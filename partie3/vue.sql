set schema 'partie3';

DROP VIEW IF EXISTS vue cascade;
CREATE OR REPLACE VIEW vue AS(
      SELECT date_naissance, code_nip, i.ine 
      FROM _individu i
      INNER JOIN _etudiant e ON i.ine = e.ine
);

CREATE OR REPLACE FUNCTION ages(dat DATE) RETURNS INTEGER AS $ancien$
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
    
select ages(date_naissance) from _individu;
    
select nom, POSITION('A' in nom) from _individu;

