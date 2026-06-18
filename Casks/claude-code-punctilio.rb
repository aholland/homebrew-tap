cask "claude-code-punctilio" do
  arch arm: "arm64", intel: "x64"
  os macos: "darwin", linux: "linux"

  version "2.1.181"
  sha256 arm:          "c4d833b04606cef9b6eab3ad255ed2e1448f87dea2bc00ff5acf77b57df6e94d",
         x86_64:       "353798bcdc49a52a666645370e1c48a84fe837d93bf9d954c19338dca7260ddd",
         x86_64_linux: "35ffd4e9d9a86395d0ba4e05f8b23bf098bfeab95e97deacd6537909d1324e9c",
         arm64_linux:  "1393f993533e08d5c96245504750a7fcfe37490a5f44eec35b0beac3d709dab9"

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
