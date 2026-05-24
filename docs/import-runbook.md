# Syntec Import Runbook

## Scope
Runbook for importing remaining Oracle-exported tables into MySQL with a safe, repeatable pattern:
- staging import
- runtime migration/upsert
- constraints
- parity + integrity checks

Project root: `c:\Websites\Syntec_ReactPHP`

---

## Current State (Completed)
- Suppliers pipeline created and run:
  - `database/mysql/002a_suppliers_staging_import.sql`
  - `database/mysql/002b_suppliers_migration_from_oracle.sql`
  - `database/mysql/002c_suppliers_constraints_mysql.sql`
- Products pipeline created and run:
  - `database/mysql/005b_products_migration_from_oracle.sql`
  - `database/mysql/005c_products_fa_to_lucide_tabler.sql`
  - `database/mysql/005d_products_constraints_mysql.sql`
- Product parity reached: staging and runtime both `943`.
- Slug collision issue resolved by suffixing slug with product-id fragment in `005b`.

---

## Standard Pattern Per Table
For each table, create three scripts:
1. `NNNa_<table>_staging_import.sql`
2. `NNNb_<table>_migration_from_oracle.sql`
3. `NNNc_<table>_constraints_mysql.sql`

Run order is always:
1. `a` staging import
2. `b` runtime migration/upsert
3. validation queries
4. dedupe/fix if needed
5. `c` constraints
6. post-constraint validation

---

## Recommended Remaining Import Order
1. Categories (parent lookup)
2. Applications (parent lookup)
3. Product-category join table
4. Product-application join table
5. Product images/documents tables
6. Menu items
7. Pages/content tables

Reason: load parent keys before child/join rows.

---

## Generic Validation SQL (Template)

### 1) Count parity
```sql
SELECT COUNT(*) AS staging_rows FROM <staging_table>;
SELECT COUNT(*) AS runtime_rows FROM <runtime_table>;
```

### 2) Missing mappings (left anti join)
```sql
SELECT st.*
FROM <staging_table> st
LEFT JOIN <runtime_table> rt
  ON rt.<oracle_key_col> = st.<staging_key_col>
WHERE rt.<runtime_pk> IS NULL
ORDER BY st.<staging_key_col>;
```

### 3) Duplicate business keys in runtime
```sql
SELECT <business_key>, COUNT(*) AS c
FROM <runtime_table>
GROUP BY <business_key>
HAVING COUNT(*) > 1
ORDER BY c DESC, <business_key>;
```

### 4) Unresolved FK links
```sql
SELECT COUNT(*) AS unresolved_fk
FROM <child_runtime> c
LEFT JOIN <parent_runtime> p ON p.id = c.<parent_id_fk>
WHERE c.<parent_id_fk> IS NOT NULL
  AND p.id IS NULL;
```

### 5) Mojibake scan (text columns)
```sql
SELECT
  SUM(<col1> REGEXP 'Ã.|Â.|â€™|â€“|â€œ|â€|�') AS bad_col1,
  SUM(<col2> REGEXP 'Ã.|Â.|â€™|â€“|â€œ|â€|�') AS bad_col2
FROM <runtime_table>;
```

---

## Products-Specific Checks

### Parity
```sql
SELECT COUNT(*) AS staged_rows FROM syntec_products_staging;
SELECT COUNT(*) AS runtime_rows FROM syntec_products;
```

### Unresolved supplier links
```sql
SELECT COUNT(*) AS unresolved_supplier_links
FROM syntec_products
WHERE oracle_supplier_code IS NOT NULL
  AND supplier_id IS NULL;
```

### Duplicates on product_code
```sql
SELECT product_code, COUNT(*) AS c
FROM syntec_products
GROUP BY product_code
HAVING COUNT(*) > 1
ORDER BY product_code;
```

### Slug uniqueness sanity
```sql
SELECT slug, COUNT(*) AS c
FROM syntec_products
GROUP BY slug
HAVING COUNT(*) > 1
ORDER BY c DESC, slug;
```

---

## Suppliers-Specific Checks

### Duplicates on supplier_code
```sql
SELECT supplier_code, COUNT(*) AS c
FROM syntec_suppliers
GROUP BY supplier_code
HAVING COUNT(*) > 1
ORDER BY supplier_code;
```

### Staging vs runtime mapping check
```sql
SELECT st.supplier_id, st.supplier_name
FROM syntec_suppliers_staging st
LEFT JOIN syntec_suppliers s
  ON s.supplier_code = st.supplier_id
WHERE s.id IS NULL
ORDER BY st.supplier_id;
```

---

## Constraint Application Guidance
- Do not add unique constraints until duplicates are resolved.
- Do not set strict `NOT NULL` FK constraints until unresolved links are zero.
- Apply CHECK constraints after value cleanup (`Y/N`, `0/1`, etc.).

---

## Icon Token Rewrite (Products Rich Text)
Script: `database/mysql/005c_products_fa_to_lucide_tabler.sql`

Run after product migration, then verify unresolved classes:
```sql
SELECT id, product_code
FROM syntec_products
WHERE long_description REGEXP 'fa-[a-z0-9-]+'
   OR short_description REGEXP 'fa-[a-z0-9-]+'
ORDER BY id;
```

---

## Admin/UI Dependencies After Imports
- Products admin supplier dropdown should read from `syntec_suppliers` (`id`, `supplier_code`, `name`).
- Facet API should wait until categories/applications and join tables are fully imported and validated.

---

## Handoff Notes For Next Agent
- Keep using `syntec_` table namespace.
- Preserve already-fixed product slug logic in `005b`.
- Do not remove legacy table CSS hard overrides until all global CSS conflicts are audited.
- If parity differs, do anti-join checks before re-running imports.
