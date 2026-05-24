-- Replace legacy Font Awesome classes in Oracle-parity product HTML fields
-- with project icon-token classes (lucide/tabler).
--
-- Target columns: about_1, about_2
-- Run this after product reimport scripts.

/* =========================
   ABOUT_1
   ========================= */
UPDATE syntec_products SET about_1 = REPLACE(about_1, 'fa-layer-group', 'icon-token lucide:layers') WHERE about_1 LIKE '%fa-layer-group%';
UPDATE syntec_products SET about_1 = REPLACE(about_1, 'fa-crosshairs', 'icon-token lucide:crosshair') WHERE about_1 LIKE '%fa-crosshairs%';
UPDATE syntec_products SET about_1 = REPLACE(about_1, 'fa-check-circle', 'icon-token lucide:circle-check') WHERE about_1 LIKE '%fa-check-circle%';
UPDATE syntec_products SET about_1 = REPLACE(about_1, 'fa-circle', 'icon-token lucide:circle') WHERE about_1 LIKE '%fa-circle%';
UPDATE syntec_products SET about_1 = REPLACE(about_1, 'fa-check', 'icon-token lucide:check') WHERE about_1 LIKE '%fa-check%';
UPDATE syntec_products SET about_1 = REPLACE(about_1, 'fa-align-justify', 'icon-token lucide:align-justify') WHERE about_1 LIKE '%fa-align-justify%';
UPDATE syntec_products SET about_1 = REPLACE(about_1, 'fa-video-camera', 'icon-token lucide:video') WHERE about_1 LIKE '%fa-video-camera%';
UPDATE syntec_products SET about_1 = REPLACE(about_1, 'fa-video', 'icon-token lucide:video') WHERE about_1 LIKE '%fa-video%';
UPDATE syntec_products SET about_1 = REPLACE(about_1, 'fa-camera', 'icon-token lucide:camera') WHERE about_1 LIKE '%fa-camera%';
UPDATE syntec_products SET about_1 = REPLACE(about_1, 'fa-file-pdf-o', 'icon-token lucide:file-text') WHERE about_1 LIKE '%fa-file-pdf-o%';
UPDATE syntec_products SET about_1 = REPLACE(about_1, 'fa-file-alt', 'icon-token lucide:file-text') WHERE about_1 LIKE '%fa-file-alt%';
UPDATE syntec_products SET about_1 = REPLACE(about_1, 'fa-screwdriver-wrench', 'icon-token lucide:wrench') WHERE about_1 LIKE '%fa-screwdriver-wrench%';
UPDATE syntec_products SET about_1 = REPLACE(about_1, 'fa-cogs', 'icon-token lucide:cog') WHERE about_1 LIKE '%fa-cogs%';
UPDATE syntec_products SET about_1 = REPLACE(about_1, 'fa-wrench', 'icon-token lucide:wrench') WHERE about_1 LIKE '%fa-wrench%';
UPDATE syntec_products SET about_1 = REPLACE(about_1, 'fa-toolbox', 'icon-token lucide:briefcase-business') WHERE about_1 LIKE '%fa-toolbox%';
UPDATE syntec_products SET about_1 = REPLACE(about_1, 'fa-info-circle', 'icon-token lucide:info') WHERE about_1 LIKE '%fa-info-circle%';
UPDATE syntec_products SET about_1 = REPLACE(about_1, 'fa-chevron-down', 'icon-token lucide:chevron-down') WHERE about_1 LIKE '%fa-chevron-down%';
UPDATE syntec_products SET about_1 = REPLACE(about_1, 'fa-chevron-up', 'icon-token lucide:chevron-up') WHERE about_1 LIKE '%fa-chevron-up%';
UPDATE syntec_products SET about_1 = REPLACE(about_1, 'fa-chevron-left', 'icon-token lucide:chevron-left') WHERE about_1 LIKE '%fa-chevron-left%';
UPDATE syntec_products SET about_1 = REPLACE(about_1, 'fa-chevron-right', 'icon-token lucide:chevron-right') WHERE about_1 LIKE '%fa-chevron-right%';
UPDATE syntec_products SET about_1 = REPLACE(about_1, 'fa-plus-circle', 'icon-token lucide:circle-plus') WHERE about_1 LIKE '%fa-plus-circle%';
UPDATE syntec_products SET about_1 = REPLACE(about_1, 'fa-minus-circle', 'icon-token lucide:circle-minus') WHERE about_1 LIKE '%fa-minus-circle%';
UPDATE syntec_products SET about_1 = REPLACE(about_1, 'fa-plus', 'icon-token lucide:plus') WHERE about_1 LIKE '%fa-plus%';
UPDATE syntec_products SET about_1 = REPLACE(about_1, 'fa-minus', 'icon-token lucide:minus') WHERE about_1 LIKE '%fa-minus%';
UPDATE syntec_products SET about_1 = REPLACE(about_1, 'fa-puzzle-piece', 'icon-token lucide:puzzle') WHERE about_1 LIKE '%fa-puzzle-piece%';
UPDATE syntec_products SET about_1 = REPLACE(about_1, 'fa-dumbbell', 'icon-token lucide:dumbbell') WHERE about_1 LIKE '%fa-dumbbell%';
UPDATE syntec_products SET about_1 = REPLACE(about_1, 'fa-bullseye', 'icon-token lucide:target') WHERE about_1 LIKE '%fa-bullseye%';
UPDATE syntec_products SET about_1 = REPLACE(about_1, 'fa-hand-holding-medical', 'icon-token lucide:hand-heart') WHERE about_1 LIKE '%fa-hand-holding-medical%';
UPDATE syntec_products SET about_1 = REPLACE(about_1, 'fa-hand-holding', 'icon-token lucide:hand') WHERE about_1 LIKE '%fa-hand-holding%';
UPDATE syntec_products SET about_1 = REPLACE(about_1, 'fa-hands', 'icon-token lucide:hand') WHERE about_1 LIKE '%fa-hands%';
UPDATE syntec_products SET about_1 = REPLACE(about_1, 'fa-snowflake', 'icon-token lucide:snowflake') WHERE about_1 LIKE '%fa-snowflake%';
UPDATE syntec_products SET about_1 = REPLACE(about_1, 'fa-shield-alt', 'icon-token lucide:shield') WHERE about_1 LIKE '%fa-shield-alt%';
UPDATE syntec_products SET about_1 = REPLACE(about_1, 'fa-lightbulb', 'icon-token lucide:lightbulb') WHERE about_1 LIKE '%fa-lightbulb%';
UPDATE syntec_products SET about_1 = REPLACE(about_1, 'fa-leaf', 'icon-token lucide:leaf') WHERE about_1 LIKE '%fa-leaf%';
UPDATE syntec_products SET about_1 = REPLACE(about_1, 'fa-stethoscope', 'icon-token lucide:stethoscope') WHERE about_1 LIKE '%fa-stethoscope%';
UPDATE syntec_products SET about_1 = REPLACE(about_1, 'fa-gem', 'icon-token lucide:gem') WHERE about_1 LIKE '%fa-gem%';
UPDATE syntec_products SET about_1 = REPLACE(about_1, 'fa-award', 'icon-token lucide:award') WHERE about_1 LIKE '%fa-award%';
UPDATE syntec_products SET about_1 = REPLACE(about_1, 'fa-stream', 'icon-token lucide:rows-3') WHERE about_1 LIKE '%fa-stream%';
UPDATE syntec_products SET about_1 = REPLACE(about_1, 'fa-scale-balanced', 'icon-token lucide:scale') WHERE about_1 LIKE '%fa-scale-balanced%';

/* =========================
   ABOUT_2
   ========================= */
UPDATE syntec_products SET about_2 = REPLACE(about_2, 'fa-layer-group', 'icon-token lucide:layers') WHERE about_2 LIKE '%fa-layer-group%';
UPDATE syntec_products SET about_2 = REPLACE(about_2, 'fa-crosshairs', 'icon-token lucide:crosshair') WHERE about_2 LIKE '%fa-crosshairs%';
UPDATE syntec_products SET about_2 = REPLACE(about_2, 'fa-check-circle', 'icon-token lucide:circle-check') WHERE about_2 LIKE '%fa-check-circle%';
UPDATE syntec_products SET about_2 = REPLACE(about_2, 'fa-circle', 'icon-token lucide:circle') WHERE about_2 LIKE '%fa-circle%';
UPDATE syntec_products SET about_2 = REPLACE(about_2, 'fa-check', 'icon-token lucide:check') WHERE about_2 LIKE '%fa-check%';
UPDATE syntec_products SET about_2 = REPLACE(about_2, 'fa-align-justify', 'icon-token lucide:align-justify') WHERE about_2 LIKE '%fa-align-justify%';
UPDATE syntec_products SET about_2 = REPLACE(about_2, 'fa-video-camera', 'icon-token lucide:video') WHERE about_2 LIKE '%fa-video-camera%';
UPDATE syntec_products SET about_2 = REPLACE(about_2, 'fa-video', 'icon-token lucide:video') WHERE about_2 LIKE '%fa-video%';
UPDATE syntec_products SET about_2 = REPLACE(about_2, 'fa-camera', 'icon-token lucide:camera') WHERE about_2 LIKE '%fa-camera%';
UPDATE syntec_products SET about_2 = REPLACE(about_2, 'fa-file-pdf-o', 'icon-token lucide:file-text') WHERE about_2 LIKE '%fa-file-pdf-o%';
UPDATE syntec_products SET about_2 = REPLACE(about_2, 'fa-file-alt', 'icon-token lucide:file-text') WHERE about_2 LIKE '%fa-file-alt%';
UPDATE syntec_products SET about_2 = REPLACE(about_2, 'fa-screwdriver-wrench', 'icon-token lucide:wrench') WHERE about_2 LIKE '%fa-screwdriver-wrench%';
UPDATE syntec_products SET about_2 = REPLACE(about_2, 'fa-cogs', 'icon-token lucide:cog') WHERE about_2 LIKE '%fa-cogs%';
UPDATE syntec_products SET about_2 = REPLACE(about_2, 'fa-wrench', 'icon-token lucide:wrench') WHERE about_2 LIKE '%fa-wrench%';
UPDATE syntec_products SET about_2 = REPLACE(about_2, 'fa-toolbox', 'icon-token lucide:briefcase-business') WHERE about_2 LIKE '%fa-toolbox%';
UPDATE syntec_products SET about_2 = REPLACE(about_2, 'fa-info-circle', 'icon-token lucide:info') WHERE about_2 LIKE '%fa-info-circle%';
UPDATE syntec_products SET about_2 = REPLACE(about_2, 'fa-chevron-down', 'icon-token lucide:chevron-down') WHERE about_2 LIKE '%fa-chevron-down%';
UPDATE syntec_products SET about_2 = REPLACE(about_2, 'fa-chevron-up', 'icon-token lucide:chevron-up') WHERE about_2 LIKE '%fa-chevron-up%';
UPDATE syntec_products SET about_2 = REPLACE(about_2, 'fa-chevron-left', 'icon-token lucide:chevron-left') WHERE about_2 LIKE '%fa-chevron-left%';
UPDATE syntec_products SET about_2 = REPLACE(about_2, 'fa-chevron-right', 'icon-token lucide:chevron-right') WHERE about_2 LIKE '%fa-chevron-right%';
UPDATE syntec_products SET about_2 = REPLACE(about_2, 'fa-plus-circle', 'icon-token lucide:circle-plus') WHERE about_2 LIKE '%fa-plus-circle%';
UPDATE syntec_products SET about_2 = REPLACE(about_2, 'fa-minus-circle', 'icon-token lucide:circle-minus') WHERE about_2 LIKE '%fa-minus-circle%';
UPDATE syntec_products SET about_2 = REPLACE(about_2, 'fa-plus', 'icon-token lucide:plus') WHERE about_2 LIKE '%fa-plus%';
UPDATE syntec_products SET about_2 = REPLACE(about_2, 'fa-minus', 'icon-token lucide:minus') WHERE about_2 LIKE '%fa-minus%';
UPDATE syntec_products SET about_2 = REPLACE(about_2, 'fa-puzzle-piece', 'icon-token lucide:puzzle') WHERE about_2 LIKE '%fa-puzzle-piece%';
UPDATE syntec_products SET about_2 = REPLACE(about_2, 'fa-dumbbell', 'icon-token lucide:dumbbell') WHERE about_2 LIKE '%fa-dumbbell%';
UPDATE syntec_products SET about_2 = REPLACE(about_2, 'fa-bullseye', 'icon-token lucide:target') WHERE about_2 LIKE '%fa-bullseye%';
UPDATE syntec_products SET about_2 = REPLACE(about_2, 'fa-hand-holding-medical', 'icon-token lucide:hand-heart') WHERE about_2 LIKE '%fa-hand-holding-medical%';
UPDATE syntec_products SET about_2 = REPLACE(about_2, 'fa-hand-holding', 'icon-token lucide:hand') WHERE about_2 LIKE '%fa-hand-holding%';
UPDATE syntec_products SET about_2 = REPLACE(about_2, 'fa-hands', 'icon-token lucide:hand') WHERE about_2 LIKE '%fa-hands%';
UPDATE syntec_products SET about_2 = REPLACE(about_2, 'fa-snowflake', 'icon-token lucide:snowflake') WHERE about_2 LIKE '%fa-snowflake%';
UPDATE syntec_products SET about_2 = REPLACE(about_2, 'fa-shield-alt', 'icon-token lucide:shield') WHERE about_2 LIKE '%fa-shield-alt%';
UPDATE syntec_products SET about_2 = REPLACE(about_2, 'fa-lightbulb', 'icon-token lucide:lightbulb') WHERE about_2 LIKE '%fa-lightbulb%';
UPDATE syntec_products SET about_2 = REPLACE(about_2, 'fa-leaf', 'icon-token lucide:leaf') WHERE about_2 LIKE '%fa-leaf%';
UPDATE syntec_products SET about_2 = REPLACE(about_2, 'fa-stethoscope', 'icon-token lucide:stethoscope') WHERE about_2 LIKE '%fa-stethoscope%';
UPDATE syntec_products SET about_2 = REPLACE(about_2, 'fa-gem', 'icon-token lucide:gem') WHERE about_2 LIKE '%fa-gem%';
UPDATE syntec_products SET about_2 = REPLACE(about_2, 'fa-award', 'icon-token lucide:award') WHERE about_2 LIKE '%fa-award%';
UPDATE syntec_products SET about_2 = REPLACE(about_2, 'fa-stream', 'icon-token lucide:rows-3') WHERE about_2 LIKE '%fa-stream%';
UPDATE syntec_products SET about_2 = REPLACE(about_2, 'fa-scale-balanced', 'icon-token lucide:scale') WHERE about_2 LIKE '%fa-scale-balanced%';

/* =========================
   Remove legacy FA library tokens once mapped
   ========================= */
UPDATE syntec_products
SET
  about_1 = REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(about_1, 'fa-custom', ''), 'fa-solid', ''), 'fas', ''), 'far', ''), 'fab', ''), 'fa', ''),
  about_2 = REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(about_2, 'fa-custom', ''), 'fa-solid', ''), 'fas', ''), 'far', ''), 'fab', ''), 'fa', '')
WHERE (about_1 LIKE '%fa-%' OR about_1 LIKE '% fas %' OR about_1 LIKE '% far %' OR about_1 LIKE '% fab %')
   OR (about_2 LIKE '%fa-%' OR about_2 LIKE '% fas %' OR about_2 LIKE '% far %' OR about_2 LIKE '% fab %');

/* Verification */
SELECT
  SUM(about_1 REGEXP 'fa-[a-z0-9-]+') AS about_1_fa_left,
  SUM(about_2 REGEXP 'fa-[a-z0-9-]+') AS about_2_fa_left
FROM syntec_products;
