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


//////////////////////////////////////////////// OLD - A SUPPRIMER /////////////////////////////////////////////////////////////////////////////////////

// // update carbon tax rate
// // parameters.Carbon_Tax_rate = 110000;

// // Basic Need  in ktep/UC
// BasicNeed = zeros(nb_Sectors,1);
// // Put in sectoral parameters 
// BasicNeed_HH = (BasicNeed .*.ones(1,nb_Households));

// // Data for Households are in thousand of people
// Coef_HH_unitpeople = 10^3;

// // sensitivity analysis 
// parameters.sigma_X = parameters.sigma_X * (1+strtod(Trade_elast_var));
// parameters.sigma_M = parameters.sigma_M * (1+strtod(Trade_elast_var));

//////////////////////////////////////////////// WAGE CURVE  /////////////////////////////////////////////////////////////////////////////////////
parameters.Coef_real_wage = strtod(Coef_real_wage_dashboard);
parameters.sigma_omegaU = strtod(sigma_omegaU_dashboard);

//////////////////////////////////////////////// CARBON TAX EU-ETS  /////////////////////////////////////////////////////////////////////////////////////
if Carbone_ETS == "True"
    // En € / MtCO2
    if time_step==1 then
        parameters.Carbon_Tax_rate = 76000;
    elseif time_step==2 then
        parameters.Carbon_Tax_rate = 77900;
    elseif time_step==3 then
        parameters.Carbon_Tax_rate = 80800;
    elseif time_step==4 then
        parameters.Carbon_Tax_rate = 152000;
    end

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

//////////////////////////////////////////////// TRANSFERT MA PRIME RENOV  /////////////////////////////////////////////////////////////////////////////////////

if MaPrimRenov == "True"
    MPR_share = 0.25; // Share of housedolds' consumption paid by the public sector
else
    MPR_share = 0;
end


//////////////////////////////////////////////// TRANSFERT BONUS VEHICULES  /////////////////////////////////////////////////////////////////////////////////////
if Bonus_vehicule_dashboard == "True"
    if Scenario == "AMS"
        Bonus_vehicules_share = 0.02; // Share of housedolds' consumption paid by the public sector
    elseif Scenario == 'AME'
        if time_step==1
            Bonus_vehicules_share = 0.02;
        else
            Bonus_vehicules_share = 0;
        end
    else
        disp("TRANSFERT BONUS VEHICULES : SCENARIO NON TRAITE")
    end
else
    Bonus_vehicules_share = 0;
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


//////////////////////////////////////////////// ACTIFS ECHOUES  /////////////////////////////////////////////////////////////////////////////////////




