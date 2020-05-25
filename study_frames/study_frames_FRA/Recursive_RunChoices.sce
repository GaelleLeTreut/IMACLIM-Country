// Actualise Emission factors embodied in imported goods
if CO2_footprint == "True" & Scenario <>"" then
	if time_step == 1
		ini.CoefCO2_reg = CoefCO2_reg;
	end
	execstr("Deriv_Exogenous.CoefCO2_reg = CoefCO2_reg_" + time_step + "_" + Macro_nb);
end

// Missing Index and Indice after aggregation processes 
// Index_Gaz = find(Index_Sectors=="Natural_gas");
// Index_Carb = [find(Index_Sectors=="AllFuels")];

// Manual correction of macroframework 
// %%%% NB: It will be possible to differenciate between crisis and non-crisis scenario
select time_step 
case 1 then
	parameters.Mu = 0.0135;
	parameters.u_param = 0.165;
case 2 then
	parameters.Mu = 0.016;
	parameters.u_param = 0.165;
end
parameters.phi_L = ones(parameters.phi_L) * parameters.Mu;

// Penetration rate of biofuels (1) and biogaz (2) regarding conventional sectors
// select Scenario
// case "AME"
// 	penetration_rate = zeros(1, 2);
// case "AMS"
// 	select time_step 
// 	case 1 then
// 		penetration_rate = [0.18, 0.054];
// 		// fuels : 7% en 2010 et on passe à 12% : 0.054 de réduction du contenu carbone
// 		// to check again  
// 	case 2 then
// 		penetration_rate = ones(1, 2);
// 	end
// end



// Carbon and energy taxes + Emission coefficients
// select Scenario 
// case "AME"
// 	parameters.Carbon_Tax_rate = 100*1e3;
// 	// UE-ETS evolution 
// 	select time_step 
// 	case 1 then
// 		parameters.CarbonTax_Diff_IC = parameters.CarbonTax_Diff_IC;		// do nothing: already in csv param file
// 	case 2 then
// 		parameters.CarbonTax_Diff_IC = (parameters.CarbonTax_Diff_IC==0.335)*0.88 + (parameters.CarbonTax_Diff_IC<>0.335).*parameters.CarbonTax_Diff_IC;
// 	end
// case "AMS"
// 	// assumption: catching-up of EU-ETS and domestic carbon tax
// 	parameters.CarbonTax_Diff_IC = ones(CarbonTax_Diff_IC);
// 	parameters.CarbonTax_Diff_IC = ones(CarbonTax_Diff_IC);
// 	// update of emission coefficients due to bio penetration 
// 	Deriv_Exogenous.Emission_Coef_C(Index_Gaz,:) = (1-penetration_rate(1))*Emission_Coef_C(Index_Gaz,:);
// 	Deriv_Exogenous.Emission_Coef_IC(Index_Gaz,:) = (1-penetration_rate(1))*Emission_Coef_IC(Index_Gaz,:);
// 	Deriv_Exogenous.Emission_Coef_C(Index_Carb,:) = (1-penetration_rate(2))*Emission_Coef_C(Index_Carb,:);
// 	Deriv_Exogenous.Emission_Coef_IC(Index_Carb,:) = (1-penetration_rate(2))*Emission_Coef_IC(Index_Carb,:);
// 	select time_step
// 	case 1 then
// 		parameters.Carbon_Tax_rate = 225*1e3;
// 	case 2 then
// 		parameters.Carbon_Tax_rate = 600*1e3;
// 		// additional energy tax: price signal for biomass scarcity
// 		Energy_Tax_rate_sup = 232.6;
// 		Energy_Tax_rate_sup_IC = zeros(BY.Energy_Tax_rate_IC);
// 		Energy_Tax_rate_sup_IC(Indice_EnerSect) = Energy_Tax_rate_sup;
// 		Deriv_Exogenous.Energy_Tax_rate_IC = BY.Energy_Tax_rate_IC + Energy_Tax_rate_sup_IC;
// 		Energy_Tax_rate_sup_FC = zeros(BY.Energy_Tax_rate_FC);
// 		Energy_Tax_rate_sup_FC(Indice_EnerSect) = Energy_Tax_rate_sup;
// 		Deriv_Exogenous.Energy_Tax_rate_FC = BY.Energy_Tax_rate_FC + Energy_Tax_rate_sup_FC;
// 	end
// end

// capital and labour intensities of production 
// select Scenario
// case "AME"
// 	select time_step 
// 	case 1 then
// 		parameters.phi_K =[0	-0.1550108	0	0	-0.0124576	0.0066989	-0.0088444	-0.0062498	-0.0057102	-0.0034528	-0.0080829	-0.0168043	0	-0.0208056	-0.0159105];
// 		parameters.phi_L =[0.0135	-0.1436035	0.0135	0.0135	0.0135	0.0135	0.0135	0.0135	0.0135	0.0135	0.0135	0.0135	0.0143043	0.0135	0.0135];
// 	case 2 then
// 		parameters.phi_K =[0	-0.0796872	0	0	-0.0173205	0.0248238	-0.0064919	-0.0029835	-0.0026108	-0.0006726	-0.0097622	-0.0174599	0	-0.014198	-0.0106965];
// 		parameters.phi_L =[0.016	-0.0649622	0.016	0.016	0.016	0.016	0.016	0.016	0.016	0.016	0.016	0.016	0.0172445	0.016	0.016];
// 	end
// case "AMS"
// 	select time_step 
// 	case 1 then
// 		parameters.phi_K =[0	0.0662911	0	-0.0855834	-0.0186164	-0.0587296	-0.0120686	-0.0072547	-0.0066602	-0.0030313	-0.0116768	-0.0296089	0	-0.0215932	-0.0177525];
// 		parameters.phi_L =[0.0135	0.10112	0.0135	-0.0004573	0.0135	0.0135	0.0135	0.0135	0.0135	0.0135	0.0135	0.0135	0.0128728	0.0135	0.0135];
// 	case 2 then
// 		parameters.phi_K =[0	0.0690707	0	-0.0868102	-0.0229234	-0.0411437	-0.0125368	-0.0045674	-0.0041246	-0.0019489	-0.0145488	-0.0296514	0	-0.0165052	-0.0135263];
// 		parameters.phi_L =[0.016	0.0922118	0.016	-0.015186	0.016	0.016	0.016	0.016	0.016	0.016	0.016	0.016	0.0121447	0.016	0.016];
// 	end
// end



// specific to gaz and fuels 




// select Scenario
// case "AME"
// 	select time_step 
// 	case 1 then
// 	case 2 then
// 	end
// case "AMS"
// 	select time_step 
// 	case 1 then
// 	case 2 then
// 	end
// end

	