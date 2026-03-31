# Lidar Visualisation (Safety Fields)

Simple web app for visualising SICK safety fields from pasted XML content.

## What it does now

- Paste a safety field XML export (or import `.xml/.txt/.sdxml/.sdxlm` file directly) for **Rear Left Lidar** and/or **Front Right Lidar**.
- Parse `Fieldset > Field > Polygon Type="Field"` points.
- List available fields for each lidar in separate dropdowns.
- Render one or both selected fields as polygons in one SVG coordinate system.
- Rotate all Lidar 2 points by `180°` and then offset by `(-1180, -1650)` to match real-space placement.
- Show coordinate labels on every rendered point using the **original, pre-transform** values.
- Draw lidar locations as yellow 50x50 markers: `rear left lidar` at `(0,0)` and `front right lidar` at `(-1180,-1650)`.
- Include a measurement tool: click **Measure distance**, then click any two canvas points to get total distance plus absolute `Δx` and `Δy` in mm.
- XML imports are parsed client-side only (no file storage/upload backend).
- Add/paste monitoring cases XML for both lidars (supports `.casesxml`), choose a monitoring case once, and render matched fields from both lidar datasets for that same case number/name.
- Monitoring-case parsing prioritizes **case ID / number** nodes and searches under each case for field names that match the imported field list.
- Uses SICK `.casesxml` mapping flow: reads `/SdImportExport/Cases/Case` (`Name`, `DisplayOrder`, `Activation/CaseNumber`) and matches eval paths via `/SdImportExport/Evals/Eval/Cases/Case[@Id=DisplayOrder]`, then reads `ScanPlanes/ScanPlane/UserFieldId`.
- Monitoring case detail panel outputs a markdown table row with `CaseNumber`, `Name`, `DisplayOrder`, and 4 cut-off path cells in the format `UserFieldId = resolved field name` (or `not found`).
- Monitoring case panel now supports rendering/filtering cut-off paths 1..8 (or all), and output table includes cut-off paths 1..8.
- Current parser logic: `CaseNumber` comes from `Activation/CaseNumber` (no `+1` logic), while Eval linking uses main case object `@Id` (`Eval/Cases/Case[@Id = Case/@Id]`), with fixed static labels `100=PermRed`, `101=PermGreen`, `102=PermGreenWf`.
- Cross-lidar monitoring-case pairing uses `Activation/CaseNumber` as the global join key.
- Monitoring-case details output shows one readable block per lidar (with lidar + case name) and lists cut-off paths 1..8 explicitly.
- Rendering now centers geometry in the SVG frame, shows an in-canvas color legend (`color -> field name`), and cut-off path filtering is done with checkboxes for paths 1..8.
- Monitoring case details are shown in a readable multi-line block per lidar/case (instead of one long single-line row).
- Field parsing now includes all polygon types found under a field (not only `Type="Field"`), so contour-detection polygons can also be rendered when present.
- Legend is rendered below the canvas (not over the plot), to avoid covering coordinate labels.
- Field dropdown now shows field type and geometry type (`[Fieldtype / PolygonType]`) so contour entries are visible/selectable directly.
- You can toggle point coordinate labels on/off via the **Show coordinates** checkbox.

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
