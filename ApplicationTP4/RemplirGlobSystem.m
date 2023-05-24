function [lGlobSystemRempli] = RemplirGlobSystem(pBDInterne, pGlobSystem)

%Cette fonction enclenche du le remplissage du sytème de matrice ...
% globale qui a été aloué. Elle prend en argument la base de données ...
% interne et le système global vide. 
% A la fin de la fonction le système est assemblé pour la résolution
% finale.


% --- Extraction de la Table des éléments
lTableElem = pBDInterne{2};

%--- extraction du nombre d'léments : 
% il suffit de lire le nombre de ligne de la table des éléments
lNbElem = size(lTableElem, 1);

%--- Bouble de remplissage sur les éléments
for i = 1:lNbElem
    
    %-- contribution élémentaire MatKelem et VectFelem
    lContribElem = CalculContribElem(pBDInterne, i);

    %-- Assemblage de la contribution dans le système globale
    pGlobSystem = AssembleGlobSystem(pBDInterne, ...
        pGlobSystem, lContribElem);
end

%-- on recupère le système globale modifié
lGlobSystemRempli =  pGlobSystem;
end