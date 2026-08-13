cask "claude-code-punctilio" do
  arch arm: "arm64", intel: "x64"
  os macos: "darwin", linux: "linux"

  version "2.1.231"
  sha256 arm:          "ba790279cab6ef77b713864d4bf5f764fcea87d3a3eb7591a41f741e45212b5c",
         x86_64:       "7c7c6179f55c985409af4c31603d19b9b64af4759d016f86b99bfbdb29042a90",
         x86_64_linux: "47a01daebf794f6c86c13d1875ad6e5be0627029ad8600731161f24018ecde5b",
         arm64_linux:  "4ee7c484b11dece6521aa2173a19ea913428c1c78599186d62559d2d2aef4e32"

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
