cask "claude-code-punctilio" do
  arch arm: "arm64", intel: "x64"
  os macos: "darwin", linux: "linux"

  version "2.1.199"
  sha256 arm:          "e3cb61abc8a2ec7b98976cee1ffdde5a3fa755c9990bc8d688cd89290e0dcec0",
         x86_64:       "e64853ff3bc2ae6ed8115581c851e1176762d445d0b8b9e0dd37d0d560224a88",
         x86_64_linux: "b31dfd5e3dee23b51c42e0d8ddb405148978237d3aabc8cbbf77c5cf83367e27",
         arm64_linux:  "14851b5170b154b01baca09bba970172e70cdd768b5a012bf347ba0f594b4ad3"

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
