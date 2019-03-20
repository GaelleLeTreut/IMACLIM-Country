// clean
clear

// main executable script
//PREAMBULE

disp("=====IMACLIM-Country Platform========");
 
/////////////////////////////////////////////////////////////////////////////////////////////
//	STEP 0: SYSTEM DEFINITION & SAVEDIR SETUP
/////////////////////////////////////////////////////////////////////////////////////////////
disp("STEP 0: loading Dashboard ");
exec ("preambule.sce");
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
exec(STUDY_Country+"Recalib_RunChoices_1.sce");
exec(System_Resol+".sce");

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

////////////////////////////////////////////////////////////
// 	STEP 7: VARIABLE STORAGE FOR RECURSIVE VERSION
////////////////////////////////////////////////////////////
if Nb_Iter <> 1
	exec(CODE+"Variable_Storage.sce");
else
	disp("Variable Storage not executed for the Nb_Iter = "+Nb_Iter)
end

exec("test_1.sce");






////////////////////////////////////////////////////////////
// 	STEP Final: SHUT DOWN THE DIARY
////////////////////////////////////////////////////////////
if Output_files=='True'
diary(0)
end
