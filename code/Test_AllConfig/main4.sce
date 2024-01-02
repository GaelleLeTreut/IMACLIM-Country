// TODO : mode output en supprimant le fichier outputs créé

// -------------- *
// Initialization *
// -------------- *

/// Selection of def of test files
// def_test_file = 'def_of_tests.sce';
def_test_file = 'def_of_MacroIncFRA.sce';

// Enable TEST_MODE in ImaclimS.sce
TEST_MODE = %F;

SCENARIO_INCREMENT = %T;

// Parameters of the tests
testing.countMax = 3;
testing.debug_mode = %F;

// ---------------------- *
// Structure of directory *
// ---------------------- *

// Paths of the directories
exec('Load_paths.sce');

// To save Country_Selection and Dashboards
mkdir(SAVED_DATA);

// Name of this tests run
funcprot(0);
exec(LIB + 'tools.sci');
funcprot(1);
RunName = 'Run_' + mydate();

// To save the not working Dashboards
Not_working_name = 'Not_working_dashboards';
NOT_WORKING = TEST_FULLCODE + Not_working_name + filesep();
mkdir(NOT_WORKING);
mkdir(NOT_WORKING + RunName);


// --------- *
// Code data *
// --------- *

// Classes and functions
getd(TEST_FULLCODE);

// Data for the tests
exec(TEST_FULLCODE + def_test_file);


// ------------- *
// Run the tests *
// ------------- *

// Save the current Country Selection file
save_file(country_selection, STUDY);

// launch the tests

nb_errors = 0;
// nb_tests = 0;
load("C:\Users\douda\Documents\GitHub\IMACLIM-Country\code\Test_AllConfig\dashboards.dat")
group = list(121:160)

for country = countries
    
    // Write Country_Selection.csv of the tested country
    write_country_selection(country);
    
    // Save the current Dashboard_COUNTRY file
    save_file(country.dashboard_file, STUDY + country.study_frames);
    
    // // List of all the dashboards to test
    // dashboards = create_dashboards(country.dashboard);
    
    // Test each dashboard
    for i = group(1)

        nb_tests = i

        dash = dashboards(i)
        
        // Display the current test information
        printf('%s\n', country.name);
        for var = fieldnames(country.test)'
            ind = find(dash(:,1) == var);
            printf('    %s = ""%s""\n', var, dash(ind,2));
        end
        
        printf('\nTESTING ..\n\n');

        // Write the dashboard to test
        csvWrite(dash, STUDY + country.study_frames + country.dashboard_file,";");
        
        // Run ImaclimS.sce. If an error is raised, save the dashboard
        cd(CODE);
        try
            launch_ImaclimS();
        catch
            printf('\n************** ERROR **************\n');
            nb_errors = nb_errors + 1;
            csvWrite(dash, NOT_WORKING + RunName + filesep() + ..
            string(nb_tests) + '_' + country.dashboard_file,";");
        end
        cd(TEST_FULLCODE);
        
        disp('-------------------------------------------');
        
    end
    
end


// -------------------------------- *
// Display the results of the tests *
// -------------------------------- *

disp('Tests made : ' + string(nb_tests));
disp('      - Successful tests : ' + string(nb_tests - nb_errors));
disp('      - Failed tests : ' + string(nb_errors));

disp('Find the not working dashboards in ' + NOT_WORKING + RunName);


// ---------------------------------------------------- *
// Restore the initial Country_Selection and Dashboards *
// ---------------------------------------------------- *

exec('restore_saved_files.sce');
