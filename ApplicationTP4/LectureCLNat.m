function [lNewTableElement, lTableCondLimitNat] = ...
    LectureCLNat(pFichierGiD, pTableElement)
%Cette fonction recueille les conditions aux limites naturelles du
%problèmes à partir du fichier de données obtenu à partir de GiD. 
%Elle prend en argument le fichier ayant pour extension .dat et construit
%cette table constituée des éléments concernés par le terme de convection.
% Le renseignement de la table des éléments se fait egalement au
% sortie de cette fonction; ainsi à la fin, on obtient la table des
% conditions limites naturelle et une nouvelle table des éléments.
% la valeur -1 en cas d'erreur servira à l'arrêt du programme principal

disp(" ");
disp("***** LECTURE DES CONDITIONS LIMITES NATURELLES EN COURS ********");
IdFichier = fopen(pFichierGiD,"r");

%==== TROUVER L'INFORMATION SUR LES CONDITIONS LIMITES NATURELLES ========

while true % parcours de tout le fichier

    %-----lecture de la premiere ligne du fichier .dat
    LirLigne = fgetl(IdFichier);

    %------Si la ligne lue contient le mot clé CONVECTION
    if contains(LirLigne,'CONVECTION')
        InfoElemLimitNat = textscan(LirLigne, '%s  %d');
        % on récupère le nombre d'éléments (conditions LIMITES NATURELLES)
        lNbElemLimitNat = InfoElemLimitNat{2};
        % Test sur le contenu «lNbElemLimitNat»
        if isempty(lNbElemLimitNat) 
            disp("Le bloc CONVECTION n'est pas defini dans " + ...
                " le fichier de donnees");
            lTableCondLimitNat = -1;
            return

        % test sur le nombre d'éléments contenant des CLN
        elseif isequal(lNbElemLimitNat, 0)
             disp(" Il n'y a pas de flux imposé q = 0 (pas de " + ...
                 "conditions naturelles dans ce problème");
             lTableCondLimitNat = 0;
             lNewTableElement = pTableElement;
            return
        end

        break % Arrêt de la boucle while une fois la bonne valeur trouvée

%-si la ligne lue est non vide et ne contient pas le mode clé CONVECTION
    elseif ~contains(LirLigne,'CONVECTION') || ~isempty(LirLigne)
        continue

    %----si la ligne lue est vide alors elle est vide ou erreur fichier
    else  
        disp('Fin du fichier atteinte ou le fichier est corrompu');
        disp("le bloc ELEMENT est introuvable");
        lTableCondLimitNat = -1;
        return
    end 
end

%===== Initialisation de la table des COND. LIMITES NATURELLES ==========
%---- format de la table : Identifiant|CoefConvection|TemperatureAir

%-- initialisation du compteur à 1 du nombre de variante de conditions
% aux limites naturelles. En effet, les valeurs pouvant variées d'un ...
% élément à un autre, alors les conditions seront comptabilisé comme des
% conditions aux limites naturelles differentes
lComptCondLimit = 1;
LirLigne = fgetl(IdFichier);
InfoElemLimitNat = textscan(LirLigne, '%s %d %f %f');

%-- Initialisation de la table des conditions aux limites naturelles
lTableCondLimitNat = {};
lTableCondLimitNat{1,1} = InfoElemLimitNat{1};
lTableCondLimitNat{1,2} = InfoElemLimitNat{3};
lTableCondLimitNat{1,3} = InfoElemLimitNat{4};
pTableElement{InfoElemLimitNat{2},2} = lComptCondLimit;

%===================== remplissage pre-traitement =======================
%--- boucle de remplissage sur les éléments aux conditions aux limites de
%type naturelle sont appliquées

for i = 1:(lNbElemLimitNat-1)
    LirLigne = fgetl(IdFichier);

    %-- format de la ligne dans le fichier GiD
    %-- Identifiant|NumElement|CoeffConvection|TemperatureAir
    InfoElemLimitNat = textscan(LirLigne, '%s %d %f %f');

    %-- Test pour savoir si la ligne lue est identique aux conditions
    %limites naturelles précédentes. 
    lMemeVarianteLimit = false;
    for j = 1:lComptCondLimit
        if isequal(InfoElemLimitNat{1}, lTableCondLimitNat{j,1})
            lMemeVarianteLimit = true;
            lNumVariante = j;
            break
    % si on atteint la dernière variante et qu'il y a difference ...
    % alors on crée un nouveau numéro de variante de condition
        elseif isequal(j, lComptCondLimit)
            lNumVariante = j + 1;
        end
    end
    
    % On renseigne la table des éléments (colonne N­°2) par le numéro de la
    % variante de condition aux limites naturelles (valeur j)
    pTableElement{InfoElemLimitNat{2},2} = lNumVariante;

    % dans le cas ou la ligne lue est différente des lignes précédentes de
  % la table (en construction), alors on renseigne la tablde des conditions
    % aux limites naturelles avec une nouvelle ligne (nouvelle variante)
    if isequal(lMemeVarianteLimit,false) && ~isequal(i,1)
        lTableCondLimitNat{j+1,1} = InfoElemLimitNat{1};
        lTableCondLimitNat{j+1,2} = InfoElemLimitNat{3};
        lTableCondLimitNat{j+1,3} = InfoElemLimitNat{4};
        lComptCondLimit = lComptCondLimit + 1;
    end 
end 
lNewTableElement = pTableElement;
fclose(IdFichier);
fprintf("-> Il y a %d variante(s) de condition(s) aux limites" + ...
    " naturelles traitées \n", lComptCondLimit );
fprintf("-> Ces conditions aux limites naturelles sont " + ...
    "appliquées à %d éléments \n", lNbElemLimitNat);
end