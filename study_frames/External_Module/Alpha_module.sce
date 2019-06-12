if Scenario<>"" then

if ScenAgg_IOT==%F 
// data treatment
	if ToAggregate=="True"
	IC_proj = zeros(nb_SectorsTEMP,nb_SectorsTEMP);
	Y_proj = zeros(nb_SectorsTEMP);
	execstr("IC_proj = fill_table(IOT_Qtities_"+time_step+ ",IndRow_IOT_Qtities,IndCol_IOT_Qtities,Index_CommoditiesTEMP,Index_SectorsTEMP);");
	execstr("Y_proj = fill_table(IOT_Qtities_"+time_step+ ",IndRow_IOT_Qtities,IndCol_IOT_Qtities,Index_CommoditiesTEMP,""Y"");");
	end
	
	if ToAggregate=="False"
	IC_proj = zeros(nb_Sectors,nb_Sectors);
	Y_proj = zeros(nb_Sectors);
	execstr("IC_proj = fill_table(IOT_Qtities_"+time_step+ ",IndexRow,IndexCol,Index_Commodities,Index_Sectors);");
	execstr("Y_proj = fill_table(IOT_Qtities_"+time_step+ ",IndexRow,IndexCol,Index_Commodities,""Y"");");
	end
	
	Projection.IC = zeros(nb_SectorsAGG,nb_SectorsAGG);
	Projection.Y = zeros(nb_SectorsAGG);
	
	if ToAggregate=="True"
	for line  = 1:nb_SectorsAGG
		for column = 1:nb_SectorsAGG
			Projection.IC(line,column)=sum(IC_proj(all_IND(line), all_IND(column)));
		end
		Projection.Y(line)=sum(Y_proj(all_IND(line)));
	end
	end
	
	if ToAggregate=="False"
		Projection.IC = IC_proj;
		Projection.Y = Y_proj;
	end
	
	clear IC_proj Y_proj
	
elseif ScenAgg_IOT==%T 

execstr("Y_proj = fill_table(IOT_Qtities_"+time_step+ ",IndexRow,IndCol_IOT_Qtities,Index_CommoInit,""Y"");");
execstr("IC_proj = fill_table(IOT_Qtities_"+time_step+ ",IndexRow,IndCol_IOT_Qtities,Index_CommoInit,Index_SectInit);");
	//aggregation here by line..
	for column = 1:nb_SectorsAGG
		Projection.Y(column,:) = sum(Y_proj(all_IND(column)),:);
	end
   //for sector*sector aggregation
	for line  = 1:nb_SectorsAGG
    for column = 1:nb_SectorsAGG
        Projection.IC(line,column) = sum(IC_proj(all_IND(line),all_IND(column)));
	end	
    end

end


// parameter forcing
alpha_current = BY.alpha;
alpha_current(Alpha_BU,:) = Projection.IC(Alpha_BU,:)./(ones(Alpha_BU)'*((Projection.Y==0)+(Projection.Y<>0).*Projection.Y)');
r_alpha = zeros(nb_Sectors,nb_Sectors);
r_alpha (Alpha_BU,:)= (alpha_current(Alpha_BU,:)./((BY.alpha(Alpha_BU,:)>1E-7).*BY.alpha(Alpha_BU,:)+(BY.alpha(Alpha_BU,:)<=1E-7))).^(1/(parameters.time_since_BY))-(BY.alpha(Alpha_BU,:)>1E-7);

for line=1:nb_Sectors
    for column=1:nb_Sectors
        if r_alpha(line,column)==-1
            parameters.phi_IC(line,column) = 1E7;
        else
            parameters.phi_IC(line,column) = -r_alpha(line,column)./(1+r_alpha(line,column));
        end
    end
end

parameters.phi_IC = (abs(parameters.phi_IC)>1E-6).*parameters.phi_IC;

if Alpha_BU_Intens==%T & Alpha_Part_BU<>[]
error("parameters.phi_IC for Alpha_Part_BU are not calculated yet in Alpha_module.sce - Need to be done before selecting this options")
end

clear alpha_reference r_alpha

else
warning("No forcing available because no scenario selected");
end




