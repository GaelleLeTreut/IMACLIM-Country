// ////////////////////////////////////////                                    ////////////////////////////////////////
// ////////////////////////////////////////                                    ////////////////////////////////////////
// ////////////////////////////////////////          Model settings          ////////////////////////////////////////
// ////////////////////////////////////////									////////////////////////////////////////
// ////////////////////////////////////////									////////////////////////////////////////



if  Scenario=='S2test' 

	parameters.efficiency_coeff = efficiency_coeff_file(1,time_step);

	parameters.alpha_share_budget(:) = alpha_share_budget_file(1:2,time_step)';

end


// //////////////////////////////////////////////////// Macroeconomic closure  //////////////////////////////////////////////////////////////////////

// if SystemOpt_Resol == "SystemOpt_johansen_full" 

// 	VAR_saving = "johansen_full";
// 	closure = "johansen";

// elseif SystemOpt_Resol == "SystemOpt_Static" 

// 	closure = "postkeynesian";

// elseif SystemOpt_Resol == "SystemOpt_neoclassical_full" 

// 	closure = "neoclassical";

// end

// // //////////////////////////////////////////////////// Wage curve  //////////////////////////////////////////////////////////////////////

// ////////////////////////////////////////
// // Elasticity
// ////////////////////////////////////////
// if VAR_sigma_omegaU=='ref'

// 	parameters.sigma_omegaU = -0.1;

// elseif VAR_sigma_omegaU=='ademevalue'

// 	parameters.sigma_omegaU = -1.8;

// end

// ////////////////////////////////////////
// // Wage curve real wage coefficient
// ////////////////////////////////////////

// if VAR_coef_real_wage=='ref'

// 	parameters.Coef_real_wage = 1;

// elseif VAR_coef_real_wage=='low'

// 	parameters.Coef_real_wage = 0;

// end

// // //////////////////////////////////////////////////// Households consumption basic need  //////////////////////////////////////////////

// if VAR_C_basic_need == 'ref'

// 	parameters.ConstrainedShare_C = ones(nb_Sectors,nb_Households) * 0.8;

// elseif VAR_C_basic_need == 'low'

// 	parameters.ConstrainedShare_C = zeros(nb_Sectors,nb_Households);

// end

// ////////////////////////////////////////                                    ////////////////////////////////////////
// ////////////////////////////////////////                                    ////////////////////////////////////////
// ////////////////////////////////////////          Policy shocks           ////////////////////////////////////////
// ////////////////////////////////////////									////////////////////////////////////////
// ////////////////////////////////////////									////////////////////////////////////////


if proj_alpha == 'false'

	Proj_Vol.alpha.apply_proj = %F; 	
end 

if proj_c == 'false'

Proj_Vol.C.apply_proj = %F; 

end 

if proj_kappa == 'false'

Proj_Vol.kappa.apply_proj = %F;

end 

parameters.sigma_ConsoBudget(1:18) = -50;


// ////////////////////////////////////////                                    ////////////////////////////////////////
// ////////////////////////////////////////                                    ////////////////////////////////////////
// ////////////////////////////////////////          Context shocks           ////////////////////////////////////////
// ////////////////////////////////////////									////////////////////////////////////////
// ////////////////////////////////////////									////////////////////////////////////////

// ////////////////////////////////////////////// contrôle de pY gaz par rapport à pM gaz /////////////////////////////////////////////////////
// // Baisser le taux de Profit_margin pour avoir un taux proche de celui du pétrole
// if Spe_margs_Profit_margin_gaz_reduced == 'true' then
// 	Deriv_Exogenous.markup_rate = markup_rate;
// 	Deriv_Exogenous.markup_rate(Indice_GasS) = BY.markup_rate(Indice_GasS) / 10;
// // Baisser les taux de marges spécifiques appliqués par les secteurs énergétiques pour leurs ventes au gaz
// 	Deriv_Exogenous.SpeMarg_rates_IC = SpeMarg_rates_IC;
// 	Deriv_Exogenous.SpeMarg_rates_IC(Indice_GasS, Indice_GasS) = -0.87;
// 	Deriv_Exogenous.SpeMarg_rates_IC(Indice_GasS, Indice_CoalS) = -0.87;
// 	Deriv_Exogenous.SpeMarg_rates_IC(Indice_GasS, Indice_ElecS) = -0.87;
// end


//////////////////////////////////////////////////// IMPORTATIONS ///////////////////////////////////////////////////////////////

if VAR_sigma_MX == "ref"

// delta_M forcé pour les carburants liquides et le gaz
parameters.delta_M_parameter(1:2) = delta_M_file(1:2,time_step)';

end

//////////////////////////////////////////////////// EXPORTATIONS ///////////////////////////////////////////////////////////////

if  trade_drive=='exports_detailed' 

	parameters.delta_X_parameter(1:11) = delta_X_file(1:11,time_step)';
	parameters.delta_X_parameter(16) = delta_X_file(16,time_step)';
	parameters.delta_X_parameter(18) = delta_X_file(18,time_step)';

elseif trade_drive=='exports_detailed_low' 

	parameters.delta_X_parameter(1:11) = delta_X_file_low(1:11,time_step)';
	parameters.delta_X_parameter(16) = delta_X_file_low(16,time_step)';
	parameters.delta_X_parameter(18) = delta_X_file_low(18,time_step)';

	if time_step == 1

		parameters.delta_X_parameter(12:15) = 0.008679232 ;
		parameters.delta_X_parameter(17) = 0.008679232 ;
		parameters.delta_X_parameter(19) =  0.008679232 ;

	elseif time_step == 2

		parameters.delta_X_parameter(12:15) = 0.001771701 ;
		parameters.delta_X_parameter(17) = 0.001771701 ;
		parameters.delta_X_parameter(19) =  0.001771701 ;

	end

elseif trade_drive=='exports_detailed_high'

	parameters.delta_X_parameter(1:11) = delta_X_file_high(1:11,time_step)';
	parameters.delta_X_parameter(16) = delta_X_file_high(16,time_step)';
	parameters.delta_X_parameter(18) = delta_X_file_high(18,time_step)';

	if time_step == 1

		parameters.delta_X_parameter(12:15) = 0.0171270873928357;
		parameters.delta_X_parameter(17) = 0.0171270873928357;
		parameters.delta_X_parameter(19) =  0.0171270873928357 ;

	elseif time_step == 2

		parameters.delta_X_parameter(12:15) = 0.02133961;
		parameters.delta_X_parameter(17) = 0.02133961 ;
		parameters.delta_X_parameter(19) =  0.02133961 ;

	end

elseif trade_drive=='neutral'

	parameters.delta_X_parameter(1:19) = 0;

end


//////////////////////////////////////////////// Emissions  /////////////////////////////////////////////////////////////////////////////////////

if Scenario=='S2' |  Scenario=='S3'

	////////////////////////////////////
	// Specific emission factors according to renewable mix
	Deriv_Exogenous.Emission_Coef_C = Emission_Coef_C;
	Deriv_Exogenous.Emission_Coef_IC = Emission_Coef_IC;
	// Gas

	Emission_Coef_C(2,:) = Emis_Coef_Gas(20,time_step);

	Deriv_Exogenous.Emission_Coef_IC(2,1) = Emis_Coef_Gas(1,time_step);
	Deriv_Exogenous.Emission_Coef_IC(2,2) = Emis_Coef_Gas(2,time_step);
	Deriv_Exogenous.Emission_Coef_IC(2,3) = Emis_Coef_Gas(3,time_step);
	Deriv_Exogenous.Emission_Coef_IC(2,4) = Emis_Coef_Gas(4,time_step);
	Deriv_Exogenous.Emission_Coef_IC(2,5) = Emis_Coef_Gas(5,time_step);
	Deriv_Exogenous.Emission_Coef_IC(2,6) = Emis_Coef_Gas(6,time_step);
	Deriv_Exogenous.Emission_Coef_IC(2,7) = Emis_Coef_Gas(7,time_step);
	Deriv_Exogenous.Emission_Coef_IC(2,8) = Emis_Coef_Gas(8,time_step);
	Deriv_Exogenous.Emission_Coef_IC(2,9) = Emis_Coef_Gas(9,time_step);
	Deriv_Exogenous.Emission_Coef_IC(2,10) = Emis_Coef_Gas(10,time_step);
	Deriv_Exogenous.Emission_Coef_IC(2,11) = Emis_Coef_Gas(11,time_step);
	Deriv_Exogenous.Emission_Coef_IC(2,12) = Emis_Coef_Gas(12,time_step);
	Deriv_Exogenous.Emission_Coef_IC(2,13) = Emis_Coef_Gas(13,time_step);
	Deriv_Exogenous.Emission_Coef_IC(2,14) = Emis_Coef_Gas(14,time_step);
	Deriv_Exogenous.Emission_Coef_IC(2,15) = Emis_Coef_Gas(15,time_step);
	Deriv_Exogenous.Emission_Coef_IC(2,16) = Emis_Coef_Gas(16,time_step);
	Deriv_Exogenous.Emission_Coef_IC(2,17) = Emis_Coef_Gas(17,time_step);
	Deriv_Exogenous.Emission_Coef_IC(2,18) = Emis_Coef_Gas(18,time_step);
	Deriv_Exogenous.Emission_Coef_IC(2,19) = Emis_Coef_Gas(19,time_step);


    // Liquid fuels
	// X & C
	Deriv_Exogenous.Emission_Coef_C(1,:) = Emis_Coef_Oil(20,time_step);

	// Autres secteurs
	Deriv_Exogenous.Emission_Coef_IC(1,1) = Emis_Coef_Oil(1,time_step);
	Deriv_Exogenous.Emission_Coef_IC(1,2) = Emis_Coef_Oil(2,time_step);
	Deriv_Exogenous.Emission_Coef_IC(1,3) = Emis_Coef_Oil(3,time_step);
	Deriv_Exogenous.Emission_Coef_IC(1,4) = Emis_Coef_Oil(4,time_step);
	Deriv_Exogenous.Emission_Coef_IC(1,5) = Emis_Coef_Oil(5,time_step);
	Deriv_Exogenous.Emission_Coef_IC(1,6) = Emis_Coef_Oil(6,time_step);
	Deriv_Exogenous.Emission_Coef_IC(1,7) = Emis_Coef_Oil(7,time_step);
	Deriv_Exogenous.Emission_Coef_IC(1,8) = Emis_Coef_Oil(8,time_step);
	Deriv_Exogenous.Emission_Coef_IC(1,9) = Emis_Coef_Oil(9,time_step);
	Deriv_Exogenous.Emission_Coef_IC(1,10) = Emis_Coef_Oil(10,time_step);
	Deriv_Exogenous.Emission_Coef_IC(1,11) = Emis_Coef_Oil(11,time_step);
	// LandTransport, NavalTransport, Airtransport, Agri_forestry_fishing, 
	Deriv_Exogenous.Emission_Coef_IC(1,12) = Emis_Coef_Oil(12,time_step);
	Deriv_Exogenous.Emission_Coef_IC(1,13) = Emis_Coef_Oil(13,time_step);
	Deriv_Exogenous.Emission_Coef_IC(1,14) = Emis_Coef_Oil(14,time_step);
	Deriv_Exogenous.Emission_Coef_IC(1,15) = Emis_Coef_Oil(15,time_step);
	// Other
	Deriv_Exogenous.Emission_Coef_IC(1,16) = Emis_Coef_Oil(16,time_step);
	Deriv_Exogenous.Emission_Coef_IC(1,17) = Emis_Coef_Oil(17,time_step);
	Deriv_Exogenous.Emission_Coef_IC(1,18) = Emis_Coef_Oil(18,time_step);
	Deriv_Exogenous.Emission_Coef_IC(1,19) = Emis_Coef_Oil(19,time_step);

end

////////////////////////////////////////                                     ////////////////////////////////////////
////////////////////////////////////////                                     ////////////////////////////////////////
////////////////////////////////////////          Context uncertainty        ////////////////////////////////////////
////////////////////////////////////////									 ////////////////////////////////////////
////////////////////////////////////////									 ////////////////////////////////////////

////////////////////////////////////////          Saving rate                ////////////////////////////////////////

if  VAR_saving=="low"
	
	Deriv_Exogenous.Household_saving_rate = evstr(0.11);

elseif VAR_saving=="high"

	Deriv_Exogenous.Household_saving_rate = evstr(0.21);

end

///////////////////////////////////////           Population                 /////////////////////////////////////////

if VAR_population =="low"

	if time_step == 1

		Deriv_Exogenous.Population = 68091;
		Deriv_Exogenous.Labour_force = 28851;
		Deriv_Exogenous.Retired = 20885;
	
	elseif time_step == 2

		Deriv_Exogenous.Population = 69624;
		Deriv_Exogenous.Labour_force = 27657;
		Deriv_Exogenous.Retired =  27172;

	end

end

if VAR_population =="ref"

	if time_step == 1

		Deriv_Exogenous.Population = 69161;
		Deriv_Exogenous.Labour_force = 29256;
		Deriv_Exogenous.Retired = 21297;
	
	elseif time_step == 2

		Deriv_Exogenous.Population = 72580;
		Deriv_Exogenous.Labour_force = 28703;
		Deriv_Exogenous.Retired = 28626;

	end

end

if VAR_population =="high"

	if time_step == 1

		Deriv_Exogenous.Population = 71617;
		Deriv_Exogenous.Labour_force = 29979;
		Deriv_Exogenous.Retired = 21932;
	
	elseif time_step == 2

		Deriv_Exogenous.Population = 79658;
		Deriv_Exogenous.Labour_force = 30635;
		Deriv_Exogenous.Retired = 30957;

	end

end

//////////////////////////////////////////////////// Labour productivity  //////////////////////////////////////////////////////////////////////

if VAR_Mu=="ref"
	parameters.Mu = 0.011;
	parameters.phi_L = ones(parameters.phi_L).*parameters.Mu;
elseif VAR_Mu=="low"
	parameters.Mu = 0.009;
	parameters.phi_L = ones(parameters.phi_L).*parameters.Mu;
elseif VAR_Mu=="high"
	parameters.Mu = 0.013
	parameters.phi_L = ones(parameters.phi_L).*parameters.Mu;
elseif VAR_Mu=="neutral"
	parameters.Mu = 0
	parameters.phi_L = ones(parameters.phi_L).*parameters.Mu;
end

// //////////////////////////////////////////////////// Fossil import prices  ///////////////////////////////////////////////////////////

if VAR_import_enersect=="high"

	if time_step == 1

		parameters.delta_pM_parameter(Indice_OilS) = 0.127154385;		
		parameters.delta_pM_parameter(Indice_GasS) = 0.104082573;
		parameters.delta_pM_parameter(Indice_CoalS) = 0.11283111;


	elseif time_step == 2

		parameters.delta_pM_parameter(Indice_OilS) = 0.019529516;
		parameters.delta_pM_parameter(Indice_GasS) = 0.017485127;
		parameters.delta_pM_parameter(Indice_CoalS) = 0.011735716;

	end

elseif VAR_import_enersect=="low"

	if time_step == 1

		parameters.delta_pM_parameter(Indice_OilS) = -0.066891327;
		parameters.delta_pM_parameter(Indice_GasS) = 0.02885052;
		parameters.delta_pM_parameter(Indice_CoalS) = -0.042104935;

	elseif time_step == 2

		parameters.delta_pM_parameter(Indice_OilS) = -0.018687887;
		parameters.delta_pM_parameter(Indice_GasS) = -0.004103463;
		parameters.delta_pM_parameter(Indice_CoalS) = -0.008494988;
	
	end

elseif VAR_import_enersect=="ref"

	if time_step == 1

		parameters.delta_pM_parameter(Indice_OilS) = 0.072668228;
		parameters.delta_pM_parameter(Indice_GasS) = 0.073566267;
		parameters.delta_pM_parameter(Indice_CoalS) = 0.063860125;

	elseif time_step == 2

		parameters.delta_pM_parameter(Indice_OilS) = 0.019529516 ;
		parameters.delta_pM_parameter(Indice_GasS) = 0.017485127;
		parameters.delta_pM_parameter(Indice_CoalS) = 0.011735716;
	
	end

end

// ////////////////////////////////////////                                     ////////////////////////////////////////
// ////////////////////////////////////////                                     ////////////////////////////////////////
// ////////////////////////////////////////          Economy uncertainty        ////////////////////////////////////////
// ////////////////////////////////////////									 ////////////////////////////////////////
// ////////////////////////////////////////									 ////////////////////////////////////////
// end


// //////////////////////////////////////////////////// Import-export price elasticity  //////////////////////////////////////////////////////////////////////

// if VAR_sigma_MX=="ref"
// 	Deriv_Exogenous.sigma_M = [0,0,0,0,1.9,1.9,1.9,1.9,1.9,1.9,1.9,0,0,0,1.9,1.9,0,1.9,1.9];
// elseif  VAR_sigma_MX=="low"
// 	Deriv_Exogenous.sigma_M = [0,0,0,0,1.9,1.9,1.9,1.9,1.9,1.9,1.9,0,0,0,1.9,1.9,0,1.9,1.9];
// 	Deriv_Exogenous.sigma_X = [0,0,0,0,0.1,0.1,0.1,0.1,0.1,0.1,0.1,0,0,0,0.1,0.1,0,0.1,0.1];
// elseif  VAR_sigma_MX=="low_MX"
// 	Deriv_Exogenous.sigma_M = [0,0,0,0,1,1,1,1,1,1,1,0,0,0,1,1,0,1,1];
// 	Deriv_Exogenous.sigma_X = [0,0,0,0,0.1,0.1,0.1,0.1,0.1,0.1,0.1,0,0,0,0.1,0.1,0,0.1,0.1];
// elseif  VAR_sigma_MX=="high"
// 	Deriv_Exogenous.sigma_M = [0,0,0,0,1.9,1.9,1.9,1.9,1.9,1.9,1.9,0,0,0,1.9,1.9,0,1.9,1.9];
// 	Deriv_Exogenous.sigma_X = [0,0,0,0,0.9,0.9,0.9,0.9,0.9,0.9,0.9,0,0,0,0.9,0.9,0,0.9,0.9];
// elseif  VAR_sigma_MX=="high_MX"
// 	Deriv_Exogenous.sigma_M = [0,0,0,0,2.5,2.5,2.5,2.5,2.5,2.5,2.5,0,0,0,2.5,2.5,0,2.5,2.5];
// 	Deriv_Exogenous.sigma_X = [0,0,0,0,0.9,0.9,0.9,0.9,0.9,0.9,0.9,0,0,0,0.9,0.9,0,0.9,0.9];
// end


