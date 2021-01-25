//////////////////////////
// Variables exogènes
//////////////////////////
// Exogenous NetFinancialDebt : Index_InstitAgents  = Corporations / Government / Households / RestOfWorld
Deriv_Exogenous.NetFinancialDebt = BY.NetFinancialDebt;
Deriv_Exogenous.NetFinancialDebt(1:2) = [2132930000.0 1707972000.0];
Deriv_Exogenous.NetFinancialDebt(Indice_Households) = -3583937000.0 * BY.NetFinancialDebt(Indice_Households)/sum(BY.NetFinancialDebt(Indice_Households)) ;
Deriv_Exogenous.NetFinancialDebt(Indice_RestOfWorld) = -256965000.0;

// Exogenous Property_income : 	Index_InstitAgents  = Corporations / Government / Households / RestOfWorld
Deriv_Exogenous.Property_income = BY.Property_income;
Deriv_Exogenous.Property_income(1:2) = [-27426000.0 -26250000.0];
Deriv_Exogenous.Property_income(Indice_Households) = 76509000.0 * BY.Property_income(Indice_Households)/sum(BY.Property_income(Indice_Households)) ;
Deriv_Exogenous.Property_income(Indice_RestOfWorld) = -22833000.0;

// GFCF distribution by Agent
Deriv_Exogenous.GFCF_Distribution_Shares = BY.GFCF_Distribution_Shares; // ajouter une calibration de ça... ça sera plus simple
Deriv_Exogenous.GFCF_Distribution_Shares(1:2) = [0.5864207144 0.1635198603];
Deriv_Exogenous.GFCF_Distribution_Shares(Indice_Households) = 0.2500594253 * BY.GFCF_Distribution_Shares(Indice_Households)/sum(BY.GFCF_Distribution_Shares(Indice_Households)) ;

// Distribution shares
Deriv_Exogenous.Distribution_Shares = BY.Distribution_Shares;
Deriv_Exogenous.Distribution_Shares = BY.Distribution_Shares;
Deriv_Exogenous.Distribution_Shares(Indice_Non_Labour_Income,1:2) = [0.638037969 0.1118701802];
Deriv_Exogenous.Distribution_Shares(Indice_Non_Labour_Income,Indice_Households) = 0.2500918508 * BY.Distribution_Shares(Indice_Non_Labour_Income,Indice_Households)/sum(BY.Distribution_Shares(Indice_Non_Labour_Income,Indice_Households)) ;
Deriv_Exogenous.Distribution_Shares(Indice_Non_Labour_Income,Indice_RestOfWorld) =  0.0;

// HH saving rate
Deriv_Exogenous.HH_saving_rate_agg = 0.13925654620247;

// Composanste du GDP
//Deriv_Exogenous.Consumption_budget   = (1199.2438728305*1E6)*BY.Consumption_budget/sum(BY.Consumption_budget);
Deriv_Exogenous.G_Consumption_budget = 576.37*1E6;
Deriv_Exogenous.I_Consumption_budget = 488.008*1E6;

// TEE update
Deriv_Exogenous.Labour_Tax_rate = ones(Labour_Tax_rate) * 0.4509447164;
Deriv_Exogenous.Unemployment_transfers = 44500000.0*BY.Unemployment_transfers/sum(BY.Unemployment_transfers);
Deriv_Exogenous.Pensions = 325300000.0*BY.Pensions/sum(BY.Pensions);
Deriv_Exogenous.Other_social_transfers = 116492000.0*BY.Other_social_transfers/sum(Other_social_transfers);
Deriv_Exogenous.Corporate_Tax = 51.6121588305*1E6;
Deriv_Exogenous.Income_Tax = 200.6828411695*1E6*BY.Income_Tax/sum(BY.Income_Tax);
Deriv_Exogenous.Production_Tax_byAgent = 57.171*1E6; 
Deriv_Exogenous.VA_Tax_byAgent = 154.43*1E6; 
Deriv_Exogenous.GOS_total = 716.3928748305*1E6;




//////////////////////////
// Paramètres centraux à caller 
//////////////////////////

// Recherche d'optimum ou simple résolution
//		[Mu    			u_param  		sigma_omegaU	CoefRealWage	phi_K..		
scal = 	[0.0082227339	0.1127758064	-0.1192021581	0.8242216354	-0.004913253 .. 
		0.0161172695	0.0179282157	-0.4074066869	-0.1707256015	-0.0729734596];
//		delta_M			delta_X			pGaz 			pFuels 			pElec];


target = 	[0.101573450097788.. 	// u_tot	
			847.503..				// NetCompWages_byAgent
			1.0718874451..			// CPI
			44.676..				// Trade_balance
			1.0280235988..
			0.9678596039..
			1.3837111671
			];

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


// clear scal