-- Kenny Saint-Cyr
-- Code Perm: SAIK17119305
-- Valentin Pigaux 
-- Code Perm: PIGV74050106
-- Script de Création des Tables


SET ECHO ON
SPOOL "spool_output.txt"

--Création des tables

CREATE TABLE Client (
numClient INTEGER NOT NULL,
dateHeureInscription DATE NOT NULL,
nom VARCHAR (15) NOT NULL,
prenom VARCHAR (15) NOT NULL,
courriel VARCHAR (30) NOT NULL,
addresse VARCHAR (100) NOT NULL,
typeClient CHAR NOT NULL,
PRIMARY KEY (numClient)
);
/

CREATE TABLE Corporatif (
numClient INTEGER NOT NULL,
Compagnie VARCHAR (30) NOT NULL,
numCompagnie INTEGER NOT NULL,
dateHeureInscription DATE NOT NULL,
nom VARCHAR (15) NOT NULL,
prenom VARCHAR (15) NOT NULL,
courriel VARCHAR (30) NOT NULL,
addresse VARCHAR (100) NOT NULL,
typeClient CHAR NOT NULL,
FOREIGN KEY (numClient) REFERENCES Client
);
/

CREATE TABLE Categories (
codeCategorie INTEGER NOT NULL,
codeCategorieParent INTEGER NOT NULL,
nomCategorie VARCHAR (30) NOT NULL,
PRIMARY KEY (codeCategorie)
);
/

CREATE TABLE Fournisseurs (
numFournisseur INTEGER NOT NULL,
nomFournisseur VARCHAR (30) NOT NULL,
PRIMARY KEY (numFournisseur)
);
/

CREATE TABLE Article (
numArticle INTEGER NOT NULL,
codeCategorie INTEGER NOT NULL,
numFournisseur INTEGER NOT NULL,
description VARCHAR (100) NOT NULL,
prix DECIMAL NOT NULL
CHECK (prix >= 0), 
quantite INTEGER NOT NULL
CHECK (quantite >= 0), 
URL VARCHAR (100) NOT NULL,
PRIMARY KEY (numArticle),
FOREIGN KEY (codeCategorie) REFERENCES Categories,
FOREIGN KEY (numFournisseur) REFERENCES Fournisseurs
);
/

CREATE TABLE Commande (
numCommande INTEGER NOT NULL,
numClient INTEGER NOT NULL,
dateHeureCommande DATE NOT NULL,
PRIMARY KEY (numCommande),
FOREIGN KEY (numClient) REFERENCES Client
);
/

CREATE TABLE LigneCommande (
numCommande INTEGER NOT NULL,
numArticle  INTEGER NOT NULL,
quantiteCommande    INTEGER NOT NULL
CHECK (quantiteCommande > 0),
PRIMARY KEY (numCommande,numArticle),
FOREIGN KEY (numCommande) REFERENCES Commande,
FOREIGN KEY (numArticle) REFERENCES Article
);
/

CREATE TABLE ConsulterCommandes (
numClient INTEGER NOT NULL,
numCommande INTEGER NOT NULL,
dateHeureCommande INTEGER NOT NULL,
FOREIGN KEY (numClient) REFERENCES Client,
FOREIGN KEY (numCommande) REFERENCES Commande
);
/

CREATE TABLE Livraison (
numLivraison              INTEGER NOT NULL,
numClient                 INTEGER NOT NULL,
dateLivraison             DATE NOT NULL,
PRIMARY KEY (numLivraison),
FOREIGN KEY (numClient)   REFERENCES Client
);

CREATE TABLE LigneLivraison (
numLivraison INTEGER NOT NULL,
numArticle INTEGER NOT NULL,
numCommande  INTEGER NOT NULL,
qteArticleLivree  INTEGER NOT NULL,
FOREIGN KEY (numLivraison) REFERENCES Livraison,
FOREIGN KEY (numArticle) REFERENCES Article,
FOREIGN KEY (numCommande)  REFERENCES Commande
);
/

CREATE TABLE Facture (
numLivraison             INTEGER NOT NULL,     
numClient                INTEGER NOT NULL,     
qteArticle 	             INTEGER NOT NULL,    
dateLimitePaiement       DATE NOT NULL,      
montantApresEscompte     DECIMAL NOT NULL, 
PRIMARY KEY (numLivraison), 
FOREIGN KEY (numClient)  REFERENCES Client
); 
/

CREATE TABLE Paiement (   
numPaiement         INTEGER NOT NULL,
numLivraison        INTEGER NOT NULL,     
datePaiement 	    DATE NOT NULL,     
montantPaiement 	DECIMAL NOT NULL,     
montantTotalFacture DECIMAL NOT NULL,     
totalPaiement 	    DECIMAL NOT NULL,     
montantRestant 	    DECIMAL NOT NULL, 
    PRIMARY KEY (numPaiement), 
    FOREIGN KEY (numLivraison) REFERENCES Livraison 
); 
/

CREATE TABLE CarteCredit (     
numCarte             VARCHAR (12) NOT NULL,     
numLivraison         INTEGER NOT NULL, 
typeCarte            VARCHAR (2) NOT NULL    
CHECK (typeCarte IN ('V','MC', 'AE')),
moisExpiration       DATE NOT NULL,     
numPaiement	         INTEGER NOT NULL, 
PRIMARY KEY (numCarte), 
FOREIGN KEY (numLivraison) REFERENCES Paiement
); 
/

CREATE TABLE Cheque (     
numCheque 	INTEGER NOT NULL,     
numLivraison 	INTEGER NOT NULL,     
idBanqueClient       INTEGER NOT NULL,     
idBanque 	            INTEGER NOT NULL, 
PRIMARY KEY (numCheque), 
FOREIGN KEY (numLivraison) REFERENCES Paiement 
); 
/

COMMIT
/

