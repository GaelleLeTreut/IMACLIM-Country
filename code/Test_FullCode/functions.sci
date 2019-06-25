function save_file(name, path)
    list_saved_files = listfiles(SAVED_DATA);
    if find(list_saved_files == name) == [] then
        movefile(path + name, SAVED_DATA + name);
    end
endfunction

function restore_file(name, path)
    list_saved_files = listfiles(SAVED_DATA);
    if find(list_saved_files == name) <> [] then
        movefile(SAVED_DATA + name, path + name);
    end
endfunction

function restore_saved_files()
    // TODO : Cas par cas -> restaure country selection et les dashboards
    // TODO : plutôt un fichier de nettoyage à appeler à la fin mais aussi si on coupe le programme avant la fin
endfunction

function select_country(country)
    csv = ['Component', 'Name', ''; ..
    'Country', country.name, country.iso];
    csvWrite(csv, STUDY + country_selection, ';');
endfunction

function dashboards = create_dashboards(default_dashboard)
    head = 'h';
    dashboards = [struct(head,['// *** Careful ', 'first line deleted by the program ***'])];
    inputs = fieldnames(default_dashboard);
    for var = inputs'
        values = default_dashboard(var);
        nb_values = size(values,2);
        nb_dashboards = size(dashboards,1);
        new_dashboards = [struct()];
        for i = 1:nb_values
            for j = 1:nb_dashboards
                dash = dashboards(j);
                tab = dash(head);
                tab($+1,1) = var;
                tab($,2) = values(i);
                dash(head) = tab;
                dash(var) = values(i);
                ind = (i-1)*nb_dashboards+j; 
                new_dashboards(ind) = dash;
            end
        end
        dashboards = new_dashboards;
    end
endfunction

function err = new_err(country)
    err = struct();
    err.country = country;
endfunction

function test_ImaclimS()
    exec('ImaclimS.sce');
endfunction


