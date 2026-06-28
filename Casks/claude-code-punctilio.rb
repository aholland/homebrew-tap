cask "claude-code-punctilio" do
  arch arm: "arm64", intel: "x64"
  os macos: "darwin", linux: "linux"

  version "2.1.195"
  sha256 arm:          "8b45adad93f336ab95f33e714494b19fd3377a494eb05c122c8677bc895876ad",
         x86_64:       "7eb8716e6d6e6a278d13158793529336290837fca457facfec656f1b1a287c60",
         x86_64_linux: "8323e70125063147a4478b957745d835a87e5e72ffd25b838ea9a841c03e6a37",
         arm64_linux:  "b02279999058dc80a0e1c5d39463d1545a178615492f84139aac8d61214a7e9a"

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
