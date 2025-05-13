if  VAR_saving=="low"
	
	Deriv_Exogenous.Household_saving_rate = evstr(0.11);

elseif  VAR_saving=="ref"
	
	Deriv_Exogenous.Household_saving_rate = evstr(0.14);

elseif VAR_saving=="high"

	Deriv_Exogenous.Household_saving_rate = evstr(0.174);

end

if proj_c == 'true' & Scenario =='AMSrun3' & time_step == 3

    if auto_c == "1"

        Proj_Vol.C.val(12) = 64713
    
    elseif auto_c == "2"
    
        Proj_Vol.C.val(12) = 57523

    elseif auto_c == "3"

        Proj_Vol.C.val(12) = 50332

    elseif auto_c == "4"

        Proj_Vol.C.val(12) = 43142

    elseif auto_c == "5"

        Proj_Vol.C.val(12) = 35952

    elseif auto_c == "6"

        Proj_Vol.C.val(12) = 28761

    elseif auto_c == "7"

        Proj_Vol.C.val(12) = 21571
    
    elseif auto_c == "8"

        Proj_Vol.C.val(12) = 14380
    
    elseif auto_c == "9"

        Proj_Vol.C.val(12) = 7190

    end
end 

if proj_c == 'true' & Scenario =='AMSrun3' & time_step == 3

    if const_c == "1"

        Proj_Vol.C.val(21) = 16019
    
    elseif const_c == "2"
    
        Proj_Vol.C.val(21) = 14239

    elseif const_c == "3"

        Proj_Vol.C.val(21) = 12459 

    elseif const_c == "4"

        Proj_Vol.C.val(21) = 10679 

    elseif const_c == "5"

        Proj_Vol.C.val(21) = 8900

    elseif const_c == "6"

        Proj_Vol.C.val(21) = 7120 

    elseif const_c == "7"

        Proj_Vol.C.val(21) = 5340  
    
    elseif const_c == "8"

        Proj_Vol.C.val(21) = 13560 
    
    elseif const_c == "9"

        Proj_Vol.C.val(21) = 1780 

    end
end 

//////////////////////////////////////////////// WAGE CURVE  /////////////////////////////////////////////////////////////////////////////////////
parameters.Coef_real_wage = strtod(Coef_real_wage_dashboard);
parameters.sigma_omegaU = strtod(sigma_omegaU_dashboard);

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
//////////////////////// INACTIF ET NON TESTE - BAISSER LA TICPE  /////////////////////////////////////////////////////////////////////////////////////
// REDUCING THE TICPE TAX BY THE PROPORTION OF BIOENERGY - ONLY FOR LIQUID_FUELS
//TOCLEAN
if 0 & ticpe_bioenergy == 'True' then
    bioenergy_proportions_filename = 'bioenergy_proportions_' + Scenario; // Creation of a string like "bioenergy_proportions_AME"
    bioenergy_proportions = evstr(bioenergy_proportions_filename); // Get the value of the var named bioenergy_proportions_AME
    bioenergy_proportion_liquid_fuels = bioenergy_proportions(2,time_step); // Select liquid_fuels' value for time_step

    bioenergy_taxe_rate = 0.33 * Energy_Tax_rate_IC(2); // We suppose bioenergy is 3 times less taxed

    Deriv_Exogenous.Energy_Tax_rate_IC = Energy_Tax_rate_IC;
    Deriv_Exogenous.Energy_Tax_rate_IC(2) = bioenergy_taxe_rate * bioenergy_proportion_liquid_fuels + Energy_Tax_rate_IC(2) * (1-bioenergy_proportion_liquid_fuels); // Weighted calculation
end

//////////////////////////////////////////////// INACTIF - CONTROLE DE LA TICGN (TICPE pour le gaz) /////////////////////////////////////////////////////////////////////////////////////

//////////////////////////////////////////////// PROJECTIONS SELON LES SCENARIOS /////////////////////////////////////////////////////////////////////////////////////

// On ne force jamais les ratio M sur Y industriels dans l AME
if Scenario == 'AME_run3' | Scenario == 'AME_run2'
    Proj_Vol.M_Y.ind_of_proj = list(list(Indice_EnerSect,1));
end

//////////////////////////////////////////////// POUR SIMULATIONS PAS A PAS  /////////////////////////////////////////////////////////////////////////////////////

// TOCLEAN
// Productivite du travail quand Demographic_shift est désactivé : on met les valeurs qui sont normalement calculees dans macro_framework.sce
// Desactiver les projections qui sont toujours mises a %T dans projection_scenario.csv
if proj_alpha == 'false'
    Proj_Vol.alpha.apply_proj = %F;
end 

if proj_c == 'false'
    Proj_Vol.C.apply_proj = %F;
end 

if proj_kappa == 'false' | Proj_scenario == 'SNBC3test_run31' | Proj_scenario == 'SNBC3test_run32' | Proj_scenario == 'SNBC3test_run33' | Proj_scenario == 'SNBC3test_run34' | Proj_scenario == 'SNBC3test_irun31' | Proj_scenario == 'SNBC3test_irun32'| Proj_scenario == 'SNBC3test_irun33' | Proj_scenario == 'SNBC3test_irun34' | Proj_scenario == 'SNBC3test_irun38' | Proj_scenario == 'SNBC3test_irun39' | Proj_scenario == 'SNBC3test_irun310' | Proj_scenario == 'SNBC3test_irun312' | Proj_scenario == 'SNBC3test_irun313' | Proj_scenario == 'SNBC3test_irun314' | Proj_scenario == 'SNBC3test_irun316' | Proj_scenario == 'SNBC3test_irun321' 
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


//////////////////////////////////////////////// IMPORTS EXPORTS DE L'INDUSTRIE : NARRATIF DE REINDUSTRIALISATION  /////////////////////////////////////////////////////////////////////////////////////


if reindustrialisation_imports_bool =='True' & (Scenario == "AMSrun3" | Scenario == "AMScst_run3" | Scenario == "AMS_run2") <> ""
    imports_tendanciels = evstr('reindustrialisation_imports');
    time_since_BY_tmp = Proj_Macro.current_year(time_step) - Proj_Macro.reference_year(1);
    
    for ind = list(Indice_NonMetalsS, Indice_PharmaS, Indice_PaperS)
        parameters.delta_M_parameter(ind) = imports_tendanciels(ind, time_step) ^ (1/time_since_BY_tmp) - 1;
    end
end

if reindustrialisation_exports_bool =='True' & (Scenario == "AMSrun3" | Scenario == "AMScst_run3" | Scenario == "AMS_run2") <> ""
    exports_tendanciels = evstr('reindustrialisation_exports');
    time_since_BY_tmp = Proj_Macro.current_year(time_step) - Proj_Macro.reference_year(1);

    for ind = list(Indice_SteelIronS, Indice_CementS)
        parameters.delta_X_parameter(ind) = (1 + parameters.delta_X_parameter(ind)) * exports_tendanciels(ind, time_step) ^ (1/time_since_BY_tmp) - 1;
    end 
end




//////////////////////////////////////////////// TRANSFERT MA PRIME RENOV  /////////////////////////////////////////////////////////////////////////////////////
MPR_share = 0;
Bonus_vehicules_share = 0;