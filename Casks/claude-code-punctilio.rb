cask "claude-code-punctilio" do
  arch arm: "arm64", intel: "x64"
  os macos: "darwin", linux: "linux"

  version "2.1.186"
  sha256 arm:          "463a79cc34a9787cff1b3361b4ec9e2dff928c18b077f41f0bb412e4cda78637",
         x86_64:       "9e17e23d451cbbc64cf4b9536c1d25efd86808512617c855091fa608f77c9899",
         x86_64_linux: "6a6d5d23486597c93138941c9b68caa0fbcd2dcedbf49e29a9c8d83e3a1cb329",
         arm64_linux:  "817e5ff483568b78c49171be317b9b9190cade77248a5776e912789312961cb6"

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
