-- Generated from Oracle_Exports/SUPPLIERS_DATA_TABLE.sql
-- Best-effort FR/IT translation placeholders (no external API).

INSERT INTO syntec_suppliers_i18n (supplier_id, lang, profile_1, profile_2)
VALUES

ON DUPLICATE KEY UPDATE
  profile_1 = VALUES(profile_1),
  profile_2 = VALUES(profile_2),
  updated_at = CURRENT_TIMESTAMP;
