function [MatGradFluxElem] = CalculGradFluxElem(pBDInterne, pNumElem)
% Cette fonction calcul les gradients et les flux suivant les axes x et y
% pour un élément. 
% Elle prend en argument la base de données interne et le numéro de
% l'élément considéré.

%---> nombre de noeuds dans l'élément de numéro pNumElem
    %--- vecteur de numéro de noeud de l'élément
    lVectNumNoeudElem = cell2mat(pBDInterne{2}(pNumElem,5));
    %--- nombre de noeuds de l'élément
    lNbNoeudElem = length ( lVectNumNoeudElem );

%-- récuperation des coordonnées (x,y) des noeuds et des températures :
% on crée donc les vecteurs x, y et T. Selon le type on a x=(x1,x2), ...
% y=(y1,y2) et T=(T1,T2) ou encore x=(x1,x2,x3), y=(y1,y2,y3) et ...
% T=(T1,T2,T3) 
    x = zeros(1,lNbNoeudElem);
    y = zeros(1,lNbNoeudElem);
    T = zeros(1,lNbNoeudElem);
    
    for i = 1:lNbNoeudElem
        x(i) = pBDInterne{1}(lVectNumNoeudElem(i),1);
        y(i) = pBDInterne{1}(lVectNumNoeudElem(i),2);
        T(i) = pBDInterne{1}(lVectNumNoeudElem(i),5);
    end

%--> calcul du jacobien
    dxdu = x(2) - x(1);
    dxdv = x(3) - x(1);
    dydu = y(2) - y(1);
    dydv = y(3) - y(1);
    J = [dxdu  dxdv ; dydu  dydv];

%--> inversion du jacobien
    InvJ = inv(J);

% --> Initialisation de la Matrice des résultats 
% Forme de la matrice : [gradx, gradY, qx, qy]
    MatGradFluxElem = zeros(lNbNoeudElem,4);

%---> récuperation  de conductivité de l'élément
    lNumMateriau = cell2mat(pBDInterne{2}(pNumElem,1)); %numero materiau
    Kconductiv = cell2mat(pBDInterne{3}(lNumMateriau,1)); 

%---> Calcul du flux et remplissage de la matrice des résultats
   %--- Calcul du gradient
    dTdx = (T(2) - T(1)) * InvJ(1,1) + (T(3) - T(1)) * InvJ(2,1);
    dTdy = (T(2) - T(1)) * InvJ(1,2) + (T(3) - T(1)) * InvJ(2,2);

    %--- Calcul du flux 
    qx = - Kconductiv * dTdx; 
    qy = - Kconductiv * dTdy;

%---> Sauvegarde dans la matrice des résultats
    for i = 1:lNbNoeudElem
        MatGradFluxElem(i,1) = dTdx;
        MatGradFluxElem(i,2) = dTdy;
        MatGradFluxElem(i,3) = qx;
        MatGradFluxElem(i,4) = qy;
    end
end