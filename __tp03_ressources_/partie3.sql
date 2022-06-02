set schema 'partie3';

DROP VIEW IF EXISTS _part3_1 cascade;
CREATE OR REPLACE VIEW _part3_1 AS(
      SELECT date_naissance, code_nip 
      FROM _individu i
      INNER JOIN _etudiant e ON i.ine = e.ine
);


CREATE OR REPLACE VIEW _part3_2 AS(
      SELECT date_naissance, r.code_nip, id_module, moyenne
      FROM _part3_1 p1
      INNER JOIN _resultat r ON p1.code_nip = r.code_nip);
      
DROP VIEW _moyenne_g;
CREATE OR REPLACE VIEW _moyenne_g AS(
      SELECT date_naissance, avg(moyenne) as moy_g
      FROM _part3_2
      GROUP BY date_naissance, code_nip
      );
