-- Normalisé esx items

ALTER TABLE job_grades2 ADD CONSTRAINT job_grades2_UN UNIQUE KEY (grade,job_name);


INSERT IGNORE INTO jobs2 (name, label) VALUES('boucher2', 'Boucher v2');
INSERT IGNORE INTO job_grades2 ( job_name, grade, name, label, salary, skin_male, skin_female) VALUES( 'boucher2', 0, 'employee', 'Employé', 0, '{}', '{}');
INSERT IGNORE INTO items (name, label, weight, rare, can_remove) VALUES('viande_boeuf', 'Viande de boeuf', 0.4, 0, 1);
INSERT IGNORE INTO items (name, label, weight, rare, can_remove) VALUES('viande_boeuf_qualite', 'Viande de boeuf de qualité', 0.4, 1, 1);
INSERT IGNORE INTO items (name, label, weight, rare, can_remove) VALUES('viande_boeuf_emballe', 'Viande de boeuf emballée', 0.4, 0, 1);
INSERT IGNORE INTO items (name, label, weight, rare, can_remove) VALUES('viande_porc', 'Viande de porc', 0.4, 0, 1);
INSERT IGNORE INTO items (name, label, weight, rare, can_remove) VALUES('viande_porc_qualite', 'Viande de porc de qualité', 0.4, 1, NULL);
INSERT IGNORE INTO items (name, label, weight, rare, can_remove) VALUES('viande_porc_emballe', 'Viande de porc emballée', 0.4, 0, 1);
INSERT IGNORE INTO items (name, label, weight, rare, can_remove) VALUES('lait', 'Lait', 0.4, 0, 1);
INSERT IGNORE INTO items (name, label, weight, rare, can_remove) VALUES('lait_bouteille', 'Lait en bouteille', 0.4, 0, 1);
INSERT IGNORE INTO items (name, label, weight, rare, can_remove) VALUES('lait_qualite', 'Lait de qualité', 0.4, 1, 1);

INSERT IGNORE INTO jobs2 (name, label) VALUES('ems2', 'EMS v2');
INSERT IGNORE INTO job_grades2 ( job_name, grade, name, label, salary, skin_male, skin_female) VALUES( 'ems2', 0, 'employee', 'Employé', 0, '{}', '{}');

INSERT IGNORE INTO jobs2 (name, label) VALUES('mineur2', 'Mineur v2');
INSERT IGNORE INTO job_grades2 ( job_name, grade, name, label, salary, skin_male, skin_female) VALUES( 'mineur2', 0, 'employee', 'Employé', 0, '{}', '{}');
INSERT IGNORE INTO items (name, label, weight, rare, can_remove) VALUES('pierre', 'Pierre', 0.4, 0, 1);
INSERT IGNORE INTO items (name, label, weight, rare, can_remove) VALUES('minerai_or', 'Or brut', 0.4, 0, 1);
INSERT IGNORE INTO items (name, label, weight, rare, can_remove) VALUES('minerai_diamant', 'Diamant brut', 0.4, 1, 1);

INSERT IGNORE INTO jobs2 (name, label) VALUES('recolte2', 'Récolte v2');
INSERT IGNORE INTO job_grades2 ( job_name, grade, name, label, salary, skin_male, skin_female) VALUES( 'recolte2', 0, 'employee', 'Employé', 0, '{}', '{}');
INSERT IGNORE INTO items (name, label, weight, rare, can_remove) VALUES('pomme', 'Pomme', 0.4, 0, 1);
INSERT IGNORE INTO items (name, label, weight, rare, can_remove) VALUES('pomme_jus', 'Jus de pomme', 0.4, 0, 1);
INSERT IGNORE INTO items (name, label, weight, rare, can_remove) VALUES('orange', 'Orange', 0.4, 0, 1);
INSERT IGNORE INTO items (name, label, weight, rare, can_remove) VALUES('orange_jus', 'Jus d''orange', 0.4, 0, 1);
INSERT IGNORE INTO items (name, label, weight, rare, can_remove) VALUES('tomate', 'Tomate', 0.4, 0, 1);
INSERT IGNORE INTO items (name, label, weight, rare, can_remove) VALUES('tomate_lave', 'Tomate lavée', 0.4, 0, 1);

INSERT IGNORE INTO jobs2 (name, label) VALUES('agriculteur2', 'Agriculteur v2');
INSERT IGNORE INTO job_grades2 ( job_name, grade, name, label, salary, skin_male, skin_female) VALUES( 'agriculteur2', 0, 'employee', 'Employé', 0, '{}', '{}');
INSERT IGNORE INTO items (name, label, weight, rare, can_remove) VALUES('patate', 'Pomme de terre', 0.4, 0, 1);
INSERT IGNORE INTO items (name, label, weight, rare, can_remove) VALUES('patate_lave', 'Pomme de terre lavée', 0.4, 0, 1);
INSERT IGNORE INTO items (name, label, weight, rare, can_remove) VALUES('ble', 'Blé', 0.4, 0, 1);
INSERT IGNORE INTO items (name, label, weight, rare, can_remove) VALUES('ble_lave', 'Blé lavé', 0.4, 0, 1);
INSERT IGNORE INTO items (name, label, weight, rare, can_remove) VALUES('salade', 'Salade', 0.4, 0, 1);
INSERT IGNORE INTO items (name, label, weight, rare, can_remove) VALUES('salade_lave', 'Salade lavée', 0.4, 0, 1);


INSERT IGNORE INTO jobs2 (name, label) VALUES('uwu2', 'UwU v2');
INSERT IGNORE INTO job_grades2 ( job_name, grade, name, label, salary, skin_male, skin_female) VALUES( 'uwu2', 0, 'employee', 'Employé', 0, '{}', '{}');



--  Update Recettes

UPDATE items SET label='Lait', weight=0.40, rare=0, can_remove=1, recette=NULL, contexte='freejob', statut='actif' WHERE name='lait';
UPDATE items SET label='Lait en bouteille', weight=0.40, rare=0, can_remove=1, recette='{
{ "lait": 1, "_give": 1, },
{ "lait_qualite":5, "_give": 1, },
}', contexte='freejob,uwu', statut='actif' WHERE name='lait_bouteille';
UPDATE items SET label='Lait de qualité', weight=0.40, rare=1, can_remove=1, recette=NULL, contexte='freejob', statut='actif' WHERE name='lait_qualite';
UPDATE items SET label='Viande de boeuf', weight=0.40, rare=0, can_remove=1, recette='', contexte='freejob', statut='actif' WHERE name='viande_boeuf';
UPDATE items SET label='Viande de boeuf emballée', weight=0.40, rare=0, can_remove=1, recette='{
{ "viande_boeuf": 1, "_give": 1, },
{ "viande_boeuf_qualite":5, "_give": 1, },
}', contexte='freejob,uwu', statut='actif' WHERE name='viande_boeuf_emballe';
UPDATE items SET label='Viande de boeuf de qualité', weight=0.40, rare=1, can_remove=1, recette=NULL, contexte='freejob', statut='actif' WHERE name='viande_boeuf_qualite';
UPDATE items SET label='Viande de porc', weight=0.40, rare=0, can_remove=1, recette='', contexte='freejob', statut='actif' WHERE name='viande_porc';
UPDATE items SET label='Viande de porc emballée', weight=0.40, rare=0, can_remove=1, recette='{
{ "viande_porc": 1, "_give": 1, },
{ "viande_porc_qualite":5, "_give": 1, },
}', contexte='freejob,uwu', statut='actif' WHERE name='viande_porc_emballe';
UPDATE items SET label='Viande de porc de qualité', weight=0.40, rare=1, can_remove=1, recette=NULL, contexte='freejob', statut='actif' WHERE name='viande_porc_qualite';
