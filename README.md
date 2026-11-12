# CHTC Collection Manager

Specimen database for the Coleção Herpetológica Teresa Cristina Sauer de Avila-Pires (CHTC).
One code base, three ways to use it: desktop app (Windows, macOS, Linux), web app, and phone (installable web app).

- Online database: free **Supabase** (PostgreSQL) with sign-in, roles (admin / editor / viewer) and row-level security
- Works offline and syncs automatically when the connection returns; local copy on every device
- 36 specimen fields, Darwin Core terms shown on each field, "Export Darwin Core" table
- QR scanning with the **webcam or the phone camera** (opens the specimen by Voucher Number), or a USB scanner (works anywhere in the app, no need to click a field)
- Google Maps (per specimen and all specimens), dashboard with charts, CSV import/export

## Files
- `setup.sql` – run once in Supabase (SQL Editor)
- `config.js` – put your Supabase URL and anon key here once
- `.github/workflows/pages.yml` – publishes the web/phone version on GitHub Pages
- `.github/workflows/build.yml` – builds Windows / macOS / Linux installers

See `SETUP-PT.md` for the step-by-step guide (Portuguese).

## Platforms
Windows (.exe), macOS Intel + Apple Silicon (.dmg), Linux (.AppImage, .deb) via *Build installers*; Android and iOS as an installable web app (PWA) via *Publish web app*; optional Android APK via *Build Android APK*.
