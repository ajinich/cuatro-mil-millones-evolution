# Archive Viewer

This folder is a local navigation aid for the preserved site.

- `index.html` is a searchable page index.
- `pages.js` is generated from `manifests/discovered-pages.csv`.

Rebuild the data file after updating the archive:

```bash
./scripts/build_viewer_data.sh
```

Then open `viewer/index.html` in a browser.
