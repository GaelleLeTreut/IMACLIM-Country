if Scenario<>"" then

// data treatment
M_proj = zeros(nb_SectorsTEMP);
X_proj = zeros(nb_SectorsTEMP);

execstr("X_proj = fill_table(IOT_Qtities_"+time_step+ ",IndRow_IOT_Qtities,IndCol_IOT_Qtities,Index_CommoditiesTEMP,""X"");");
execstr("M_proj = fill_table(IOT_Qtities_"+time_step+ ",IndRow_IOT_Qtities,IndCol_IOT_Qtities,Index_CommoditiesTEMP,""M"");");

Projection.M = zeros(nb_SectorsAGG);
Projection.X = zeros(nb_SectorsAGG);

for line  = 1:nb_SectorsAGG
    Projection.M(line)=sum(M_proj(all_IND(line)));
    Projection.X(line)=sum(X_proj(all_IND(line)));
end

clear M_proj X_proj

// parameter forcing
parameters.delta_X_parameter(Trade_BU) = ((Projection.X(Trade_BU)./((BY.X(Trade_BU)==0)+(BY.X(Trade_BU)<>0).*BY.X(Trade_BU))).^(1/parameters.time_since_BY)-(Projection.X(Trade_BU)<>0))';

parameters.delta_M_parameter(Trade_BU) = ((Projection.M(Trade_BU)./((BY.M(Trade_BU)==0)+(BY.M(Trade_BU)<>0).*BY.M(Trade_BU))).^(1/parameters.time_since_BY)-(Projection.M(Trade_BU)<>0))';

else
warning("No forcing available because no scenario selected");
end





