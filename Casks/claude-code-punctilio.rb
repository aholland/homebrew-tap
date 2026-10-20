cask "claude-code-punctilio" do
  arch arm: "arm64", intel: "x64"
  os macos: "darwin", linux: "linux"

  version "2.1.305"
  sha256 arm:          "ea3ea3c08d2a9634a4651e687fcf900d410c489bce2b00f22bd7352b91ba704f",
         x86_64:       "af7ad8d6d8b1e49059988f6657d91bb8b9feac127bf8bec005c4c27d0093f153",
         x86_64_linux: "86cb722ab68348877dba7971e4d0c659919e05e6228c05e006e83da320e656ef",
         arm64_linux:  "5265a60217e667b75e126e887b49ac0f168ad8bb13c605c3e3df528519876dc0"

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
