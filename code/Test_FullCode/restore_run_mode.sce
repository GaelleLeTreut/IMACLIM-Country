// TODO : remettre à niveau avec les nouvelles fonctions / def_of_tests etc 

// TODO : Dashboards dans gitignore

// load the paths
if ~isdef('CODE') then
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
end

// load the names
exec(TEST_FULLCODE + 'working_files.sce');

saved_files = listfiles(SAVED_DATA);

function restore_country(country)
    if find(saved_files == country.dashboard) <> [] then
        movefile(SAVED_DATA + country.dashboard, STUDY + country.study_frames + sep + country.dashboard);
        disp(country.dashboard + ' restored');
    end
endfunction

if find(saved_files == country_selection) <> [] then
    movefile(SAVED_DATA + country_selection, STUDY + country_selection);
    disp(country_selection + ' restored');
end

countries = [argentina, brasil, france];
for i = 1:3
    restore_country(countries(i));
end

if listfiles(SAVED_DATA) <> [] then
    error('Undesirable files in ' + SAVED_DATA);
end
