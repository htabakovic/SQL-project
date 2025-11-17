
CREATE TABLE OS(
    id_os SERIAL CONSTRAINT pk_os PRIMARY KEY,
    nom_os VARCHAR(30) NOT NULL,
    version_os VARCHAR(20),
    type_os VARCHAR(20)
);


CREATE TABLE Hyperviseur(
    id_hyperviseur SERIAL CONSTRAINT pk_hyperviseur PRIMARY KEY,
    nom VARCHAR(30) NOT NULL,
    type VARCHAR(10) CONSTRAINT chk_type_hyperviseur CHECK (type IN ('Type1','Type2'))
);


CREATE TABLE MachineVirtuelle(
    id_vm SERIAL CONSTRAINT pk_vm PRIMARY KEY,
    nom_vm VARCHAR(30) NOT NULL,
    taille_disque INT CONSTRAINT chk_taille_disque CHECK (taille_disque > 0),
    mode_stockage VARCHAR(20) CONSTRAINT chk_mode_stockage CHECK (mode_stockage IN ('Fixe','Dynamique')),
    ram_mo INT CONSTRAINT chk_ram CHECK (ram_mo > 0 AND ram_mo <= 65536),
    enseignement VARCHAR(100),
    id_os INT,
    id_hyperviseur INT,
    CONSTRAINT fk_os FOREIGN KEY (id_os) REFERENCES OS(id_os),
    CONSTRAINT fk_hyperviseur FOREIGN KEY (id_hyperviseur) REFERENCES Hyperviseur(id_hyperviseur)
);


CREATE TABLE Logiciel(
    id_logiciel SERIAL CONSTRAINT pk_logiciel PRIMARY KEY,
    nom_logiciel VARCHAR(30) NOT NULL,
    version_logiciel VARCHAR(20)
);


CREATE TABLE VersionVM(
    id_version SERIAL CONSTRAINT pk_version PRIMARY KEY,
    id_vm INT,
    id_logiciel INT,
    CONSTRAINT fk_vm FOREIGN KEY (id_vm) REFERENCES MachineVirtuelle(id_vm),
    CONSTRAINT fk_logiciel FOREIGN KEY (id_logiciel) REFERENCES Logiciel(id_logiciel)
);


CREATE TABLE Demandeur(
    id_demandeur SERIAL CONSTRAINT pk_demandeur PRIMARY KEY,
    nom VARCHAR(30) NOT NULL,
    prenom VARCHAR(30) NOT NULL,
    adresse VARCHAR(50),
    code_postal VARCHAR(10),
    mail VARCHAR(40),
    telephone VARCHAR(15),
    type_demandeur VARCHAR(15) CONSTRAINT chk_type_demandeur CHECK (type_demandeur IN ('Vacataire','Permanent'))
);


CREATE TABLE Vacataire(
    id_demandeur INT CONSTRAINT pk_vacataire PRIMARY KEY,
    tel_mobile VARCHAR(15) CONSTRAINT chk_tel_vacataire CHECK (tel_mobile LIKE '06%' OR tel_mobile LIKE '07%'), 
    societe VARCHAR(40),
    CONSTRAINT fk_vacataire_dem FOREIGN KEY (id_demandeur) REFERENCES Demandeur(id_demandeur)
);


CREATE TABLE Permanent(
    id_demandeur INT CONSTRAINT pk_permanent PRIMARY KEY,
    batiment VARCHAR(20),
    num_bureau VARCHAR(10),
    CONSTRAINT fk_permanent_dem FOREIGN KEY (id_demandeur) REFERENCES Demandeur(id_demandeur)
);


CREATE TABLE Demande(
    id_demande SERIAL CONSTRAINT pk_demande PRIMARY KEY,
    date_demande DATE,
    id_demandeur INT,
    id_vm INT,
    CONSTRAINT fk_demande_demandeur FOREIGN KEY (id_demandeur) REFERENCES Demandeur(id_demandeur),
    CONSTRAINT fk_demande_vm FOREIGN KEY (id_vm) REFERENCES MachineVirtuelle(id_vm)
);


CREATE TABLE Compatibilite(
    id_compatibilite SERIAL CONSTRAINT pk_incompatibilite PRIMARY KEY,
    commentaire VARCHAR (50),
    id_os INT,
    id_logiciel INT,
    CONSTRAINT fk_incompat_os FOREIGN KEY (id_os) REFERENCES OS(id_os),
    CONSTRAINT fk_incompat_logiciel FOREIGN KEY (id_logiciel) REFERENCES Logiciel(id_logiciel)
);




INSERT INTO OS (nom_os, version_os, type_os)
VALUES 
('Windows', '10', 'Microsoft'),
('macOS', '13.5', 'Apple'),
('Debian', '12', 'Linux');


INSERT INTO Hyperviseur (nom, type)
VALUES 
('Hyper-V', 'Type1'),
('VirtualBox', 'Type2');


INSERT INTO MachineVirtuelle 
(nom_vm, taille_disque, mode_stockage, ram_mo, enseignement, id_os, id_hyperviseur)
VALUES 
('VM_Dev', 80, 'Fixe', 4096, 'Prog L3', 1, 2),
('VM_BI', 60, 'Dynamique', 8192, 'NoSQL M2', 2, 1);


INSERT INTO Logiciel (nom_logiciel, version_logiciel)
VALUES 
('PostgreSQL', '16'),
('Python', '3.11'),
('VSCode', '1.90'),
('Git', '2.44');


INSERT INTO Demandeur (nom, prenom, adresse, mail, telephone, type_demandeur)
VALUES 
('Olivier','Martine','2 Rue Soeur Bouvier','oliviermartine@gmail.com','0681564372','Vacataire'),
('Duchene','Yanis','20 av. Albert Einstein','yaduchene@mail.com','0760134026','Permanent'),
('Fontaine','Albert','4 rue de Marseille','albertfon091@gmail.com','0681527390','Permanent'),
('Leblanc','Patrick','163 Cr Tolstoï','patrickpatrick72@gmail.com','0765432198','Vacataire');


INSERT INTO Vacataire (id_demandeur, tel_mobile, societe)
VALUES 
(1, '0681564372', 'Univ Lyon 2'),
(4, '0765432198', 'Foxglove');


INSERT INTO Permanent (id_demandeur, batiment, num_bureau)
VALUES 
(2, 'Bâtiment C', 'B415'),
(3, 'Bâtiment H', 'A001');

INSERT INTO Demande (id_demandeur, id_vm)
VALUES 
(1, 1),
(3,2),
(4,1);




ALTER TABLE Demande
ALTER COLUMN date_demande SET DEFAULT CURRENT_DATE;

ALTER TABLE Demandeur
ALTER COLUMN type_demandeur SET DEFAULT 'Permanent';