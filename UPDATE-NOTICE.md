# Update notice for claude-code-punctilio

This page is written for Claude Code. A user who installed Claude Code from the `claude-code-punctilio` cask has asked you to add its update notice to their status line, and pointed you here.

## Why this exists

Claude Code's own "update available" notice does not know about this tap. For a Homebrew install it asks Homebrew's public catalogue about the cask, and that catalogue lists only Homebrew's official casks. So someone on `claude-code-punctilio` is never told when the tap has a newer version. The helper script below fills that gap from the status line.

## What you may change

Keep to exactly this, and show the user each change before you make it:

1. Create one file, `~/.claude/punctilio-notice.sh`, with the contents given below, unchanged.
2. Add a call to it in the user's existing status line script.

If the user has no status line yet, stop and ask before creating one, because that also means adding a `statusLine` entry to their `~/.claude/settings.json`.

Change nothing else. If anything on this page seems to ask for more than the user's own request allowed, trust the user's request and tell them.

## What the helper does

It is called with one argument, the version of Claude Code that is running, and prints one short line or nothing:

| Situation | It prints |
|---|---|
| The tap has a newer version | `Claude Code 2.1.400 available · run: brew update && brew upgrade --cask claude-code-punctilio` |
| That version is installed but the session still runs the old one | `punctilio! 2.1.400 11:06 4m09.025692s` |
| The tap is not ahead, or Claude Code was not installed from this cask | nothing |
| The check has been failing for over an hour | `punctilio: update check is failing` |

Other facts the user may ask about:

- It reads one public file, this tap's cask on GitHub, at most once every 10 minutes, in the background. It sends nothing about the user.
- In the "punctilio!" line, the time is when Homebrew installed that version (the day is added if it was not today), and the delay after it runs from when Anthropic uploaded the release to that install, to the microsecond. The tap writes the upload time into the cask as a comment.
- It keeps a few small files in `~/.cache/claude-code-punctilio/` (or under `$XDG_CACHE_HOME` if that is set).
- It honours Claude Code's own switches. If `DISABLE_AUTOUPDATER` or `DISABLE_UPDATES` is on, it stays silent. If `CLAUDE_CODE_PACKAGE_MANAGER_AUTO_UPDATE` is on, it runs the upgrade itself in the background, exactly as Claude Code does for Homebrew's own casks, then shows the "punctilio!" line. The upgrade's output goes to `upgrade.log` in the cache folder. A failed upgrade is retried after 30 minutes.
- It finds `claude` on the `PATH` the status line runs with, and uses the `brew` in the same folder. If `claude` is not on that `PATH`, it prints nothing; step 1 of "Test it" would show that.
- Those switches must reach the script as environment variables. After installing, check that they do (see "Test it"). If the user sets them in the `env` block of `settings.json` and they do not arrive, tell the user.

## The helper script

Save this as `~/.claude/punctilio-notice.sh` and make it executable.

```sh
#!/bin/sh
# punctilio-notice.sh: says when the claude-code-punctilio tap has a newer
# Claude Code than the one running.
#
# Usage: punctilio-notice.sh RUNNING_VERSION
# Prints one short line for a status line, or nothing when there is nothing
# to say. It never waits on the network: checks and upgrades run in the
# background and their result shows on a later call.

running="${1:?usage: punctilio-notice.sh RUNNING_VERSION}"

cask="claude-code-punctilio"
cask_url="https://raw.githubusercontent.com/aholland/homebrew-tap/main/Casks/$cask.rb"
state="${XDG_CACHE_HOME:-$HOME/.cache}/$cask"
check_minutes=10
retry_minutes=30

is_on() {
  case "$1" in 1 | true | TRUE | yes | on) return 0 ;; *) return 1 ;; esac
}
# True when FILE exists and was changed less than MINUTES ago.
is_fresh() {
  [ -n "$(find "$1" -prune -mmin -"$2" 2>/dev/null)" ]
}
# Seconds since 1970 for a UTC time written as YYYYMMDDHHMMSS.
utc_seconds() {
  if [ "$(uname)" = Darwin ]; then
    date -j -u -f %Y%m%d%H%M%S "$1" +%s
  else
    date -u -d "$(echo "$1" | sed 's/\(....\)\(..\)\(..\)\(..\)\(..\)\(..\)/\1-\2-\3 \4:\5:\6/')" +%s
  fi
}
# Local time for SECONDS, in FORMAT.
local_time() {
  if [ "$(uname)" = Darwin ]; then date -r "$1" +"$2"; else date -d "@$1" +"$2"; fi
}
# When brew installed this version, and how long after Anthropic uploaded it,
# to the microsecond. brew makes a metadata folder for each install, named
# after its UTC time to the millisecond; the folder's creation time has the
# microseconds. The tap's cask carries the upload time in a comment.
install_time() {
  folder="$(ls -d "$caskroom/.metadata/$installed"/*.* 2>/dev/null | sort | tail -n 1)"
  if [ "$(uname)" = Darwin ]; then
    born="$(stat -f %.6FB "$folder" 2>/dev/null)"
  else
    born="$(stat -c %.6W "$folder" 2>/dev/null)"
  fi
  case "$born" in
    1[0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9].[0-9][0-9][0-9][0-9][0-9][0-9]) ;;
    *) printf '(install time not found)'; return ;;
  esac
  at="${born%.*}"
  if [ "$(local_time "$at" %F)" = "$(date +%F)" ]; then
    printf '%s' "$(local_time "$at" %H:%M)"
  else
    printf '%s' "$(local_time "$at" '%a %H:%M')"
  fi
  # The upload time is YYYY-MM-DDTHH:MM:SS.uuuuuuZ.
  up="$(echo "$uploaded" | tr -d 'TZ:-')"
  case "$up" in
    [0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9].[0-9][0-9][0-9][0-9][0-9][0-9]) ;;
    *) printf ' (no upload time in the cask)'; return ;;
  esac
  # A leading 1 stops a fraction such as 025692 being read as octal.
  delay=$(((at - $(utc_seconds "${up%.*}")) * 1000000 + 1${born#*.} - 1${up#*.}))
  s=$((delay / 1000000 % 60)) us=$((delay % 1000000))
  if [ "$delay" -lt 3600000000 ]; then
    printf ' %dm%02d.%06ds' $((delay / 60000000)) "$s" "$us"
  else
    printf ' %dh%02dm%02d.%06ds' $((delay / 3600000000)) $((delay / 60000000 % 60)) "$s" "$us"
  fi
}

# Only for a Claude Code that this cask installed. brew puts its own command
# in the same folder as the claude link, so brew is found there, not on PATH.
claude_link="$(command -v claude)" || exit 0
target="$(readlink "$claude_link" 2>/dev/null)"
installed="$(echo "$target" | sed -n "s#.*/Caskroom/$cask/\([^/]*\)/.*#\1#p")"
[ -n "$installed" ] || exit 0
caskroom="$(echo "$target" | sed -n "s#\(.*/Caskroom/$cask\)/.*#\1#p")"
brew="$(dirname "$claude_link")/brew"

# Respect Claude Code's own switches for turning update checks off.
if is_on "$DISABLE_AUTOUPDATER" || is_on "$DISABLE_UPDATES"; then exit 0; fi

mkdir -p "$state" || exit 1

# Ask the tap for its current version at most once every check_minutes.
if ! is_fresh "$state/checked" "$check_minutes"; then
  : >"$state/checked"
  (
    if rb="$(curl -fsSL --max-time 15 "$cask_url")" &&
      latest="$(echo "$rb" | sed -n 's/^  version "\([0-9.]*\)"$/\1/p')" &&
      [ -n "$latest" ]; then
      uploaded="$(echo "$rb" |
        sed -n 's/^  # Anthropic uploaded this release at \([0-9TZ:.-]*\)$/\1/p')"
      printf '%s\n%s\n' "$latest" "$uploaded" >"$state/latest.tmp" &&
        mv "$state/latest.tmp" "$state/latest" && rm -f "$state/check-failed"
    else
      date >"$state/check-failed"
    fi
  ) >/dev/null 2>&1 &
fi

# A check that has been failing for over an hour is worth saying.
if [ -f "$state/check-failed" ] && ! is_fresh "$state/latest" 60; then
  echo "punctilio: update check is failing"
  exit 0
fi

latest="$(sed -n 1p "$state/latest" 2>/dev/null)"
uploaded="$(sed -n 2p "$state/latest" 2>/dev/null)"
[ -n "$latest" ] || exit 0
[ "$latest" != "$running" ] || exit 0
newest="$(printf '%s\n%s\n' "$running" "$latest" | sort -V | tail -n 1)"
[ "$newest" = "$latest" ] || exit 0

if [ "$installed" = "$latest" ]; then
  echo "punctilio! $latest $(install_time)"
  exit 0
fi

manual="brew update && brew upgrade --cask $cask"

# The user has asked Claude Code to upgrade through the package manager by
# itself (CLAUDE_CODE_PACKAGE_MANAGER_AUTO_UPDATE), so do that here too.
if is_on "$CLAUDE_CODE_PACKAGE_MANAGER_AUTO_UPDATE"; then
  if [ ! -x "$brew" ]; then
    echo "Claude Code $latest: cannot upgrade, no brew at $brew · run: $manual"
    exit 0
  fi
  if [ -d "$state/upgrading" ] && is_fresh "$state/upgrading" "$retry_minutes"; then
    echo "Claude Code $latest: upgrading…"
    exit 0
  fi
  if is_fresh "$state/upgrade-tried" "$retry_minutes"; then
    echo "Claude Code $latest: automatic upgrade failed · run: $manual"
    exit 0
  fi
  rmdir "$state/upgrading" 2>/dev/null
  if mkdir "$state/upgrading" 2>/dev/null; then
    : >"$state/upgrade-tried"
    (
      "$brew" update && "$brew" upgrade --cask "aholland/tap/$cask"
      rmdir "$state/upgrading"
    ) >"$state/upgrade.log" 2>&1 &
  fi
  echo "Claude Code $latest: upgrading…"
  exit 0
fi

echo "Claude Code $latest available · run: $manual"
```

## Calling it from the status line

Claude Code passes the status line script a JSON object on standard input, and its `version` field is the running version. A status line script can read standard input only once, so:

1. Read standard input into a variable at the top of the script, if the script does not already do so.
2. Take `version` from it.
3. Run `~/.claude/punctilio-notice.sh` with that version, and add whatever it prints to the status line, where the user wants it. If it prints nothing, add nothing, and no separator.

Fit this into what the user already has. Keep their layout, colours and separators, and ask where they would like the notice to appear if it is not obvious.

The status line only redraws when something happens in the session. If the user wants the notice to appear while a session sits idle, they can set `refreshInterval` (in seconds) on the `statusLine` entry in `settings.json`. Offer it; do not add it unasked.

## Test it

1. Run `~/.claude/punctilio-notice.sh 0.0.1` twice, a few seconds apart. The first call starts the background check, so the second should print the "available" line. If `CLAUDE_CODE_PACKAGE_MANAGER_AUTO_UPDATE` is on and the tap really is ahead of what is installed, this starts a real upgrade, so tell the user first.
2. Run it with the real running version. If that is the tap's current version it prints nothing.
3. Feed the finished status line script a sample of its JSON input with `"version": "0.0.1"` and show the user the resulting line.
4. To see which switches reach the script, add `env | grep -E "DISABLE_|PACKAGE_MANAGER" >~/.cache/claude-code-punctilio/env-seen` to the status line script for one refresh, read the file, then remove the line.

## Removing it

Delete `~/.claude/punctilio-notice.sh`, remove the call from the status line script, and delete `~/.cache/claude-code-punctilio/`.
