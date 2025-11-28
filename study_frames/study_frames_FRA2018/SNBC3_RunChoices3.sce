/////////////////////////////////////////////// TRANSFERT MA PRIME RENOV  /////////////////////////////////////////////////////////////////////////////////////
MPR_share = 0;
Bonus_vehicules_share = 0;

//////////////////////////////////////////////// WAGE CURVE  /////////////////////////////////////////////////////////////////////////////////////
// parameters.Coef_real_wage = strtod(Coef_real_wage_dashboard);
// parameters.sigma_omegaU = strtod(sigma_omegaU_dashboard);


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

if proj_lambda == 'false' 
    Proj_Vol.lambda.apply_proj = %F;
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

//////////////////////////////////////////////// EXPORTATIONS  ///////////////////////////////////////////////////////////////////////////////

if  exports_drive=='true' 

	parameters.delta_X_parameter(1:20) = delta_X_file(1:20,time_step)';
    parameters.delta_X_parameter(22:23) = delta_X_file(22:23,time_step)';

end

if  imports_drive=='true' 

	parameters.delta_M_parameter(1:20) = delta_M_file(1:20,time_step)';
    parameters.delta_M_parameter(22:23) = delta_M_file(22:23,time_step)';

end

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


//////////////////////////////////////////////// Coeff constraint  ///////////////////////////////////////////////////////////////////////////////

if coeff_constraint=="ref"

	Deriv_Exogenous.coeff_constraint = 1.127633389;

elseif coeff_constraint=="1_10"

	Deriv_Exogenous.coeff_constraint = 1.10;

elseif coeff_constraint=="1_08"

	Deriv_Exogenous.coeff_constraint = 1.08;

elseif coeff_constraint=="1_06"

	Deriv_Exogenous.coeff_constraint = 1.06;

elseif coeff_constraint=="1_04"

	Deriv_Exogenous.coeff_constraint = 1.04;

end

//////////////////////////////////////////////////// Import-export price elasticity  //////////////////////////////////////////////////////////////////////

if VAR_sigma_M=="high2"
	Deriv_Exogenous.sigma_M = [0,0,0,0,0,2.85,2.85,2.85,2.85,2.85,2.85,2.85,2.85,2.85,2.85,2.85,0,0,0,2.85,0,2.85,2.85];
elseif VAR_sigma_M=="high1"
	Deriv_Exogenous.sigma_M = [0,0,0,0,0,2.375,2.375,2.375,2.375,2.375,2.375,2.375,2.375,2.375,2.375,2.375,0,0,0,2.375,0,2.375,2.375];
elseif VAR_sigma_M=="ref"
	Deriv_Exogenous.sigma_M = [0,0,0,0,0,1.9,1.9,1.9,1.9,1.9,1.9,1.9,1.9,1.9,1.9,1.9,0,0,0,1.9,0,1.9,1.9];
elseif VAR_sigma_M=="low1"
	Deriv_Exogenous.sigma_M = [0,0,0,0,0,1.425,1.425,1.425,1.425,1.425,1.425,1.425,1.425,1.425,1.425,1.425,0,0,0,1.425,0,1.425,1.425];
elseif VAR_sigma_M=="low2"
    Deriv_Exogenous.sigma_M = [0,0,0,0,0,0.95,0.95,0.95,0.95,0.95,0.95,0.95,0.95,0.95,0.95,0.95,0,0,0,0.95,0,0.95,0.95];
elseif VAR_sigma_M=="old"
    Deriv_Exogenous.sigma_M = [0,0,0,0,0,1.2,1.2,1.2,1.2,1.2,1.2,1.2,1.2,1.2,1.2,1.2,0,0,0,1.2,0,1.2,1.2];
elseif VAR_sigma_M=="gtap"
    Deriv_Exogenous.sigma_M = [0,0,0,0,0,2.95,4.2,2.9,2.9,3.3,2.95,2.8,4.05,4.4,2.0,3.75,0,0,0,2.5,0,1.9,1.9];
elseif VAR_sigma_M=="threeme"
    Deriv_Exogenous.sigma_M = [0,0,0,0,0,0.48,0.48,0.48,0.48,0.48,0.48,0.48,0.48,0.48,0.48,0.48,0,0,0,0.48,0,0.69,0.69];
elseif VAR_sigma_M=="low"
    Deriv_Exogenous.sigma_M = [0,0,0,0,0,0.43,0.43,0.43,0.43,0.43,0.43,0.43,0.43,0.43,0.43,0.43,0,0,0,0.43,0,0.62,0.62];
elseif VAR_sigma_M=="high"
    Deriv_Exogenous.sigma_M = [0,0,0,0,0,0.53,0.53,0.53,0.53,0.53,0.53,0.53,0.53,0.53,0.53,0.53,0,0,0,0.53,0,0.76,0.76];
elseif VAR_sigma_M=="max"
    Deriv_Exogenous.sigma_M = [0,0,0,0,0,0.72,0.72,0.72,0.72,0.72,0.72,0.72,0.72,0.72,0.72,0.72,0,0,0,0.72,0,0.72,0.72];
elseif VAR_sigma_M=="note"
    Deriv_Exogenous.sigma_M = [0,0,0,0,0,0.8,0.8,0.8,0.8,0.8,0.8,0.8,0.8,0.8,0.8,0.8,0,0,0,0.8,0,0.8,0.8];
end

if VAR_sigma_X=="high2"
    Deriv_Exogenous.sigma_X = [0,0,0,0,0,0.63,0.63,0.63,0.63,0.63,0.63,0.63,0.63,0.63,0.63,0.63,0,0,0,0.63,0,0.63,0.63];
elseif VAR_sigma_X=="high1"
    Deriv_Exogenous.sigma_X = [0,0,0,0,0,0.525,0.525,0.525,0.525,0.525,0.525,0.525,0.525,0.525,0.525,0.525,0,0,0,0.525,0,0.525,0.525];;
elseif VAR_sigma_X=="ref"
    Deriv_Exogenous.sigma_X = [0,0,0,0,0,0.42,0.42,0.42,0.42,0.42,0.42,0.42,0.42,0.42,0.42,0.42,0,0,0,0.42,0,0.42,0.42];
elseif VAR_sigma_X=="low1"
    Deriv_Exogenous.sigma_X = [0,0,0,0,0,0.315,0.315,0.315,0.315,0.315,0.315,0.315,0.315,0.315,0.315,0.315,0,0,0,0.315,0,0.315,0.315];;
elseif VAR_sigma_X=="low2"
    Deriv_Exogenous.sigma_X = [0,0,0,0,0,0.21,0.21,0.21,0.21,0.21,0.21,0.21,0.21,0.21,0.21,0.21,0,0,0,0.21,0,0.21,0.21];;
elseif VAR_sigma_X=="minx"
     Deriv_Exogenous.sigma_X = [0,0,0,0,0,0.22,0.22,0.22,0.22,0.22,0.22,0.22,0.22,0.22,0.22,0.22,0,0,0,0.22,0,0.22,0.0];
elseif VAR_sigma_X=="old"
    Deriv_Exogenous.sigma_X = [0,0,0,0,0,0.42,0.42,0.42,0.42,0.42,0.42,0.42,0.42,0.42,0.42,0.42,0,0,0,0.42,0,0.42,0];
elseif VAR_sigma_X=="threeme"
    Deriv_Exogenous.sigma_X = [0,0,0,0,0,0.8,0.8,0.8,0.8,0.8,0.8,0.8,0.8,0.8,0.8,0.8,0,0,0,0.8,0,0.8,0.8];
elseif VAR_sigma_X=="low"
    Deriv_Exogenous.sigma_X = [0,0,0,0,0,0.72,0.72,0.72,0.72,0.72,0.72,0.72,0.72,0.72,0.72,0.72,0,0,0,0.72,0,0.72,0.72];
elseif VAR_sigma_X=="high"
    Deriv_Exogenous.sigma_X = [0,0,0,0,0,0.88,0.88,0.88,0.88,0.88,0.88,0.88,0.88,0.88,0.88,0.88,0,0,0,0.88,0,0.88,0.88];
elseif VAR_sigma_X=="max"
    Deriv_Exogenous.sigma_X = [0,0,0,0,0,1.1,1.1,1.1,1.1,1.1,1.1,1.1,1.1,1.1,1.1,1.1,0,0,0,1.1,0,1.1,1.1];
end

if VAR_sigma_omegaU=="-0.1"
	parameters.sigma_omegaU = -0.1;
elseif VAR_sigma_omegaU=="-0.6"
	parameters.sigma_omegaU = -0.6;
elseif VAR_sigma_omegaU=="-1.2"
	parameters.sigma_omegaU = -1.2;
elseif VAR_sigma_omegaU=="-1.8"
	parameters.sigma_omegaU = -1.8;
elseif VAR_sigma_omegaU=="-2.4"
	parameters.sigma_omegaU = -2.4;
elseif VAR_sigma_omegaU=="-3.0"
	parameters.sigma_omegaU = -3.0;
elseif VAR_sigma_omegaU=="-3.6"
	parameters.sigma_omegaU = -3.6;
elseif VAR_sigma_omegaU=="-0.05"
	parameters.sigma_omegaU = -0.05;
elseif VAR_sigma_omegaU=="-0.5"
	parameters.sigma_omegaU = -0.5;
elseif VAR_sigma_omegaU=="-1.0"
	parameters.sigma_omegaU = -1.0;
end

if Coef_real_wage=="1"
	parameters.Coef_real_wage = 1;
elseif Coef_real_wage=="0.5"
    parameters.Coef_real_wage = 0.5;
elseif Coef_real_wage=="0"
    parameters.Coef_real_wage = 0;
end
