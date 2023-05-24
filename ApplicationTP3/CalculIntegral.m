function [lResultVectInt] = CalculIntegral(pChoixUser, pPosiCabl, ...
    i, pCoefK)
%Elle evalue l'intégral I1 et I2 necessaire au calcul du vecteur force
%élémentaire. L'intégral est évalué pour un élément, et ce, en fonction...
% du choix du schema d'intégration.
%Pour le fonctionnement, il faut le choix du schema d'intégration qui varie
%entre 0 et 3, le vecteur des positions sur le cable et le coefficient K.
% 0 pour une intégration exacte, 1 à 3 pour une intégration de Gauss à ...
% 1, 2 et 3 points d'intégration.
%    ---------------------------------------------------
%cette fonction fait appel aux fonctions de calcul de l'integral exacte et
%de l'intégration par le schema de Gauss

    switch pChoixUser
        
        case 0  %intégration exacte
                lResultInt = IntExact(pPosiCabl(i), ...
                    pPosiCabl(i+1), pCoefK);
            
        case 1 %integration à un point d'intégration
                lResultInt = IntGauss(1, pPosiCabl(i), ...
                    pPosiCabl(i+1), pCoefK);
    
        case 2 %integration à deux points d'intégration
                lResultInt = IntGauss(2, pPosiCabl(i), ...
                    pPosiCabl(i+1), pCoefK);
    
         case 3 %integration à trois points d'intégration
                lResultInt = IntGauss(3, pPosiCabl(i), ...
                    pPosiCabl(i+1), pCoefK);
    end 

lResultVectInt = lResultInt;
end