// -------------------- *
// Load projection data *
// -------------------- *

iot_qtities = eval('IOT_Qtities_' + string(time_step));
prod_factors = eval('prod_factors_' + string(time_step));
prod_factors_hline = eval('prod_factors_' + string(time_step) + '_hline');
prod_factors_hcol = eval('prod_factors_' + string(time_step) + '_hcol');

// Check IOT_Qtities_TimeStep's aggregation
proj_desaggregated = ..
and(IndexRow == IndRow_IOT_Qtities) & and(IndexCol == IndCol_IOT_Qtities);

proj_well_aggregated = ..
and(IndexRow(1:nb_Sectors,:) == Index_Commodities) & and(IndexCol(:,1:nb_Sectors) == Index_Commodities');


// ------- *
// Headers *
// ------- *

if proj_desaggregated then
    Index_Sectors_IC = Index_SectInit;
else
    Index_Sectors_IC = Index_Sectors;
end

if nb_Households == 1 then
    Index_Headers_H = 'C';
else
    Index_Headers_H = Index_Households;
end


// ------------------------- *
// Load projection structure *
// ------------------------- *

// Parameter's file
file_name = 'Projections_Scenario.csv';
proj_file = STUDY_Country + file_name;

// Read the parameter's file
// [headers columns , headers rows , values]
[param_names, proj_variables, param_values] = read_csv_table(proj_file,';');

// Define and check if the headers are consistent
head_col.file = 'file';
head_col.headers = 'headers';
head_col.ind_of_proj = 'indexes_of_proj';
head_col.apply_proj = 'apply_the_proj';
head_col.intens = 'Intens';

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
    Proj_Vol(var) = new_proj(param_val);
end


// ---------------------- *
// Fill projection's data *
// ---------------------- *


// load Y, may be needed for proj intens
Proj_Vol.Y.file = Proj_Vol.IC.file;
Proj_Vol.Y.headers = 'Y';
Proj_Vol.Y.apply_proj = Proj_Vol.IC.apply_proj;

for var = fieldnames(Proj_Vol)'
    if Proj_Vol(var).apply_proj then
        // Read IOT_Qtities
        if Proj_Vol(var).file == 'IOT_Qtities' then
            
            // IndexRow / IndexCol : Index of IOT_Qtities_TimeStep
            // IndRow_IOT_Qtities / IndCol_IOT_Qtities : Index of desagregated IOT
            // Index_Commodities : aggregated commodities
            // Index_CommoInit : desagregated commodities

            // If IOT_Qtities_TimeStep is not aggregated
            if proj_desaggregated then
                Proj_Vol(var).val = fill_table(iot_qtities, IndexRow, IndexCol, Index_CommoInit, Proj_Vol(var).headers);
            // If IOT_Qtities_TimeStep is aggregated
            else
                // Check that the aggregation is fine
                if proj_well_aggregated then
                    Proj_Vol(var).val = fill_table(iot_qtities, IndexRow, IndexCol, Index_Commodities, Proj_Vol(var).headers);
                else
                    error('Scenario aggregation is not consistent with working aggregation.');
                end
            end
        elseif Proj_Vol(var).file == 'prod_factors' then
            if proj_desaggregated then
                Proj_Vol(var).val = fill_table(prod_factors, prod_factors_hcol, prod_factors_hline, ..
                                                var, Proj_Vol(var).headers);
            else
                if proj_well_aggregated then
                    Proj_Vol(var).val = fill_table(prod_factors, prod_factors_hcol, prod_factors_hline, ..
                                                    var, Proj_Vol(var).headers);
                else
                    error('Scenario aggregation is not consistent with working aggregation.');
                end
            end
        else
            error('You need to define how to read the projection file ' + Proj_Vol(var).file + ' for projection of ' + var)
        end
    end
end

// ------------------------------------ *
// If needed, aggregate the projections *
// ------------------------------------ *

if AGG_type <> '' & proj_desaggregated then

    nb_Sectors_ini = size(Index_CommoInit,1);

    for var = fieldnames(Proj_Vol)'
        if Proj_Vol(var).apply_proj then
            if var == 'IC' then
                Proj_Vol(var).val = aggregate(Proj_Vol(var).val, all_IND, all_IND);
            elseif size(Proj_Vol(var).val,1) == nb_Sectors_ini ..
                & size(Proj_Vol(var).val,2) == 1 then
                Proj_Vol(var).val = aggregate(Proj_Vol(var).val, all_IND, list(1));
            elseif size(Proj_Vol(var).val,1) == 1 ..
                & size(Proj_Vol(var).val,2) == nb_Sectors_ini then
                Proj_Vol(var).val = aggregate(Proj_Vol(var).val, list(1), all_IND);
            else
                error('Projection of ' + var + ' needs a rule to aggregate the columns');
            end
        end
    end

end

function Proj_Vol = proj_intens(Proj_Vol, var_name, var_intens_name)

    warning(var_intens_name + ' est calculé à partir de Y initial : il faut la projection de Y.'),
    Proj_Vol(var_intens_name) = Proj_Vol(var_name);
    Y_copy_lines = ones(size(Proj_Vol(var_name).val,1), 1) * (1.1 * Y');
    Proj_Vol(var_intens_name).val = Proj_Vol(var_name).val ./ Y_copy_lines;
    Proj_Vol(var_name).apply_proj = %F;

endfunction

// IC intensity projection
if Proj_Vol.IC.intens then
	Proj_Vol = proj_intens(Proj_Vol, 'IC', 'alpha');
end

// Labour intensity projection
if Proj_Vol.Labour.intens then
	Proj_Vol = proj_intens(Proj_Vol, 'Labour', 'lambda');
end

// Capital_consumption intensity projection
if Proj_Vol.Capital_consumption.intens then
	Proj_Vol = proj_intens(Proj_Vol, 'Capital_consumption', 'kappa');
end
// Don't project Y
Proj_Vol.Y = null();