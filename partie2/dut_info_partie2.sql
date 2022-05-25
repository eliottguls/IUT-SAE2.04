drop schema if exists partie2 cascade;
create schema partie2;
set schema 'partie2';


/**********************
*       CANDIDAT      *
**********************/
drop table if exists _candidat cascade;
CREATE TABLE _candidat(
      id_individu         SERIAL,
      no_candidat         INT,
      classement          VARCHAR(100),
      boursier_lycee      VARCHAR(100),--30
      profil_candidat     VARCHAR(100) not null,--30
      etablissement       VARCHAR(100),--30
      dept_etablissement  VARCHAR(100), -- 2
      ville_etablissement VARCHAR(100), --50
      niveau_etude        VARCHAR(100), --30
      type_formation_prec VARCHAR(100), --10 de base
      serie_prec          VARCHAR(100), --2 de base
      dominante_prec      VARCHAR(100),--30
      specialite_prec     VARCHAR(100), --50
      LV1                 VARCHAR(100),--30
      LV2                 VARCHAR(100),
       constraint PK_CANDIDAT primary key (id_individu)
      );
      
/**********************
*       INDIVIDU      *
**********************/
drop table if exists _individu Cascade;
CREATE TABLE _individu(
      id_individu         SERIAL,
      nom                 VARCHAR(100),
      prenom              VARCHAR(100),
      sexe                VARCHAR(100),
      date_naissance      DATE ,
      code_postal         VARCHAR(100), --null
      ville               VARCHAR(100), --null
      nationalite         VARCHAR(100),
      INE                 VARCHAR(100),
      CONSTRAINT PK_INDIVIDU PRIMARY KEY(id_individu));
    

/**********************
*       ETUDIANT      *
**********************/
DROP TABLE IF EXISTS _etudiant cascade;
CREATE TABLE _etudiant(
      code_nip            VARCHAR(80),
      annee_inscription   VARCHAR(100) not null, -- on peut utiliser la variable qu'on a vu en cours pour reprndre le meme type que dans la table temp
      id_individu         INT,
      cat_socio_etu       VARCHAR(200) not null,
      cat_socio_parent    VARCHAR(200) not null,
      bourse_superieur    VARCHAR(200),
      mention_bac         VARCHAR(100),
      serie_bac           VARCHAR(200),
      dominante_bac       VARCHAR(200), 
      specialite_bac      VARCHAR(200), 
      mois_annee_obtention_bac    VARCHAR(70), --formater les dates
      CONSTRAINT PK_ETUDIANT PRIMARY KEY(code_nip, annee_inscription)
      );


/**********************
*       SEMESTRE      *
**********************/
drop table if exists _semestre cascade;
CREATE TABLE _semestre(
      id_semestre                 SERIAL PRIMARY KEY, 
      num_semestre                CHAR(5) not null,
      annee_univ                  CHAR(9) not null,
      UNIQUE(annee_univ, num_semestre));
drop table if exists _temp_semestre cascade;
CREATE TABLE _temp_semestre
(
      num_semestre                VARCHAR(5),
      annee_univ                  CHAR(9)
);


/*************************
*       INSCRIPTION      *
*************************/
DROP TABLE  if exists _inscription cascade;
CREATE TABLE _inscription(
      code_nip            VARCHAR(80),
      annee_inscription   VARCHAR(100) not null,
      num_semestre                VARCHAR(20) not null,
      groupe_tp                   CHAR(2),
      CONSTRAINT PK_INSCRIPTION PRIMARY KEY(code_nip, annee_inscription, num_semestre));
        
-- ALTER TABLE _inscription
--     ADD CONSTRAINT fk_inscription_semestre FOREIGN KEY (num_semestre)
--         REFERENCES _semestre(num_semestre);
--         
-- ALTER TABLE _inscription
--     ADD CONSTRAINT fk_inscription_etudiant FOREIGN KEY (code_nip, annee_inscription)
--         REFERENCES _etudiant(code_nip, annee_inscription);
-- erreur lors de l'injection des données donc à ajouter après avoir injecter les donneés
-- Nous n'avons pas tous les étudiant qui devrait être présent dans _etudiant donc inscription ne peut pas respecter la clé étrangeère sur code_nip, annee_inscription


WbImport -file= data2/v_resu_s1.csv
         -header = true
         -delimiter = ';'
         -table = _inscription
         -schema = partie2
         -filecolumns = annee_inscription, num_semestre, code_nip, $wb_skip$, $wb_skip$, $wb_skip$, $wb_skip$, 
         $wb_skip$, $wb_skip$, groupe_tp;
         
WbImport -file= data2/v_resu_s2.csv
         -header = true
         -delimiter = ';'
         -table = _inscription
         -schema = partie2
         -filecolumns = annee_inscription, num_semestre, code_nip, $wb_skip$, $wb_skip$, $wb_skip$, $wb_skip$, 
         $wb_skip$, $wb_skip$, groupe_tp;
         
WbImport -file= data2/v_resu_s3.csv
         -header = true
         -delimiter = ';'
         -table = _inscription
         -schema = partie2
         -filecolumns = annee_inscription, num_semestre, code_nip, $wb_skip$, $wb_skip$, $wb_skip$, $wb_skip$, 
         $wb_skip$, $wb_skip$, groupe_tp;
         
WbImport -file= data2/v_resu_s4.csv
         -header = true
         -delimiter = ';'
         -table = _inscription
         -schema = partie2
         -filecolumns = annee_inscription, num_semestre, code_nip, $wb_skip$, $wb_skip$, $wb_skip$, $wb_skip$, 
         $wb_skip$, $wb_skip$, groupe_tp;

/********************
*       MODULE      *
********************/
CREATE TABLE _module(
      id_module                   VARCHAR(10),
      ue                          CHAR(4) not null,
      libelle_module              VARCHAR(150) not null,
      CONSTRAINT PK_MODULE PRIMARY KEY (id_module));
      
/***********************
*      PROGRAMME       *
***********************/
CREATE TABLE _programme(
      annee_univ                  CHAR(9) ,
      num_semestre                CHAR(5) ,
      id_module                   VARCHAR(7), -- passage en varchar 7
      coefficient                 FLOAT not null,
      CONSTRAINT PK_PROGRAMME PRIMARY KEY (id_module, num_semestre));
      
/**********************
*       RESULTAT      *
**********************/
DROP TABLE IS EXISTS _resultat cascade;
CREATE TABLE _resultat(
      id_module                   CHAR(5),
      annee_univ                  CHAR(9) ,
      num_semestre                CHAR(5) ,
      code_nip                    VARCHAR(8),
      moyenne                     FLOAT not null,
      CONSTRAINT PK_RESULTAT PRIMARY KEY(id_module, num_semestre, code_nip));

DROP TABLE IF EXISTS _id_module_temp CASCADE;
CREATE TABLE _id_module_temp(
      id_module VARCHAR(50)
);
INSERT INTO _id_module_temp(
SELECT id_module
FROM _module);

DROP TABLE IF EXISTS _resulat_temp CASCADE;
CREATE TABLE _resultat_temp(
      INE     VARCHAR(100),
      anee_univ VARCHAR(100),
      num_semestre VARCHAR(100),
      code_nip      VARCHAR(100)); 
      


      


/********************
*    CONTRAINTES    *
********************/
ALTER TABLE _resultat
  ADD CONSTRAINT Fk_resultat_etudiant FOREIGN KEY (code_nip)
    REFERENCES _etudiant (code_nip);

ALTER TABLE _resultat
  ADD CONSTRAINT fk_resultat_module FOREIGN KEY (id_module)
    REFERENCES _module (id_module);
    
ALTER TABLE _programme
  ADD CONSTRAINT fk_programme_module FOREIGN KEY (id_module)
    REFERENCES _module(id_module);

ALTER TABLE _programme
  ADD CONSTRAINT fk_programme_semestre_1 FOREIGN KEY (annee_univ, num_semestre)
    REFERENCES _semestre (annee_univ, num_semestre);
    
ALTER TABLE _inscription
    ADD CONSTRAINT fk_inscription_semestre FOREIGN KEY (id_semestre)
        REFERENCES _semestre(id_semestre);
        
ALTER TABLE _inscription
    ADD CONSTRAINT fk_inscription_etudiant FOREIGN KEY (code_nip)
        REFERENCES _etudiant(code_nip);
        
ALTER TABLE _candidat
    ADD CONSTRAINT fk_candidat_postuler_individu FOREIGN KEY (id_individu)
        REFERENCES _individu(id_individu);
        
ALTER TABLE _etudiant
      ADD CONSTRAINT fk_etudiant_incription FOREIGN KEY (id_individu)
          REFERENCES _individu(id_individu);


drop table if exists partie2._candidat_temp;
CREATE TABLE partie2._candidat_temp(
      no_candidat         INT,
      classement          VARCHAR(5),
      boursier_lycee      VARCHAR(100),--30
      profil_candidat     VARCHAR(100) not null,--30
      INE                 VARCHAR(11),
      etablissement       VARCHAR(100),--30
      ville_etablissement VARCHAR(100), --50
      dept_etablissement  VARCHAR(5), -- 2
      niveau_etude        VARCHAR(100), --30
      type_formation_prec VARCHAR(100), --10 de base
      serie_prec          VARCHAR(100), --2 de base
      dominante_prec      VARCHAR(100),--30
      specialite_prec     VARCHAR(100), --50
      LV1                 VARCHAR(40),--30
      LV2                 VARCHAR(25),
      CONSTRAINT PK_CANDIDAT_TEMP PRIMARY KEY(INE)
      );

      

WbImport -file = data2/v_candidatures.csv
         -header = true
         -delimiter = ';'
         -table = _individu
         -schema = partie2
         -fileColumns = $wb_skip$, $wb_skip$ , $wb_skip$,  nom, prenom, sexe, date_naissance, nationalite, code_postal, ville, $wb_skip$, $wb_skip$, $wb_skip$, INE;
         
WbImport -file=data2/v_candidatures.csv
         -header=true
         -delimiter=';'
         -table=_candidat_temp
         -schema=partie2
         -filecolumns=$wb_skip$, no_candidat, classement, $wb_skip$, $wb_skip$,$wb_skip$, $wb_skip$, 
          $wb_skip$, $wb_skip$, $wb_skip$, $wb_skip$, boursier_lycee, profil_candidat, INE, $wb_skip$, etablissement,
          ville_etablissement, dept_etablissement, $wb_skip$, niveau_etude, 
          type_formation_prec, serie_prec, dominante_prec, specialite_prec, lv1, lv2;
         
INSERT INTO partie2._candidat
    (SELECT id_individu, no_candidat, classement, boursier_lycee, profil_candidat, etablissement, ville_etablissement, niveau_etude, type_formation_prec, serie_prec, dominante_prec, specialite_prec, LV1, LV2
      FROM partie2._candidat_temp ct
      INNER JOIN partie2._individu i ON ct.ine = i.ine);

         

WbImport -file= data2/ppn.csv
         -header = true
         -delimiter = ';'
         -table = _module
         -schema = partie2
         -filecolumns = id_module, ue, libelle_module;

WbImport -file= data2/v_resu_s1.csv
         -header = true
         -delimiter = ';'
         -table = _temp_semestre
         -schema = partie2
         -filecolumns = annee_univ, num_semestre;
                
WbImport -file= data2/v_resu_s2.csv
         -header = true
         -delimiter = ';'
         -table = _temp_semestre
         -schema = partie2
         -filecolumns = annee_univ, num_semestre;
         
WbImport -file= data2/v_resu_s3.csv
         -header = true
         -delimiter = ';'
         -table = _temp_semestre
         -schema = partie2
         -filecolumns = annee_univ, num_semestre;
;        
WbImport -file= data2/v_resu_s4.csv
         -header = true
         -delimiter = ';'
         -table = _temp_semestre
         -schema = partie2
         -filecolumns = annee_univ, num_semestre;
        
insert into _semestre (num_semestre, annee_univ)
select  num_semestre, annee_univ
from _temp_semestre;

WbImport -file= data2/v_programme.csv
         -header = true
         -delimiter = ';'
         -decimal = ","
         -table = _programme
         -schema = partie2
         -filecolumns = annee_univ, num_semestre  ,id_module, coefficient;
         


/******************************
******** ETUDIANT *************
******************************/
drop table if exists _etudiant_temp_inscription cascade;
-- ALTER TABLE _etudiant_temp_candidatures
--   DROP CONSTRAINT PK_ETUDIANT_TEMP_INSCRIPTION;
CREATE TABLE _etudiant_temp_inscription(
      code_nip            VARCHAR(80),
      annee_inscription   VARCHAR(100) not null, 
      INE                 VARCHAR(120),
      cat_socio_etu       VARCHAR(100) not null,
      cat_socio_parent    VARCHAR(200) not null,
      mention_bac         VARCHAR(100),
      bourse_superieur    VARCHAR(200));
      -- CONSTRAINT PK_ETUDIANT_TEMP_INSCRIPTION PRIMARY KEY(code_nip, annee_inscription) je peut pas drop la contrainte donc pas recreer la table
      

      
WbImport -file=data2/v_inscriptions.csv
         -header = true
         -delimiter = ';'
         -table = _etudiant_temp_inscription
         -schema = partie2
         -filecolumns = annee_inscription, $wb_skip$, $wb_skip$, $wb_skip$, code_nip, INE, $wb_skip$, $wb_skip$, $wb_skip$,
         $wb_skip$, $wb_skip$, $wb_skip$, $wb_skip$, cat_socio_etu, cat_socio_parent, serie_bac, mention_bac,
         $wb_skip$, $wb_skip$, $wb_skip$, $wb_skip$,$wb_skip$, bourse_superieur;
         


drop table if exists _etudiant_temp_candidatures cascade;
create table _etudiant_temp_candidatures( 
      INE                 VARCHAR(120),
      annee_candidature   VARCHAR(200),
      serie_bac           VARCHAR(200),
      dominante_bac       VARCHAR(200), 
      specialite_bac      VARCHAR(200), 
      mois_annee_obtention_bac    VARCHAR(70),
      CONSTRAINT PK_ETUDIANT_TEMP_CANDIDATURES PRIMARY KEY(INE));
      

WbImport -file=data2/v_candidatures.csv
         -header = true
         -delimiter = ';'
         -table = _etudiant_temp_candidatures
         -schema = partie2
         -filecolumns = annee_candidature, $wb_skip$, $wb_skip$, $wb_skip$, $wb_skip$, $wb_skip$, 
         $wb_skip$, $wb_skip$, $wb_skip$, $wb_skip$, $wb_skip$, $wb_skip$, $wb_skip$, INE, 
         $wb_skip$, $wb_skip$, $wb_skip$, $wb_skip$, $wb_skip$, $wb_skip$, $wb_skip$, serie_bac,
         dominante_bac, specialite_bac, $wb_skip$, $wb_skip$,$wb_skip$, $wb_skip$, $wb_skip$, $wb_skip$, 
         $wb_skip$, mois_annee_obtention_bac;
         
drop table if exists _etudiant_temp cascade;
CREATE TABLE _etudiant_temp(
      INE                       VARCHAR(120),
      code_nip                  VARCHAR(80),
      annee_inscription         VARCHAR(100) not null, 
      cat_socio_etu             VARCHAR(100) not null,
      cat_socio_parent          VARCHAR(200),
      bourse_superieur          VARCHAR(200),
      mention_bac               VARCHAR(100),
      serie_bac                 VARCHAR(200),
      dominante_bac             VARCHAR(200), 
      specialite_bac            VARCHAR(200), 
      mois_annee_obtention_bac  VARCHAR(70));
      
INSERT INTO _etudiant_temp
  (SELECT eti.INE, code_nip, annee_inscription, cat_socio_etu, cat_socio_parent, 
  bourse_superieur, mention_bac, serie_bac, dominante_bac, specialite_bac, mois_annee_obtention_bac
  FROM _etudiant_temp_inscription eti
  INNER JOIN _etudiant_temp_candidatures etc ON eti.INE = etc.INE and eti.annee_inscription = etc.annee_candidature);
  

INSERT INTO partie2._etudiant
    (SELECT code_nip, annee_inscription, id_individu, cat_socio_etu, cat_socio_parent, bourse_superieur,
    mention_bac, serie_bac, dominante_bac, specialite_bac, mois_annee_obtention_bac
    FROM partie2._etudiant_temp et
    INNER JOIN partie2._individu i ON et.INE = i.INE);
    



