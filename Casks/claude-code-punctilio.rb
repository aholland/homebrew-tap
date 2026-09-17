cask "claude-code-punctilio" do
  arch arm: "arm64", intel: "x64"
  os macos: "darwin", linux: "linux"

  version "2.1.274"
  sha256 arm:          "3509913f9d1576316c8845b88837f8fd3bbbcf26625833ac82cfb6b8985da94a",
         x86_64:       "b18e8c9d7666d8987a174ac65e0019f4ba6befa73d2f75c05cbe92e5093431eb",
         x86_64_linux: "15e2d05148f801b5774032faad87e624ecd172e9903288bda448b892eb58fa07",
         arm64_linux:  "2db904daea17addff9de557ba26a725916888aa7b546e2c5dd989c20d9d49ab3"

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
