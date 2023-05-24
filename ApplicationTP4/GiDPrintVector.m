function [] = GiDPrintVector(pFile, pResultName, pAnalysisName, pTime, pVectNodeNo, pMatResults)
%GiDPrintVector Impression des vecteurs
%   Description détaillée:

%Impression de l'entête du fichier
fprintf(pFile, '\nResult \"%s\" \"%s\" %f Vector OnNodes',pResultName,pAnalysisName,pTime);
fprintf(pFile, '\nValues');

%Requête du nombre de noeuds
lNbValues = length(pVectNodeNo);

%Boucle sur les noeuds
for i = 1:lNbValues
  fprintf(pFile, '\n%d %16.5e %16.5e %16.5e', pVectNodeNo(i),pMatResults(i,1), pMatResults(i,2), pMatResults(i,3));
end

fprintf(pFile, '\nEnd Values\n');

end
