# Raw Archive

This directory stores verbatim HTTP responses fetched from the original site and its CDN assets.

## Layout

- `raw/pages/<slug>/source.html`: HTML as returned by the server
- `raw/pages/<slug>/headers.txt`: response headers from the fetch
- `raw/pages/<slug>/metadata.json`: fetch metadata
- `raw/assets/<filename>`: downloaded binary asset
- `raw/assets/<filename>.metadata.json`: fetch metadata

## Re-fetch

Run:

```bash
./scripts/fetch_raw_archive.sh
```

The script reads:

- `manifests/pages.csv`
- `manifests/assets.csv`

To discover all image originals referenced by the saved HTML and write a broader asset manifest:

```bash
./scripts/build_discovered_asset_manifest.sh
./scripts/fetch_raw_archive.sh manifests/pages.csv manifests/discovered-assets.csv
```

To discover internal site links from the saved HTML and build a broader page manifest:

```bash
./scripts/build_internal_link_manifest.sh
./scripts/fetch_raw_archive.sh manifests/discovered-pages.csv manifests/discovered-assets.csv
```
