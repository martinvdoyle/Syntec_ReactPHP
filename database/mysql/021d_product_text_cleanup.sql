-- Optional post-load cleanup for known mojibake sequences in product text fields.
-- Run after 021c. Deterministic replacements only.

UPDATE syntec_products
SET
  product_name = REPLACE(REPLACE(REPLACE(REPLACE(product_name, 'â€™', '’'), 'â€“', '–'), 'â€œ', '“'), 'â€', '”'),
  about_1 = REPLACE(REPLACE(REPLACE(REPLACE(about_1, 'â€™', '’'), 'â€“', '–'), 'â€œ', '“'), 'â€', '”'),
  about_2 = REPLACE(REPLACE(REPLACE(REPLACE(about_2, 'â€™', '’'), 'â€“', '–'), 'â€œ', '“'), 'â€', '”');

UPDATE syntec_products
SET
  product_name = REPLACE(product_name, 'Â', ''),
  about_1 = REPLACE(about_1, 'Â', ''),
  about_2 = REPLACE(about_2, 'Â', '');

