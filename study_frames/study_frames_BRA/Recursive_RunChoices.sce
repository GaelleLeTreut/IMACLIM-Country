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
// Indice of sectors to force volume of imports and exports
Trade_BU =Indice_EnerSect ;

// Indice of sectors to force all intermediate consumption in volume 
Alpha_BU = Indice_EnerSect;
// Alpha_BU_Intens = %T; 

// Partial BU forcing (only few element of the intermediate consumption) 
  // Alpha_Part_BU matrix with in line the Index of the Sector partially informed, and in column for which input sector. 
// Alpha_Part_BU =[];                                                                                              
// Example  : consumption of chemical from planted forest and cattle are forced, consumption of bovineMeat from planted forest is forced (zero put a the end of the BovineMeat line to keep 3 column)
// Alpha_Part_BU = [find(Index_Sectors=="Chemical"), find(Index_Sectors=="PlantedForest"),  find(Index_Sectors=="Cattle")] ;
 // Alpha_Part_BU = [find(Index_Sectors=="Chemical"), find(Index_Sectors=="PlantedForest"),  find(Index_Sectors=="Cattle"); find(Index_Sectors=="BovineMeat"), find(Index_Sectors=="PlantedForest"), 0 ];

// Indice of sectors to force households consumption in volume 
C_BU =  Indice_EnerSect;


//////////////////////////
// Sets of conditions to make the code run even if the variables to force are not define
//////////////////////////
if isdef("Alpha_Part_BU") ==%F
Alpha_Part_BU=[];
end

if isdef("Alpha_BU") ==%F
Alpha_BU=[];
end

if isdef("Alpha_BU_Intens") ==%F
Alpha_BU_Intens=%F;
end

if isdef("C_BU") ==%F
C_BU=[];
end

if isdef("C_BU_Intens") ==%F
C_BU_Intens=%F;
end

if isdef("Trade_BU") ==%F
Trade_BU=[];
end

if Alpha_Part_BU <>[]& Alpha_BU <>[]
AllSet = [Alpha_BU, Alpha_Part_BU(:,1)'];
ToSet = setdiff(Indice_Sectors, AllSet);
elseif Alpha_Part_BU ==[]& Alpha_BU <>[]
ToSet = setdiff(Indice_Sectors, Alpha_BU);
elseif Alpha_Part_BU <>[]& Alpha_BU ==[]
AllSet = [Alpha_Part_BU(:,1)'];
ToSet = setdiff(Indice_Sectors, AllSet);
elseif Alpha_Part_BU ==[] & Alpha_BU ==[]
ToSet = Indice_Sectors;
end

ToAggregate = "False"; // feature whether forcing data are not aggregated... check if it's working... to improve ?

////////////////////////////////////////////////////////////////////////
// Soft-coupling from BU (volumes)
////////////////////////////////////////////////////////////////////////
// load all data
if time_step==1 & Scenario<>"" then

	if Alpha_BU <> []
	parameters.ConstrainedShare_IC(Alpha_BU,:)=1;
	ConstrainedShare_IC(Alpha_BU,:)=1;
	/// Need to recalibrate aIC
	Coeff_forCES = (sum(pIC.* (1 - ConstrainedShare_IC) .* alpha,"r") + sum(pL .* (1-ConstrainedShare_Labour) .* lambda, "r") + pK .* (1-ConstrainedShare_Capital) .* kappa );
	aIC = (ones(nb_Sectors,1)*Coeff_forCES<>0).*pIC.* ((1 - ConstrainedShare_IC) .* alpha) .^ (1 -(ones(nb_Sectors,1)*((sigma-1)./sigma))) .* (ones(nb_Sectors,1)*((Coeff_forCES<>0).*Coeff_forCES + (Coeff_forCES==0))).^(-1);
	aL	=  (Coeff_forCES<>0).*pL.* ((1 - ConstrainedShare_Labour) .* lambda) .^ (1 -((sigma-1)./sigma)) .*((Coeff_forCES<>0).*Coeff_forCES + (Coeff_forCES==0)) .^(-1);
	aK= (Coeff_forCES<>0) .* (pK.* ((1 - ConstrainedShare_Capital) .* kappa) .^ (1 -((sigma-1)./sigma)) .*((Coeff_forCES<>0).*Coeff_forCES + (Coeff_forCES==0)) .^(-1));
	
	end
	
	///////// ConstrainedShare_C set up to 1 to reproduce forced volumes of C
	if C_BU<> []
	parameters.ConstrainedShare_C(C_BU)=1;
	end
	
	/////// Elasticity set up to 0 to reproduce forced volumes of X and M
	if Trade_BU <> []
	parameters.sigma_M(Trade_BU) = 0;
	parameters.sigma_X (Trade_BU) = 0;
	end

	if Alpha_BU <> [] | Trade_BU <> [] | C_BU <> [] 
		exec(STUDY+"External_Module"+sep+"Import_Proj_Volume.sce");
	end
	
end

// traitement des données et forçage relatifs à alpha (phi_IC)
if  Alpha_BU <> []
	exec(STUDY+"External_Module"+sep+"Alpha_module.sce");
	if Alpha_BU_Intens==%F
	disp("The intermediate consumption of -Index_Sectors(Alpha_BU)- are forced");
	elseif Alpha_BU_Intens==%T
	disp("The production intensity of -Index_Sectors(Alpha_BU)- are forced");
	end
end

// traitement des données et forçage relatifs à commerce (delta_X_parameter & delta_M_parameter)
if  Trade_BU <> []
	exec(STUDY+"External_Module"+sep+"Trade_module.sce");
	disp("The volume of exports and imports of -Index_Sectors(Alpha_BU)- are forced");
end

// traitement des données et forçage relatifs à la consommation des ménages (delta_C_parameter)
if C_BU <> []
	exec(STUDY+"External_Module"+sep+"C_module.sce");
	if C_BU_Intens==%F
	disp("The households consumption of -Index_Sectors(C_BU)- are forced");
	elseif C_BU_Intens==%T
	disp("The consumption intensity of -Index_Sectors(Alpha_BU)- are forced");
	end
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
