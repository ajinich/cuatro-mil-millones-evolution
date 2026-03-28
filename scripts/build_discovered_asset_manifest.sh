#!/usr/bin/env bash

set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
PAGES_DIR="${1:-$ROOT_DIR/archive/raw/pages}"
OUT_FILE="${2:-$ROOT_DIR/manifests/discovered-assets.csv}"

mkdir -p "$(dirname "$OUT_FILE")"

{
  printf 'filename,url\n'
  rg \
    --glob 'source.html' \
    -o 'https://images\.squarespace-cdn\.com/[^"'"'"' )]+' \
    "$PAGES_DIR" |
    sed 's#^[^:]*:##' |
    sed 's/[?].*$//' |
    sort -u |
    awk -F/ 'NF { print $NF "," $0 }'
} >"$OUT_FILE"

printf 'Wrote %s\n' "$OUT_FILE"
