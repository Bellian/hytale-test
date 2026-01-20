#!/usr/bin/env bash
set -euo pipefail
IFS=$'\n\t'

URL="https://downloader.hytale.com/hytale-downloader.zip"

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
ROOT_DIR="$(cd "$SCRIPT_DIR/.." && pwd)"
DEST_DIR="$ROOT_DIR/vendor/hytale-downloader"

# If the destination directory already exists and is non-empty, skip download.
if [ -d "$DEST_DIR" ] && [ "$(ls -A "$DEST_DIR" 2>/dev/null || true)" ]; then
	echo "Downloader already present at: $DEST_DIR — skipping."
	exit 0
fi

if ! command -v curl >/dev/null 2>&1 && ! command -v wget >/dev/null 2>&1; then
	echo "Error: curl or wget is required to download files." >&2
	exit 1
fi

if ! command -v unzip >/dev/null 2>&1; then
	echo "Error: unzip is required to extract the zip archive." >&2
	exit 1
fi

TMPZIP="$(mktemp --suffix=.zip)"
cleanup() { rm -f "$TMPZIP"; }
trap cleanup EXIT

echo "Downloading $URL ..."
if command -v curl >/dev/null 2>&1; then
	curl -fSL "$URL" -o "$TMPZIP"
else
	wget -qO "$TMPZIP" "$URL"
fi

mkdir -p "$DEST_DIR"
echo "Extracting to $DEST_DIR ..."
unzip -o "$TMPZIP" -d "$DEST_DIR"

echo "Making any bundled executables executable (if present) ..."
chmod +x "$DEST_DIR"/* 2>/dev/null || true

echo "Done — downloader extracted to: $DEST_DIR"

