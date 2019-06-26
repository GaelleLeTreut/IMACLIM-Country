// Compute projection of Y
Projection.Y = Proj_of("Y");

// Compute projection of IC
proj_IC = [];
// TODO : faire un unique cas
if ScenAgg_IOT then 
    IndSect = Index_SectInit;
elseif ToAggregate == "True" then
    IndSect = Index_SectInit;
else
    IndSect = Index_Sectors;
end
for var = IndSect'
    proj_IC(:,1+$) = Proj_of(var);
end
// TODO : trouver une solution mieux que ça (première colonne ajoutée à 0 ??):
proj_IC = proj_IC(:,2:$); // because first column added with zeros ?? remove it
if ToAggregate == "True" then
    for line = 1:nb_SectorsAGG
        for column = 1:nb_SectorsAGG
            Projection.IC(line,column) = sum(proj_IC(line,all_IND(column)));
        end
    end
else
    Projection.IC = proj_IC;
end
clear proj_IC;

// parameter forcing
alpha_current = BY.alpha;
alpha_current(Alpha_BU,:) = Projection.IC(Alpha_BU,:) ./ (ones(Alpha_BU)' * ((Projection.Y==0) + (Projection.Y<>0) .* Projection.Y)');
r_alpha = zeros(nb_Sectors,nb_Sectors);
r_alpha (Alpha_BU,:) = (alpha_current(Alpha_BU,:) ./ ((BY.alpha(Alpha_BU,:)>1E-7) .* BY.alpha(Alpha_BU,:) + (BY.alpha(Alpha_BU,:)<=1E-7))) .^ (1/(parameters.time_since_BY)) - (BY.alpha(Alpha_BU,:)>1E-7);

for line = 1:nb_Sectors
    for column = 1:nb_Sectors
        if r_alpha(line,column) == -1
            parameters.phi_IC(line,column) = 1E7;
        else
            parameters.phi_IC(line,column) = -r_alpha(line,column) ./ (1+r_alpha(line,column));
        end
    end
end

parameters.phi_IC = (abs(parameters.phi_IC)>1E-6) .* parameters.phi_IC;

if Alpha_BU_Intens & Alpha_Part_BU <> []
    error("parameters.phi_IC for Alpha_Part_BU are not calculated yet in Alpha_module.sce - Need to be done before selecting this options");
end

clear alpha_reference r_alpha;
