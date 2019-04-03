//////////////////////////
// Variables exogènes
//////////////////////////
// Exogenous NetFinancialDebt : Index_InstitAgents  = Corporations / Government / Households / RestOfWorld
if H_DISAGG == "HH1"
	Deriv_Exogenous.NetFinancialDebt = [2132930000.0 1707972000.0 -3583937000.0 -256965000.0];
end

if H_DISAGG == "H10"
	Deriv_Exogenous.NetFinancialDebt = [2132930000.0 1707972000.0 ..
		-114519452.783358	-153743948.046157	-178439230.805759	-242164630.421028	-248920799.658153 ..
		-426576026.325477	-463150279.02339	-494297673.388974	-474292119.135289	-787832840.412415 ..
	 	-256965000.0];
end

// Exogenous Property_income : 	Index_InstitAgents  = Corporations / Government / Households / RestOfWorld
if H_DISAGG == "HH1"
	Deriv_Exogenous.Property_income = [-27426000.0 -26250000.0 76509000.0 -22833000.0];
end
if H_DISAGG == "H10"
	Deriv_Exogenous.Property_income = [-27426000.0 -26250000.0 .. 
		2444732.932806	3282087.749049	3809276.532963	5169670.590996	5313899.619621 ..
		9106439.426289	9887217.52023	10552144.385718	10125070.765173	16818460.477155 ..
		-22833000.0];
end

// GFCF distribution by Agent
if H_DISAGG == "HH1"
	Deriv_Exogenous.GFCF_Distribution_Shares = [0.5864207144 0.1635198603 0.2500594253];
end
if H_DISAGG == "H10"
	Deriv_Exogenous.GFCF_Distribution_Shares = [0.5864207144 0.1635198603 ..
		0.0102508886	0.0123449565	0.0062950617	0.0068174014	0.0151269689 ..
		0.0246360284	0.0229613252	0.0450364012	0.0497614313	0.0568289621];
end

// Distribution shares
Deriv_Exogenous.Distribution_Shares = BY.Distribution_Shares;
if H_DISAGG == "HH1"
	Deriv_Exogenous.Distribution_Shares(Indice_Non_Labour_Income, : ) = [0.638037969 0.1118701802 0.2500918508 0.0];
end
if H_DISAGG == "H10"
	Deriv_Exogenous.Distribution_Shares(Indice_Non_Labour_Income, : ) = [0.638037969 0.1118701802 ..
	0.0118755465	0.012526292	0.0138089719	0.0176861753	0.0198250646 ..
	0.0235612996	0.0270839248	0.03190569	0.0359080622	0.0559108238 ..
	0.0];
end


// HH saving rate
if H_DISAGG == "HH1"
	Deriv_Exogenous.Household_saving_rate = 0.13925654620247;
end
if H_DISAGG == "H10"
	Deriv_Exogenous.Household_saving_rate = [-0.247676895	0.1113724477	0.1143954502	0.1324727043	0.1600105525..
		0.1815834328	0.1828037492	0.1640877271	0.1427541428	0.1679890465];
end

// Composanste du GDP
Deriv_Exogenous.Consumption_budget   = (1199.2438728305*1E6)*BY.Consumption_budget/sum(BY.Consumption_budget);
Deriv_Exogenous.G_Consumption_budget = 576.37*1E6;
Deriv_Exogenous.I_Consumption_budget = 488.008*1E6;
tau_Betta = 0; // initialisation

// TEE update
Deriv_Exogenous.Exo_VA_Tax = 154.43*1E6; 
tau_VA_Tax_rate = 0; // initialisation
Deriv_Exogenous.Labour_Tax_rate = ones(Labour_Tax_rate) * 0.4509447164;
Deriv_Exogenous.Unemployment_transfers = 44500000.0*BY.Unemployment_transfers/sum(BY.Unemployment_transfers);
Deriv_Exogenous.Pensions = 325300000.0*BY.Pensions/sum(BY.Pensions);
Deriv_Exogenous.Other_social_transfers = 116492000.0*BY.Other_social_transfers/sum(Other_social_transfers);
Deriv_Exogenous.Corporate_Tax = 51.6121588305*1E6;
Deriv_Exogenous.Income_Tax = 200.6828411695*1E6*BY.Income_Tax/sum(BY.Income_Tax);
Deriv_Exogenous.Exo_Production_Tax = 57.171*1E6; 
tau_Production_Tax_rate = 0; // initialisation
Deriv_Exogenous.Exo_GrossOpSurplus = 716.3928748305*1E6; 
tau_markup_rate = 0; // initialisation

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
parameters.sigma_M = parameters.sigma_M*scal(6);
parameters.sigma_X = parameters.sigma_X*scal(7);

// Energy prices (Gaz, AllFuels & Elec)
parameters.phi_K([2 4 5]) = [-0.3790052 -0.1719113 -0.0754572];//scal(6) scal(7) scal(8)];
parameters.phi_L(2)= -0.1719113;//scal(6);
parameters.phi_IC = zeros(parameters.phi_IC);
parameters.phi_IC(Indice_NonEnerSect,[2 4 5]) = ones(Indice_NonEnerSect)'.*.[-0.3790052 -0.1719113 -0.0754572];//scal(6) scal(7) scal(8)];


// marge spécifiques 
//Deriv_Exogenous.SpeMarg_rates_C = BY.SpeMarg_rates_C;
//Deriv_Exogenous.SpeMarg_rates_C(4) = BY.SpeMarg_rates_C(4)*scal(8);
//Deriv_Exogenous.SpeMarg_rates_X = BY.SpeMarg_rates_X;
//Deriv_Exogenous.SpeMarg_rates_X(4) = BY.SpeMarg_rates_X(4)*scal(9);