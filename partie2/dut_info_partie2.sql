drop schema if exists partie1 cascade;
create schema partie1;
set schema 'partie1';


/**********************
*       CANDIDAT      *
**********************/
CREATE TABLE _candidat(
      no_candidat         INT,
      id_individu         INT,
      classement          VARCHAR(5),
      boursier_lycee      VARCHAR(20) not null,
      profil_candidat     VARCHAR(20) not null,
      etablissement       VARCHAR(40) not null,
      dept_etablissement  VARCHAR(2) not null,
      ville_etablissement VARCHAR(30) not null,
      niveau_etude        VARCHAR(20) not null,
      type_formation_prec VARCHAR(15) not null,
      serie_prec          VARCHAR(1),
      dominante_prec      VARCHAR(20),
      specialite_prec     VARCHAR(30),
      LV1                 VARCHAR(20) not null,
      LV2                 VARCHAR(25) not null,
       constraint PK_CANDIDAT primary key (no_candidat)
      );
      
/**********************
*       INDIVIDU      *
**********************/
CREATE TABLE _individu(
      id_individu         INT,
      nom                 VARCHAR(30) not null,
      prenom              VARCHAR(20) not null,
      sexe                VARCHAR(8) not null,
      date_naissance      DATE not null,
      code_postal         VARCHAR(30), --null
      ville               VARCHAR(30), --null
      nationalite         VARCHAR(20) not null,
      INE                 VARCHAR(11) not null,
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
      CONSTRAINT PK_SEMESTRE PRIMARY KEY(id_semestre));
      

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
      id_semestre                 INT,
      id_module                   CHAR(5),
      coefficient                 FLOAT not null,
      CONSTRAINT PK_PROGRAMME PRIMARY KEY (id_semestre, id_module));
      
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
  ADD CONSTRAINT fk_resultat_etudiant FOREIGN KEY (code_nip)
    REFERENCES _etudiant (code_nip);
    
ALTER TABLE _resultat
  ADD CONSTRAINT fk_resultat_module FOREIGN KEY (id_module)
    REFERENCES _module (id_module);
    
ALTER TABLE _resultat
  ADD CONSTRAINT fk_resultat_semestre FOREIGN KEY (id_semestre)
    REFERENCES _semestre (id_semestre);
    
ALTER TABLE _programme
  ADD CONSTRAINT fk_programme_module FOREIGN KEY (id_module)
    REFERENCES _module;
    
ALTER TABLE _programme
  ADD CONSTRAINT fk_programme_smestre FOREIGN KEY (id_semestre)
    REFERENCES _semestre;

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

WbImport -file= C:\Users\eliot\OneDrive\Bureau\IUT\SAE\S2\SAE2.04\partie2\data\v_candidatures.csv
         -header=true
         -delimiter=';'
         -table=_individu
         -schema=partie1
         -fileColumns=$wb_skip$, id_individu, $wb_skip$,  nom, prenom, sexe, date_naissance, nationalite, code_postal, ville, $wb_skip$, $wb_skip$, $wb_skip$, INE;

WbImport -file=C:\Users\eliot\OneDrive\Bureau\IUT\SAE\S2\SAE2.04\partie2\data\ppn.csv
         -header=true
         -delimiter=';'
         -table=_module
         -schema=partie1
         -filecolumns=id_module,ue,libelle_module
         

;
