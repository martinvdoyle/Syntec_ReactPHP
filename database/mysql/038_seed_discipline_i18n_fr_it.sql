-- Seed FR/IT translations for existing discipline records.
-- Safe to re-run (upsert behavior).

INSERT INTO syntec_discipline_i18n (discipline_id, lang, discipline_name)
VALUES
  ('DIS-0001', 'fr', 'Histopathologie'),
  ('DIS-0002', 'fr', 'Immunologie'),
  ('DIS-0003', 'fr', 'Microbiologie'),
  ('DIS-0004', 'fr', 'Diagnostic moléculaire'),
  ('DIS-0005', 'fr', 'Homogénéisation'),
  ('DIS-0006', 'fr', 'Cytométrie en flux'),
  ('DIS-0007', 'fr', 'Chirurgie régénérative'),
  ('DIS-0008', 'fr', 'Récupération sportive d''élite'),
  ('DIS-0009', 'fr', 'Tests de performance sportive'),
  ('DIS-0010', 'fr', 'Chirurgie régénérative sportive et bien-être'),
  ('DIS-0001', 'it', 'Istopatologia'),
  ('DIS-0002', 'it', 'Immunologia'),
  ('DIS-0003', 'it', 'Microbiologia'),
  ('DIS-0004', 'it', 'Diagnostica molecolare'),
  ('DIS-0005', 'it', 'Omogeneizzazione'),
  ('DIS-0006', 'it', 'Citometria a flusso'),
  ('DIS-0007', 'it', 'Chirurgia rigenerativa'),
  ('DIS-0008', 'it', 'Recupero sportivo d''élite'),
  ('DIS-0009', 'it', 'Test delle prestazioni sportive'),
  ('DIS-0010', 'it', 'Chirurgia rigenerativa sportiva e benessere')
ON DUPLICATE KEY UPDATE
  discipline_name = VALUES(discipline_name),
  updated_at = CURRENT_TIMESTAMP;
