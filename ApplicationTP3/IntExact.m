function [lResultIntExact] = IntExact(pX1,pX2,pCoefK)
%Cette fonction evalue l'intégration exacte entre - et 1 pour un élément en
%fonction des ses coordonnées pX1 et pX2. 
%le coefficient K est necessaire pour le calcul de l'intégral
%Elle retourne un vecteur (1x2), chaque element représentant la
%contribution de chaque noeud de l'élément qui sera multiplié plus tard
%par une constante pour connaitre la contribution de la force en ce noeud.
%on a choisi la symbolique u pour rester fidèle ...
% au developpement mathematique

    syms u
    
    lFoncI1 = (1-u)*( 1-pCoefK*( (1-u)*pX1/2 + (1+u)*pX2/2 ) )*...
                exp( -pCoefK*( (1-u)*pX1/2 + (1+u)*pX2/2 ) );
    
    lFonctI2 = (1+u)*( 1-pCoefK*( (1-u)*pX1/2 + (1+u)*pX2/2 ) )*...
                exp( -pCoefK*( (1-u)*pX1/2 + (1+u)*pX2/2 ) );
    
    lRestInt1 = int(lFoncI1,u,-1,1);
    lRestInt2 = int(lFonctI2,u,-1,1);
    
    lResultIntExact = [lRestInt1, lRestInt2];

end

