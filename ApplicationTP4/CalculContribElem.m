function [ContribElem] = CalculContribElem(pBDInterne, pNumElem)

% Cette fonction permet le calcul des contributions élémentaires ...
% à partir de la base de données internes et le numéro de l'élément ...
% concerné. Un schéma d'intégration de Hammer à 3 points sera utilisé ...
% pour l'intégration numérique.
% La fonction retourne la matrice élémentaire et le vecteur force
% elementaire. 

%--- recupération du nombre de noeud de l'élément (pNumElem) : 
% ATTENTION : Convertir le contenu de la cellulaire en matrice pour obtenir
% le nombre de noeud de l'élément.

%--- Le vecteur des numeros de noeuds formé par l'élément
lVectNumNoeudElem = cell2mat(pBDInterne{2}(pNumElem,5)); 

%--- Nombre de noeuds contenu dans le vecteur
lNbNoeudElem = length(lVectNumNoeudElem);

%--- Création de la taille de MatKelem et VectFelem
MatKelem = zeros(lNbNoeudElem);
VectFelem = zeros(1,lNbNoeudElem);

%---- Trouver le TYPE de l'élément pNumElem : en fonction du type, les
%valeurs de MatKelm sont connus (grâce aux developpements mathématiques)
lTypeElem = pBDInterne{2}(pNumElem, 4);

%-- récuperation des coordonnées (x,y) des noeuds : on crée donc les
%vecteurs x et y. Selon le type on a x=(x1,x2) et y=(y1,y2) ou encore
% x=(x1,x2,x3) et y=(y1,y2,y3) 
x = zeros(1, lNbNoeudElem);
y = zeros(1, lNbNoeudElem);
for i = 1:lNbNoeudElem
    x(i) = pBDInterne{1}(lVectNumNoeudElem(i), 1);
    y(i) = pBDInterne{1}(lVectNumNoeudElem(i), 2);
end

%-- Récupération de l'épaisseur
Epais = pBDInterne{7};

%-- Calcul selon le type de l'élément (pNumElem)

    %-- cas d'un élément de contour (L2)
if isequal(lTypeElem, "L2")
    
    %-- Recupération du numéro de la condition aux limites naturelles
    lNumLimNat = cell2mat(pBDInterne{2}(pNumElem, 2));

    %-- test de l'existence de la condition sur l'élément de contour
        %-- oui présence de condition CLN sur l'élément de contour
    if ~isequal(lNumLimNat, 0)
        %-- Récuperation des propriétés de la condition limite naturelle
        hc = cell2mat( pBDInterne{6}(lNumLimNat, 2));
        TempAir = cell2mat( pBDInterne{6}(lNumLimNat, 3));

        %--- calcul de la longueur élémentaire
        LongElem = sqrt( (x(2)-x(1))^2 + (y(2)-y(1))^2 );

        %-- caclul des contributions élémentaires :
        % une grande partie excécutée grâce aux developpements mathématiques
        MatKelem =  Epais * ((hc*LongElem)/6) * [2 1; 1 2];
        VectFelem = - Epais * ((hc*TempAir*LongElem)/2) * ones(2,1);
    end

    %-- cas d'un élément interne (T3)
else
    %-- recupération du numéro de matériau et de la conductivité K
    lNumMat = cell2mat( pBDInterne{2}(pNumElem, 1) );
    Kconductiv = cell2mat( pBDInterne{3}(lNumMat, 1) );
    
    %--- Calcul du jacobien J
    dxdu = x(2) - x(1);
    dxdv = x(3) - x(1);
    dydu = y(2) - y(1);
    dydv = y(3) - y(1);
    J = [dxdu  dxdv ; dydu  dydv];

    %-- Déterminant du jacobien
    DetJ = det(J);

    %--- Inverse du déterminant
    InvJ = inv(J);

    % Construction de la matrice B. Element triangulaire donc nombre
    % de noeuds = 3 (lNbNoeudElem = 3). Connaissant le jacobien, il est
    % facile de déterminer les composants de B par l'inverse du jacobien
    B = zeros(2,3);
    dudx = InvJ(1,1);
    dvdx = InvJ(2,1);
    dudy = InvJ(1,2);
    dvdy = InvJ(2,2);
    B = [(-dudx-dvdx) dudx dvdx; (-dudy-dvdy) dudy dvdy];

    % Matrice de conductivité
    MatKonductiv = [Kconductiv 0; 0 Kconductiv];

    % Calcul de la matrice élémentaire
    MatKelem = Epais * DetJ/2 * B' * MatKonductiv * B ;

    %--- Prise en compte du terme source et calcul :  
        %-- recupération du numéro du terme source et du terme source
        %-- Q est fonction de X et Y. 
    lNumSource = cell2mat( pBDInterne{2}(pNumElem, 3) );
    if ~isequal(lNumSource, 0)
        syms X Y
        lQ(X,Y) = cell2sym( pBDInterne{4}(lNumSource, 2) );

    %--- Coordonnées et poids d'intégration selon le schéma de Hammer à
    %trois points : Nous avons programmé pour differents points
    %d'intégration. Cependant le TP4 requiert 3 points que nous appelerons
    %ici pour la suite du programme. Dans un futur il sera plus facile de
    %modifier le programme. 
    lSetUpIntgHammer = IntHammer(3);

    % Nombre de points d'intégration
    NbPI = lSetUpIntgHammer{1}; 

    % Coordonnées (ksi, eta) et poids d'intégration (Wk)
    lVectCoorKsi = lSetUpIntgHammer{2};
    lVectCoorEta = lSetUpIntgHammer{3};
    lVectPoids = lSetUpIntgHammer{4};

    % boucle sur les termes dependant de u et v : 
    % ici c'est le terme source. 
    ValQIntgHammer = zeros(3,1);
    for j = 1:NbPI
        Uk = lVectCoorKsi(j);
        Vk = lVectCoorEta(j);
        Wk = lVectPoids(j);
        Nk = [1-Uk-Vk Uk Vk];

        Xk = Nk * x';
        Yk = Nk * y';
        lQk = lQ(Xk,Yk);

        ValQIntgHammer = ValQIntgHammer + Nk' * eval(lQk) * Wk;
    end
    VectFelem = - Epais * DetJ * ValQIntgHammer;

    else
         VectFelem = zeros(3,1); % car lQ = 0 (pas de source/puit)
    end
end

ContribElem = {pNumElem, MatKelem, VectFelem};
end