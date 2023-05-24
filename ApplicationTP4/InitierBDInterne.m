function [lBDInterne] = InitierBDInterne()

% Fonction d'affectation des informations à partir de la base de données 
% GiD on obtient au sortie de la fonction la base de données interne prête 
% à être exploitée. 
% la valeur -1 en cas d'erreur servira à l'arrêt du programme principal

%---récupération des informations de la base de données interne
BaseDataGiD = LectureBDGiD();

%------ test de validité de la base données GiD
if isequal(BaseDataGiD, -1)
    lBDInterne = -1;
    return
end

lTableNoeud = BaseDataGiD{1};
lTableElem = BaseDataGiD{2};
lTableMateriau = BaseDataGiD{3};
lTableSource = BaseDataGiD{4};
lTableCLEss = BaseDataGiD{5};
lTableCLNat = BaseDataGiD{6};
lEpaisseur = BaseDataGiD{7};
lNomFichierExport = BaseDataGiD{8};

% ------- Numérotation des noeuds
NoeudNum = NumeroterNoeud(lTableNoeud); 
if isequal(NoeudNum, -1)
    lBDInterne = -1;
    return
end

NbNumNoeud = NoeudNum{1};
lTableNoeud = NoeudNum{2};

lBDInterne = {lTableNoeud, lTableElem, lTableMateriau, lTableSource, ...
    lTableCLEss, lTableCLNat, lEpaisseur, NbNumNoeud, lNomFichierExport};

disp(" ");
disp("==================================================================");
disp("->  Base de données interne prête pour la résolution du problème  ");
disp("==================================================================");

disp(" ");
disp("********** RESOLUTION DU SYSTÈME MATRICIEL EN COURS --> *********");

end