function [lTableNoeud] = LectureNoeud(pFichierGiD)
%Cette fonction permet de recupérer dans le fichier .dat fourni par le...
% logiciel GiD la table des noeuds qui definissent le système à étudier.
% On récupère également le nombre total de noeuds. 
% le programme parcourt le fichier .dat et recupère la ligne des NOEUDS et
% le nombre de noms. 
% Si cette ligne n'existe pas, alors le programme retourne un message
% d'erreur.
% Par ailleurs, un test est fait d'emblée sur le fichier afin de décéler
% des anomalies; gage d'un bon déroulement de la suite du programme.
%           -----------------------------------
% La table des noeuds contient au post-traitement : les coordonnées X et Y
% de chaque noeuds, la condition aux limites essentielles, les numéros
% d'équations; 
% En post-traitement, nous obtiendrons les températures, le gradient de
% flux en X et Y
% --------------------------------------
% la valeur -1 en cas d'erreur servira à l'arrêt du programme principal

disp(" ");
disp("******************* LECTURE DES NOEUDS EN COURS *****************");
IdFichier = fopen(pFichierGiD,"r");

%============= TROUVER L'INFORMATION SUR LES NOEUDS ====================

while true % parcours de tout le fichier

    %-----lecture de la premiere ligne du fichier .dat
    LirLigne = fgetl(IdFichier);

    %------Si la ligne lue contient le mot clé NOEUD
    if contains(LirLigne,'NOEUD')
        InfoNoeud = textscan(LirLigne, '%s  %d');
        % on récupère le nombre de noeud
        lNbNoeud = InfoNoeud{2}; 
        % test sur le nombre de noeud récupéré
        if isempty(lNbNoeud) || lNbNoeud == 0
            disp("Le bloc NOEUD n'est pas defini dans..." + ...
                " le fichier de donnees");
            lTableNoeud = -1;
            return
        end
        break % on arrete la boucle une fois la bonne valeur trouvée

    %----si la ligne lue est non vide et ne contient pas le mode clé NOEUD
    elseif ~contains(LirLigne,'NOEUD') || ~isempty(LirLigne)
        continue

    %----si la ligne lue est vide soit elle est vide ou erreur fichier
    else  
        disp('Fin du fichier atteinte ou le fichier est corrompu');
        disp("le bloc NOEUD est introuvable")
        lTableNoeud = -1;
        return
    end 
end

%============ Allocation de la table des noeuds ======================
% on a une matrice de (Nbreligne = Nombre noeuds X 9 colonnes)
lTableNoeud = zeros(lNbNoeud,9);

%============ Remplissage pré-traitement ============================
    %-- boucle sur les noeuds
for i = 1:lNbNoeud
    LirLigne = fgetl(IdFichier);
    InfoNoeud = textscan(LirLigne, '%d %f %f');

    %coordonnees en X
    lTableNoeud(i,1) = InfoNoeud{2};
    %coordonnees en Y
    lTableNoeud(i,2) = InfoNoeud{3};
   
end
fclose(IdFichier);
fprintf('-> Le nombre de noeuds traités est %d \n', lNbNoeud);
end
