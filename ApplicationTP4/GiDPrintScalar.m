function [] = GiDPrintScalar(pFile, pResultName, pAnalysisName, pTime, pVectNodeNo, pVectResults)
%GiDPrintScalar Impression des scalaires
%   Description d�taill�e:

%Impression de l'ent�te du fichier
fprintf(pFile, '\nResult \"%s\" \"%s\" %f Scalar OnNodes',pResultName,pAnalysisName,pTime);
fprintf(pFile, '\nValues');

%Requ�te du nombre de noeuds
lNbValues = length(pVectNodeNo);

%Boucle sur les noeuds
for i = 1:lNbValues
  fprintf(pFile, '\n%d %16.5e', pVectNodeNo(i), pVectResults(i));
end

fprintf(pFile, '\nEnd Values\n');

end
