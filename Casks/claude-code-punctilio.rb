cask "claude-code-punctilio" do
  arch arm: "arm64", intel: "x64"
  os macos: "darwin", linux: "linux"

  version "2.1.203"
  sha256 arm:          "57b5aec68a35f42036bd2f82836d91c2d2990c2d589fb3465e3ee87142af9a1e",
         x86_64:       "1481cffd33d5d19219b53d832fb14e4c2c2def781fc4f1db6c5a4b2d1e596763",
         x86_64_linux: "85e4d203c5b43c67a778efd25dcc9ae1d239110c87726df5c6ac0774b576cc6c",
         arm64_linux:  "59bf43c7fc8c254a2d7a994f26d577a50f17876e4ed180cff6a1cef2f9ebe473"

  url "https://storage.googleapis.com/claude-code-dist-86c565f3-f756-42ad-8dfa-d59b1c096819/claude-code-releases/#{version}/#{os}-#{arch}/claude",
      verified: "storage.googleapis.com/claude-code-dist-86c565f3-f756-42ad-8dfa-d59b1c096819/claude-code-releases/"
  name "Claude Code"
  desc "Terminal-based AI coding assistant"
  homepage "https://www.anthropic.com/claude-code"

  livecheck do
    url "https://storage.googleapis.com/claude-code-dist-86c565f3-f756-42ad-8dfa-d59b1c096819/claude-code-releases/latest"
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

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
