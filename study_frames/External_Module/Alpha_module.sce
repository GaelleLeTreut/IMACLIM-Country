if Scenario<>"" then

// data treatment
IC_proj = zeros(nb_SectorsTEMP,nb_SectorsTEMP);
Y_proj = zeros(nb_SectorsTEMP);
execstr("IC_proj = fill_table(IOT_Qtities_"+time_step+ ",IndRow_IOT_Qtities,IndCol_IOT_Qtities,Index_CommoditiesTEMP,Index_SectorsTEMP);");
execstr("Y_proj = fill_table(IOT_Qtities_"+time_step+ ",IndRow_IOT_Qtities,IndCol_IOT_Qtities,Index_CommoditiesTEMP,""Y"");");

Projection.IC = zeros(nb_SectorsAGG,nb_SectorsAGG);
Projection.Y = zeros(nb_SectorsAGG);

for line  = 1:nb_SectorsAGG
    for column = 1:nb_SectorsAGG
        Projection.IC(line,column)=sum(IC_proj(all_IND(line), all_IND(column)));
    end
    Projection.Y(line)=sum(Y_proj(all_IND(line)));
end

clear IC_proj Y_proj

// parameter forcing
alpha_current = BY.alpha;
alpha_current(Alpha_BU,:) = Projection.IC(Alpha_BU,:)./(ones(Alpha_BU)'*(Projection.Y)');
r_alpha = zeros(nb_Sectors,nb_Sectors);
r_alpha (Alpha_BU,:)= (alpha_current(Alpha_BU,:)./((BY.alpha(Alpha_BU,:)>1E-7).*BY.alpha(Alpha_BU,:)+(BY.alpha(Alpha_BU,:)<=1E-7))).^(1/(parameters.time_since_BY))-(BY.alpha(Alpha_BU,:)>1E-6);

for line=1:nb_Sectors
    for column=1:nb_Sectors
        if r_alpha(line,column)==-1
            parameters.phi_IC(line,column) = 1E7;
        else
            parameters.phi_IC(line,column) = -r_alpha(line,column)./(1+r_alpha(line,column));
        end
    end
end

clear alpha_reference r_alpha

else
warning("No forcing available because no scenario selected");
end




