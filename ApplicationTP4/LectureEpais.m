function [lValEpaisseur] = LectureEpais(pFichierGiD)
%fonction de lecture de l'épaisseur de la base GiD
% la valeur -1 en cas d'erreur servira à l'arrêt du programme principal

disp(" ");
disp("************ LECTURE DE L'EPAISSEUR EN COURS ********************");
IdFichier = fopen(pFichierGiD,"r");

%============== TROUVER L'INFORMATION SUR L'EPAISSEUR ================

while true % parcours de tout le fichier

    %-----lecture de la premiere ligne du fichier .dat
    LirLigne = fgetl(IdFichier);

    %------Si la ligne lue contient le mot clé EPAISSEUR
    if contains(LirLigne,'EPAISSEUR')
        InfoEpaisseur = textscan(LirLigne, '%s  %f');
        % on récupère la valeur de l'épaisseur
        lValEpaisseur = InfoEpaisseur{2};
        % test sur la valeur de l'épaisseur
        if isempty(lValEpaisseur) || lValEpaisseur == 0
            disp("Le bloc EPAISSEUR n'est pas defini dans..." + ...
                " le fichier de donnees");
            lValEpaisseur = -1;
            return
        end
        break % Arrêt de la boucle while une fois la bonne valeur trouvée

    %-si la ligne lue est non vide et ne contient pas le mode clé EPAISSEUR
    elseif ~contains(LirLigne,'CLE') || ~isempty(LirLigne)
        continue

    %----si la ligne lue est vide alors elle est vide ou erreur fichier
    else  
        disp('Fin du fichier atteinte ou le fichier est corrompu');
        disp("le bloc EPAISSEUR est introuvable");
        lValEpaisseur = -1;
        return
    end 
end

fprintf("-> Epaisseur : %f mètre(s) \n", lValEpaisseur);
end