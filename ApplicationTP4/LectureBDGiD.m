function [BaseDonnees] = LectureBDGiD()

% Cette fonction fait une lecture intégrale du fichier basé de données GiD
% elle retourne : 
% ==> le nom du fichier de la base de données GiD
% ==> Information sur la base de données GiD
%==> lecture de l'épaisseur
%==> lecture des noeuds
% ==> lecture des elements
% ==> Lecture des matériaux
% ==> Lecture des conditions aux limites naturelles
% ==> Lecture des sources/puits chaleur
% ==> Lecture des conditions aux limites essentielles
%        ------------- -----------
% on obtient finalement les tables : 
% ** NodeTable des noeuds, 
% ** Table des elements
% ** Table des matériaux 
% ** Table des termes sources
% ** Table des conditions limites naturelles
% ** Table des conditions limites essentielles
% ** l'épaisseur de la plaque
% ** le prefixe pour l'exportation du fichier resultat
% --------------------
% la valeur -1 en cas d'erreur servira à l'arrêt du programme principal

%======= RECUPERATION DU NOM DU FICHIER BASE DE DONNEES GiD ==========
gInfoFichierGiD = RecupererNomBDGiD();  

%--- Gestion de l'erreur provenant de « RecupererNomBDGiD »
if isequal(gInfoFichierGiD, -1)
    BaseDonnees = -1;
    return
else
    gNomFichierGiD = gInfoFichierGiD{1};
    gFichier = gInfoFichierGiD{3};
end

%---- Nom (Prefixe) à utiliser pour l'exportation des résultats
gNomFichierExport = gInfoFichierGiD{2};

%====================== OUVERTURE DU FICHIER =========================
gIdFichier = fopen(gFichier, "r");

%=============== IMPRESSION DES INFORMATIONS (ENTÊTES) ===============
LigneLue = fgetl(gIdFichier);

disp("==================================================================");
disp("|             LECTURE DE LA BASE DE DONNÉES GID                  |");
disp("==================================================================");
fprintf( "    -> Nom du fichier GiD : %s \n", gNomFichierGiD);
fprintf( '    -> %s \n', LigneLue);
LigneLue = fgetl(gIdFichier);
fprintf( '    -> %s \n', LigneLue);
LigneLue = fgetl(gIdFichier);
fprintf( '    -> %s \n', LigneLue);
LigneLue = fgetl(gIdFichier);
fprintf( '    -> %s \n', LigneLue);

%=============== IMPRESSION DE L'EPAISSEUR ============================
gEpaisseur = LectureEpais(gFichier);
if isequal(gEpaisseur, -1)
    BaseDonnees = -1;
    return
end

%=============== LECTURE DES NOEUDS ===================================
gTableNoeud = LectureNoeud(gFichier); 
if isequal(gTableNoeud, -1)
    BaseDonnees = -1;
    return
end

%=============== LECTURE DES ELEMENTS =================================
gTableElement = LectureElement(gFichier); 
if isequal(gTableElement, -1)
    BaseDonnees = -1;
    return
end

%=============== LECTURE DES MATERIAUX ================================
gTableMateriau = LectureMateriau(gFichier); 
if isequal(gTableMateriau, -1)
    BaseDonnees = -1;
    return
end

%============= LECTURE DES CONDITIONS AUX LIMITES NATURELLES ==========
% attention, ici on obtient la table des éléments modifiés. 
[gTableElement, gTableCondLimitNat] = LectureCLNat...
    (gFichier,gTableElement); 
if isequal(gTableCondLimitNat, -1)
    BaseDonnees = -1;
    return
end

%============= LECTURE DES SOURCES/PUITS ==============================
[gTableElement, gTableSource] = LectureSources...
    (gFichier, gTableElement); 
if isequal(gTableSource, -1)
    BaseDonnees = -1;
    return
end

%============= LECTURE DES CONDITIONS AUX LIMITES ESSENTIELLES ========
[gTableNoeud, gTableCondLimitEs] = LectureCLEss...
    (gFichier, gTableNoeud);
if isequal(gTableCondLimitEs, -1)
    BaseDonnees = -1;
    return
end

BaseDonnees = {gTableNoeud, gTableElement, gTableMateriau, gTableSource, ...
    gTableCondLimitEs, gTableCondLimitNat, gEpaisseur, gNomFichierExport};

fclose(gIdFichier);
end