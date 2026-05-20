/* Set icon for Scientific Portfolio menu item */
UPDATE syntec_menu_items
SET icon_class = 'lucide:briefcase'
WHERE LOWER(COALESCE(sub_menu_name, menu_name, title)) = 'scientific portfolio';

/* Verify */
SELECT id, menu_name, sub_menu_name, title, icon_class
FROM syntec_menu_items
WHERE LOWER(COALESCE(sub_menu_name, menu_name, title)) = 'scientific portfolio';
