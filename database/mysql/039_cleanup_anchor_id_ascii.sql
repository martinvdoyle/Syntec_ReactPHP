-- Cleanup anchor_id values to ASCII-safe fragment IDs.
-- Keeps Oracle-parity columns; only normalizes existing data values.
-- Pattern: lowercase, spaces/slashes -> '-', strip invalid chars, collapse dashes.

UPDATE syntec_products
SET anchor_id = NULLIF(
  TRIM(BOTH '-' FROM REGEXP_REPLACE(
    REGEXP_REPLACE(
      LOWER(REPLACE(REPLACE(TRIM(COALESCE(anchor_id, '')), ' ', '-'), '/', '-')),
      '[^a-z0-9_-]+', '-'
    ),
    '-+', '-'
  )),
  ''
)
WHERE anchor_id IS NOT NULL AND TRIM(anchor_id) <> '';

UPDATE syntec_suppliers
SET anchor_id = NULLIF(
  TRIM(BOTH '-' FROM REGEXP_REPLACE(
    REGEXP_REPLACE(
      LOWER(REPLACE(REPLACE(TRIM(COALESCE(anchor_id, '')), ' ', '-'), '/', '-')),
      '[^a-z0-9_-]+', '-'
    ),
    '-+', '-'
  )),
  ''
)
WHERE anchor_id IS NOT NULL AND TRIM(anchor_id) <> '';

UPDATE syntec_discipline
SET anchor_id = NULLIF(
  TRIM(BOTH '-' FROM REGEXP_REPLACE(
    REGEXP_REPLACE(
      LOWER(REPLACE(REPLACE(TRIM(COALESCE(anchor_id, '')), ' ', '-'), '/', '-')),
      '[^a-z0-9_-]+', '-'
    ),
    '-+', '-'
  )),
  ''
)
WHERE anchor_id IS NOT NULL AND TRIM(anchor_id) <> '';

UPDATE syntec_product_group
SET anchor_id = NULLIF(
  TRIM(BOTH '-' FROM REGEXP_REPLACE(
    REGEXP_REPLACE(
      LOWER(REPLACE(REPLACE(TRIM(COALESCE(anchor_id, '')), ' ', '-'), '/', '-')),
      '[^a-z0-9_-]+', '-'
    ),
    '-+', '-'
  )),
  ''
)
WHERE anchor_id IS NOT NULL AND TRIM(anchor_id) <> '';

UPDATE syntec_product_type
SET anchor_id = NULLIF(
  TRIM(BOTH '-' FROM REGEXP_REPLACE(
    REGEXP_REPLACE(
      LOWER(REPLACE(REPLACE(TRIM(COALESCE(anchor_id, '')), ' ', '-'), '/', '-')),
      '[^a-z0-9_-]+', '-'
    ),
    '-+', '-'
  )),
  ''
)
WHERE anchor_id IS NOT NULL AND TRIM(anchor_id) <> '';

UPDATE syntec_divisions
SET anchor_id = NULLIF(
  TRIM(BOTH '-' FROM REGEXP_REPLACE(
    REGEXP_REPLACE(
      LOWER(REPLACE(REPLACE(TRIM(COALESCE(anchor_id, '')), ' ', '-'), '/', '-')),
      '[^a-z0-9_-]+', '-'
    ),
    '-+', '-'
  )),
  ''
)
WHERE anchor_id IS NOT NULL AND TRIM(anchor_id) <> '';

UPDATE syntec_job_titles
SET anchor_id = NULLIF(
  TRIM(BOTH '-' FROM REGEXP_REPLACE(
    REGEXP_REPLACE(
      LOWER(REPLACE(REPLACE(TRIM(COALESCE(anchor_id, '')), ' ', '-'), '/', '-')),
      '[^a-z0-9_-]+', '-'
    ),
    '-+', '-'
  )),
  ''
)
WHERE anchor_id IS NOT NULL AND TRIM(anchor_id) <> '';
