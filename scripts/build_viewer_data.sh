#!/usr/bin/env bash

set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
MANIFEST_FILE="${1:-$ROOT_DIR/manifests/discovered-pages.csv}"
VIEWER_DATA_FILE="${2:-$ROOT_DIR/viewer/pages.js}"
FAILURES_FILE="${3:-$ROOT_DIR/archive/failures.log}"

mkdir -p "$(dirname "$VIEWER_DATA_FILE")"

{
  printf 'window.ARCHIVE_PAGES = [\n'
  tail -n +2 "$MANIFEST_FILE" | while IFS=, read -r slug language url; do
    [ -n "$slug" ] || continue

    status="archived"
    if [ ! -f "$ROOT_DIR/archive/raw/pages/$slug/source.html" ]; then
      status="missing"
    fi

    failure=""
    if [ -f "$FAILURES_FILE" ]; then
      failure="$(awk -F '\t' -v target="$slug" '$1 == "page" && $2 == target { print $4; exit }' "$FAILURES_FILE")"
    fi

    title="$(printf '%s' "$slug" | sed 's/-/ /g; s#/# #g')"
    case "$slug" in
      home)
        title="home"
        ;;
    esac

    printf '  {"slug":"%s","language":"%s","title":"%s","url":"%s","localPath":"../archive/raw/pages/%s/source.html","status":"%s","failure":"%s"},\n' \
      "$slug" "$language" "$title" "$url" "$slug" "$status" "$failure"
  done
  printf '];\n'
} >"$VIEWER_DATA_FILE"

printf 'Wrote %s\n' "$VIEWER_DATA_FILE"
