-- Convert legacy Font Awesome icon classes in supplier profile HTML
-- Targets: syntec_suppliers.profile_1, syntec_suppliers.profile_2

/* =========================
   PROFILE_1
   ========================= */
UPDATE syntec_suppliers SET profile_1 = REPLACE(profile_1, 'fa-chevron-down', 'icon-token lucide:chevron-down') WHERE profile_1 LIKE '%fa-chevron-down%';
UPDATE syntec_suppliers SET profile_1 = REPLACE(profile_1, 'fa-chevron-up', 'icon-token lucide:chevron-up') WHERE profile_1 LIKE '%fa-chevron-up%';
UPDATE syntec_suppliers SET profile_1 = REPLACE(profile_1, 'fa-chevron-left', 'icon-token lucide:chevron-left') WHERE profile_1 LIKE '%fa-chevron-left%';
UPDATE syntec_suppliers SET profile_1 = REPLACE(profile_1, 'fa-chevron-right', 'icon-token lucide:chevron-right') WHERE profile_1 LIKE '%fa-chevron-right%';
UPDATE syntec_suppliers SET profile_1 = REPLACE(profile_1, 'fa-circle', 'icon-token lucide:circle') WHERE profile_1 LIKE '%fa-circle%';
UPDATE syntec_suppliers SET profile_1 = REPLACE(profile_1, 'fa-check-circle', 'icon-token lucide:circle-check') WHERE profile_1 LIKE '%fa-check-circle%';
UPDATE syntec_suppliers SET profile_1 = REPLACE(profile_1, 'fa-check', 'icon-token lucide:check') WHERE profile_1 LIKE '%fa-check%';
UPDATE syntec_suppliers SET profile_1 = REPLACE(profile_1, 'fa-info-circle', 'icon-token lucide:info') WHERE profile_1 LIKE '%fa-info-circle%';
UPDATE syntec_suppliers SET profile_1 = REPLACE(profile_1, 'fa-plus', 'icon-token lucide:plus') WHERE profile_1 LIKE '%fa-plus%';
UPDATE syntec_suppliers SET profile_1 = REPLACE(profile_1, 'fa-minus', 'icon-token lucide:minus') WHERE profile_1 LIKE '%fa-minus%';
UPDATE syntec_suppliers SET profile_1 = REPLACE(profile_1, 'fa-angle-down', 'icon-token lucide:chevron-down') WHERE profile_1 LIKE '%fa-angle-down%';
UPDATE syntec_suppliers SET profile_1 = REPLACE(profile_1, 'fa-angle-up', 'icon-token lucide:chevron-up') WHERE profile_1 LIKE '%fa-angle-up%';

/* =========================
   PROFILE_2
   ========================= */
UPDATE syntec_suppliers SET profile_2 = REPLACE(profile_2, 'fa-chevron-down', 'icon-token lucide:chevron-down') WHERE profile_2 LIKE '%fa-chevron-down%';
UPDATE syntec_suppliers SET profile_2 = REPLACE(profile_2, 'fa-chevron-up', 'icon-token lucide:chevron-up') WHERE profile_2 LIKE '%fa-chevron-up%';
UPDATE syntec_suppliers SET profile_2 = REPLACE(profile_2, 'fa-chevron-left', 'icon-token lucide:chevron-left') WHERE profile_2 LIKE '%fa-chevron-left%';
UPDATE syntec_suppliers SET profile_2 = REPLACE(profile_2, 'fa-chevron-right', 'icon-token lucide:chevron-right') WHERE profile_2 LIKE '%fa-chevron-right%';
UPDATE syntec_suppliers SET profile_2 = REPLACE(profile_2, 'fa-circle', 'icon-token lucide:circle') WHERE profile_2 LIKE '%fa-circle%';
UPDATE syntec_suppliers SET profile_2 = REPLACE(profile_2, 'fa-check-circle', 'icon-token lucide:circle-check') WHERE profile_2 LIKE '%fa-check-circle%';
UPDATE syntec_suppliers SET profile_2 = REPLACE(profile_2, 'fa-check', 'icon-token lucide:check') WHERE profile_2 LIKE '%fa-check%';
UPDATE syntec_suppliers SET profile_2 = REPLACE(profile_2, 'fa-info-circle', 'icon-token lucide:info') WHERE profile_2 LIKE '%fa-info-circle%';
UPDATE syntec_suppliers SET profile_2 = REPLACE(profile_2, 'fa-plus', 'icon-token lucide:plus') WHERE profile_2 LIKE '%fa-plus%';
UPDATE syntec_suppliers SET profile_2 = REPLACE(profile_2, 'fa-minus', 'icon-token lucide:minus') WHERE profile_2 LIKE '%fa-minus%';
UPDATE syntec_suppliers SET profile_2 = REPLACE(profile_2, 'fa-angle-down', 'icon-token lucide:chevron-down') WHERE profile_2 LIKE '%fa-angle-down%';
UPDATE syntec_suppliers SET profile_2 = REPLACE(profile_2, 'fa-angle-up', 'icon-token lucide:chevron-up') WHERE profile_2 LIKE '%fa-angle-up%';

/* Remove FA library class fragments after mapping */
UPDATE syntec_suppliers
SET
  profile_1 = REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(profile_1, 'fa-custom', ''), 'fa-solid', ''), 'fas', ''), 'far', ''), 'fab', ''),
  profile_2 = REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(profile_2, 'fa-custom', ''), 'fa-solid', ''), 'fas', ''), 'far', ''), 'fab', '')
WHERE (profile_1 LIKE '%fa-%' OR profile_1 LIKE '% fas %' OR profile_1 LIKE '% far %' OR profile_1 LIKE '% fab %')
   OR (profile_2 LIKE '%fa-%' OR profile_2 LIKE '% fas %' OR profile_2 LIKE '% far %' OR profile_2 LIKE '% fab %');

/* Verification */
SELECT
  SUM(profile_1 REGEXP 'fa-[a-z0-9-]+') AS profile_1_fa_left,
  SUM(profile_2 REGEXP 'fa-[a-z0-9-]+') AS profile_2_fa_left
FROM syntec_suppliers;

