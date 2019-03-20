// Unemployment rate 
//parameters.sigma_omegaU = 0.1;

// real GDP
//parameters.Mu = 0.005;//- 0.0002776;
paramters.phi_L = parameters.Mu;

// Share of I in GDP
parameters.phi_K = -ones(parameters.phi_K)*0.005;

// Energy prices (Gaz & Elec)
parameters.phi_K([2 5]) = [-0.05 -0.05];
parameters.phi_IC = zeros(parameters.phi_IC);
parameters.phi_IC(Indice_NonEnerSect,[2 5]) = ones(Indice_NonEnerSect)'.*.[-0.05 -0.05];

// Exogenous NetFinancialDebt : Index_InstitAgents  = Corporations / Government / Households / RestOfWorld
Deriv_Exogenous.NetFinancialDebt = [2132930000.0 1707972000.0 -3583937000.0 -256965000.0];

// Exogenous Property_income : 	Index_InstitAgents  = Corporations / Government / Households / RestOfWorld
Deriv_Exogenous.Property_income = [-27426000.0 -26250000.0 76509000.0 -22833000.0];

// GFCF distribution by Agent
Deriv_Exogenous.GFCF_Distribution_Shares = [0.57846100 0.16059150 0.26094750];

// Distribution shares
Deriv_Exogenous.Distribution_Shares = BY.Distribution_Shares;
Deriv_Exogenous.Distribution_Shares(Indice_Non_Labour_Income, : ) = [0.645435273 0.1095839245 0.2449808024 0.0];

// HH saving rate
Deriv_Exogenous.Household_saving_rate = 0.13925654620247;

// Composanste du GDP
Deriv_Exogenous.I_share = 0.19858623;
Deriv_Exogenous.C_share = 0.55661210;
Deriv_Exogenous.G_share = 0.26921374;
Deriv_Exogenous.TradeBalance_share = -0.02432740;

