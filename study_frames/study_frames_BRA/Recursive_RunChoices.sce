////////////////////////////////////
// Specific to homothetic projection
////////////////////////////////////
if [System_Resol=="Systeme_ProjHomot_BRA"]
	parameters.sigma_pC = ones(parameters.sigma_pC);
	parameters.sigma_ConsoBudget = ones(parameters.sigma_ConsoBudget);
	parameters.ConstrainedShare_C = zeros(parameters.ConstrainedShare_C);
	parameters.sigma_M = ones(parameters.sigma_M);
	parameters.sigma_X = ones(parameters.sigma_X);
	parameters.CarbonTax_Diff_IC = ones(CarbonTax_Diff_IC);
	parameters.CarbonTax_Diff_IC = ones(CarbonTax_Diff_IC);
	parameters.Carbon_Tax_rate = 0.0;
	parameters.u_param = BY.u_tot;
end

// Actualise Emission factors embodied in imported goods
if CO2_footprint == "True" & Scenario <>"" then
	if time_step == 1
		ini.CoefCO2_reg = CoefCO2_reg;
	end
	execstr("Deriv_Exogenous.CoefCO2_reg = CoefCO2_reg_" + time_step + "_" + Macro_nb);
end
