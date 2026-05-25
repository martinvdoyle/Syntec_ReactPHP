-- 044_lookup_i18n_translate_fr_it.sql
-- One-off real translations for lookup i18n rows (FR/IT).
-- Requires i18n rows already seeded (043 script).

UPDATE syntec_product_type_i18n
SET product_type_name = CASE product_type_name
  WHEN 'Accessories' THEN 'Accessoires'
  WHEN 'Related Products' THEN 'Produits associes'
  WHEN 'Diagnostic Systems' THEN 'Systemes de diagnostic'
  WHEN 'Consumables' THEN 'Consommables'
  WHEN 'Reagents' THEN 'Reactifs'
  ELSE product_type_name
END
WHERE lang = 'fr';

UPDATE syntec_product_type_i18n
SET product_type_name = CASE product_type_name
  WHEN 'Accessories' THEN 'Accessori'
  WHEN 'Related Products' THEN 'Prodotti correlati'
  WHEN 'Diagnostic Systems' THEN 'Sistemi diagnostici'
  WHEN 'Consumables' THEN 'Materiali di consumo'
  WHEN 'Reagents' THEN 'Reagenti'
  ELSE product_type_name
END
WHERE lang = 'it';

UPDATE syntec_divisions_i18n
SET division_description = CASE division_description
  WHEN 'Sales' THEN 'Ventes'
  WHEN 'Logistics' THEN 'Logistique'
  WHEN 'Service' THEN 'Service'
  WHEN 'Accounts' THEN 'Comptabilite'
  WHEN 'Laboratory' THEN 'Laboratoire'
  WHEN 'Technology' THEN 'Technologie'
  ELSE division_description
END
WHERE lang = 'fr';

UPDATE syntec_divisions_i18n
SET division_description = CASE division_description
  WHEN 'Sales' THEN 'Vendite'
  WHEN 'Logistics' THEN 'Logistica'
  WHEN 'Service' THEN 'Assistenza'
  WHEN 'Accounts' THEN 'Contabilita'
  WHEN 'Laboratory' THEN 'Laboratorio'
  WHEN 'Technology' THEN 'Tecnologia'
  ELSE division_description
END
WHERE lang = 'it';

UPDATE syntec_job_titles_i18n
SET job_title_description = CASE job_title_description
  WHEN 'Founder & CEO' THEN 'Fondateur et PDG'
  WHEN 'Sales Director' THEN 'Directeur des ventes'
  WHEN 'Business Development Executive' THEN 'Responsable du developpement commercial'
  WHEN 'Product Sales Specialist' THEN 'Specialiste ventes produits'
  WHEN 'Key Account Manager' THEN 'Responsable grands comptes'
  WHEN 'General Operations Manager' THEN 'Directeur des operations'
  WHEN 'Logistics Manager' THEN 'Responsable logistique'
  WHEN 'Warehouse Logistics Operator' THEN 'Operateur logistique entrepot'
  WHEN 'Service Engineer' THEN 'Ingenieur service'
  WHEN 'Accounts Manager' THEN 'Responsable comptable'
  WHEN 'Chief Scientific Officer' THEN 'Directeur scientifique'
  WHEN 'IT Support' THEN 'Support informatique'
  ELSE job_title_description
END
WHERE lang = 'fr';

UPDATE syntec_job_titles_i18n
SET job_title_description = CASE job_title_description
  WHEN 'Founder & CEO' THEN 'Fondatore e CEO'
  WHEN 'Sales Director' THEN 'Direttore vendite'
  WHEN 'Business Development Executive' THEN 'Responsabile sviluppo commerciale'
  WHEN 'Product Sales Specialist' THEN 'Specialista vendite prodotto'
  WHEN 'Key Account Manager' THEN 'Key Account Manager'
  WHEN 'General Operations Manager' THEN 'Responsabile operativo generale'
  WHEN 'Logistics Manager' THEN 'Responsabile logistica'
  WHEN 'Warehouse Logistics Operator' THEN 'Operatore logistico di magazzino'
  WHEN 'Service Engineer' THEN 'Ingegnere di assistenza'
  WHEN 'Accounts Manager' THEN 'Responsabile contabilita'
  WHEN 'Chief Scientific Officer' THEN 'Direttore scientifico'
  WHEN 'IT Support' THEN 'Supporto IT'
  ELSE job_title_description
END
WHERE lang = 'it';

UPDATE syntec_message_enquiry_type_i18n
SET enquiry_type_description = CASE enquiry_type_description
  WHEN 'Sales' THEN 'Ventes'
  WHEN 'Support' THEN 'Support'
  WHEN 'Accounts' THEN 'Comptabilite'
  WHEN 'Service' THEN 'Service'
  WHEN 'General Enquiry' THEN 'Demande generale'
  WHEN 'Distribution' THEN 'Distribution'
  ELSE enquiry_type_description
END
WHERE lang = 'fr';

UPDATE syntec_message_enquiry_type_i18n
SET enquiry_type_description = CASE enquiry_type_description
  WHEN 'Sales' THEN 'Vendite'
  WHEN 'Support' THEN 'Supporto'
  WHEN 'Accounts' THEN 'Contabilita'
  WHEN 'Service' THEN 'Assistenza'
  WHEN 'General Enquiry' THEN 'Richiesta generale'
  WHEN 'Distribution' THEN 'Distribuzione'
  ELSE enquiry_type_description
END
WHERE lang = 'it';

UPDATE syntec_message_types_i18n
SET message_description = CASE message_description
  WHEN 'Website' THEN 'Site web'
  ELSE message_description
END
WHERE lang = 'fr';

UPDATE syntec_message_types_i18n
SET message_description = CASE message_description
  WHEN 'Website' THEN 'Sito web'
  ELSE message_description
END
WHERE lang = 'it';

UPDATE syntec_sources_i18n
SET source_description = CASE source_description
  WHEN 'Products' THEN 'Produits'
  WHEN 'Contact Us Form' THEN 'Formulaire de contact'
  WHEN 'Contact Us Team' THEN 'Equipe contact'
  WHEN 'Contact Us Team Sales, Support & Servicing' THEN 'Equipe contact ventes, support et service'
  ELSE source_description
END
WHERE lang = 'fr';

UPDATE syntec_sources_i18n
SET source_description = CASE source_description
  WHEN 'Products' THEN 'Prodotti'
  WHEN 'Contact Us Form' THEN 'Modulo contatti'
  WHEN 'Contact Us Team' THEN 'Team contatti'
  WHEN 'Contact Us Team Sales, Support & Servicing' THEN 'Team contatti vendite, supporto e assistenza'
  ELSE source_description
END
WHERE lang = 'it';

-- Product groups: translate the common set of names seen in Oracle export.
UPDATE syntec_product_group_i18n
SET product_group_name = CASE product_group_name
  WHEN 'IFA Testing' THEN 'Tests IFA'
  WHEN 'Pipettes' THEN 'Pipettes'
  WHEN 'Transport Media' THEN 'Milieux de transport'
  WHEN 'Consumables' THEN 'Consommables'
  WHEN 'Reagents' THEN 'Reactifs'
  WHEN 'Molecular PCR' THEN 'PCR moleculaire'
  WHEN 'Next Gen. Sequencing' THEN 'Sequencage nouvelle generation'
  WHEN 'Liquid-Handling' THEN 'Manipulation des liquides'
  WHEN 'Lab-Ware' THEN 'Materiel de laboratoire'
  WHEN 'Life Science' THEN 'Sciences de la vie'
  WHEN 'Cryo' THEN 'Cryo'
  WHEN 'Cellular Therapies' THEN 'Therapies cellulaires'
  WHEN 'Molecular Controls' THEN 'Controles moleculaires'
  WHEN 'Antibodies' THEN 'Anticorps'
  WHEN 'Digital Analysis' THEN 'Analyse numerique'
  WHEN 'Frozen Section' THEN 'Coupe a congelation'
  WHEN 'Grossing' THEN 'Macroscopie'
  WHEN 'Microtomy' THEN 'Microtomie'
  WHEN 'Sample Handling' THEN 'Manipulation des echantillons'
  WHEN 'Staining & Coverslipping' THEN 'Coloration et pose de lamelles'
  WHEN 'Tissue Processing' THEN 'Traitement des tissus'
  WHEN 'Staining' THEN 'Coloration'
  WHEN 'Culture Media' THEN 'Milieux de culture'
  WHEN 'Incubators & Cabinets' THEN 'Incubateurs et enceintes'
  WHEN 'Refrigeration' THEN 'Refrigeration'
  WHEN 'Cellular Analytics' THEN 'Analyse cellulaire'
  WHEN 'Test kits' THEN 'Kits de test'
  WHEN 'Autoimmunity' THEN 'Auto-immunite'
  WHEN 'Sample Preparation' THEN 'Preparation des echantillons'
  WHEN 'Tissue Preparation' THEN 'Preparation tissulaire'
  WHEN 'Metabolic Testing' THEN 'Tests metaboliques'
  WHEN 'Regenerative Therapies' THEN 'Therapies regeneratives'
  WHEN 'Restorative Therapies' THEN 'Therapies restauratives'
  WHEN 'Cryotherapy' THEN 'Cryotherapie'
  WHEN 'Muscle Therapy' THEN 'Therapie musculaire'
  WHEN 'Light Therapy' THEN 'Phototherapie'
  ELSE product_group_name
END
WHERE lang = 'fr';

UPDATE syntec_product_group_i18n
SET product_group_name = CASE product_group_name
  WHEN 'IFA Testing' THEN 'Test IFA'
  WHEN 'Pipettes' THEN 'Pipette'
  WHEN 'Transport Media' THEN 'Terreni di trasporto'
  WHEN 'Consumables' THEN 'Materiali di consumo'
  WHEN 'Reagents' THEN 'Reagenti'
  WHEN 'Molecular PCR' THEN 'PCR molecolare'
  WHEN 'Next Gen. Sequencing' THEN 'Sequenziamento di nuova generazione'
  WHEN 'Liquid-Handling' THEN 'Gestione liquidi'
  WHEN 'Lab-Ware' THEN 'Materiale da laboratorio'
  WHEN 'Life Science' THEN 'Scienze della vita'
  WHEN 'Cryo' THEN 'Criogenia'
  WHEN 'Cellular Therapies' THEN 'Terapie cellulari'
  WHEN 'Molecular Controls' THEN 'Controlli molecolari'
  WHEN 'Antibodies' THEN 'Anticorpi'
  WHEN 'Digital Analysis' THEN 'Analisi digitale'
  WHEN 'Frozen Section' THEN 'Sezione congelata'
  WHEN 'Grossing' THEN 'Macroscopia'
  WHEN 'Microtomy' THEN 'Microtomia'
  WHEN 'Sample Handling' THEN 'Gestione campioni'
  WHEN 'Staining & Coverslipping' THEN 'Colorazione e coprioggetto'
  WHEN 'Tissue Processing' THEN 'Processazione tissutale'
  WHEN 'Staining' THEN 'Colorazione'
  WHEN 'Culture Media' THEN 'Terreni di coltura'
  WHEN 'Incubators & Cabinets' THEN 'Incubatori e armadi'
  WHEN 'Refrigeration' THEN 'Refrigerazione'
  WHEN 'Cellular Analytics' THEN 'Analitica cellulare'
  WHEN 'Test kits' THEN 'Kit di test'
  WHEN 'Autoimmunity' THEN 'Autoimmunita'
  WHEN 'Sample Preparation' THEN 'Preparazione campioni'
  WHEN 'Tissue Preparation' THEN 'Preparazione tissutale'
  WHEN 'Metabolic Testing' THEN 'Test metabolici'
  WHEN 'Regenerative Therapies' THEN 'Terapie rigenerative'
  WHEN 'Restorative Therapies' THEN 'Terapie restorative'
  WHEN 'Cryotherapy' THEN 'Crioterapia'
  WHEN 'Muscle Therapy' THEN 'Terapia muscolare'
  WHEN 'Light Therapy' THEN 'Terapia della luce'
  ELSE product_group_name
END
WHERE lang = 'it';
