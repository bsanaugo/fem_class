function [lTableMateriau] = LectureMateriau(pFichierGiD)
%Cette fonction permet de construire la table des materiaux des éléments
%qui constituent le systéme. 
%Elle prend en argument le nom du fichier basé de données produit par GiD
%il s'agit principalement de la conductivité thermique du matériau
% la valeur -1 en cas d'erreur servira à l'arrêt du programme principal

disp(" ");
disp("************* LECTURE DES MATERIAUX EN COURS ********************");
IdFichier = fopen(pFichierGiD,"r");

%============= TROUVER L'INFORMATION SUR LES MATERIAUX ====================
while true % parcours de tout le fichier

    %-----lecture de la premiere ligne du fichier .dat
    LirLigne = fgetl(IdFichier);

    %------Si la ligne lue contient le mot clé MATERIAU
    if contains(LirLigne,'MATERIAU')
        InfoMateriau = textscan(LirLigne, '%s  %d');
        % on récupère le nombre de MATERIAU
        lNbMateriau = InfoMateriau{2}; 
        % test sur le nombre de MATERIAU récupéré
        if isempty(lNbMateriau) || lNbMateriau == 0
            disp("Le bloc MATERIAU n'est pas defini dans..." + ...
                " le fichier de données");
            lTableMateriau = -1;
            return
        end
        break % on arrete la boucle une fois la bonne valeur trouvée

   %--si la ligne lue est non vide et ne contient pas le mode clé MATERIAU
    elseif ~contains(LirLigne,'MATERIAU') || ~isempty(LirLigne)
        continue

    %----si la ligne lue est vide; soit elle est vide ou erreur fichier
    else  
        disp('Fin du fichier atteinte ou le fichier est corrompu');
        disp("le bloc MATERIAU est introuvable");
        lTableMateriau = -1;
        return
    end 
end

%============ Allocation de la table des MATERIAUX ======================
%---- initialisation ...
lTableMateriau = {};

%============ Remplissage pré-traitement ============================
for i = 1:lNbMateriau
    LirLigne = fgetl(IdFichier);
    InfoMateriau = textscan(LirLigne, '%d %s');
    testMateriau = str2double(InfoMateriau{2});

    % si la conductivité est fonction de X et/ou Y alors ...
    if isnan(testMateriau)
        lTableMateriau{i,1} = str2sym(InfoMateriau{2});
    else
        lTableMateriau{i,1} = testMateriau;
    end
end

fclose(IdFichier);
fprintf("-> Il y a %d materiau(x) traité(s) \n", lNbMateriau);
end