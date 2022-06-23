// ------------------------------------- *
// Read the csv defining the simulations *
// ------------------------------------- *

// Read the csv
simu_file = read_csv(simu_path, ';');

// Remove the blanks 
simu_file = stripblanks(simu_file);

// Remove empty lines and comments
lines_kept = [];
for i = 1:size(simu_file,1)
    // Empty line <-> The first 3 columns are empty
    if part(simu_file(i,1),1:2) <> '//' ..
        & (simu_file(i,1) <> '' | simu_file(i,2) <> '' | simu_file(i,3) <> '') ..
        then
        if lines_kept == [] then
            lines_kept = simu_file(i,:);
        else
            lines_kept($+1,:) = simu_file(i,:);
        end
    end
end
simu_file = lines_kept;


// ----------------------------------- *
// Split the file from each seperation *
// ----------------------------------- *

dash_simu_blocks = list();
size_sep = length(separation_head);

// Beginning of the first block
ind_deb = 1;

// Browse the file line by line
for i = 1:size(simu_file,1)
    // If the line i is a separation
    if part(simu_file(i,1), 1:size_sep) == separation_head then
        // Record the block before i
        dash_simu_blocks($+1) = simu_file(ind_deb:(i-1),:);
        // Beginning of the next block
        ind_deb = i+1;
    end
end
// Load the last block 
dash_simu_blocks($+1) = simu_file(ind_deb:$,:);


// ------------------------------------------- *
// Fill the data structures : treat each block *
// ------------------------------------------- *

for block = dash_simu_blocks

    // header of the block
    header = block(1,1);
    // specific name
    name_spec = block(1,2);
    // remove the header
    block(1,:) = [];

    // Treat each block specifically on its header
    select header

        // Dashboard
    case dashboard_head then
        // record the 2 first columns of dashboard block
        dashboard_def = block(:,1:2);

        // Functions
    case functions_head then
        // record the id and the definition of each function
        for fun = block'
            id = fun(1);
            functions_def(id) = fun(2:4)';
        end

        // Variables
    case variables_head then
        // record the name and the size of each variable
        for var = block'
            variables_def(var(1)) = var(2:3)';
        end

        // Simulations
    case simulation_head then
        
        first_col = block(:,1);
        // Number of categories to find
        nb_cat = size(simu_list_cat);
        // Index position of each category header
        ind_cat_head = list();
        for i = 1:nb_cat
            ind = find(first_col == simu_list_cat(i));
            if size(ind) == [1,1] then
                ind_cat_head($+1) = ind;
            elseif ind == []
                disp(block);
                error("""" + simu_list_cat(i) + """" + ' is not given for this simulation');
            else
                disp(block);
                error("""" + simu_list_cat(i) + """" + ' is defined several times for this simulation');
            end
        end
        
        // Sort the category list by increasing index
        for i = 2:nb_cat
            // List sorted between 1 and i-1
            ind = i;
            // Sort the list between 1 and i
            while (ind > 1 & ind_cat_head(ind-1) > ind_cat_head(ind))
                // Exhange values of ind and (ind-1)
                ind_temp = ind_cat_head(ind-1);
                cat_temp = simu_list_cat(ind-1);
                ind_cat_head(ind-1) = ind_cat_head(ind);
                simu_list_cat(ind-1) = simu_list_cat(ind);
                ind_cat_head(ind) = ind_temp;
                simu_list_cat(ind) = cat_temp;
                ind = ind - 1;
            end
        end
        
        // Record the simulation
        simu = struct();
        simu(simu_name_head) = name_spec;
        for i = 1:nb_cat
            // Record the block of data corresponding to category of header i
            ind_deb = ind_cat_head(i) + 1;
            if i < nb_cat then
                ind_fin = ind_cat_head(i+1) - 1;
            else
                ind_fin = $;
            end
            // Record the first 2 columns for dashboard, and only
            // the first column for the others
            if simu_list_cat(i) == dash_changes_head then
                col_kept = 2;
            else
                col_kept = 1;
            end
            simu(simu_list_cat(i)) = block(ind_deb:ind_fin,1:col_kept);
        end

        // Record the sensibilities to test
        sensib_list = list();
        current_sensib = [];
        for line = simu(sensib)'
            if line == sensib_sep then
                sensib_list($+1) = current_sensib;
                current_sensib = [];
            else
                current_sensib($+1) = line; 
            end
        end
        if current_sensib <> [] then
            sensib_list($+1) = current_sensib;
        end
        simu(sensib) = sensib_list;

        simulation_list($+1) = simu;
        
    else
        // If header is not in a case above
        error("""" + header + """" + ' is not defined as a header.');
    end
    
end


// ------------------------------------------ *
// Compute the dashboards of each simulations *
// ------------------------------------------ *

for i = 1:size(simulation_list)
    simu = simulation_list(i);
    
    // initial dashboard 
    dashboard = dashboard_def;
    // modifications to apply
    dash_changes = simu(dash_changes_head);
    
    for modif = dash_changes'
        dash_entry = modif(1);
        // Find the line to change
        ind = find(dashboard(:,1) == dash_entry);
        if size(ind) == [1,1] then
            // Apply the change
            dashboard(ind,2) = modif(2);
        else
            disp(dash_changes);
            error('In dash_changes of this simulation : ' + """" + dash_entry + """" + ' is not an header of Dashboard');
        end
    end
    // Record the modified dashboard
    simu(dashboard_head) = dashboard;
    
    simulation_list(i) = simu;
end


// ------------------------------------------------------------- *
// Replace the ID of functions and variables by its complete def *
// ------------------------------------------------------------- *

for i = 1:size(simulation_list)
    simu = simulation_list(i);
    
    // Fonctions
    for head_fun = [remove_fun_head, add_fun_head]
        
        real_fun = list();
        // For each ID, record the associated function
        for id = simu(head_fun)'
            ind_id = find(fieldnames(functions_def) == id);
            if size(ind_id) == [1,1] then
                real_fun($+1) = functions_def(id);
            else
                disp(simu(head_fun));
                error('In ' + """" + head_fun + """" + ', ' + """" + id + """" + ' is not an id of a function.');
            end
        end
        
        // Replace the id by the functions
        simu(head_fun) = real_fun;
    end
    
    // Variables
    for head_var = [remove_var_head, add_var_head]

        real_var = list();
        // For each var, record the associated complete variable def
        for var = simu(head_var)'
            ind_id = find(fieldnames(variables_def) == var);
            if size(ind_id) == [1,1] then
                real_var($+1) = [var, variables_def(var)];
            else
                disp(simu(head_var));
                error('In ' + """" + head_var + """" + ', ' + """" + var + """" + ' is not an id of a variable.');
            end
            
            // Record the var by the complete variables
            simu(head_var) = real_var;
        end
        
        // Record the modified simulation
        simulation_list(i) = simu;
    end
    
end
