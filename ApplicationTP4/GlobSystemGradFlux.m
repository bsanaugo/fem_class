function [BDInterneUpdated] = GlobSystemGradFlux(pBDInterne)
% Cette fonction permet l'assemblage du vecteur global des gradients et des
% flux élémentaires. Une moyenne en fonction de l'occurence d'un noeud est
% utilisé pour résoudre les discontinuités des valeurs aux noeuds.
% La fonction retourne, une mise à jour de la table des noeuds donc une
% mise à jour de la base de données interne nommée «BDInterneUpdated».
% Elle prend en argument la base de données interne.

%--> Extraire la table des noeuds
lTableNoeud = pBDInterne{1};

%--> Extraire la table des éléments
lTableElem = pBDInterne{2};

%--> Nombre de noeuds total 
lNbNoeud = size(lTableNoeud, 1);

%--> Nombre d'éléments total 
lNbElem = size(lTableElem, 1);

%--> Vecteur des occurences des noeuds et initialisation
lVectOccur = zeros(lNbNoeud, 1);

%--> initialisation des variables internes (colonnes qui recevront)
for i =1:lNbNoeud
    lTableNoeud(i,6) = 0.0; %--> dTdx
    lTableNoeud(i,7) = 0.0; %--> dTdy
    lTableNoeud(i,8) = 0.0; %--> qx
    lTableNoeud(i,9) = 0.0; %--> dy
end

%--> Boucle sur les éléments: calcul et assemblage des variables internes
for i = 1:lNbElem
     
    % Est-ce que ce n'est pas un élément de contour ?
    if ~isequal(lTableElem{i,1}, 0)

        % gradient et flux de l'élément i
        lMatGradFluxElem = CalculGradFluxElem(pBDInterne, i);

        % Recuperation du nombre de noeuds de l'élément
        lNbNoeudElem = length( cell2mat(lTableElem(i, 5)) );

        % boucle sur les noeuds de l'élément i
        for j = 1:lNbNoeudElem
            NumNoeud = lTableElem{i, 5}(j);
            lVectOccur(NumNoeud) = lVectOccur(NumNoeud) + 1;

            % boucle sur le contenu de la matrice de resultats MatGradFlux
            % A cette étape chaque gradient et flux élémentaire est
            % assemblé dans la table des noeuds.
            for k = 1:4
                lTableNoeud(NumNoeud, 5+k) = lTableNoeud(NumNoeud, 5+k) +...
                    lMatGradFluxElem(j, k);
            end
        end
    end
end

%--> Une autre boucle permet le calcul la moyenne des valeurs du gradient
% et du flux à un noeud  en fonction de l'occurence du noeud.
for i = 1:lNbNoeud
    for k = 1:4
        lTableNoeud(i,5+k) = lTableNoeud(i,5+k) / lVectOccur(i);
    end 
end

%--> Mise à jour de la base de données interne
pBDInterne{1} = lTableNoeud;
BDInterneUpdated = pBDInterne;
end