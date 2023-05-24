function [] = CourbeFinal(pComptCas,pCordX,pCordY,plegendNames)
%%Cette fonction permet de tracer toutes les courbes des cas étudiés à
%la fin du programme.

    for k = 1:pComptCas-1
        plot( pCordX{k}, pCordY{k} )
        hold on
        grid on
    end

    legend(plegendNames);
    xlabel('Position sur le cable (m)');
    ylabel('Déflexion du cable (m)');
end