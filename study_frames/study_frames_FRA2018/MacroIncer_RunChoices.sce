////////////////////////////////////
// Specific to homothetic projection
////////////////////////////////////

// Actualise Emission factors embodied in imported goods
if CO2_footprint == "True" & Scenario <>"" then
	if time_step == 1
		ini.CoefCO2_reg = CoefCO2_reg;
	end
	execstr("Deriv_Exogenous.CoefCO2_reg = CoefCO2_reg_" + time_step + "_" + Macro_nb);
end



////////EXAMPLES

////// To define and select by Dashboard_FRA2018
/////VAR_MU;Mu_low
/////VAR_MU;Mu_high

// VAR_MU="Mu_high";
// Variante on Mu - Productivity
/////For example , range of +/-10%
/////In this case; variation "homothetic" for all sectors (Mu) // (phi_L sectoral changes)
// scal_Mu = 0.1 ;
// if VAR_MU=="Mu_low"
	// parameters.Mu = parameters.Mu.*(1+scal_Mu);
	// parameters.phi_L = parameters.phi_L.*(1+scal_Mu);
// elseif VAR_MU=="Mu_high"
	//parameters.phi_L = parameters.phi_L.*(1-scal_Mu);
	// parameters.Mu = parameters.Mu.*(1+scal_Mu);
// end