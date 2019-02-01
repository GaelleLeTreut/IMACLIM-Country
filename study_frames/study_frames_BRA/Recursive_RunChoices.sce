////////////////////////////////////
// Specific to homothetic projection
////////////////////////////////////
if [System_Resol=="Systeme_ProjHomot_BRA"]
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
Trade_BU =[] ; //Indice_EnerSect 
Alpha_BU =[] ; // Indice_EnerSect; // à généraliser pour avoir des forçages en volume et en intensité  
C_BU = [] ;  //Indice_EnerSect;
// faire des forçages sous-entend un certain de jeu de paramètres en entrée... implémenter le changement dans le code au cas où ce n'est pas bien renseigné ? Par forcément car parfois que je fais un forçage en indiquant une cible mais je veux me laisser une liberté de me promener autour de cette cible par jeux d'arbitrage économique   
// find(Index_Sectors=="Automobile") find(Index_Sectors=="Load_PipeTransp") find(Index_Sectors=="PassTransp") find(Index_Sectors=="Agri_Food_industry") find(Index_Sectors=="Property_business")]; 

ToAggregate = "False"; // feature whether forcing data are not aggregated... check if it's working... to improve ?

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
