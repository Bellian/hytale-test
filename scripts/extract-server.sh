#!/usr/bin/env bash
set -euo pipefail

ZIP="vendor/server.zip"
DEST="vendor/server"

echo "Extracting $ZIP -> $DEST"

if [ ! -f "$ZIP" ]; then
  echo "Error: $ZIP not found" >&2
  exit 1
fi

mkdir -p "$DEST"

if command -v unzip >/dev/null 2>&1; then
  unzip -o "$ZIP" -d "$DEST"
elif command -v python3 >/dev/null 2>&1; then
  python3 - <<PY
import zipfile
zipfile.ZipFile("${ZIP}").extractall("${DEST}")
PY
else
  echo "Error: neither 'unzip' nor 'python3' available to extract zip" >&2
  exit 1
fi

echo "Done."
