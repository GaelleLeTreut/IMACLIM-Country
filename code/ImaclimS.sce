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



// test mode
if ~isdef('TEST_MODE') then
    TEST_MODE = %F;
end

if ~isdef('SIMU_MODE') then
    SIMU_MODE = %F;
end

// debug mode
debug_mode = %T;

// defined in the test program
if TEST_MODE then
    debug_mode = testing.debug_mode;
end

// output of print
if debug_mode then
    //out2 =0;
    // out2 = %io(2);
    out = %io(2);
    warning('on');
else
    // out2 = 0;
    out = 0;
    warning('off');
end

//PREAMBULE

print(out,"=====IMACLIM-Country Platform========");

/////////////////////////////////////////////////////////////////////////////////////////////
//	STEP 0: SYSTEM DEFINITION & SAVEDIR SETUP
/////////////////////////////////////////////////////////////////////////////////////////////
printf("STEP 0: loading Dashboard \n");

exec("Load_file_structure.sce");

//saved_files = listfiles(SAVED_DATA);
//if saved_files <> [] then
//    exec(TEST_FULLCODE + "restore_run_mode.sce");
//end

exec ("preambule.sce");
exec("Dashboard.sce");


if Output_files

    simu_name = '';
    if SIMU_MODE then
        simu_name = Current_Simu_Name;
	elseif 	Scenario==""
		simu_name='';
	else
		simu_name=Scenario;
    end

    syst_name = '';
    if Optimization_Resol then
        syst_name = SystemOpt_Resol;
    else
        syst_name = System_Resol;
    end

    runName = Country_ISO + '_' + mydate() + '_' + simu_name + '_' + syst_name + '_' + study;
    SAVEDIR = OUTPUT + runName + filesep();
    mkdir(SAVEDIR);
    diary(SAVEDIR+"summary.log");

    SAVEDIR_IOA = SAVEDIR + "outputs_IOA" + filesep();
    mkdir(SAVEDIR_IOA);	

    // Save Dashbord.csv & System_Resol.csv in output
    copyfile(STUDY_Country + "Dashboard_" + Country_ISO + ".csv", SAVEDIR);
	if study <> '' 
    copyfile(STUDY_Country + study + ".sce", SAVEDIR);	
	end	
	if Scenario <> '' 
        if Country == 'France'
            copyfile(STUDY_Country + "ProjScenario" + AGG_type + ".csv", SAVEDIR);	
        else
            copyfile(STUDY_Country + 'Projections_Scenario.csv', SAVEDIR); 
        end
	end
    if Optimization_Resol then
        copyfile(SYST_RESOL + SystemOpt_Resol + ".csv", SAVEDIR);
    else
        copyfile(CODE + System_Resol + ".sce", SAVEDIR);
    end

    // Record the name of the current run
    if SIMU_MODE then
        current_run_name = simu_name;
    elseif Scenario <> '' then
        current_run_name = Scenario;
    else
        current_run_name = 'NoScen';
    end

    fd = mopen(SAVEDIR + 'name.txt','wt');
    mputl(current_run_name,fd);
    mclose(fd);

end

print(out," ======= IMACLIM-"+Country+" is running=============================");

// Short name to identify homo proj
Homo_Shortname = "Systeme_ProjHomo";
OptHomo_Shortname ="SystemOpt_ProjHomo";
// Forcing changes in dashboard if proj homo selected
if Optimization_Resol
	if part(SystemOpt_Resol,1:length(OptHomo_Shortname))== OptHomo_Shortname & ( Scenario<>"")
		warning("The scenario selected in the dashboard has been cancelled: incompatible with homothetic projection");
		Scenario = "";
	end
	
	if part(SystemOpt_Resol,1:length(OptHomo_Shortname))== OptHomo_Shortname & ( Capital_Dynamics)
		warning("The scenario selected in the dashboard has been cancelled: incompatible with homothetic projection");
		Capital_Dynamics = %F;
	end
	
	if part(SystemOpt_Resol,1:length(OptHomo_Shortname))== OptHomo_Shortname & ( World_prices=="True" | X_nonEnerg=="True")
		warning("The boundaries conditions selected on world prices or exports in the dashboard has been cancelled: incompatible with homothetic projection");
		World_prices = "False";
		X_nonEnerg = "False";
	end
	
	
else
	if part(System_Resol,1:length(Homo_Shortname))== Homo_Shortname & ( Scenario<>"")
		warning("The scenario selected in the dashboard has been cancelled: incompatible with homothetic projection");
		Scenario = "";
	end
	
	if part(System_Resol,1:length(Homo_Shortname))== Homo_Shortname & ( Capital_Dynamics)
		warning("Capital Market modelling has been cancelled: incompatible with homothetic projection");
		Capital_Dynamics = %F;
	end
	
	if part(System_Resol,1:length(Homo_Shortname))== Homo_Shortname &  ( World_prices=="True" | X_nonEnerg=="True")
		warning("The boundaries conditions selected on world prices or exports in the dashboard has been cancelled: incompatible with homothetic projection");
		World_prices = "False";
		X_nonEnerg = "False";
	end

end

if Optimization_Resol 
    print(out," ======= for resolving the system: "+SystemOpt_Resol);
else
    print(out," ======= for resolving the system: "+System_Resol);
end
if Capital_Dynamics
print(out," ======= modelling Capital Market ");
else 
print(out," ======= not modelling Capital Market ");
end 
print(out," ======= using the study file: "+study);
print(out,"======= with various class of households: "+H_DISAGG);
print(out,"======= at aggregated level: "+AGG_type);

print(out,"======= number of resolution iterations:" + string(Nb_Iter));
print(out,"======= under the scenario named:"+Scenario);
print(out,"======= under the macro framework number:"+Macro_nb);
//print(out,"======= Recycling option of carbon tax:"+Recycling_Option);
if ~Output_files
    print(out,"======= You chose not to save outputs in external files");
end
if CO2_footprint=='False'
    print(out,"======= You chose not to realise a Carbon footprint analysis");
end


/////////////////////////////////////////////////////////////////////////////////////////////
//	STEP 1: LOADING DATA
/////////////////////////////////////////////////////////////////////////////////////////////

printf("STEP 1: DATA... \n");
exec("Loading_data.sce");

exec("IOT_DecompImpDom.sce");

//Execute Households_Disagg.sce file if Index_HouseholdsDISAGG is defined
if H_DISAGG <> "HH1"
    exec("Households_Desag.sce");
end

nb_size_I = 1;
if Invest_matrix then
    nb_size_I = nb_Sectors;
    exec("Invest_Desag.sce");
end

//Execute agreagation.sce file if Index_SectorsAGG is defined
if AGG_type <> ""
    exec("Aggregation.sce");
    if Invest_matrix then
        nb_size_I = nb_SectorsAGG;
    end
end

exec("Hybridisation.sce" );

exec("Loading_params.sce");

/////////////////////////////////////////////////////////////////////////////////////////////
//	STEP 2: CHECKING BENCHMARK DATA
/////////////////////////////////////////////////////////////////////////////////////////////
printf("STEP 2: CHECKING CONSISTENCY of BENCHMARK DATA... \n");
exec("Checks_loads.sce");

/////////////////////////////////////////////////////////////////////////////////////////////
//	STEP 3: CALIBRATION
/////////////////////////////////////////////////////////////////////////////////////////////

printf("STEP 3: CODE CALIBRATION... \n");
exec("Check_CalibSyst.sce");
exec("Calibration.sce");

////////////////////////////////////////////////////////////
// 	STEP 4: INPUT OUTPUT ANALYSIS BY
////////////////////////////////////////////////////////////
printf("STEP 4: INPUT OUTPUT ANALYSIS FOR EMBODIED EMISSIONS AT BASE YEAR \n");
if CO2_footprint =="True"
    exec(CODE+"IOA_BY.sce");
end

////////////////////////////////////////////////////////////
// 	STEP 5: RESOLUTION - EQUILIBRIUM
////////////////////////////////////////////////////////////

printf("STEP 5: RESOLUTION AND EQUILIBRIUM... \n");

// Loop initialisation for various time step calculation
for time_step=1:Nb_Iter

    // set up calibration to ini instead of BY
    if time_step > 1 & Country = 'France' & study == 'Recalib_RunChoices'

        // load a file !!!

    end

    // Loading different carbon tax diff for each time step ( to be informed in dashboard)
    if CarbonTaxDiff
        if AGG_type == ""
            parameters.CarbonTax_Diff_IC=read_csv(PARAMS_Country+sep+"Simu_CarbonTaxDiff"+sep+"CarbonTax_Diff_IC"+string(AGG_type)+"_"+time_step+".csv",";");
            parameters.CarbonTax_Diff_C=read_csv(PARAMS_Country+sep+"Simu_CarbonTaxDiff"+sep+"CarbonTax_Diff_C_"+string(AGG_type)+string(H_DISAGG)+"_"+time_step+".csv",";");
        else
            parameters.CarbonTax_Diff_IC=read_csv(PARAMS_Country+string(AGG_type)+sep+"Simu_CarbonTaxDiff"+sep+"CarbonTax_Diff_IC_"+string(AGG_type)+"_"+time_step+".csv",";");
            parameters.CarbonTax_Diff_C=read_csv(PARAMS_Country+string(AGG_type)+sep+"Simu_CarbonTaxDiff"+sep+"CarbonTax_Diff_C_"+string(AGG_type)+"_"+string(H_DISAGG)+"_"+time_step+".csv",";");
        end
        parameters.CarbonTax_Diff_IC (1,:) = [];
        parameters.CarbonTax_Diff_IC (:,1) = [];
        parameters.CarbonTax_Diff_IC=evstr(parameters.CarbonTax_Diff_IC);

        parameters.CarbonTax_Diff_C (1,:) = [];
        parameters.CarbonTax_Diff_C (:,1) = [];
        parameters.CarbonTax_Diff_C=evstr(parameters.CarbonTax_Diff_C);

    end


    // Loading macro framework (common feature for each country) 
    if Macro_nb <> ""
        exec("Macro_Framework.sce");
    end
	
	// Calibration of capital dynamics
	if Capital_Dynamics & time_step ==1 
		exec("Calibration_CapitalDyn.sce");
	end
	
    // Load the projections for forcing
    if Scenario <> '' then
        if time_step == 1 then
            exec("Load_Proj_files.sce");
        end
        exec('Load_Proj_Vol.sce');
    end

    // Loading other study changes (specific feature) except for homothetic projections
    if Optimization_Resol then
        if part(SystemOpt_Resol,1:length(OptHomo_Shortname))<> OptHomo_Shortname
            if Country == "France" & study == 'Recalib_RunChoices'
                exec(STUDY_Country+study+"_"+time_step+".sce");
            else
                exec(STUDY_Country+study+".sce");
            end
        end 
    else
        if part(System_Resol,1:length(Homo_Shortname))<> Homo_Shortname
            exec(STUDY_Country+study+".sce");
        end 
    end

//%%%%%%%%%%%%%%%%%%%%%%%%%

	// Give the year into file name instead of the time step
	if isdef("Proj_Macro")
	Name_time=	Proj_Macro.current_year(time_step);
	Init_year = Proj_Macro.reference_year(1);
		if time_step > 1
		YearBef = Proj_Macro.reference_year(time_step);
		elseif time_step==1
		YearBef = Proj_Macro.reference_year(1);
		end
	else
	Name_time = time_step;
	YearBef = "StepBef";
	Init_year = "0";
	end
	
    // Creation of a new output subdirectory for each time step
    //if Nb_Iter<>1
    if Output_files
        SAVEDIR = OUTPUT +runName + filesep() + "Time_" + Name_time + filesep();
        mkdir(SAVEDIR);
			if time_step==1
			    SAVEDIR_INIT = OUTPUT +runName + filesep() + "Time_" +Init_year+ filesep();
				mkdir(SAVEDIR_INIT);
			end
    end
    //end

    /// RESOLUTION
    if Optimization_Resol then
        exec('Order_resolution.sce');
        exec('Resolution.sce');
    else
        exec(System_Resol+".sce");
    end

    warning("sign of ClimPolCompensbySect");

    // Check if the projections are made correctly
    if Scenario <> '' then
        exec("Check_Proj_Vol.sce");
    end

    ////////////////////////////////////////////////////////////
    // 	STEP 6: OUTPUT EXTRACTION AND RESULTS DISPLAY
    ////////////////////////////////////////////////////////////
    printf("STEP 6: RECORDING THE OUTPUTS... \n");
    exec(CODE+"outputs.sce");
    if time_step == 1
        BY = ini; 
		//Save BY for full output template
		ref = BY;
		evol_ref = evol_init;
		ref_name = "BY";
		Out = BY ;
		Name_time_temp = Name_time;
		Name_time = Init_year;	
	    OutputfilesBY =%F;
		exec(CODE+"outputs_indic.sce");	
		Name_time =Name_time_temp;
	
    end

	// Reference year for results and indice prices
	ref = BY;
	evol_ref = evol_BY;
	ref_name = "BY";
	Out = d ;
	OutputfilesBY =%T;
    exec(CODE+"outputs_indic.sce");
	
	// Prints compare with year before
    if Output_prints
        exec(CODE+"output_prints.sce");
    end
	
	// Changing reference_year to compare results
	if Country=="Argentina"	
		if time_step==1
			ref = d;
			evol_ref = evol_2015;
			ref_name = "2015";
			Out = d ;
			OutputfilesBY =%F;
				if Output_files
					SAVEDIR_INIT_temp =SAVEDIR_INIT; 
					SAVEDIR_INIT = SAVEDIR;
				end
			exec(CODE+"outputs_indic.sce");	
			OutputfilesBY =%T;
				if Output_files
					SAVEDIR_INIT =SAVEDIR_INIT_temp;
					clear SAVEDIR_INIT_temp 
				end
		elseif time_step>=2
			ref = data_1;
			evol_ref = evol_2015;
			ref_name = "2015";
			Out=d;
			exec(CODE+"outputs_indic.sce");
		end
	end
	

    ////////////////////////////////////////////////////////////
    // 	STEP 7: INPUT OUTPUT ANALYSIS AFTER RUN
    ////////////////////////////////////////////////////////////
    if CO2_footprint == 'True'
        print(out,"STEP 7: INPUT OUTPUT ANALYSIS FOR EMBODIED EMISSIONS...");
        exec(CODE+"IOA_Run.sce");
    end

//%%%%%%%%%%%%%%%%%%%%%%%%%
// Tests de contrôle recalibration 
//%%%%%%%%%%%%%%%%%%%%%%%%%
    if Country == "France" & SystemOpt_Resol == "SystemOpt_Static_Recalib"
        Test_1 = "False";
        Test_2 = "True";

        if Test_1 == "True"
            exec("Test_Recalib"+filesep()+"test_1.sce");
            pause
        end
        if Test_2 == "True"
            exec("Test_Recalib"+filesep()+"test_2.sce");
            pause
        end
    end
//%%%%%%%%%%%%%%%%%%%%%%%%%

    ////////////////////////////////////////////////////////////
    // 	STEP 8: VARIABLE STORAGE FOR RECURSIVE VERSION
    ////////////////////////////////////////////////////////////
    if Nb_Iter <> 1
        exec(CODE+"Variable_Storage.sce");
    else
        print(out,"Variable Storage not executed for the Nb_Iter = " + string(Nb_Iter));
    end

end // Loop ending for for various time step calculation

//shut down the diary
if Output_files
    diary(0);
end

printf('\n------------ Done ! :) ------------\n');

AGG_type
time_step
Macro_nb
Scenario
Recycling_Option

GDP
u_tot
GDP_pFish
