//////////////////////////
// Variables exogènes
//////////////////////////
// Exogenous NetFinancialDebt : Index_InstitAgents  = Corporations / Government / Households / RestOfWorld
if H_DISAGG == "HH1"
	Deriv_Exogenous.NetFinancialDebt = [2132930000.0 1707972000.0 -3583937000.0 -256965000.0];
end

if H_DISAGG == "H10"
//	Deriv_Exogenous.NetFinancialDebt = [2132930000.0 1707972000.0 ..
//		-114519452.783358	-153743948.046157	-178439230.805759	-242164630.421028	-248920799.658153 ..
//		-426576026.325477	-463150279.02339	-494297673.388974	-474292119.135289	-787832840.412415 ..
//	 	-256965000.0];
	Deriv_Exogenous.NetFinancialDebt = BY.NetFinancialDebt;
	Deriv_Exogenous.NetFinancialDebt(1:2) = [2132930000.0 1707972000.0];
	Deriv_Exogenous.NetFinancialDebt(Indice_Households) = -3583937000.0 * BY.NetFinancialDebt(Indice_Households)/sum(BY.NetFinancialDebt(Indice_Households)) ;
	Deriv_Exogenous.NetFinancialDebt(Indice_RestOfWorld) = -256965000.0;
end

// Exogenous Property_income : 	Index_InstitAgents  = Corporations / Government / Households / RestOfWorld
if H_DISAGG == "HH1"
	Deriv_Exogenous.Property_income = [-27426000.0 -26250000.0 76509000.0 -22833000.0];
end
if H_DISAGG == "H10"
	Deriv_Exogenous.Property_income = BY.Property_income;
	Deriv_Exogenous.Property_income(1:2) = [-27426000.0 -26250000.0];
	Deriv_Exogenous.Property_income(Indice_Households) = 76509000.0 * BY.Property_income(Indice_Households)/sum(BY.Property_income(Indice_Households)) ;
	Deriv_Exogenous.Property_income(Indice_RestOfWorld) = -22833000.0;
end

// GFCF distribution by Agent
if H_DISAGG == "HH1"
	Deriv_Exogenous.GFCF_Distribution_Shares = [0.5864207144 0.1635198603 0.2500594253];
end
if H_DISAGG == "H10"
	Deriv_Exogenous.GFCF_Distribution_Shares = BY.GFCF_Distribution_Shares;
	Deriv_Exogenous.GFCF_Distribution_Shares(1:2) = [0.5864207144 0.1635198603];
	Deriv_Exogenous.GFCF_Distribution_Shares(Indice_Households) = 0.2500594253 * BY.GFCF_Distribution_Shares(Indice_Households)/sum(BY.GFCF_Distribution_Shares(Indice_Households)) ;
end

// Distribution shares
Deriv_Exogenous.Distribution_Shares = BY.Distribution_Shares;
if H_DISAGG == "HH1"
	Deriv_Exogenous.Distribution_Shares(Indice_Non_Labour_Income, : ) = [0.638037969 0.1118701802 0.2500918508 0.0];
end
if H_DISAGG == "H10"
	Deriv_Exogenous.Distribution_Shares = BY.Distribution_Shares;
	Deriv_Exogenous.Distribution_Shares(Indice_Non_Labour_Income,1:2) = [0.638037969 0.1118701802];
	Deriv_Exogenous.Distribution_Shares(Indice_Non_Labour_Income,Indice_Households) = 0.2500918508 * BY.Distribution_Shares(Indice_Non_Labour_Income,Indice_Households)/sum(BY.Distribution_Shares(Indice_Non_Labour_Income,Indice_Households)) ;
	Deriv_Exogenous.Distribution_Shares(Indice_Non_Labour_Income,Indice_RestOfWorld) =  0.0;
end

//HH saving rate
Deriv_Exogenous.Household_saving_ratetot = 0.13925654620247;

// Composanste du GDP
//Deriv_Exogenous.Consumption_budget   = (1199.2438728305*1E6)*BY.Consumption_budget/sum(BY.Consumption_budget);
Deriv_Exogenous.G_Consumption_budget = 576.37*1E6;
Deriv_Exogenous.I_Consumption_budget = 488.008*1E6;

// TEE update
Exo_VA_Tax = 154.43*1E6; 
Deriv_Exogenous.Labour_Tax_rate = ones(Labour_Tax_rate) * 0.4509447164;
Deriv_Exogenous.Unemployment_transfers = 44500000.0*BY.Unemployment_transfers/sum(BY.Unemployment_transfers);
Deriv_Exogenous.Pensions = 325300000.0*BY.Pensions/sum(BY.Pensions);
Deriv_Exogenous.Other_social_transfers = 116492000.0*BY.Other_social_transfers/sum(Other_social_transfers);
Deriv_Exogenous.Corporate_Tax = 51.6121588305*1E6;
Deriv_Exogenous.Income_Tax = 200.6828411695*1E6*BY.Income_Tax/sum(BY.Income_Tax);
Exo_Production_Tax = 57.171*1E6; 
Exo_GrossOpSurplus = 716.3928748305*1E6; 

//////////////////////////
// Paramètres centraux à caller 
//////////////////////////
// Indicateurs macroéconomiques
parameters.Mu = scal(1);
parameters.phi_L = ones(Indice_Sectors)*parameters.Mu;
parameters.u_param = scal(2);
parameters.sigma_omegaU = scal(3);
parameters.Coef_real_wage = scal(4);//0.7;
parameters.phi_K = ones(Indice_Sectors)*scal(5);
parameters.sigma_M = zeros(parameters.sigma_M);
parameters.delta_M_parameter(Indice_NonEnerSect)=ones(parameters.delta_M_parameter(Indice_NonEnerSect))*scal(6);
parameters.sigma_X = zeros(parameters.sigma_X);
parameters.delta_X_parameter(Indice_NonEnerSect)=ones(parameters.delta_X_parameter(Indice_NonEnerSect))*scal(7);

// Energy prices (Gaz, AllFuels & Elec)
parameters.phi_K([2 4 5]) = [scal(8) scal(9) scal(10)];
parameters.phi_L(2)= scal(9);
parameters.phi_IC = zeros(parameters.phi_IC);
parameters.phi_IC(Indice_NonEnerSect,[2 4 5]) = ones(Indice_NonEnerSect)'.*.[scal(8) scal(9) scal(10)];


// marge spécifiques 
//Deriv_Exogenous.SpeMarg_rates_C = BY.SpeMarg_rates_C;
//Deriv_Exogenous.SpeMarg_rates_C(4) = BY.SpeMarg_rates_C(4)*scal(8);
//Deriv_Exogenous.SpeMarg_rates_X = BY.SpeMarg_rates_X;
//Deriv_Exogenous.SpeMarg_rates_X(4) = BY.SpeMarg_rates_X(4)*scal(9);