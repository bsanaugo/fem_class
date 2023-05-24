function [GlobSystem] = InitierGlobSystem(pBDInterne)
%Cette fonction permet de créer et d'initialiser le système globale pour la
%résolution du problème. 
% Au sortie, il n'y a que des valeurs nulles dans le système et prêt à être
% rempli. 

%-- recuperation du nombre de degré de liberté libre
lNbDegLibr = pBDInterne{8}(2);

%-- Allocation et mise à zeros
MatKGlobSystem = zeros(lNbDegLibr);
VectFelemGlob = zeros(lNbDegLibr,1);

GlobSystem = {MatKGlobSystem, VectFelemGlob};
end