function [BDInterneUpdated] = ResoudreGlobSystem(pBDInterne,...
    pGlobSystemFilled)

%Cette fonction resoud le système d'équation linéaire et les résultats sont
%extraits et rangés dans le tableau des noeuds. 
% elle necessite comme argument la base de données interne et le système
% global préalablement rempli. 
% Cette fonction retourne la tableau des noeuds avec la colonne des
% températures rempli pour les calculs (flux et gradient)
% le système à resoudre est sous la forme 
% [K].{T} = -{F} avec T à déterminer.
% En rapport avec notre TP4, le système s'écrit : 
% [MatKGlobSystem].{T} = -{VectGlobFelem}
% A la fin de l'opération, on récupère 

%----- recupereration de MatKGlobSystem, VectFelemGlob
lMatKGlobSystem = pGlobSystemFilled{1};
lVectFelemGlob = pGlobSystemFilled{2};

%------- Résolution du système 
lVectT = lMatKGlobSystem \ lVectFelemGlob;

%-- Récuperation des solutions dans la table des noeuds
    %----- Nombre de dégrés de liberté total
lNbDegTot = pBDInterne{8}(1);

    %----- table des noeuds
lTableNoeud = pBDInterne{1};

    %-- table des conditions aux limites essentielles
lTableLimitEss = pBDInterne{5};

    %-- récuperation solution
for i = 1:lNbDegTot
    %-- Récupération du numéro de l'équation
    NumEq = lTableNoeud(i,4);
    %--- est ce libre ?
    if NumEq > 0 
        lTableNoeud(i,5) = lVectT(NumEq);
    else 
        lTableNoeud(i,5) = lTableLimitEss{lTableNoeud(i,3),2};
    end
end

%-- Récuperation de la nouvelle table et de la nouvelle base de données
pBDInterne{1} = lTableNoeud;
BDInterneUpdated = pBDInterne;
end