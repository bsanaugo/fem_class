%       |    SOLVEUR THERMIQUE EN 2D EN REGIME STATIONNAIRE    |
%        ------------------------------------------------------
% description détaillée :
% Ce programme permet la résolution d'un problème de transfert thermique...
% en 2D en regime stationnaire. 
% Le programme prend en argument une base données provenant du logiciel GiD
% Un schéma d'intégration de Hammer à 3 points est utilisé pour
% l'intégration de la partie therme source. 
%                  |----------------------|
% le programme peut resoudre un problème sans terme sources et peut
% resoudre un problème sans conditions naturelles.

%                  |----------------------|
% Le programme demande à l'utilisateur de chosir le fichier de base de
% données GiD grâce à une fenêtre contextuelle qui lui donne la main. Ce
% fichier doit impérativement avoir l'extension « .dat » autrement dit
% le programme ne marchera pas. 

%                    |-----------------|
% En fonctionnement : après le chargement du fichier de base de ...
% données GiD, un traitement préliminaire permet la constitution de la ...
% base de données nécessaire à la résolution du problème. Cette base de
% données est nommée « base de données interne (BDInterne) ». 
% Elle comprend : les tables des noeuds, des éléments, des matériaux, ...
% des sources et puits de chaleur, des conditions limites essentielles,
% des conditions limites naturelles, l'épaisseur, la table des dégrées de
% libertés (total, libres et imposés) et finalement le chemin d'accès ...
% pour la sauvegarde des résultats. 

% Le calcul de la perte de chaleur est effectué par défaut via les surfaces
% soumises aux conditions limites naturelles. Par la suite, l'utilisateur
% pourra exploité ces résultats (pertes de chaleur) pour déterminer des
% valeurs selon les études envisagée. 

%                     |-------------------|
% Les résultats sont exportés dans le même dossier que le fichier de base...
% de données GiD et porte le même nom avec une extension « post.res ».
% Les résultats peuvent être également récuperer dans la variable
% « gBDInterneFinal ».
% Pour son fonctionnement, ce programme s'appuie sur d'autres fonctions
% dont les descriptions sont fournies dans leurs scripts.

%                     |-------------------|
% En cas d'erreur, un message affiche la cause de l'erreur et le programme
% est arrêté. 

%========================================================================% 
%           NETTOYAGE DE LA CONSOLE ET DES DONNÉES EN MEMOIRE 
%========================================================================%
clear 
close all
clc

disp("=================================================================");
disp("|        SOLVEUR THERMIQUE 2D EN REGIME STATIONNAIRE             |");
disp("=================================================================")
disp("");
disp(" Selection du fichier de base de données GiD (.dat) .... en cours");

%========================================================================% 
% LECTURE BASE DONNÉE GID ET INITIALISATION DE LA BASE DE DONNÉES INTERNE 
%========================================================================%

%--> base de données interne
gBDInterne = InitierBDInterne();
    %--> en cas d'erreur : base de données GiD ou autres
if isequal(gBDInterne, -1)
    error("    -> ERREUR : Base de données erronée ou inexistante      ");
end

%--> création système matriciel global
gGlobSystem = InitierGlobSystem(gBDInterne);

%========================================================================%
%  BOUCLES SUR LES ÉLÉMENTS : CONTRIBUTIONS ÉLÉMENTAIRES, ASSEMBLAGE,    
%  RESOLUTION DU SYSTÈME MATRICIEL, CALCUL GRADIENT ET FLUX
%========================================================================%

%--> Remplissage du système global
gGlobSystem = RemplirGlobSystem(gBDInterne,gGlobSystem);

%--> Résolution du système matriciel global et mise de la base de données
% interne 
gBDInterne = ResoudreGlobSystem(gBDInterne,gGlobSystem);

%--> Calcul du gradient, du flux et mise à jour de la base de données : on
% obtient la base de données finale à jour
gBDInterne = GlobSystemGradFlux(gBDInterne);

disp("            ->->->       Système résolu       <-<-<              ");
disp(" ");

%========================================================================%
%                        EXPORTATION DES RESULTATS
%========================================================================%

disp("*********** EXPORTATION DES RÉSULTATS EN COURS ******************");

%--> Récupération du préfixe pour la création du fichier résultat
gPrefixFichier = gBDInterne{9};

%--> Création du fichier résultats
gFichierResult = GiDOpen(gPrefixFichier);

%--> Vecteur numérotation des noeuds : nombre de ligne de la table noeuds
gVectNumNoeud = 1:size(gBDInterne{1}, 1);

%--> vecteur représentant l'axe Z : 
% On crée ce vecteur car le programme d'exportation requiert un axe Z pour
% l'exportation des gradients et des flux. 
% Vu que nous travaillons en 2D, nous procedons de cette manière afin de ne
% pas modifier le programme fourni par le professeur.
axeZ = zeros(size(gBDInterne{1}, 1), 1);

%--- Exportation des résultats
    %----> Température
GiDPrintScalar( gFichierResult, "Température", "Thermique 2D " + ...
    "stationnaire",1.0, gVectNumNoeud, gBDInterne{1}(:,5) );

   %----> Exportation des Gradients
   %--> on crée la matrice des resultats des gradients GradX|GradY|GradZ
gMatResultGrad = [gBDInterne{1}(:,[6 7]), axeZ];    
GiDPrintVector(gFichierResult, "Gradient", "Thermique 2D stationnaire",...
    1.0, gVectNumNoeud, gMatResultGrad);

 %--- Exportation des Flux
 %--> on crée la matrice des resultats des gradients qX|qY|qZ
gMatResulFlux = [gBDInterne{1}(:,[8 9]), axeZ];
GiDPrintVector( gFichierResult, "Flux", "Thermique 2D stationnaire",...
    1.0, gVectNumNoeud,  gMatResulFlux);

disp("-> Resulats exportés ");
%--> Fermeture du fichier
GiDClose(gFichierResult);

%---> Calcul de chaleur perdue par les surfaces aux flux imposés
gTableCLN = gBDInterne{6};

% s'il y a des conditions limites naturelles
if ~isequal(gTableCLN, 0)
    disp(" ");
    disp("*********** CALCUL DE PERTE DE CHALEUR **************");
    for p = 1:size(gTableCLN,1)
        gIdSurfaceInteret = cell2mat( gTableCLN{p, 1} );
        PerteChaleur(gBDInterne, gIdSurfaceInteret);
    end
end

fprintf(" \n           === FIN DU PROGRAMME ===                   \n   ");
