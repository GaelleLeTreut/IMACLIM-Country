// Shocking some parameters default values

Carbon_Tax_rate0 = 1e5; // 100reais / tCO2 
Carbon_Tax_rate1 = 2e5;
Carbon_Tax_rate2 = 3e5;
Carbon_Tax_rate3 = 5e5;


/// Info  reduction goal
if time_step == 1 
parameters.Carbon_Tax_rate = Carbon_Tax_rate1;
// goal_reduc_IC = 0.05 * ones(nb_Sectors,nb_Sectors);
// goal_reduc_C = 0.05 * ones(nb_Sectors, nb_Households);

// Calcul indirect IC / direct C
////  Carbon cap to be informed as a reduction cap (0.2 for 20% of reduction)
// parameters.CarbonCap = 0.2 ;
// parameters.CarbonCap_IC = parameters.CarbonCap.* ones(nb_Sectors,nb_Sectors);
// CO2Emis_IC = (1-parameters.CarbonCap_IC).*BY.CO2Emis_IC;
// parameters.CarbonCap_C = parameters.CarbonCap.* ones(nb_Sectors,nb_Households);
// CO2Emis_C = (1-parameters.CarbonCap_C).*BY.CO2Emis_C;

end 


if time_step == 2 
parameters.Carbon_Tax_rate = Carbon_Tax_rate1;
// goal_reduc_IC = 0.15 * ones(nb_Sectors,nb_Sectors);
// goal_reduc_C = 0.15 * ones(nb_Sectors, nb_Households);

// Calcul indirect IC / direct C
////  Carbon cap to be informed as a reduction cap (0.2 for 20% of reduction)
// parameters.CarbonCap = 0.1 ;
// parameters.CarbonCap_IC = parameters.CarbonCap.* ones(nb_Sectors,nb_Sectors);
// CO2Emis_IC = (1-parameters.CarbonCap_IC).*BY.CO2Emis_IC;
// parameters.CarbonCap_C = parameters.CarbonCap.* ones(nb_Sectors,nb_Households);
// CO2Emis_C = (1-parameters.CarbonCap_C).*BY.CO2Emis_C;

end 

// u_param a clarifier
parameters.u_param = BY.u_tot;



