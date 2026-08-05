cask "claude-code-punctilio" do
  arch arm: "arm64", intel: "x64"
  os macos: "darwin", linux: "linux"

  version "2.1.222"
  sha256 arm:          "c66a6cc6fa2e8145bb1a6e77831f2caf4b83690ff04650500dfa6e2c05ca997c",
         x86_64:       "36bfc6482a25730dbb1cee72589e522c66c45a4dc9ebfdd8a76a8113b01b6188",
         x86_64_linux: "10caae8f22b915c26bfff0e013a4d45608c4f1ae287583626569156f447730e5",
         arm64_linux:  "a04be0a8d7fe0259571ab7411d51d85658d71a4a26ce62b60c908290372e6016"

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
