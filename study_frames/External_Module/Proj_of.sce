function proj_agg = Proj_of(var)
    // Returns the column of IOT_Qtities_+"time_step" whose header is var
    // -> this column is aggregated if ToAggregate is True

    execstr("IOT_Qtities_time = IOT_Qtities_" + time_step); 

    if size(var,"c") <> 1 | size(var,"r") <> 1 then
        error("arg of Proj_of needs to be a string")
    end

    if ScenAgg_IOT then 
        proj_desagg = fill_table(IOT_Qtities_time, IndexRow, IndCol_IOT_Qtities, Index_CommoInit, var);
    elseif ToAggregate == "True" then
        proj_desagg = fill_table(IOT_Qtities_time, IndRow_IOT_Qtities, IndCol_IOT_Qtities, Index_CommoditiesTEMP, var);
    elseif ToAggregate == "False" then
        proj_desagg = fill_table(IOT_Qtities_time, IndexRow, IndexCol, Index_Commodities, var);
    else
        error("Wrong value for ""ToAggregate""")
    end

    if ToAggregate == "True" then
        proj_agg = zeros(nb_SectorsAGG,1);
        for line = 1:nb_SectorsAGG
            proj_agg(line) = sum(proj_desagg(all_IND(line)));
        end
    else
        proj_agg = proj_desagg;
    end
    
endfunction
