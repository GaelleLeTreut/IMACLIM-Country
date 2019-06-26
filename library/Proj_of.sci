function proj_of_var = Proj_of(var)
    // Returns the column of IOT_Qtities_+"time_step" whose header is var
    // -> this column is aggregated if ToAggregate is True

    if size(var,"c") <> 1 | size(var,"r") <> 1 then
        error("arg of Proj_of needs to be a string")
    end

    // Load the file of projections
    execstr("IOT_Qtities_time = IOT_Qtities_" + time_step); 

    // Read the column whose header is var
    // TODO : faire un unique cas
    if ScenAgg_IOT then 
        proj_of_var = fill_table(IOT_Qtities_time, IndexRow, IndCol_IOT_Qtities, Index_CommoInit, var);
    elseif ToAggregate == "True" then
        // proj_of_var = fill_table(IOT_Qtities_time, IndRow_IOT_Qtities, IndCol_IOT_Qtities, Index_CommoditiesTEMP, var);
        proj_of_var = fill_table(IOT_Qtities_time, IndRow_IOT_Qtities, IndCol_IOT_Qtities, Index_CommoInit, var);
    elseif ToAggregate == "False" then
        proj_of_var = fill_table(IOT_Qtities_time, IndexRow, IndexCol, Index_Commodities, var);
    else
        error("Wrong value for ""ToAggregate""")
    end

    // if needed, aggregate the column
    if ToAggregate == "True" then
        proj_agg = zeros(nb_SectorsAGG,1);
        for line = 1:nb_SectorsAGG
            proj_agg(line) = sum(proj_of_var(all_IND(line)));
        end
        proj_of_var = proj_agg;
    end

endfunction
