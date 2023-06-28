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

//////////////////////////////////////////////// CONTROLE pY GAZ PAR RAPPORT A pM GAZ  /////////////////////////////////////////////////////////////////////////////////////
if pY_gas_reduced == 'True' then
    // Baisser le taux de Profit_margin pour avoir un taux proche de celui du pétrole
    Deriv_Exogenous.markup_rate = markup_rate;
    Deriv_Exogenous.markup_rate(Indice_GasS) = BY.markup_rate(Indice_GasS) / 10;

    // Baisser le lambda du gaz pour avoir une intensité en emploi similaire à celle du liquid et de l'élec
    // BY.lambda(Indice_GasS) = 0.002; // avant valait 0.012. Divise par 6
    // BY.w(Indice_GasS) = 40000; // avant valait 61390.52

    // Baisser les taux de marges spécifiques appliqués par les secteurs énergétiques pour leurs ventes au gaz
    Deriv_Exogenous.SpeMarg_rates_IC = SpeMarg_rates_IC;
    Deriv_Exogenous.SpeMarg_rates_IC(Indice_GasS, Indice_GasS) = -0.87;
    Deriv_Exogenous.SpeMarg_rates_IC(Indice_GasS, Indice_CoalS) = -0.87;
    Deriv_Exogenous.SpeMarg_rates_IC(Indice_GasS, Indice_ElecS) = -0.87;
    // Deriv_Exogenous.SpeMarg_rates_IC(Indice_GasS, Indice_GasS) = -0.5;
    // Deriv_Exogenous.SpeMarg_rates_IC(Indice_GasS, Indice_CoalS) = -0.5;
    // Deriv_Exogenous.SpeMarg_rates_IC(Indice_GasS, Indice_ElecS) = -0.5;

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
        parameters.Carbon_Tax_rate = 82000;
    elseif time_step==3 then
        parameters.Carbon_Tax_rate = 85000;
    elseif time_step==4 then
        parameters.Carbon_Tax_rate = 160000;
    end

    // On rentre les valeurs en €2020 en dur, que l'on déflate pour avoir des €2018
    inflation_2018_2020 = 0.027;
    parameters.Carbon_Tax_rate = parameters.Carbon_Tax_rate * (1-inflation_2018_2020);


    if Scenario == 'AME'
        // Pour définir des taxes carbones différentes selon les secteurs
        CarbonTax_Diff_IC_filename = 'CarbonTax_Diff_IC_' + Scenario; // Creation of a string like "CarbonTax_Diff_IC_AME"
        parameters.CarbonTax_Diff_IC = evstr(CarbonTax_Diff_IC_filename); // Useless
        // CarbonTax_Diff_IC = evstr(CarbonTax_Diff_IC_filename);
        Deriv_Exogenous.CarbonTax_Diff_IC = evstr(CarbonTax_Diff_IC_filename);

        CarbonTax_Diff_C_filename = 'CarbonTax_Diff_C_' + Scenario; // Creation of a string like "CarbonTax_Diff_C_AME"
        parameters.CarbonTax_Diff_C = evstr(CarbonTax_Diff_C_filename); // Useless ?
        // CarbonTax_Diff_C = evstr(CarbonTax_Diff_C_filename);
        Deriv_Exogenous.CarbonTax_Diff_C = evstr(CarbonTax_Diff_C_filename);

    elseif Scenario == 'AMS'
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

    elseif Scenario == 'AMS_high_ETS'
        parameters.Carbon_Tax_rate = 1000;

        // Pour définir des taxes carbones différentes selon les ETS 1 et 2

        // Trajectoire de coûts du carbone à 410€ en 2050 pour l'ETS1 dans l'AMS
        // Carbon_Tax_rate en €2018 / MtCO2, même s'il est appliqué en € courant
        prix_carbone_ets_1_AMS = [80, 120, 250, 410];
        prix_carbone_ets_2 = [80, 82, 85, 160];

        // Pour tester
        // prix_carbone_ets_1_AMS = prix_carbone_ets_2

        // On rentre les valeurs en €2020 en dur, que l'on déflate pour avoir des €2018
        inflation_2018_2020 = 0.027;
        prix_carbone_ets_1_AMS = prix_carbone_ets_1_AMS .* (1-inflation_2018_2020);
        prix_carbone_ets_2 = prix_carbone_ets_2 .* (1-inflation_2018_2020);

        CarbonTax_Diff_IC_ETS1_filename = 'CarbonTax_Diff_IC_ETS1_' + Scenario; 
        CarbonTax_Diff_IC_ETS2_filename = 'CarbonTax_Diff_IC_ETS2_' + Scenario; 

        parameters.CarbonTax_Diff_IC = prix_carbone_ets_1_AMS(time_step) * evstr(CarbonTax_Diff_IC_ETS1_filename) + ..
                                        prix_carbone_ets_2(time_step) * evstr(CarbonTax_Diff_IC_ETS2_filename);
        // CarbonTax_Diff_IC = evstr(CarbonTax_Diff_IC_filename);
        Deriv_Exogenous.CarbonTax_Diff_IC = prix_carbone_ets_1_AMS(time_step) * evstr(CarbonTax_Diff_IC_ETS1_filename) + ..
                                        prix_carbone_ets_2(time_step) * evstr(CarbonTax_Diff_IC_ETS2_filename);


        CarbonTax_Diff_C_filename = 'CarbonTax_Diff_C_' + Scenario; // Creation of a string like "CarbonTax_Diff_C_AME"
        parameters.CarbonTax_Diff_C = prix_carbone_ets_2(time_step) * evstr(CarbonTax_Diff_C_filename); // Useless ?
        // CarbonTax_Diff_C = evstr(CarbonTax_Diff_C_filename);
        Deriv_Exogenous.CarbonTax_Diff_C = prix_carbone_ets_2(time_step) * evstr(CarbonTax_Diff_C_filename);
        
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
    if ticpe_bioenergy == 'True' then
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


//////////////////////////////////////////////// OLD - CONTROLE DES PRIX DE L'ENERGIE  /////////////////////////////////////////////////////////////////////////////////////
// On fait varier les coefficients techniques de liquid_fuels et de gas_fuels dans l'AMS,
// pour obtenir en sortie des écarts de prix par rapport à l'AME similaires à ceux des données de la DGEC
if Scenario=='AMS2035' & energy_prices_controlled=='True' then

    // Get the initial value of the alphas for liquid_fuels and gas_fuels
    alpha_init = Proj_Vol('alpha').val;
    alpha_liquid_init = alpha_init(1:5, Indice_OilS);
    alpha_gas_init = alpha_init(1:5, Indice_GasS);
    
    // Calculate the new values of the alphas, depending on time_step
    // VALEURS DE MULTIPLICATEURS JUSQU'AU 8 FEVRIER 17H
    // if time_step == 1
    //     alpha_liquid_new = alpha_liquid_init * 0.95;
    //     alpha_gas_new = alpha_gas_init * 2.30;
	// elseif time_step == 2
    //     alpha_liquid_new = alpha_liquid_init * 0.95;
    //     alpha_gas_new = alpha_gas_init * 2.30;
    // elseif time_step == 3
    //     alpha_liquid_new = alpha_liquid_init * 0.67;
    //     alpha_gas_new = alpha_gas_init * 1.53;
    // elseif time_step == 4
    //     alpha_liquid_new = alpha_liquid_init * 0.24;
    //     alpha_gas_new = alpha_gas_init * 1.52;
	// end

    // VALEURS DE MULTIPLICATEURS APRES LE 8 FEVRIER 17H
    if time_step == 1
        alpha_liquid_new = alpha_liquid_init * 0.95;
        alpha_gas_new = alpha_gas_init * 2.30;
	elseif time_step == 2
        alpha_liquid_new = alpha_liquid_init * 0.95;
        alpha_gas_new = alpha_gas_init * 2.30;
    elseif time_step == 3
        alpha_liquid_new = alpha_liquid_init * 0.67;
        alpha_gas_new = alpha_gas_init * 1.53;
    elseif time_step == 4
        alpha_liquid_new = alpha_liquid_init * 0.24;
        alpha_gas_new = alpha_gas_init * 1.52;
	end


    // Force the new values of the alphas for liquid_fuels and gas_fuels
    alpha_new = alpha_init;
    alpha_new(1:5, Indice_OilS) = alpha_liquid_new;
    alpha_new(1:5, Indice_GasS) = alpha_gas_new;
    //Deriv_Exogenous.alpha = alpha_new;
    Proj_Vol('alpha').val = alpha_new;
    
    // After the resolution, there is a test on wether the projection went well or not,
    // line 442 of ImaclimS.sce, calling Check_Proj_Vol.sce".
    // We put the new values of alpha in Proj_Vol to succeed this test.
    //Proj_Vol('alpha').val = alpha_new;
end

//////////////////////////////////////////////// COMPOSANTES DU BUDGET PUBLIC  /////////////////////////////////////////////////////////////////////////////////////

// On définit des variables globales pour y avoir accès dans Output_Indic et les afficher dans le fullTemplate
global G_Tax_revenue
global G_Non_Labour_Income
global G_Other_Income
global G_Property_income
global G_Social_Transfers
global G_Compensations
global T_MPR
global Bonus_vehicules

//////////////////////////////////////////////// ACTIFS ECHOUES  /////////////////////////////////////////////////////////////////////////////////////


//////////////////////////////////////////////// ELASTICITE ENTRE PRODUCTION ET EXPORTS  /////////////////////////////////////////////////////////////////////////////////////

// new_sigma_X = 0.8; // Initial parameter is 0.42

// for i=1:nb_Sectors
//     if sigma_X(i) <> 0
//         sigma_X(i) = new_sigma_X;
//     end
// end

// Deriv_Exogenous.sigma_X = sigma_X;

//////////////////////////////////////////////// ELASTICITE ENTRE PRODUCTION ET IMPORTS  /////////////////////////////////////////////////////////////////////////////////////

// new_sigma_M = 0.8; // Initial parameter is 1.9

// for i=1:nb_Sectors
//     if sigma_M(i) <> 0
//         sigma_M(i) = sigma_M;
//     end
// end

