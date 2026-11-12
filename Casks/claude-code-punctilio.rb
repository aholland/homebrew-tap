cask "claude-code-punctilio" do
  arch arm: "arm64", intel: "x64"
  os macos: "darwin", linux: "linux"

  version "2.1.323"
  sha256 arm:          "5432918d904a9b6afef7bb79d20df24d76052eabc1f41bceb84091d21f8889a7",
         x86_64:       "d68f8e14d65a1784391775cc1aadaf0f217ae5155813a9f91526e846018a25c4",
         arm64_linux:  "452dddff140b5caf00a5410333a3d6db82c73ea2dec74b1541fae18e97d47dca",
         x86_64_linux: "604d29a6869409106b6a1110bdadcc8b72e8654a5a865d23258f938a696e348e"

  url "https://downloads.claude.ai/claude-code-releases/#{version}/#{os}-#{arch}/claude"
  name "Claude Code"
  desc "Terminal-based AI coding assistant"
  homepage "https://claude.com/product/claude-code"

  # This tap publishes each release as soon as Anthropic uploads it, which is
  # before the "latest" pointer moves, so livecheck would always look behind.
  livecheck do
    skip "Updated by this tap's own watcher"
  end

  conflicts_with cask: [
    "claude-code",
    "claude-code@latest",
  ]

  binary "claude"

  zap trash: [
    "~/.cache/claude",
    "~/.claude",
    "~/.claude.json*",
    "~/.config/claude",
    "~/.local/bin/claude",
    "~/.local/share/claude",
    "~/.local/state/claude",
    "~/Library/Caches/claude-cli-nodejs",
  ]
end
