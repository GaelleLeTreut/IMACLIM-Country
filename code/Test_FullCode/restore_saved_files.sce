// ---------------------------------- *
// This code can be run undependantly *
// ---------------------------------- *


// -------------- *
// Initialization *
// -------------- *

// Load the paths of the directories
exec('Load_paths.sce');

// Load the data of countries tested
if ~isdef('TEST_MODE') then
    getd(TEST_FULLCODE);
end
exec(TEST_FULLCODE + 'def_of_tests.sce');

// Load the files to restore
saved_files = listfiles(SAVED_DATA);


// ---------------------- *
// Restore the saved file *
// ---------------------- *

disp('Files restored : ');

// Restore Country_Selection

restore_file(country_selection, STUDY);

// Restore the dashboards

for country = countries
    restore_file(country.dashboard_file, STUDY + country.study_frames);
end

// If other file in saved_data, it needs to be restore but hadn't been

if listfiles(SAVED_DATA) <> [] then
    disp('Files cannot be restored in ' + SAVED_DATA' + ' : ');
    disp(listfiles(SAVED_DATA));
    error('');
end
