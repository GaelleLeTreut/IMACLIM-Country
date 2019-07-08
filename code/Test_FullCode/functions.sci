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


