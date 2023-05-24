function [lChoixUser, lNomSchema] = ChoixIntegral()
%En fonction de la valeur saisie par l'utilisateur, cette fontion retourne
%le mode d'intégration choisi et le nom correspondant.

lcLimitEssai = 2;
lComptEssai = 0;
    %---------------- Affichage du menu --------------------
    disp('----------- CHOIX DU MODE D''INTEGRATION -------');
    disp('0 --> intégration exacte');
    disp('1 --> intégration par le schéma de Gauss à 1 point');
    disp('2 --> intégration par le schéma de Gauss à 2 points');
    disp('3 --> intégration par le schéma de Gauss à 3 points');
    
    lInputUser = input('VOTRE CHOIX = ','s');

    while lComptEssai<lcLimitEssai
        lInputUserDouble = str2double(lInputUser);
        if isnan(lInputUserDouble) || lInputUserDouble<0 || ...
                lInputUserDouble>3
            disp('!! REPONSE INCORRECTE');
            disp('Veuillez saisir une valeur selon le menu');
            lInputUser = input('Entrez votre choix = ' ,'s');
            lComptEssai = lComptEssai +1;

        else 
            lInputUser = lInputUserDouble;
            break
        end

        lInputUserDouble = str2double(lInputUser);
        if lComptEssai == lcLimitEssai && isnan(lInputUserDouble)
            lChoixUser = -1;
            lNomSchema = '';
            return;
        elseif lInputUserDouble>=0 && lInputUserDouble<=3
            lInputUser = lInputUserDouble;
            break
        end
    end

    switch lInputUser
        case 0
            lNomSchema = 'EXACTE';
        case 1
             lNomSchema = 'GAUSS 1PT';
        case 2
             lNomSchema = 'GAUSS 2PT';
        case 3
              lNomSchema = 'GAUSS 3PT';
    end

lChoixUser = lInputUser;
end