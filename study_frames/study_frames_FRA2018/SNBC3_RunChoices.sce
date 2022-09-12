// update carbon tax rate
// parameters.Carbon_Tax_rate = 110000;

// Basic Need  in ktep/UC
BasicNeed = zeros(nb_Sectors,1);
// Put in sectoral parameters 
BasicNeed_HH = (BasicNeed .*.ones(1,nb_Households));

// Data for Households are in thousand of people
Coef_HH_unitpeople = 10^3;

// sensitivity analysis 
parameters.sigma_X = parameters.sigma_X * (1+strtod(Trade_elast_var));
parameters.sigma_M = parameters.sigma_M * (1+strtod(Trade_elast_var));

// EMISSIONS
// pause
// parts_bioenergies_2030 = [0 ;0.0601127103850908;0.0187062249657335;0.802228045203052;0.0847093067810176];
// Deriv_Exogenous.Emission_Coef_C(Indice_EnerSect, :) = Deriv_Exogenous.Emission_Coef_C(Indice_EnerSect, :) .* parts_bioenergies_2030;



// if Scenario=='S2' |  Scenario=='S3'
//     // Specific emission factors according to renewable mix
//     Deriv_Exogenous.Emission_Coef_C = Emission_Coef_C;
//     Deriv_Exogenous.Emission_Coef_IC = Emission_Coef_IC;
//     // Gas
//     Deriv_Exogenous.Emission_Coef_C(Indice_Natural_gas,:) = Emis_Coef_Gas(time_step);
//     Deriv_Exogenous.Emission_Coef_IC(Indice_Natural_gas,:) = Emis_Coef_Gas(time_step);
//     // Liquid fuels
//     // X & C
//     Deriv_Exogenous.Emission_Coef_C(1,1) = Emis_Coef_Oil(20,time_step);
//     Deriv_Exogenous.Emission_Coef_X(1,1) = Emis_Coef_Oil(21,time_step);
//     // LandTransport, NavalTransport, Airtransport, Agri_forestry_fishing, 
//     Deriv_Exogenous.Emission_Coef_IC(1,12) = Emis_Coef_Oil(12,time_step);
//     Deriv_Exogenous.Emission_Coef_IC(1,13) = Emis_Coef_Oil(13,time_step);
//     Deriv_Exogenous.Emission_Coef_IC(1,14) = Emis_Coef_Oil(14,time_step);
//     Deriv_Exogenous.Emission_Coef_IC(1,15) = Emis_Coef_Oil(15,time_step);
// end

