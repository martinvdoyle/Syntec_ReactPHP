# Translation Runbook (Demo Now, OpenAI Later)

## Goal

Support multilingual demo in dev **without paid API calls**, while keeping production-ready plumbing to switch to OpenAI later.

## Current Design

- Base tables hold English source text.
- i18n tables hold non-English records (`fr`, `it`).
- Supplier profiles currently translated:
  - `syntec_suppliers.profile_1`
  - `syntec_suppliers.profile_2`
- Product i18n table is prepared for batch translation use.

## Current Status (2026-05-24)

- Manual language editing flow is now the active/approved workflow.
- Suppliers manual update is confirmed working:
  - editing FR/IT no longer overwrites EN base text.
- Products now follow the same non-EN write logic as Suppliers.
- EN remains in base tables only; i18n stores non-EN records (`fr`, `it`).
- Automatic high-quality translation is deferred until OpenAI/company key is enabled.

## Key Files

- Translation provider wrapper:
  - `api/config/translate.php`
- Suppliers CRUD translation flow:
  - `api/suppliers-admin.php`
- Temporary web backfill endpoint:
  - `api/admin/backfill-translations.php`
- SQL:
  - `database/mysql/040_suppliers_i18n.sql`
  - `database/mysql/041_product_i18n.sql`

## Modes

### 1) Demo Mode (No Cost)

Use built-in best-effort translator.

Env:

```text
TRANSLATE_ENABLED=0
TRANSLATE_PROVIDER=best_effort
```

Behavior:
- Translation calls do not go to OpenAI.
- Placeholder FR/IT output is generated locally in PHP.

Note:
- This mode is not considered production translation quality.
- Current recommended use is manual FR/IT edits in admin.

### 2) Production Mode (OpenAI)

Use OpenAI translation.

Env:

```text
TRANSLATE_ENABLED=1
TRANSLATE_PROVIDER=openai
OPENAI_API_KEY=your_key_here
OPENAI_TRANSLATE_MODEL=gpt-4.1-mini
```

Behavior:
- Translation requests call OpenAI Responses API.
- Higher quality, billable usage.

## Setup Steps (Order)

1. Run SQL:
   - `database/mysql/040_suppliers_i18n.sql`
   - `database/mysql/041_product_i18n.sql`
2. Deploy API files:
   - `api/config/translate.php`
   - `api/suppliers-admin.php`
   - `api/admin/backfill-translations.php`
3. Set translation env mode:
   - demo or production (above).
4. Set backfill token:

```text
BACKFILL_TOKEN=long_random_secret
```

## Backfill Endpoint (Temporary)

Path:

```text
/api/admin/backfill-translations.php
```

Security:
- Requires `BACKFILL_TOKEN`
- Pass token via query string

### Suppliers Bulk Backfill

```text
/api/admin/backfill-translations.php?mode=suppliers&limit=50&offset=0&token=YOUR_TOKEN
```

Run repeatedly with increasing offset until `processed = 0`.

### Products Backfill Per Supplier

```text
/api/admin/backfill-translations.php?mode=products&supplier_id=SUP-0003&limit=50&offset=0&token=YOUR_TOKEN
```

Run repeatedly per supplier until `processed = 0`.

## Ongoing CRUD Behavior

- Save supplier in `lang=en`:
  - base EN saved
- Save in `lang=fr` or `lang=it`:
  - updates selected language record only

Products mirror this model:
- Save product in `lang=en`: base EN fields update.
- Save product in `lang=fr` or `lang=it`: only i18n row updates; EN base text is preserved.

## Cleanup After Initial Backfill

After initial rollout is complete, remove temporary endpoint:

- Delete or disable `api/admin/backfill-translations.php`

Keep:
- `api/config/translate.php`
- `api/suppliers-admin.php`

## Notes

- Demo mode is for preview only and not publication-grade translation quality.
- Production should use OpenAI mode for final quality pass before launch.
