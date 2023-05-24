function [SetIntHammer] = IntHammer(pNbPtsIntg)

% Cette fonction retourne les paramètres necessaires pour l'intégration de
% Hammer dependamment du nombre de poids fourni par l'utilisateur. 
% Elle retourne le nombre points, le vecteur des coordonnées U et V et le
% vecteur regroupe les poids d'intégration

% disp(" ");
% Allocation des vecteurs en fonction du nombre de points
lVectCoorKsi = zeros(1, pNbPtsIntg);
lVectCoorEta = zeros(1, pNbPtsIntg);
lVectPoids = zeros(1, pNbPtsIntg);

switch pNbPtsIntg

    case 1
        lVectCoorKsi(1) = 1/3;
        lVectCoorEta(1) = 1/3;
        lVectPoids(1) = 1/2;
        lNbPtsIng = 1;

    case 3
        lVectCoorKsi = [1/6 2/3 1/6];
        lVectCoorEta = [1/6 1/6 2/3];
        lVectPoids   = [1/6 1/6 1/6];
        lNbPtsIng = 3;

    case 4
        lVectCoorKsi = [1/3   1/5   3/5   1/5 ];
        lVectCoorEta = [1/3   1/5   1/5   3/5 ];
        lVectPoids = [-27/96 25/96 25/96 25/96];
        lNbPtsIng = 4;
    
    otherwise
        disp("ERREUR : le schéma n'est pas pris en compte.")
        disp("SCHEMA AUTORISÉ : [1, 3, 4]");
        lNbPtsIng = 0;
end

SetIntHammer = {lNbPtsIng, lVectCoorKsi, lVectCoorEta, lVectPoids};
end