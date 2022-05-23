drop schema if exists partie2 cascade;
create schema partie2;
set schema 'partie2';


/**********************
*       CANDIDAT      *
**********************/
drop table if exists _candidat;
CREATE TABLE _candidat(
      id_individu         INT,
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
CREATE TABLE _etudiant(
      code_nip            VARCHAR(8),
      id_individu         INT,
      cat_socio_etu       VARCHAR(20) not null,
      cat_socio_parent    VARCHAR(20) not null,
      bourse_superieur    BOOLEAN,
      mention_bac         VARCHAR(10),
      serie_bac           VARCHAR(20) not null,
      dominante_bac       VARCHAR(20) not null, 
      specialite_bac      VARCHAR(20), 
      mois_annee_obtention_bac    CHAR(7),
      CONSTRAINT PK_ETUDIANT PRIMARY KEY(code_nip));
      

/**********************
*       SEMESTRE      *
**********************/
CREATE TABLE _semestre(
      id_semestre                 INT,
      num_semestre                CHAR(5) not null,
      annee_univ                  CHAR(9) not null,
      CONSTRAINT PK_SEMESTRE PRIMARY KEY(id_semestre),
      UNIQUE(num_semestre, annee_univ)      
);
      
CREATE TABLE _temp_semestre
(
      num_semestre                VARCHAR(5),
      annee_univ                  CHAR(9)
);


/*************************
*       INSCRIPTION      *
*************************/
CREATE TABLE _inscription(
      code_nip                    VARCHAR(8),
      id_semestre                 INT,
      groupe_tp                   CHAR(2) not null,
      amenagement_evaluation      VARCHAR(20) not null,
      CONSTRAINT PK_INSCRIPTION PRIMARY kEY(code_nip, id_semestre));
        

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
CREATE TABLE _resultat(
      id_module                   CHAR(5),
      id_semestre                 INT,
      code_nip                    VARCHAR(8),
      moyenne                     FLOAT not null,
      CONSTRAINT PK_RESULTAT PRIMARY KEY(id_module, id_semestre, code_nip));


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
          $wb_skip$, $wb_skip$, $wb_skip$, $wb_skip$, boursier, profil_candidat, INE, $wb_skip$, etablissement,
          ville_etablissement, dept_etablissement, $wb_skip$, niveau_etude, 
          type_formation, serie_prec, dominante_prec, specialite_prec, lv1, lv2;
         
INSERT INTO partie2._candidat
    (SELECT id_individu, no_candidat, classement, boursier_lycee, profil_candidat, etablissement, ville_etablissement, niveau_etude, type_formation_prec, serie_prec, dominante_prec, specialite_prec, LV1, LV2
      FROM _candidat_temp ct
      INNER JOIN _individu i ON ct.ine = i.ine);

         

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


WbImport -file= data2/v_programme.csv
         -header = true
         -delimiter = ';'
         -decimal = ","
         -table = _programme
         -schema = partie2
         -filecolumns = annee_univ, num_semestre  ,id_module, coefficient;



