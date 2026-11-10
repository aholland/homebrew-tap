#!/usr/bin/env bash
# Point the claude-code-punctilio cask at a Claude Code release.
#
# Usage: tools/update-cask.sh <version>
#
# Trust comes from Anthropic's signed release manifest, not from this tap:
# each release folder holds a manifest.json listing the SHA-256 of every
# platform binary, and a manifest.json.sig made with Anthropic's release
# signing key. This script checks that signature against the copy of the key
# pinned in keys/claude-code.asc, downloads each binary to confirm it matches
# the manifest's checksum, then writes those checksums into the cask. brew
# checks every download against them again at install time.
#
# Any failed check stops the script with an error. It never downgrades.
set -euo pipefail

VERSION="${1:?usage: update-cask.sh <version>}"
CASK="Casks/claude-code-punctilio.rb"
KEY="keys/claude-code.asc"
# Published at https://code.claude.com/docs/en/setup ("Binary integrity and
# code signing"). If Anthropic replaces the key, this check fails until the
# new key and fingerprint are pinned here by hand.
KEY_FINGERPRINT="31DDDE24DDFAB679F42D7BD2BAA929FF1A7ECACE"
RELEASES="https://downloads.claude.ai/claude-code-releases"

die() { echo "ERROR: $*" >&2; exit 1; }

[[ "$VERSION" =~ ^[0-9]+\.[0-9]+\.[0-9]+$ ]] || die "'$VERSION' is not a version number"

CURRENT="$(sed -n 's/^  version "\(.*\)"$/\1/p' "$CASK")"
[[ -n "$CURRENT" ]] || die "could not read the current version from $CASK"
if [[ "$VERSION" == "$CURRENT" ]]; then
  echo "Cask is already at $CURRENT"
  exit 0
fi
NEWEST="$(printf '%s\n%s\n' "$CURRENT" "$VERSION" | sort -V | tail -n 1)"
[[ "$NEWEST" == "$VERSION" ]] || die "$VERSION is older than the cask's $CURRENT"

WORK="$(mktemp -d)"
trap 'rm -rf "$WORK"' EXIT

# 1. The pinned key is the key we expect.
PINNED="$(GNUPGHOME="$WORK" gpg --show-keys --with-colons "$KEY" 2>/dev/null |
  awk -F: '$1 == "fpr" { print $10; exit }')"
[[ "$PINNED" == "$KEY_FINGERPRINT" ]] ||
  die "$KEY has fingerprint '$PINNED', expected $KEY_FINGERPRINT"
GNUPGHOME="$WORK" gpg --dearmor <"$KEY" >"$WORK/key.gpg" 2>/dev/null

# 2. The manifest is signed by that key.
curl -fsSL "$RELEASES/$VERSION/manifest.json" -o "$WORK/manifest.json" ||
  die "no manifest.json for $VERSION"
curl -fsSL "$RELEASES/$VERSION/manifest.json.sig" -o "$WORK/manifest.json.sig" ||
  die "no manifest.json.sig for $VERSION"
gpgv --keyring "$WORK/key.gpg" "$WORK/manifest.json.sig" "$WORK/manifest.json" ||
  die "manifest.json for $VERSION is not signed by Anthropic's release key"

# 3. The manifest is for this version, and every binary it lists is published
#    and has the checksum the manifest gives.
MANIFEST_VERSION="$(jq -r '.version' "$WORK/manifest.json")"
[[ "$MANIFEST_VERSION" == "$VERSION" ]] ||
  die "manifest.json says version '$MANIFEST_VERSION', expected $VERSION"

sha256_of_stdin() {
  if command -v sha256sum >/dev/null; then sha256sum; else shasum -a 256; fi | cut -d' ' -f1
}
checksum_for() {
  local platform="$1" expected actual
  expected="$(jq -r --arg p "$platform" '.platforms[$p].checksum' "$WORK/manifest.json")"
  [[ "$expected" =~ ^[a-f0-9]{64}$ ]] || die "manifest has no SHA-256 for $platform"
  actual="$(curl -fsSL "$RELEASES/$VERSION/$platform/claude" | sha256_of_stdin)" ||
    die "could not download the $platform binary for $VERSION"
  [[ "$actual" == "$expected" ]] ||
    die "the $platform binary has SHA-256 $actual, manifest says $expected"
  echo "Checked $platform" >&2
  echo "$expected"
}
SHA_ARM="$(checksum_for darwin-arm64)"
SHA_X86_64="$(checksum_for darwin-x64)"
SHA_ARM64_LINUX="$(checksum_for linux-arm64)"
SHA_X86_64_LINUX="$(checksum_for linux-x64)"
export VERSION SHA_ARM SHA_X86_64 SHA_ARM64_LINUX SHA_X86_64_LINUX

# 4. Write them into the cask, and confirm every value landed.
perl -pi -e '
  s/^(  version ")[^"]*"/$1$ENV{VERSION}"/;
  s/(\barm:\s+")[a-f0-9]{64}/$1$ENV{SHA_ARM}/;
  s/(\bx86_64:\s+")[a-f0-9]{64}/$1$ENV{SHA_X86_64}/;
  s/(\barm64_linux:\s+")[a-f0-9]{64}/$1$ENV{SHA_ARM64_LINUX}/;
  s/(\bx86_64_linux:\s+")[a-f0-9]{64}/$1$ENV{SHA_X86_64_LINUX}/;
' "$CASK"
for value in "version \"$VERSION\"" "$SHA_ARM" "$SHA_X86_64" "$SHA_ARM64_LINUX" "$SHA_X86_64_LINUX"; do
  grep -qF "$value" "$CASK" || die "$CASK was not updated with: $value"
done

echo "Cask updated: $CURRENT -> $VERSION"
