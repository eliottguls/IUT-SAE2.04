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
      code_nip            VARCHAR(8),
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
      id_semestre                 CHAR(2), --passage de int a char(2)
      num_semestre                CHAR(5) not null,
      annee_univ                  CHAR(9) not null,
      CONSTRAINT PK_SEMESTRE PRIMARY KEY(id_semestre));
      
CREATE TABLE _inscription(
      code_nip                    VARCHAR(8),
      id_semestre                 CHAR(2), -- passage de int to char(2)
      groupe_tp                   CHAR(2) not null,
      amenagement_evaluation      VARCHAR(20) not null,
      CONSTRAINT PK_INSCRIPTION PRIMARY kEY(code_nip, id_semestre));
        
CREATE TABLE _module(
      id_module                   VARCHAR(6),
      libelle_module              VARCHAR(150) not null, --changement a 150
      ue                          CHAR(4) not null,
      CONSTRAINT PK_MODULE PRIMARY KEY (id_module));
      

CREATE TABLE _programme(
      id_semestre                 CHAR(2), -- passage de int to char(2)
      id_module                   VARCHAR(6),
      coefficient                 FLOAT not null,
      CONSTRAINT PK_PROGRAMME PRIMARY KEY (id_semestre, id_module));
      

CREATE TABLE _resultat(
      id_module                   VARCHAR(6),
      id_semestre                 CHAR(2), -- passage de int to char(2)
      code_nip                    VARCHAR(8),
      moyenne                     FLOAT not null,
      CONSTRAINT PK_RESULTAT PRIMARY KEY(id_module, id_semestre, code_nip));

ALTER TABLE _resultat
  ADD CONSTRAINT Fk_resultat_etudiant FOREIGN KEY (code_nip)
    REFERENCES _etudiant (code_nip);
    
ALTER TABLE _resultat
  ADD CONSTRAINT Fk_resultat_module FOREIGN KEY (id_module)
    REFERENCES _module (id_module);
    
ALTER TABLE _resultat
  ADD CONSTRAINT Fk_resultat_semestre FOREIGN KEY (id_semestre)
    REFERENCES _semestre (id_semestre);
    
ALTER TABLE _programme
  ADD CONSTRAINT Fk_programme_module FOREIGN KEY (id_module)
    REFERENCES _module(id_module);
    
ALTER TABLE _programme
  ADD CONSTRAINT Fk_programme_smestre FOREIGN KEY (id_semestre)
    REFERENCES _semestre (id_semestre);

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
          
WbImport -file = data/v_candidatures.csv
         -header = true
         -delimiter = ';'
         -table = _individu
         -schema = partie2
         -fileColumns = $wb_skip$, $wb_skip$ , $wb_skip$,  nom, prenom, sexe, date_naissance, nationalite, code_postal, ville, $wb_skip$, $wb_skip$, $wb_skip$, INE;
         
BEGIN TRANSACTION

WbImport -file= data/ppn.csv
         -header = true
         -delimiter = ';'
         -table = _programme
         -schema = partie2
         -filecolumns = id_module, $wb_skip$  ,$wb_skip$, coefficient, $wb_skip$, $wb_skip$, $wb_skip$, id_semestre

WbImport -file= data/ppn.csv
         -header = true
         -delimiter = ';'
         -table = _module
         -schema = partie2
         -filecolumns = id_module,ue,libelle_module
         
WbImport -file= data/ppn.csv
         -header = true
         -delimiter = ';'
         -table = _module
         -schema = partie2
         -filecolumns = id_module,ue,libelle_module
         

COMMIT TRANSACTION


