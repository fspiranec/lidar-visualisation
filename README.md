# Lidar Visualisation (Safety Fields)

Simple web app for visualising SICK safety fields from pasted XML content.

## What it does now

- Paste a safety field XML export in the built-in dialog.
- Parse `Fieldset > Field > Polygon Type="Field"` points.
- List available fields in a dropdown.
- Render selected field as a polygon in SVG.

## Run locally

Because this is a static app, you can open `index.html` directly or run a static server:

```bash
python3 -m http.server 8080
```

Then open <http://localhost:8080>.

## Deploy to Vercel

1. Push this folder to a Git repository.
2. Import project in Vercel.
3. Framework preset: **Other**.
4. Build command: *(empty)*.
5. Output directory: `.`

This project is static and does not require backend hosting.

## Next step (optional)

To support monitoring cases and saved uploads, we can add:

- Supabase Storage for XML/JPG uploads.
- Supabase Postgres tables for `monitoring_case`, `cutoff_path`, and `field_reference`.
- A second parser for monitoring-case files and case-by-case rendering.
