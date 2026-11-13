cask "claude-code-punctilio" do
  arch arm: "arm64", intel: "x64"
  os macos: "darwin", linux: "linux"

  version "2.1.324"
  sha256 arm:          "4f91ea2cc07280b01768fc581fdb9209420e040aed1765120ff8a01daa7c0a74",
         x86_64:       "b02d5345916f2c8ec78ef05084c8904c40445d8c46ab1a9518b6c29f92e1b54c",
         arm64_linux:  "dafaf839aba19d081f7a7c69ef0fd0570528f1493a5f3d532cfb6b939ce97f3e",
         x86_64_linux: "bf6a59f62a3116d673260b6098cf35898cfdf336e677d73c3416fdb51f03c2f7"

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
