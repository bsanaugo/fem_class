function [lResVectFelem] = CalculFelm(pVectResultInt,...
    pChargeW0, pLongElem)
    %Cette fonction effectue le calcul du vecteur force elementaire ...
    %en prenant en argumant la chargeW0 (charge linéique), le vecteur du...
    %resultat de l'intégration et la longueur de l'élément. 
    %le vecteur du resultat de l'intégration est obtenu dans le calcul ...
    %de l'intégral en fonction du schéma d'intégration.

    lResVectFelem = ((pChargeW0*pLongElem)/4)*pVectResultInt;
end