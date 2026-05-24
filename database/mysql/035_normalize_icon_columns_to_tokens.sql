-- Normalize remaining icon columns to project icon tokens (lucide:/tabler:)
-- Targets:
--   syntec_menu_items.icon_class
--   syntec_discipline.discipline_icon_class
--   syntec_product_group.product_group_icon_class

/* =========================
   syntec_menu_items.icon_class
   ========================= */
UPDATE syntec_menu_items
SET icon_class = CASE
  WHEN icon_class IS NULL OR TRIM(icon_class) = '' THEN icon_class
  WHEN LOWER(icon_class) LIKE 'lucide:%' OR LOWER(icon_class) LIKE 'tabler:%' THEN icon_class
  WHEN LOWER(icon_class) LIKE '%fa-network-wired%' THEN 'lucide:network'
  WHEN LOWER(icon_class) LIKE '%fa-microscope%' THEN 'tabler:microscope'
  WHEN LOWER(icon_class) LIKE '%fa-head-side-virus%' THEN 'tabler:virus'
  WHEN LOWER(icon_class) LIKE '%fa-head-side-mask%' THEN 'lucide:shield-plus'
  WHEN LOWER(icon_class) LIKE '%fa-virus%' THEN 'tabler:virus'
  WHEN LOWER(icon_class) LIKE '%fa-bacterium%' THEN 'tabler:virus'
  WHEN LOWER(icon_class) LIKE '%fa-building%' THEN 'lucide:building-2'
  WHEN LOWER(icon_class) LIKE '%fa-atom%' THEN 'lucide:atom'
  WHEN LOWER(icon_class) LIKE '%fa-snowflake%' THEN 'lucide:snowflake'
  WHEN LOWER(icon_class) LIKE '%fa-recycle%' THEN 'lucide:recycle'
  WHEN LOWER(icon_class) LIKE '%fa-droplet%' THEN 'lucide:droplets'
  WHEN LOWER(icon_class) LIKE '%fa-water%' THEN 'lucide:droplets'
  WHEN LOWER(icon_class) LIKE '%fa-tint%' THEN 'lucide:droplets'
  WHEN LOWER(icon_class) LIKE '%fa-dna%' THEN 'lucide:dna'
  WHEN LOWER(icon_class) LIKE '%fa-vials%' THEN 'lucide:flask-conical'
  WHEN LOWER(icon_class) LIKE '%fa-vial%' THEN 'lucide:flask-conical'
  WHEN LOWER(icon_class) LIKE '%fa-flask-vial%' THEN 'lucide:flask-conical'
  WHEN LOWER(icon_class) LIKE '%fa-pills%' THEN 'lucide:pill'
  WHEN LOWER(icon_class) LIKE '%fa-prescription-bottle%' THEN 'lucide:pill-bottle'
  WHEN LOWER(icon_class) LIKE '%fa-inbox%' THEN 'lucide:package'
  WHEN LOWER(icon_class) LIKE '%fa-boxes-packing%' THEN 'lucide:package'
  WHEN LOWER(icon_class) LIKE '%fa-box%' THEN 'lucide:package'
  WHEN LOWER(icon_class) LIKE '%fa-keyboard%' THEN 'lucide:keyboard'
  WHEN LOWER(icon_class) LIKE '%fa-location%' THEN 'lucide:map-pin'
  WHEN LOWER(icon_class) LIKE '%fa-temperature-low%' THEN 'lucide:thermometer'
  WHEN LOWER(icon_class) LIKE '%fa-thermometer-half%' THEN 'lucide:thermometer'
  WHEN LOWER(icon_class) LIKE '%fa-syringe%' THEN 'tabler:syringe'
  WHEN LOWER(icon_class) LIKE '%fa-kit-medical%' THEN 'lucide:briefcase-medical'
  WHEN LOWER(icon_class) LIKE '%fa-tags%' THEN 'lucide:tags'
  WHEN LOWER(icon_class) LIKE '%fa-cogs%' THEN 'lucide:cog'
  WHEN LOWER(icon_class) LIKE '%fa-truck%' THEN 'lucide:truck'
  WHEN LOWER(icon_class) LIKE '%fa-users%' THEN 'lucide:users'
  WHEN LOWER(icon_class) LIKE '%fa-eye-dropper%' THEN 'lucide:pipette'
  WHEN LOWER(icon_class) LIKE '%fa-bottle-water%' THEN 'lucide:bottle-wine'
  WHEN LOWER(icon_class) LIKE '%fa-disease%' THEN 'tabler:virus'
  WHEN LOWER(icon_class) LIKE '%fa-hard-drive%' THEN 'lucide:hard-drive'
  WHEN LOWER(icon_class) LIKE '%fa-hands%' THEN 'lucide:hand'
  WHEN LOWER(icon_class) LIKE '%fa-person-running%' THEN 'lucide:person-standing'
  WHEN LOWER(icon_class) LIKE '%fa-running%' THEN 'lucide:person-standing'
  WHEN LOWER(icon_class) LIKE '%fa-walking%' THEN 'lucide:person-standing'
  WHEN LOWER(icon_class) LIKE '%fa-spa%' THEN 'lucide:leaf'
  WHEN LOWER(icon_class) LIKE '%fa-fan%' THEN 'lucide:wind'
  WHEN LOWER(icon_class) LIKE '%fa-chart-line%' THEN 'lucide:trending-up'
  WHEN LOWER(icon_class) LIKE '%microscope%' THEN 'tabler:microscope'
  WHEN LOWER(icon_class) LIKE '%virus%' THEN 'tabler:virus'
  WHEN LOWER(icon_class) LIKE '%dna%' THEN 'lucide:dna'
  WHEN LOWER(icon_class) LIKE '%flask%' THEN 'lucide:flask-conical'
  WHEN LOWER(icon_class) LIKE '%syringe%' THEN 'tabler:syringe'
  WHEN LOWER(icon_class) LIKE '%truck%' THEN 'lucide:truck'
  WHEN LOWER(icon_class) LIKE '%network%' THEN 'lucide:network'
  WHEN LOWER(icon_class) LIKE '%building%' THEN 'lucide:building-2'
  ELSE icon_class
END;

/* =========================
   syntec_discipline.discipline_icon_class
   ========================= */
UPDATE syntec_discipline
SET discipline_icon_class = CASE
  WHEN discipline_icon_class IS NULL OR TRIM(discipline_icon_class) = '' THEN discipline_icon_class
  WHEN LOWER(discipline_icon_class) LIKE 'lucide:%' OR LOWER(discipline_icon_class) LIKE 'tabler:%' THEN discipline_icon_class
  WHEN LOWER(discipline_icon_class) LIKE '%fa-microscope%' THEN 'tabler:microscope'
  WHEN LOWER(discipline_icon_class) LIKE '%fa-virus%' THEN 'tabler:virus'
  WHEN LOWER(discipline_icon_class) LIKE '%fa-dna%' THEN 'lucide:dna'
  WHEN LOWER(discipline_icon_class) LIKE '%fa-flask%' THEN 'lucide:flask-conical'
  WHEN LOWER(discipline_icon_class) LIKE '%fa-syringe%' THEN 'tabler:syringe'
  WHEN LOWER(discipline_icon_class) LIKE '%fa-snowflake%' THEN 'lucide:snowflake'
  WHEN LOWER(discipline_icon_class) LIKE '%fa-leaf%' THEN 'lucide:leaf'
  ELSE discipline_icon_class
END;

/* =========================
   syntec_product_group.product_group_icon_class
   ========================= */
UPDATE syntec_product_group
SET product_group_icon_class = CASE
  WHEN product_group_icon_class IS NULL OR TRIM(product_group_icon_class) = '' THEN product_group_icon_class
  WHEN LOWER(product_group_icon_class) LIKE 'lucide:%' OR LOWER(product_group_icon_class) LIKE 'tabler:%' THEN product_group_icon_class
  WHEN LOWER(product_group_icon_class) LIKE '%fa-microscope%' THEN 'tabler:microscope'
  WHEN LOWER(product_group_icon_class) LIKE '%fa-virus%' THEN 'tabler:virus'
  WHEN LOWER(product_group_icon_class) LIKE '%fa-dna%' THEN 'lucide:dna'
  WHEN LOWER(product_group_icon_class) LIKE '%fa-flask%' THEN 'lucide:flask-conical'
  WHEN LOWER(product_group_icon_class) LIKE '%fa-syringe%' THEN 'tabler:syringe'
  WHEN LOWER(product_group_icon_class) LIKE '%fa-building%' THEN 'lucide:building-2'
  WHEN LOWER(product_group_icon_class) LIKE '%fa-cogs%' THEN 'lucide:cog'
  WHEN LOWER(product_group_icon_class) LIKE '%fa-box%' THEN 'lucide:package'
  ELSE product_group_icon_class
END;

/* =========================
   Verification
   ========================= */
SELECT 'menu_icons_non_token' AS check_name, COUNT(*) AS cnt
FROM syntec_menu_items
WHERE icon_class IS NOT NULL
  AND TRIM(icon_class) <> ''
  AND LOWER(icon_class) NOT LIKE 'lucide:%'
  AND LOWER(icon_class) NOT LIKE 'tabler:%'
UNION ALL
SELECT 'discipline_icons_non_token', COUNT(*)
FROM syntec_discipline
WHERE discipline_icon_class IS NOT NULL
  AND TRIM(discipline_icon_class) <> ''
  AND LOWER(discipline_icon_class) NOT LIKE 'lucide:%'
  AND LOWER(discipline_icon_class) NOT LIKE 'tabler:%'
UNION ALL
SELECT 'product_group_icons_non_token', COUNT(*)
FROM syntec_product_group
WHERE product_group_icon_class IS NOT NULL
  AND TRIM(product_group_icon_class) <> ''
  AND LOWER(product_group_icon_class) NOT LIKE 'lucide:%'
  AND LOWER(product_group_icon_class) NOT LIKE 'tabler:%';

