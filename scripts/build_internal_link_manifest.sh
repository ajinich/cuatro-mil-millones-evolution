#!/usr/bin/env bash

set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
PAGES_DIR="${1:-$ROOT_DIR/archive/raw/pages}"
OUT_FILE="${2:-$ROOT_DIR/manifests/discovered-pages.csv}"
BASE_URL="${BASE_URL:-https://www.4milmillones.org}"

mkdir -p "$(dirname "$OUT_FILE")"

{
  printf 'slug,language,url\n'
  printf 'home,es,%s/\n' "$BASE_URL"
  rg \
    --glob 'source.html' \
    -o 'href=\"/[^\"#?]+\"' \
    "$PAGES_DIR" |
    sed 's#^[^:]*:href=\"/##' |
    sed 's/\"$//' |
    sort -u |
    while IFS= read -r slug; do
      [ -n "$slug" ] || continue
      case "$slug" in
        cart)
          continue
          ;;
      esac

      language="es"
      case "$slug" in
        english|authors|characters|creation-myths|evidence-for-evolution|evolution-of-dogs|evolution-still-happening|gene-flow|genetic-drift|geographical-evidence-for-evolution|geological-evidence|happens|hereditability|mechanisms|molecular-evidence-for-evolution|mutations|natural-selection|neodarwinists-english|primates|sexual-selection|speciation|time|variability|what-is-evolution|*-english)
          language="en"
          ;;
      esac

      printf '%s,%s,%s/%s\n' "$slug" "$language" "$BASE_URL" "$slug"
    done
} >"$OUT_FILE"

printf 'Wrote %s\n' "$OUT_FILE"
