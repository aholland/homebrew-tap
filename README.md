# aholland/homebrew-tap

## claude-code-punctilio

Claude Code from Anthropic's own release files, published here within a few minutes of Anthropic uploading each release. That is usually before the release reaches npm, and hours before it reaches Homebrew's own `claude-code@latest` cask.

```
brew install --cask aholland/tap/claude-code-punctilio
```

It installs the same binary as Homebrew's official casks, straight from Anthropic's servers. If you have one of those installed, uninstall it first: all three provide the `claude` command.

### This is earlier than "latest"

Anthropic uploads a release, publishes it to npm a few minutes later, and only some time after that marks it as "latest": anything from half an hour to most of a day. Homebrew's `claude-code@latest` follows that last step. This cask follows the first. So you get each build before Anthropic has promoted it, including the rare build it decides not to promote. If you would rather wait for Anthropic's say-so, use `claude-code@latest`.

### How a release gets here

1. A small Cloudflare Worker ([`watcher/worker.js`](watcher/worker.js)) checks Anthropic's release server once a minute for the next version numbers.
2. When one appears, it starts this repository's [update workflow](.github/workflows/update-claude-code-punctilio.yml).
3. The workflow ([`tools/update-cask.sh`](tools/update-cask.sh)) downloads the release's `manifest.json`, which lists the SHA-256 of every platform's binary, and checks its signature against [Anthropic's release signing key](https://code.claude.com/docs/en/setup#binary-integrity-and-code-signing), a copy of which is pinned in [`keys/`](keys/claude-code.asc). Only then does it write those checksums into the cask.
4. `brew` checks your download against those checksums when it installs.

Nothing is rebuilt or re-hosted. This tap only says where Anthropic's file is and what its checksum must be.

### Getting told about updates

Claude Code's built-in "update available" notice cannot see this tap, so on this cask it stays quiet. To get a notice in your status line instead, give Claude Code this:

```
Please add the claude-code-punctilio update notice to my status line, following https://raw.githubusercontent.com/aholland/homebrew-tap/notice-v1/UPDATE-NOTICE.md. It should only add one helper script under ~/.claude and a call to it from my status line. Show me the changes before you make them.
```

The page it points to is [`UPDATE-NOTICE.md`](UPDATE-NOTICE.md), fixed at the `notice-v1` tag so it cannot change underneath you. It is short enough to read first, and you can ask your Claude Code whether it looks safe.

If you have set `CLAUDE_CODE_PACKAGE_MANAGER_AUTO_UPDATE=1`, the notice also runs the upgrade for you in the background, the same as Claude Code does for Homebrew's own casks. Either way a new version takes effect when you restart Claude Code.

### Uninstalling

```
brew uninstall --cask claude-code-punctilio
```

Use a plain `uninstall`, not `--zap`: the zap stanza removes `~/.claude`, which holds your settings and session history.
