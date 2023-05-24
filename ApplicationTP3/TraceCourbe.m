function [] = TraceCourbe(pX, pYx, pNameSchema, pNbElem)
%%elle permet de visualiser la courbe des résultats pendant que le ...
%programme est encore en exécution. l'utilisateur peut ainsi faire 
%des comparaisons sans mettre fin à son programme.

    plot(pX,pYx)
    grid on
	xlabel('Position sur le cable (m)');
	ylabel('Deflexion du cable (m)');

    legend(sprintf('%s MEF N=%d ', pNameSchema, pNbElem));
    hold on
end 