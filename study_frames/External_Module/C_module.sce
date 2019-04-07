if Scenario<>"" then

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

// parameter forcing
//parameters.delta_C_parameter(C_BU) = ((Projection.C(C_BU)./((BY.C(C_BU)==0)+(BY.C(C_BU)<>0).*BY.C(C_BU))).^(1/parameters.time_since_BY)-(Projection.C(C_BU)<>0))';
// parameters.delta_C_parameter(C_BU) = ((Projection.C(C_BU)./((BY.C(C_BU)==0)+(BY.C(C_BU)<>0).*BY.C(C_BU))).^(1/parameters.time_since_BY)-(ones(Projection.C(C_BU))))';
parameters.delta_C_parameter(C_BU) = ((Projection.C(C_BU)./((sum(BY.C(C_BU,:),"c")==0)+(sum(BY.C(C_BU,:),"c")<>0).*sum(BY.C(C_BU,:),"c"))).^(1/parameters.time_since_BY)-(ones(Projection.C(C_BU))))';

else
warning("No forcing available because no scenario selected");
end


