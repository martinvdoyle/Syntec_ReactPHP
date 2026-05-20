CREATE TABLE IF NOT EXISTS syntec_menu_items (
  id BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
  parent_id BIGINT UNSIGNED NULL,
  menu_key VARCHAR(64) NOT NULL,
  title VARCHAR(255) NOT NULL,
  url VARCHAR(1024) NULL,
  route VARCHAR(255) NULL,
  menu_type ENUM('standard','dropdown','mega','external','separator','heading','link','group') NOT NULL DEFAULT 'standard',
  description TEXT NULL,
  image_path VARCHAR(1024) NULL,
  sort_order INT NOT NULL DEFAULT 0,
  visible TINYINT(1) NOT NULL DEFAULT 1,
  target VARCHAR(32) NOT NULL DEFAULT '_self',
  css_class VARCHAR(255) NULL,
  created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (id),
  KEY idx_menu_key_parent_sort (menu_key, parent_id, sort_order),
  KEY idx_visible (visible),
  CONSTRAINT fk_syntec_menu_parent
    FOREIGN KEY (parent_id)
    REFERENCES syntec_menu_items(id)
    ON DELETE SET NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

INSERT INTO syntec_menu_items (id, parent_id, menu_key, title, route, menu_type, sort_order, visible, target)
VALUES
  (1, NULL, 'main', 'Home', '/', 'standard', 10, 1, '_self'),
  (2, NULL, 'main', 'Suppliers', '/suppliers', 'mega', 20, 1, '_self'),
  (3, NULL, 'main', 'Products', '/products', 'mega', 30, 1, '_self'),
  (4, NULL, 'main', 'Contact', '/contact', 'standard', 40, 1, '_self')
ON DUPLICATE KEY UPDATE
  title = VALUES(title),
  route = VALUES(route),
  menu_type = VALUES(menu_type),
  sort_order = VALUES(sort_order),
  visible = VALUES(visible),
  target = VALUES(target);
