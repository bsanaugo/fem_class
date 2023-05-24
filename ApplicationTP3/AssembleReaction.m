function ResultVectRea = AssembleReaction(pMatKel, pVectFelem, i,...
    pVectNumEq, pVectDDLI, pVectYcalcul, pVectRea)
%pElle permet le calcul des reactions aux noeuds imposés après ...
% le calcul Ysolution du système matriciel.
%Elle prend en argument la matrice elementaire, le vecteur force ...
% elementaire, l'element i(position), la numérotation des noeuds, ...
% le vecteur des dégré de liberté imposé. 
% On obtient un vecteur de même dimension que le vecteur des dégrés de
% liberté imposés.

    lVectNumEq = [pVectNumEq(i) pVectNumEq(i+1)];
    
    for j = 1:2
        lNumEqL = lVectNumEq(j);
        if lNumEqL < 0
            for k = 1:2
                lNumEqC = lVectNumEq(k);
                if lNumEqC > 0
                    pVectRea(-lNumEqL) = pVectRea(-lNumEqL) - pMatKel(j,k)...
                        *pVectYcalcul(lNumEqC);
                else
                pVectRea(-lNumEqL) = pVectRea(-lNumEqL) - pMatKel(j,k)...
                    *pVectDDLI(-lNumEqC);
                end
            end
        pVectRea(-lNumEqL) = pVectRea(-lNumEqL) - pVectFelem(j);
        end
    end
    ResultVectRea = pVectRea;
end 