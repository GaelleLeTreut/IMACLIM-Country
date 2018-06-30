//////////////////////////
// Select a set of forcing
//////////////////////////

// macro context
Labour_product = "True"; //"True"
World_energy_prices = ["Crude_oil" "Natural_gas" "Coal"]; // 
Demographic_shift = "True"; //True

Trade_BU = Indice_EnerSect ; //
//Alpha_BU = Indice_EnerSect ; //
//C_BU = Indice_EnerSect ; // 

Alpha_BU = [Indice_EnerSect 14 16] ;
C_BU = [Indice_EnerSect 11 13 14 15]  ; 
ToAggregate = "False";


X_nonEnerg = "True"; //"";
warning("Antoine : Dans la wage curve on garde u_tot_ref ou on passe sur un u_param comme au Brésil ?")

// wage_curve
parameters.Coef_real_wage = 1.0;
parameters.sigma_omegaU = -0.3;
parameters.u_param = BY.u_tot ;//0.06   ;

////////////////////////////////////
// Specific to homothetic projection
////////////////////////////////////
if [System_Resol=="Systeme_ProjHomothetic"]|[System_Resol=="Systeme_ProjHomothetic_bis"]
	parameters.sigma_pC = ones(parameters.sigma_pC);
	parameters.sigma_ConsoBudget = ones(parameters.sigma_ConsoBudget);
	parameters.ConstrainedShare_C = zeros(parameters.ConstrainedShare_C);
	parameters.sigma_M = ones(parameters.sigma_M);
	parameters.sigma_X = ones(parameters.sigma_X);
end

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
        execstr("Projection."+varname+"=evstr(Macro_Framework(find(Macro_Framework==varname),2:$));");
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
// nettoyage possible après avoir différencier param et calib
end

// Set up demographic context
if Demographic_shift == "True"
Deriv_Exogenous.Labour_force =  ((1+Projection.Labour_force(time_step)).^(parameters.time_since_ini))*ini.Labour_force;
Deriv_Exogenous.Population =  ((1+Projection.Population(time_step)).^(parameters.time_since_ini))*ini.Population;
Deriv_Exogenous.Retired =  ((1+Projection.Labour_force(time_step)).^(parameters.time_since_ini))*ini.Retired;
// trop compliqué ce que je faisais... Retired évolue comme Labour_force
end

// Set up macroeconomic context
if Labour_product == "True"
	GDP_index(time_step) = prod((1 + Projection.GDP(1:time_step)).^(Projection.current_year(1:time_step) - Projection.reference_year(1:time_step)));
	parameters.Mu = (GDP_index(time_step)/(sum(Deriv_Exogenous.Labour_force)*(1-BY.u_tot)/(sum(BY.Labour))))^(1/parameters.time_since_BY)-1;
	parameters.Mu = parameters.Mu*1.3;
	parameters.phi_L = ones(parameters.phi_L)*parameters.Mu;
	warning("Antoine: nécessite de pouvoir implémenter Mu et phi_L à la main à l extérieur (study frame)")
end

// attention pour wage curve, différence entre Mu (/ini) et phi_L (/BY)
if time_step>1
	parameters.Mu = ((GDP_index(time_step)/GDP_index(time_step-1))/(sum(Deriv_Exogenous.Labour_force)*(1-BY.u_tot)/(sum(BY.Labour))))^(1/parameters.time_since_ini)-1;
end

//Set imported prices of energy
if World_energy_prices <> []
	for k=1:size(World_energy_prices,2)
		name = World_energy_prices(k);
		if sum(Index_Sectors == name)==1
			execstr("parameters.delta_pM_parameter("+k+") = Projection.pM_"+name+"(time_step);");
		else
			warning("the energy quantity "+ name +" does not fit with the agregation level used: the related prices won't be informed.");  
		end
	end
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

// clear des variables lors du load data du 1er pas de temps
if time_step==Nb_Iter & Scenario<>"" then
	if Alpha_BU <> [] | Trade_BU <> [] | C_BU <> [] 
		clear nb_SectorsTEMP Index_CommoditiesTEMP  
	end
end

if X_nonEnerg == "True"
	parameters.delta_X_parameter(1,Indice_NonEnerSect) = ones(parameters.delta_X_parameter(1,Indice_NonEnerSect))*Projection.GDP_world(time_step);
end

//TestX = ((1 + parameters.delta_X_parameter').^20).*BY.X;
//TestM = ((1 + parameters.delta_M_parameter').^20).*BY.M;
//TestC = ((1 + parameters.delta_C_parameter').^20).*BY.C;
//Testalpha = BY.alpha ./ ((1 + parameters.phi_IC).^20);

// implémentation de la taxe carbone et de l'incorporation de la biomasse
if Scenario == "AME"
	parameters.Carbon_Tax_rate = 100*1e3;
//	parameters.CarbonTax_Diff_IC = ones(CarbonTax_Diff_IC);
//	parameters.CarbonTax_Diff_IC = ones(CarbonTax_Diff_IC);
end

if Scenario == "AMS"
	parameters.CarbonTax_Diff_IC = ones(CarbonTax_Diff_IC);
	parameters.CarbonTax_Diff_IC = ones(CarbonTax_Diff_IC);
	if time_step == 1
		parameters.Carbon_Tax_rate == 225*1e3;
		// gaz
		Emission_Coef_C(2,:) = (1-0.18)*Emission_Coef_C(2,:);
		Emission_Coef_IC(2,:) = (1-0.18)*Emission_Coef_IC(2,:);
		// fuels
		Emission_Coef_C(4:5,:) = (1-0.12)*Emission_Coef_C(4:5,:);
		Emission_Coef_IC(4:5,:) = (1-0.12)*Emission_Coef_IC(4:5,:);
	end
	if time_step == 2
		parameters.Carbon_Tax_rate == 600*1e3;
		// gaz
		Emission_Coef_C(2,:) = (1-1.0)*Emission_Coef_C(2,:);
		Emission_Coef_IC(2,:) = (1-1.0)*Emission_Coef_IC(2,:);
		// fuels
		Emission_Coef_C(4:5,:) = (1-1.0)*Emission_Coef_C(4:5,:);
		Emission_Coef_IC(4:5,:) = (1-1.0)*Emission_Coef_IC(4:5,:);
	end
end

