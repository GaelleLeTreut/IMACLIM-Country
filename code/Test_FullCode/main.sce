// TODO : un clean au début pour pouvoir relancer le code de zéro

// TODO : affichage -> mute ImaclimS sauf calibration .. et résolution ..

TEST_MODE = %T;

// Parameters of the tests
testing.countMax = 2;
testing.mute_mode = %T;

// enable or disable the mute mode
if testing.mute_mode then
    testing.out = 0;
else
    testing.out = %io(2);
end

// Load the paths of the files
try
    exec('Load_file_structure.sce');
catch
    try
        cd('..');
        exec('Load_file_structure.sce');
        cd(TEST_FULLCODE);
    catch
        error('You need to be in the directory ''code'' or ''Test_FullCode''');
    end
end

// load the data of the test
exec(TEST_FULLCODE + 'def_of_tests.sce');

// load the functions
exec(TEST_FULLCODE + 'functions.sci');

// launch the tests
//errs = launch_tests(argentina);

    // TODO : teste la configuration de départ
    // TODO : crée le country_selection avec le bon pays
    //errors = [struct()];

function err = new_error(country,dash)
    err = struct();
    err.country_name = country.name;
    err.country_ISO = country.iso;
//    err.mess_err = lasterror();
    err.tests = country.test;
//    pause;
    for var = fieldnames(err.tests)'
        err.tests(var) = dash(var);
    end
    //pause;
endfunction

errors = [struct()];
err_ind = 0;

nb_countries = size(countries,2);

save_file(country_selection, STUDY);

for k = 1:nb_countries
    // TODO : select country    
    country = countries(k);
    select_country(country);
    save_file(country.dashboard_file, STUDY + country.study_frames);
    dashboards = create_dashboards(country.dashboard);
    nb_dashboards =  size(dashboards,1);
    for i = 1:nb_dashboards
        disp('COUCOU 2222222222222222');
        //pause;
        dash = dashboards(i).h;
        csvWrite(dash, STUDY + country.study_frames + country.dashboard_file,";");
        cd(CODE);
        //pause;
        try
//            pause
            test_ImaclimS();
            disp('******************** NO PROBLEM !!! =D ********************');
        catch
            disp('************************** ERROR **************************');
//            pause;
            errors($+1) = new_error(country,dashboards(i));
//            pause;
        end
        disp("COUCOU 11111111111111111");
        cd(TEST_FULLCODE);
    end
end

nb_errors = size(errors,1);
for i = 1:nb_errors
    disp('* -------------------------------------------------------------- *');
    err = errors(i);
    disp('ERROR ' + string(i) + ' / ' + string(nb_errors) + ' :');
    //pause;
//    disp('error : ' + err.mess_err);
    disp('Country : ' + err.country_name + ' / ' + err.country_ISO);
    disp('Dashboard specificities : ');
    vars = fieldnames(err.tests);
    for var = vars
        disp('   - ' + var + ' = ""' + err.tests(var) + """");
    end
end

restore_saved_files();

// TODO : avant de faire les sauvegardes, tester les configurations actuelles de chaque pays

// TODO : save Country_Selection.csv

// TODO : afficher default dashboard puis spécifique features s'il y a des erreurs, sinon mettre un message gentil


//////////////////////////////////////////////////////////////////////////////
// Save Country_Selection if it is not already saved
//try
//    movefile(STUDY + 'Country_Selection.csv', SAVED_DATA + 'Country_Selection.csv');
//    // Function for tests of ImaclimS.sce :
//end
//try
//    movefile(STUDY + france.study_frames + sep + france.dashboard, SAVED_DATA + france.dashboard);
//    // Launch the mode test
//end

// Save the Dashboard if it is not already saved
///////////////////////////////////////////////////////////////////////////////


// in a function
//Arg.full_dashboard = new_default_dashboard();
//Arg.full_dashboard.Scenario = ['','NDC','CCS'];
//
//Arg.dashboards = create_dashboards(Arg.full_dashboard);
//for i = 1:size(Arg.dashboards,1)
//    csvWrite(Arg.dashboards(i).h,'test_Dashboards_' + Arg.Country_ISO + '_' + string(i) + '.csv',';');
//end





//warning('off');
//exec('ImaclimS.sce');
//warning('on');
