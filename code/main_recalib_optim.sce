// clean
clear

// main executable script
//PREAMBULE

disp("=====IMACLIM-Country Platform========");
 
/////////////////////////////////////////////////////////////////////////////////////////////
//	STEP 0: SYSTEM DEFINITION & SAVEDIR SETUP
/////////////////////////////////////////////////////////////////////////////////////////////
disp("STEP 0: loading Dashboard ");
exec("preambule.sce");
exec("Dashboard.sce");

if Output_files=='True'
	runName = study + "_" + mydate();
	SAVEDIR = OUTPUT+Country_ISO+"_" +runName + filesep();
	mkdir(SAVEDIR);
	diary(SAVEDIR+"summary.log");

	SAVEDIR_IOA = OUTPUT+Country_ISO+"_"+runName + filesep()+ "outputs_IOA"+filesep();
	mkdir(SAVEDIR_IOA);	
	
	// Save Dashbord.csv & System_Resol.csv in output
	copyfile(STUDY_Country + "Dashboard_" + Country_ISO + ".csv", SAVEDIR);
	copyfile(CODE + System_Resol + ".sce", SAVEDIR);
end

/////////////////////////////////////////////////////////////////////////////////////////////
//	STEP 1: LOADING DATA
/////////////////////////////////////////////////////////////////////////////////////////////

disp("STEP 1: DATA...");
exec("Loading_data.sce");

exec("IOT_DecompImpDom.sce");
 
//Execute Households_Disagg.sce file if Index_HouseholdsDISAGG is defined
if H_DISAGG <> "HH1"
	exec("Households_Desag.sce");
end

//Execute agreagation.sce file if Index_SectorsAGG is defined
if AGG_type <> ""
	exec("Aggregation.sce");
	exec("Hybridisation.sce" );
else
	exec("Hybridisation.sce" );
end

exec("Loading_params.sce");

/////////////////////////////////////////////////////////////////////////////////////////////
//	STEP 2: CHECKING BENCHMARK DATA
/////////////////////////////////////////////////////////////////////////////////////////////
disp("STEP 2: CHECKING CONSISTENCY of BENCHMARK DATA...")
exec("Checks_loads.sce");

/////////////////////////////////////////////////////////////////////////////////////////////
//	STEP 3: CALIBRATION
/////////////////////////////////////////////////////////////////////////////////////////////
disp("STEP 3: CODE CALIBRATION...");
exec("Check_CalibSyst.sce");
exec("Calibration.sce");

////////////////////////////////////////////////////////////
// 	STEP 4: RESOLUTION - EQUILIBRIUM 2016
////////////////////////////////////////////////////////////
disp("STEP 4: RESOLUTION AND EQUILIBRIUM 2016");

// Loop initialisation for various time step calculation
time_step=1;

// Creation of a new output subdirectory for each time step in case of several time steps calculation
if Nb_Iter<>1
	if Output_files=='True'
		SAVEDIR = OUTPUT+Country_ISO+"_" +runName + filesep() + time_step + filesep();
		mkdir(SAVEDIR);
	end
end

// Loading macro framework (common feature for each country) 
if Macro_nb <> ""
	exec(STUDY+"External_Module"+sep+"Macro_Framework.sce");
end

// Loading other study changes (specific feature)
exec(STUDY_Country+study+".sce");


// Recherche d'optimum ou simple résolution
//		[Mu    			u_param  		sigma_omegaU	CoefRealWage	phi_K..		
scal = 	[0.0082227339	0.1127758064	-0.1192021581	0.8242216354	-0.004913253 .. 
		0.0161172695	0.0179282157	-0.4074066869	-0.1707256015	-0.0729734596];
//		delta_M			delta_X			pGaz 			pFuels 			pElec];

//Optimum_1 = "True";
//if Optimum_1 == "True"
	function [d, parameters, Deriv_Exogenous] = GDP_calculation(parameters, Deriv_Exogenous, BY, calib, initial_value, scal) ;
		exec(STUDY_Country+"Recalib_RunChoices_1.sce");
		exec(System_Resol+".sce");
	endfunction 

	function [y] = System_optimisation(scal)
		[d, parameters, Deriv_Exogenous] = GDP_calculation(parameters, Deriv_Exogenous, BY, calib, initial_value, scal)
		y1 = [100*abs(((d.GDP/d.GDP_pFish)/BY.GDP - GDP_index)/GDP_index) .. 			//1
			100*abs((d.u_tot - 0.101573450097788)/0.101573450097788) .. 				//2
			100*(d.NetCompWages_byAgent(Indice_Households)*1E-6 - 847.503)/847.503 ..	//3
			100*abs((d.CPI - 1.0718874451)/1.0718874451) .. 							//3
			100*abs(((sum(d.pM.*d.M) - sum(d.pX.*d.X))*1E-6 - 44.676)/44.676) ..		//4
			100*(d.NetCompWages_byAgent(Indice_Households)*1E-6 - 847.503)/847.503 ..	//5
			100*(d.pC(2)/BY.pC(2) - 1.0280235988)/1.0280235988 .. 						//6	
			100*(d.pC(4)/BY.pC(4) - 0.9678596039)/0.9678596039 ..						//7
			100*(d.pC(5)/BY.pC(5) - 1.3837111671)/1.3837111671 ..						//8	
			];
		y = norm(y1);
	endfunction

	opt = optimset ("Display","iter", ..
	               "FunValCheck","on", ..
	               "MaxFunEvals",500, ..
	               "MaxIter",200, ..
	               "TolFun",1.e-5, ..
	               "TolX",1.e-10);
	
	[scal_opt_1, fval, exitflag, output] = fminsearch(System_optimisation, scal, opt);
	
	SAVEDIR_OPT = OUTPUT+"Optimum"+filesep();
	mkdir(SAVEDIR_OPT);
	csvWrite(scal_opt_1,SAVEDIR_OPT+"scal_opt_1.csv", ';');

//	disp("abort because of you choose to run an optimisation")
//	abort
//end
//if Optimum_1 == "False"
	scal = scal_opt_1;
	exec(STUDY_Country+"Recalib_RunChoices_1.sce");
	exec(System_Resol+".sce");
	clear scal
//end	

////////////////////////////////////////////////////////////
// 	STEP 5: OUTPUT EXTRACTION AND RESULTS DISPLAY 2016
////////////////////////////////////////////////////////////
disp("STEP 5: OUTPUT EXTRACTION AND RESULTS DISPLAY 2016");
if Output_files=='True'
	disp("STEP 6: OUTPUT EXTRACTION AND RESULTS DISPLAY...");
	exec(CODE+"outputs.sce");
	if time_step == 1
		BY = ini; // Carbon_Tax absent de BY mais pas de ini et nécessaire pour outputs_indic.sce
	end
	exec(CODE+"outputs_indic.sce");
end

Test_1 = "False"
if Test_1 == "True"
	exec("test_1.sce");
end

////////////////////////////////////////////////////////////
// 	STEP 7: VARIABLE STORAGE FOR RECURSIVE VERSION
////////////////////////////////////////////////////////////
if Nb_Iter <> 1
	exec(CODE+"Variable_Storage.sce");
else
	disp("Variable Storage not executed for the Nb_Iter = "+Nb_Iter)
end

////////////////////////////////////////////////////////////
// 	STEP 8: Data actualisation for 2018 (reference)
////////////////////////////////////////////////////////////
disp("STEP 8: Data actualisation for 2018");
time_step = 2;

// Dashboard elements
System_Resol = "Systeme_ProjHomothetic";
Energy_Balance = "False";

// BY & initial_value actualisation (data de 2010 stockée dans data_1)
data_0 = BY;
BY = ini;
clear initial_value
initial_value = Variables2struct(list_InitVal); // prend les valeurs courantes dans la liste 
Projection.IC = [];
Projection.Y = [];
Projection.M = [];
Projection.X = [];
Projection.X = [];

// parameters actualisations and re-calibration
exec("Loading_params.sce");
parameters.u_param = BY.u_param;
parameters.ConstrainedShare_Labour = ones(parameters.ConstrainedShare_Labour);//*0.8;
parameters.ConstrainedShare_Capital = ones(parameters.ConstrainedShare_Capital);//*0.8;
parameters.ConstrainedShare_IC = ones(parameters.ConstrainedShare_IC);//*0.8;
parameters.ConstrainedShare_C(Indice_EnerSect) = 0.5*ones(parameters.ConstrainedShare_C(Indice_EnerSect));
parameters.sigma_omegaU = BY.sigma_omegaU;
parameters.Coef_real_wage = BY.Coef_real_wage;

clear calib
exec("Calibration.sce");
warning("la recalibration ne fonctionne que si output_files = True")

Test_recalib = "False";
if Test_recalib == "True"
	for elt=1:size(list_calib)
		disp(list_calib(elt))
		execstr("test_BY = calib."+ list_calib(elt) + "- BY."+ list_calib(elt)+";");
		test_BY
		execstr("test_current = calib."+ list_calib(elt) + "- "+ list_calib(elt)+";");
		test_current
	end
end

////////////////////////////////////////////////////////////
// 	STEP 9: RESOLUTION - EQUILIBRIUM 2018
////////////////////////////////////////////////////////////
disp("STEP 9: RESOLUTION AND EQUILIBRIUM 2018");
// Creation of a new output subdirectory for each time step in case of several time steps calculation
if Nb_Iter<>1
	if Output_files=='True'
		SAVEDIR = OUTPUT+Country_ISO+"_" +runName + filesep() + time_step + filesep();
		mkdir(SAVEDIR);
	end
end

// Loading macro framework (common feature for each country) 
if Macro_nb <> ""
	exec(STUDY+"External_Module"+sep+"Macro_Framework.sce");
end

// Loading other study changes (specific feature)
exec(STUDY_Country+study+".sce");
parameters.time_since_ini = 2;
parameters.time_since_BY = 2;

// Recherche d'optimum ou simple résolution
scal = [0.0054862432	0.1129423369];

//Optimum_2 = "True";
//if Optimum_2 == "True"
	function [d, parameters, Deriv_Exogenous] = GDP_calculation(parameters, Deriv_Exogenous, data_0, BY, calib, initial_value, scal) ;
		parameters.Mu = scal(1);
		parameters.phi_L = ones(parameters.phi_L)*Mu;
		parameters.u_param = scal(2);		
		exec(System_Resol+".sce");
	endfunction 

	function [y] = System_optimisation(scal);
		[d, parameters, Deriv_Exogenous] = GDP_calculation(parameters, Deriv_Exogenous, data_0, BY, calib, initial_value, scal)
		y1 = [100*(d.u_tot - 0.096657603)/0.096657603 .. 					
			100*(d.GDP/(BY.GDP_pFish * d.GDP_pFish*data_0.GDP) - GDP_index(2))/GDP_index(2)];
		y = norm(y1);
	endfunction

	opt = optimset ("Display","iter", ..
	               "FunValCheck","on", ..
	               "MaxFunEvals",500, ..
	               "MaxIter",200, ..
	               "TolFun",1.e-5, ..
	               "TolX",1.e-10);

	[scal_opt_2, fval, exitflag, output] = fminsearch(System_optimisation, scal, opt);
	
	csvWrite(scal_opt_2,SAVEDIR_OPT+"scal_opt_2.csv", ';');

//	disp("abort because of you choose to run an optimisation")
//	abort
//end
//if Optimum_2 == "False"
	scal = scal_opt_2;
	clear scal_opt_2
	parameters.Mu = scal(1);
	parameters.phi_L = ones(parameters.phi_L)*Mu;
	parameters.u_param = scal(2);
	exec(System_Resol+".sce");
//end	

////////////////////////////////////////////////////////////
// 	STEP 10: OUTPUT EXTRACTION AND RESULTS DISPLAY 2018
////////////////////////////////////////////////////////////
disp("STEP 10: OUTPUT EXTRACTION AND RESULTS DISPLAY 2019");
if Output_files=='True'
	exec(CODE+"outputs.sce");
	exec(CODE+"outputs_indic.sce");
end

// attention : oubli du variable_storage... cela ne marchera pas sinon au delà

abort

////////////////////////////////////////////////////////////
// 	STEP 11: Static comparative based on 2018 reference
////////////////////////////////////////////////////////////
time_step = 3; // avant la boucle 

// Dashboard elements
System_Resol = "Systeme_Static_LeMonde";
clear Projection
Demographic_shift = "False";
Labour_product = "False";
World_prices = "False";
Energy_Balance = "False";

// BY & initial_value actualisation (data de 2010 stockée dans data_1)
BY = ini;
clear initial_value
initial_value = Variables2struct(list_InitVal); // prend les valeurs courantes dans la liste 

// parameters actualisations and loops
exec("Loading_params.sce");
parameters.u_param = BY.u_param;
parameters.time_since_BY = 0;
parameters.time_since_ini = 0;
parameters.ConstrainedShare_Labour(Indice_EnerSect) = ones(parameters.ConstrainedShare_Labour(Indice_EnerSect));//*0.8;
parameters.ConstrainedShare_Labour(Indice_EnerSect) = ones(parameters.ConstrainedShare_Labour(Indice_EnerSect));//*0.8;
parameters.ConstrainedShare_Capital = ones(parameters.ConstrainedShare_Capital);//*0.8;
parameters.ConstrainedShare_IC = ones(parameters.ConstrainedShare_IC);//*0.8;
parameters.ConstrainedShare_C(Indice_EnerSect) = 0.5*zeros(parameters.ConstrainedShare_C(Indice_EnerSect));
Loop_elements.Carbon_Tax_rate = [50 100 250]*1E3; // Taxe Carbone
Loop_elements.sigma_omegaU = [0.0 -0.1]; // Wage Curve : elasticity
Loop_elements.Coef_real_wage = [0.0 1.0]; // wage Curve : wage indexation
Loop_elements.sigma_Trade_coef = [1.0 0.1 0.0]; // Élasticité du commerce 

for CTax_elt=1:size(Loop_elements.Carbon_Tax_rate,1)
	for sigW_elt=1:size(Loop_elements.sigma_omegaU,1)
		for CoefW_elt=1:size(Loop_elements.Coef_real_wage,1)
			for SigTrade_elt=1:size(Loop_elements.sigma_Trade_coef,1)
				parameters.Carbon_Tax_rate = Loop_elements.Carbon_Tax_rate(CTax_elt);
				parameters.sigma_omegaU = Loop_elements.sigma_omegaU(sigW_elt);
				parameters.Coef_real_wage = Loop_elements.Coef_real_wage(CoefW_elt);
				parameters.sigma_X = parameters.sigma_X * Loop_elements.sigma_Trade_coef(CoefW_elt);
				parameters.sigma_M = parameters.sigma_M *Loop_elements.sigma_Trade_coef(CoefW_elt);

				// recalibration 

				// resolution 

				// sortie / output
				// definir un nom de dossier en contion des paramètres (et non du pas de temps)
				// Carbon_Tax-

				// current = BY, acttualisation des listes, data storage, etc... 

				// repassage en courant des valeurs de l'année de base 
				[Table_initial_value] = struct2Variables(BY,"BY");
				for i= Table_initial_value
				    execstr(Table_initial_value);
				end


				time_step = time_step + 1;
			end
		end
	end
end

// besoin de refaire chaque étape 
// notamment la recalibration à cause des fonctions de production 


// penser à la fin de chaque résolution à remettre l'ensemble des variables de BY en courant... 
// revoir les fonctions de Gaëlle pour se faire







////////////////////////////////////////////////////////////
// 	STEP Final: SHUT DOWN THE DIARY
////////////////////////////////////////////////////////////
if Output_files=='True'
diary(0)
end
