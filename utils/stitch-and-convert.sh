#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
INPUT_DIR="$SCRIPT_DIR/webp"
OUTPUT_MP4="$INPUT_DIR/combined.mp4"
OUTPUT_WEBM="$INPUT_DIR/combined.webm"

# Build concat list from files sorted by order number in filename
CONCAT_LIST=$(mktemp)
trap 'rm -f "$CONCAT_LIST"' EXIT

for f in $(ls "$INPUT_DIR"/*.mp4 | sort); do
  echo "file '$f'" >> "$CONCAT_LIST"
done

echo "Stitching videos..."
ffmpeg -y -f concat -safe 0 -i "$CONCAT_LIST" -c copy "$OUTPUT_MP4"

echo "Converting to webm..."
ffmpeg -y -i "$OUTPUT_MP4" -c:v libvpx-vp9 -crf 30 -b:v 0 "$OUTPUT_WEBM"

echo "Done: $OUTPUT_WEBM"
