function [ChaleurPerdu] = PerteChaleur(pBDInterne, pIdentifiantCLN)

% Cette fonction evalue la perte de chaleur en fonction des surfaces
% d'intérêt choisi à cet effet. Elle prend en argument la base de données
% interne après résolution du système. 
% De façon resumé, elle recupère l'identifiant de la surface d'intérêt dont
% on veut calculer la perte de chaleur. Elle compare cet identifiant donné
% par l'utilisateur avec les éléments de la table de conditions limites
% puis retrouve le numéro de la condition correspoondante. 
% Par la suite, ce numéro permet de recupérer tous les éléments qui ont ce
% numéro de condition limite naturelle et de calculer la perte de chaleur.
% -----------------------------------------------------------------------

%--> récuperation de la table des noeuds
lTableNoeud = pBDInterne{1};

%--> récupération de la table des éléments
lTableElem = pBDInterne{2};

%--> récupération de la table des conditions aux limites naturelles
lTableLimNat = pBDInterne{6};   %cell

%--> Nombre d'éléments
lNbElem = size(lTableElem, 1);

%--> Nombre de conditions limites naturelles
lNbLimNat = size(lTableLimNat, 1);

%--> extraction de la condition limite naturelle qui correspond à la
% surface d'intérêt dont on veut calculer les pertes 
for NumLimNat = 1:lNbLimNat
    IdLimitNat = cell2mat( lTableLimNat{NumLimNat, 1} );
    if isequal(IdLimitNat, pIdentifiantCLN)
        break;
    elseif isequal(NumLimNat, lNbLimNat) && ...
            ~isequal(IdLimitNat, pIdentifiantCLN)
        fprintf("« %s » ne fait pas partie des condtions " + ...
            "limites naturelles \n", pIdentifiantCLN);
        return
    end
end

%--> récuperation de l'épaisseur
Epais = pBDInterne{7};

%--> Initialisation de la perte de chaleur
ChaleurPerdu = 0;

%--> boucle sur les éléments
for i = 1:lNbElem

    %-- type de l'élément i
    lTypeElemi = cell2mat( pBDInterne{2}(i, 4) );
    %--- Numero de la condition limite naturelle de l'élément i
    lNumLimNatElemi = cell2mat( pBDInterne{2}(i, 2) );
    
    %-- contribution uniquement sur les éléments de contour correspondant à
    % l'identifiant du contour (pIdentifiantCLN).
    if isequal(lTypeElemi, "L2") && isequal(lNumLimNatElemi, NumLimNat)

        %-- nombre de noeud de l'élément i est 2 (car de type L2)
        lNbNoeudElem = 2;

        %-- initialisation des varialbes
        X = zeros(1, lNbNoeudElem);
        Y = zeros(1, lNbNoeudElem);
        qX = zeros(1, lNbNoeudElem);
        qY = zeros(1, lNbNoeudElem);

        %-- Coordonnées et flux des noeuds
            %--- Le vecteur des numeros de noeuds formé par l'élément i
            % on fait une conversion en matrice pour que la boucle puisse
            % indexer chaque numéro.
        lVectNumNoeudElem = lTableElem{i, 5};

        for j = 1:lNbNoeudElem
            X(j) = lTableNoeud(lVectNumNoeudElem(j), 1);
            Y(j) = lTableNoeud(lVectNumNoeudElem(j), 2);
            qX(j) = lTableNoeud(lVectNumNoeudElem(j), 8);
            qY(j) = lTableNoeud(lVectNumNoeudElem(j), 9);
        end

        % calcul du déterminant du jacobien :
        % (correspond à la longueur élémentaire divisée par 2)
        dxdu = ( X(2) - X(1) ) / 2;
        dydu = ( Y(2) - Y(1) ) / 2;
        detJ = sqrt(dxdu*dxdu + dydu*dydu);

        % calcul de qX(u) et qY(u) : 
        % x(u) = x2 - x1 et y(u) = y2 - y1 sont des constantes 
        syms u 
        N1 = (1-u)/2;
        N2 = (1+u)/2;
        N = [N1 N2];
        qx = N * qX';
        qy = N * qY';

        % valeur du flux dans la direction normale en fonction de u
        qN(u) = (qx*dydu - qy*dxdu) / detJ;

        % Coordonnées pour l'intégration par le schéma de Gauss (3 points)
        lVectCoorU = [-0.77459666924148 0 0.77459666924148];
        lVectCoordW = [0.55555555555556 0.88888888888889 0.55555555555556];
        
        % calcul de la contribution
        for k = 1:3
            uk = lVectCoorU(k);
            wk = lVectCoordW(k);
            ChaleurPerdu = ChaleurPerdu + eval(qN(uk))*Epais*detJ*wk;
        end 
    end
end

fprintf(" -> la perte de chaleur par le (la) %s est : %f Watt \n",...
    pIdentifiantCLN, abs(ChaleurPerdu) );

end