function [GlobSystemAsmbled] = AssembleGlobSystem(pBDinterne,...
    pGlobSystem, pContribElem)

% Cette fonction opère l'assemblage de la contribution dans le système
% globale. Pour ce faire, elle prend en argument la base de données
% internes, le système matriciel global et la contribution élémentaire. 
% ce programme prend en compte l'assemblage pour les contributions de type
% linéique et triangulaire. 

%-- Extraction de MatKGlobSystem et VectFelemGlob
lMatKGlobSystem = pGlobSystem{1};
lVectFelemGlob = pGlobSystem{2};

%--- récupération du numéro de l'élément, de MatKelem et VectFelem
lNumElem = pContribElem{1};
lMatKelem = pContribElem{2};
lVectFelem = pContribElem{3};

%--- Nombre de dégré de liberté à assembler
lNbDegAss = length(lVectFelem);

%--- extraction de la table des noeuds
lTableNoeud = pBDinterne{1};

%--- table des éléments 
lTableElem = pBDinterne{2}; 

%--- Table des conditions aux limites essentielles
lTableCondLimitEs = pBDinterne{5};

%--- boucle sur les dégrés de liberté à assembler
for i = 1:lNbDegAss

    %-- numérotation de la ligne du dégré de liberté
    NumEqLine = lTableNoeud( lTableElem{lNumElem,5}(i), 4);

    %-- est-ce un degré libre ?
    if (NumEqLine > 0) % oui

        %-- boucle sur les colonnes 
        for j = 1:lNbDegAss
            
            %-- recupération de la numérotation de la colonne
            NumEqCol = lTableNoeud( lTableElem{lNumElem,5}(j), 4);
            
            %--- est un dégré libre ?
            if (NumEqCol > 0) % oui
                lMatKGlobSystem(NumEqLine, NumEqCol) = lMatKGlobSystem...
                    (NumEqLine, NumEqCol) + lMatKelem(i,j);

            %--- si imposé = contribution au second membre
            else
                lVectFelemGlob(NumEqLine) = lVectFelemGlob(NumEqLine) - ...
                    lMatKelem(i,j) * cell2mat( lTableCondLimitEs(...
                    lTableNoeud(lTableElem{lNumElem,5}(j), 3) ,2)); 
            end
        end
        %-- Ajout de la contribution au second membre
        lVectFelemGlob(NumEqLine) = lVectFelemGlob(NumEqLine) - ...
            lVectFelem(i);
    end
end
% recupération des résultats
GlobSystemAsmbled = {lMatKGlobSystem, lVectFelemGlob};
end