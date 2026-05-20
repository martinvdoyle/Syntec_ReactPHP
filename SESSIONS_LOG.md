# SESSIONS_LOG.md

## Session Date
- 2026-05-19 (Europe/Dublin)

## Project Context
- Project: `Syntec_ReactPHP`
- Objective: Rebuild `https://www.syntec.ie` (Oracle APEX public site) as a modern React + PHP + MySQL application.
- Oracle APEX is treated as a functional/visual reference only, not architecture to replicate.

## Confirmed Architectural Rules
- Frontend: React (Vite) with JavaScript (not TypeScript).
- Styling: Tailwind CSS v4.
- Routing: React Router.
- Backend: PHP APIs returning JSON only (no server-rendered frontend HTML).
- Database: MySQL is source of truth from day one.
- Assets: Filesystem-based images/docs; DB stores file paths only.
- Avoid JSON as long-term source of truth.
- Keep codebase/elements ecommerce-ready without building ecommerce now.

## Hosting / Environment Model
- Local frontend dev on `http://localhost:5173`.
- Frontend calls hosted PHP APIs + MySQL on Register365.
- Use `.env` placeholder config including `VITE_API_BASE_URL`.
- Temporary shared hosting path pattern expected:
  - `/public_html/syntec-dev/` with isolated folders (`api`, `admin`, `assets`, `uploads`).
- Use Syntec-prefixed tables only (e.g., `syntec_products`, `syntec_suppliers`, etc.).

## What Was Asked and Agreed
- Assistant can see and follow `AGENTS.md` instructions.
- Assistant summarized understanding of:
  - migration scope,
  - architecture,
  - features,
  - constraints,
  - phase-1 build targets.
- User provided initial implementation preferences:
  - JavaScript
  - Tailwind v4
  - `.env` placeholders for API base URL
- Assistant must wait for user to provide legacy directories before scaffolding.

## Legacy Reference Inputs (Planned)
User will provide:
- Legacy CSS directory
- Legacy JS directory
- Logos and image directories

Rules agreed:
- Legacy CSS/JS are reference-only.
- Extract design tokens/patterns (colors, spacing, typography, interaction cues).
- Do not blindly import legacy CSS/JS.
- Copy only required images into new project as needed.
- Keep legacy files separated from new implementation.

## Visual / Functional Reference Sources
- Live site reference confirmed: `https://www.syntec.ie`
- Note from user: site was largely built on the Superfine template.
- Superfine should be treated as visual reference only, not copied architecture/code.

## APEX Export Guidance Agreed
- Full APEX app export is useful and preferred first input.
- Region-by-region details are also valuable, especially:
  - dynamic SQL assembled in PL/SQL,
  - called Oracle procedures/functions/packages,
  - visibility/condition logic.
- Most valuable extraction targets:
  - menu hierarchy/visibility rules,
  - page-region content mapping,
  - lookups (suppliers/categories/applications),
  - business/visibility/filter rules,
  - legacy URL patterns for redirects.

## Initial Starter Scope Agreed
User can provide starter package containing:
- Header region SQL/logic + related procs/functions.
- Footer region SQL/logic + related procs/functions.
- Page 1 (home) regions and SQL/PLSQL sources + conditions.
- Related assets and page-specific CSS/JS.

## Phase 1 Scaffold Target (When User Says Proceed)
- Vite React scaffold
- Tailwind v4 setup
- Routing shell
- API config layer
- Layout structure
- Responsive header
- DB-driven menu API contract
- Mega menu component
- Mobile menu component
- Footer
- Placeholder pages:
  - Home
  - Suppliers
  - Products

## Current Status
- Awaiting user-provided legacy/reference directories and/or APEX export/region content.
- No scaffold implementation started yet per user instruction to wait.

## Credentials Handling Update (2026-05-19)
- Added secure local credentials pattern in Syntec repo.
- Created tracked template: `.env.example` (placeholders only).
- Created local runtime file: `.env.local` (gitignored via existing `.env.*` rule).
- Rule: no secrets in `AGENTS.md` or other tracked docs.
- Action recommended: rotate temporary DB password after initial setup.

## Phase 1 + Phase 2 Progress (2026-05-20)
- Completed Phase 1 React scaffold in `Syntec_ReactPHP`:
  - Vite + React (JavaScript)
  - Tailwind CSS v4
  - React Router shell
  - Header / MegaMenu / MobileMenu / Footer placeholders
  - Home / Suppliers / Products / Contact placeholder pages
- Added API config layer using `VITE_API_BASE_URL`.
- Verified frontend build (`npm run build`) succeeds.
- Commit recorded:
  - `a85f4b2 feat: phase 1 react scaffold with tailwind, router, layout, and placeholders`

## Asset Migration Progress
- Completed SQL-driven asset reference scan and selective copy from legacy image root into new `public/assets/images`.
- Added log: `ASSET_COPY_LOG.md`.
- Missing references identified and deferred to placeholder/fallback handling.

## Phase 2 Backend/API + Menu Integration
- Added PHP API scaffold:
  - `api/config/cors.php`
  - `api/config/db.php`
  - `api/menu.php`
- Added MySQL schema + seed script:
  - `database/mysql/001_syntec_menu_items.sql`
- Added frontend API fetch with fallback:
  - `src/api/menu.js`
  - `src/components/layout/Header.jsx` now fetches menu data from API.
- Verified frontend build still passes after integration.

## Operational Notes
- Runtime note: local environment had Node/NPM conflicts due legacy NVM config; resolved to working state for scaffold/build.
- Pending deployment step:
  - Upload `api/` to `/public_html/syntec-dev/api/`
  - Run `database/mysql/001_syntec_menu_items.sql` in `9ng6ht_syntecdev`.

## Security / Config Note
- For production-style config, PHP expects DB connection values from runtime environment variables:
  - `SYNTEC_DB_HOST`
  - `SYNTEC_DB_NAME`
  - `SYNTEC_DB_USER`
  - `SYNTEC_DB_PASS`
- If hosting env vars are not available in Register365, fallback is to store these in a local non-committed PHP config include and require it from `api/config/db.php`.

## DB Config Pattern Update (2026-05-20)
- Reviewed `C:\Websites\ReactMembersWebsite_clean` DB pattern.
- Syntec now supports same style via root local config include:
  - `db-config.local.php` (gitignored, real secrets)
  - `db-config.example.php` (tracked template)
- `api/config/db.php` now loads `db-config.local.php` first, then falls back to env vars (`SYNTEC_DB_*`) if local file not present.
- This aligns deployment behavior with existing Luttrellstown setup.

## Suppliers Phase Update (2026-05-20)
- Added suppliers schema script:
  - `database/mysql/002_syntec_suppliers.sql`
- Added suppliers API endpoint:
  - `api/suppliers.php`
- Added frontend suppliers client:
  - `src/api/suppliers.js`
- Replaced suppliers placeholder page with live API-driven supplier card listing:
  - `src/pages/SuppliersPage.jsx`
- Kept fallback supplier data and missing-image fallback behavior for resilience during migration.
