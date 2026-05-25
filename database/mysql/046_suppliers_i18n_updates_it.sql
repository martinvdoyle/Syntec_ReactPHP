-- 046_suppliers_i18n_updates_it.sql
-- Italian update statements for supplier HTML profiles.
-- Current values are seeded from base EN; replace with refined IT as needed.

UPDATE syntec_suppliers_i18n si
JOIN syntec_suppliers s ON s.supplier_id = si.supplier_id
SET
  si.profile_1 = s.profile_1,
  si.profile_2 = s.profile_2
WHERE si.lang = 'it';
