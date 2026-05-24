-- Convert embedded FA icon classes in syntec_products HTML to icon-token placeholders
-- Token format inserted into class attr: icon-token lucide:<name>

-- Apply one mapping at a time to avoid deep nested REPLACE syntax errors.

UPDATE syntec_products SET long_description = REPLACE(long_description, 'fa-layer-group', 'icon-token lucide:layers') WHERE long_description LIKE '%fa-layer-group%';
UPDATE syntec_products SET long_description = REPLACE(long_description, 'fa-crosshairs', 'icon-token lucide:crosshair') WHERE long_description LIKE '%fa-crosshairs%';
UPDATE syntec_products SET long_description = REPLACE(long_description, 'fa-circle', 'icon-token lucide:circle') WHERE long_description LIKE '%fa-circle%';
UPDATE syntec_products SET long_description = REPLACE(long_description, 'fa-check-circle', 'icon-token lucide:circle-check') WHERE long_description LIKE '%fa-check-circle%';
UPDATE syntec_products SET long_description = REPLACE(long_description, 'fa-check', 'icon-token lucide:check') WHERE long_description LIKE '%fa-check%';
UPDATE syntec_products SET long_description = REPLACE(long_description, 'fa-align-justify', 'icon-token lucide:align-justify') WHERE long_description LIKE '%fa-align-justify%';
UPDATE syntec_products SET long_description = REPLACE(long_description, 'fa-camera', 'icon-token lucide:camera') WHERE long_description LIKE '%fa-camera%';
UPDATE syntec_products SET long_description = REPLACE(long_description, 'fa-video-camera', 'icon-token lucide:video') WHERE long_description LIKE '%fa-video-camera%';
UPDATE syntec_products SET long_description = REPLACE(long_description, 'fa-video', 'icon-token lucide:video') WHERE long_description LIKE '%fa-video%';
UPDATE syntec_products SET long_description = REPLACE(long_description, 'fa-file-pdf-o', 'icon-token lucide:file-text') WHERE long_description LIKE '%fa-file-pdf-o%';
UPDATE syntec_products SET long_description = REPLACE(long_description, 'fa-file-alt', 'icon-token lucide:file-text') WHERE long_description LIKE '%fa-file-alt%';
UPDATE syntec_products SET long_description = REPLACE(long_description, 'fa-cogs', 'icon-token lucide:cog') WHERE long_description LIKE '%fa-cogs%';
UPDATE syntec_products SET long_description = REPLACE(long_description, 'fa-screwdriver-wrench', 'icon-token lucide:wrench') WHERE long_description LIKE '%fa-screwdriver-wrench%';
UPDATE syntec_products SET long_description = REPLACE(long_description, 'fa-toolbox', 'icon-token lucide:briefcase-business') WHERE long_description LIKE '%fa-toolbox%';
UPDATE syntec_products SET long_description = REPLACE(long_description, 'fa-wrench', 'icon-token lucide:wrench') WHERE long_description LIKE '%fa-wrench%';
UPDATE syntec_products SET long_description = REPLACE(long_description, 'fa-info-circle', 'icon-token lucide:info') WHERE long_description LIKE '%fa-info-circle%';
UPDATE syntec_products SET long_description = REPLACE(long_description, 'fa-leaf', 'icon-token lucide:leaf') WHERE long_description LIKE '%fa-leaf%';
UPDATE syntec_products SET long_description = REPLACE(long_description, 'fa-snowflake', 'icon-token lucide:snowflake') WHERE long_description LIKE '%fa-snowflake%';
UPDATE syntec_products SET long_description = REPLACE(long_description, 'fa-shield-alt', 'icon-token lucide:shield') WHERE long_description LIKE '%fa-shield-alt%';
UPDATE syntec_products SET long_description = REPLACE(long_description, 'fa-star', 'icon-token lucide:star') WHERE long_description LIKE '%fa-star%';
UPDATE syntec_products SET long_description = REPLACE(long_description, 'fa-lightbulb', 'icon-token lucide:lightbulb') WHERE long_description LIKE '%fa-lightbulb%';
UPDATE syntec_products SET long_description = REPLACE(long_description, 'fa-award', 'icon-token lucide:award') WHERE long_description LIKE '%fa-award%';
UPDATE syntec_products SET long_description = REPLACE(long_description, 'fa-hands', 'icon-token lucide:hand') WHERE long_description LIKE '%fa-hands%';
UPDATE syntec_products SET long_description = REPLACE(long_description, 'fa-hand-holding-medical', 'icon-token lucide:hand-heart') WHERE long_description LIKE '%fa-hand-holding-medical%';
UPDATE syntec_products SET long_description = REPLACE(long_description, 'fa-hand-holding', 'icon-token lucide:hand') WHERE long_description LIKE '%fa-hand-holding%';
UPDATE syntec_products SET long_description = REPLACE(long_description, 'fa-dumbbell', 'icon-token lucide:dumbbell') WHERE long_description LIKE '%fa-dumbbell%';
UPDATE syntec_products SET long_description = REPLACE(long_description, 'fa-bullseye', 'icon-token lucide:target') WHERE long_description LIKE '%fa-bullseye%';
UPDATE syntec_products SET long_description = REPLACE(long_description, 'fa-chevron-down', 'icon-token lucide:chevron-down') WHERE long_description LIKE '%fa-chevron-down%';
UPDATE syntec_products SET long_description = REPLACE(long_description, 'fa-chevron-up', 'icon-token lucide:chevron-up') WHERE long_description LIKE '%fa-chevron-up%';
UPDATE syntec_products SET long_description = REPLACE(long_description, 'fa-chevron-left', 'icon-token lucide:chevron-left') WHERE long_description LIKE '%fa-chevron-left%';
UPDATE syntec_products SET long_description = REPLACE(long_description, 'fa-chevron-right', 'icon-token lucide:chevron-right') WHERE long_description LIKE '%fa-chevron-right%';
UPDATE syntec_products SET long_description = REPLACE(long_description, 'fa-plus-circle', 'icon-token lucide:circle-plus') WHERE long_description LIKE '%fa-plus-circle%';
UPDATE syntec_products SET long_description = REPLACE(long_description, 'fa-minus-circle', 'icon-token lucide:circle-minus') WHERE long_description LIKE '%fa-minus-circle%';
UPDATE syntec_products SET long_description = REPLACE(long_description, 'fa-plus', 'icon-token lucide:plus') WHERE long_description LIKE '%fa-plus%';
UPDATE syntec_products SET long_description = REPLACE(long_description, 'fa-minus', 'icon-token lucide:minus') WHERE long_description LIKE '%fa-minus%';
UPDATE syntec_products SET long_description = REPLACE(long_description, 'fa-puzzle-piece', 'icon-token lucide:puzzle') WHERE long_description LIKE '%fa-puzzle-piece%';
UPDATE syntec_products SET long_description = REPLACE(long_description, 'fa-stream', 'icon-token lucide:rows-3') WHERE long_description LIKE '%fa-stream%';
UPDATE syntec_products SET long_description = REPLACE(long_description, 'fa-gem', 'icon-token lucide:gem') WHERE long_description LIKE '%fa-gem%';
UPDATE syntec_products SET long_description = REPLACE(long_description, 'fa-stethoscope', 'icon-token lucide:stethoscope') WHERE long_description LIKE '%fa-stethoscope%';
UPDATE syntec_products SET long_description = REPLACE(long_description, 'fa-scale-balanced', 'icon-token lucide:scale') WHERE long_description LIKE '%fa-scale-balanced%';

UPDATE syntec_products SET short_description = REPLACE(short_description, 'fa-layer-group', 'icon-token lucide:layers') WHERE short_description LIKE '%fa-layer-group%';
UPDATE syntec_products SET short_description = REPLACE(short_description, 'fa-crosshairs', 'icon-token lucide:crosshair') WHERE short_description LIKE '%fa-crosshairs%';
UPDATE syntec_products SET short_description = REPLACE(short_description, 'fa-circle', 'icon-token lucide:circle') WHERE short_description LIKE '%fa-circle%';
UPDATE syntec_products SET short_description = REPLACE(short_description, 'fa-check-circle', 'icon-token lucide:circle-check') WHERE short_description LIKE '%fa-check-circle%';
UPDATE syntec_products SET short_description = REPLACE(short_description, 'fa-check', 'icon-token lucide:check') WHERE short_description LIKE '%fa-check%';
UPDATE syntec_products SET short_description = REPLACE(short_description, 'fa-align-justify', 'icon-token lucide:align-justify') WHERE short_description LIKE '%fa-align-justify%';
UPDATE syntec_products SET short_description = REPLACE(short_description, 'fa-camera', 'icon-token lucide:camera') WHERE short_description LIKE '%fa-camera%';
UPDATE syntec_products SET short_description = REPLACE(short_description, 'fa-video-camera', 'icon-token lucide:video') WHERE short_description LIKE '%fa-video-camera%';
UPDATE syntec_products SET short_description = REPLACE(short_description, 'fa-video', 'icon-token lucide:video') WHERE short_description LIKE '%fa-video%';
UPDATE syntec_products SET short_description = REPLACE(short_description, 'fa-file-pdf-o', 'icon-token lucide:file-text') WHERE short_description LIKE '%fa-file-pdf-o%';
UPDATE syntec_products SET short_description = REPLACE(short_description, 'fa-file-alt', 'icon-token lucide:file-text') WHERE short_description LIKE '%fa-file-alt%';
UPDATE syntec_products SET short_description = REPLACE(short_description, 'fa-cogs', 'icon-token lucide:cog') WHERE short_description LIKE '%fa-cogs%';
UPDATE syntec_products SET short_description = REPLACE(short_description, 'fa-screwdriver-wrench', 'icon-token lucide:wrench') WHERE short_description LIKE '%fa-screwdriver-wrench%';
UPDATE syntec_products SET short_description = REPLACE(short_description, 'fa-toolbox', 'icon-token lucide:briefcase-business') WHERE short_description LIKE '%fa-toolbox%';
UPDATE syntec_products SET short_description = REPLACE(short_description, 'fa-wrench', 'icon-token lucide:wrench') WHERE short_description LIKE '%fa-wrench%';
UPDATE syntec_products SET short_description = REPLACE(short_description, 'fa-info-circle', 'icon-token lucide:info') WHERE short_description LIKE '%fa-info-circle%';
UPDATE syntec_products SET short_description = REPLACE(short_description, 'fa-leaf', 'icon-token lucide:leaf') WHERE short_description LIKE '%fa-leaf%';
UPDATE syntec_products SET short_description = REPLACE(short_description, 'fa-snowflake', 'icon-token lucide:snowflake') WHERE short_description LIKE '%fa-snowflake%';
UPDATE syntec_products SET short_description = REPLACE(short_description, 'fa-shield-alt', 'icon-token lucide:shield') WHERE short_description LIKE '%fa-shield-alt%';
UPDATE syntec_products SET short_description = REPLACE(short_description, 'fa-star', 'icon-token lucide:star') WHERE short_description LIKE '%fa-star%';
UPDATE syntec_products SET short_description = REPLACE(short_description, 'fa-lightbulb', 'icon-token lucide:lightbulb') WHERE short_description LIKE '%fa-lightbulb%';
UPDATE syntec_products SET short_description = REPLACE(short_description, 'fa-award', 'icon-token lucide:award') WHERE short_description LIKE '%fa-award%';
UPDATE syntec_products SET short_description = REPLACE(short_description, 'fa-hands', 'icon-token lucide:hand') WHERE short_description LIKE '%fa-hands%';
UPDATE syntec_products SET short_description = REPLACE(short_description, 'fa-hand-holding-medical', 'icon-token lucide:hand-heart') WHERE short_description LIKE '%fa-hand-holding-medical%';
UPDATE syntec_products SET short_description = REPLACE(short_description, 'fa-hand-holding', 'icon-token lucide:hand') WHERE short_description LIKE '%fa-hand-holding%';
UPDATE syntec_products SET short_description = REPLACE(short_description, 'fa-dumbbell', 'icon-token lucide:dumbbell') WHERE short_description LIKE '%fa-dumbbell%';
UPDATE syntec_products SET short_description = REPLACE(short_description, 'fa-bullseye', 'icon-token lucide:target') WHERE short_description LIKE '%fa-bullseye%';
UPDATE syntec_products SET short_description = REPLACE(short_description, 'fa-chevron-down', 'icon-token lucide:chevron-down') WHERE short_description LIKE '%fa-chevron-down%';
UPDATE syntec_products SET short_description = REPLACE(short_description, 'fa-chevron-up', 'icon-token lucide:chevron-up') WHERE short_description LIKE '%fa-chevron-up%';
UPDATE syntec_products SET short_description = REPLACE(short_description, 'fa-chevron-left', 'icon-token lucide:chevron-left') WHERE short_description LIKE '%fa-chevron-left%';
UPDATE syntec_products SET short_description = REPLACE(short_description, 'fa-chevron-right', 'icon-token lucide:chevron-right') WHERE short_description LIKE '%fa-chevron-right%';
UPDATE syntec_products SET short_description = REPLACE(short_description, 'fa-plus-circle', 'icon-token lucide:circle-plus') WHERE short_description LIKE '%fa-plus-circle%';
UPDATE syntec_products SET short_description = REPLACE(short_description, 'fa-minus-circle', 'icon-token lucide:circle-minus') WHERE short_description LIKE '%fa-minus-circle%';
UPDATE syntec_products SET short_description = REPLACE(short_description, 'fa-plus', 'icon-token lucide:plus') WHERE short_description LIKE '%fa-plus%';
UPDATE syntec_products SET short_description = REPLACE(short_description, 'fa-minus', 'icon-token lucide:minus') WHERE short_description LIKE '%fa-minus%';
UPDATE syntec_products SET short_description = REPLACE(short_description, 'fa-puzzle-piece', 'icon-token lucide:puzzle') WHERE short_description LIKE '%fa-puzzle-piece%';
UPDATE syntec_products SET short_description = REPLACE(short_description, 'fa-stream', 'icon-token lucide:rows-3') WHERE short_description LIKE '%fa-stream%';
UPDATE syntec_products SET short_description = REPLACE(short_description, 'fa-gem', 'icon-token lucide:gem') WHERE short_description LIKE '%fa-gem%';
UPDATE syntec_products SET short_description = REPLACE(short_description, 'fa-stethoscope', 'icon-token lucide:stethoscope') WHERE short_description LIKE '%fa-stethoscope%';
UPDATE syntec_products SET short_description = REPLACE(short_description, 'fa-scale-balanced', 'icon-token lucide:scale') WHERE short_description LIKE '%fa-scale-balanced%';

-- Remove base FA markers after token rewrite
UPDATE syntec_products
SET long_description = REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(long_description, 'fa-custom', ''), 'fa-solid', ''), 'fas', ''), 'far', ''), 'fab', ''),
    short_description = REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(short_description, 'fa-custom', ''), 'fa-solid', ''), 'fas', ''), 'far', ''), 'fab', '')
WHERE long_description LIKE '%fa-%' OR short_description LIKE '%fa-%';

-- Review unresolved project-specific fa-* remnants
SELECT id, product_code
FROM syntec_products
WHERE long_description REGEXP 'fa-[a-z0-9-]+'
   OR short_description REGEXP 'fa-[a-z0-9-]+'
ORDER BY id;
