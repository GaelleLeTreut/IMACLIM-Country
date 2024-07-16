// Est exécuté ligne 377 d'ImaclimS.sce :
// if Optimization_Resol then
//     if part(SystemOpt_Resol,1:length(OptHomo_Shortname))<> OptHomo_Shortname
//         exec(STUDY_Country+study+".sce");


//////////////////////////////////////////////// EMISSIONS  /////////////////////////////////////////////////////////////////////////////////////

// On réduit les facteurs d'émissions selon la proportion de bioénergie utilisée
if emissions_bioenergy == 'True' then
    Deriv_Exogenous.Emission_Coef_IC = Emission_Coef_IC;

	bioenergy_proportions_filename = 'bioenergy_proportions_' + Scenario; // Creation of a string like "bioenergy_proportions_AME"
	bioenergy_proportions = evstr(bioenergy_proportions_filename); // Get the value of the var named bioenergy_proportions_AME
	bioenergy_proportions = repmat(bioenergy_proportions(:,time_step)', nb_Sectors, 1)'; // Reproduction of the column corresponding to time_step
	Deriv_Exogenous.Emission_Coef_IC(Indice_EnerSect, :) = BY.Emission_Coef_IC(Indice_EnerSect, :) .* (ones(5 , nb_Sectors) - bioenergy_proportions); // Reducing the emissions factors by the proportions of bioenergy
end

//////////////////////////////////////////////// WAGE CURVE  /////////////////////////////////////////////////////////////////////////////////////
parameters.Coef_real_wage = strtod(Coef_real_wage_dashboard);
parameters.sigma_omegaU = strtod(sigma_omegaU_dashboard);


//////////////////////////////////////////////// CARBON TAX EU-ETS  /////////////////////////////////////////////////////////////////////////////////////
if Carbone_ETS == "True"
    
    // Carbon_Tax_rate en €2018 / MtCO2, même s'il est appliqué en € courant
    if time_step==1 then
        parameters.Carbon_Tax_rate = 80000;
    elseif time_step==2 then
        parameters.Carbon_Tax_rate = 85000;
    elseif time_step==3 then
        parameters.Carbon_Tax_rate = 160000;
    end

    // On rentre les valeurs en €2020 en dur, que l'on déflate pour avoir des €2018
    inflation_2018_2020 = 0.027;
    parameters.Carbon_Tax_rate = parameters.Carbon_Tax_rate * (1-inflation_2018_2020);

    // pause
    if Scenario == 'AME' | Scenario =='AME_TISE' | Scenario =='AME_TESI_iter2' | Scenario =='AME_TESI' | Scenario =='AME_M3_CBAM_TESI' | Scenario =='AME_normal_sans_CBAM_TESI' | Scenario =='AME_M3_sans_CBAM_TESI'
        // Pour définir des taxes carbones différentes selon les secteurs
        CarbonTax_Diff_IC_filename = 'CarbonTax_Diff_IC_' + Scenario; // Creation of a string like "CarbonTax_Diff_IC_AME"
        parameters.CarbonTax_Diff_IC = evstr(CarbonTax_Diff_IC_filename); // Useless
        // CarbonTax_Diff_IC = evstr(CarbonTax_Diff_IC_filename);
        Deriv_Exogenous.CarbonTax_Diff_IC = evstr(CarbonTax_Diff_IC_filename);

        CarbonTax_Diff_C_filename = 'CarbonTax_Diff_C_' + Scenario; // Creation of a string like "CarbonTax_Diff_C_AME"
        parameters.CarbonTax_Diff_C = evstr(CarbonTax_Diff_C_filename); // Useless ?
        // CarbonTax_Diff_C = evstr(CarbonTax_Diff_C_filename);
        Deriv_Exogenous.CarbonTax_Diff_C = evstr(CarbonTax_Diff_C_filename);

    elseif Scenario == 'AMS' | (Scenario == 'AMS_TISE' & Scenario_ETS <> 'AMS_TESI_high_ETS') | (Scenario == 'AMS_TESI_iter2' & Scenario_ETS <> 'AMS_TESI_high_ETS') | (Scenario == 'AMS_TESI' & Scenario_ETS <> 'AMS_TESI_high_ETS') | (Scenario == 'AMS_M3_CBAM_TESI' & Scenario_ETS <> 'AMS_TESI_high_ETS') | (Scenario == 'AMS_normal_sans_CBAM_TESI' & Scenario_ETS <> 'AMS_TESI_high_ETS') | (Scenario == 'AMS_M3_sans_CBAM_TESI' & Scenario_ETS <> 'AMS_TESI_high_ETS')
        // PRIX DU CARBONE PLUS FAIBLE EN 2030 SUR LE PERIMETRE DE L'ETS 2
        if time_step == 2
            // Pour définir des taxes carbones différentes selon les secteurs
            CarbonTax_Diff_IC_filename = 'CarbonTax_Diff_IC_2030_' + Scenario; // Creation of a string like "CarbonTax_Diff_IC_AME"
            parameters.CarbonTax_Diff_IC = evstr(CarbonTax_Diff_IC_filename); // Useless
            // CarbonTax_Diff_IC = evstr(CarbonTax_Diff_IC_filename);
            Deriv_Exogenous.CarbonTax_Diff_IC = evstr(CarbonTax_Diff_IC_filename);

            CarbonTax_Diff_C_filename = 'CarbonTax_Diff_C_2030_' + Scenario; // Creation of a string like "CarbonTax_Diff_C_AME"
            parameters.CarbonTax_Diff_C = evstr(CarbonTax_Diff_C_filename); // Useless ?
            // CarbonTax_Diff_C = evstr(CarbonTax_Diff_C_filename);
            Deriv_Exogenous.CarbonTax_Diff_C = evstr(CarbonTax_Diff_C_filename);  
        else
            // Pour définir des taxes carbones différentes selon les secteurs
            CarbonTax_Diff_IC_filename = 'CarbonTax_Diff_IC_' + Scenario; // Creation of a string like "CarbonTax_Diff_IC_AME"
            parameters.CarbonTax_Diff_IC = evstr(CarbonTax_Diff_IC_filename); // Useless
            // CarbonTax_Diff_IC = evstr(CarbonTax_Diff_IC_filename);
            Deriv_Exogenous.CarbonTax_Diff_IC = evstr(CarbonTax_Diff_IC_filename);

            CarbonTax_Diff_C_filename = 'CarbonTax_Diff_C_' + Scenario; // Creation of a string like "CarbonTax_Diff_C_AME"
            parameters.CarbonTax_Diff_C = evstr(CarbonTax_Diff_C_filename); // Useless ?
            // CarbonTax_Diff_C = evstr(CarbonTax_Diff_C_filename);
            Deriv_Exogenous.CarbonTax_Diff_C = evstr(CarbonTax_Diff_C_filename);
        end

    elseif Scenario == 'AMS_high_ETS' | Scenario_ETS == 'AMS_TESI_high_ETS'
        parameters.Carbon_Tax_rate = 1000;

        // Pour définir des taxes carbones différentes selon les ETS 1 et 2

        // Trajectoire de coûts du carbone à 410€ en 2050 pour l'ETS1 dans l'AMS
        // Carbon_Tax_rate en €2018 / MtCO2, même s'il est appliqué en € courant
        // prix_carbone_ets_1_AMS = [80, 120, 250, 410];
        // prix_carbone_ets_2 = [80, 82, 85, 160];

        // Pour tester
        // prix_carbone_ets_1_AMS = prix_carbone_ets_2

        // On rentre les valeurs en €2020 en dur, que l'on déflate pour avoir des €2018
        inflation_2018_2020 = 0.027;
        prix_carbone_ets_1_AMS = prix_carbone_ets_1_AMS .* (1-inflation_2018_2020);
        prix_carbone_ets_2 = prix_carbone_ets_2 .* (1-inflation_2018_2020);

        CarbonTax_Diff_IC_ETS1_filename = 'CarbonTax_Diff_IC_ETS1_' + Scenario;
        CarbonTax_Diff_IC_ETS2_filename = 'CarbonTax_Diff_IC_ETS2_' + Scenario;

        if Scenario == 'AMS_TISE' | Scenario == 'AMS_TESI_iter2' | Scenario == 'AMS_TESI' | Scenario == 'AMS_M3_CBAM_TESI' | Scenario == 'AMS_normal_sans_CBAM_TESI' | Scenario == 'AMS_M3_sans_CBAM_TESI' 
            CarbonTax_Diff_IC_ETS1_filename = CarbonTax_Diff_IC_ETS1_filename + '_high_ETS';
            CarbonTax_Diff_IC_ETS2_filename = CarbonTax_Diff_IC_ETS2_filename + '_high_ETS';
        end

        parameters.CarbonTax_Diff_IC = prix_carbone_ets_1_AMS(time_step) * evstr(CarbonTax_Diff_IC_ETS1_filename) + ..
                                        prix_carbone_ets_2(time_step) * evstr(CarbonTax_Diff_IC_ETS2_filename);
        // CarbonTax_Diff_IC = evstr(CarbonTax_Diff_IC_filename);
        Deriv_Exogenous.CarbonTax_Diff_IC = prix_carbone_ets_1_AMS(time_step) * evstr(CarbonTax_Diff_IC_ETS1_filename) + ..
                                        prix_carbone_ets_2(time_step) * evstr(CarbonTax_Diff_IC_ETS2_filename);


        CarbonTax_Diff_C_filename = 'CarbonTax_Diff_C_' + Scenario; // Creation of a string like "CarbonTax_Diff_C_AME"
        parameters.CarbonTax_Diff_C = prix_carbone_ets_2(time_step) * evstr(CarbonTax_Diff_C_filename); // Useless ?
        // CarbonTax_Diff_C = evstr(CarbonTax_Diff_C_filename);
        Deriv_Exogenous.CarbonTax_Diff_C = prix_carbone_ets_2(time_step) * evstr(CarbonTax_Diff_C_filename);
        
        Deriv_Exogenous.CarbonTax_Diff_M = 0.4 * prix_carbone_ets_1_AMS(time_step);
        parameters.CarbonTax_Diff_M = 0.4 * prix_carbone_ets_1_AMS(time_step);


    else
        error('Scenario non traite pour l ETS')
    end
end

//////////////////////////////////////////////// TRANSFERT MA PRIME RENOV  /////////////////////////////////////////////////////////////////////////////////////

MPR_share = 0;

if MaPrimRenov == "True"
    if Scenario == "AMS" | Scenario == "AMS_high_ETS"
        if time_step==1 then
            MPR_share = 0.145; // Share of property_bus invest in construction paid by the public sector
        elseif time_step==2 then
            MPR_share = 0.147;
        elseif time_step==3 then
            MPR_share = 0.104;
        elseif time_step==4 then
            MPR_share = 0.024;
        end

    elseif Scenario == 'AME'
        MPR_share = 0;
    else
        disp("TRANSFERT MA PRIME RENOV : SCENARIO NON TRAITE")
    end
end 


//////////////////////////////////////////////// TRANSFERT BONUS VEHICULES  /////////////////////////////////////////////////////////////////////////////////////

Bonus_vehicules_share = 0;

if Bonus_vehicule_dashboard == "True"
    if Scenario == "AMS" | Scenario == "AMS_high_ETS"

        if time_step==1 then
            Bonus_vehicules_share = 0.068; // Share of housedolds' consumption paid by the public sector
        elseif time_step==2 then
            Bonus_vehicules_share = 0.1;
        elseif time_step==3 then
            Bonus_vehicules_share = 0.1;
        elseif time_step==4 then
            Bonus_vehicules_share = 0.1;
        end

    elseif Scenario == 'AME'
        if time_step==1
            Bonus_vehicules_share = 0.052;
        else
            Bonus_vehicules_share = 0;
        end
    else
        disp("TRANSFERT BONUS VEHICULES : SCENARIO NON TRAITE")
    end
end 



//////////////////////////////////////////////// GESTION DES KAPPAS  /////////////////////////////////////////////////////////////////////////////////////



//////////////////////////////////////////////// INACTIF ET NON TESTE - BAISSER LA TICPE  /////////////////////////////////////////////////////////////////////////////////////
// REDUCING THE TICPE TAX BY THE PROPORTION OF BIOENERGY - ONLY FOR LIQUID_FUELS
if 0 & ticpe_bioenergy == 'True' then
    bioenergy_proportions_filename = 'bioenergy_proportions_' + Scenario; // Creation of a string like "bioenergy_proportions_AME"
    bioenergy_proportions = evstr(bioenergy_proportions_filename); // Get the value of the var named bioenergy_proportions_AME
    bioenergy_proportion_liquid_fuels = bioenergy_proportions(2,time_step); // Select liquid_fuels' value for time_step

    bioenergy_taxe_rate = 0.33 * Energy_Tax_rate_IC(2); // We suppose bioenergy is 3 times less taxed

    Deriv_Exogenous.Energy_Tax_rate_IC = Energy_Tax_rate_IC;
    Deriv_Exogenous.Energy_Tax_rate_IC(2) = bioenergy_taxe_rate * bioenergy_proportion_liquid_fuels + Energy_Tax_rate_IC(2) * (1-bioenergy_proportion_liquid_fuels); // Weighted calculation
end

//////////////////////////////////////////////// INACTIF - CONTROLE DE LA TICGN (TICPE pour le gaz) /////////////////////////////////////////////////////////////////////////////////////
if Scenario=='AMS2035' & ticgn_controlled=='True' then

    // Get the initial value of the TICGN rate
    BY_ticgn_rate = BY.Energy_Tax_rate_IC(1,Indice_GasS);

    // Calculate the new value of the TICGN rate, depending on time_step
    if time_step == 1
        new_ticgn_rate = BY_ticgn_rate * 2.61; // Multiplier's values come from "Prix - AME2021_V 17 - avec calculs.xlsx"
	elseif time_step == 2
        new_ticgn_rate = BY_ticgn_rate * 3.84;
    elseif time_step == 3
        new_ticgn_rate = BY_ticgn_rate * 3.42;
    elseif time_step == 4
        new_ticgn_rate = BY_ticgn_rate * 2.29;
	end

    // Force the new value of TICGN rate
    Deriv_Exogenous.Energy_Tax_rate_IC = Energy_Tax_rate_IC;
    Deriv_Exogenous.Energy_Tax_rate_IC(1,Indice_GasS) = new_ticgn_rate;

end

//////////////////////////////////////////////// ELASTICITE PRIX AUX IMPORTATIONS  /////////////////////////////////////////////////////////////////////////////////////
indices_indus_sect = [6:11];

if Scenario == 'AME_M3_CBAM_TESI' | Scenario == 'AMS_M3_CBAM_TESI' then
    sigma_M(indices_indus_sect) = 3;
    sigma_X(indices_indus_sect) = 1;

elseif Scenario == 'AME_M3_sans_CBAM_TESI' | Scenario == 'AMS_M3_sans_CBAM_TESI' then
    sigma_M(indices_indus_sect) = 3;
    sigma_X(indices_indus_sect) = 1;

elseif Scenario == 'AME_normal_sans_CBAM_TESI' | Scenario == 'AMS_normal_sans_CBAM_TESI' then

end

//////////////////////////////////////////////// PROJECTIONS SELON LES SCENARIOS /////////////////////////////////////////////////////////////////////////////////////
if Scenario == 'AME'
    Proj_Vol.C.ind_of_proj = list(list(Indice_EnerSect,1:nb_Households));
    Proj_Vol.I.apply_proj = %F;
end

if Scenario == 'AMS' // Config de Projections_Scenario_SNBC3.csv
    Proj_Vol.C.ind_of_proj = list(list(Indice_EnerSect,1:nb_Households),list(Indice_AutoS,1:nb_Households),list(Indice_PropertyS,1:nb_Households));
    Proj_Vol.I.ind_of_proj = list(list(Indice_ConstruS,Indice_PropertyS),list(Indice_AutoS,Indice_LandS),list(Indice_ConstruS,Indice_LandS),list(1:nb_Sectors,Indice_ElecS));
end

if Scenario == 'AME_run2'
    // Proj_Vol.C.ind_of_proj = list(list(Indice_EnerSect,1:nb_Households));
    Proj_Vol.C.ind_of_proj = list(list(Indice_EnerSect,1:nb_Households),list(Indice_AutoS,1:nb_Households));
    // Proj_Vol.I.apply_proj = %F;
    Proj_Vol.I.ind_of_proj = list(list(Indice_ConstruS,Indice_PropertyS),list(Indice_AutoS,Indice_LandS),list(Indice_ConstruS,Indice_LandS),list(1:nb_Sectors,Indice_ElecS));
end

if Scenario == 'AMS_run2' // Config de Projections_Scenario_SNBC3.csv
    Proj_Vol.C.ind_of_proj = list(list(Indice_EnerSect,1:nb_Households),list(Indice_AutoS,1:nb_Households),list(Indice_PropertyS,1:nb_Households));
    Proj_Vol.I.ind_of_proj = list(list(Indice_ConstruS,Indice_PropertyS),list(Indice_AutoS,Indice_LandS),list(Indice_ConstruS,Indice_LandS),list(1:nb_Sectors,Indice_ElecS));
end

if Scenario == 'AME_TISE' | Scenario == 'AME_TESI_iter2' | Scenario == 'AME_TESI' | Scenario =='AME_M3_CBAM_TESI' | Scenario =='AME_normal_sans_CBAM_TESI' | Scenario =='AME_M3_sans_CBAM_TESI'
    Proj_Vol.C.ind_of_proj = list(list(Indice_EnerSect,1:nb_Households));
    Proj_Vol.I.ind_of_proj = list(list(Indice_SteelIronS,1:nb_Sectors),list(Indice_NonMetalsS, 1:nb_Sectors),list(Indice_CementS, 1:nb_Sectors),list(Indice_OthMinS, 1:nb_Sectors), ..
    list(Indice_PharmaS, 1:nb_Sectors),list(Indice_PaperS, 1:nb_Sectors));
end

if Scenario == 'AMS_TISE' | Scenario == 'AMS_TESI_iter2' | Scenario == 'AMS_TESI' // Config de Projections_Scenario_TISE.csv
    Proj_Vol.C.ind_of_proj = list(list(Indice_EnerSect,1:nb_Households),list(Indice_AutoS,1:nb_Households),list(Indice_PropertyS,1:nb_Households));
    Proj_Vol.I.ind_of_proj = list(list(Indice_ConstruS,Indice_PropertyS),list(Indice_AutoS,Indice_LandS),list(Indice_ConstruS,Indice_LandS),list(1:nb_Sectors,Indice_ElecS),list(Indice_SteelIronS,1:nb_Sectors), ..
    list(Indice_NonMetalsS, 1:nb_Sectors),list(Indice_CementS, 1:nb_Sectors),list(Indice_OthMinS, 1:nb_Sectors),list(Indice_PharmaS, 1:nb_Sectors),list(Indice_PaperS, 1:nb_Sectors));
end


//////////////////////////////////////////////// POUR SIMULATIONS PAS A PAS  /////////////////////////////////////////////////////////////////////////////////////

// TOCLEAN
// Productivite du travail quand Demographic_shift est désactivé : on met les valeurs qui sont normalement calculees dans macro_framework.sce
if Scenario == 'AME_TISE' | Scenario == 'AME_TESI_iter2' | Scenario == 'AME_TESI'
    if Labour_product =='True' & Demographic_shift <> 'True'
        if time_step == 1
            parameters.Mu = 0.0063541;
        elseif time_step == 2
            parameters.Mu = 0.0083716;
        elseif time_step == 3
            parameters.Mu = 0.0110542;
        else 
            erreur
        end

        parameters.phi_L = ones(parameters.phi_L).*parameters.Mu;
    end

elseif Scenario == 'AME'
    if Labour_product =='True' & Demographic_shift <> 'True'
        if time_step == 1
            parameters.Mu = 0.0063541;
        elseif time_step == 2
            parameters.Mu = 0.0076591;
        elseif time_step == 3
            parameters.Mu = 0.0083716;
        elseif time_step == 4
            parameters.Mu = 0.0110542;
        else 
            erreur
        end

        parameters.phi_L = ones(parameters.phi_L).*parameters.Mu;
    end
end

// Desactiver les projections qui sont toujours mises a %T dans projection_scenario.csv
if proj_alpha == 'false'
    Proj_Vol.alpha.apply_proj = %F;
end 

if proj_c == 'false'
    Proj_Vol.C.apply_proj = %F;
end 

if proj_kappa == 'false'
    Proj_Vol.kappa.apply_proj = %F;
end

if proj_imports == 'false'
    Proj_Vol.M_Y.apply_proj = %F;
end

if proj_exports == 'false'
    Proj_Vol.X.apply_proj = %F;
end

if proj_invest == 'false'
    Proj_Vol.I.apply_proj = %F;
end

if proj_pY == 'false'
    Proj_Vol.pY.apply_proj = %F;
end

if proj_spemarg_rates_IC == 'false'
    Proj_Vol.SpeMarg_rates_IC.apply_proj = %F;
end

