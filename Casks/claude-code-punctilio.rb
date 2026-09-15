cask "claude-code-punctilio" do
  arch arm: "arm64", intel: "x64"
  os macos: "darwin", linux: "linux"

  version "2.1.273"
  sha256 arm:          "953e9880dbcb0b70f31c1f508de6a3fd389753d131688557fd992da9184693fb",
         x86_64:       "2030ecf911e301e778b3c5a49068d6751384c830e48ea14f11eb61dd23622cee",
         x86_64_linux: "6c752e2cc7c110c9df15f26d8d134d438c5ae95dbd610efc1a308bf7f9c5f6c1",
         arm64_linux:  "103cfab4d6ae898b6af692336fb662ffcc607075cc6408892bd350b3f549ebee"

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
