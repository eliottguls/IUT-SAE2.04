set schema 'partie3';

DROP VIEW IF EXISTS _part3_2 cascade;
CREATE OR REPLACE VIEW _part3_2 AS(
      SELECT date_naissance, code_nip, i.ine, code_postal
      FROM _individu i
      INNER JOIN _etudiant e ON i.ine = e.ine);


DROP VIEW IF EXISTS _part3_3 cascade;
CREATE OR REPLACE VIEW _part3_3 AS(
      SELECT date_naissance, r.code_nip, id_module, moyenne, ine, 
      FROM _part3_2 p1
      INNER JOIN _resultat r ON p1.code_nip = r.code_nip);
      


      


      
DROP VIEW IF EXISTS _part3_2 cascade;
CREATE OR REPLACE VIEW _part3_2 AS(
      SELECT date_naissance, code_nip, i.ine, nom , dept_etablissement
      FROM _individu i
      INNER JOIN _etudiant e ON i.ine = e.ine
      INNER JOIN _candidat c ON c.ine = i.ine);


DROP VIEW IF EXISTS _part3_3 cascade;
CREATE OR REPLACE VIEW _part3_3 AS(
      SELECT date_naissance, r.code_nip, id_module, moyenne, ine, nom, dept_etablissement
      FROM _part3_2 p1
      INNER JOIN _resultat r ON p1.code_nip = r.code_nip);
      





      

      


CREATE OR REPLACE FUNCTION anciennete(dat DATE) RETURNS INTEGER AS $ancien$
  DECLARE 
  age integer;
  currentDate Date;
  currentYear INTEGER;
  currentMonth INTEGER;
  year INTEGER;
  month INTEGER;
BEGIN
  currentDate := CAST(CURRENT_DATE AS Date);
  currentYear := EXTRACT(YEAR FROM currentDate);
  currentMonth := EXTRACT(MONTH FROM currentDate);
  year := EXTRACT(YEAR FROM dat);
  month := EXTRACT(MONTH FROM dat);
  
  IF dat> CURRENT_DATE THEN
    RAISE EXCEPTION 'Date posterieur %', dat;
  END IF;
  
  age := currentYear - year;
  if (currentMonth > month) then
    age := age +1;
  END IF;
RETURN age;
END;
$ancien$ LANGUAGE plpgsql;



DROP VIEW IF EXISTS _moyenne_g CASCADE;
CREATE OR REPLACE VIEW _moyenne_g AS(
      SELECT anciennete(date_naissance) as age, avg(moyenne) as moy_g, nom, dept_etablissement
      FROM _part3_3
      GROUP BY date_naissance, nom, dept_etablissement
      );
