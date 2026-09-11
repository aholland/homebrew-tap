cask "claude-code-punctilio" do
  arch arm: "arm64", intel: "x64"
  os macos: "darwin", linux: "linux"

  version "2.1.268"
  sha256 arm:          "06a96d5423f83770f120859f1c58e60d7252cc4c122aa13043b7e7cd716bc76a",
         x86_64:       "f94c0d5ab0ab79f28e8dc9129ae7c980c2c1af65f3ea67ee6e9256bed3da67e9",
         x86_64_linux: "9691a2b7bd796712ca8cffb8e32e54ff7fc45b662540233171a16a94a0425653",
         arm64_linux:  "116fd031f939ef1e09edf170d62c489e1cc28ed6bfbda49f948773ba168c8f62"

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
