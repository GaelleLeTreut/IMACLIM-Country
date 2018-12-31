//////  Copyright or © or Copr. Ecole des Ponts ParisTech / CNRS 2018
//////  Main Contributor (2017) : Gaëlle Le Treut / letreut[at]centre-cired.fr
//////  Contributors : Emmanuel Combet, Ruben Bibas, Julien Lefèvre
//////  
//////  
//////  This software is a computer program whose purpose is to centralise all  
//////  the IMACLIM national versions, a general equilibrium model for energy transition analysis
//////
//////  This software is governed by the CeCILL license under French law and
//////  abiding by the rules of distribution of free software.  You can  use,
//////  modify and/ or redistribute the software under the terms of the CeCILL
//////  license as circulated by CEA, CNRS and INRIA at the following URL
//////  "http://www.cecill.info".
//////  
//////  As a counterpart to the access to the source code and  rights to copy,
//////  modify and redistribute granted by the license, users are provided only
//////  with a limited warranty  and the software's author,  the holder of the
//////  economic rights,  and the successive licensors  have only  limited
//////  liability.
//////  
//////  In this respect, the user's attention is drawn to the risks associated
//////  with loading,  using,  modifying and/or developing or reproducing the
//////  software by the user in light of its specific status of free software,
//////  that may mean  that it is complicated to manipulate,  and  that  also
//////  therefore means  that it is reserved for developers  and  experienced
//////  professionals having in-depth computer knowledge. Users are therefore
//////  encouraged to load and test the software's suitability as regards their
//////  requirements in conditions enabling the security of their systems and/or 
//////  data to be ensured and,  more generally, to use and operate it in the
//////  same conditions as regards security.
//////  
//////  The fact that you are presently reading this means that you have had
//////  knowledge of the CeCILL license and that you accept its terms.
//////////////////////////////////////////////////////////////////////////////////

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

printf("===============================================\n");
disp(" ======= IMACLIM-"+Country+" is running=============================");
printf("===============================================\n");

disp(" ======= for resolving the system: "+System_Resol)
printf("===============================================\n");
disp(" ======= using the study file: "+study)
printf("===============================================\n");
disp("======= with various class of households: "+H_DISAGG)
printf("===============================================\n");
disp("======= at aggregated level: "+AGG_type)
printf("===============================================\n");
disp("======= with the resolution mode: "+Resol_Mode)
printf("===============================================\n")
disp("======= using various iterations:"+Nb_Iter)
printf("===============================================\n");
disp("======= under the scenario nammed:"+Scenario)
printf("===============================================\n");
disp("======= under the macro framework number:"+Macro_nb)
printf("===============================================\n");
//disp("======= Recycling option of carbon tax:"+Recycling_Option)
//printf("===============================================\n");
if Output_files=='False'
	disp("=======You choose not to print outputs in external files")
	printf("===============================================\n");
end
if CO2_footprint=='False'
	disp("=======You choose not to realise a Carbon footprint analysis")
	printf("===============================================\n");
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
// 	STEP 4: INPUT OUTPUT ANALYSIS BY
////////////////////////////////////////////////////////////
disp("STEP 4: INPUT OUTPUT ANALYSIS FOR EMBODIED EMISSIONS AT BASE YEAR");
if CO2_footprint =="True"
	exec(CODE+"IOA_BY.sce");
end


////////////////////////////////////////////////////////////
// 	STEP 5: RESOLUTION - EQUILIBRIUM
////////////////////////////////////////////////////////////

disp("STEP 5: RESOLUTION AND EQUILIBRIUM...");

// Loop initialisation for various time step calculation
for time_step=1:Nb_Iter

	// Creation of a new output subdirectory for each time step in case of several time steps calculation
	if Nb_Iter<>1
		if Output_files=='True'
			SAVEDIR = OUTPUT+Country_ISO+"_" +runName + filesep() + time_step + filesep();
			mkdir(SAVEDIR);
		end
	end

	//// Defining matrix with dimension of each variable for Resolution file
	// if  System_Resol=="Projection_homothetic"
	// VarDimMat_resol = eval(Index_Imaclim_VarProHom(2:$,2:3));
	// else
	// VarDimMat_resol = eval(Index_Imaclim_VarResol(2:$,2:3));
	// end

	// Loading macro framework (common feature for each country) 
	if Macro_nb <> ""
		exec(STUDY+"External_Module"+sep+"Macro_Framework.sce");
	end

	// Loading other study changes (specific feature)
	exec(STUDY_Country+study+".sce");

	exec(System_Resol+".sce");
	warning("sign of ClimPolCompensbySect")

	////////////////////////////////////////////////////////////
	// 	STEP 6: OUTPUT EXTRACTION AND RESULTS DISPLAY
	////////////////////////////////////////////////////////////
	if Output_files=='True'
		disp("STEP 6: OUTPUT EXTRACTION AND RESULTS DISPLAY...");
		exec(CODE+"outputs.sce");
		if time_step == 1
			BY = ini; // ré-initialisation de BY sur ini car certaines variables de ini ne sont pas dans BY et nécessaire pour la suite (pour outputs_indice : BY.Carbon_Tax --> cela sera réglé quand update calibration de la taxe carbone ? )
		end

		exec(CODE+"outputs_indic.sce");

		if System_Resol == "Projection_ECOPA"
			exec(CODE+"outputs_indic_ECOPA.sce");
		end
	end

	////////////////////////////////////////////////////////////
	// 	STEP 7: INPUT OUTPUT ANALYSIS AFTER RUN
	////////////////////////////////////////////////////////////
	if CO2_footprint == 'True'
		disp("STEP 7: INPUT OUTPUT ANALYSIS FOR EMBODIED EMISSIONS...");
		exec(CODE+"IOA_Run.sce");
	end

	////////////////////////////////////////////////////////////
	// 	STEP 8: VARIABLE STORAGE FOR RECURSIVE VERSION
	////////////////////////////////////////////////////////////
	if Nb_Iter <> 1
		exec(CODE+"Variable_Storage.sce");
	else
		disp("Variable Storage not executed for the Nb_Iter = "+Nb_Iter)
	end


end // Loop ending for for various time step calculation

//shut down the diary
if Output_files=='True'
diary(0)
end
