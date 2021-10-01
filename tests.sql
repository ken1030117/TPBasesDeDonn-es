-- Kenny Saint-Cyr
-- Code Perm: SAIK17119305
-- Valentin Pigaux 
-- Code Perm: PIGV74050106
-- Script de Tests

-- **IMPORTANT POUR QUE LE JAVA FONCTIONNE**
SET SERVEROUTPUT ON 

ALTER SESSION SET NLS_DATE_FORMAT = 'DD/MM/YYYY';

--INSERTION DES VALEURS DANS LES TABLES.
INSERT INTO Client
--Peut être utilisé pour tester les fonctions et le programme Java
(numClient,dateHeureInscription,nom,prenom,courriel,addresse,typeClient)
VALUES (123456,TO_DATE ('03/03/2021 13:24','dd-MM-yyyy
HH24:MI'),'Brighach','Moncef','moncefbrighach@gmail.com','50 rue Bob, Montreal','i');
INSERT INTO Client
(numClient,dateHeureInscription,nom,prenom,courriel,addresse,typeClient)
VALUES (789012,TO_DATE ('03/03/2022 15:24','dd-MM-yyyy
HH24:MI'),'Saint-Cyr','Kenny','saintcyrkenny@gmail.com','50 rue Guy, Montreal','i');
INSERT INTO Fournisseurs (numFournisseur,nomFournisseur)
VALUES (6843,'Lenovo');
INSERT INTO Categories (codeCategorie,codeCategorieParent,nomCategorie)
VALUES (10,100,'Ecrans');
INSERT INTO Article (numArticle,codeCategorie,numFournisseur,description,prix,quantite,URL)
VALUES (342,10,6843,'Ecran 24po',199.99,20,'http://lenovo.ca');
INSERT INTO Article (numArticle,codeCategorie,numFournisseur,description,prix,quantite,URL)
VALUES (600,10,6843,'Ecran 30po',299.99,25,'http://hp.ca');
INSERT INTO Article (numArticle,codeCategorie,numFournisseur,description,prix,quantite,URL)
VALUES (400,10,6843,'Ecran 16po',299.99,45,'http://hp.ca');
INSERT INTO Article (numArticle,codeCategorie,numFournisseur,description,prix,quantite,URL)
VALUES (300,10,6843,'Ecran 12po',299.99,10,'http://hp.ca');
INSERT INTO Article (numArticle,codeCategorie,numFournisseur,description,prix,quantite,URL)
VALUES (200,10,6843,'Ecran 40po',299.99,5,'http://hp.ca');
INSERT INTO Article (numArticle,codeCategorie,numFournisseur,description,prix,quantite,URL)
VALUES (500,10,6843,'Ecran 30po',299.99,2,'http://hp.ca');
INSERT INTO Commande
(numCommande,numClient,dateHeureCommande)
VALUES (0001,123456,TO_DATE ('04/03/2021 23:42','dd-MM-yyyy HH24:MI'));
INSERT INTO Commande
(numCommande,numClient,dateHeureCommande)
VALUES (0002,123456,('13/03/2021'));
INSERT INTO Livraison (numLivraison,numClient,dateLivraison)
VALUES (0001,123456,'06/06/2021');
INSERT INTO Livraison (numLivraison,numClient,dateLivraison)
VALUES (0002,789012,'08/06/2021');

INSERT INTO LigneCommande (numCommande,numArticle,quantiteCommande)
VALUES (0001,342,5);
INSERT INTO LigneCommande (numCommande,numArticle,quantiteCommande)
VALUES (0001,300,6);
INSERT INTO LigneCommande (numCommande,numArticle,quantiteCommande)
VALUES (0001,500,2);
INSERT INTO LigneCommande (numCommande,numArticle,quantiteCommande)
VALUES (0001,400,7);
INSERT INTO LigneCommande (numCommande,numArticle,quantiteCommande)
VALUES (0001,200,5);
INSERT INTO LigneCommande (numCommande,numArticle,quantiteCommande)
VALUES (0001,600,7);
INSERT INTO LigneCommande (numCommande,numArticle,quantiteCommande)
VALUES (0002,600,3);
INSERT INTO Lignelivraison (numLivraison,numArticle,numCommande,qteArticleLivree)
VALUES (0001,342,0001,2);


--TEST Cheeck LigneCommande 
-- Non VALIDE

INSERT INTO LigneCommande VALUES(2,300,0);

--TEST CarteCredit NON VALIDE
INSERT INTO Livraison VALUES(3,123456,'06/09/2021');
INSERT INTO Paiement VALUES(1,3,'06/09/2022',200,2300,2300,2100);
INSERT INTO CarteCredit VALUES(123456789012,3,'H','06/09/2023',1);

-- TEST Trigger AjusterEnStock
INSERT INTO Client
(numClient,dateHeureInscription,nom,prenom,courriel,addresse,typeClient)
VALUES (123,TO_DATE ('03/03/2022 15:24','dd-MM-yyyy
HH24:MI'),'Saint-Cyr','Kenny','saintcyrkenny@gmail.com','50 rue Guy, Montreal','i');
INSERT INTO Fournisseurs (numFournisseur,nomFournisseur)
VALUES (7000,'Compaq');
INSERT INTO Categories (codeCategorie,codeCategorieParent,nomCategorie)
VALUES (11,100,'Tablettes');
INSERT INTO Article VALUES (800,11,7000,'Ecran 30po',599.99,2,'http://hp.ca');
INSERT INTO Commande VALUES (0003,123,'06/09/2021');
INSERT INTO LigneCommande VALUES (0003,800,1);

SELECT quantite
FROM Article;

INSERT INTO Livraison (numLivraison,numClient,dateLivraison)
VALUES (0005,123,'06/06/2021');
--A ce moment, la quantité dans article est réduite. 
INSERT INTO LigneLivraison VALUES (0005,800,0003,1);

SELECT quantite
FROM Article;

-- TEST Trigger BloquerLivraison

INSERT INTO Article VALUES (850,11,7000,'Ecran 30po',599.99,50,'http://hp.ca');
INSERT INTO Commande VALUES (0004,123,'13/03/2021');
INSERT INTO Livraison VALUES (0010,123,'13/03/2021');
INSERT INTO LigneCommande VALUES (0004,850,30);
--La commande devrait être bloquée au niveau commande
INSERT INTO LigneLivraison VALUES (0010,850,0004,40);
--La commande devrait être bloquée au niveau article
INSERT INTO LigneLivraison VALUES (0010,850,0004,70);


-- TEST Trigger BloquerPaiement
INSERT INTO Client
(numClient,dateHeureInscription,nom,prenom,courriel,addresse,typeClient)
VALUES (789012,'03/03/2022','Saint-Cyr','Kenny','saintcyrkenny@gmail.com','50 rue Guy, Montreal','i');
INSERT INTO Livraison VALUES(4,789012,'03/03/2021'); 
INSERT INTO Facture VALUES(4,789012,7,'03/03/2022',11000);

SELECT SUM(Facture.montantApresEscompte) 
FROM Facture;
--Le paiement devrait être bloqué.
INSERT INTO Paiement VALUES(1,4,'06/09/2022',20000,2300,2300,2100);

INSERT INTO Paiement VALUES(2,4,'06/09/2022',10000,2300,2300,2100);

---TEST Procédures MeilleuresVendeurs: 

EXECUTE MeilleursVendeurs('01/03/2021');

COMMIT
/

