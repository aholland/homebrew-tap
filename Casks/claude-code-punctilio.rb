cask "claude-code-punctilio" do
  arch arm: "arm64", intel: "x64"
  os macos: "darwin", linux: "linux"

  version "2.1.235"
  sha256 arm:          "83b8f806f6f2eea316cfe246628e6c23374711d868f1fd0409db551b877b7748",
         x86_64:       "325a2dbc166ba8361a913ce588dce4a236789502060239acea52072bb51a54f1",
         x86_64_linux: "bfcf0ae2dbf94b2b6a106074aabf3938b9a10889c3b678e4cb5a00c03274d5d5",
         arm64_linux:  "cff9592faa292db0f6ac21874f151b8c3d44e23bf0ab9fd1bcca95edc3469549"

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
