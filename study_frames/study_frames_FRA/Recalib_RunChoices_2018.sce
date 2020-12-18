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
//////////////////////////
// Paramètres centraux à caller 
//////////////////////////

// target definition 
// target.u_tot 				= 0.096657603;
// target.NetCompWages_byAgent	= 890.989561480099;
// target.CPI 					= 1.0847715321481;
// target.Trade_balance		= 54.3722247871991;
// target.pC = [1.35909757603164 1.1176459210912 1.11302943713353 1.25327047141911 1.27317747456186 1.37781176761594];
// target.pIndice = [Indice_Gas Indice_HH_Fuels Indice_Elec];

// // Recherche d'optimum ou simple résolution
// scal = [0.006715296522585	0.093911951945478	-0.101678127309367	0.711746891165572	-0.000791516714252	-0.002181565502178	0.002517190964051	-0.006136655189795	0.002517190964051	0.002517190964051	3.19838634592751E-05	0.002517190964051	-0.000350355690478];

if Optimum_Recal <> %T
	target.u_tot 				= 0.096657603;
	target.NetCompWages_byAgent	= 890.989561480099;
	target.CPI 					= 1.0847715321481;
	target.Trade_balance		= 54.3722247871991;
	target.M_value				= 481.634411627445;
	target.X_value				= 427.262186840246;
	target.pC = [1.35909757603164 1.1176459210912 1.11302943713353 1.25327047141911 1.27317747456186 1.37781176761594];
	target.pIndice = [Indice_Gas Indice_HH_Fuels Indice_Elec];

scal = [0.013479938172368	0.066173868682517..
		0.073686756678932..
		-0.025367784169615	-0.011498859862948..
		-0.559467206301469	2.01946027534565..
		0.062191070802509	0.014532244560709	-0.133449359806118	-0.141765614263338..	//-0.001338020171661	-0.016776238930613];
		-0.15	-0.016776238930613];

	parameters.Mu = scal(1);
	parameters.phi_L = ones(Indice_Sectors)*parameters.Mu;
	parameters.u_param = scal(2);
	parameters.phi_K = ones(Indice_Sectors)*scal(3);
	parameters.sigma_M = zeros(parameters.sigma_M);
	parameters.delta_M_parameter(Indice_NonEnerSect)=ones(parameters.delta_M_parameter(Indice_NonEnerSect))*scal(4);
	parameters.sigma_X = zeros(parameters.sigma_X);
	parameters.delta_X_parameter(Indice_NonEnerSect)=ones(parameters.delta_X_parameter(Indice_NonEnerSect))*scal(5);
	parameters.sigma_omegaU = scal(6);
	parameters.Coef_real_wage = scal(7);

	// Energy prices (Gaz, AllFuels & Elec)
	parameters.phi_K(target.pIndice) = [scal(8) scal(9) scal(10) scal(11) scal(12) scal(13)]; // scal(8:13) ne fonctionne pas !! 
	parameters.phi_L(target.pIndice)= [scal(8) scal(9) scal(10) scal(11) scal(12) scal(13)];
	parameters.phi_IC = zeros(parameters.phi_IC);
	parameters.phi_IC(Indice_NonEnerSect,target.pIndice) = ones(Indice_NonEnerSect)'.*.[scal(8) scal(9) scal(10) scal(11) scal(12) scal(13)];

end

