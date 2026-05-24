# Multilingual Module (EN/FR/IT) - Syntec ReactPHP

## Purpose

This project uses MySQL + PHP + React with **English as source-of-truth** and translated text stored in `*_i18n` tables.

Current pilot is implemented for:
- `syntec_discipline` + `syntec_discipline_i18n`

Target model is to extend the same pattern to products, suppliers, and other user-facing text tables.

## Core Rules

1. Base tables are not replaced.
2. Base tables keep stable/non-language data:
   - ids, skus, flags, links, image paths, sort/order, dates, internal keys.
3. i18n tables store translated text only.
4. One row per `(entity_id, lang)`.

## Current Language Set

- `en` (master/source)
- `fr`
- `it`

## Data Model Pattern

Example:

- Base: `syntec_products`
- i18n: `syntec_product_i18n`
  - `product_id`
  - `lang`
  - translated text columns only (`product_name`, `short_name`, `about_1`, etc.)
  - unique/primary key: `(product_id, lang)`

## Save Behavior (Chosen Approach)

For this project (low update volume), use **instant translation on save**:

1. Admin saves English (`lang=en`).
2. API writes base + EN i18n text.
3. In same request, API translates to FR and IT.
4. API upserts FR/IT i18n rows immediately.
5. Response includes per-language status.

Failure policy:
- English save must succeed even if translation provider fails.
- Return warning payload for failed language updates so user can retry.

## Read Behavior

When requesting `lang=fr` (or `it`):

1. return requested language text if present
2. else fall back to `en`
3. else fall back to base table text

## Add A New Language (Process)

Example for German (`de`):

1. Add language code to backend allowed list/config.
2. Add language to admin selector UI.
3. Add language to auto-translate target list.
4. Seed `de` rows from EN in each `*_i18n` table (upsert-safe SQL).
5. Add frontend locale route support (`/de/...`) as needed.
6. Add SEO entries:
   - `hreflang`
   - locale sitemap entries

After this, all future EN saves auto-populate DE instantly.

## Table Onboarding Checklist

For each table:

1. Confirm translatable columns list.
2. Create `syntec_<table>_i18n`.
3. Seed EN from base text.
4. Seed FR/IT from EN (initial pass).
5. Update read endpoint with `lang` + fallback.
6. Update save endpoint with EN master + instant FR/IT translation.
7. Add/confirm admin language selector behavior.

## Discipline Pilot Files

- SQL table seed:
  - `database/mysql/037_discipline_i18n.sql`
  - `database/mysql/038_seed_discipline_i18n_fr_it.sql`
- API:
  - `api/table-admin.php` (discipline `lang` support)
- Frontend:
  - `src/api/tableAdmin.js`
  - `src/pages/LookupAdminPage.jsx`

## Notes

- No Oracle/hybrid schema rename behavior introduced.
- Oracle parity remains on base tables.
- i18n extension is additive and isolated.
