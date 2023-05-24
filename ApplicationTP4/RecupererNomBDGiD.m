function [lInfoFichierBD] = RecupererNomBDGiD()
%Cette fonction permet de chercher dans le dossier courant en fonction de
%l'extension (dat) le fichier correspondant à la base de données GiD . 
% Une fois trouvé, le nom du fichier est extrait puis les données sont ...
%extraite pour la résolution du problème. 
% on recupère directement le nom du fichier avec son extension avec la
% fonction uigetfile de MATLAB. En plus, nous avons imposé une restriction: 
% SEULS LES FICHIERS .dat DOIVENT ETRE AFFICHÉS
% De plus le nom du fichier sans extension et son extension sont récuperés.
% L'utiisateur aura juste à choisir le bon fichier.
% -----------------------
% la valeur -1 en cas d'erreur servira à l'arrêt du programme principal


%-- recupération du nom (avec extension) et du chemin d'accès du fichier
[lNomFichierBDGiD, lCheminDossier]  = uigetfile('.dat',['Choisir ' ...
    'le fichier .dat']);

% ---- test selon le choix de l'utilisateur 
if isequal(lNomFichierBDGiD,0) || isequal(lCheminDossier,0)
    disp("    -> Opération annulée par l'utilisateur    ");
    disp("            == FIN DU PROGRAMME ==           ");
    lInfoFichierBD = - 1;
    return

elseif ~endsWith(lNomFichierBDGiD,".dat")
    disp("    -> Mauvais fichier selectionné               ");
    disp("            == FIN DU PROGRAMME ==           ");
    lInfoFichierBD = - 1;
    return
else
    disp("     -> le fichier choisi est conforme       ");
end

% -- recupération du nom du fichier (sans extension)
[~, lNomFichierSansExt, ~] = fileparts([lCheminDossier, lNomFichierBDGiD]);

%-- on crée le nom du fichier pour enregister plus tard les résultats
% cela comprend le chemin d'accès et le nom du fichier sans l'extension
NomFichierExport = [lCheminDossier,lNomFichierSansExt];

%-- Recupération du chemin complet du fichier
CheminFichierFull = [lCheminDossier, lNomFichierBDGiD];

%--- recuperation du resultats
lInfoFichierBD = {lNomFichierBDGiD, NomFichierExport, CheminFichierFull};

end
