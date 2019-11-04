// Shocking some parameters default values
// pesos per tCO2
Carbon_Tax_rate0 = 40;
Carbon_Tax_rate1 = 1e5;
Carbon_Tax_rate2 = 3e5;
Carbon_Tax_rate3 = 5e5;

parameters.Carbon_Tax_rate = Carbon_Tax_rate0;


// Specific Emis COef for gas under CCS scenario 
if [Scenario=='CCS'| Scenario=='CCS_EnNDC'] & AGG_type==""
	Deriv_Exogenous.Emission_Coef_IC =  ini.Emission_Coef_IC;
	Deriv_Exogenous.Emission_Coef_IC(Indice_Gas,Indice_Elec) =  Emis_Coef_Gas_Elec(time_step);
end

// parameters.CarbonCap = 0.05 ;
// parameters.CarbonCap_IC = parameters.CarbonCap.* ones(nb_Sectors,nb_Sectors);
// CO2Emis_IC = (1-parameters.CarbonCap_IC).*BY.CO2Emis_IC;
// parameters.CarbonCap_C = parameters.CarbonCap.* ones(nb_Sectors,nb_Households);
// CO2Emis_C = (1-parameters.CarbonCap_C).*BY.CO2Emis_C;

goal_reduc_IC = 0.01 * ones(nb_Sectors,nb_Sectors);
goal_reduc_C = 0.01 * ones(nb_Sectors, nb_Households);

if part(Scenario,1:length("EmisObj"))=="EmisObj"
	if is_projected('CO2Emis_C')
	CO2Emis_C = Proj_Vol.CO2Emis_C.val;
	end 
	
	if is_projected('CO2Emis_IC')
	CO2Emis_IC = Proj_Vol.CO2Emis_IC.val;
	end
// GOal reduction /BY
// goal_reduc_IC = divide(Proj_Vol.CO2Emis_IC.val - BY.CO2Emis_IC,BY.CO2Emis_IC,0);
// goal_reduc_C = divide(Proj_Vol.CO2Emis_C.val - BY.CO2Emis_C,BY.CO2Emis_C,0);

end
	
// Deriv_Exogenous.ConstrainedShare_C(Indice_EnerSect, :) = 0;
// Deriv_Exogenous.ConstrainedShare_C(Indice_EnerSect, :) = parameters.ConstrainedShare_C(Indice_EnerSect, :)./2;
// Deriv_Exogenous.sigma_pC = parameters.sigma_pC.*3;
// Deriv_Exogenous.sigma_ConsoBudget = 0;
// Deriv_Exogenous.pC = pC *1.2;
// Deriv_Exogenous.sigma_X = parameters.sigma_X/4;
// Deriv_Exogenous.sigma_M = parameters.sigma_M/4;

