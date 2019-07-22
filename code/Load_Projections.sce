// ------------------------- *
// Load projection structure *
// ------------------------- *

// Parameter's file
file_name = 'Projections_Scenario.csv';
proj_file = STUDY_Country + file_name;

// Read the parameter's file
// [headers columns , headers rows , values]
[param_names, proj_variables, param_values] = read_csv_table(proj_file,';');

// Check if the headers are consistent
head_col.file = 'file';
head_col.headers = 'headers';
head_col.ind_of_proj = 'indexes_of_proj';
head_col.apply_proj = 'apply_the_proj';

for param = fieldnames(head_col)'
    ind_of(param) = find(param_names == head_col(param));
end

for param = fieldnames(head_col)'
    if ind_of(param) == [] then
        error('Problem of consistence between headers columns of ' + file_name);
    end
end

function proj_var = new_proj(param_val)
    for param = fieldnames(head_col)'
        proj_var(param) = evstr(param_val(ind_of(param)));
    end
endfunction

nb_var = size(proj_variables,1);
for i = 1:nb_var
    var = proj_variables(i);
    param_val = param_values(i,:);
    Proj(var) = new_proj(param_val);
end


// -------------------- *
// Load projection data *
// -------------------- *

for var = fieldnames(Proj)'
    proj_param = Proj(var);
    if proj_param.apply_proj then
        execstr('proj_values = ' + proj_param.file + '_' + string(time_step));
        if Country <> 'France' then
            proj_val = fill_table(proj_values, IndRow_IOT_Qtities, IndCol_IOT_Qtities, Index_CommoInit, proj_param.headers);
        else
            proj_val = fill_table(proj_values, IndexRow, IndexCol, Index_Commodities, proj_param.headers);
        end
        Proj(var).val = proj_val;
        //    else
        //        Proj(var) = null();
    end
end


// ------------------------------------ *
// If needed, aggregate the projections *
// ------------------------------------ *

if AGG_type <> '' & Country <> 'France' then

    for var = fieldnames(Proj)'
        if Proj(var).apply_proj then
            if var == 'IC' then
                Proj(var).val = aggregate(Proj(var).val, all_IND, all_IND);
            elseif size(Proj(var).val,2) == 1 then
                Proj(var).val = aggregate(Proj(var).val, all_IND, list(1));
            else
                error('Projection of 'var + ' needs a rule to aggregate the columns');
            end
        end
    end

end


// ---------------------- *
// Clear unused variables *
// ---------------------- *

clear file_name proj_file param_names proj_variables param_values head_col ind_of nb_var param var param_val proj_param proj_val;

