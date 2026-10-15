cask "claude-code-punctilio" do
  arch arm: "arm64", intel: "x64"
  os macos: "darwin", linux: "linux"

  version "2.1.300"
  sha256 arm:          "475517caa611e3318a2f298fa071287ec98955538df78c58f709ecc01e5ae2d3",
         x86_64:       "5824fc36863e70bbd070491bb9359e217d3f17b38c45697c085b31a3a67356b3",
         x86_64_linux: "674deba0bba9aee479f4503c438b49303b6fdd304b9a471b14977aaec5215453",
         arm64_linux:  "ae2295ae2da156936bf5831ab01971ce924d0c9a0af174e28d96fffa8d5fa0a6"

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
