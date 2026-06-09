cask "claude-code-punctilio" do
  arch arm: "arm64", intel: "x64"
  os macos: "darwin", linux: "linux"

  version "2.1.169"
  sha256 arm:          "86d8b820ad7eed50e50a130706d3dc5ef70696f91194de1b3897a842182afe3a",
         x86_64:       "6d8d510c715b899307b7d29a1062d43e62c99370c55330dac3ec1851a2fbf7c8",
         x86_64_linux: "cf066bf360cbf7b51abeb8cb230012fc0f2fed4253b2ce305de48ccd6d49a39c",
         arm64_linux:  "341072395844b2b6d2846d8d61d551752b12a44433c920d0cc7fe6e7b5692a9b"

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
