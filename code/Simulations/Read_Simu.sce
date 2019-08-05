simu_file = read_csv(simu_path, ';');

// remove blanks
simu_file = stripblanks(simu_file);

// remove empty lines and comments
remove_comments = [];
for i = 1:size(simu_file,1)
    // empty line <-> the first 3 columns are empty
    if part(simu_file(i,1),1:2) <> '//' ..
        & (simu_file(i,1) <> '' | simu_file(i,2) <> '' | simu_file(i,3) <> '') ..
        then
        if remove_comments == [] then
            remove_comments($,:) = simu_file(i,:);
        else
            remove_comments($+1,:) = simu_file(i,:);
        end
    end
end
simu_file = remove_comments;

// Load data

// Split the file at each seperation
dash_simu_parts = list();

ind_deb = 1;

size_sep = length(separation_head);

for i = 1:size(simu_file,1)
    if part(simu_file(i,1), 1:size_sep) == separation_head then
        dash_simu_parts($+1) = simu_file(ind_deb:(i-1),:);
        ind_deb = i+1;
    end
end
// load the last block 
dash_simu_parts($+1) = simu_file(ind_deb:$,:);

// fill the data structures for the simulations
for block = dash_simu_parts
    header = block(1,1);
    block(1,:) = [];
    select header
    case country_head then 
        // Country Selection
        if size(block,1) == 1 then
            country_simu($+1,:) = block(1,1:3);
        else
            error("""" + country_head + """" + ' has to be defined in 1 line');
        end
    case dashboard_head then
        // Dashboard
        dashboard_simu = block(:,1:2);
    case functions_head then
        // Functions
        for fun = block'
            id = fun(1);
            functions_simu(id) = fun(2:4)';
        end
    case variables_head then
        for var = block'
            variables_simu(var(1)) = var(2:3)';
        end
    case simulations_head then
        // Simulations
        columns = block(:,1);
        ind_cat = list();
        nb_cat = size(simu_cat,2);
        for i = 1:nb_cat
            ind = find(columns == simu_cat(i));
            if size(ind) == [1,1] then
                ind_cat($+1) = ind;
            elseif ind == []
                disp(block);
                error("""" + simu_cat(i) + """" + ' is not given for this simulation');
            else
                disp(block);
                error("""" + simu_cat(i) + """" + ' is defined several times for this simulation');
            end
        end
        // sort the list by increasing index
        for i = 2:nb_cat
            ind = i;
            while (ind > 1 & ind_cat(ind-1) > ind_cat(ind))
                ind_temp = ind_cat(ind-1);
                cat_temp = simu_cat(ind-1);
                ind_cat(ind-1) = ind_cat(ind);
                simu_cat(ind-1) = simu_cat(ind);
                ind_cat(ind) = ind_temp;
                simu_cat(ind) = cat_temp;
                ind = ind - 1;
            end
        end
        // record the simulation
        simu = struct();
        for i = 1:nb_cat
            ind_deb = ind_cat(i) + 1;
            if i < nb_cat then
                ind_fin = ind_cat(i+1) - 1;
            else
                ind_fin = $;
            end
            // Record the first 2 columns for dashboard, and only
            // the first column for the others
            if simu_cat(i) == simu_dash then
                col_kept = 2;
            else
                col_kept = 1;
            end
            simu(simu_cat(i)) = block(ind_deb:ind_fin,1:col_kept);
        end
        simulations($+1) = simu;
    else
        // if header is not consistent
        error("""" + header + """" + ' is not defined as a header');
    end
end

// Record the dashboards of each simulations
for i = 1:size(simulations)
    simu = simulations(i);
    dash_changes = simu(simu_dash);
    dashboard = dashboard_simu;
    for line = dash_changes'
        head = line(1);
        ind = find(dashboard(:,1) == head);
        if size(ind) == [1,1] then
            dashboard(ind,2) = line(2);
        else
            disp(simu)
            error('In dash change of this simulation : ' + """" + head + """" + ' is not an header of Dashboard');
        end
    end
    simu(dashboard_head) = dashboard;
    simulations(i) = simu;
end

// Associe les valeurs aux numéros lus
for i = 1:size(simulations)
    simu = simulations(i);
    // Fonctions
    for head_fun = [simu_remove, simu_add]
        simu_head_fun = list();
        for id = simu(head_fun)'
            ind_id = find(fieldnames(functions_simu) == id);
            if size(ind_id) == [1,1] then
                simu_head_fun($+1) = functions_simu(id);
            else
                disp(simu(head_fun));
                error('In ' + """" + head_fun + """" + ', ' + """" + id + """" + ' is not an id of a function.');
            end
        end
        simu(head_fun) = simu_head_fun;
    end
    // Variable
    for head_var = [remove_var, add_var]
        simu_head_var = list();
        for var = simu(head_var)'
            ind_id = find(fieldnames(variables_simu) == var);
            if size(ind_id) == [1,1] then
                simu_head_var($+1) = [var, variables_simu(var)];
            else
                disp(simu(head_var));
                error('In ' + """" + head_var + """" + ', ' + """" + var + """" + ' is not an id of a variable.');
            end
            simu(head_var) = simu_head_var;
        end
        simulations(i) = simu;
    end
end
