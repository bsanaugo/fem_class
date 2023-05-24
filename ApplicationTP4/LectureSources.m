function [lNewTableElement, lTableSource] = ...
    LectureSources(pFichierGiD,pTableElement)
%Cette fonction permet la construction des termes sources ou puits de
%chaleur dans le système. 
% Elle prend en argument le fichier de base de données GiD et la table des
% éléments. Le renseignement de la table des éléments se fait egalement au
% sortie de cette fonction; ainsi à la fin, on obtient la table des termes
% sources ou puits et une nouvelle table des éléments.
% -------------------------------
% la valeur -1 en cas d'erreur servira à l'arrêt du programme principal

disp(" ");
disp("********* LECTURE DES SOURCES/PUITS DE CHALEUR EN COURS **********");
IdFichier = fopen(pFichierGiD,"r");

%==== TROUVER L'INFORMATION SUR LES TERMES SOURCES  ET/OU PUITS ========

while true % parcours de tout le fichier

    %-----lecture de la premiere ligne du fichier .dat
    LirLigne = fgetl(IdFichier);

    %------Si la ligne lue contient le mot clé SOURCE/PUIT
    if contains(LirLigne,'SOURCE/PUIT')
        InfoElemSource = textscan(LirLigne, '%s  %d');
        % on récupère le nombre d'éléments contenant des TERMES SOURCES
        lNbElemSource = InfoElemSource{2};
        % Test sur le contenu «lNbElemSource»
        if isempty(lNbElemSource)
            disp("Le bloc SOURCE/PUIT n'est pas defini dans " + ...
                " le fichier de données");
            lTableSource = -1;
            return

        % test sur le nombre d'éléments contenant des TERMES SOURCES
        elseif isequal(lNbElemSource, 0)
            disp(" Il n'y a pas de terme source Q = 0");
            lTableSource = 0;
            lNewTableElement = pTableElement;
            return
        end

        break % Arrêt de la boucle while dès que la bonne valeur trouvée

%-si la ligne lue est non vide et ne contient pas le mode clé SOURCE/PUIT
    elseif ~contains(LirLigne,'SOURCE/PUIT') || ~isempty(LirLigne)
        continue

    %----si la ligne lue est vide alors elle est vide ou erreur fichier
    else  
        disp('Fin du fichier atteinte ou le fichier est corrompu');
        disp("le bloc SOURCE/PUIT est introuvable");
        lTableSource = -1;
        return
    end 
end

%=====Initialisation de la table des TERMES SOURCES ============
%---- format de la table : Identifiant|Q(X,Y)_Q est fonction de X et Y

%-- initialisation du compteur à 1 du nombre de variante de conditions
% aux limites naturelles. En effet, les valeurs pouvant variées d'un ...
% élément à un autre, alors les conditions seront comptabilisé comme des
% conditions aux limites naturelles differentes
lComptSource = 1;
LirLigne = fgetl(IdFichier);
InfoElemSource = textscan(LirLigne, '%s %d %s');

%-- Initialisation de la table des termes sources
lTableSource = {};
lTableSource{1, 1} = InfoElemSource{1};

% ON RAPPELLE que Q est fonction de X et Y
% On gère une eventualité ou Q serait un nombre, dans ce cas un
% petit test sur la valeur de Q s'impose avant de continuer
testQ = str2double(InfoElemSource{3});
if isnan(testQ)
    lTableSource{1,2} = str2sym(InfoElemSource{3});
else
    lTableSource{1,2} = testQ;
end

pTableElement{InfoElemSource{2},3} = lComptSource;

%========== remplissage pre-traitement ==================================
%--- boucle de remplissage sur les éléments contenants des TERMES SOURCES 

for i = 1:(lNbElemSource-1)
    LirLigne = fgetl(IdFichier);

    %-- format de la ligne dans le fichier GiD
    %-- Identifiant|NumElement|CoeffConvection|TemperatureAir
    InfoElemSource = textscan(LirLigne, '%s %d %s');

    %-- Test pour savoir si la ligne lue est identique...
    % au terme sources précédents 
    lMemeSource = false;
    for j = 1:lComptSource
        if isequal(InfoElemSource{1}, lTableSource{j,1})
            lMemeSource = true;
            break
        end
    end

    % On renseigne la table des éléments (colonne N­°3) par le numéro de la
    % variante de TERMES SOURCES (valeur j)
    pTableElement{InfoElemSource{2},3} = j;

    % dans le cas ou la ligne lue est différente des lignes précédentes de
    % la table(en construction), alors on renseigne la table des TERMES 
    % SOURCES avec une nouvelle ligne (nouvelle variante)

    if isequal(lMemeSource, false) && ~isequal(i, 1)
        lTableSource{j, 1} = InfoElemSource{1};
        
        %test sur le type du TERME SOURCE DE LA LIGNE
        testQ = str2double(InfoElemSource{3});
        if isnan(testQ)
            lTableSource{j,2} = str2sym(InfoElemSource{3});
        else
            lTableSource{j,2} = testQ;
        end        
        lComptSource = lComptSource + 1;
    end
end

%-- recupération des résultats
lNewTableElement = pTableElement;
fclose(IdFichier);

%---impression resultats
fprintf("-> Il y a %d variante(s) de TERMES SOURCES \n", lComptSource);
fprintf("-> Nombre d'éléments contenant des TERMES SOURCES : %d \n",...
    lNbElemSource);
end
