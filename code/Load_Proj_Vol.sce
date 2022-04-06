// Remove all entries of Proj_Vol 
clear Proj_Vol;

if part(Scenario,1:length("EmisObj"))=="EmisObj"
	// Check IOT_CO2EMIS_TimeStep's aggregation
	proj_desaggregated = ..
	and(IndexRow == IndRow_IOT_CO2Emis) & and(IndexCol == IndCol_IOT_CO2Emis(1:$-1));
else
	// Check IOT_CO2EMIS_TimeStep's aggregation
	proj_desaggregated = ..
	and(IndexRow == IndRow_IOT_Qtities) & and(IndexCol == IndCol_IOT_Qtities);
end

proj_well_aggregated = ..
and(IndexRow(1:nb_Sectors,:) == Index_Commodities) & and(IndexCol(:,1:nb_Sectors) == Index_Commodities');


// ------- *
// Headers *
// ------- *

if proj_desaggregated then
    Index_Sectors_IC = Index_SectInit;
	Index_Commo_IC = Index_CommoInit;
else
    Index_Sectors_IC = Index_Sectors;
	Index_Commo_IC = Index_Commodities;
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
if Country_ISO == 'FRA'
    file_name = 'ProjScenario'  + AGG_type + '.csv';
else
    file_name = 'Projections_Scenario.csv';
end
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
head_col.can_be_agg = 'Can be agg';

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

// Load data files

proj_files = [
    'Capital_Cons_' + Scenario, ..
    'Invest_Elec_' + Scenario, ..
    'Labour_' + Scenario
];

to_transpose = [
    'Capital_Cons_' + Scenario, ..
    'Labour_' + Scenario
];


	// load Y, may be needed for proj intens
Proj_Vol.Y.file = Proj_Vol.IC.file;
Proj_Vol.Y.headers = 'Y';
if ~Proj_Vol.IC.apply_proj & ( find("Capital_consumption"==fieldnames(Proj_Vol))<> [])
	if 	Proj_Vol.Capital_consumption.intens 
		Proj_Vol.Y.apply_proj = %T;
	else
		Proj_Vol.Y.apply_proj = Proj_Vol.IC.apply_proj;
	end
else 
	Proj_Vol.Y.apply_proj = Proj_Vol.IC.apply_proj;
end
Proj_Vol.Y.can_be_agg =%T;

for var = fieldnames(Proj_Vol)'

    if Proj_Vol(var).apply_proj then

        if Proj_Vol(var).file == 'IOT_Qtities' then
            iot_qtities = evstr('IOT_Qtities_' + Scenario + '_' + string(time_step));
			
		elseif Proj_Vol(var).file == 'IOT_CO2' then
            iot_co2emis = evstr('IOT_CO2_' + Scenario + '_' + string(time_step));

        elseif find(proj_files == Proj_Vol(var).file) then
                
            Proj_Vol(var).data = evstr(Proj_Vol(var).file);
            Proj_Vol(var).headline = evstr('headline(""' + Proj_Vol(var).file + '"")');
            Proj_Vol(var).headcol = evstr('headcol(""' + Proj_Vol(var).file + '"")');

            if or(Proj_Vol(var).headcol <> Proj_Vol(var).headers) then
                error('Years of ' + Proj_Vol(var).file + ' are not consistent with current working years.')
            end

        else 

            error('File name of ' + var + ' not known : ' + Proj_Vol(var).file);
            
        end

    end
end


for var = fieldnames(Proj_Vol)'
    if Proj_Vol(var).apply_proj then
        // Read IOT_Qtities
        if Proj_Vol(var).file == 'IOT_Qtities'
            
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
		elseif Proj_Vol(var).file == 'IOT_CO2'
            
            // IndexRow / IndexCol : Index of IOT_Qtities_TimeStep
            // IndRow_IOT_Qtities / IndCol_IOT_Qtities : Index of desagregated IOT
            // Index_Commodities : aggregated commodities
            // Index_CommoInit : desagregated commodities

            // If IOT_Qtities_TimeStep is not aggregated
            if proj_desaggregated then
                Proj_Vol(var).val = fill_table(iot_co2emis, IndexRow, IndexCol, Index_CommoInit, Proj_Vol(var).headers);
            // If IOT_Qtities_TimeStep is aggregated
            else
                // Check that the aggregation is fine
                if proj_well_aggregated then
                    Proj_Vol(var).val = fill_table(iot_co2emis, IndexRow, IndexCol, Index_Commodities, Proj_Vol(var).headers);
                else
                    error('Scenario aggregation is not consistent with working aggregation.');
                end
            end

        elseif find(proj_files == Proj_Vol(var).file) <> [] then
            
			    if proj_well_aggregated then
                    			Proj_Vol(var).val = fill_table(Proj_Vol(var).data, Proj_Vol(var).headline, Proj_Vol(var).headcol, ..
                Index_Commo_IC, Proj_Vol(var).headers(time_step));
                else
                    error('Scenario aggregation is not consistent with working aggregation.');
                end
			
			
            if find(to_transpose == Proj_Vol(var).file) <> [] then
                Proj_Vol(var).val = Proj_Vol(var).val';
            end

            if ~proj_desaggregated then
                warning('Desaggregated projection.')
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

            // Check that the variable can be aggregated
            if ~Proj_Vol(var).can_be_agg then
                error('The variable ' + var + ' cannot be projected in an aggregated mode.')
            end

            // Indexes of aggregation
            if (var == 'IC') | (var == "CO2Emis_IC") then

                agg_line = all_IND;
                agg_col = all_IND;
                
            elseif size(Proj_Vol(var).val,1) == nb_Sectors_ini ..
                & size(Proj_Vol(var).val,2) == 1 then

                agg_line = all_IND;
                agg_col = list([1]);
                
            elseif size(Proj_Vol(var).val,1) == 1 ..
                & size(Proj_Vol(var).val,2) == nb_Sectors_ini then

                agg_line = list([1]);
                agg_col = all_IND;
                
            else
                error('Projection of ' + var + ' needs a rule to aggregate the columns');
            end

            // Apply the aggregation
            Proj_Vol(var).val = aggregate(Proj_Vol(var).val, agg_line, agg_col);

        end
    end

end

function Proj_Vol = proj_intens(Proj_Vol, var_name, var_intens_name)
		
    Proj_Vol(var_intens_name) = Proj_Vol(var_name);
	// Y_copy_lines = ones(size(Proj_Vol(var_name).val,1), 1) * Proj_Vol.Y.val' + (Proj_Vol.Y.val'  == 0).*Y';
	Y_copy_lines = Proj_Vol.Y.val' + (Proj_Vol.Y.val'  == 0).*Y';
    if size(Proj_Vol(var_name).val,1) == nb_Sectors & size(Proj_Vol(var_name).val,2) == 1
        Proj_Vol(var_intens_name).val = Proj_Vol(var_name).val ./ Y_copy_lines';
    else
        Y_copy_lines = ones(size(Proj_Vol(var_name).val,1), 1).*. Y_copy_lines
    	Proj_Vol(var_intens_name).val = Proj_Vol(var_name).val ./ Y_copy_lines;
    end
	
	if var_name <> 'IC'
		for elt=1:size(Proj_Vol(var_name).val,"c")
			if 	Proj_Vol(var_name).val(elt) ./ Y_copy_lines(elt) <> 0 & Proj_Vol.Y.val(elt)==0
				warning(var_intens_name +' of sector '+Index_Sectors(elt)+ ' evaluated using Y of last step: projection of Y required.')
			end
		end
		
	else
		for elt=1:size(Proj_Vol(var_name).val,"c")
			if 	Proj_Vol.Y.val(elt)==0
				warning(var_intens_name+'s of sector '+Index_Sectors(elt)+ ' evaluated using Y of last step: projection of Y required.')
			end
		end

	end
	
    Proj_Vol(var_name).apply_proj = %F;

endfunction

// IC intensity projection
if find(fieldnames(Proj_Vol) == 'IC') <> [] then
    if Proj_Vol.IC.apply_proj & Proj_Vol.IC.intens then
        Proj_Vol = proj_intens(Proj_Vol, 'IC', 'alpha');
    end
end

// M/Y ratio (import intensity of production) projection
if find(fieldnames(Proj_Vol) == 'M') <> [] then
    if Proj_Vol.M.apply_proj & Proj_Vol.M.intens==%T then
        Proj_Vol = proj_intens(Proj_Vol, 'M', 'M_Y');
    end
end

// Labour intensity projection
if find(fieldnames(Proj_Vol) == 'Labour') <> [] then
    if Proj_Vol.Labour.apply_proj & Proj_Vol.Labour.intens then
        Proj_Vol = proj_intens(Proj_Vol, 'Labour', 'lambda');
    end
end

// Capital_consumption intensity projection
if find(fieldnames(Proj_Vol) == 'Capital_consumption') <> [] then
	if Proj_Vol.Capital_consumption.apply_proj & Proj_Vol.Capital_consumption.intens then
        Proj_Vol = proj_intens(Proj_Vol, 'Capital_consumption', 'kappa');
	end
end

// HH consumption projection in case HH != 1 and size(Proj_Vol.C.val,2) == 1
// prorata distribution on BY data
// if ~(nb_Households == size(Proj_Vol.C.val,2))
    // if size(Proj_Vol.C.val,2) == 1
        // Proj_Vol.C.ind_of_proj(1)(2) = 1 : nb_Households;
        // Proj_Vol.C.val = (ones(1,10) .*. Proj_Vol.C.val) .* BY.C ./ (ones(1,10) .*. ((sum(BY.C,'c') == 0) + (~(sum(BY.C,'c') == 0)) .* sum(BY.C,'c')));
    // else
       // warning("nb_Households BY = " + nb_Households + " and nb_Households proj = " + size(Proj_Vol.C.val,2) + " might be a case not implemented") 
    // end
// end

// Don't project Y
Y_obj = Proj_Vol.Y;
Proj_Vol.Y = null();

// Clear unuseful Proj_Vol entries

unuseful = [
    'file', ..
    'headers', ..
    'data', ..
    'hline', ..
    'hcol'
];

for var = fieldnames(Proj_Vol)'
    for elt = unuseful
        if find(fieldnames(Proj_Vol(var)) == elt) <> [] then
            Proj_Vol(var)(elt) = null();
        end
    end
end
