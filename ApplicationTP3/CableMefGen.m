%=====================================================================%
%                       FONCTIONNNEMENT  
%                  -------------------------
% Ce programme permet la résolution du problème cable tendu par la methode...
% des éléments finis. Les solutions sont stockés dans un tableau. 
% Le programme peut traiter plusieurs cas en variant soit le nombre ...
% d'éléments finis ou en variant le schéma d'intégration (intégration ...
% exacte, intégration par le schéma de Gauss à 1,2 ou 3 points.
%                  ----------------------
% Le programme demande les valeurs du nombre d'éléments pour la 
% discrétisation et les autres caractéristiques du problèmes (longueur ...
% du câble, la tension, la charge repartie et la valeur du coefficient k.
% De même l'utilisateur choisi le schéma d'intégration.
%                     -----------------
% En fonctionnement, le programme calcule et trace le graphe selon le 
% nombre d'éléments et le schéma d'intégrationpuis une question est posé 
% à l'utilisateur s'il veut continuer avec un autre cas. S'il accepte de 
% continuer, les résultats du cas précédents sont conservés de même que sa
% courbe puis le nouveau cas est traité et sa courbe est tracée sur le 
% même graphique que la courbe précédente. 
% Ceci permet de faire une comparaison rapide par l'utilisateur.
% A la fin du programme, un graphique regroupant toutes les courbes des 
% cas traités est affiché.  
%                        -------------------
% Les résultats de tous les cas traités peuvent être récupérer dans 
% variables XMEFGlob et YMEFGlob. 
% Pour son fonctionnement, ce programme s'appuie sur d'autres fonctions
% dont les descriptions sont fournies dans leurs scripts.

%====================================================================% 
%           NETTOYAGE DE LA CONSOLE ET DES DONNÉES EN MEMOIRE 
%====================================================================%
clear 
close all
clc

disp('%-------------------------------------------------------------%'); 
disp('      RESOLUTION DU PROBLEME DU CABLE TENDU PAR LA MEF         ');
disp('%-------------------------------------------------------------%');

gReponseUser = 'oui';
gcLimitRep = 5;
gRepValid = {'oui','non','NON','OUI','Non','O','N','n','o'};
gComptCas = 1;  %le compteur de cas initialisé à 1

%--------- debut du programme 
while strcmpi(gReponseUser,'Oui') || strcmpi(gReponseUser,'O')

%====================================================================% 
%               LECTURE ET CONTROLES DES ENTRÉES 
%====================================================================%
    % Saisi des caractéristiques du problème
    [gNbElem, gLongCabl, gTensCabl, gChargeW0, gCoefK] = LectureData();
    
    if gNbElem == -1
        error('VALEURS SAISIES INCORRECTES, ARRÊT DU PROGRAMME')
    end 

    % Choix du mode d'intégration
    [gChoixUser, gNameSchema] = ChoixIntegral();
    if gChoixUser == -1
        error('CHOIX DU MODE D''INTEGRATION INCORRECT, ARRÊT DU PROGRAMME')
    end

%====================================================================% 
%                   INITIALISATION DES VARIABLES 
%====================================================================%
    gLongElem = gLongCabl / gNbElem; % longueur elementaire
    gNbDDLT = gNbElem + 1; % nombre total de degrés de liberté 
    
    %coordonnées (abscisse du degré de liberté)
    gPosCordX = linspace(0,gLongCabl,gNbDDLT); 
    
    %matrice élementaire
    gMatKel = (-gTensCabl/gLongElem)*[1 -1;-1 1];

%====================================================================%
%           APPEL DES FONCTIONS ET CALCUL SUR CHAQUE ELEMENT
%===================================================================%
    %------- Numérotation des noeuds 
    gVectNumNod = NumeroNoeud(gNbDDLT);

    %------- Vecteur Degrés De Liberté Imposés
    gVectDDLI = [0 0];

    %------- Assemblage de la matrice globale et du second membre 
    gMatGlobRig = zeros(gNbDDLT-2);         %initialisation
    gVectMbre2Glob = zeros(gNbDDLT-2, 1);   %initialisation

    for p = 1:gNbElem
        %---- calcul de l'intégral en tenant compte du schema
        gVectResultInt = CalculIntegral(gChoixUser, gPosCordX, p, gCoefK);
        
        %-------Calcul du vecteur force elementaire
        gVectFelem = CalculFelm(gVectResultInt,gChargeW0,gLongElem);
        
        %Assemblage ...
        [gMatGlobRig, gVectMbre2Glob] = AssembleMatGlob(gMatKel, ...
            gVectFelem, p, gVectNumNod ,gVectDDLI,...
            gMatGlobRig,gVectMbre2Glob);
    end

    %------- Resolution du système AY+B = 0
    gVectYcalcul = gMatGlobRig \ (-gVectMbre2Glob); %VectY calculé

    %----- Calcul des reactions
    gVectRea = zeros(length(gVectDDLI), 1); %initialisation

    for q = 1:gNbElem
        gVectRea = AssembleReaction(gMatKel, gVectFelem, ...
            q, gVectNumNod,gVectDDLI,gVectYcalcul,gVectRea);
    end

    %------ vecteur Y solution finale
    gYsolFinal = [0; gVectYcalcul; 0];

%====================================================================%
%              SAUVEGARDE DES RÉSULTATS ET TRAITEMENT
%====================================================================%
    %---- Récupération des coordonnées du cas traités et de la réaction
    XMEFGlob{gComptCas} = gPosCordX; 
    YMEFGlob{gComptCas} = gYsolFinal;
    ReactionGlob{gComptCas} = gVectRea;

    % ------- Tracé de la courbe du cas en cours
    TraceCourbe(XMEFGlob{gComptCas}, YMEFGlob{gComptCas}, ...
        gNameSchema,gNbElem);
	
    % - préparation de la légende pour le graphique ....
    % finale de l'ensemble des cas à la fin du programme
    legendNames{gComptCas} = sprintf('%s MEF N=%d ', gNameSchema, ...
        gNbElem);  
    hold on    

%====================================================================%
%                  SORTIR OU CONTINUER LE PROGRAMME ?
%====================================================================%
    disp(['L''execution d''un autre cas n''effacera pas les données' ...
        ' du cas précédent : LA SOLUTION SERA SAUVÉE']);
    gReponseUser = input ("voulez vous traiter un autre cas ? ..." + ...
        "Oui/Non;" + "votre reponse = ","s");
    gComptReponse = 0; 

        while ~ismember(gReponseUser, gRepValid) && ...
                gComptReponse < gcLimitRep
            disp('Reponse non valide, Saisir "oui(O)" ou "non (N)".');
            gReponseUser = input ("voulez-vous traiter un autre cas ?" + ...
                " Oui(O)/Non(N);  votre reponse = ","s");
            gComptReponse = gComptReponse + 1;
        end

        if gComptReponse == gcLimitRep
            disp('limite de tentatives atteinte; FIN DU PROGRAMME ...');
            return;
        end
        gComptCas = gComptCas + 1;
end 

%====================================================================%
%                       TRACE DES COURBES FINALES
%====================================================================%
close % fermeture des courbes precedentes
CourbeFinal(gComptCas,XMEFGlob,YMEFGlob,legendNames);

disp('*********** FIN DU PROGRAMME ***********');