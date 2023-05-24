function [lFile] = GiDOpen(pFileNamePrefix)
%GiDOpen Ouverture de l'interface de post-traitement GiD
%   Description détaillée:

%Création du nom de fichier
lFileName = sprintf('%s.post.res',pFileNamePrefix);

%Ouverture du fichier
lFile = fopen(lFileName,'w');

%Écriture de l'entête du fichier
fprintf(lFile,'GiD Post Results File 1.0\n');

end
