if Scenario<>"" then

// data treatment
C_proj = zeros(nb_SectorsTEMP);
execstr("C_proj = fill_table(IOT_Qtities_"+time_step+ ",IndRow_IOT_Qtities,IndCol_IOT_Qtities,Index_CommoditiesTEMP,""C"");");

Projection.C = zeros(nb_SectorsAGG);

for line  = 1:nb_SectorsAGG
	Projection.C(line)=sum(C_proj(all_IND(line)));
end

clear C_proj

// parameter forcing
parameters.delta_C_parameter(C_BU) = ((Projection.C(C_BU)./((BY.C(C_BU)==0)+(BY.C(C_BU)<>0).*BY.C(C_BU))).^(1/parameters.time_since_BY)-(Projection.C(C_BU)<>0))';

else
warning("No forcing available because no scenario selected");
end


