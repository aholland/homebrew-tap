# aholland/homebrew-tap

## claude-code-punctilio is paused (disabled 5 November 2026)

This tap's `claude-code-punctilio` cask is **disabled**. Please use Homebrew's own cask instead, which tracks the same "latest" release channel of Claude Code and is updated by Homebrew within a few hours of each release:

```
brew uninstall --cask claude-code-punctilio
brew install --cask claude-code@latest
```

Use a plain `uninstall`, not `--zap`: this cask's zap stanza removes `~/.claude`, which holds your settings and session history.

The cask existed because, in early 2026, Homebrew's `claude-code` cask lagged well behind Anthropic's releases. `claude-code@latest` now closes that gap. The cask may come back if I finish the original idea, which was to publish a new version the moment Anthropic releases it, ahead of Homebrew's own update; until then it stays disabled rather than deleted.
