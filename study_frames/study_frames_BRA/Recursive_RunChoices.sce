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

period_0 = [1,2,3,4,5];
period_1 = [6,7,8,9,10];
period_2 =[11,12,13,14,15];

////////////////////////////////////
///// Modification of Household saving rate 
////////////////////////////////////
// Exogenous info
Table_Hsav_rate = ["Saving_rate",2015,2016,2017,2018,2019,2020,2021,2022,2023,2024,2025,2026,2027,2028,2029,2030;
"HH1",-0.566,-0.528266667,-0.490533333,-0.4528,-0.415066667,-0.377333333,-0.3396,-0.301866667,-0.264133333,-0.2264,-0.188666667,-0.150933333,-0.1132,-0.075466667,-0.037733333,0
"HH2",-0.102,-0.088533333,-0.075066667,-0.0616,-0.048133333,-0.034666667,-0.0212,-0.007733333,0.005733333,0.0192,0.032666667,0.046133333,0.0596,0.073066667,0.086533333,0.1
"HH3",0.064,0.073066667,0.082133333,0.0912,0.100266667,0.109333333,0.1184,0.127466667,0.136533333,0.1456,0.154666667,0.163733333,0.1728,0.181866667,0.190933333,0.2
"HH4",0.324,0.324,0.324,0.324,0.324,0.324,0.324,0.324,0.324,0.324,0.324,0.324,0.324,0.324,0.324,0.324];


if H_DISAGG=="H4"
Household_saving_rate = eval(Table_Hsav_rate(2:$,time_step+2)');
end

////////////////////////////////////
///// Capital_consumption or Kappa never informed in first period
////////////////////////////////////

if Proj_Vol.Capital_consumption.apply_proj & ~Proj_Vol.Capital_consumption.intens

	if or(time_step==period_0)
		Proj_Vol.Capital_consumption.apply_proj = %F;
	elseif or(time_step<>period_0)
		Proj_Vol.Capital_consumption.apply_proj = %T; 
	end
end 

if ( find("kappa"==fieldnames(Proj_Vol))<> [] ) & Proj_Vol.kappa.intens
if or(time_step==period_0)
		Proj_Vol.kappa.apply_proj = %F;
	elseif or(time_step<>period_0)
		Proj_Vol.kappa.apply_proj = %T; 
	end
end 


////////////////////////////////////
//// CARBON TAX AND EXEMPTIONS 
////////////////////////////////////

/////
// Carbon tax rate
/////
Scen_WithTax = ["PMR_CP1","PMR_CP2","PMR_CP3","PMR_CP4","PMR_CP5","PMR_CP6"];

Carbon_Tax_rate1 = 19.8e3; // 19reais / tCO2 /// PERIOD ONE
Carbon_Tax_rate2 = 26.4e3; // 26reais / tCO2 /// PERIOD TWO

if or(Scenario==Scen_WithTax) & AGG_type== "AGG_PMR19"
	if or(time_step==period_1)
		parameters.Carbon_Tax_rate = Carbon_Tax_rate1;
	end
		
	if or(time_step==period_2)
		parameters.Carbon_Tax_rate = Carbon_Tax_rate2;
	end
end

/////
// Exemptions
/////
if (Scenario =="PMR_CP1"|Scenario =="PMR_CP2") & AGG_type== "AGG_PMR19"
	if or(time_step==period_1)
		CarbonTax_Diff_IC_p1 = [0.40,0.40,0.40,0.40,0.40,0.50,0.40,0.50,0.40,0.50,0.40,0.40,0.40,0.40,0.40,0.40,0.40,0.50,0.50].*.ones(nb_Sectors,1);
		parameters.CarbonTax_Diff_IC = CarbonTax_Diff_IC_p1 ;
	end
	if or(time_step==period_2)
		CarbonTax_Diff_IC_p2 = [0.90,0.90,0.90,0.90,0.90,1.00,0.95,1.00,0.90,1.00,0.90,0.90,0.90,0.90,0.90,0.90,0.90,1.00,1.00].*.ones(nb_Sectors,1);
		parameters.CarbonTax_Diff_IC = CarbonTax_Diff_IC_p2 ;
	end

elseif Scenario =="PMR_CP3" & AGG_type== "AGG_PMR19"
	if or(time_step==period_1)
		CarbonTax_Diff_IC_p1 = [0.50,0.50,0.50,0.50,0.50,0.50,0.50,0.50,0.50,0.50,0.50,0.50,0.50,0.50,0.50,0.50,0.50,0.50,0.50].*.ones(nb_Sectors,1);
		parameters.CarbonTax_Diff_IC = CarbonTax_Diff_IC_p1 ;
	end
	if or(time_step==period_2)
		CarbonTax_Diff_IC_p2 = [1.00,1.00,1.00,1.00,1.00,1.00,1.00,1.00,1.00,1.00,1.00,1.00,1.00,1.00,1.00,1.00,1.00,1.00,1.00].*.ones(nb_Sectors,1);
		parameters.CarbonTax_Diff_IC = CarbonTax_Diff_IC_p2 ;
	end

elseif Scenario =="PMR_CP4" & AGG_type== "AGG_PMR19"
	if or(time_step==period_1)
		CarbonTax_Diff_IC_p1 = [0.40,0.40,0.40,0.40,0.40,0.50,0.40,0.50,0.40,0.50,0.40,0.40,0.40,0.40,0.40,0.40,0.40,0.50,0.50].*.ones(nb_Sectors,1);
		parameters.CarbonTax_Diff_IC = CarbonTax_Diff_IC_p1 ;
	end
	if or(time_step==period_2)
		CarbonTax_Diff_IC_p2 = [0.90,0.90,0.90,0.90,0.90,1.00,0.95,1.00,0.90,1.00,0.90,0.90,0.90,0.90,0.90,0.90,0.90,1.00,1.00].*.ones(nb_Sectors,1);
		parameters.CarbonTax_Diff_IC = CarbonTax_Diff_IC_p2 ;
	end

elseif Scenario =="PMR_CP5" & AGG_type== "AGG_PMR19"
	if or(time_step==period_1)
		CarbonTax_Diff_IC_p1 = [0.40,0.30,0.37,0.40,0,0.50,0.40,0.50,0.40,0.50,0.40,0.40,0.40,0.40,0.40,0.40,0.40,0.50,0.50].*.ones(nb_Sectors,1);
		parameters.CarbonTax_Diff_IC = CarbonTax_Diff_IC_p1 ;
	end
	if or(time_step==period_2)
		CarbonTax_Diff_IC_p2 = [0.90,0.70,0.82,0.90,0,1.00,0.95,1.00,0.90,1.00,0.90,0.90,0.90,0.90,0.90,0.90,0.90,1.00,1.00].*.ones(nb_Sectors,1);
		parameters.CarbonTax_Diff_IC = CarbonTax_Diff_IC_p2 ;
	end

elseif Scenario =="PMR_CP6" & AGG_type== "AGG_PMR19"
	if or(time_step==period_1)
		CarbonTax_Diff_IC_p1 = [0.40,0.40,0.40,0.40,0.40,0.50,0.40,0.50,0.40,0.50,0.40,0.40,0.40,0.40,0.40,0.40,0.40,0.50,0.50].*.ones(nb_Sectors,1);
		parameters.CarbonTax_Diff_IC = CarbonTax_Diff_IC_p1 ;
	end
	if or(time_step==period_2)
		CarbonTax_Diff_IC_p2 = [0.90,0.90,0.90,0.90,0.90,1.00,0.95,1.00,0.90,1.00,0.90,0.90,0.90,0.90,0.90,0.90,0.90,1.00,1.00].*.ones(nb_Sectors,1);
		parameters.CarbonTax_Diff_IC = CarbonTax_Diff_IC_p2 ;
	end
	
end 

// LUMP SUM TARGETED for only HH class
if  Scenario =="PMR_CP2" & AGG_type== "AGG_PMR19"
	// Artefact to get LumSum only for 1 households class
	Consumption_Units = [1, 0, 0, 0 ];
end





