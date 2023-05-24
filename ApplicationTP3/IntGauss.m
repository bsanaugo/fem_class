function [lResultIntGauss] = IntGauss(pNbPInt,pX1,pX2,pCoefK)
%Cette fonction evalue l'intégrale pour un element en fonction des ...
% coordonnées de ces noeuds pX1 et pX2. 
% le coefficient K est necessaire pour le calcul de l'intégral
%Elle retourne un vecteur (1x2), chaque element représentant la
%contribution de chaque noeud de l'élément qui sera multiplié plus tard
%par une constante pour connaitre la contribution de la force en ce noeud.
% lWj represente le poids de l'intégrale de Gauss

lRestInt1 =0;
lRestInt2 = 0;

    switch pNbPInt
        case 1  %schema à un point d'intégration
            lUj = 0.0;
            lWj = 2.0;
            lRestInt1 = lWj*(1-lUj)*(1 - pCoefK*((1-lUj)*...
                pX1/2+(1+lUj)*pX2/2))*exp(-pCoefK*...
                ((1-lUj)*pX1/2+(1+lUj)*pX2/2));
    
            lRestInt2 = lWj*(1+lUj)*(1- pCoefK*((1-lUj)*...
                pX1/2+(1+lUj)*pX2/2))*exp(-pCoefK*...
                ((1-lUj)*pX1/2+(1+lUj)*pX2/2));
    
        case 2 %schema à deux points d'intégration
            lUj = [-0.57735026918963, +0.57735026918963];
            lWj = [1.0 , 1.0];
            for m = 1:2
                lRestIntI1p = lWj(m)*(1-lUj(m))*(1- pCoefK*...
                    ((1-lUj(m))*(pX1/2)+(1+lUj(m))*pX2/2))*exp(-pCoefK*...
                    ((1-lUj(m))*pX1/2+(1+lUj(m))*pX2/2));
                lRestInt1 = lRestInt1 + lRestIntI1p;
    
                lRestIntI2p = lWj(m)*(1+lUj(m))*(1- pCoefK*((1-lUj(m))*...
                    pX1/2+(1+lUj(m))*pX2/2))*exp(-pCoefK*((1-lUj(m))*...
                    pX1/2+(1+lUj(m))*pX2/2));
                lRestInt2 = lRestInt2 + lRestIntI2p;
            end         
    
        case 3 %schema à trois points d'intégration
            lUj = [-0.77459666924148, 0.0, +0.77459666924148];
            lWj = [0.55555555555556, 0.88888888888889, 0.55555555555556];
    
            for m = 1:3
                lRestIntI1p = lWj(m)*(1-lUj(m))*(1- pCoefK*...
                    ((1-lUj(m))*(pX1/2)+(1+lUj(m))*pX2/2))*exp(-pCoefK*...
                    ((1-lUj(m))*pX1/2+(1+lUj(m))*pX2/2));
                lRestInt1 = lRestInt1 + lRestIntI1p;
    
                lRestIntI2p = lWj(m)*(1+lUj(m))*(1- pCoefK*((1-lUj(m))*...
                    pX1/2+(1+lUj(m))*pX2/2))*exp(-pCoefK*((1-lUj(m))*...
                    pX1/2+(1+lUj(m))*pX2/2));
                lRestInt2 = lRestInt2 + lRestIntI2p;
            end 
    end 
lResultIntGauss = [lRestInt1, lRestInt2];
end 