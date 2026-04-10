# Lidar Visualisation (Safety Fields) v1.1.0

**Creator:** Franjo Spiranec / Codex

Simple web app for visualising SICK safety fields from imported XML files.

## What it does now

- Import safety field XML export files (`.sdxml`) for **Rear Left Lidar** and/or **Front Right Lidar**.
- Parse `Fieldset > Field > Polygon Type="Field"` points.
- List available fields for each lidar in separate dropdowns.
- Render one or both selected fields as polygons in one SVG coordinate system.
- Rotate all Lidar 2 points by `180°` and then offset by `(-1180, -1650)` to match real-space placement.
- Show coordinate labels on every rendered point using the **original, pre-transform** values.
- Draw lidar locations as yellow 50x50 markers: `rear left lidar` at `(0,0)` and `front right lidar` at `(-1180,-1650)`.
- Include a measurement tool: click **Measure distance**, then click any two canvas points to get total distance plus absolute `Δx` and `Δy` in mm.
- XML imports are parsed client-side only (no file storage/upload backend).
- Import monitoring cases XML for both lidars (`.casesxml`), choose a monitoring case once, and render matched fields from both lidar datasets for that same case number/name.
- UI is split into tabs (**Import**, **Visualisation**): import all files in one place, then do all selections/rendering in Visualisation.
- Monitoring-case parsing prioritizes **case ID / number** nodes and searches under each case for field names that match the imported field list.
- Uses SICK `.casesxml` mapping flow: reads `/SdImportExport/Cases/Case` (`Name`, `DisplayOrder`, `Activation/CaseNumber`) and matches eval paths via `/SdImportExport/Evals/Eval/Cases/Case[@Id=DisplayOrder]`, then reads `ScanPlanes/ScanPlane/UserFieldId`.
- Monitoring case detail panel outputs a markdown table row with `CaseNumber`, `Name`, `DisplayOrder`, and 4 cut-off path cells in the format `UserFieldId = resolved field name` (or `not found`).
- Monitoring case panel now supports rendering/filtering cut-off paths 1..8 (or all), and output table includes cut-off paths 1..8.
- Current parser logic: `CaseNumber` comes from `Activation/CaseNumber` (no `+1` logic), while Eval linking uses main case object `@Id` (`Eval/Cases/Case[@Id = Case/@Id]`), with fixed static labels `100=PermRed`, `101=PermGreen`, `102=PermGreenWf`.
- Cross-lidar monitoring-case pairing uses `Activation/CaseNumber` as the global join key.
- Monitoring-case details output shows one readable block per lidar (with lidar + case name) and lists cut-off paths 1..8 explicitly.
- Rendering now centers geometry in the SVG frame, shows an in-canvas color legend (`color -> field name`), and cut-off path filtering is done with checkboxes for paths 1..8.
- Monitoring-case controls now contain `Render monitoring case`, `Show coordinates`, and cut-off path checkboxes; measurement controls are placed above the render canvas.
- Monitoring case details are shown in a readable multi-line block per lidar/case (instead of one long single-line row).
- Field parsing now includes all polygon types found under a field (not only `Type="Field"`), so contour-detection polygons can also be rendered when present.
- Legend is rendered below the canvas (not over the plot), to avoid covering coordinate labels.
- Field dropdown now shows field type and geometry type (`[Fieldtype / PolygonType]`) so contour entries are visible/selectable directly.
- You can toggle point coordinate labels on/off via the **Show coordinates** checkbox.
- Monitoring case panel includes a highlighted box showing selected monitoring case number in decimal and 8-bit binary (example: `8 -> 00001000`).

## Run locally

Because this is a static app, you can open `index.html` directly or run a static server:

```bash
python3 -m http.server 8080
```

Then open <http://localhost:8080>.

## Run with Docker

Build the image:

```bash
docker build -t lidar-visualisation .
```

Run the container:

```bash
docker run -d --name lidar-visualisation --restart unless-stopped -p 8080:8080 lidar-visualisation
```

Check logs:

```bash
docker logs -f lidar-visualisation
```

Stop/remove container:

```bash
docker rm -f lidar-visualisation
```

Then open <http://localhost:8080>.

## Full setup from a clean Ubuntu install (remote machine / bridged network)

If your Ubuntu machine is fresh, use these exact steps.

1. Update packages:

```bash
sudo apt update
sudo apt upgrade -y
```

2. Install required tools:

```bash
sudo apt install -y ca-certificates curl gnupg lsb-release git
```

3. Install Docker Engine (official Docker repository):

```bash
sudo install -m 0755 -d /etc/apt/keyrings
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg
sudo chmod a+r /etc/apt/keyrings/docker.gpg

echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu \
  $(. /etc/os-release && echo $VERSION_CODENAME) stable" | \
  sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

sudo apt update
sudo apt install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin
```

4. (Optional but recommended) Run Docker without `sudo`:

```bash
sudo usermod -aG docker $USER
newgrp docker
```

5. Get the project on the Ubuntu machine:

```bash
git clone <YOUR_REPO_URL> lidar-visualisation
cd lidar-visualisation
```

6. Build and run:

```bash
docker build -t lidar-visualisation .
docker run -d --name lidar-visualisation --restart unless-stopped -p 8080:8080 lidar-visualisation
```

7. Verify it is running:

```bash
docker ps
docker logs --tail=50 lidar-visualisation
curl http://localhost:8080
```

8. If you access it from another machine over your bridged network, allow port `8080`:

```bash
sudo ufw allow 8080/tcp
sudo ufw status
```

9. Find the Ubuntu machine IP and open it from your client machine:

```bash
ip -4 addr show
```

Then browse to:

```text
http://<UBUNTU_BRIDGED_IP>:8080
```

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


## Version management

- App version is stored in `version.js`.
- Update `window.APP_VERSION` manually to change the version displayed on `index.html`.
