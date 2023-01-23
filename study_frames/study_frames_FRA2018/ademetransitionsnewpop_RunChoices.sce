//////////////////////////////////////////////////// HYPOTHESES SCENARIOS ///////////////////////////////////////////////////////////////

// delta_M forcé pour les carburants liquides et le gaz
parameters.delta_M_parameter(1:2) = delta_M_file(1:2,time_step)';

if  trade_drive=='ref' 

	parameters.delta_X_parameter = delta_X_file(1:19,time_step)';
//    parameters.delta_M_parameter = delta_M_file(1:19,time_step)';

elseif trade_drive=='exports_only' 

	parameters.delta_X_parameter = delta_X_file(1:19,time_step)';

elseif trade_drive=='exports_detailed' 

	parameters.delta_X_parameter(1:11) = delta_X_file(1:11,time_step)';
	parameters.delta_X_parameter(16) = delta_X_file(16,time_step)';
	parameters.delta_X_parameter(18) = delta_X_file(18,time_step)';

elseif trade_drive=='exports_detailed_low' 

	parameters.delta_X_parameter(1:11) = delta_X_file_low(1:11,time_step)';
	parameters.delta_X_parameter(16) = delta_X_file_low(16,time_step)';
	parameters.delta_X_parameter(18) = delta_X_file_low(18,time_step)';

	parameters.delta_X_parameter(12:15) = 0.001771701 ;
	parameters.delta_X_parameter(17) = 0.001771701 ;
	parameters.delta_X_parameter(19) =  0.001771701 ;

elseif trade_drive=='exports_detailed_high'

	parameters.delta_X_parameter(1:11) = delta_X_file_high(1:11,time_step)';
	parameters.delta_X_parameter(16) = delta_X_file_high(16,time_step)';
	parameters.delta_X_parameter(18) = delta_X_file_high(18,time_step)';

	parameters.delta_X_parameter(12:15) = 0.02133961;
	parameters.delta_X_parameter(17) = 0.02133961 ;
	parameters.delta_X_parameter(19) =  0.02133961 ;

elseif trade_drive=='test' 

	parameters.delta_X_parameter(1:2) = delta_X_file(1:2,time_step)';
	parameters.delta_X_parameter(5:19) = 0;


end

//////////////////////////////////////////////////// INCERTITUDES //////////////////////////////////////////////////////////////////////

////////////////////////////////////////
// Modification of C basic need
///////////////////////////////////////

if VAR_C_basic_need == 'ref'

	parameters.ConstrainedShare_C = ones(nb_Sectors,nb_Households) * 0.8;

elseif VAR_C_basic_need == 'low'

	parameters.ConstrainedShare_C = zeros(nb_Sectors,nb_Households);

end

////////////////////////////////////////
// Modification of sigma wage curve
////////////////////////////////////////

if VAR_sigma_omegaU=='ref'

	parameters.sigma_omegaU = -0.1;

elseif VAR_sigma_omegaU=='ademevalue'

	parameters.sigma_omegaU = -1.8;

end


////////////////////////////////////////
// Modification of real wage coefficient
////////////////////////////////////////

if VAR_coef_real_wage=='ref'

	parameters.Coef_real_wage = 1;

elseif VAR_coef_real_wage=='low'

	parameters.Coef_real_wage = 0;

end

////////////////////////////////////////
// Modification of Household saving rate 
////////////////////////////////////////

if SystemOpt_Resol == "SystemOpt_johansen_full" 

	VAR_saving = "johansen_full";

elseif SystemOpt_Resol == "SystemOpt_johansen_half" 

	VAR_saving = "johansen_half";

end

if  VAR_saving=="low"
	
	Deriv_Exogenous.Household_saving_rate = evstr(0.11);

elseif  VAR_saving=="ref"
	
	Deriv_Exogenous.Household_saving_rate = evstr(0.14);

elseif VAR_saving=="high"

	Deriv_Exogenous.Household_saving_rate = evstr(0.21);

end

////////////////////////////////////////
// Modification of Labour productivity 
////////////////////////////////////////
if VAR_Mu=="ref"
	parameters.Mu = 0.011;
	parameters.phi_L = ones(parameters.phi_L).*parameters.Mu;
elseif VAR_Mu=="low"
	parameters.Mu = 0.009;
	parameters.phi_L = ones(parameters.phi_L).*parameters.Mu;
elseif VAR_Mu=="high"
	parameters.Mu = 0.013
	parameters.phi_L = ones(parameters.phi_L).*parameters.Mu;
end

////////////////////////////////////////
// Modification of imports - exports price elasticity
////////////////////////////////////////

if VAR_sigma_MX=="ref"
	Deriv_Exogenous.sigma_M = [0,0,0,0,1.9,1.9,1.9,1.9,1.9,1.9,1.9,0,0,0,1.9,1.9,0,1.9,1.9];
elseif  VAR_sigma_MX=="low"
	Deriv_Exogenous.sigma_M = [0,0,0,0,1.9,1.9,1.9,1.9,1.9,1.9,1.9,0,0,0,1.9,1.9,0,1.9,1.9];
	Deriv_Exogenous.sigma_X = [0,0,0,0,0.1,0.1,0.1,0.1,0.1,0.1,0.1,0,0,0,0.1,0.1,0,0.1,0.1];
elseif  VAR_sigma_MX=="low_MX"
	Deriv_Exogenous.sigma_M = [0,0,0,0,1,1,1,1,1,1,1,0,0,0,1,1,0,1,1];
	Deriv_Exogenous.sigma_X = [0,0,0,0,0.1,0.1,0.1,0.1,0.1,0.1,0.1,0,0,0,0.1,0.1,0,0.1,0.1];
elseif  VAR_sigma_MX=="high"
	Deriv_Exogenous.sigma_M = [0,0,0,0,1.9,1.9,1.9,1.9,1.9,1.9,1.9,0,0,0,1.9,1.9,0,1.9,1.9];
	Deriv_Exogenous.sigma_X = [0,0,0,0,0.9,0.9,0.9,0.9,0.9,0.9,0.9,0,0,0,0.9,0.9,0,0.9,0.9];
elseif  VAR_sigma_MX=="high_MX"
	Deriv_Exogenous.sigma_M = [0,0,0,0,2.5,2.5,2.5,2.5,2.5,2.5,2.5,0,0,0,2.5,2.5,0,2.5,2.5];
	Deriv_Exogenous.sigma_X = [0,0,0,0,0.9,0.9,0.9,0.9,0.9,0.9,0.9,0,0,0,0.9,0.9,0,0.9,0.9];
end

////////////////////////////////////////
// Modification of CES production function elasticity
////////////////////////////////////////

if VAR_sigma=="high"
	Deriv_Exogenous.sigma = [1.2,1.2,1.2,1.2,1.2,1.2,1.2,1.2,1.2,1.2,1.2,1.2,1.2,1.2,1.2,1.2,0,1.2,1.2];
end

////////////////////////////////////////
// Modification of delta_pM 
////////////////////////////////////////

if VAR_delta_pM=="high"
	Deriv_Exogenous.delta_pM_parameter = [0,0,0,0,0.02,0.02,0.02,0.02,0.02,0.02,0.02,0.02,0.02,0.02,0.02,0.02,0.02,0.02,0];
end

////////////////////////////////////////
// Modification of consumption income elasticity
////////////////////////////////////////

if VAR_sigma_ConsoBudget=="low"
	parameters.sigma_ConsoBudget(5:19) = 0.2;
end

if Scenario=='S2' |  Scenario=='S2test'
	parameters.sigma_ConsoBudget(1:4) = 0;
	parameters.sigma_ConsoBudget(9:18) = 0;
end

////////////////////////////////////////
// Modification of consumption price elasticity
////////////////////////////////////////

if VAR_sigma_pC=="low"
	parameters.sigma_pC(5:19) = -0.06;
end

////////////////////////////////////////
// Modification of import prices
////////////////////////////////////////

if VAR_import_enersect=="high"

	if time_step == 1

		parameters.delta_pM_parameter(Indice_OilS) = 0.115332476;		
		parameters.delta_pM_parameter(Indice_GasS) = 0.080337383;
		parameters.delta_pM_parameter(Indice_CoalS) = 0.104889472;

//		markup_rate(1) = 0.5;
//		markup_rate(2) = 0.5;
//		markup_rate(3) = 0.0073918;
//		markup_rate(4) = 0.5;

	elseif time_step == 2

		parameters.delta_pM_parameter(Indice_OilS) = 0.025999708;
		parameters.delta_pM_parameter(Indice_GasS) = 0.030844979;
		parameters.delta_pM_parameter(Indice_CoalS) = 0.016092709;

	end

elseif VAR_import_enersect=="low"

	if time_step == 1

		parameters.delta_pM_parameter(Indice_OilS) = -0.005541574;
		parameters.delta_pM_parameter(Indice_GasS) = 0.066290058;
		parameters.delta_pM_parameter(Indice_CoalS) = -0.009309006;

	elseif time_step == 2

		parameters.delta_pM_parameter(Indice_OilS) = -0.018687887;
		parameters.delta_pM_parameter(Indice_GasS) = -0.004103463;
		parameters.delta_pM_parameter(Indice_CoalS) = -0.008494988;
	
	end

end

////////////////////////////////// Population ///////////////////////////////////////////////////////

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

// if VAR_S2 =="true"

// 		C(1:nb_Sectors, :) = C_per_capita_file(1:19,time_step) * Deriv_Exogenous.Population ;

// end

//////////////////////////////////////////////// EMISSIONS /////////////////////////////////////////////////////////////////////////////////////

if Scenario=='S2' |  Scenario=='S3'

	////////////////////////////////////
	// Specific emission factors according to renewable mix
	Deriv_Exogenous.Emission_Coef_C = Emission_Coef_C;
	Deriv_Exogenous.Emission_Coef_IC = Emission_Coef_IC;
	// Gas
	Deriv_Exogenous.Emission_Coef_C(Indice_Gas_heating,:) = Emis_Coef_Gas(time_step);
	Deriv_Exogenous.Emission_Coef_IC(Indice_Gas_heating,:) = Emis_Coef_Gas(time_step);

    // Liquid fuels
	// X & C
	Deriv_Exogenous.Emission_Coef_C(1,1) = Emis_Coef_Oil(20,time_step);
	Deriv_Exogenous.Emission_Coef_X(1,1) = Emis_Coef_Oil(21,time_step);

	// LandTransport, NavalTransport, Airtransport, Agri_forestry_fishing, 
	Deriv_Exogenous.Emission_Coef_IC(1,12) = Emis_Coef_Oil(12,time_step);
	Deriv_Exogenous.Emission_Coef_IC(1,13) = Emis_Coef_Oil(13,time_step);
	Deriv_Exogenous.Emission_Coef_IC(1,14) = Emis_Coef_Oil(14,time_step);
	Deriv_Exogenous.Emission_Coef_IC(1,15) = Emis_Coef_Oil(15,time_step);

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
	Deriv_Exogenous.Emission_Coef_IC(1,16) = Emis_Coef_Oil(16,time_step);
	Deriv_Exogenous.Emission_Coef_IC(1,17) = Emis_Coef_Oil(17,time_step);
	Deriv_Exogenous.Emission_Coef_IC(1,18) = Emis_Coef_Oil(18,time_step);
	Deriv_Exogenous.Emission_Coef_IC(1,18) = Emis_Coef_Oil(19,time_step);

	if VAR_emis == "high"

	////////////////////////////////////
	// Specific emission factors according to renewable mix
	Deriv_Exogenous.Emission_Coef_C = Emission_Coef_C;
	Deriv_Exogenous.Emission_Coef_IC = Emission_Coef_IC;
	// Gas
	Deriv_Exogenous.Emission_Coef_C(Indice_Gas_heating,:) = Emis_Coef_Gas_high(time_step);
	Deriv_Exogenous.Emission_Coef_IC(Indice_Gas_heating,:) = Emis_Coef_Gas_high(time_step);

    // Liquid fuels
	// X & C
	Deriv_Exogenous.Emission_Coef_C(1,1) = Emis_Coef_Oil_high(20,time_step);
	Deriv_Exogenous.Emission_Coef_X(1,1) = Emis_Coef_Oil_high(21,time_step);

	// LandTransport, NavalTransport, Airtransport, Agri_forestry_fishing, 
	Deriv_Exogenous.Emission_Coef_IC(1,12) = Emis_Coef_Oil_high(12,time_step);
	Deriv_Exogenous.Emission_Coef_IC(1,13) = Emis_Coef_Oil_high(13,time_step);
	Deriv_Exogenous.Emission_Coef_IC(1,14) = Emis_Coef_Oil_high(14,time_step);
	Deriv_Exogenous.Emission_Coef_IC(1,15) = Emis_Coef_Oil_high(15,time_step);

	// Autres secteurs
	Deriv_Exogenous.Emission_Coef_IC(1,1) = Emis_Coef_Oil_high(1,time_step);
	Deriv_Exogenous.Emission_Coef_IC(1,2) = Emis_Coef_Oil_high(2,time_step);
	Deriv_Exogenous.Emission_Coef_IC(1,3) = Emis_Coef_Oil_high(3,time_step);
	Deriv_Exogenous.Emission_Coef_IC(1,4) = Emis_Coef_Oil_high(4,time_step);
	Deriv_Exogenous.Emission_Coef_IC(1,5) = Emis_Coef_Oil_high(5,time_step);
	Deriv_Exogenous.Emission_Coef_IC(1,6) = Emis_Coef_Oil_high(6,time_step);
	Deriv_Exogenous.Emission_Coef_IC(1,7) = Emis_Coef_Oil_high(7,time_step);
	Deriv_Exogenous.Emission_Coef_IC(1,8) = Emis_Coef_Oil_high(8,time_step);
	Deriv_Exogenous.Emission_Coef_IC(1,9) = Emis_Coef_Oil_high(9,time_step);
	Deriv_Exogenous.Emission_Coef_IC(1,10) = Emis_Coef_Oil_high(10,time_step);
	Deriv_Exogenous.Emission_Coef_IC(1,11) = Emis_Coef_Oil_high(11,time_step);
	Deriv_Exogenous.Emission_Coef_IC(1,16) = Emis_Coef_Oil_high(16,time_step);
	Deriv_Exogenous.Emission_Coef_IC(1,17) = Emis_Coef_Oil_high(17,time_step);
	Deriv_Exogenous.Emission_Coef_IC(1,18) = Emis_Coef_Oil_high(18,time_step);
	Deriv_Exogenous.Emission_Coef_IC(1,18) = Emis_Coef_Oil_high(19,time_step);

	end

end

// if VAR_pM=="pM_low"
// 	//parameters.delta_pM_parameter(Indice_OilS) = (1+parameters.delta_pM_parameter(Indice_OilS)).^time_since_ini*(1-scal_pM);
// 	//parameters.delta_pM_parameter(Indice_GasS) = (1+parameters.delta_pM_parameter(Indice_GasS)).^time_since_ini*(1-scal_pM);
// 	//parameters.delta_pM_parameter(Indice_CoalS) = (1+parameters.delta_pM_parameter(Indice_CoalS)).^time_since_ini*(1-scal_pM);
// 	parameters.delta_pM_parameter(Indice_OilS) = parameters.delta_pM_parameter(Indice_OilS)*(1-scal_pM);
// 	parameters.delta_pM_parameter(Indice_GasS) = parameters.delta_pM_parameter(Indice_GasS)*(1-scal_pM);
// 	parameters.delta_pM_parameter(Indice_CoalS) = parameters.delta_pM_parameter(Indice_CoalS)*(1-scal_pM);
// elseif VAR_pM=="pM_high"
// 	//parameters.delta_pM_parameter(Indice_OilS) = (1+parameters.delta_pM_parameter(Indice_OilS)).^time_since_ini*(1+scal_pM);
// 	//parameters.delta_pM_parameter(Indice_GasS) = (1+parameters.delta_pM_parameter(Indice_GasS)).^time_since_ini*(1+scal_pM);
// 	//parameters.delta_pM_parameter(Indice_CoalS) = (1+parameters.delta_pM_parameter(Indice_CoalS)).^time_since_ini*(1+scal_pM);
// 	parameters.delta_pM_parameter(Indice_OilS) = parameters.delta_pM_parameter(Indice_OilS)*(1+scal_pM);
// 	parameters.delta_pM_parameter(Indice_GasS) = parameters.delta_pM_parameter(Indice_GasS)*(1+scal_pM);
// 	parameters.delta_pM_parameter(Indice_CoalS) = parameters.delta_pM_parameter(Indice_CoalS)*(1+scal_pM);
// end


// if ( find("alpha"==fieldnames(Proj_Vol))<> [] ) & Proj_Vol.alpha.intens

// 		Proj_Vol.alpha.apply_proj = %T; 
// 		Proj_Vol.alpha.ind_of_proj = list(list(Indice_OilS,1:nb_Sectors),list(Indice_GasS,1:nb_Sectors),list(Indice_CoalS,1:nb_Sectors),list(Indice_ElecS,1:nb_Sectors));

// 		Proj_Vol.IC.apply_proj = %T; 
// 		Proj_Vol.IC.intens = %F;
// 		Proj_Vol.IC.ind_of_proj = list(list(Indice_SteelIronS,1:nb_Sectors),list(Indice_NonMetalsS,1:nb_Sectors),list(Indice_CementS,1:nb_Sectors),list(Indice_OthMinS,1:nb_Sectors),list(Indice_PharmaS,1:nb_Sectors),list(Indice_PaperS,1:nb_Sectors));
		
// end 


// Exports_Val_2 : comme la croissance naturelle dans le pays à termes de l'échanges inchangés 
//if  VAR_choice_X=="second"
//	fun_resolution_val(1).name = "Imports_Val_2";
//end

// if Scenario =="S2" | Scenario =="S3"

// 	if time_step==1

// 		CarbonTax_Diff_IC = [0.030,0.030,0.030,0.030,0.030,0.030,0.030,0.030,0.030,0.030,0.030,0.030,0.030,0.030,0.030,0.030,0.030,0.030].*.ones(nb_Sectors,1);
// 		parameters.CarbonTax_Diff_IC = CarbonTax_Diff_IC;

// 		parameters.Carbon_Tax_rate = 0.2e6

// 	elseif time_step==2

// 		CarbonTax_Diff_IC = [0.090,0.090,0.090,0.090,0.090,0.090,0.090,0.090,0.090,0.090,0.090,0.090,0.090,0.090,0.090,0.090,0.090,0.090].*.ones(nb_Sectors,1);
// 		parameters.CarbonTax_Diff_IC = CarbonTax_Diff_IC; 

// 		parameters.Carbon_Tax_rate = 1.0e6

// 	end
// end

// old

// if VAR_population =="high"

// 	if time_step == 1

// 		Deriv_Exogenous.Population = 70868 ;
// 		Deriv_Exogenous.Labour_force = 29746;
// 		Deriv_Exogenous.Retired = 21307;
	
// 	elseif time_step == 2

// 		Deriv_Exogenous.Population = 74932 ;
// 		Deriv_Exogenous.Labour_force = 30003;
// 		Deriv_Exogenous.Retired = 28659;

// 	end