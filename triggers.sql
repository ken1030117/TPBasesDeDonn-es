-- Kenny Saint-Cyr
-- Code Perm: SAIK17119305
-- Valentin Pigaux 
-- Code Perm: PIGV74050106
-- Script de Triggers

-- TRIGGERS

--Trigger: AjusterQteEnStock
-- Ajuste en stock la quantit� en stock lorsqu'une quantit� est command�e.
CREATE OR REPLACE TRIGGER AjusterQteEnStock
AFTER INSERT ON LigneLivraison
REFERENCING
NEW AS NewArticle
FOR EACH ROW 
BEGIN 
     UPDATE Article
     SET Article.quantite = Article.quantite - :NewArticle.qteArticleLivree
     WHERE Article.numArticle = :NewArticle.numArticle;
END; 
/

--Trigger: BloquerLivaison
-- Blocque l'insertion d'une Livraison si la quantit� d'article command� exc�de
-- la quantit� en stock. 
CREATE OR REPLACE TRIGGER BloquerLivraison
BEFORE INSERT ON LigneLivraison
REFERENCING
NEW AS NewLivraison
FOR EACH ROW 
DECLARE
nbreCommandees INTEGER;
quantiteStock INTEGER;

BEGIN 
     SELECT quantite
     INTO   quantiteStock
     FROM   Article 
     WHERE  Article.numArticle = :NewLivraison.numArticle;
     
     SELECT quantiteCommande
     INTO   nbreCommandees
     FROM   LigneCommande
     WHERE  LigneCommande.numArticle = :NewLivraison.numArticle;
     
     IF :NewLivraison.qteArticleLivree > nbreCommandees THEN
     raise_application_error(-20100, 'La quantit� livr�e excede la quantit� command�e.'); 
     END IF; 
     
     IF :NewLivraison.qteArticleLivree > quantiteStock THEN
     raise_application_error(-20100, 'La quantit� livr�e excede la quantit� en stock.'); 
     END IF; 
     
END; 
/
SHOW ERRORS 

--Trigger: BloquerPaiement
-- Blocque l'insertion d'un Paiement si le montant du paiement exc�de
-- le paiement restant.. 
CREATE OR REPLACE TRIGGER BloquerPaiement
BEFORE INSERT ON Paiement
REFERENCING
NEW AS NewPaiement
FOR EACH ROW 
DECLARE
paiementTotal DECIMAL;
montantTotalFacture DECIMAL;

BEGIN
SELECT SUM(Facture.montantApresEscompte) 
INTO montantTotalFacture
FROM Facture
WHERE Facture.numLivraison = :NewPaiement.numLivraison;

SELECT SUM(montantPaiement)
INTO   paiementTotal
FROM   Paiement 
WHERE  Paiement.numLivraison = :NewPaiement.numLivraison;

IF :NewPaiement.montantPaiement > (montantTotalFacture - paiementTotal) THEN
raise_application_error(-20100, 'Le paiement exc�de le montant qui reste � payer.');  

END IF; 

END; 
/
SHOW ERRORS 
