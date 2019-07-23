// ------------------------------- *
// Structure for testing a country *
// ------------------------------- *

function country = new_country(name, iso, test)
    // init : structure of initial values of the country
    // test : stucture of tests to perform
    // country : structure ready to launch the tests of the country

    country = struct();
    
    country.name = name;
    country.iso = iso;
    
    // tests to perform
    country.test = test;

    // dashboard file's name
    country.dashboard_file = 'Dashboard_' + country.iso + '.csv';
    
    // study_frames directory's name
    country.study_frames = 'study_frames_' + country.iso + filesep();

    // dashboard's structure
    country.dashboard = new_default_dashboard();

    // check test's inputs are dashboard's inputs
    for var = fieldnames(test)'
        if find(fieldnames(country.dashboard) == var) == []
            error('""' + var + '""' + ' is not an entry of Dashboard' + ..
            ' : defining ' + name + ' in def_of_tests.sce : ');
        end
    end

    // fill dashboard with test's values
    tests_inputs = fieldnames(country.test);
    for name = tests_inputs'
        country.dashboard(name) = country.test(name);
    end

endfunction
