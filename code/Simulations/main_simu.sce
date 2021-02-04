// ----------------------- *
// Load the code structure *
// ----------------------- *

cd('..');
exec('Load_file_structure.sce');
cd(SIMUS);


// ----------------------------- *
// Data structure initialisation *
// ----------------------------- *

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
dashboard_head = 'Dashboard';
functions_head = 'Functions';
variables_head = 'Variables';
simulation_head = 'Simulation';

sensib_sep = '<<<';

// Categories of the simulation
remove_fun_head = 'Remove_Fun';
add_fun_head = 'Add_Fun';
dash_changes_head = 'Dash_changes';
remove_var_head = 'Remove_Var';
add_var_head = 'Add_Var';
sensib = 'Sensib';

simu_name_head = 'Name';

// List of the categories
simu_list_cat = list(remove_fun_head, add_fun_head, dash_changes_head, ..
remove_var_head, add_var_head, sensib);


// -------------------- *
// Load the simulations *
// -------------------- *

// Read the country
count_selec = read_csv(STUDY + 'Country_Selection.csv' , ';');
count_selec = stripblanks(count_selec);
for line = count_selec'
    if line(1) == 'Country' then
        country_name = line(2);
        country_iso = line(3);
    end
end

study_frames_country = STUDY + 'study_frames_' + country_iso + filesep();
data_country = DATA + 'data_' + country_iso + filesep();

simu_dir = study_frames_country + 'Simulations' + filesep();

// Get the name of the simulation
exec('def_simu_file_name.sce');

// Path
simu_path = simu_dir + simu_file_name;

// Fill the data structures
exec('Read_Simu.sce');


// ------------------------------------------------- *
// Save the files which may are going to be modified *
// ------------------------------------------------- *

// To earn time, use the code of Test_AllConfing
getd(TEST_FULLCODE);

// To save Country_Selection and Dashboards, in Test_AllConfig directory
mkdir(SAVED_DATA);

// Save the current Dashboard
dashboard_file_name = 'Dashboard_' + country_iso + '.csv';
save_file(dashboard_file_name, study_frames_country);

// Save all the SystemOpt Resol .csv
save_sys = 'Save_System_Resol' + filesep();
mkdir(save_sys);

// Save all the Var Resol files
save_var_resol = 'Save_Var_Resol' + filesep();
mkdir(save_var_resol);

// Save Recursive runchoice
save_rec_runchoice = 'Save_Rec_Runchoice' + filesep();
mkdir(save_rec_runchoice);


// --------------------------------- *
// Parameters to launch ImaclimS.sce *
// --------------------------------- *

// Enable TEST_MODE
TEST_MODE = %T;

// Parameters of the simulations
testing.countMax = 30;
testing.debug_mode = %T;

SIMU_MODE = %T;
Current_Simu_Name = '';

// -------------------------------- *
// Launch each simulation one by one *
// -------------------------------- *

for simu = simulation_list
    
    Current_Simu_Name = simu(simu_name_head);

    // ------------------------------------- *
    // Write the dashboard of the simulation *
    // ------------------------------------- *

    csvWrite(simu(dashboard_head), study_frames_country + dashboard_file_name, ';');

    // ---------------------------------------------------- *
    // Write the SystemOpt Resol csv file of the simulation *
    // ---------------------------------------------------- *

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
                // Read the initial file
                if find(listfiles(save_sys) == systopt_resol_name + '.csv') <> [] then
                    SystOpt_resol_Fun = read_csv(save_sys + systopt_resol_name + '.csv', ';');
                else
                    SystOpt_resol_Fun = read_csv(SYST_RESOL + systopt_resol_name + '.csv', ';');
                end

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

                // Save the initial SystemOpt Resol file
                list_saved_files = listfiles(save_sys);
                if find(list_saved_files == systopt_resol_name + '.csv') == [] then
                    copyfile(SYST_RESOL + systopt_resol_name + '.csv', save_sys);
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
    var_resol_file_name = stripblanks(SystOpt_resol_Fun(1,2)) + '.csv';
    
    // Read the initial file
    if find(listfiles(save_var_resol) == var_resol_file_name) <> [] then
        var_resol = read_csv(save_var_resol + var_resol_file_name, ';');
    else
        var_resol = read_csv(data_country + var_resol_file_name, ';');
    end
    
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

    // Save the initial Var Resol file
    list_saved_files = listfiles(save_var_resol);
    if find(list_saved_files == var_resol_file_name) == [] then
        copyfile(data_country + var_resol_file_name, save_var_resol);
    end

    // Write the new Var Resol file
    csvWrite(var_resol, data_country + var_resol_file_name, ';');


    // ------------------- *
    // Launch ImaclimS.sce *
    // ------------------- *

    rec_runchoices = 'Recursive_RunChoices.sce';

    // Do the sensibility tests
    if length(simu(sensib)) > 0 then
        for current_sensib = simu(sensib)

            // Name of the sensibility test
            sensib_name = current_sensib(1);
            current_sensib(1) = [];

            Current_Simu_Name = simu.Name + '_' + sensib_name;

            // Save recursive runchoice
            if listfiles(save_rec_runchoice) <> [] then
                error('There is already a recurive_runchoice saved, please remove it from : ' ..
                 + save_rec_runchoice)
            else
                copyfile(study_frames_country + rec_runchoices, save_rec_runchoice);
            end
            // Write the sensib
            // open a file as text with write property
            fd_w = mopen(study_frames_country + rec_runchoices,'wt');

            for line = current_sensib'
                // write a line in fd_w 
                mputl(line, fd_w);
            end
            mclose(fd_w);
            // Execute the code
            cd('..');
            try
                launch_ImaclimS();
            catch
                printf("simulation error")
            end
            cd(SIMUS);
            // Restore recursive runchoice
            movefile(save_rec_runchoice + rec_runchoices, study_frames_country);
        end
    else
        cd('..');
        try
            launch_ImaclimS();
        catch
            printf("simulation error")
        end
        cd(SIMUS);
    end

end


// -------------------------------------- *
// Restore the files which had been saved *
// -------------------------------------- *

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
