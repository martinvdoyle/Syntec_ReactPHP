/* Convert legacy APEX/FA icon_class values to prefixed Lucide/Tabler keys */
UPDATE syntec_menu_items
SET icon_class = CASE
  WHEN icon_class IS NULL OR TRIM(icon_class) = '' THEN icon_class

  /* already converted */
  WHEN LOWER(icon_class) LIKE 'lucide:%' THEN icon_class
  WHEN LOWER(icon_class) LIKE 'tabler:%' THEN icon_class

  /* specific mappings */
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

  /* generic cleanup fallbacks */
  WHEN LOWER(icon_class) LIKE '%microscope%' THEN 'tabler:microscope'
  WHEN LOWER(icon_class) LIKE '%virus%' THEN 'tabler:virus'
  WHEN LOWER(icon_class) LIKE '%dna%' THEN 'lucide:dna'
  WHEN LOWER(icon_class) LIKE '%flask%' THEN 'lucide:flask-conical'
  WHEN LOWER(icon_class) LIKE '%syringe%' THEN 'tabler:syringe'
  WHEN LOWER(icon_class) LIKE '%truck%' THEN 'lucide:truck'
  WHEN LOWER(icon_class) LIKE '%network%' THEN 'lucide:network'
  WHEN LOWER(icon_class) LIKE '%building%' THEN 'lucide:building-2'

  /* if unknown, keep original for manual review */
  ELSE icon_class
END;

/* Quick review of what remains unconverted */
SELECT DISTINCT icon_class
FROM syntec_menu_items
WHERE icon_class IS NOT NULL
  AND TRIM(icon_class) <> ''
  AND LOWER(icon_class) NOT LIKE 'lucide:%'
  AND LOWER(icon_class) NOT LIKE 'tabler:%'
ORDER BY icon_class;
