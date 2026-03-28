#!/usr/bin/env bash

set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
DIST_DIR="$ROOT_DIR/dist"
STAMP="$(date -u +%Y%m%dT%H%M%SZ)"
OUT_FILE="$DIST_DIR/cuatro-mil-millones-archive-$STAMP.tar.gz"

mkdir -p "$DIST_DIR"

tar \
  -czf "$OUT_FILE" \
  -C "$ROOT_DIR" \
  README.md \
  archive \
  manifests \
  scripts

printf 'Created %s\n' "$OUT_FILE"
