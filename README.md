# Cuatro Mil Millones de Años: Evolución Archive

This repository preserves the website **4milmillones.org** before it disappears. The priority is preservation first: save the original HTML and images as served by the live site, keep a reproducible fetch workflow, and maintain a readable derived copy of the content.

## Preservation Status

- Raw archived HTML pages: `179` fetched successfully from discovered internal links
- Raw archived image assets: `105` discovered originals plus `darwincito.jpg`
- Known failed page: `glaciacion-1` returns `404` and is logged in `archive/failures.log`
- Repository size: about `70M`, which is safe for a normal GitHub repository push

## Repository Layout

```text
archive/
  raw/pages/<slug>/source.html    # Verbatim HTML returned by the server
  raw/pages/<slug>/headers.txt    # Response headers
  raw/pages/<slug>/metadata.json  # Fetch metadata
  raw/assets/<filename>           # Downloaded original image asset
  failures.log                    # URLs that failed during fetch

manifests/
  pages.csv                       # Initial hand-curated page list
  assets.csv                      # Initial hand-curated asset list
  discovered-pages.csv            # Internal links discovered from archived HTML
  discovered-assets.csv           # Image originals discovered from archived HTML

scripts/
  fetch_raw_archive.sh            # Fetch pages and assets into archive/
  build_internal_link_manifest.sh # Build page manifest from saved HTML
  build_discovered_asset_manifest.sh
  package_archive.sh              # Create a release tarball

content/
  spanish/
  english/

docs/
  autores.md
```

## Long-Term Plan

Use more than one preservation channel:

1. Keep this repository as the master working archive.
2. Push it to GitHub as a public, versioned copy.
3. Create release tarballs for point-in-time preservation snapshots.
4. Keep at least one additional backup outside GitHub, such as an external drive or another cloud storage location.

GitHub is appropriate here because the current archive is small enough for a standard repository and individual files are far below GitHub's per-file limit.

## Rebuild Or Extend The Archive

Fetch from the current manifests:

```bash
./scripts/fetch_raw_archive.sh
```

Discover more internal site pages from the already archived HTML:

```bash
./scripts/build_internal_link_manifest.sh
./scripts/fetch_raw_archive.sh manifests/discovered-pages.csv manifests/discovered-assets.csv
```

Discover image originals from the archived HTML:

```bash
./scripts/build_discovered_asset_manifest.sh
./scripts/fetch_raw_archive.sh manifests/discovered-pages.csv manifests/discovered-assets.csv
```

Create a portable snapshot tarball:

```bash
./scripts/package_archive.sh
```

## Credits

Original site and educational content:

- María Garza-Jinich
- Ricardo Figueroa
- Jorge Picasso

Original website: [4milmillones.org](https://www.4milmillones.org/)

## Notes

- The `content/` directory contains working markdown derivatives and notes. The preservation source of truth is the raw archive under `archive/raw/`.
- This repository preserves content for educational continuity. Please respect the original authorship and attribution.
