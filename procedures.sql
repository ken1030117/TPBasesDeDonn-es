-- Kenny Saint-Cyr
-- Code Perm: SAIK17119305
-- Valentin Pigaux 
-- Code Perm: PIGV74050106
-- Script de Procédures



SET ECHO ON
ALTER SESSION SET NLS_DATE_FORMAT = 'DD/MM/YYYY';

  SET SERVEROUTPUT ON
 /

CREATE OR REPLACE PROCEDURE MeilleursVendeurs
(LaDate Commande.dateHeureCommande%TYPE) IS

LeNumArticle LigneCommande.numArticle%TYPE;
LeQuantiteCommande LigneCommande.quantiteCommande%TYPE;
laDateHeureCommande Commande.dateHeureCommande%TYPE;
Compteur INTEGER := 0;


CURSOR curCommande IS
SELECT numArticle, quantiteCommande, dateHeureCommande
FROM LigneCommande, Commande
WHERE Commande.numCommande = LigneCommande.numCommande 
AND TRUNC(dateHeureCommande, 'IW') = TRUNC(LaDate, 'IW')
ORDER BY quantiteCommande DESC;  

BEGIN
DBMS_OUTPUT.PUT_LINE('numArticle' || '||' || 'quantiteCommande' || '||' || 'dateHeureCommande');
 OPEN curCommande; 
 
LOOP 
FETCH curCommande INTO LeNumArticle, LeQuantiteCommande, laDateHeureCommande; 
EXIT WHEN curCommande%NOTFOUND OR Compteur = 5; 
Compteur := Compteur + 1; 

DBMS_OUTPUT.PUT_LINE(LeNumArticle || '||' || LeQuantiteCommande || '||' || laDateHeureCommande);

END LOOP; 
CLOSE curCommande; 
END MeilleursVendeurs;
/
SHOW ERRORS


COMMIT;
/









