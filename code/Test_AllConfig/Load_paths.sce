
try
    cd('..');
    exec('Load_file_structure.sce');
    cd(TEST_FULLCODE);
catch
    error('You need to be in the directory ""Test_FullCode""');
end

// Country_Selection file
country_selection = 'Country_Selection.csv';
