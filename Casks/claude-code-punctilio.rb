cask "claude-code-punctilio" do
  arch arm: "arm64", intel: "x64"
  os macos: "darwin", linux: "linux"

  version "2.1.284"
  sha256 arm:          "50a14c2f50f56668380fdda490167f1d3630d5cc18fb8aed3073c2c7ea7314fe",
         x86_64:       "79441b868935a11ed0630b2ee59327eda9f6a93bb8d470bd6633c03df76d2135",
         x86_64_linux: "5cd90aabd83f8a15136c35aa37bb1d92b348993573316643dc3fe4e04afbf88f",
         arm64_linux:  "3dd0f96d7ada463152d20300186f6cfc6ab94b57e218f49e3ac86db42ac695a6"

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
