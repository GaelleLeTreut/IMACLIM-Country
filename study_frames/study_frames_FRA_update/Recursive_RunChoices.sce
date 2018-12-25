////////////////////////////////////
// Specific to homothetic projection
////////////////////////////////////
if [System_Resol=="Systeme_ProjHomothetic"]
	parameters.sigma_pC = ones(parameters.sigma_pC);
	parameters.sigma_ConsoBudget = ones(parameters.sigma_ConsoBudget);
	parameters.ConstrainedShare_C = zeros(parameters.ConstrainedShare_C);
	parameters.sigma_M = ones(parameters.sigma_M);
	parameters.sigma_X = ones(parameters.sigma_X);
	parameters.CarbonTax_Diff_IC = ones(CarbonTax_Diff_IC);
	parameters.CarbonTax_Diff_IC = ones(CarbonTax_Diff_IC);
	parameters.Carbon_Tax_rate = 0.0;
	parameters.u_param = BY.u_tot;
end

//////////////////////////
// Select a set of forcing
//////////////////////////
	// to integrate within the Dashboard thereafter : à généraliser pour forcer certains secteurs... où choisir si on indique True ou False dans le Dashboard
Trade_BU = Indice_EnerSect; 
Alpha_BU = Indice_EnerSect; // à généraliser pour avoir des forçages en volume et en intensité  
C_BU = Indice_EnerSect;
// faire des forçages sous-entend un certain de jeu de paramètres en entrée... implémenter le changement dans le code au cas où ce n'est pas bien renseigné ? Par forcément car parfois que je fais un forçage en indiquant une cible mais je veux me laisser une liberté de me promener autour de cette cible par jeux d'arbitrage économique   
// find(Index_Sectors=="Automobile") find(Index_Sectors=="Load_PipeTransp") find(Index_Sectors=="PassTransp") find(Index_Sectors=="Agri_Food_industry") find(Index_Sectors=="Property_business")]; 

ToAggregate = "False"; // feature whether forcing data are not aggregated... check if it's working... to improve ?

////////////////////////////////////////////////////////////////////////
// load of macroeconomic and demographic context for the first step only
////////////////////////////////////////////////////////////////////////
if time_step==1 then
    for elt=1:size(Row_Column,"r")
        NameTemp = Row_Column(elt);
        TempIndicElt = find( NameTemp ==Index_Macro_Framework(:,1));
        TableTemp = Index_Macro_Framework(TempIndicElt,:);
        TableTemp(:,1)=[];
        if NameTemp=="Row"
            Index_Var_Macro = TableTemp;
            nb_Var_Macro = size(Index_Var_Macro,1);
        end
    end

    for var=1:nb_Var_Macro
        varname=Index_Var_Macro(var);
        execstr("Projection."+varname+"=evstr(Macro_Framework_"+Macro_nb+"(find(Macro_Framework_"+Macro_nb+"==varname),2:$));");
    end
end

/////////////////////////
// Macroeconomic context
/////////////////////////
// Définition des time_since_BY et time_since_ini
if Resol_Mode == "Static_comparative"
time_step_temp = time_step;
time_step=1;
end
if Resol_Mode == "Dynamic_projection"
parameters.time_since_ini = Projection.current_year(time_step) - Projection.reference_year(time_step);
parameters.time_since_BY = Projection.current_year(time_step) - Projection.reference_year(1);
end
warning("Macro-framework dans cette situation est indispensable pour informer time_since_ini et time_since_BY")

// Set up demographic context
if Demographic_shift == "True"
	Deriv_Exogenous.Labour_force =  ((1+Projection.Labour_force(time_step)).^(parameters.time_since_ini))*ini.Labour_force;
	Deriv_Exogenous.Population =  ((1+Projection.Population(time_step)).^(parameters.time_since_ini))*ini.Population;
	if [System_Resol<>"Systeme_ProjHomothetic"] then
		Deriv_Exogenous.Retired =  ((1+Projection.Retired(time_step)).^(parameters.time_since_ini))*ini.Retired;
	end
end

// Set up macroeconomic context
if Labour_product == "True"
	GDP_index(time_step) = prod((1 + Projection.GDP(1:time_step)).^(Projection.current_year(1:time_step) - Projection.reference_year(1:time_step)));
	parameters.Mu = (GDP_index(time_step)/(sum(Deriv_Exogenous.Labour_force)*(1-BY.u_tot)/(sum(BY.Labour))))^(1/parameters.time_since_BY)-1;
	parameters.phi_L = ones(parameters.phi_L).*parameters.Mu;
end

//Set imported prices as Macro_framework
//if World_energy_prices <> []
if World_prices == "True"
//	for k=1:size(World_energy_prices,2)
	for k=1:size(Index_Sectors,1)
//		name = World_energy_prices(k);
		name = Index_Sectors(k);
		if sum(Index_Sectors == name)==1
			execstr("parameters.delta_pM_parameter("+k+") = Projection.pM_"+name+"(time_step);");
		else
			warning("the energy quantity "+ name +" does not fit with the agregation level used: the related prices won't be informed.");  
		end
	end
end

// Export growth of non-energy sectors as GDP_world
if X_nonEnerg == "True"
	parameters.delta_X_parameter(1,Indice_NonEnerSect) = ones(parameters.delta_X_parameter(1,Indice_NonEnerSect))*Projection.GDP_world(time_step);
end

// clear programming trick for Static_comparative
if Resol_Mode == "Static_comparative"
time_step=time_step_temp;
clear time_step_temp
end

////////////////////////////////////////////////////////////////////////
// Soft-coupling from BU (volumes)
////////////////////////////////////////////////////////////////////////
// load all data
if time_step==1 & Scenario<>"" then
	if Alpha_BU <> [] | Trade_BU <> [] | C_BU <> [] 
		exec(STUDY+"External_Module"+sep+"Import_Proj_Volume.sce");
	end
end

// traitement des données et forçage relatifs à alpha (phi_IC)
if Alpha_BU <> []
	exec(STUDY+"External_Module"+sep+"Alpha_module.sce");
end

// traitement des données et forçage relatifs à commerce (delta_X_parameter & delta_M_parameter)
if Trade_BU <> []
	exec(STUDY+"External_Module"+sep+"Trade_module.sce");
end

// traitement des données et forçage relatifs à la consommation des ménages (delta_C_parameter)
if C_BU <> []
	exec(STUDY+"External_Module"+sep+"C_module.sce");
end

// Actualise Emission factors embodied in imported goods
if CO2_footprint == "True" & Scenario <>"" then
	if time_step == 1
		ini.CoefCO2_reg = CoefCO2_reg;
	end
	execstr("Deriv_Exogenous.CoefCO2_reg = CoefCO2_reg_" + time_step + "_" + Macro_nb);
end

// clear des variables lors du load data du 1er pas de temps
if time_step==Nb_Iter & Scenario<>"" then
	if Alpha_BU <> [] | Trade_BU <> [] | C_BU <> [] 
		clear nb_SectorsTEMP Index_CommoditiesTEMP  
	end
end
