function [lNewTableNoeud, lTableCondLimitEs] = LectureCLEss(pFichierGiD,...
    pTableNoeud)
%Cette fonction permet la construction des conditions limites
%essentielles. Il s'agit des noeuds dont il a été imposée une valeur de 
% température.
% Elle prend en argument le fichier de base de données GiD et la table des
% noeuds. Le renseignement de la table des noeuds se fait egalement au
% sortie de cette fonction; ainsi à la fin, on obtient la table des
% conditions essentielles et une nouvelle table des noeuds. 
% -----------------------
% la valeur -1 en cas d'erreur servira à l'arrêt du programme principal

disp(" ");
disp("****** LECTURE DES CONDITIONS LIMITES ESSENTIELLES EN COURS *****");
IdFichier = fopen(pFichierGiD,"r");

%==== TROUVER L'INFORMATION SUR LES CONDITIONS LIMITES ESSENTIELLES ====

while true % parcours de tout le fichier

    %-----lecture de la premiere ligne du fichier .dat
    LirLigne = fgetl(IdFichier);

    %------Si la ligne lue contient le mot clé CLE
    if contains(LirLigne,'CLE')
        InfoNoeudLimEs = textscan(LirLigne, '%s  %d');
        % on récupère le nombre de noeuds (LIMITES ESSENTIELLES)
        lNbNoeudLimEs = InfoNoeudLimEs{2};
        % test sur le nombre de noeuds (LIMITES ESSENTIELLES)
        if isempty(lNbNoeudLimEs) || lNbNoeudLimEs == 0
            disp("Le bloc CLE n'est pas defini dans..." + ...
                " le fichier de donnees");
            lTableCondLimitEs = -1;
            return
        end
        break % Arrêt de la boucle while une fois la bonne valeur trouvée

    %-si la ligne lue est non vide et ne contient pas le mode clé CLE
    elseif ~contains(LirLigne,'CLE') || ~isempty(LirLigne)
        continue

    %----si la ligne lue est vide alors elle est vide ou erreur fichier
    else  
        disp('Fin du fichier atteinte ou le fichier est corrompu');
        disp("le bloc CLE est introuvable");
        lTableCondLimitEs = -1;
        return
    end 
end

%=====Initialisation de la table des CONDITIONS LIMITES ESSENTIELLES ======
%---- format de la table : Identifiant|TemperatureImposée

%-- initialisation du compteur à 1 du nombre de variante de conditions
% aux limites essentielles. En effet, les valeurs pouvant variées d'un ...
% élément à un autre, alors les conditions seront comptabilisé comme des
% conditions aux limites naturelles differentes.

%----- ici on traite le cas 1, en supposant qu'on a une variante. Les
%lignes suivantes seront comparées avec elle. 

lComptCondLimitEs = 1;
LirLigne = fgetl(IdFichier);
InfoNoeudLimEs = textscan(LirLigne, '%s %d %f');

%-- Initialisation de la table des conditions aux limites essentielles
lTableCondLimitEs = {};
lTableCondLimitEs{1,1} = InfoNoeudLimEs{1};
lTableCondLimitEs{1,2} = InfoNoeudLimEs{3};

pTableNoeud(InfoNoeudLimEs{2},3) = lComptCondLimitEs;

%==================== remplissage pre-traitement =========================
%--- boucle de remplissage sur les noeuds contenant les conditions
%essentiells

for i = 1:(lNbNoeudLimEs-1)
    LirLigne = fgetl(IdFichier);

    %-- format de la ligne dans le fichier GiD
    %-- Identifiant|NumNoeud|TemperatureImposée
    InfoNoeudLimEs = textscan(LirLigne, '%s %d %f');

    %-- Test pour savoir si la ligne lue est identique aux conditions
    % limites essentielles précédentes. 
    lMemeVarianteLimEs = false;
    for j = 1:lComptCondLimitEs
        if isequal(InfoNoeudLimEs{1},lTableCondLimitEs{j,1})
            lMemeVarianteLimEs = true;
            lNumVariante = j;
            break
        elseif isequal(j, lComptCondLimitEs)
            lNumVariante = j + 1; 
        end
    end

    % On renseigne la table des éléments (colonne N­°3) par le numéro de la
    % variante de condition aux limites essentielles (valeur j)
    pTableNoeud(InfoNoeudLimEs{2},3) = lNumVariante;

    % dans le cas ou la ligne lue est différente des lignes précédentes de
    % la table(en construction), alors on renseigne la tablde ...
    % des conditions aux limites essentielles avec ...
    % une nouvelle ligne (nouvelle variante)
    if isequal(lMemeVarianteLimEs, false) && ~isequal(i, 1)
        lTableCondLimitEs{j+1, 1} = InfoNoeudLimEs{1};
        lTableCondLimitEs{j+1, 2} = InfoNoeudLimEs{3};
        lComptCondLimitEs = lComptCondLimitEs + 1;
    end 
end 

lNewTableNoeud = pTableNoeud;
fclose(IdFichier);

%--- impression resultats
fprintf("-> Il y a %d variante(s) de condition(s) aux limites" + ...
    " essentielles traitées \n", lComptCondLimitEs);
fprintf("-> Ces conditions aux limites essentielles sont " + ...
    "appliquées à %d noeuds \n", lNbNoeudLimEs);

end