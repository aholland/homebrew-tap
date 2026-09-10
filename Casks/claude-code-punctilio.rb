cask "claude-code-punctilio" do
  arch arm: "arm64", intel: "x64"
  os macos: "darwin", linux: "linux"

  version "2.1.267"
  sha256 arm:          "a681f3008f0050029aeebcab3af51bb6a55ddeb625a3af3141a4416d43cd2558",
         x86_64:       "071988cb2e5a4378d8543d78e0ff5f8ed1ecc5e113271774a0582ee74fb0ef79",
         x86_64_linux: "0399c793ff571d5946ef923d80b4f330d05ac4b6842a6b0775468f5d389403c0",
         arm64_linux:  "226a4e009574044a18bf5495f127806b2a1bfcbf25b3c01608705fafee95fefb"

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
