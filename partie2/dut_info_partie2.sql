drop schema if exists partie2 cascade;
create schema partie2;
set schema 'partie2';

CREATE TABLE _candidat(
      no_candidat         INT,
      id_individu         INT,  
      classement          VARCHAR(5),
      boursier_lycee      VARCHAR(20) not null, 
      profil_candidat     VARCHAR(20) not null,
      etablissement       VARCHAR(40),
      dept_etablissement  VARCHAR(2),
      ville_etablissement VARCHAR(30),
      niveau_etude        VARCHAR(20),
      type_formation_prec VARCHAR(15),
      serie_prec          VARCHAR(100), 
      dominante_prec      VARCHAR(20),
      specialite_prec     VARCHAR(30),
      LV1                 VARCHAR(20),
      LV2                 VARCHAR(25),
       constraint PK_CANDIDAT primary key (no_candidat)
      );
      
CREATE TABLE _individu(
      id_individu         SERIAL,
      nom                 VARCHAR(30) not null,
      prenom              VARCHAR(20),
      date_naissance      DATE not null,
      code_postal         VARCHAR(30) not null,
      ville               VARCHAR(50) not null,
      sexe                VARCHAR(8) not null,
      nationalite         VARCHAR(20) not null,
      INE                 VARCHAR(11) not null,
      CONSTRAINT PK_INDIVIDU PRIMARY KEY(id_individu)
);
    

CREATE TABLE _etudiant(
      code_nip            VARCHAR(8), -- = numero etudiant
      id_individu         INT,
      cat_socio_etu       VARCHAR(20),
      cat_socio_parent    VARCHAR(20),
      bourse_superieur    BOOLEAN not null,
      mention_bac         VARCHAR(10),
      serie_bac           VARCHAR(20) not null,
      dominante_bac       VARCHAR(20) not null, 
      specialite_bac      VARCHAR(20),
      mois_annee_obtention_bac    CHAR(7),
      CONSTRAINT PK_ETUDIANT PRIMARY KEY(code_nip));
      
CREATE TABLE _semestre(
      id_semestre                 SERIAL, 
      num_semestre                CHAR(5) not null,
      annee_univ                  CHAR(9) not null,
      CONSTRAINT PK_SEMESTRE PRIMARY KEY(annee_univ, num_semestre));
      
CREATE TABLE _inscription(
      code_nip                    VARCHAR(8),
      id_semestre                 SERIAL,
      groupe_tp                   CHAR(2) not null,
      amenagement_evaluation      VARCHAR(20) not null,
      CONSTRAINT PK_INSCRIPTION PRIMARY kEY(code_nip, id_semestre));
        
CREATE TABLE _module(
      id_module                   VARCHAR(7), -- passage en varchar 7
      libelle_module              VARCHAR(150) not null, --changement a 150
      ue                          CHAR(4) not null,
      CONSTRAINT PK_MODULE PRIMARY KEY (id_module));
      

CREATE TABLE _programme(
      annee_univ                  CHAR(9) not null,
      num_semestre                CHAR(5) not null,
      id_module                   VARCHAR(7), -- passage en varchar 7
      coefficient                 FLOAT not null,
      CONSTRAINT PK_PROGRAMME PRIMARY KEY (id_module));
      

CREATE TABLE _resultat(
      id_module                   VARCHAR(7), -- passage en varchar 7
      code_nip                    VARCHAR(8),
      moyenne                     FLOAT not null,
      CONSTRAINT PK_RESULTAT PRIMARY KEY(id_module, code_nip));
      
CREATE TABLE _temp_semestre
(
      num_semestre                VARCHAR(5),
      annee_univ                  CHAR(9)
);

ALTER TABLE _resultat
  ADD CONSTRAINT Fk_resultat_etudiant FOREIGN KEY (code_nip)
    REFERENCES _etudiant (code_nip);

ALTER TABLE _resultat
  ADD CONSTRAINT Fk_resultat_module FOREIGN KEY (id_module)
    REFERENCES _module (id_module);
    
ALTER TABLE _programme
  ADD CONSTRAINT Fk_programme_module FOREIGN KEY (id_module)
    REFERENCES _module(id_module);

ALTER TABLE _programme
  ADD CONSTRAINT Fk_programme_smestre_1 FOREIGN KEY (annee_univ)
    REFERENCES _semestre (annee_univ);
    
ALTER TABLE _programme
  ADD CONSTRAINT Fk_programme_smestre_2 FOREIGN KEY (num_semestre)
    REFERENCES _semestre (num_semestre);

/*
ALTER TABLE _inscription
    ADD CONSTRAINT fk_inscription_semestre FOREIGN KEY (id_semestre)
        REFERENCES _semestre(id_semestre);
        
ALTER TABLE _inscription
    ADD CONSTRAINT fk_inscription_etudiant FOREIGN KEY (code_nip)
        REFERENCES _etudiant(code_nip);
*/
   
ALTER TABLE _candidat
    ADD CONSTRAINT fk_candidat_postuler_individu FOREIGN KEY (id_individu)
        REFERENCES _individu(id_individu);
        
ALTER TABLE _etudiant
      ADD CONSTRAINT fk_etudiant_incription FOREIGN KEY (id_individu)
          REFERENCES _individu(id_individu);
          
          
WbImport -file = data/v_candidatures.csv
         -header = true
         -delimiter = ';'
         -table = _individu
         -schema = partie2
         -fileColumns = $wb_skip$, $wb_skip$ , $wb_skip$,  nom, prenom, sexe, date_naissance, nationalite, code_postal, ville, $wb_skip$, $wb_skip$, $wb_skip$, INE;

          
WbImport -file = data2/v_candidatures.csv
         -header = true
         -delimiter = ';'
         -table = _individu
         -schema = partie2
         -fileColumns = $wb_skip$, $wb_skip$ , $wb_skip$,  nom, prenom, sexe, date_naissance, nationalite, code_postal, ville, $wb_skip$, $wb_skip$, $wb_skip$, INE;

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
;       
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
select distinct num_semestre, annee_univ
from _temp_semestre;


WbImport -file= data2/ppn.csv
         -header = true
         -delimiter = ';'
         -table = _programme
         -schema = partie2
         -filecolumns = id_module, $wb_skip$  ,$wb_skip$, coefficient;
 
drop table if exists partie2._candidat_temp;
CREATE TABLE partie2._candidat_temp(
      no_candidat         INT,
      classement          VARCHAR(5),
      boursier_lycee      VARCHAR(100),--30
      profil_candidat     VARCHAR(100) not null,--30
      INE                 VARCHAR(11)PRIMARY KEY,
      etablissement       VARCHAR(100),--30
      ville_etablissement VARCHAR(100), --50
      dept_etablissement  VARCHAR(5), -- 2
      niveau_etude        VARCHAR(100), --30
      type_formation_prec VARCHAR(100), --10 de base
      serie_prec          VARCHAR(100), --2 de base
      dominante_prec      VARCHAR(100),--30
      specialite_prec     VARCHAR(100), --50
      LV1                 VARCHAR(40),--30
      LV2                 VARCHAR(25)
      );

      

WbImport -file=/home/etuinfo/eguillossou/Documents/IUT_1ST_Y/S2/SAE/SAE2.04/data/v_candidatures.csv
         -header=true
         -delimiter=';'
         -table=_candidat_temp
         -schema=partie2
         -filecolumns=$wb_skip$, no_candidat, classement, $wb_skip$, $wb_skip$,$wb_skip$, $wb_skip$, 
          $wb_skip$, $wb_skip$, $wb_skip$, $wb_skip$, boursier, profil_candidat, INE, $wb_skip$, etablissement,
          ville_etablissement, dept_etablissement, $wb_skip$, niveau_etude, 
          type_formation, serie_prec, dominante_prec, specialite_prec, lv1, lv2;
         
INSERT INTO partie2._candidat
    (SELECT id_individu, no_candidat, classement, boursier_lycee, profil_candidat, etablissement, ville_etablissement, niveau_etude, type_formation_prec, serie_prec, dominante_prec, specialite_prec, LV1, LV2
      FROM _candidat_temp ct
      INNER JOIN _individu i ON ct.ine = i.ine);
