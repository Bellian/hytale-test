#!/usr/bin/env bash
set -euo pipefail

# This script implements the steps described in the original comments.
# It is safe to run from any working directory — paths are resolved relative
# to the location of this script.

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
ROOT_DIR="$(cd "$SCRIPT_DIR/.." && pwd)"

log() { printf "[setup] %s\n" "$*"; }

INSTALL_SCRIPT="$ROOT_DIR/scripts/install-downloader.sh"
if [[ -f "$INSTALL_SCRIPT" ]]; then
	if [[ ! -x "$INSTALL_SCRIPT" ]]; then
		log "Making install script executable"
		chmod +x "$INSTALL_SCRIPT"
	fi
	log "Running install-downloader.sh"
	"$INSTALL_SCRIPT"
else
	echo "Error: $INSTALL_SCRIPT not found" >&2
	exit 1
fi

DOWNLOADER_DIR="$ROOT_DIR/vendor/hytale-downloader"
DOWNLOADER_BIN="$DOWNLOADER_DIR/hytale-downloader-linux-amd64"

if [[ ! -d "$DOWNLOADER_DIR" ]]; then
	echo "Error: downloader directory not found: $DOWNLOADER_DIR" >&2
	exit 1
fi

if [[ ! -f "$DOWNLOADER_BIN" ]]; then
	echo "Error: downloader binary not found: $DOWNLOADER_BIN" >&2
	exit 1
fi

if [[ ! -x "$DOWNLOADER_BIN" ]]; then
	log "Making downloader binary executable"
	chmod +x "$DOWNLOADER_BIN"
fi

log "Running downloader to produce ../server.zip (working dir: $DOWNLOADER_DIR)"
pushd "$DOWNLOADER_DIR" > /dev/null
./hytale-downloader-linux-amd64 -download-path ../server.zip
popd > /dev/null

EXTRACT_SCRIPT="$ROOT_DIR/scripts/extract-server.sh"
if [[ -f "$EXTRACT_SCRIPT" ]]; then
	if [[ ! -x "$EXTRACT_SCRIPT" ]]; then
		log "Making extract script executable"
		chmod +x "$EXTRACT_SCRIPT"
	fi
	log "Running extract-server.sh"
	"$EXTRACT_SCRIPT"
else
	echo "Error: $EXTRACT_SCRIPT not found" >&2
	exit 1
fi

log "Setup complete"

