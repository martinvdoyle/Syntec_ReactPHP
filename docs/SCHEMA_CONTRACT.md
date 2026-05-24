# Schema Contract (Oracle Parity)

This project uses a strict schema contract for Oracle-derived tables.

## Hard Rules

1. Oracle export DDL is the source of truth for column names.
2. For Oracle-parity tables, MySQL must have:
   - `extra columns = 0`
   - `missing columns = 0`
3. No hybrid aliases (`name`, `slug`, `*_code`, `*_flag`, surrogate `id`) unless that column exists in Oracle for that table.
4. If parity fails, stop and return diff only. Do not create/alter migration scripts until resolved.

## Covered Tables

- `syntec_suppliers` vs `SUPPLIERS.sql`
- `syntec_products` vs `PRODUCTS.sql`
- `syntec_discipline` vs `DISCIPLINE.sql`
- `syntec_product_group` vs `PRODUCT_GROUP.sql`
- `syntec_product_type` vs `PRODUCT_TYPE.sql`
- `syntec_divisions` vs `SYNTEC_DIVISIONS.sql`
- `syntec_job_titles` vs `SYNTEC_JOB_TITLES.sql`
- `syntec_message_enquiry_type` vs `SYNTEC_MESSAGE_ENQUIRY_TYPE.sql`
- `syntec_message_types` vs `SYNTEC_MESSAGE_TYPES.sql`
- `syntec_sources` vs `SYNTEC_SOURCES.sql`
- `syntec_users` vs `SYNTEC_USERS.sql`
- `syntec_messages` vs `SYNTEC_MESSAGES.sql`

## Required Preflight

Run this before any table work:

```bash
npm run schema:check
```

If it reports mismatches, fix schema parity first.

