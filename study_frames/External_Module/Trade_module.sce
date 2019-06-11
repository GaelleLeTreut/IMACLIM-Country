if Scenario<>"" then


// If ScenAgg_IOT==%T , data are loaded in loadind data because there are a the size of maxmimun sectoral granularity and are aggregated 
if ScenAgg_IOT==%F 

// data treatment
	if ToAggregate=="True"
	M_proj = zeros(nb_SectorsTEMP);
	X_proj = zeros(nb_SectorsTEMP);
	
	execstr("X_proj = fill_table(IOT_Qtities_"+time_step+ ",IndRow_IOT_Qtities,IndCol_IOT_Qtities,Index_CommoditiesTEMP,""X"");");
	execstr("M_proj = fill_table(IOT_Qtities_"+time_step+ ",IndRow_IOT_Qtities,IndCol_IOT_Qtities,Index_CommoditiesTEMP,""M"");");
	end
	
	if ToAggregate=="False"
	M_proj = zeros(nb_Sectors);
	X_proj = zeros(nb_Sectors);
	
	execstr("X_proj = fill_table(IOT_Qtities_"+time_step+ ",IndexRow,IndexCol,Index_Commodities,""X"");");
	execstr("M_proj = fill_table(IOT_Qtities_"+time_step+ ",IndexRow,IndexCol,Index_Commodities,""M"");");
	end
	
	Projection.M = zeros(nb_SectorsAGG);
	Projection.X = zeros(nb_SectorsAGG);
	
	if ToAggregate=="True"
	for line  = 1:nb_SectorsAGGs
		Projection.M(line)=sum(M_proj(all_IND(line)));
		Projection.X(line)=sum(X_proj(all_IND(line)));
	end
	end
	
	if ToAggregate=="False"
		Projection.M = M_proj;
		Projection.X = X_proj;
	end
	clear M_proj X_proj
	
elseif ScenAgg_IOT==%T 

execstr("X_proj = fill_table(IOT_Qtities_"+time_step+ ",IndexRow,IndCol_IOT_Qtities,Index_CommoInit,""X"");");
execstr("M_proj = fill_table(IOT_Qtities_"+time_step+ ",IndexRow,IndCol_IOT_Qtities,Index_CommoInit,""M"");");
 
	for column = 1:nb_SectorsAGG
		//aggregation here by line..
		Projection.X(column,:) = sum(X_proj(all_IND(column)),:);
		Projection.M(column,:) = sum(M_proj(all_IND(column)),:);	
	end	

end 


// parameter forcing
parameters.delta_X_parameter(Trade_BU) = ((Projection.X(Trade_BU)./((BY.X(Trade_BU)==0)+(BY.X(Trade_BU)<>0).*BY.X(Trade_BU))).^(1/parameters.time_since_BY)-((Projection.X(Trade_BU)<>0) + (Projection.X(Trade_BU)==0)*0.9 ))';

rate_BY = BY.M./BY.Y;
rate_proj = Projection.M./((Projection.Y==0)+(Projection.Y<>0).*Projection.Y);

parameters.delta_M_parameter(Trade_BU) = ((rate_proj(Trade_BU)./((rate_BY(Trade_BU)==0)+(rate_BY(Trade_BU)<>0).*rate_BY(Trade_BU))).^(1/parameters.time_since_BY)-(ones(rate_proj(Trade_BU))))';

clear rate_BY rate_proj


else
warning("No forcing available because no scenario selected");
end





