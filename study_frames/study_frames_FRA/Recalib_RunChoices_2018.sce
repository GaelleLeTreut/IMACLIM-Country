//////////////////////////
// Variables exogènes
//////////////////////////

// import DataAccountTable 2018
DataAccountTable_2018(1,:)=[];
Var_2018 = DataAccountTable_2018(:,1);
DataAccountTable_2018(:,1)=[];
DataAccountTable_2018=eval(DataAccountTable_2018);

// Exogenous NetFinancialDebt : Index_InstitAgents  = Corporations / Government / Households / RestOfWorld
Deriv_Exogenous.NetFinancialDebt = BY.NetFinancialDebt;
Deriv_Exogenous.NetFinancialDebt = DataAccountTable_2018(find(Var_2018 == 'NetFinancialDebt'),:);

// Exogenous Property_income : 	Index_InstitAgents  = Corporations / Government / Households / RestOfWorld
Deriv_Exogenous.Property_income = BY.Property_income;
Deriv_Exogenous.Property_income = DataAccountTable_2018(find(Var_2018 == 'Property_income'),:);

// GFCF distribution by Agent
Deriv_Exogenous.GFCF_Distribution_Shares = BY.GFCF_Distribution_Shares; // ajouter une calibration de ça... ça sera plus simple
Deriv_Exogenous.GFCF_Distribution_Shares = DataAccountTable_2018(find(Var_2018 == 'GFCF_byAgent'),1:3)/sum(DataAccountTable_2018(find(Var_2018 == 'GFCF_byAgent'),1:3));

// Distribution shares
Deriv_Exogenous.Distribution_Shares = BY.Distribution_Shares;
Deriv_Exogenous.Distribution_Shares(Indice_Non_Labour_Income,:) = DataAccountTable_2018(find(Var_2018 == 'GOS_byAgent'),:)/sum(DataAccountTable_2018(find(Var_2018 == 'GOS_byAgent'),:));

// HH saving rate
Deriv_Exogenous.HH_saving_rate_agg = 1 - DataAccountTable_2018(find(Var_2018 == 'FC_byAgent'),Indice_Households)/DataAccountTable_2018(find(Var_2018 == 'Disposable_Income'),Indice_Households);

// Composanste du GDP
Deriv_Exogenous.G_Consumption_budget = DataAccountTable_2018(find(Var_2018 == 'FC_byAgent'),Indice_Government);
Deriv_Exogenous.I_Consumption_budget = sum(DataAccountTable_2018(find(Var_2018 == 'GFCF_byAgent'),:));

// // TEE update
Deriv_Exogenous.Labour_Tax_rate = ones(Labour_Tax_rate) * DataAccountTable_2018(find(Var_2018 == 'InsuranceContrib_byAgent'),2)/sum(DataAccountTable_2018(find(Var_2018 == 'NetCompWages_byAgent'),Indice_Households));
Deriv_Exogenous.Unemployment_transfers = DataAccountTable_2018(find(Var_2018 == 'Unemployment_transfers'),Indice_Households)*BY.Unemployment_transfers/sum(BY.Unemployment_transfers);
Deriv_Exogenous.Pensions = DataAccountTable_2018(find(Var_2018 == 'Pensions'),Indice_Households)*BY.Pensions/sum(BY.Pensions);
Deriv_Exogenous.Other_social_transfers = DataAccountTable_2018(find(Var_2018 == 'Other_social_transfers'),Indice_Households)*BY.Other_social_transfers/sum(Other_social_transfers);
Deriv_Exogenous.Corporate_Tax = DataAccountTable_2018(find(Var_2018 == 'Corporate_Tax'),Indice_Government);
Deriv_Exogenous.Income_Tax = DataAccountTable_2018(find(Var_2018 == 'Income_Tax'),Indice_Government)*BY.Income_Tax/sum(BY.Income_Tax);
Deriv_Exogenous.Production_Tax_byAgent = DataAccountTable_2018(find(Var_2018 == 'Production_Tax_byAgent'),Indice_Government); 
Deriv_Exogenous.VA_Tax_byAgent = DataAccountTable_2018(find(Var_2018 == 'VA_Tax_byAgent'),Indice_Government); 
Deriv_Exogenous.GOS_total = sum(DataAccountTable_2018(find(Var_2018 == 'GOS_byAgent'),:));
Deriv_Exogenous.Other_Transfers = DataAccountTable_2018(find(Var_2018 == 'Other_Transfers'),:);
Deriv_Exogenous.Other_Direct_Tax = DataAccountTable_2018(find(Var_2018 == 'Other_Direct_Tax'),Indice_Government);

// Update energy taxes
Energy_tax_params = [0	109.74025974026	170	0	1.10874938210578	1.92472118959108	0	1.38655462184874	2.75971731448763	7.54054054054054	261.627906976744	0];
Energy_tax_mask  = [0	1	1	0	0	0	0	0	0	0	1	1];
Deriv_Exogenous.Energy_Tax_rate_FC = calib.Energy_Tax_rate_FC;
Deriv_Exogenous.Energy_Tax_rate_FC(Indice_EnerSect) = 	(Energy_tax_mask == 1).*Energy_tax_params + ..
														(Energy_tax_mask <> 1).*Deriv_Exogenous.Energy_Tax_rate_FC(Indice_EnerSect).*Energy_tax_params;

Deriv_Exogenous.Energy_Tax_rate_IC = calib.Energy_Tax_rate_IC;
Deriv_Exogenous.Energy_Tax_rate_IC(Indice_EnerSect) = Deriv_Exogenous.Energy_Tax_rate_FC(Indice_EnerSect) .* [1 0.547794117647059 0 0 1 1 1 1 1 1 0.606923506420994 1];

//////////////////////////
// Paramètres centraux à caller 
//////////////////////////
// copier coller de l'optimisation 
// créer une fonction unique plus tard 
// isoler l'ensemble des fonctions dans lib ??? 

// target
exec("find_optimum.sce");

// scals
scal_1 = [0.00616094912332	0.110117793907716	-0.076518082236339	0.052963910996107	0.053905071516345	-0.097682691495862	0.800760033157237];
scal_2 = [0.130804270985452	1.83123335722652	1.06698165358753	-0.008425396395677	1.48385247754645	1.29201784433981];
scal_3 = [0.028134974871905	-0.125018375449198	-0.153567859605146	0.067769410113357	1.48703828295866	1.13349907122075	0.14603334935936	2.23020802705819	2.05769795931865];
scal_4 = [0.806995088789325	0.403198744232868	1.52927141113606	1.32870529350748	1.21338731782569	1.28588067122097	2.14549015484176	-0.010097621097958	1.07177347351213	1.42391973031022	0.894453495141674	0.188394389784593	1.29494532565261	0.059880657032697];

// set results of previsous optimisation
parameters.Mu = scal_1(1);
parameters.phi_L = ones(Indice_Sectors)*parameters.Mu;
parameters.u_param = scal_1(2);
parameters.phi_K = ones(Indice_Sectors)*scal_1(3);
parameters.sigma_M = zeros(parameters.sigma_M);
parameters.delta_M_parameter(Indice_NonEnerSect)=ones(parameters.delta_M_parameter(Indice_NonEnerSect))*scal_1(4);
parameters.sigma_X = zeros(parameters.sigma_X);
parameters.delta_X_parameter(Indice_NonEnerSect)=ones(parameters.delta_X_parameter(Indice_NonEnerSect))*scal_1(5);
parameters.sigma_omegaU = scal_1(6);
parameters.Coef_real_wage = scal_1(7);

// init SpeMarg
Deriv_Exogenous.SpeMarg_rates_C 	= BY.SpeMarg_rates_C;
Deriv_Exogenous.SpeMarg_rates_G 	= BY.SpeMarg_rates_G;
Deriv_Exogenous.SpeMarg_rates_I 	= BY.SpeMarg_rates_I;
Deriv_Exogenous.SpeMarg_rates_X 	= BY.SpeMarg_rates_X;
Deriv_Exogenous.SpeMarg_rates_IC 	= BY.SpeMarg_rates_IC;

// Gaz
parameters.phi_K(Indice_Gas) 		= scal_2(1);
parameters.phi_L(Indice_Gas)	= scal_2(1);
parameters.phi_IC(Indice_NonEnerSect,Indice_Gas) = ones(size(Indice_NonEnerSect,2),size(Indice_Gas,1))*scal_2(1);
Deriv_Exogenous.SpeMarg_rates_C(Indice_Gas)	= BY.SpeMarg_rates_C(Indice_Gas) .* [(BY.SpeMarg_rates_C(Indice_Gas) >= 0).*scal_2(2) + (BY.SpeMarg_rates_C(Indice_Gas) < 0).*scal_2(3)];
Deriv_Exogenous.SpeMarg_rates_G(Indice_Gas)	= BY.SpeMarg_rates_G(Indice_Gas) .* [(BY.SpeMarg_rates_G(Indice_Gas) >= 0).*scal_2(2) + (BY.SpeMarg_rates_G(Indice_Gas) < 0).*scal_2(3)];
Deriv_Exogenous.SpeMarg_rates_I(Indice_Gas)	= BY.SpeMarg_rates_I(Indice_Gas) .* [(BY.SpeMarg_rates_I(Indice_Gas) >= 0).*scal_2(2) + (BY.SpeMarg_rates_I(Indice_Gas) < 0).*scal_2(3)];
Deriv_Exogenous.SpeMarg_rates_X(Indice_Gas)	= BY.SpeMarg_rates_X(Indice_Gas) .* [(BY.SpeMarg_rates_X(Indice_Gas) >= 0).*scal_2(2) + (BY.SpeMarg_rates_X(Indice_Gas) < 0).*scal_2(3)];
Deriv_Exogenous.SpeMarg_rates_IC(:,Indice_Gas)= BY.SpeMarg_rates_IC(:,Indice_Gas).*[(BY.SpeMarg_rates_IC(:,Indice_Gas) >= 0).*(ones(Indice_Sectors').*.scal_2(2)) + (BY.SpeMarg_rates_IC(:,Indice_Gas) < 0).*(ones(Indice_Sectors').*.scal_2(3))];

// Électricité
parameters.phi_K(Indice_Elec) 	= scal_2(4);
parameters.phi_L(Indice_Elec)	= scal_2(4);
parameters.phi_IC(Indice_NonEnerSect,Indice_Elec) = ones(size(Indice_NonEnerSect,2),size(Indice_Elec,1))*scal_2(4);
Deriv_Exogenous.SpeMarg_rates_C(Indice_Elec)	= BY.SpeMarg_rates_C(Indice_Elec) .* [(BY.SpeMarg_rates_C(Indice_Elec) >= 0).*scal_2(5) + (BY.SpeMarg_rates_C(Indice_Elec) < 0).*scal_2(6)];
Deriv_Exogenous.SpeMarg_rates_G(Indice_Elec)	= BY.SpeMarg_rates_G(Indice_Elec) .* [(BY.SpeMarg_rates_G(Indice_Elec) >= 0).*scal_2(5) + (BY.SpeMarg_rates_G(Indice_Elec) < 0).*scal_2(6)];
Deriv_Exogenous.SpeMarg_rates_I(Indice_Elec)	= BY.SpeMarg_rates_I(Indice_Elec) .* [(BY.SpeMarg_rates_I(Indice_Elec) >= 0).*scal_2(5) + (BY.SpeMarg_rates_I(Indice_Elec) < 0).*scal_2(6)];
Deriv_Exogenous.SpeMarg_rates_X(Indice_Elec)	= BY.SpeMarg_rates_X(Indice_Elec) .* [(BY.SpeMarg_rates_X(Indice_Elec) >= 0).*scal_2(5) + (BY.SpeMarg_rates_X(Indice_Elec) < 0).*scal_2(6)];
Deriv_Exogenous.SpeMarg_rates_IC(:,Indice_Elec)= BY.SpeMarg_rates_IC(:,Indice_Elec).*[(BY.SpeMarg_rates_IC(:,Indice_Elec) >= 0).*(ones(Indice_Sectors').*.scal_2(5)) + (BY.SpeMarg_rates_IC(:,Indice_Elec) < 0).*(ones(Indice_Sectors').*.scal_2(6))];

// Fuels 
parameters.phi_K(Indice_HH_Fuels) 	= [scal_3(1), scal_3(2), scal_3(3)];
parameters.phi_L(Indice_HH_Fuels)	= [scal_3(1), scal_3(2), scal_3(3)];
parameters.phi_IC(Indice_NonEnerSect,Indice_HH_Fuels) = ones(Indice_NonEnerSect').*.[scal_3(1), scal_3(2), scal_3(3)];
Deriv_Exogenous.SpeMarg_rates_C(Indice_HH_Fuels)	= BY.SpeMarg_rates_C(Indice_HH_Fuels) .* [(BY.SpeMarg_rates_C(Indice_HH_Fuels) >= 0).*[scal_3(4), scal_3(5), scal_3(6)] + (BY.SpeMarg_rates_C(Indice_HH_Fuels) < 0).*[scal_3(7), scal_3(8), scal_3(9)]];
Deriv_Exogenous.SpeMarg_rates_G(Indice_HH_Fuels)	= BY.SpeMarg_rates_G(Indice_HH_Fuels) .* [(BY.SpeMarg_rates_G(Indice_HH_Fuels) >= 0).*[scal_3(4), scal_3(5), scal_3(6)] + (BY.SpeMarg_rates_G(Indice_HH_Fuels) < 0).*[scal_3(7), scal_3(8), scal_3(9)]];
Deriv_Exogenous.SpeMarg_rates_I(Indice_HH_Fuels)	= BY.SpeMarg_rates_I(Indice_HH_Fuels) .* [(BY.SpeMarg_rates_I(Indice_HH_Fuels) >= 0).*[scal_3(4), scal_3(5), scal_3(6)] + (BY.SpeMarg_rates_I(Indice_HH_Fuels) < 0).*[scal_3(7), scal_3(8), scal_3(9)]];
Deriv_Exogenous.SpeMarg_rates_X(Indice_HH_Fuels)	= BY.SpeMarg_rates_X(Indice_HH_Fuels) .* [(BY.SpeMarg_rates_X(Indice_HH_Fuels) >= 0).*[scal_3(4), scal_3(5), scal_3(6)] + (BY.SpeMarg_rates_X(Indice_HH_Fuels) < 0).*[scal_3(7), scal_3(8), scal_3(9)]];
Deriv_Exogenous.SpeMarg_rates_IC(:,Indice_HH_Fuels) = BY.SpeMarg_rates_IC(:,Indice_HH_Fuels).*[(BY.SpeMarg_rates_IC(:,Indice_HH_Fuels) >= 0).*(ones(Indice_Sectors').*.[scal_3(4), scal_3(5), scal_3(6)]) + (BY.SpeMarg_rates_IC(:,Indice_HH_Fuels) < 0).*(ones(Indice_Sectors').*.[scal_3(7), scal_3(8), scal_3(9)])];

//other energ
Deriv_Exogenous.SpeMarg_rates_C(Indice_OtherEner)	= BY.SpeMarg_rates_C(Indice_OtherEner) .* [(BY.SpeMarg_rates_C(Indice_OtherEner) >= 0).*[scal_4(1) scal_4(2) scal_4(3) scal_4(4) scal_4(5) scal_4(6) scal_4(7)] + (BY.SpeMarg_rates_C(Indice_OtherEner) < 0).*[scal_4(8) scal_4(9) scal_4(10) scal_4(11) scal_4(12) scal_4(13) scal_4(14)]];
Deriv_Exogenous.SpeMarg_rates_G(Indice_OtherEner)	= BY.SpeMarg_rates_G(Indice_OtherEner) .* [(BY.SpeMarg_rates_G(Indice_OtherEner) >= 0).*[scal_4(1) scal_4(2) scal_4(3) scal_4(4) scal_4(5) scal_4(6) scal_4(7)] + (BY.SpeMarg_rates_G(Indice_OtherEner) < 0).*[scal_4(8) scal_4(9) scal_4(10) scal_4(11) scal_4(12) scal_4(13) scal_4(14)]];
Deriv_Exogenous.SpeMarg_rates_I(Indice_OtherEner)	= BY.SpeMarg_rates_I(Indice_OtherEner) .* [(BY.SpeMarg_rates_I(Indice_OtherEner) >= 0).*[scal_4(1) scal_4(2) scal_4(3) scal_4(4) scal_4(5) scal_4(6) scal_4(7)] + (BY.SpeMarg_rates_I(Indice_OtherEner) < 0).*[scal_4(8) scal_4(9) scal_4(10) scal_4(11) scal_4(12) scal_4(13) scal_4(14)]];
Deriv_Exogenous.SpeMarg_rates_X(Indice_OtherEner)	= BY.SpeMarg_rates_X(Indice_OtherEner) .* [(BY.SpeMarg_rates_X(Indice_OtherEner) >= 0).*[scal_4(1) scal_4(2) scal_4(3) scal_4(4) scal_4(5) scal_4(6) scal_4(7)] + (BY.SpeMarg_rates_X(Indice_OtherEner) < 0).*[scal_4(8) scal_4(9) scal_4(10) scal_4(11) scal_4(12) scal_4(13) scal_4(14)]];
Deriv_Exogenous.SpeMarg_rates_IC(:,Indice_OtherEner)= BY.SpeMarg_rates_IC(:,Indice_OtherEner).*[..
	(BY.SpeMarg_rates_IC(:,Indice_OtherEner) >= 0).*(ones(Indice_Sectors').*.[scal_4(1) scal_4(2) scal_4(3) scal_4(4) scal_4(5) scal_4(6) scal_4(7)]) + ..
	(BY.SpeMarg_rates_IC(:,Indice_OtherEner) < 0).*(ones(Indice_Sectors').*.[scal_4(8) scal_4(9) scal_4(10) scal_4(11) scal_4(12) scal_4(13) scal_4(14)]) ..
	];
