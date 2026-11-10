# aholland/homebrew-tap

## claude-code-punctilio

If Claude Code has ever told you about an update that Homebrew didn't have yet, or you simply don't like being several hours behind every release, this is for you. It is Claude Code from Anthropic's own release files, published here within a few minutes of Anthropic uploading each release.

### Install

You probably already have Claude Code installed through Homebrew. If so, uninstall that first, because both provide the `claude` command:

```
brew uninstall --cask claude-code
```

(or `claude-code@latest`, if that is the one you have). Use a plain `uninstall`, not `--zap`: zap deletes Claude Code's settings and session history.

Then:

```
brew install --cask aholland/tap/claude-code-punctilio
```

It installs the same binary as Homebrew's own casks, straight from Anthropic's servers.

### Get told about updates

Claude Code's built-in "update available" notice cannot see this tap, so on this cask it stays quiet. To get a notice in your status line instead, give Claude Code this:

```
Please add the claude-code-punctilio update notice to my status line, following
https://raw.githubusercontent.com/aholland/homebrew-tap/main/UPDATE-NOTICE.md
It should only add one helper script under ~/.claude and a call to it from my status line.
Show me the changes before you make them.
```

The page it points to is [`UPDATE-NOTICE.md`](UPDATE-NOTICE.md). It is short enough to read first, and you can ask your Claude Code whether it looks safe.

Claude Code can upgrade itself through Homebrew in the background if you ask it to, as described under [Auto-updates](https://code.claude.com/docs/en/setup#auto-updates) in Anthropic's setup guide: you set `CLAUDE_CODE_PACKAGE_MANAGER_AUTO_UPDATE=1`. If you have done that, the notice runs the upgrade for you too, the same as Claude Code does for Homebrew's own casks. Either way a new version takes effect when you restart Claude Code.

### This is earlier than "latest"

Anthropic uploads a release, publishes it to npm a few minutes later, and only some time after that marks it as "latest": anything from half an hour to most of a day. Homebrew's `claude-code@latest` follows that last step, and then takes an hour or two of its own. This cask follows the first step. So you get each build before Anthropic has promoted it, including the rare build it decides not to promote. If you would rather wait for Anthropic's say-so, use `claude-code@latest`.

### Uninstalling

```
brew uninstall --cask claude-code-punctilio
```

Use a plain `uninstall`, not `--zap`: the zap stanza removes `~/.claude`, which holds your settings and session history.

### How a release gets here

1. A small Cloudflare Worker ([`watcher/worker.js`](watcher/worker.js)) checks Anthropic's release server once a minute for the next version numbers.
2. When one appears, it starts this repository's [update workflow](.github/workflows/update-claude-code-punctilio.yml).
3. The workflow ([`tools/update-cask.sh`](tools/update-cask.sh)) downloads the release's `manifest.json`, which lists the SHA-256 of every platform's binary, and checks its signature against [Anthropic's release signing key](https://code.claude.com/docs/en/setup#binary-integrity-and-code-signing), a copy of which is pinned in [`keys/`](keys/claude-code.asc). It then downloads each binary and confirms it matches. Only then does it write those checksums into the cask.
4. `brew` checks your download against those checksums again when it installs.

Nothing is rebuilt or re-hosted. This tap only says where Anthropic's file is and what its checksum must be.
