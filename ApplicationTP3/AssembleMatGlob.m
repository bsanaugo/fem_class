function [ResultMatGlobRig, ResultVectMbre2Glob] = ...
    AssembleMatGlob(pMatKel, pVectFelm, i, pVectNumEq,...
    pVectDDLI, pMatGlobRig, pVectMbre2Glob)
%Cette fonction permet l'assemblage de la matrice gblobale de rigidité et
%du vecteur second membre necessaires au calcul du vecteur Ysolutoin du
%système matriciel AY+B=0
% Y representant la deflexion du cable.
% Elle prend en argument l'élément i, la numérotation ...
% des noeuds, le vecteur de liberté imposé, la matrice ...
% elementaire et la matrice de force elementaire

    lVectNumEq = [pVectNumEq(i) pVectNumEq(i+1)];

    for j = 1:2
        lNumEqL = lVectNumEq(j);
        if lNumEqL > 0
            for k = 1:2
                lNumEqC = lVectNumEq(k);
                if lNumEqC > 0
                    pMatGlobRig(lNumEqL, lNumEqC) = pMatGlobRig(...
                        lNumEqL, lNumEqC) + pMatKel(j,k);
               
                else
                pVectMbre2Glob(lNumEqL) = pVectMbre2Glob(lNumEqL)...
                    + pMatKel(j,k)*pVectDDLI(-lNumEqC);
                end
            end
         pVectMbre2Glob(lNumEqL) = pVectMbre2Glob(lNumEqL) + pVectFelm(j);
        end
    end
    
    ResultMatGlobRig = pMatGlobRig;
    ResultVectMbre2Glob = pVectMbre2Glob;
end
    
    
    
    

