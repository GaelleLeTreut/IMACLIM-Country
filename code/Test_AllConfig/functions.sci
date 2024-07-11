function save_file(name_file, path)
    // If it is not already saved, save the file named *name_file*.
    // This file is taken in *path*.
    
    list_saved_files = listfiles(SAVED_DATA);
    if find(list_saved_files == name_file) == [] then
        movefile(path + name_file, SAVED_DATA + name_file);
    end
    
endfunction

function restore_file(name_file, path)
    // If the file named *name_file* is saved, replace it in its
    // origin *path*.
    
    list_saved_files = listfiles(SAVED_DATA);
    if find(list_saved_files == name_file) <> [] then
        movefile(SAVED_DATA + name_file, path + name_file);
        disp('  - ' + name_file + ' well restored !')
    end
    
endfunction

function write_country_selection(country)
    // Define and save the file Country_Selection.csv in which the
    // country enabled is *country*.
    
    // Define Country_Selection.csv
    csv = ['Component', 'Name', ''; ..
    'Country', country.name, country.iso];
    
    // Write it in study_frames
    csvWrite(csv, STUDY + country_selection, ';');
    
endfunction

function dashboards = create_dashboards(dashboard_country)
    // Returns *dashboards*, the list of all the dashboards to test.
    // Inputs : *dashboard_country*, defined in def_of_tests.sce
    // (from Class_country.sce).
    
    // Be careful, a first line is needed since it is deleted by
    // the code
    dashboards = list(['Component', 'Name']);
    
    // variables of dashboard
    dash_var = fieldnames(dashboard_country);
    
    // Add the variables one by one
    for var = dash_var'
        
        // Cross the current partial dashboards with the different
        // values taken by the variable
        
        new_dashboards = list();
        
        values = dashboard_country(var);
        for val = values
            for dash = dashboards
                dash($+1,1) = var;
                dash($,2) = val; 
                new_dashboards($+1) = dash;
            end
        end
        
        // dashboards in which we added var and its values
        dashboards = new_dashboards;
        
    end
    
endfunction

function launch_ImaclimS()
    // Launch the program ImaclimS.sce.
    // Everything defined in this program is erased at the end of
    // this function.
    
    exec('ImaclimS.sce');
    
endfunction

function skip_calib(skip_calibration)

    printf('%s\n', '1');
    if ~skip_calibration
        printf('%s\n', '1');
        // Get all variable names before calibration
        save('sauvegarde_variables_pre_calibration');
        [variable_names,types,dims,vols] = listvarinfile('sauvegarde_variables_pre_calibration');
        printf('%s\n', '2');
        // Execute Calibration.sce
        exec("Calibration.sce");
        
        // Get all variable names after calibration
        save('sauvegarde_variables_post_calibration');
        [variable_names2,types,dims,vols] = listvarinfile('sauvegarde_variables_post_calibration');
        printf('%s\n', '3');
        // Function to check if a string is in a list
        function [res] = check_string_in_list(list, string)
            for i=1:length(length(list))
                if list(i) == string then
                    res = %t;
                    return;
                end
            end
            res = %f;
        endfunction
        
        // Select every variable created in calibration
        variables_to_load = []
        printf('%s\n', '4');
        for i = 1:length(length(variable_names2))
            if ~check_string_in_list(variable_names, variable_names2(i)) then
                variables_to_load = [variables_to_load, variable_names2(i)];
            end
        end
        pause
        // Save all variables created in calibration. It creates a binary file in IMACLIM-Country/code/
        printf('%s\n', 'test1');
        save('sauvegarde_variables_post_calibration', variables_to_load);
        printf('%s\n', 'test2');
    else
        printf("Calibration skipped \n");
        // Load all variables created in calibration
        load('sauvegarde_variables_post_calibration');
    end

endfunction