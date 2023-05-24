function [lResultNbElem, lResultLongCabl, lResultTens, ...
    lResultW0,lResultCoefK] = LectureData()
% LECTURE_DATA verifie les données saisies par l'utilisateur et ...
% verifie leur conformité en tenant compte de la physique du problème

%================= LES CONDITIONS DE VALIDITÉ ========================
    lcLimitEssai = 2;
    lComptEssai = 0;
    
% ================== Nombre d'éléments ================================
    lNbEle = input (['Nombre d''éléments pour ' ...
    'la discrétisation N = '],'s');
    while lComptEssai<lcLimitEssai
        lNbElemDouble = str2double(lNbEle);
        if isnan(lNbElemDouble) || lNbElemDouble<=1
            disp('!! REPONSE INCORRECTE, ENTRER UNE VALEUR NUMERIQUE !!');
            disp('Veuillez saisir un nombre supérieur à 1');
            lNbEle = input (['Entrez le nombre ...' ...
                'd''éléments voulus N = '],'s');
            lComptEssai = lComptEssai +1;

        else 
            lNbEle = lNbElemDouble;
            break
        end

        lNbElemDouble = str2double(lNbEle);
        if lComptEssai == lcLimitEssai && isnan(lNbElemDouble)
            lResultNbElem = -1;
            lResultLongCabl = 0;
            lResultTens = 0;
            lResultW0 = 0;
            lResultCoefK = 0;
            return;
        elseif lNbElemDouble > 1 
            lNbEle = lNbElemDouble;
        break
        end
    end
    lComptEssai = 0;
    
%==========================Longueur du cable =======================
    lLongCabl = input ('Entrez la longueur du câble en metre L = ','s');
    while lComptEssai<lcLimitEssai
        lLongCablDouble = str2double(lLongCabl);
        if isnan(lLongCablDouble) || lLongCablDouble <= 0
            disp('Veuillez saisir un nombre supérieur à 0');
            lLongCabl = input ('Entrez la longueur du cable ','s');
            lComptEssai = lComptEssai +1;
        else
            lLongCabl = lLongCablDouble;
            break
        end

        lLongCablDouble = str2double(lLongCabl);
        if lComptEssai == lcLimitEssai && isnan(lLongCablDouble)
            lResultNbElem = -1;
            lResultLongCabl = 0;
            lResultTens = 0;
            lResultW0 = 0;
            lResultCoefK = 0;
            return;
        elseif lLongCablDouble > 0
            lLongCabl = lLongCablDouble;
            break
        end
    end
    lComptEssai = 0;
    
%==================== la tension du cable============================
    lTension = input (['Entrez la valeur de la tension du ' ...
        'cable en kN T = '],'s');
    while lComptEssai < lcLimitEssai
        lTensionDouble = str2double(lTension);
        if isnan(lTensionDouble) || lTensionDouble<=0
            disp('Veuillez saisir un nombre supérieur à 0');
            lTension = input ('Entrez la tension = ','s');
            lComptEssai = lComptEssai +1;
        else
            lTension = lTensionDouble;
            break
        end

        lTensionDouble = str2double(lTension);
        if lComptEssai == lcLimitEssai && isnan(lTensionDouble)
            lResultNbElem = -1;
            lResultLongCabl = 0;
            lResultTens = 0;
            lResultW0 = 0;
            lResultCoefK = 0;
            return;
        elseif lTensionDouble > 0 
            lTension = lTensionDouble;
            break
        end
    end
    lComptEssai = 0;
    
    
% ===================== la charge linéique============================
    lChargeW0 = input (['Entrez la valeur de la charge repartie en ' ...
        'kN/m w0 = '],'s');
    while lComptEssai < lcLimitEssai
        lChargeW0Double = str2double(lChargeW0);
        if isnan(lChargeW0Double) || lChargeW0Double<=0
            disp('Veuillez saisir un nombre supérieur à 0');
            lChargeW0 = input ('Entrez la charge (valeur de w0) ','s');
            lComptEssai = lComptEssai +1;
        else
            lChargeW0 = lChargeW0Double;
            break
        end
    
        lChargeW0Double = str2double(lChargeW0);
        if lComptEssai == lcLimitEssai && isnan(lChargeW0Double)
            lResultNbElem = -1;
            lResultLongCabl = 0;
            lResultTens = 0;
            lResultW0 = 0;
            lResultCoefK = 0;
            return;
        elseif lChargeW0Double > 0
            lChargeW0 = lChargeW0Double;
            break
        end
    end
    lComptEssai = 0;
    
% ==================== coefficient k =================================
    lCoefK = input ('Entrez la valeur du coefficient k =  ','s');
    while lComptEssai < lcLimitEssai
        lCoefKDouble = str2double(lCoefK);
        if isnan(lCoefKDouble)
            disp('Veuillez saisir un nombre k = ');
            lCoefK = input ('Entrez k = ','s');
            lComptEssai = lComptEssai +1;
        else
            lCoefK = lCoefKDouble;
            break
        end

    lCoefKDouble = str2double(lCoefK);
    if lComptEssai == lcLimitEssai && isnan(lCoefKDouble)
        lResultNbElem = -1;
        lResultLongCabl = 0;
        lResultTens = 0;
        lResultW0 = 0;
        lResultCoefK = 0;
        return;
    elseif isnumerictype(lCoefKDouble)
        lCoefK = lCoefKDouble;
    end
    end
    
%=============== FIN DU PROGRAMME ET RESULTATS =======================
    lResultNbElem = lNbEle;
    lResultLongCabl = lLongCabl;
    lResultTens = lTension;
    lResultW0 = lChargeW0;
    lResultCoefK = lCoefK;
end