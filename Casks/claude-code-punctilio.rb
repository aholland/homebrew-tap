cask "claude-code-punctilio" do
  arch arm: "arm64", intel: "x64"
  os macos: "darwin", linux: "linux"

  version "2.1.177"
  sha256 arm:          "eb0730351be2f02b482b1855870f5877489085aac86b0c4c1db4e458d9e40ed9",
         x86_64:       "fcdc6c6679d4e1e3a0a3812f24e8b08ab73156732072c2ca5ee6248bee8313bd",
         x86_64_linux: "ff41753634b20c869ef6a32a20863521b33d4186ac0d6a49379ab48a48395ee7",
         arm64_linux:  "baf3926dc166215772f959e367da9784ff4c75157aaafe4524fdc79ebff984b1"

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
