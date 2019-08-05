// ----------------------- *
// Load the code structure *
// ----------------------- *

cd('..');
exec('Load_file_structure.sce');
cd(SIMUS);


// ----------------------------- *
// Data structure initialisation *
// ----------------------------- *

// Country
country_def = ['Component', 'Name', ''];
// Default dashboard 
dashboard_def = [];
// Given functions
functions_def = struct();
// Given variables
variables_def = struct();
// List of simulations to launch
simulation_list = list();

// Headers to read the csv
separation_head = '**********';
country_head = 'Country Selection';
dashboard_head = 'Dashboard';
functions_head = 'Functions';
variables_head = 'Variables';
simulation_head = 'Simulation';

// Categories of the simulation
remove_fun_head = 'Remove_Fun';
add_fun_head = 'Add_Fun';
dash_changes_head = 'Dash_changes';
remove_var_head = 'Remove_Var';
add_var_head = 'Add_Var';

// List of the categories
simu_list_cat = list(remove_fun_head, add_fun_head, dash_changes_head, ..
remove_var_head, add_var_head);


// -------------------- *
// Load the simulations *
// -------------------- *

// Name
simu_file_name = 'SimuTest.csv';
// Path
simu_path = SIMUS + simu_file_name;

// Fill the data structures
exec('Read_Simu.sce');


// ------------------------------------------------- *
// Save the files which may are going to be modified *
// ------------------------------------------------- *

// To earn time, use the code of Test_AllConfing
getd(TEST_FULLCODE);

// To save Country_Selection and Dashboards, in Test_AllConfig directory
mkdir(SAVED_DATA);

// Save the current Country Selection file
country_selection = 'Country_Selection.csv';
save_file(country_selection, STUDY);

// Save the current Dashboard
country_iso = country_def(2,3);
dashboard_file_name = 'Dashboard_' + country_iso + '.csv';
study_frames_country = STUDY + 'study_frames_' + country_iso + filesep();
save_file(dashboard_file_name, study_frames_country);

// Save all the SystemOpt Resol .csv
save_sys = 'Save_System_Resol' + filesep();
mkdir(save_sys);
for f = listfiles(SYST_RESOL)'
    // Save the .csv file, only if it is not already saved
    list_saved_files = listfiles(save_sys);
    if part(f,$-3:$) == '.csv' & (find(list_saved_files == f) == []) then
        copyfile(SYST_RESOL + f, save_sys);
    end
end

// Save all the Var Resol files
save_var_resol = 'Save_Var_Resol' + filesep();
mkdir(save_var_resol);
data_country = DATA + 'data_' + country_iso + filesep();
pref = 'Index_Imaclim_Var';
for f = listfiles(data_country)'
    // Save the .csv file, only if it is not already saved
    list_saved_files = listfiles(save_var_resol);
    if part(f,1:length(pref)) == pref & (find(list_saved_files == f) == []) then
        copyfile(data_country + f, save_var_resol);
    end
end


// --------------------------------- *
// Parameters to launch ImaclimS.sce *
// --------------------------------- *

// Enable test_mode
TEST_MODE = %T;

// Parameters of the simulations
testing.countMax = 3;
testing.debug_mode = %F;


// ------------------------------------------------- *
// Write Country_Selection.csv of the tested country *
// ------------------------------------------------- *

csvWrite(country_def, STUDY + country_selection, ';');


// -------------------------------- *
// Launh each simulation one by one *
// -------------------------------- *

for simu = simulation_list

    // ------------------------------------- *
    // Write the dashboard of the simulation *
    // ------------------------------------- *

    csvWrite(simu(dashboard_head), study_frames_country + dashboard_file_name, ';');


    // ----------------------------------------------------- *
    // Write the SystemOpt Resol csv file for the simulation *
    // ----------------------------------------------------- *

    opt_resol_entry = 'Optimization_Resol';
    systopt_resol_entry = 'SystemOpt_Resol';
    ind_opt_resol = find(simu(dashboard_head)(:,1) == opt_resol_entry);

    // Test if Optimization is an entry of the Dashboard
    if size(ind_opt_resol) == [1,1] then
        val_opt_resol = simu(dashboard_head)(ind_opt_resol,2);

        // Test if Optimization is activated in the Dashboard
        if val_opt_resol == '%T' then
            ind_systopt = find(simu(dashboard_head)(:,1) == systopt_resol_entry);

            // Test that SystemOpt_Resol is an entry of the Dashboard
            if size(ind_systopt) == [1,1] then

                // Name of the SystemeOpt Resol file
                systopt_resol_name = simu(dashboard_head)(ind_systopt,2);
                // Functions csv file 
                SystOpt_resol_Fun = read_csv(save_sys + systopt_resol_name + '.csv', ';');

                // Remove functions to remove
                for fun_line = simu(remove_fun_head)
                    // Find the line to remove
                    ind_fun_line = -1;

                    for i = 1:size(SystOpt_resol_Fun,1)
                        sys_line = SystOpt_resol_Fun(i,:);
                        // Do not check the arguments
                        if sys_line(1:2) == fun_line(1:2) then
                            ind_fun_line = i;
                        end
                    end

                    if ind_fun_line == -1 then
                        // The line to removed has not been found
                        disp(fun_line);
                        error('This functions is not defined in system opt resol, it cannot be removed.');
                    else
                        // Remove the line found
                        SystOpt_resol_Fun(ind_fun_line,:) = [];
                    end

                end

                // Add functions to add : at the end of the file
                for fun_line = simu(add_fun_head)
                    SystOpt_resol_Fun($+1,1:3) = fun_line(1:3);
                end

                // Write the new SystemOpt Resol functions file
                csvWrite(SystOpt_resol_Fun, SYST_RESOL + systopt_resol_name + '.csv', ';');

            else
                // SystemOpt_Resol not an entry of the Dashboard
                disp(simu(dashboard_head));
                error("""" + systopt_resol_entry + """" + ' is not an entry of the Dashboard of this simulation');
            end
            
        else
            // Optimization == %F
            warning('Mode optimization not activated in the Dashboard : no change in the functions.');
        end
        
    else
        // Optimization not an entry of the Dashboard
        disp(simu(dashboard_head));
        error("""" + opt_resol_entry + """" + ' is not an entry of the Dashboard of this simulation');
    end


    // ------------------------------------------ *
    // Write the Var Resol file of the simulation *
    // ------------------------------------------ *

    // Load the Var Resol file
    // TODO : Systeme Resol dans le systeme de résolution !
    var_resol_file_name = 'Index_Imaclim_VarResol.csv';
    var_resol = read_csv(save_var_resol + var_resol_file_name, ';');
    var_resol = stripblanks(var_resol);

    // Remove the variables to remove
    for var_line = simu(remove_var_head)
        var_to_remove = var_line(1);
        ind_var = find(var_resol(:,1) == var_to_remove);
        if size(ind_var) == [1,1] then
            // remove the line of the variable
            var_resol(ind_var,:) = [];
        else
            error('The variable ' + var_to_remove + ' cannot be removed, ' ..
            + 'it is not in var resol : ' + var_resol_file_name);
        end
    end

    // Add the variables to add
    for var_line = simu(add_var_head)
        var_to_add = var_line(1);
        ind_var = find(var_resol == var_to_add);
        if size(ind_var) == [1,1] then
            error('You try to add a variable which is already in Var_Resol : ' ..
            + """" + var_to_add + """" + ' / ' + var_resol_file_name );
        else
            var_resol($+1,1:size(var_line,2)) = var_line;
        end
    end

    // Write the new Var Resol file
    csvWrite(var_resol, data_country + var_resol_file_name, ';');


    // ------------------- *
    // Launch ImaclimS.sce *
    // ------------------- *

    cd('..');
    launch_ImaclimS();
    cd(SIMUS);

end


// -------------------------------------- *
// Restore the files which had been saved *
// -------------------------------------- *

// Restore Country_Selection
restore_file(country_selection, STUDY);

// Restore Dashboard
restore_file(dashboard_file_name, study_frames_country);

// Restore all SystemOpt Resol csv files
for f = listfiles(save_sys)'
    movefile(save_sys + f, SYST_RESOL);
end
disp('  - Systeme resol files restored !');

// Restore all the Var Resol files
for f = listfiles(save_var_resol)'
    movefile(save_var_resol + f, data_country);
end
disp('  - Var Resol files restored !');
