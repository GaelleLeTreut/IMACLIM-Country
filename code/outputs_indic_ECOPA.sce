//////  Copyright or © or Copr. Ecole des Ponts ParisTech / CNRS 2018
//////  Main Contributor (2017) : Gaëlle Le Treut / letreut[at]centre-cired.fr
//////  Contributors : Emmanuel Combet, Ruben Bibas, Julien Lefèvre
//////  
//////  
//////  This software is a computer program whose purpose is to centralise all  
//////  the IMACLIM national versions, a general equilibrium model for energy transition analysis
//////
//////  This software is governed by the CeCILL license under French law and
//////  abiding by the rules of distribution of free software.  You can  use,
//////  modify and/ or redistribute the software under the terms of the CeCILL
//////  license as circulated by CEA, CNRS and INRIA at the following URL
//////  "http://www.cecill.info".
//////  
//////  As a counterpart to the access to the source code and  rights to copy,
//////  modify and redistribute granted by the license, users are provided only
//////  with a limited warranty  and the software's author,  the holder of the
//////  economic rights,  and the successive licensors  have only  limited
//////  liability.
//////  
//////  In this respect, the user's attention is drawn to the risks associated
//////  with loading,  using,  modifying and/or developing or reproducing the
//////  software by the user in light of its specific status of free software,
//////  that may mean  that it is complicated to manipulate,  and  that  also
//////  therefore means  that it is reserved for developers  and  experienced
//////  professionals having in-depth computer knowledge. Users are therefore
//////  encouraged to load and test the software's suitability as regards their
//////  requirements in conditions enabling the security of their systems and/or 
//////  data to be ensured and,  more generally, to use and operate it in the
//////  same conditions as regards security.
//////  
//////  The fact that you are presently reading this means that you have had
//////  knowledge of the CeCILL license and that you accept its terms.
//////////////////////////////////////////////////////////////////////////////////

//	Computation of a Gini Index - Discrete linear approximation 

function y = Gini( Population, H_disposable_income) ;

//	Cumulated proportion of the population variable
	Population_Cumul = [0];
	Pop_Cumul_Prop = [0];
	Population_Cumul($+1) = Population(1);
	Pop_Cumul_Prop($+1) = Population_Cumul(2) / sum(Population) ;

	for i=2:nb_Households
		Population_Cumul($+1) = Population(i) + Population_Cumul(i);
		Pop_Cumul_Prop($+1) 	 = Population_Cumul(i+1) / sum(Population) ;
	end

//	Cumulated proportion of the disposable income variable
	Income_Cumul = [0];
	Income_Cumul_Prop = [0];
	Income_Cumul($+1) 		= H_disposable_income(1);
	Income_Cumul_Prop($+1) 	= Income_Cumul(2) / sum(H_disposable_income) ;

	for i=2:nb_Households
		Income_Cumul($+1) 		= H_disposable_income(i) + Income_Cumul(i);
		Income_Cumul_Prop($+1) 	= Income_Cumul(i+1) / sum(H_disposable_income) ;
	end

//	Approximation of the Lorenz curve on each interval as a line between consecutive points
	A = [];
	B = [];
	
	for i=2:nb_Households+1
		A($+1) = Pop_Cumul_Prop(i) - Pop_Cumul_Prop(i-1);
	end

	for i=2:nb_Households+1
		B($+1) = Income_Cumul_Prop(i) + Income_Cumul_Prop(i-1);
	end

	y = 1 - sum( A .* B );
endfunction

	///	Consumptions by households group and by commodity
 
Index_Composite = find(Index_Sectors=="Composite");

//	Households Expenditures 

Index_Sectors_ECOPA = Index_Sectors;
Index_Sectors_ECOPA(Index_Composite) = "Equipment";
Index_Sectors_ECOPA($+1)= "Housing";
Index_Sectors_ECOPA($+1)= "Clothes";
Index_Sectors_ECOPA($+1)= "Services";

nb_Sectors_ECOPA = size(Index_Sectors_ECOPA,1);

Share_Equipment 	=0.0901181055265676;
Share_Housing 	= 0.317922725256654;
Share_Clothes 	= 0.0617566678808701;
Share_Services 	=0.530202501335908;

Dist_Key_Equipment 	= [0.037049098, 0.045223947, 0.056224223, 0.071515967, 0.079632841, 0.096164605, 0.10975515, 0.131128824, 0.151478232, 0.221827114];
Dist_Key_Housing 		= [0.084333393, 0.085679651, 0.099748153, 0.100921577, 0.100887633, 0.104057244, 0.104291792, 0.096893149, 0.103970594, 0.119216814];
Dist_Key_Clothes 		= [0.066847629, 0.073917207, 0.077900571, 0.087042461, 0.093510198, 0.100374035, 0.102941799, 0.116803251, 0.128168497, 0.152494353];
Dist_Key_Services 	= [0.055500156, 0.060961752, 0.067590362, 0.079162623, 0.084677738, 0.094898549, 0.107180513, 0.123704834, 0.137370179, 0.188953294];

//	Initial Consumptions
ini.Composite_budget =  ini.Consumption_budget - sum(ini.pC(1:Index_Composite-1, :) .* ini.C(1:Index_Composite-1, :),"r");

ini.C_Equipment 	= sum (ini.C (Index_Composite, :)) * Share_Equipment  * ones(1,nb_Households)  .*  Dist_Key_Equipment ;
ini.C_Housing 	= sum (ini.C (Index_Composite, :)) * Share_Housing  * ones(1,nb_Households)  .*  Dist_Key_Housing ;
ini.C_Clothes 	= sum (ini.C (Index_Composite, :)) * Share_Clothes  * ones(1,nb_Households)  .*  Dist_Key_Clothes ;
ini.C_Services 	= ( ini.Composite_budget - ini.pC(Index_Composite,:) .* (ini.C_Equipment + ini.C_Housing + ini.C_Clothes) ) ./ ini.pC(Index_Composite,:)  ;

ini.C_ECOPA 			= ini.C(1:Index_Composite-1, :);
ini.C_ECOPA($+1, :) 	= ini.C_Equipment;
ini.C_ECOPA($+1, :) 	= ini.C_Housing;
ini.C_ECOPA($+1, :) 	= ini.C_Clothes;
ini.C_ECOPA($+1, :) 	= ini.C_Services;

//	Final Consumptions
sigma_ConsoBudget_ECOPA = [ 1.084402893, 1.084402893, 1.084402893, 0.758328504, 1.084402893, 0.758328504, 1.084402893, 1.084402893, 1.12943496, 1.12943496, 1.12943496, 1.12943496, 1.12943496, 1.12943496, 1.12943496, 1.12943496, 1.12943496, 0.689792179, 0.88936357, 0.88936357, 1.12943496, 1.294048831, 0.88936357, 1.002712465 ]';
	
sigma_pC_ECOPA = [ -0.335325014, -0.335325014, -0.335325014, -0.107069748, -0.335325014, -0.107069748, -0.335325014, -0.335325014, -2.035693589, -2.035693589, -2.035693589, -2.035693589, -2.035693589, -2.035693589, -2.035693589, -2.035693589, -2.035693589, -0.527671536, -0.351294309, -0.351294309, -2.035693589, -0.448632393, -0.351294309, -0.421581356 ]';

d.C_Equipment = ini.C_Equipment .* ( (pC(Index_Composite,:)/CPI) ./ (pC_ref(Index_Composite,:)/CPI_ref) ).^ ( sigma_pC_ECOPA(Index_Composite).*. ones(1,nb_Households)) .* (( (Consumption_budget/CPI) ./ (Consumption_budget_ref/CPI_ref) ) .^ (sigma_ConsoBudget_ECOPA(Index_Composite) .*. ones(1,nb_Households)) ) ;
d.C_Housing   = ini.C_Housing .* ( (pC(Index_Composite,:)/CPI) ./ (pC_ref(Index_Composite,:)/CPI_ref) ).^ ( sigma_pC_ECOPA(Index_Composite+1).*. ones(1,nb_Households)) .* (( (Consumption_budget/CPI) ./ (Consumption_budget_ref/CPI_ref) ) .^ (sigma_ConsoBudget_ECOPA(Index_Composite+1).*. ones(1,nb_Households)) );
d.C_Clothes   = ini.C_Clothes .* ( (pC(Index_Composite,:)/CPI) ./ (pC_ref(Index_Composite,:)/CPI_ref) ).^ ( sigma_pC_ECOPA(Index_Composite+2).*. ones(1,nb_Households)) .* (( (Consumption_budget/CPI) ./ (Consumption_budget_ref/CPI_ref) ) .^ (sigma_ConsoBudget_ECOPA(Index_Composite+2).*. ones(1,nb_Households)) );

Composite_budget =  Consumption_budget - sum(pC(1:Index_Composite-1, :) .* C(1:Index_Composite-1, :),"r");
	
d.C_Services  =	( Composite_budget - pC(Index_Composite,:) .* (d.C_Equipment + d.C_Housing + d.C_Clothes) ) ./ pC(Index_Composite,:)  ;

d.C_ECOPA 				= d.C(1:Index_Composite-1, :);
d.C_ECOPA($+1, :) 	= d.C_Equipment;
d.C_ECOPA($+1, :) 	= d.C_Housing;
d.C_ECOPA($+1, :) 	= d.C_Clothes;
d.C_ECOPA($+1, :) 	= d.C_Services;

//	Consumption Prices
ini.pC_ECOPA			= ini.pC(1:Index_Composite-1, :);
ini.pC_ECOPA($+1, :) = ini.pC(Index_Composite,:);
ini.pC_ECOPA($+1, :) = ini.pC(Index_Composite,:);
ini.pC_ECOPA($+1, :) = ini.pC(Index_Composite,:);
ini.pC_ECOPA($+1, :) = ini.pC(Index_Composite,:);

d.pC_ECOPA			 = d.pC(1:Index_Composite-1, :);
d.pC_ECOPA($+1, :) = d.pC(Index_Composite,:);
d.pC_ECOPA($+1, :) = d.pC(Index_Composite,:);
d.pC_ECOPA($+1, :) = d.pC(Index_Composite,:);
d.pC_ECOPA($+1, :) = d.pC(Index_Composite,:);


//	Aggregate variables
ECOPA_Table_1 = [["Variable", "Value_ref_2010", "Scenario", "Unit"]; 
["Total Population", sum(ini.Population), sum(d.Population), "Thousands people"];
["Total Number of households", sum(ini.Nb_Households), sum(d.Nb_Households), "Thousands"];
["Total Number of Persons per households", sum(ini.Population)/ sum(ini.Nb_Households), sum(d.Population)/ sum(d.Nb_Households), "Number"];
["Total Active Population", sum(ini.Labour_force_ref), sum(d.Labour_force_ref), "Thousands people"];
["Total Employed Labour Force", sum(ini.Labour),  sum(d.Labour), "Thousands Full Time Equivalent"];
["Total Number of unemployed", sum(ini.Unemployed), sum(d.Unemployed), "Thousands people"];
["Total Number of retired", sum(ini.Retired), sum(d.Retired), "Thousands people"];
["Share of Net Labour Income In GDP", sum(ini.Labour_income)*100/ini.GDP,  sum(d.Labour_income)*100/d.GDP, "Percentage"];
["Share of Non Labour Income In GDP", sum(ini.GrossOpSurplus)*100/ini.GDP, sum(d.GrossOpSurplus)*100/d.GDP, "Percentage"];
["Share of Taxes In GDP", (sum(ini.Production_Tax + ini.Labour_Tax + ini.OtherIndirTax + ini.VA_Tax) + sum(ini.Energy_Tax_IC) + sum(ini.Carbon_Tax_IC) + sum(ini.Energy_Tax_FC) + sum(ini.Carbon_Tax_C))*100/ini.GDP, (sum(d.Production_Tax + d.Labour_Tax + d.OtherIndirTax + d.VA_Tax) + sum(d.Energy_Tax_IC) + sum(d.Carbon_Tax_IC) + sum(d.Energy_Tax_FC) + sum(d.Carbon_Tax_C))*100/d.GDP, "Percentage"];
["Corporate tax rates", ini.Corporate_Tax_rate, d.Corporate_Tax_rate, "Percentage of Total Gross operating surplus"];
["Carbon Tax rate", ini.Carbon_Tax_rate, d.Carbon_Tax_rate, "€ per ton of CO2 (all sources)"];
["Net Financial Property (Assets) - Corporations", -ini.NetFinancialDebt(Indice_Corporations), -d.NetFinancialDebt(Indice_Corporations), "Thousands euros"];
["Net Financial Property (Assets) - Government", -ini.NetFinancialDebt(Indice_Government), -d.NetFinancialDebt(Indice_Government), "Thousands euros"];
["Real interest rate on financial assets - Corporations", ini.interest_rate(Indice_Corporations), d.interest_rate(Indice_Corporations), "Percentage"];
["Real interest rate on financial assets) - Government", ini.interest_rate(Indice_Government), d.interest_rate(Indice_Government), "Percentage"];
["Gini Coefficient - Disposable Income", Gini( ini.Population, ini.H_disposable_income), Gini( d.Population, d.H_disposable_income), "no unit"];
["Gini Coefficient - Consumption Budget", Gini( ini.Population, ini.Consumption_budget), Gini( d.Population, d.Consumption_budget), "no unit"];
["Share of public expenditures in the consumption of Composite good", ini.G_value(Index_Composite,:)*100 ./ ( ini.G_value(Index_Composite,:) + sum(ini.C_value(Index_Composite,:)) ), d.G_value(Index_Composite,:)*100 ./ ( d.G_value(Index_Composite,:) + sum(d.C_value(Index_Composite,:)) ), "percentage"];
["Total Exports / Production Ratio - Energy", sum(ini.X(Indice_EnerSect))*100 ./ sum(ini.Y(Indice_EnerSect)), sum(d.X(Indice_EnerSect))*100 ./ sum(d.Y(Indice_EnerSect)), "Percentage "];
["Total Imports / Production Ratio - Energy", sum(ini.M(Indice_EnerSect))*100 ./ sum(ini.Y(Indice_EnerSect)), sum(d.M(Indice_EnerSect))*100 ./ sum(d.Y(Indice_EnerSect)), "Percentage "];
["Total Exports / Production Ratio - non Energy", sum(ini.X(Indice_NonEnerSect))*100 ./ sum(ini.Y(Indice_NonEnerSect)), sum(d.X(Indice_NonEnerSect))*100 ./ sum(d.Y(Indice_NonEnerSect)), "Percentage "];
["Total Imports / Production Ratio - non Energy", sum(ini.M(Indice_NonEnerSect))*100 ./ sum(ini.Y(Indice_NonEnerSect)), sum(d.M(Indice_NonEnerSect))*100 ./ sum(d.Y(Indice_NonEnerSect)), "Percentage "];
["Total Emissions", ini.DOM_CO2, d.DOM_CO2, "Mega Ton CO2"];
["Emissions from intermediate Consumptions", sum(ini.CO2Emis_IC), sum(d.CO2Emis_IC), "Mega Ton CO2"];
["Emissions from Private Consumption", sum(ini.CO2Emis_C), sum(d.CO2Emis_C), "Mega Ton CO2"];
];
 
//	Variables per Household groups 
ECOPA_Table_2 = [["Variable", "Value_ref_2010", "D1", "D2", "D3", "D4", "D5", "D6", "D7", "D8", "D9", "D10", "Scenario", "D1", "D2", "D3", "D4", "D5", "D6", "D7", "D8", "D9", "D10", "Unit"];
["Number of Consumption Units", "", ini.Consumption_Units, "", d.Consumption_Units, "UC per household"];
["Income tax Rate", "", ini.Income_Tax_rate*100, "", d.Income_Tax_rate*100, "Percentage"];
["Pension Benefits", "", ini.Pension_Benefits, "", d.Pension_Benefits, "euros per retired"];
["Unemployment benefits", "", ini.UnemployBenefits, "", d.UnemployBenefits, "euros per unemployed"];
["Net Financial Property (Assets)", "", -ini.NetFinancialDebt(Indice_Households), "", -d.NetFinancialDebt(Indice_Households), "Thousands euros"];
["Real interest rate on financial assets", "", interest_rate(Indice_Households), "", interest_rate(Indice_Households), "Percentage"];
["Share of disposable income allocated to current consumption", "", ini.Consumption_budget*100 ./ini.H_disposable_income, "", d.Consumption_budget*100 ./d.H_disposable_income, "Percentage" ];
["Share of disposable income allocated to Gross fixed Capital Formation", "", ini.GFCF_byAgent(Indice_Households)*100 ./ini.H_disposable_income, "", d.GFCF_byAgent(Indice_Households)*100 ./d.H_disposable_income, "Percentage" ];
["Consumption budget", "", ini.Consumption_budget, "", d.Consumption_budget, "Thousands euros" ];
["GFCF budget", "", ini.GFCF_byAgent(Indice_Households), "", d.GFCF_byAgent(Indice_Households), "Thousands euros" ];
["Direct final CO2 Emissions","", sum(ini.CO2Emis_C(Indice_EnerSect,:),"r"), "", sum(d.CO2Emis_C(Indice_EnerSect,:),"r"), "Mega Ton CO2"];
 ];

 //	Variable per Sectors
 ECOPA_Table_3 = [["Variable", "Value_ref_2010:", Index_Sectors' , "Scenario", Index_Sectors' , "Unit"];
 ["Production tax rates", "", ini.Production_Tax_rate, "", d.Production_Tax_rate, "Percentage of sales revenue"];
 ["Labour tax rates", "", ini.Labour_Tax_rate, "", d.Labour_Tax_rate, "Percentage of net labour compensations"];
 ["Energy tax rates on intermediate consumptions", "", ini.Energy_Tax_rate_IC, "", d.Energy_Tax_rate_IC, "Energy Tax per ton oil equivalent"];
 ["Energy tax rates on final consumptions", "", ini.Energy_Tax_rate_FC, "", d.Energy_Tax_rate_FC, "Energy Tax per ton oil equivalent"];
 ["Other indirect taxes", "", ini.OtherIndirTax_rate, "", d.OtherIndirTax_rate, "€ of Energy Tax per ton oil equivalent"];
 ["Other indirect taxes", "", ini.OtherIndirTax_rate, "", d.OtherIndirTax_rate, "€ of Sales Tax on € of real consumptions"];
 ["Value added Tax", "", ini.VA_Tax_rate, "", d.VA_Tax_rate, "Percentage on the value of final consumptions"];
 ];
 
 //	Variables per household group and per sectors
 ECOPA_Table_4 = [["Real Consumptions (Constant €2010, toe for energy goods) - Value_ref_2010",Index_Households'];[Index_Sectors_ECOPA,ini.C_ECOPA]];
 
 ECOPA_Table_5 = [["Real Consumptions (Constant €2010, toe for energy goods) - Scenario",Index_Households'];[Index_Sectors_ECOPA, d.C_ECOPA]];
 
 ECOPA_Table_6 = [["Consumptions Prices (€ per toe for energy goods, per €2010 else) - Value_ref_2010",Index_Households'];[Index_Sectors_ECOPA,ini.pC_ECOPA]];
 
 ECOPA_Table_7 = [["Consumptions Prices (€ per toe for energy goods, per €2010 else) -  - Scenario",Index_Households'];[Index_Sectors_ECOPA, d.pC_ECOPA]];
 
 ECOPA_Table_8 = [["Budget Shares (percentage) - Value_ref_2010",Index_Households'];[Index_Sectors_ECOPA, 100*(ini.pC_ECOPA .* ini.C_ECOPA) ./ ( ini.Consumption_budget .*. ones(nb_Sectors_ECOPA,1) ) ]];
 
 ECOPA_Table_9 = [["Budget Shares (percentage) - Scenario",Index_Households'];[Index_Sectors_ECOPA, 100*(d.pC_ECOPA .* d.C_ECOPA) ./ ( d.Consumption_budget .*. ones(nb_Sectors_ECOPA,1) ) ]];

 ECOPA_Table_10 = [["Income elasticities",Index_Households'];[Index_Sectors_ECOPA,sigma_ConsoBudget_ECOPA .*. ones(1,nb_Households)]];
 
 ECOPA_Table_11 = [["Price elasticities",Index_Households'];[Index_Sectors_ECOPA, sigma_pC_ECOPA .*. ones(1,nb_Households)]];
 
 ECOPA_Table_12 = [["Direct final CO2 Emissions (Mega Ton CO2) - Value_ref_2010",Index_Households'];[Index_EnerSect, ini.CO2Emis_C(Indice_EnerSect,:)]];
  
 ECOPA_Table_13 = [["Direct intermediate CO2 Emissions (Mega Ton CO2) - Value_ref_2010",Index_Sectors'];[Index_EnerSect, ini.CO2Emis_IC(Indice_EnerSect,:)]];
 
 ECOPA_Table_14 = [["Direct final CO2 Emissions (Mega Ton CO2) - Scenario",Index_Households'];[Index_EnerSect, d.CO2Emis_C(Indice_EnerSect,:)]];
 
 ECOPA_Table_15 = [["Direct intermediate CO2 Emissions (Mega Ton CO2) - Scenario",Index_Sectors'];[Index_EnerSect, d.CO2Emis_IC(Indice_EnerSect,:)]];
 
 
//	Export tables to csv. in SAVEDIR
 csvWrite(ECOPA_Table_1,SAVEDIR+"ECOPA_Indicators_1.csv", ';');
 csvWrite(ECOPA_Table_2,SAVEDIR+"ECOPA_Indicators_2.csv", ';');
 csvWrite(ECOPA_Table_3,SAVEDIR+"ECOPA_Indicators_3.csv", ';');
 csvWrite(ECOPA_Table_4,SAVEDIR+"ECOPA_Indicators_4.csv", ';');
 csvWrite(ECOPA_Table_5,SAVEDIR+"ECOPA_Indicators_5.csv", ';');
 csvWrite(ECOPA_Table_6,SAVEDIR+"ECOPA_Indicators_6.csv", ';');
 csvWrite(ECOPA_Table_7,SAVEDIR+"ECOPA_Indicators_7.csv", ';');
 csvWrite(ECOPA_Table_8,SAVEDIR+"ECOPA_Indicators_8.csv", ';');
 csvWrite(ECOPA_Table_9,SAVEDIR+"ECOPA_Indicators_9.csv", ';');
 csvWrite(ECOPA_Table_10,SAVEDIR+"ECOPA_Indicators_10.csv", ';');
 csvWrite(ECOPA_Table_11,SAVEDIR+"ECOPA_Indicators_11.csv", ';');
 csvWrite(ECOPA_Table_12,SAVEDIR+"ECOPA_Indicators_12.csv", ';');
 csvWrite(ECOPA_Table_13,SAVEDIR+"ECOPA_Indicators_13.csv", ';');
 csvWrite(ECOPA_Table_14,SAVEDIR+"ECOPA_Indicators_14.csv", ';');
 csvWrite(ECOPA_Table_15,SAVEDIR+"ECOPA_Indicators_15.csv", ';');
 
 