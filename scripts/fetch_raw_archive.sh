#!/usr/bin/env bash

set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
PAGES_MANIFEST="${1:-$ROOT_DIR/manifests/pages.csv}"
ASSETS_MANIFEST="${2:-$ROOT_DIR/manifests/assets.csv}"
ARCHIVE_DIR="${ARCHIVE_DIR:-$ROOT_DIR/archive}"
USER_AGENT="${USER_AGENT:-Mozilla/5.0 (compatible; cuatro-mil-millones-archiver/1.0; +https://www.4milmillones.org/)}"
FETCHED_AT="$(date -u +"%Y-%m-%dT%H:%M:%SZ")"

mkdir -p "$ARCHIVE_DIR/raw/pages" "$ARCHIVE_DIR/raw/assets"
FAILURES_FILE="$ARCHIVE_DIR/failures.log"
: >"$FAILURES_FILE"

record_failure() {
  local kind="$1"
  local slug_or_name="$2"
  local url="$3"
  local message="$4"
  printf '%s\t%s\t%s\t%s\n' "$kind" "$slug_or_name" "$url" "$message" >>"$FAILURES_FILE"
}

fetch_page() {
  local slug="$1"
  local language="$2"
  local url="$3"
  local out_dir="$ARCHIVE_DIR/raw/pages/$slug"

  mkdir -p "$out_dir"

  if ! curl \
    --fail \
    --silent \
    --show-error \
    --location \
    --compressed \
    --user-agent "$USER_AGENT" \
    --dump-header "$out_dir/headers.txt" \
    --output "$out_dir/source.html" \
    "$url"; then
    rm -f "$out_dir/headers.txt" "$out_dir/source.html"
    record_failure "page" "$slug" "$url" "fetch_failed"
    return 0
  fi

  cat >"$out_dir/metadata.json" <<EOF
{
  "slug": "$slug",
  "language": "$language",
  "url": "$url",
  "fetched_at_utc": "$FETCHED_AT",
  "source_file": "source.html",
  "headers_file": "headers.txt"
}
EOF
}

fetch_asset() {
  local filename="$1"
  local url="$2"
  local out_path="$ARCHIVE_DIR/raw/assets/$filename"
  local metadata_path="$ARCHIVE_DIR/raw/assets/$filename.metadata.json"

  if ! curl \
    --fail \
    --silent \
    --show-error \
    --location \
    --compressed \
    --user-agent "$USER_AGENT" \
    --output "$out_path" \
    "$url"; then
    rm -f "$out_path"
    record_failure "asset" "$filename" "$url" "fetch_failed"
    return 0
  fi

  cat >"$metadata_path" <<EOF
{
  "filename": "$filename",
  "url": "$url",
  "fetched_at_utc": "$FETCHED_AT"
}
EOF
}

tail -n +2 "$PAGES_MANIFEST" | while IFS=, read -r slug language url; do
  fetch_page "$slug" "$language" "$url"
done

tail -n +2 "$ASSETS_MANIFEST" | while IFS=, read -r filename url; do
  fetch_asset "$filename" "$url"
done
