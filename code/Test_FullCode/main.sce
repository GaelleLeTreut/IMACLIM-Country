// ************** *
// Initialization *
// ************** *

// Enable test_mode in ImaclimS.sce
TEST_MODE = %T;

// Parameters of the tests
testing.countMax = 2;
testing.mute_mode = %T;

// Paths of the directories
exec('Load_paths.sce');
mkdir(SAVED_DATA);

// Classes and functions
getd(TEST_FULLCODE);

// Data of the test
exec(TEST_FULLCODE + 'def_of_tests.sce');


// ************* *
// Run the tests *
// ************* *

// Save the current Country Selection file
save_file(country_selection, STUDY);

// Record the not working configurations
errors = list();

// launch the tests
for country = countries
    
    // Write Country_Selection.csv with the test country
    write_country_selection(country);
    
    // Save the current Dashboard_COUNTRY file
    save_file(country.dashboard_file, STUDY + country.study_frames);
    
    // List of all the dashboards to test
    dashboards = create_dashboards(country.dashboard);
    
    // Test each dashboard
    for dash = dashboards
        
        printf(country.name + '\n');
        for var = fieldnames(country.test)'
            ind = find(dash(:,1) == var);
            printf('    ' + var + ' = ' + dash(ind,2) + '\n');
        end
        
        printf('\nTESTING ..\n\n');

        // Write the dashboard to test
        csvWrite(dash, STUDY + country.study_frames + country.dashboard_file,";");
        
        // Run ImaclimS.sce. If an error is raised, save it
        cd(CODE);
        try
            launch_ImaclimS();
        catch
            printf('\n************** ERROR **************\n');
            errors($+1) = new_error(country,dash);
        end
        cd(TEST_FULLCODE);
        
        disp('-------------------------------------------');
        
    end
    
end


// ************************ *
// Display the errors found *
// ************************ *

nb_errors = size(errors);
error_count = 0;

for err = errors
    
    // Counter of errors
    error_count = error_count + 1;
    disp('ERROR ' + string(error_count) + ' / ' + string(nb_errors) + ' :');
    
    // Country of the error
    disp('Country : ' + err.country_name + ' / ' + err.country_ISO);
    
    // Dashboard
    disp('Dashboard :');    
    disp(err.dashboard);
    
    disp('* --------------------------------------------------- *');
    
end


// **************************************************** *
// Restore the initial Country_Selection and Dashboards *
// **************************************************** *

exec('restore_saved_files.sce');
