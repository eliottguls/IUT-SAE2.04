
SET SCHEMA 'partie3';

DROP FUNCTION IF EXISTS datenaissance() cascade;

CREATE FUNCTION partie3.datenaissance(d date) RETURNS DATE AS $age$
DECLARE 
  newJourNaissance integer := 0;
  OldDate date := d;

BEGIN
  IF EXTRACT(MONTH FROM d) == 2 THEN 
    newJourNaissance :=   round(rand() * 29);
  ELSIF EXTRACT(MONTH FROM d)% comp == 0 THEN 
    newJourNaissance := round(rand() * 30);
  ELSE
    newJourNaissance := round(rand() * 31);
  END IF;
END;
$age$ LANGUAGE plpgsql;

select datenaissance('06/06/1984');
