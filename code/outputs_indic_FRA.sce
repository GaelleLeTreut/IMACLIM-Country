

if [H_DISAGG == "H20"] & [Country == "France"]

	Out.H_Primary_income = Out.H_disposable_income - Out.Other_Direct_Tax(Indice_Households) - Out.Income_Tax(Indice_Households);
	BY.H_Primary_income = ini.H_disposable_income - ini.Other_Direct_Tax(Indice_Households) - ini.Income_Tax(Indice_Households);	

	for k=1:nb_Households
		C_H20_qFish(1,k) = QInd_Fish( BY.pC, BY.C, Out.pC, Out.C, :, k);
		C_H20_pFish(1,k) = PInd_Fish( BY.pC, BY.C, Out.pC, Out.C, :, k);
	end

	Indice_Poor 	= 1;
	Indice_Lower	= 2:7;
	Indice_Middle 	= 8:13;
	Indice_Upper	= 14:19;
	Indice_Rich 	= 20;

	OutputTable.EquityEfficiency = [["Variables" 	"BY values" 																		"Variation to BY (+x%)"];
		["Total CO2 emissions", 					string(sum(BY.CO2Emis_IC)+sum(BY.CO2Emis_C))+" MtCO2",								round(1000*((sum(Out.CO2Emis_IC)+sum(Out.CO2Emis_C))./(sum(BY.CO2Emis_IC)+sum(BY.CO2Emis_C))-1))/10 + " %"];..
		["HH CO2 emissions",	 					string(sum(BY.CO2Emis_C))+" MtCO2",													round(1000*(sum(Out.CO2Emis_C)./(sum(BY.CO2Emis_C))-1))/10 + " %"];..
		["ENT CO2 emissions", 						string(sum(BY.CO2Emis_IC))+" MtCO2",												round(1000*(sum(Out.CO2Emis_IC)./(sum(BY.CO2Emis_IC))-1))/10 + " %"];..
		["Real GDP",			 					string(BY.GDP*money_disp_adj)+money_DUnit_short+money, 								round(1000*((Out.GDP/(GDP_pLasp*BY.GDP))-1))/10 + " %"];..
		["Total employment",						string(sum(BY.Labour))+Labour_unit,													round(1000*(sum(Out.Labour)/sum(BY.Labour)-1))/10 + " %"];..
		["Real investment",							string(sum(BY.I_value)*money_disp_adj)+money_DUnit_short+money,													round(1000*((sum(Out.I_value)/sum(I_pLasp*BY.I_value))-1))/10 + " %"];..
		["Producer price of the composite good",	"-",			 																	round(1000*(Y_NonEn_pLasp-1))/10 + " %"];..
		["Labour intensity of the composite good",	"-",																				round(1000*(lambda_NonEn_pLasp-1))/10 + " %"];..
		["Effective Consumption",					" ",																				" "];..
		["Total",									string(sum(BY.C_value)*money_disp_adj)+money_DUnit_short+money,						round(1000*(C_qFish-1))/10 + " %"];..
		["Poor (F0-5)",								string(sum(BY.C_value(:, Indice_Poor))*money_disp_adj)+money_DUnit_short+money,		round(1000*(QInd_Fish( BY.pC, BY.C, Out.pC, Out.C, :, Indice_Poor)-1))/10 + " %"];..
		["Lower class (F5-35)",						string(sum(BY.C_value(:, Indice_Lower))*money_disp_adj)+money_DUnit_short+money,	round(1000*(QInd_Fish( BY.pC, BY.C, Out.pC, Out.C, :, Indice_Lower)-1))/10 + " %"];..
		["Middle class (F35-65)",					string(sum(BY.C_value(:, Indice_Middle))*money_disp_adj)+money_DUnit_short+money,	round(1000*(QInd_Fish( BY.pC, BY.C, Out.pC, Out.C, :, Indice_Middle)-1))/10 + " %"];..
		["Upper class (F65-95)",					string(sum(BY.C_value(:, Indice_Upper))*money_disp_adj)+money_DUnit_short+money,	round(1000*(QInd_Fish( BY.pC, BY.C, Out.pC, Out.C, :, Indice_Upper)-1))/10 + " %"];..
		["Rich (F95-100)",							string(sum(BY.C_value(:, Indice_Rich))*money_disp_adj)+money_DUnit_short+money,		round(1000*(QInd_Fish( BY.pC, BY.C, Out.pC, Out.C, :, Indice_Rich)-1))/10 + " %"];..
		["Gini index",								Gini_indicator_bis(sum(BY.C_value,"r"),BY.Population),								round(1000*(Gini_indicator_bis(sum(Out.C_value,"r")./C_H20_pFish,Out.Population)/Gini_indicator_bis(sum(BY.C_value,"r"),BY.Population)-1))/10+ " %"];..
		["Share of H_disposable_income (pts)",		" ",																				" "];..
		["Poor (F0-5)",								BY.H_disposable_income(Indice_Poor)/sum(BY.H_disposable_income),					100*(Out.H_disposable_income(Indice_Poor)/sum(Out.H_disposable_income)-BY.H_disposable_income(Indice_Poor)/sum(BY.H_disposable_income))];..
		["Lower class (F5-35)",						sum(BY.H_disposable_income(Indice_Lower))/sum(BY.H_disposable_income),				100*(sum(Out.H_disposable_income(Indice_Lower))/sum(Out.H_disposable_income)-sum(BY.H_disposable_income(Indice_Lower))/sum(BY.H_disposable_income))];..
		["Middle class (F35-65)",					sum(BY.H_disposable_income(Indice_Middle))/sum(BY.H_disposable_income),				100*(sum(Out.H_disposable_income(Indice_Middle))/sum(Out.H_disposable_income)-sum(BY.H_disposable_income(Indice_Middle))/sum(BY.H_disposable_income))];..
		["Upper class (F65-95)",					sum(BY.H_disposable_income(Indice_Upper))/sum(BY.H_disposable_income),				100*(sum(Out.H_disposable_income(Indice_Upper))/sum(Out.H_disposable_income)-sum(BY.H_disposable_income(Indice_Upper))/sum(BY.H_disposable_income))];..
		["Rich (F95-100)",							BY.H_disposable_income(Indice_Rich)/sum(BY.H_disposable_income),					100*(Out.H_disposable_income(Indice_Rich)/sum(Out.H_disposable_income)-BY.H_disposable_income(Indice_Rich)/sum(BY.H_disposable_income))];..
		["Gini index (on Gross primary income)",	Gini_indicator_bis(BY.H_Primary_income,BY.Population),								100*(Gini_indicator_bis(Out.H_Primary_income,Out.Population)/Gini_indicator_bis(BY.H_Primary_income,BY.Population)-1)];..
		["Gini index (on Gross disposable income)", Gini_indicator_bis(BY.H_disposable_income,BY.Population)							100*(Gini_indicator_bis(Out.H_disposable_income,Out.Population)./Gini_indicator_bis(BY.H_disposable_income,BY.Population)-1)];..
		["", 										"", 																				""];..
		["Government expenditure (real)",			string(sum(BY.G_value)*money_disp_adj)+money_DUnit_short+money,						round(1000*((sum(Out.G_value)/sum(G_pLasp*BY.G_value))-1))/10+ "%"];..
		["Government expenditure (nom)",			string(sum(BY.G_value)*money_disp_adj)+money_DUnit_short+money,						round(1000*((sum(Out.G_value)/sum(BY.G_value))-1))/10 + "%"];..
		["Public debt to GDP ratio",				BY.NetFinancialDebt(Indice_Government)/BY.GDP,										(Out.NetFinancialDebt(Indice_Government)/Out.GDP)/(BY.NetFinancialDebt(Indice_Government)/BY.GDP)];..
		["Public net lending to GDP ratio",			BY.NetLending(Indice_Government)/BY.GDP,											(Out.NetLending(Indice_Government)/Out.GDP)/(BY.NetLending(Indice_Government)/BY.GDP)];..
		[money_DUnit_short+money+" stands for "+money_disp_unit+money,"",""];
		];
		
	if Output_files
	csvWrite(OutputTable.EquityEfficiency,SAVEDIR+"EquityEfficiency.csv", ';');
	end 
end