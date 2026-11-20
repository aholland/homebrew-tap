cask "claude-code-punctilio" do
  arch arm: "arm64", intel: "x64"
  os macos: "darwin", linux: "linux"

  version "2.1.330"
  sha256 arm:          "f7c5093b9dd6560d08af28bc27b123fb55091deae3180ac39df199522da86815",
         x86_64:       "bbed99bb8a39bb3f94389c5c99d3d02cb75f3f983b5d1bc40b1b0d1efca84713",
         arm64_linux:  "6016f90cac783e367fb1aa97c768a2efb94a0128a5b46b70fb3d8fcbbd9dd444",
         x86_64_linux: "f390eaa0814e6a1bff74cbb47acb74cb9c89d30ced809fe0af5af00c7bfe8ebb"

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
