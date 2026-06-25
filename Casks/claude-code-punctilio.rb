cask "claude-code-punctilio" do
  arch arm: "arm64", intel: "x64"
  os macos: "darwin", linux: "linux"

  version "2.1.191"
  sha256 arm:          "99fdfb552a5260e649aedd06c024d0a4105b09cefec0bf67d558e017ee66c400",
         x86_64:       "6e83aad5fc4fd459fd74539cda06d2279105eac2befc603d2fba6494974cb2a4",
         x86_64_linux: "1038dba88bdf1b80941dc3e383e93b088325b00497329ac50da460c8786d5bee",
         arm64_linux:  "1a31a7cbcfd784f8c073bfc8a0a1583fb6e93e60ef70b76d7fcf663ffed8949b"

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
