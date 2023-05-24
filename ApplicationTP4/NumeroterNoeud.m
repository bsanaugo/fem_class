function [NumNoeud] = NumeroterNoeud(pTableNoeud)

%Cette fonction opère la numérotation des noeuds selon qu'ils ...
% soient libres ou imposés. 
%La fonction prend en argument la table des noeuds et retourne...
% le nombre des noeuds imposés, le nombre des noeuds libres ...
% et le nombre total de noeuds. 
% Attention : on retourne une nouvelle table des noeuds. La nouvelle table
% tient compte de la numérotation des noeuds
% ----------------------------------
% la valeur -1 en cas d'erreur servira à l'arrêt du programme principal


disp(" ");
disp("*********** NUMÉROTATION DES NOEUDS EN COURS ********************");

%Nbre de dégré de liberté total correspond au nbre de ligne pTableNoeud
NbNoeudTot = size(pTableNoeud, 1);
NbNoeudImp = 0;
NbNoeudLibre = 0;

% Initialisation de la numérotation. Tout est remis à zero
% Bien que ce soit à zero, on s'assure en faisant cette opération
for i = 1:NbNoeudTot
    pTableNoeud(i,4) = 0;
end

% Assignation de la nouvelle numérotation des noeuds imposés (negatifs)
for i = 1:NbNoeudTot
    if ~isequal( pTableNoeud(i,3), 0)
        NbNoeudImp = NbNoeudImp + 1;
        pTableNoeud(i,4) = - NbNoeudImp;
    end
end

% on verifie que les conditions aux limites essentielles ont bien été
% prises en compte
if isequal(NbNoeudImp, 0)
    disp("Erreur : Les conditions aux limites essentielles n'ont " + ...
        "pas été prises en compte !!!");
    % on sort avec cette valeur pour l'arrêt du programme principal
     NumNoeud = -1 ;
    return
end

% Assignation de la nouvelle numérotation des noeuds libres (positifs)
for i = 1:NbNoeudTot
    if isequal( pTableNoeud(i, 3), 0)
        NbNoeudLibre = NbNoeudLibre + 1;
        pTableNoeud(i, 4) = NbNoeudLibre;
    end
end

InfoNoeud = [NbNoeudTot, NbNoeudLibre, NbNoeudImp];
NumNoeud = {InfoNoeud, pTableNoeud};

%impression des résultats
fprintf("-> Nombre de Dégré de libertés imposées : %d \n", NbNoeudImp);
fprintf("-> Nombre de Dégré de libertés libres : %d \n" , NbNoeudLibre);
fprintf("-> Nombre de Dégré de libertés total : %d \n", NbNoeudTot);
end