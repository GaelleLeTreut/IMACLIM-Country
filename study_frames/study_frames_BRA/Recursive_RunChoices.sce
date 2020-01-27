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



// TO ADAPT : valor tax, scenario name, definition period

Carbon_Tax_rate1 = 19.8e3; // 19reais / tCO2 /// PERIOD ONE
Carbon_Tax_rate2 = 26.4e3; // 26reais / tCO2 /// PERIOD TWO

period_1 = [6,7,8,9,10];
period_2 =[11,12,13,14,15];


if Scenario =="PMR_NAME" & AGG_type== "AGG_PMR19"

	if or(time_step==period_1)
		parameters.Carbon_Tax_rate = Carbon_Tax_rate1;
		CarbonTax_Diff_IC_p1 = [0.9; 0.9; 0.9; 0.9; 0.9; 1;0.9; 1; 0.9; 0.9 ; 0.9 ; 0.9; 0.9; 0.9; 0.9; 0.9; 1; 1; 1 ].*.ones(1,nb_Sectors);
		parameters.CarbonTax_Diff_IC = CarbonTax_Diff_IC_p1 ;
	
		// If exeception
		// parameters.CarbonTax_Diff_IC (:, find(Index_Sectors=="Transp" )) = 0.5 * ones(nb_Sectors,1);
	end
	
	if or(time_step==period_2)
		parameters.Carbon_Tax_rate = Carbon_Tax_rate2;
		CarbonTax_Diff_IC_p2 = [0.95; 0.95; 0.95; 0.95; 0.95; 1;0.95; 1; 0.95; 0.9 ; 0.9 ; 0.9; 0.9; 0.9; 0.9; 0.9; 1; 1; 1 ].*.ones(1,nb_Sectors);
		parameters.CarbonTax_Diff_IC = CarbonTax_Diff_IC_p2 ;
	
	end
	
end 
