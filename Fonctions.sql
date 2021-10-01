-- Kenny Saint-Cyr
-- Code Perm: SAIK17119305
-- Valentin Pigaux 
-- Code Perm: PIGV74050106
-- Script de Fonctions
-- FONCTIONS

SET ECHO ON

-- Fonction: QuantiteDejaLivree
-- Retourne la quantité livrée de la commande.
CREATE OR REPLACE FUNCTION QuantiteDejaLivree
(leNumArticle LigneLivraison.numArticle%TYPE, leNumCommande ligneLivraison.numCommande%TYPE)
RETURN LigneLivraison.qteArticleLivree%TYPE IS

-- Déclaration de variables
QuantiteDejaLivree LigneLivraison.qteArticleLivree%TYPE;
BEGIN
  SELECT SUM(qteArticleLivree)
  INTO QuantiteDejaLivree
  FROM LigneLivraison
  WHERE numArticle = leNumArticle OR numCommande = leNumCommande; 
END QuantiteDejaLivree;
/
SHOW ERRORS

SELECT *
FROM Livraison;
-- Fonction: TotalFacture
-- Retourne le total de la facture.
CREATE OR REPLACE FUNCTION TotalFacture
(leNumLivraison Facture.numLivraison  %TYPE)
RETURN Facture.montantApresEscompte%TYPE IS

-- Déclaration de variables
  leMontantTotalFacture Facture.montantApresEscompte%TYPE;
BEGIN 
  SELECT montantApresEscompte
  INTO leMontantTotalFacture
  FROM Facture
  WHERE numLivraison = leNumLivraison;
  RETURN leMontantTotalFacture;
END TotalFacture;
/
SHOW ERRORS
