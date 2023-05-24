function [lResultVectNumNode] = NumeroNoeud(pNbDDLT)
%Retourne la numérotation des noeuds

    lNum = zeros(1,pNbDDLT);
    lNum(1) = -1;
    lNum(pNbDDLT) = -2;

    for u = 2:pNbDDLT-1
        lNum(u) = u - 1;
    end
lResultVectNumNode = lNum;
end