if Scenario<>"" then

// If ScenAgg_IOT==%T , data are loaded in loadind data because there are a the size of maxmimun sectoral granularity and are aggregated 
	if ScenAgg_IOT==%F 
	
		// data treatment
		if ToAggregate=="True"
		C_proj = zeros(nb_SectorsTEMP);
		execstr("C_proj = fill_table(IOT_Qtities_"+time_step+ ",IndRow_IOT_Qtities,IndCol_IOT_Qtities,Index_CommoditiesTEMP,""C"");");
		end
		
		if ToAggregate=="False"
		C_proj = zeros(nb_Sectors);
		execstr("C_proj = fill_table(IOT_Qtities_"+time_step+ ",IndexRow,IndexCol,Index_Commodities,""C"");");
		end
		
		Projection.C = zeros(nb_SectorsAGG);
		
		if ToAggregate=="True"
		for line  = 1:nb_SectorsAGG
			Projection.C(line)=sum(C_proj(all_IND(line)));
		end
		end
		
		if ToAggregate=="False"
			Projection.C = C_proj;
		end
		
		
		clear C_proj
		
	elseif ScenAgg_IOT==%T
	
		execstr("C_proj = fill_table(IOT_Qtities_"+time_step+ ",IndexRow,IndCol_IOT_Qtities,Index_CommoInit,""C"");");
		for column = 1:nb_SectorsAGG
			//aggregation here by line..
			Projection.C(column,:) = sum(C_proj(all_IND(column)),:);
		end	 
	
	end 

	if size(Projection.C,"c")<>nb_Households
	error("The C consumption objective is for all Households. It is not possible to force a unique total consumption C if the model is running with differents HH classes. Inform projection for each class or don't force C.")
	end 
	
	// parameter forcing
	// parameters.delta_C_parameter(C_BU) = ((Projection.C(C_BU)./((BY.C(C_BU)==0)+(BY.C(C_BU)<>0).*BY.C(C_BU))).^(1/parameters.time_since_BY)-(Projection.C(C_BU)<>0))';
	// parameters.delta_C_parameter(C_BU) = ((Projection.C(C_BU)./((BY.C(C_BU)==0)+(BY.C(C_BU)<>0).*BY.C(C_BU))).^(1/parameters.time_since_BY)-(ones(Projection.C(C_BU))))';
	parameters.delta_C_parameter(C_BU) = ((Projection.C(C_BU)./((sum(BY.C(C_BU,:),"c")==0)+(sum(BY.C(C_BU,:),"c")<>0).*sum(BY.C(C_BU,:),"c"))).^(1/parameters.time_since_BY)-(ones(Projection.C(C_BU))))';
else
	warning("No forcing available because no scenario selected");
end


