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
Deriv_Exogenous.HH_saving_rate_agg = 0.144415215890488; // à inverser en forçant la consommation des ménages ? 

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
scal_1 = [0.011984926156042	0.046391781928944	0.023514364417092	-0.01934599655494	-0.011369115130157	-0.130937525814799	0.468901671740756];
scal_2 = [0.258137716444485	1.81211799319418	1.09692823781033	-0.000638610379612	1.41220992402367	1.35058665073042	-0.110945300400332	0.000942498053351];
scal_3 = [0.006698907256563	-0.149690449998717	-0.176930607951945	-0.514710239666718	1.44936496678128	2.50061711513616	-0.608338566614057	0.541696808267123	4.53963965946791];

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
Deriv_Exogenous.SpeMarg_rates_IC 	= BY.SpeMarg_rates_IC;

// Gaz
parameters.phi_K(Indice_Gas) 		= scal_2(1);
parameters.phi_L(Indice_Gas)	= scal_2(1);
parameters.phi_IC(Indice_NonEnerSect,Indice_Gas) = ones(size(Indice_NonEnerSect,2),size(Indice_Gas,1))*scal_2(1);
Deriv_Exogenous.SpeMarg_rates_C(Indice_Gas)		= scal_2(2) * Deriv_Exogenous.SpeMarg_rates_C(Indice_Gas);
Deriv_Exogenous.SpeMarg_rates_IC(:,Indice_Gas)	= scal_2(3) * Deriv_Exogenous.SpeMarg_rates_IC(:,Indice_Gas);

// Électricité
parameters.phi_K(Indice_Elec) 	= scal_2(4);
parameters.phi_L(Indice_Elec)	= scal_2(4);
parameters.phi_IC(Indice_NonEnerSect,Indice_Elec) = ones(size(Indice_NonEnerSect,2),size(Indice_Elec,1))*scal_2(4);
Deriv_Exogenous.SpeMarg_rates_C(Indice_Elec)		= scal_2(5) * Deriv_Exogenous.SpeMarg_rates_C(Indice_Elec);
Deriv_Exogenous.SpeMarg_rates_IC(:,Indice_Elec)	= scal_2(6) * Deriv_Exogenous.SpeMarg_rates_IC(:,Indice_Elec);

// Crude_coal 
Deriv_Exogenous.SpeMarg_rates_C(3)	= scal_2(7) * Deriv_Exogenous.SpeMarg_rates_C(3);
Deriv_Exogenous.SpeMarg_rates_IC(:,3)	= scal_2(8) * Deriv_Exogenous.SpeMarg_rates_IC(:,3);

// Fuels 
parameters.phi_K(Indice_HH_Fuels) 	= [scal_3(1), scal_3(2), scal_3(3)];
parameters.phi_L(Indice_HH_Fuels)	= [scal_3(1), scal_3(2), scal_3(3)];
parameters.phi_IC(Indice_NonEnerSect,Indice_HH_Fuels) = ones(Indice_NonEnerSect').*.[scal_3(1), scal_3(2), scal_3(3)];
Deriv_Exogenous.SpeMarg_rates_C(Indice_HH_Fuels)	= Deriv_Exogenous.SpeMarg_rates_C(Indice_HH_Fuels).*[scal_3(4), scal_3(5), scal_3(6)];
Deriv_Exogenous.SpeMarg_rates_IC(:,Indice_HH_Fuels)	= Deriv_Exogenous.SpeMarg_rates_IC(:,Indice_HH_Fuels).*(ones(Indice_Sectors').*.[scal_3(7), scal_3(8), scal_3(9)]);
