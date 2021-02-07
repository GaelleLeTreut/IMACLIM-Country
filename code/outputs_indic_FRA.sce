//////////////////////////////////////////////////////////////////////////////
////// For equity - efficacity study on carbon tax
if nb_Households <> 1 & [Country == "France"]

	Out.H_Primary_income = Out.H_disposable_income - Out.Other_Direct_Tax(Indice_Households) - Out.Income_Tax(Indice_Households);
	BY.H_Primary_income = ini.H_disposable_income - ini.Other_Direct_Tax(Indice_Households) - ini.Income_Tax(Indice_Households);	

	for k=1:nb_Households
		HH_qFish(1,k) = QInd_Fish( BY.pC, BY.C, Out.pC, Out.C, :, k);
		HH_pFish(1,k) = PInd_Fish( BY.pC, BY.C, Out.pC, Out.C, :, k);
	end

	if [H_DISAGG == "H20"]
		Indice_Poor 	= 1;
		Indice_Lower	= 2:7;
		Indice_Middle 	= 8:13;
		Indice_Upper	= 14:19;
		Indice_Rich 	= 20;
		Name_Poor = "(F0-5)";
		Name_Lower = "(F5-35)";
		Name_Middle = "(F35-65)";
		Name_Upper = "(F65-95)";
		Name_Rich = "(F95-100)";
	end
	if [H_DISAGG == "H10"]
		Indice_Poor 	= 1;
		Indice_Lower	= 2:3;
		Indice_Middle 	= 4:7;
		Indice_Upper	= 8:9;
		Indice_Rich 	= 10;
		Name_Poor = "(F0-10)";
		Name_Lower = "(F10-30)";
		Name_Middle = "(F40-70)";
		Name_Upper = "(F70-90)";
		Name_Rich = "(F90-100)";
	end

	LabTaxShare 	= sum((Labour_Tax_Cut * ones(1, nb_Sectors)).* w .* lambda .* Y')/sum(Carbon_Tax);
	LumpSumShare 	= sum(ClimPolicyCompens(Indice_Households))/sum(Carbon_Tax);
	OtherTransfShare= sum(Other_SocioBenef.* (AdjRecycle.*ones(1,nb_Households).*Exo_HH).*Population)/sum(Carbon_Tax);

	if simu_name == ""
		header = Recycling_Option;
	else 
		header = simu_name;
	end

	OutputTable.EquityEfficiency = [..
		["Variables" 								"BY values" 																		header];..
		["Total CO2 emissions", 					string(sum(BY.CO2Emis_IC)+sum(BY.CO2Emis_C))+" MtCO2",								round(1000*((sum(Out.CO2Emis_IC)+sum(Out.CO2Emis_C))./(sum(BY.CO2Emis_IC)+sum(BY.CO2Emis_C))-1))/10 + " %"];..
		["HH CO2 emissions",	 					string(sum(BY.CO2Emis_C))+" MtCO2",													round(1000*(sum(Out.CO2Emis_C)./(sum(BY.CO2Emis_C))-1))/10 + " %"];..
		["ENT CO2 emissions", 						string(sum(BY.CO2Emis_IC))+" MtCO2",												round(1000*(sum(Out.CO2Emis_IC)./(sum(BY.CO2Emis_IC))-1))/10 + " %"];..
		["CO2 emissions reduction",					"",																					round(100 * (sum(Out.CO2Emis_IC) - sum(BY.CO2Emis_IC) + sum(Out.CO2Emis_C) - sum(BY.CO2Emis_C)))/100 + " MtCO2"];..
		["Carbon Tax rate", 						"", 																				round(Carbon_Tax_rate)*1E-3 + " €/tCO2"];..
		["Share spent in LabTax reductions",		"",																					round(1000*LabTaxShare)/ 10 + " %"];.. 	
		["Share spent in LumpSum transfers",		"",																					round(1000*(LumpSumShare + OtherTransfShare))/ 10 + " %"];..
		["Real GDP",			 					string(BY.GDP*money_disp_adj)+money_DUnit_short+money, 								round(1000*((Out.GDP/(GDP_pLasp*BY.GDP))-1))/10 + " %"];..
		["Total employment",						string(sum(BY.Labour))+Labour_unit,													round(1000*(sum(Out.Labour)/sum(BY.Labour)-1))/10 + " %"];..
		["Real investment",							string(sum(BY.I_value)*money_disp_adj)+money_DUnit_short+money,						round(1000*((sum(Out.I_value)/sum(I_pLasp*BY.I_value))-1))/10 + " %"];..
		["Producer price of the composite good",	"-",			 																	round(1000*(Y_NonEn_pLasp-1))/10 + " %"];..
		["Labour intensity of the composite good",	"-",																				round(1000*(lambda_NonEn_pLasp-1))/10 + " %"];..
		["Effective Consumption",					" ",																				" "];..
		["Total",									string(sum(BY.C_value)*money_disp_adj)+money_DUnit_short+money,						round(1000*(C_qFish-1))/10 + " %"];..
		["Poor " + Name_Poor,						string(sum(BY.C_value(:, Indice_Poor))*money_disp_adj)+money_DUnit_short+money,		round(1000*(QInd_Fish( BY.pC, BY.C, Out.pC, Out.C, :, Indice_Poor)-1))/10 + " %"];..
		["Lower class " + Name_Lower,				string(sum(BY.C_value(:, Indice_Lower))*money_disp_adj)+money_DUnit_short+money,	round(1000*(QInd_Fish( BY.pC, BY.C, Out.pC, Out.C, :, Indice_Lower)-1))/10 + " %"];..
		["Middle class " + Name_Middle,				string(sum(BY.C_value(:, Indice_Middle))*money_disp_adj)+money_DUnit_short+money,	round(1000*(QInd_Fish( BY.pC, BY.C, Out.pC, Out.C, :, Indice_Middle)-1))/10 + " %"];..
		["Upper class " + Name_Upper,				string(sum(BY.C_value(:, Indice_Upper))*money_disp_adj)+money_DUnit_short+money,	round(1000*(QInd_Fish( BY.pC, BY.C, Out.pC, Out.C, :, Indice_Upper)-1))/10 + " %"];..
		["Rich " + Name_Rich,						string(sum(BY.C_value(:, Indice_Rich))*money_disp_adj)+money_DUnit_short+money,		round(1000*(QInd_Fish( BY.pC, BY.C, Out.pC, Out.C, :, Indice_Rich)-1))/10 + " %"];..
		["Gini index",								Gini_indicator_bis(sum(BY.C_value,"r"),BY.Population),								round(1000*(Gini_indicator_bis(sum(Out.C_value,"r")./HH_pFish,Out.Population)/Gini_indicator_bis(sum(BY.C_value,"r"),BY.Population)-1))/10+ " %"];..
		["Share of H_disposable_income (pts)",		" ",																				" "];..
		["Poor " + Name_Poor,						BY.H_disposable_income(Indice_Poor)/sum(BY.H_disposable_income),					100*(Out.H_disposable_income(Indice_Poor)/sum(Out.H_disposable_income)-BY.H_disposable_income(Indice_Poor)/sum(BY.H_disposable_income))];..
		["Lower class " + Name_Lower,				sum(BY.H_disposable_income(Indice_Lower))/sum(BY.H_disposable_income),				100*(sum(Out.H_disposable_income(Indice_Lower))/sum(Out.H_disposable_income)-sum(BY.H_disposable_income(Indice_Lower))/sum(BY.H_disposable_income))];..
		["Middle class " + Name_Middle,				sum(BY.H_disposable_income(Indice_Middle))/sum(BY.H_disposable_income),				100*(sum(Out.H_disposable_income(Indice_Middle))/sum(Out.H_disposable_income)-sum(BY.H_disposable_income(Indice_Middle))/sum(BY.H_disposable_income))];..
		["Upper class " + Name_Upper,				sum(BY.H_disposable_income(Indice_Upper))/sum(BY.H_disposable_income),				100*(sum(Out.H_disposable_income(Indice_Upper))/sum(Out.H_disposable_income)-sum(BY.H_disposable_income(Indice_Upper))/sum(BY.H_disposable_income))];..
		["Rich " + Name_Rich,						BY.H_disposable_income(Indice_Rich)/sum(BY.H_disposable_income),					100*(Out.H_disposable_income(Indice_Rich)/sum(Out.H_disposable_income)-BY.H_disposable_income(Indice_Rich)/sum(BY.H_disposable_income))];..
		["Gini index (on Gross primary income)",	Gini_indicator_bis(BY.H_Primary_income,BY.Population),								100*(Gini_indicator_bis(Out.H_Primary_income,Out.Population)/Gini_indicator_bis(BY.H_Primary_income,BY.Population)-1)];..
		["Gini index (on Gross disposable income)", Gini_indicator_bis(BY.H_disposable_income,BY.Population)							100*(Gini_indicator_bis(Out.H_disposable_income,Out.Population)./Gini_indicator_bis(BY.H_disposable_income,BY.Population)-1)];..
		["", 										"", 																				""];..
		["Government expenditure (real)",			string(sum(BY.G_value)*money_disp_adj)+money_DUnit_short+money,						round(1000*((sum(Out.G_value)/sum(G_pLasp*BY.G_value))-1))/10+ "%"];..
		["Government expenditure (nom)",			string(sum(BY.G_value)*money_disp_adj)+money_DUnit_short+money,						round(1000*((sum(Out.G_value)/sum(BY.G_value))-1))/10 + "%"];..
		["Public debt to GDP ratio",				BY.NetFinancialDebt(Indice_Government)/BY.GDP,										round(1000*((sum(Out.NetFinancialDebt(Indice_Government)/Out.GDP)/sum(BY.NetFinancialDebt(Indice_Government)/BY.GDP))-1))/10 + "%"];..
		["Public net lending to GDP ratio",			BY.NetLending(Indice_Government)/BY.GDP,											round(1000*((sum(Out.NetLending(Indice_Government)/Out.GDP)/sum(BY.NetLending(Indice_Government)/BY.GDP))-1))/10 + "%"];..
		["RoW debt to GDP ratio",					BY.NetFinancialDebt(Indice_RestOfWorld)/BY.GDP,										round(1000*((sum(Out.NetFinancialDebt(Indice_RestOfWorld)/Out.GDP)/sum(BY.NetFinancialDebt(Indice_RestOfWorld)/BY.GDP))-1))/10 + "%"];..
		["RoW net lending to GDP ratio",			BY.NetLending(Indice_RestOfWorld)/BY.GDP,											round(1000*((sum(Out.NetLending(Indice_RestOfWorld)/Out.GDP)/sum(BY.NetLending(Indice_RestOfWorld)/BY.GDP))-1))/10 + "%"];..
		[money_DUnit_short+money+" stands for "+money_disp_unit+money,"",""];..
		["", "", ""];..
		["sigma_X", 		"", 		string(sigma_X(4))];..
		["sigma_M",			"", 		string(sigma_M(4))];..
		["sigma_omegaU",	"",		 	string(sigma_omegaU)];..
		["Coef_real_wage", 	"", 		string(Coef_real_wage)];..
		];
		
	if Output_files
	csvWrite(OutputTable.EquityEfficiency,SAVEDIR+"EquityEfficiency.csv", ';');
	end 
end


exec("ProdPriceDecomposition.sce");

//////////////////////////////////////////////////////////////////////////////

////// Covid 
/// Temporary - to be delete
if part(Macro_nb,1:length('Cov'))=="Cov"
OutputTable("FullTemplate_"+ref_name)=[OutputTable("FullTemplate_"+ref_name);
["---Public transfers for HH in nominal terms in "+money_disp_unit+money+"---",			 ""							];..
["Unemployment transfers"+" HH"+(1:nb_Households)',						money_disp_adj.*Out.Unemployment_transfers(Indice_Households)'						];..
["Pensions"+" HH"+(1:nb_Households)',									(money_disp_adj.*Out.Pensions(Indice_Households))'										];..
["Other social transfers"+" HH"+(1:nb_Households)',						(money_disp_adj.*Out.Other_social_transfers(Indice_Households))'					];..
["---Public transfers/GDP ratio in nominal terms---",			 ""							];..
["Unemployment transfers"+" HH"+(1:nb_Households)',						((money_disp_adj.*Out.Unemployment_transfers(Indice_Households)/Out.GDP)*100)'				];..
["Pensions"+" HH"+(1:nb_Households)',									((money_disp_adj.*Out.Pensions(Indice_Households)/Out.GDP)*100)'		  					];..
["Other social transfers"+" HH"+(1:nb_Households)',						((money_disp_adj.*Out.Other_social_transfers(Indice_Households)/Out.GDP)*100)'					];..
["---Demography---",			 ""							];..
["Population"+" ClassHH"+(1:nb_Households)', Out.Population'						];..
["Labour force"+" ClassHH"+(1:nb_Households)', Out.Labour_force'						];..
];
end












