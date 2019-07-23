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
Test_mode = isdef('TEST_MODE');

// debug mode
debug_mode = %T;

// defined in the test program
if Test_mode then
    debug_mode = testing.debug_mode;
end

// output of print
if debug_mode then
    out = %io(2);
    warning('on');
else
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

print(out," ======= IMACLIM-"+Country+" is running=============================");

print(out," ======= for resolving the system: "+System_Resol);
print(out," ======= using the study file: "+study);
print(out,"======= with various class of households: "+H_DISAGG);
print(out,"======= at aggregated level: "+AGG_type);
print(out,"======= with the resolution mode: "+Resol_Mode);
print(out,"======= using various iterations:" + string(Nb_Iter));
print(out,"======= under the scenario nammed:"+Scenario);
print(out,"======= under the macro framework number:"+Macro_nb);
//print(out,"======= Recycling option of carbon tax:"+Recycling_Option);
if Output_files=='False'
    print(out,"======= You choose not to print outputs in external files");
end
if CO2_footprint=='False'
    print(out,"======= You choose not to realise a Carbon footprint analysis");
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

    // Creation of a new output subdirectory for each time step in case of several time steps calculation
    if Nb_Iter<>1
        if Output_files=='True'
            SAVEDIR = OUTPUT+Country_ISO+"_" +runName + filesep() + "Time_" + time_step + filesep();
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
        exec("Macro_Framework.sce");
    end

    // Load the projections for forcing
    if Scenario <> '' then
        if time_step == 1 then
            exec("Import_Proj_Volume.sce");
        end
        exec('Load_Proj_Vol.sce');
    end

    // Loading other study changes (specific feature)
    exec(STUDY_Country+study+".sce");

    exec(System_Resol+".sce");
    warning("sign of ClimPolCompensbySect");

    // Check if the projections are made correctly
    if Scenario <> '' then
        exec("Check_Proj_Vol.sce");
    end

    ////////////////////////////////////////////////////////////
    // 	STEP 6: OUTPUT EXTRACTION AND RESULTS DISPLAY
    ////////////////////////////////////////////////////////////
    if Output_files=='True'
        printf("STEP 6: RECORDING THE OUTPUTS... \n");
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
        print(out,"STEP 7: INPUT OUTPUT ANALYSIS FOR EMBODIED EMISSIONS...");
        exec(CODE+"IOA_Run.sce");
    end

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
if Output_files=='True'
    diary(0);
end

printf('\n------------ Done ! :) ------------\n');
