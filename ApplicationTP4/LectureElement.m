function [lTableElement] = LectureElement(pFichierGiD)
%LectureElement permet de construire la table des éléments qui constituent
%le système.
%on récupère dans cette table les éléments, les noeuds qui les constituent
%y compris les éléments de contours. 
%La désignation des matériau est aussi recupérée.
%Pour ce faire, une boucle sur l'ensemble du fichier de données permet
%d'extraire les éléments concernés par cette fonction : 
% ==> on retrouve la ligne des éléments
% ==> on recupère le nombre d'éléments qui constituent l'élément
% ==> on definit le type de l'élément
% la valeur -1 en cas d'erreur servira à l'arrêt du programme principal

disp(" ");
disp("***************** LECTURE DES ÉLÉMENTS EN COURS *****************");
IdFichier = fopen(pFichierGiD,"r");

%============= TROUVER L'INFORMATION SUR LES ELEMENTS ====================

while true % parcours de tout le fichier

    %-----lecture de la premiere ligne du fichier .dat
    LirLigne = fgetl(IdFichier);

    %------Si la ligne lue contient le mot clé ELEMENT
    if contains(LirLigne,'ELEMENT')
        InfoElement = textscan(LirLigne, '%s  %d');
        % on récupère le nombre d'élément
        lNbElement = InfoElement{2}; 
        % test sur le nombre d'éléments récupérés
        if isempty(lNbElement) || lNbElement == 0
            disp("Le bloc ELEMENT n'est pas defini dans..." + ...
                " le fichier de donnees");
            lTableElement = -1;
            return
        end
        break % on arrete la boucle une fois la bonne valeur trouvée

    %----si la ligne lue est non vide et ne contient pas le mode clé NOEUD
    elseif ~contains(LirLigne,'ELEMENT') || ~isempty(LirLigne)
        continue

    %----si la ligne lue est vide soit elle est vide ou erreur fichier
    else  
        disp('Fin du fichier atteinte ou le fichier est corrompu');
        disp("le bloc ELEMENT est introuvable");
        lTableElement = -1;
        return
    end 
end

%============== Initialisation de la table des éléemnts ==================
% NumMateriau|ConditionLimtNatu|TermSources|TypeElm|Noeuds
lTableElement = {};
lNbElemL2 = 0;
lNbElemT3 = 0;

%========== remplissage pre-traitement ==================================
    %----- boucle sur les éléments

for i = 1:lNbElement
    LirLigne = fgetl(IdFichier);

    % ------format de la ligne dans le fichier GiD
    % NumElement|NUmMateriaux|NbreNoeud|NumNoeud_N°1|...|NumNoeud_N°n
    InfoElement = textscan(LirLigne, '%d %d %d %d %d %d');

    % --- Organisation de la table des éléments
    % NumMateriau|ConditionLimtNatu|TermSources|TypeElm|VecteurNoeuds

    %-- recuperation du numéro de matériau
    lTableElement{i,1} = InfoElement{2};
    lTableElement{i,2} = 0; % limite naturelle 
    lTableElement{i,3} = 0; % terme source

    %--- Nombre de nombre noeuds qui constituent de l'élément
    lNbNoeudElem = InfoElement{3};

    %--Definition du TYPE de l'élément en fonction de son nombre de noeuds
    % L2 : linéique à 2 noeuds; T3 : Triangulaire à 3 noeuds
    if lNbNoeudElem == 2
        lTableElement{i,4} = 'L2';
        lNbElemL2 = lNbElemL2 + 1;
    elseif lNbNoeudElem == 3
        lTableElement{i,4} = 'T3';
        lNbElemT3 = lNbElemT3 + 1;
    else
        fprintf("Le type de l'élément N°%d n'est pas pris..." + ...
            " en compte par ce programme", i);
        lTableElement = -1;
        return
    end 
   
    %-- creation du vecteur de taille correspondant au nombre de ...
    % noeuds de l'élément i. Les composants du vecteur correspondent ...
    % aux numeros des noeuds de l'élément. Le remplissage se fait par la
    % boucle j
    lTableElement{i,5} = zeros(1,lNbNoeudElem);

    %boucle de remplissage
    for j = 1:lNbNoeudElem
        lTableElement{i,5}(j) = InfoElement{3+j};
    end
end
fclose(IdFichier);
fprintf("-> Il y a %d éléments de type L2  \n", lNbElemL2);
fprintf("-> Il y a %d éléments de type T3 \n", lNbElemT3);
fprintf("-> Il y a %d éléments traités au total \n", lNbElement);
end