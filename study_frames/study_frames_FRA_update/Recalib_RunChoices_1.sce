//////////////////////////
// Variables exogènes
//////////////////////////
// Exogenous NetFinancialDebt : Index_InstitAgents  = Corporations / Government / Households / RestOfWorld
Deriv_Exogenous.NetFinancialDebt = [2132930000.0 1707972000.0 -3583937000.0 -256965000.0];

// Exogenous Property_income : 	Index_InstitAgents  = Corporations / Government / Households / RestOfWorld
Deriv_Exogenous.Property_income = [-27426000.0 -26250000.0 76509000.0 -22833000.0];

// GFCF distribution by Agent
Deriv_Exogenous.GFCF_Distribution_Shares = [0.5864207144 0.1635198603 0.2500594253];

// Distribution shares
Deriv_Exogenous.Distribution_Shares = BY.Distribution_Shares;
Deriv_Exogenous.Distribution_Shares(Indice_Non_Labour_Income, : ) = [0.645435273 0.1095839245 0.2449808024 0.0];

// HH saving rate
Deriv_Exogenous.Household_saving_rate = 0.13925654620247;

// Composanste du GDP
Deriv_Exogenous.Consumption_budget   = 1164.859*1E6;
Deriv_Exogenous.G_Consumption_budget = 576.37*1E6;

// TEE update
Deriv_Exogenous.Exo_VA_Tax = 154.43*1E6; 
tau_VA_Tax_rate = 0; // initialisation
Deriv_Exogenous.Labour_Tax_rate = ones(Labour_Tax_rate) * 0.4529614495;
Deriv_Exogenous.Unemployment_transfers = 44500000.0;
Deriv_Exogenous.Pensions = 325300000.0;
Deriv_Exogenous.Other_social_transfers = 116492000.0;
Deriv_Exogenous.Corporate_Tax = 52.703884202*1E6;
Deriv_Exogenous.Income_Tax = 204.9277817862*1E6;
Deriv_Exogenous.Exo_Production_Tax = 57.0357330598*1E6; 
tau_Production_Tax_rate = 0; // initialisation

//////////////////////////
// Paramètres centraux
//////////////////////////
// Unemployment rate 
parameters.u_param = 0.07; //0.0923620
parameters.Coef_real_wage = 0.7;

// real GDP
parameters.Mu = 0.01;//0.0030318;
paramters.phi_L = parameters.Mu;

// Share of I in GDP
parameters.phi_K = -ones(parameters.phi_K)*0.005;//2;
Deriv_Exogenous.Betta = Betta*1.2;

// Energy prices (Gaz, AllFuels & Elec)
parameters.phi_K([2 4 5]) = [-0.44 -0.19 -0.075];
parameters.phi_IC = zeros(parameters.phi_IC);
parameters.phi_IC(Indice_NonEnerSect,[2 4 5]) = ones(Indice_NonEnerSect)'.*.[-0.44 -0.19 -0.075];



