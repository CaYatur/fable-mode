#!/usr/bin/env bash
# Builds dist/fable-skill.zip — the uploadable claude.ai skill package.
# Run from anywhere: bash claude-web-skill/build.sh
set -euo pipefail

here="$(cd "$(dirname "$0")" && pwd)"
repo="$(dirname "$here")"
stage="$(mktemp -d)"
dest="$stage/fable"

mkdir -p "$dest"
cp "$here/SKILL.md" "$repo/FABLE-MODE.md" "$repo/FABLE-MODE-MINI.md" "$dest/"
cp -r "$repo/FABLE-PACKS" "$dest/FABLE-PACKS"
cp -r "$repo/FABLE-EXAMPLES" "$dest/FABLE-EXAMPLES"

mkdir -p "$repo/dist"
rm -f "$repo/dist/fable-skill.zip"
if command -v zip >/dev/null 2>&1; then
  (cd "$stage" && zip -qr "$repo/dist/fable-skill.zip" fable)
else
  # Windows 10+ ships bsdtar, which writes zip format via -a
  tar -a -cf "$repo/dist/fable-skill.zip" -C "$stage" fable
fi

rm -rf "$stage"
echo "Built: $repo/dist/fable-skill.zip"
echo "Upload it at claude.ai -> Settings -> Capabilities -> Skills -> Upload skill."
