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

## Menu Migration Mini-Phase (2026-05-20)
- Added Oracle menu migration helper script:
  - `database/mysql/003_menu_items_migration_from_oracle.sql`
- Updated menu API to return nested tree structure (`tree` with recursive `children`) while keeping flat `items` output.
- Upgraded desktop menu rendering to multi-level flyout mega behavior:
  - `src/components/menus/MegaMenu.jsx`
- Upgraded mobile menu rendering to nested accordion behavior:
  - `src/components/menus/MobileMenu.jsx`
- Updated frontend menu client to consume `tree` output:
  - `src/api/menu.js`

### Deployment Note
- Upload updated `api/menu.php` to hosting.
- To migrate real Oracle menu rows:
  1) load Oracle menu data into `syntec_menu_items_staging`
  2) run `database/mysql/003_menu_items_migration_from_oracle.sql` transform steps
  3) verify `/api/menu.php?menu_key=main` returns nested `tree`

## Menu Import Automation Update (2026-05-20)
- Added MySQL-ready converted import file:
  - `database/mysql/003a_menu_items_staging_import.sql`
- This file targets `syntec_menu_items_staging` directly and strips Oracle-only control lines.
- Migration order now:
  1) run `003_menu_items_migration_from_oracle.sql` section 1 (create staging)
  2) import `003a_menu_items_staging_import.sql`
  3) run section 3+4 of `003_menu_items_migration_from_oracle.sql`
- Going forward, provide pre-converted MySQL import files for each Oracle table migration.

## Session Date
- 2026-05-20 (Europe/Dublin)

## Addendum: Oracle Export and Icon Migration
- Oracle exports location confirmed as canonical project source:
  - `C:\Websites\Syntec_ReactPHP\Oracle_Exports`
- Future migration/import tasks must check this folder first for table exports (`*_DATA_TABLE.sql`) and related DDL/constraint scripts.
- Menu icon strategy updated to use React icon libraries instead of Oracle APEX/Font Awesome classes.
- During APEX page conversion, any legacy `fa-*` icon usage must be converted to supported library keys in `syntec_menu_items.icon_class`.
- Supported icon key format:
  - `lucide:<icon-name>`
  - `tabler:<icon-name>`
- Example conversions:
  - `fa-microscope` -> `tabler:microscope`
  - `fa-network-wired` -> `lucide:network`
  - `fa-head-side-virus` -> `tabler:virus`
- Keep icon mapping consistent across desktop mega menu, non-mega dropdowns, and mobile menu.

## Handoff Update (2026-05-23)

### Completed In This Session
- Admin UX parity and stability improvements:
  - Added Products/Suppliers/Lookup list search parity (magnifier + clear `X`).
  - Added keyboard up/down navigation + auto-scroll + focus sync on non-product list panels.
  - Added record counts on list panels (`Showing X of Y`).
  - Added centered styled save-success dialog across admin pages.
- Supplier admin page alignment:
  - Matched Products-style 3-panel layout.
  - Added Live Preview for `profile_1`.
  - Moved supplier logo to preview panel and resized thumbnail.
  - Removed logo block from main detail panel.
- Legacy content rendering fixes:
  - Corrected legacy preview wrapper class usage (`legacy-suppliers-content`).
  - Fixed bullet icon rendering and table bullet column width behavior in `legacy-content.css`.
  - Fixed Products preview `circle` token rendering to filled dot.
- Data/display fixes:
  - Products list secondary line now shows `supplier_name` (not `product_id`).
  - Products list search now includes `supplier_id` and `supplier_name`.
  - Products list sort changed to `supplier_name, product_name, product_id` in API.
  - Supplier-name strike-through in Products list now only when `supplier_active='N'` or `supplier_deleted='Y'`.
- Icon migration scripts created/updated:
  - `database/mysql/034_products_fa_to_new_icon_tokens.sql`
  - `database/mysql/035_normalize_icon_columns_to_tokens.sql`
  - `database/mysql/036_suppliers_profile_fa_to_tokens.sql`

### Backend/API Changes
- `api/products-admin.php`
  - GET includes supplier flag fields:
    - `supplier_active`
    - `supplier_deleted`
  - Sort now by supplier+product name:
    - `ORDER BY s.supplier_name, p.product_name, p.product_id`
  - Backend-only flag parity sync (phase 1):
    - Product create/update syncs supplier flags and all sibling product flags by `supplier_id`.
- `api/suppliers-admin.php`
  - CRUD retained.
  - Backend-only flag parity sync (phase 1):
    - Supplier create/update syncs all child product flags by `supplier_id`.
  - Added `impact_only=1` mode for PUT to return:
    - `products_total`
    - `products_changed`
- `src/api/suppliersAdmin.js`
  - Added `fetchSupplierImpact(payload)` helper.

### Important Stability Note
- A previous frontend preflight/impact implementation caused blank screen.
- It was rolled back surgically in `SuppliersAdminPage.jsx` and then reintroduced in a safer shape.
- Current app is reported working after rollback + safe backend changes.

### Confirmed Data/DB State From User
- MySQL view conversion for legacy `PRODUCTS_VIEW_ALL` validated at expected count:
  - `685` rows.
- Indexing check completed with required join/filter indexes added on key tables.

### Open Follow-Ups For Next Agent
1. Verify supplier impact confirm flow end-to-end in deployed environment:
   - `SuppliersAdminPage` should show confirm with changed row totals.
2. Consider adding non-blocking toast in addition to modal (optional UX polish).
3. If required, move some client-side filters to server-side for large datasets.
4. Keep strict Oracle parity (column names/types) unless explicitly approved.

### Files Most Recently Touched
- `src/pages/ProductsAdminPage.jsx`
- `src/pages/SuppliersAdminPage.jsx`
- `src/pages/LookupAdminPage.jsx`
- `src/styles/legacy-content.css`
- `src/components/admin/SaveSuccessDialog.jsx`
- `src/api/suppliersAdmin.js`
- `api/products-admin.php`
- `api/suppliers-admin.php`
- `database/mysql/034_products_fa_to_new_icon_tokens.sql`
- `database/mysql/035_normalize_icon_columns_to_tokens.sql`
- `database/mysql/036_suppliers_profile_fa_to_tokens.sql`

## Multilingual Module Update (2026-05-23)

- Added multilingual architecture/process documentation:
  - `docs/multilingual-module.md`
- Discipline pilot (EN/FR/IT) is implemented as additive i18n extension:
  - Base table unchanged (`syntec_discipline`)
  - Translation table added (`syntec_discipline_i18n`)
- Added SQL scripts:
  - `database/mysql/037_discipline_i18n.sql` (table + EN seed)
  - `database/mysql/038_seed_discipline_i18n_fr_it.sql` (FR/IT seed)
- Added discipline language handling in admin/API:
  - `api/table-admin.php` (`lang` for discipline read/write with fallback)
  - `src/api/tableAdmin.js` (optional `lang` in API calls)
  - `src/pages/LookupAdminPage.jsx` (discipline language selector)
- Current behavior:
  - Language rows are stored per `(discipline_id, lang)`
  - No auto-translation on edit yet (manual text entry per selected language, seeded FR/IT available)

## Translation Status Update (2026-05-24)

- Translation workflow clarified and stabilized to manual-first mode:
  - EN remains in base tables.
  - i18n tables store non-EN rows (`fr`, `it`) only.
- Suppliers:
  - FR/IT manual edit path confirmed working.
  - Fixed regression where FR/IT update could clear EN `profile_1/profile_2`.
  - FR/IT saves now update only selected language row in `syntec_suppliers_i18n`.
- Products:
  - Aligned write logic with suppliers.
  - FR/IT saves do not overwrite EN base text fields (`product_name`, `short_name`, `about_1`, `about_2`).
  - EN saves continue updating base table fields.
- Automatic translation:
  - Plumbing exists, but high-quality automated translation is deferred until company-owned OpenAI key is enabled.
  - Current practical production-safe path is manual FR/IT updates in admin.

## Handoff Update (2026-05-25)

### Public Site Work Completed
- Header/footer and homepage shell alignment work progressed for Oracle Page 0/Page 1 parity.
- Added new public products middle-content implementation (non-admin) in `src/pages/ProductsPage.jsx`.

### Products Public Page (Middle Content Panel)
- Replaced placeholder with styled Syntec Scientific catalogue page.
- Wired to live data (temporary source):
  - Fetches from `api/products-admin.php?lang=en`
  - Filters to `business = 'Syntec Scientific'`
- Primary filters implemented:
  - Discipline
  - Product Group (dependent list)
  - Search
- Card UX updates:
  - full product image display area (`object-contain`)
  - snippet logic from product text
  - supplier logo support (from supplier logo columns)
  - bottom-aligned `View Product` CTA
- Added product drawer:
  - opens on `View Product`
  - full product view with image, discipline/group, supplier and logo
  - full `ABOUT_1` HTML rendering
  - icon-token rendering parity with admin preview (`lucide:`/`tabler:` replacement)
  - slide-in animation
- Added enquiry modal flow from drawer:
  - `Enquire About This Product` button
  - local capture form (name/company/email/message) ready for final API wire-up

### API / Backend Changes
- `api/products-admin.php`
  - GET now includes:
    - `supplier_logo_small`
    - `supplier_logo_large`
  - Enables public card/drawer supplier logos.

### Languages Module / Wiring
- Added language master module:
  - `database/mysql/047_languages_admin.sql`
  - `api/languages-admin.php`
  - `src/api/languagesAdmin.js`
  - `src/pages/LanguagesAdminPage.jsx`
- Existing admin language dropdowns moved from hardcoded list to `syntec_languages` data source:
  - Products / Suppliers / Lookup pages.
- Added language impact-confirm behavior for add/delete in languages admin.

### Header/Nav Notes
- Multiple iterative header sticky alignment tweaks were made.
- Constraint requested by user: do not modify working nav logic; only shell behavior/layout.
- Current state includes sticky/header shell work-in-progress and may need one final alignment pass for menu/dropdown containment.

### Key Files Touched This Session
- `src/pages/ProductsPage.jsx`
- `api/products-admin.php`
- `src/components/layout/Header.jsx`
- `src/components/layout/Footer.jsx`
- `src/components/layout/Layout.jsx`
- `src/pages/HomePage.jsx`
- `src/pages/LanguagesAdminPage.jsx`
- `src/api/languagesAdmin.js`
- `api/languages-admin.php`
- `database/mysql/043_lookup_i18n_seed_fr_it.sql`
- `database/mysql/044_lookup_i18n_translate_fr_it.sql`
- `database/mysql/045_suppliers_i18n_updates_fr.sql`
- `database/mysql/046_suppliers_i18n_updates_it.sql`
- `database/mysql/047_languages_admin.sql`

### Pending Follow-Ups
1. Finalize sticky header row/menu/dropdown visual containment to exact Oracle behavior.
2. Wire enquiry modal submit to final public contact/enquiry API endpoint.
3. Replace temporary `products-admin.php` public read dependency with dedicated public `api/products.php` endpoint.

## Reboot Handoff Update (2026-05-25)

### Current Uncommitted Work
- Latest changes are **not committed** yet.
- Working tree has modified:
  - `src/components/layout/Header.jsx`
  - `src/pages/ProductsAdminPage.jsx`
  - `src/pages/ProductsPage.jsx`
  - `src/styles/legacy-content.css`
- Existing untracked `Mysql_Exports/*` translation/export working files remain intentionally uncommitted.
- `src/pages/ProductsPage.drawer.backup.jsx` is an untracked local backup of the earlier drawer code.

### Public Products Catalogue Current State
- Public products page now uses a fixed-height catalogue panel:
  - title/banner stays fixed
  - filter/products body scrolls internally
  - product drawer is scoped to the products body, not browser edge
- Product cards now include:
  - admin-style search box with icon and clear `X`
  - supplier logo
  - blue left title bar
  - bottom-aligned `View Product`
  - snippet from `ABOUT_2` first, fallback to `ABOUT_1`
- Public language dropdown is wired:
  - `Header.jsx` stores selected language in `localStorage` as `syntec_lang`
  - dispatches `syntec-language-change`
  - `ProductsPage.jsx` listens and refetches `products-admin.php?lang=<selected>`
  - product cards/drawer use selected-language rows where i18n data exists
- Product search now includes:
  - product id
  - product name
  - supplier name
  - product group
  - discipline
  - `ABOUT_1`
  - `ABOUT_2`

### Product Drawer Current State
- Drawer sticky header now shows:
  - product name with blue left bar
  - supplier name
  - supplier logo
  - close button
- Generic `Product Details` title was removed.
- Drawer body renders full `ABOUT_1` HTML.
- Rich HTML typography is normalized through `src/styles/legacy-content.css` for both:
  - `.legacy-products-content`
  - `.legacy-suppliers-content`
- Shared rich-content styles also affect:
  - public products drawer
  - products admin preview
  - suppliers admin preview

### Legacy HTML / Accordion Status
- `ABOUT_1` / `PROFILE_1` HTML is left unchanged in the database.
- Canonical Oracle APEX legacy CSS/JS source for parity work:
  - `C:\Websites\Syntec_Live\Website_Files\#APP_FILES#_DEV\assets\css\scoped_combined_syn.css`
  - `C:\Websites\Syntec_Live\Website_Files\#APP_FILES#_DEV\assets\js`
  - Do **not** use `Syntec_Register365/public_html/assets/css` as the legacy website CSS reference; that is an older Syntec site.
- `legacy-content.css` was expanded with a scoped compatibility layer for legacy classes found in product/supplier exports:
  - `panel-group`, `accordion`, `panel`, `panel-heading`, `panel-title`, `panel-collapse`, `collapse`
  - `syn_text-block`, `syn_visible-part`, `syn_show-more-start`, `syn_toggle-icon`
  - `heading-desc`, `t-justify`, `centered`, `uppercase`, `sub-heading`, `side-head`
  - image/card/antibody helper classes
  - old FA classes mapped to simple symbols
- Accordion click handling was added in `ProductsPage.jsx` via `toggleLegacyAccordion`.
- ARCTIKO test product:
  - `PRD-0261` / `Refrigerators & Freezers`
  - accordion tabs have image-only content:
    - `Fridges_Range.png`
    - `Refrigerators_Range.png`
    - `Combi_Range.png`
    - `Accessories_Range.png`
  - images exist locally under:
    - `public/assets/images/Scientific/suppliers/arctiko/`
- Important latest patch:
  - `renderRichHtml()` now rewrites legacy `#WORKSPACE_FILES#assets/...` image/link paths to `/assets/...`
  - This was patched after discovering the old check treated `#WORKSPACE_FILES#...` as a plain anchor.
- Build after this final asset-path patch was **not run** because disk space was exhausted.

### Header Sticky Issue
- Header top-strip sticky flashing was addressed by adding hysteresis:
  - top strip hides only after `scrollY > 80`
  - returns only after `scrollY < 20`
- Menu/nav should remain above catalogue/drawer by design.

### Disk Space / Reboot Context
- `C:` became full during work.
- `C:\Websites\.tmp.driveupload` was inspected:
  - contained compressed binary Git/object-like temp upload chunks
  - web search indicates `.tmp.driveupload` is commonly Google Drive / OneDrive temporary upload cache
  - user deleted it; folder is now gone
- Free space did not recover because Windows system files were large:
  - `C:\pagefile.sys` about `31.8 GB`
  - `C:\hiberfil.sys` about `6.8 GB`
- Reboot was recommended to let Windows shrink/release pagefile usage.

### First Steps After Reboot
1. Check free space:
   - `Get-PSDrive C`
2. Run build:
   - `npm run build`
3. Test public products page:
   - language dropdown opens/changes language
   - search includes `ABOUT_1` / `ABOUT_2`
   - ARCTIKO accordion expands and displays images
   - header sticky no longer flashes
4. If build passes and UI checks out, update git:
   - commit modified source files
   - leave `Mysql_Exports/*` WIP files untracked unless explicitly requested

## Implementation Note (2026-05-25)

- Product UI parity rule:
  - Any drawer/preview visual or behavior change must be applied to both:
    - `src/pages/ProductsPage.jsx` (public drawer path)
    - `src/pages/ProductsAdminPage.jsx` (admin live preview path)
  - Do not ship a product drawer-related change unless both paths are reviewed and updated in the same change set.

## Outstanding Items (Low Priority)
- Menu label resolver + i18n strategy (deferred):
  - Runtime rule agreed:
    - If `supplier_id` present -> use supplier name (not translated).
    - Else if `product_group_id` present -> use product-group translated name for selected language.
    - Else -> use static menu label translation for selected language.
  - Non supplier/product-group items should use menu-label translations (with English fallback).
  - This is intentionally deferred while higher-priority UI/menu stability tasks proceed.

- Screen/UI text translation rollout (deferred):
  - Translate all screen labels/controls/dropdowns/headings based on selected language.
  - Keep current language selection behavior but defer full label coverage implementation.
  - This is explicitly not a current priority and should be resumed later.

### Deferred Translation Process Notes (Agreed)
- Scope status: deferred by priority, but process is agreed and should be followed when resumed.

- Source-of-truth principle:
  - Use ID/FK-driven lookup values for translatable labels where possible.
  - Avoid using redundant plain-text columns when an ID-based lookup exists.

- Menu label resolution process (agreed):
  1) If `supplier_id` is populated on a menu row, render supplier name directly (supplier names are not translated).
  2) Else if `product_group_id` is populated, render product-group name from language-aware product-group source for selected language.
  3) Else render static menu label from menu translation source for selected language.
  4) Fallback chain for static labels: selected language -> English/base -> existing `sub_menu_name` -> `menu_name`.

- Tables/process referenced in agreement:
  - `syntec_menu_items` remains structural menu source.
  - `supplier_id` and `product_group_id` drive dynamic label resolution.
  - `syntec_product_group_i18n` (or equivalent product-group language table) should provide translated group names by `lang`.
  - Supplier display name should come from supplier master table (`syntec_suppliers` / supplier i18n policy as agreed: do not translate supplier brand names).
  - Static non-supplier/non-product-group labels should use a menu i18n table/process (to be implemented), keyed by menu item + language.

- Screen/UI translation process (agreed direction):
  - Translate page labels, control labels, dropdown labels, headings, and helper text by selected language.
  - Keep language selection state and apply consistently across Products/Suppliers/Admin/public screens.
  - Resume only after current menu/runtime stabilization tasks are complete.

### Screen Label i18n Contract (Agreed)
- Purpose: provide language-driven UI/screen text for labels, headings, dropdown captions, helper text, button text, and validation messages without hardcoding.

- Primary table (agreed): `syntec_ui_labels_i18n`
  - Recommended columns:
    - `label_key` VARCHAR (stable unique key, e.g. `products.filter.discipline`)
    - `lang` CHAR(2) (e.g. `en`, `fr`, `it`)
    - `label_text` TEXT/VARCHAR
    - `context` VARCHAR nullable (optional scope like `public`, `admin`, `products`)
    - `updated_at` TIMESTAMP
    - `updated_by` VARCHAR nullable
  - Recommended PK/unique:
    - `(label_key, lang)`

- Optional metadata/source table (if needed for governance):
  - `syntec_ui_labels` (base key registry)
    - `label_key` PK
    - `default_text_en`
    - `module`
    - `description`
    - `active`

- Runtime lookup/fallback rules (agreed):
  1) Try selected language row from `syntec_ui_labels_i18n`.
  2) Fallback to English (`lang='en'`).
  3) Fallback to hardcoded safe default in component.

- Key naming convention (agreed):
  - Dot notation by module/page/element, examples:
    - `products.title`
    - `products.filter.discipline`
    - `products.filter.product_group`
    - `products.search.placeholder`

## Menu Context Rule Lock (2026-05-27)

- Status: implemented and must be preserved.

- Problem solved:
  - When user is in one business context (example: `International`) and clicks a menu item that belongs to another L0 destination (example: `Syntec Scientific`), the business dropdown and menu context must switch to the clicked item destination context.

- Required runtime behavior:
  1) Determine context from the **actual clicked target item path** (clicked item -> parent chain -> owning `L0`).
  2) Apply that owning `L0` context to header/menu state:
     - `businessSet`
     - `websiteSet` (fallback `website`)
  3) Sync visible business dropdown value from resolved context:
     - `Syntec Group` website -> dropdown `Syntec Group`
     - `Syntec International` website -> dropdown `International`
     - all other websites -> dropdown `Ireland`
  4) Persist updated values in local storage keys:
     - `syntec_menu_business`
     - `syntec_menu_website`
     - and keep `syntec_business` aligned via dropdown state.

- Files implementing this rule:
  - `src/components/menus/MegaMenu.jsx`
  - `src/components/layout/Header.jsx`

- Regression warning:
  - Do not set context from the currently hovered/open mega menu alone.
  - Context must follow the clicked target’s resolved `L0` destination.
    - `products.button.view_product`
    - `menu.about_us`
    - `admin.products.save`

- Implementation workflow when resumed:
  1) Inventory all current visible UI strings per page.
  2) Assign stable `label_key` for each string.
  3) Seed English rows first.
  4) Add FR/IT rows.
  5) Replace component literals with lookup helper.
  6) Verify fallback behavior per page.

- Priority note:
  - This contract is agreed but intentionally deferred until higher-priority menu/runtime issues are complete.
