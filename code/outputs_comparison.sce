// Scenarios options
//Loop_elements.Recycling_option = ["PublicDeficit" "GreenInvest" "LumpSumHH" "LabTax" "ExactRestitution" "LabTax_PublicDeficit" "LabTax_GreenInvest" "LabTax_LumpSumHH"];
//Loop_elements.Carbon_Tax_rate = [50 100 250]*1E3; // Taxe Carbone
//Loop_elements.sigma_omegaU = [0.0 -0.1]; // Wage Curve : elasticity
//Loop_elements.Coef_real_wage = [0.0 1.0]; // wage Curve : wage indexation
//Loop_elements.sigma_Trade_coef = [2.0 1.0 0.5 0.0]; // Élasticité du commerce 

// Loop_elements.Carbon_Tax_rate = [50 100 250]*1E3; // Taxe Carbone
// Loop_elements.sigma_omegaU = [0.0 -0.1]; // Wage Curve : elasticity
// Loop_elements.Coef_real_wage = [0.0 1.0]; // wage Curve : wage indexation
// Loop_elements.sigma_Trade_coef = [2.0 1.0 0.5 0.0]; // Élasticité du commerce 

Loop_elements.Recycling_option = ["LabTaxHH1"];
Loop_elements.Carbon_Tax_rate = 100*1E3;//[50 100 250]*1E3; // Taxe Carbone
Loop_elements.sigma_omegaU = 0.0;//[0.0 -0.1]; // Wage Curve : elasticity
Loop_elements.Coef_real_wage = 0.0;//[0.0 1.0]; // wage Curve : wage indexation
Loop_elements.sigma_Trade_coef = 1.0;//[2.0 1.0 0.5 0.0]; // Élasticité du commerce 
Loop_elements.sobriety = [1.0 0.0];

// MODEL FILE STRUCTURE
sep = filesep(); // "/" or "\" depending on OS

cd("..");
PARENT    = pwd()  + sep;
CODE      = PARENT + "code" + sep;

LIB       = PARENT + "library" + sep;
getd(LIB); // Charge toutes les fonctions dans LIB

OUTPUT    = PARENT + "outputs" + sep ;
mkdir(OUTPUT);

DATA      = PARENT + "data" + sep; 
STUDY     = PARENT + "study_frames" + sep;
PARAMS    = PARENT + "params" + sep;
ROBOT     = PARENT + "robot" + sep;

SAVEDIR = OUTPUT ;
mkdir(SAVEDIR);

cd(CODE);

// OUTPUT FILES TO IMPORT
CSV_list = ["param_table_sec" "ioQ-run" "io-run" "TechCOef-run" "Prices-run" "ecoT-run" "Prices_Index_Labour"];
Nb_Iter = 1;

Scenarios(1,1:2) = [Loop_elements.Recycling_option(1)+sep+"1" Loop_elements.Recycling_option(1)+sep+"2"];

for Ropt_eld=1:size(Loop_elements.Recycling_option,2)
	for CTax_elt=1:size(Loop_elements.Carbon_Tax_rate,2)
		for sigW_elt=1:size(Loop_elements.sigma_omegaU,2)
			for CoefW_elt=1:size(Loop_elements.Coef_real_wage,2)
				for SigTrade_elt=1:size(Loop_elements.sigma_Trade_coef,2)
					for Sob_elt=1:size(Loop_elements.sobriety,2)

						Scenarios(1,$+1) = string(Loop_elements.Recycling_option(Ropt_eld)) + sep + ..
								"Ctax"+string(Loop_elements.Carbon_Tax_rate(CTax_elt)*1E-3) + "_" + .. 
								"sigW"+string(Loop_elements.sigma_omegaU(sigW_elt)) + "_" + .. 
								"CoefW"+string(Loop_elements.Coef_real_wage(CoefW_elt)) + "_" + .. 
								"SigTrade"+string(Loop_elements.sigma_Trade_coef(SigTrade_elt)) + "_" + .. 
								"sobriety"+string(Loop_elements.sobriety(Sob_elt));
					end
				end
			end
		end
	end
end

// définition de l'en tête
top = 	["type", "Variables", "unit", "Agents/Sectors", Scenarios];

//////////////////////////
// définition des légendes
//////////////////////////

// verification 
type_verif = ["rate", "Volume", "Value", "Value", "Value", "Value", "Value"];
var_verif = ["Labour Tax Cut", "Emissions", "Carbon Tax", "Energy Tax", "Clim Tax", "Clim Transfers HH", "Clim Transfers ENT"];
unit_verif = ["ratio", "GtCO2", "G€", "G€","G€", "G€", "G€"];
AgSec_verif = ["-", "-","-", "-", "-", "-", "-"];  

// Price Index
type_index = ["Fisher price index"];
var_index = ["GDP" "C" "G" "I" "X" "Y" "M"];
unit_index = ["ratio BY"];
AgSec_index = ["-"];
for elt=1:size(var_index,2)-1
	type_index(1,elt+1) = type_index(1,1);
	unit_index(1,elt+1) = unit_index(1,1);
	AgSec_index(1,elt+1) = AgSec_index(1,1);
end

// nominal macro values
type_nom_tot = ["nominal"];
var_nom_tot = ["GDP", "Consumption", "G_Conso", "Investment", "X", "M", "Trade_Balance", "Net-of-tax wages", "Net-of-tax effective wages"];
unit_nom_tot = ["G€"];
AgSec_nom_tot = ["-"];
for elt=1:size(var_nom_tot,2)-1
	type_nom_tot(1,elt+1) = type_nom_tot(1,1);
	unit_nom_tot(1,elt+1) = unit_nom_tot(1,1);
	AgSec_nom_tot(1,elt+1) = AgSec_nom_tot(1,1);
end

// real macro values
type_real_tot = ["real"];
var_real_tot = ["GDP", "Consumption", "G_Conso", "Investment", "X", "M", "Trade_Balance", "Net-of-tax wages", "Net-of-tax effective wages"];
unit_real_tot = ["G€"];
AgSec_real_tot = ["-"];
for elt=1:size(var_real_tot,2)-1
	type_real_tot(1,elt+1) = type_real_tot(1,1);
	unit_real_tot(1,elt+1) = unit_real_tot(1,1);
	AgSec_real_tot(1,elt+1) = AgSec_real_tot(1,1);
end

// index - decomp production price
type_mean = ["-"];
var_mean = ["mean labour price", "mean capital price", "mean energy price", "mean non-energy price", "mean labour intensity", "mean capital intensity", "mean energy intensity"];
unit_mean = ["ratio/BY"];
AgSec_mean = type_mean;
indice = size(type_mean,2);

for elt=1:size(var_mean,2)-indice
	type_mean(1,elt+indice) = type_mean(1,indice);
	unit_mean(1,elt+indice) = unit_mean(1,indice);
	AgSec_mean(1,elt+indice) = AgSec_mean(1,indice);
end
clear indice

// volume
type_volume = ["-", "-", "-", "-", "-"];
var_volume = ["HH_saving_rate" "Unemployement rate", "M/Y", "Y", "X"];
unit_volume = ["%", "%", "ratio/BY","ratio/BY", "ratio/BY"];
AgSec_volume = type_volume;

// funding
type_fund = ["real", "real", "real", "real", "nominal","nominal","nominal","nominal","nominal","nominal","nominal","nominal", "nominal","nominal", "nominal","nominal","nominal","nominal","nominal"];
var_fund = ["GFCF","GFCF","GFCF",, "GFCF", "GFCF","GFCF","GFCF","Disposable income", "Disposable income", "Disposable income", "Disposable income", "Net Lending","Net Lending","Net Lending","Net Lending","Net Debt","Net Debt","Net Debt","Net Debt"];
unit_fund = ["G€","G€","G€","G€", "G€","G€","G€","G€","G€","G€","G€","G€","G€","G€","G€","G€","G€","G€","G€"];
AgSec_fund = ["1.  Corporations", "2.  Government", "3.  Households", "4.  Domestic", "1.  Corporations", "2.  Government", "3.  Households", "1.  Corporations", "2.  Government", "3.  Households","4.  Rest of the World", "1.  Corporations", "2.  Government", "3.  Households","4.  Rest of the World", "1.  Corporations", "2.  Government", "3.  Households","4.  Rest of the World",];

// changement structurel 
type_struc_temp = ["nominal" "-" "-" "-" "-" "-" "-" "-" "nominal"];
var_struc_temp = ["GDP sect" "Y" "M" "M/Y" "X" "Jobs" "pM/pY" "C" "C"];
unit_struc_temp = ["G€" "volume" "ratio" "volume" "volume" "thousands" "ratio" "volume" "G€"];
AgSec_fund_temp = ["1.  Crude_oil" "2.  Natural_gas" "3.  Coal" "4.  AllFuels" "5.  Electricity" "6.  HeatGeoSol_Th" "7.  Heavy_Industry" "8.  Buildings_constr" "9.  Work_constr" "10. Automobile" "11. Load_PipeTransp" "12. PassTransp" "13. Agri_Food_industry" "14. Property_business" "15. OthSectors"];

type_struc = [];
var_struc = [];
unit_struc = [];
AgSec_struc = [];

for var=1:size(var_struc_temp,2)
	type_struc(1,(var-1)*size(AgSec_fund_temp,2)+1:var*size(AgSec_fund_temp,2))=type_struc_temp(var);
	var_struc(1,(var-1)*size(AgSec_fund_temp,2)+1:var*size(AgSec_fund_temp,2))=var_struc_temp(var);
	unit_struc(1,(var-1)*size(AgSec_fund_temp,2)+1:var*size(AgSec_fund_temp,2))=unit_struc_temp(var);
	AgSec_struc((var-1)*size(AgSec_fund_temp,2)+1:var*size(AgSec_fund_temp,2))=AgSec_fund_temp;
end

// legend
tabular = [];
tabular(:,1) = [top(1), type_verif, type_index, type_nom_tot, type_real_tot, type_mean, type_volume, type_fund, type_struc]';
tabular(:,2) = [top(2), var_verif, var_index, var_nom_tot, var_real_tot, var_mean, var_volume, var_fund, var_struc]';
tabular(:,3) = [top(3), unit_verif, unit_index, unit_nom_tot, unit_real_tot, unit_mean, var_volume, unit_fund, unit_struc]';
tabular(:,4) = [top(4), AgSec_verif, AgSec_index, AgSec_nom_tot, AgSec_real_tot, AgSec_mean, AgSec_volume, AgSec_fund, AgSec_struc]';

// Comparaison macro des scénarios
for time_step = 1:Nb_Iter
// pour le changement structurel, ajouter les info d'avant par secteur (travailleur, production, commerce, coût de production, emploie) 

	for elt = 1:size(Scenarios,2)
		load(OUTPUT + Scenarios(elt) + sep + "output.sav")
// verif --> warning HH
//verif = [data.Labour_Tax_Cut, (sum(data.CO2Emis_C) + sum(data.CO2Emis_IC)), round(sum(data.Carbon_Tax)/10^5)/10, round(sum(data.Energy_Tax_IC + data.Energy_Tax_FC)/10^5)/10, round((sum(data.Carbon_Tax + data.Energy_Tax_IC + data.Energy_Tax_FC))/10^5)/10, round(sum(data.ClimPolicyCompens(3:12))/10^5)/10, round((sum(data.ClimPolCompensbySect))/10^5)/10];
verif = [data.Labour_Tax_Cut, (sum(data.CO2Emis_C) + sum(data.CO2Emis_IC)), round(sum(data.Carbon_Tax)/10^5)/10, round(sum(data.Energy_Tax_IC + data.Energy_Tax_FC)/10^5)/10, round((sum(data.Carbon_Tax + data.Energy_Tax_IC + data.Energy_Tax_FC))/10^5)/10, round(sum(data.ClimPolicyCompens(3))/10^5)/10, round((sum(data.ClimPolCompensbySect))/10^5)/10]; 

// Indexes
		data.X_pFish = PInd_Fish( BY.pX, BY.X, data.pX, data.X, :, :);
		data.Y_pFish = PInd_Fish( BY.pY, BY.Y, data.pY, data.Y, :, :);
		data.M_pFish = PInd_Fish( BY.pM, BY.M, data.pM, data.M, :, :);
		indexes = [data.GDP_pFish data.CPI data.G_pFish data.I_pFish data.X_pFish data.Y_pFish data.M_pFish];
	
// nominal macro values
		nom_1 = [data.GDP, sum(data.C_value), sum(data.G_value), sum(data.I_value), sum(data.X_value), sum(data.M_value)];
		nom_2 = sum(data.X_value) - sum(data.M_value);
		nom_3 = [data.omega, data.omega/((1+data.Mu)^data.time_since_BY)];
		nom_tot = [round(nom_1/10^5)/10, round(nom_2/10^5)/10, round(nom_3/10^0)/10^6];

// real macro values
		Trade_pLasp = (sum(data.pX.*BY.X)-sum(data.pM.*BY.M))/(sum(BY.pX.*BY.X)-sum(BY.pM.*BY.M)) ;
		Trade_pPaas = (sum(data.pX.*data.X)-sum(data.pM.*data.M))/(sum(BY.pX.*data.X)-sum(BY.pM.*data.M)) ;
		Trade_pFish = sqrt(abs(Trade_pLasp*Trade_pPaas));
		//price_index_1 = [data.GDP_pFish, data.C_pFish, data.G_pFish, data.I_pFish, Trade_pFish];
		price_index_1 = [data.GDP_pFish, data.CPI, data.G_pFish, data.I_pFish, data.X_pFish, data.M_pFish, Trade_pFish];
		price_index_3 = [data.CPI, data.CPI];
		real_1 = [nom_1 nom_2]./price_index_1;
		real_3 = nom_3./price_index_3;
		real_tot = [round(real_1/10^5)/10, round(real_3/10^0)/10^6];
		clear nom_1 nom_2 nom_3 price_index_1 price_index_3 real_1 real_2 real_3

// index - decomp production price
		// Labour price index
		L_pFish = PInd_Fish( BY.pL', BY.Y, data.pL', data.Y, :, :);
		// Capital price index 
		K_pFish = PInd_Fish( BY.pK', BY.Y, data.pK', data.Y, :, :);
		// Energy price index
		IC_Ener_pFish = PInd_Fish( BY.pIC, BY.IC, data.pIC, data.IC, data.Indice_EnerSect, :);
		// Non energy price index
		IC_NonEn_pFish = PInd_Fish( BY.pIC, BY.IC, data.pIC, data.IC, data.Indice_NonEnerSect, :);
		// labour intensity of prodruction 
		lambda_pFish = PInd_Fish( BY.lambda', BY.Y, data.lambda', data.Y, :, :);
		// capital intensity of prodruction 
		kappa_pFish = PInd_Fish( BY.kappa', BY.Y, data.kappa', data.Y, :, :);
		// energy intensity of prodruction 
		BY.alpha_Ener = sum(BY.alpha(data.Indice_EnerSect,:),"r");
		data.alpha_Ener = sum(data.alpha(data.Indice_EnerSect,:),"r");
		alpha_Ener_pFish = PInd_Fish(BY.alpha_Ener', BY.Y, data.alpha_Ener', data.Y, :, :);
		// final 
		Mean_Eco = [L_pFish, K_pFish, IC_Ener_pFish, IC_NonEn_pFish, lambda_pFish, kappa_pFish, alpha_Ener_pFish];
		clear L_pFish K_pFish IC_Ener_pFish IC_NonEn_pFish lambda_pFish kappa_pFish alpha_Ener_pFish

// volume
		// M/Y ratio quantity index
		if abs(data.Y(1))<1E-5
			M_Y_Ratio_qFish = QInd_Fish( BY.pM./BY.pY, BY.M./BY.Y, data.pM./data.pY, data.M./data.Y, [2:15], :);
		else
			M_Y_Ratio_qFish = QInd_Fish( BY.pM./BY.pY, BY.M./BY.Y, data.pM./data.pY, data.M./data.Y, :, :);
		end
		
		if imag(M_Y_Ratio_qFish) <> 0
			M_Y_Ratio_qFish
			pause
		end

		// Y quantity index
//		if abs(data.Y(1))<1E-10
//		Y_qFish = QInd_Fish( BY.pY, BY.Y, data.pY, data.Y, [2:16], :);
//		else
		Y_qFish = QInd_Fish( BY.pY, BY.Y, data.pY, data.Y, :, :);
//		end
		// Export quantity index
		X_qFish = QInd_Fish( BY.pX, BY.X, data.pX, data.X, :, :);
		volume = [round((sum(data.Household_savings)/sum(data.H_disposable_income))*10^4)/10^2, round(data.u_tot*10^4)/10^2, M_Y_Ratio_qFish, Y_qFish, X_qFish];
		clear M_Y_Ratio_qFish Y_qFish X_qFish

// funding --> warning HH
		Funding = [round(data.GFCF_byAgent/(data.I_pFish*10^5))/10, round(sum(data.GFCF_byAgent)/(data.I_pFish*10^5))/10, round(data.GFCF_byAgent/10^5)/10, round(data.Disposable_Income/10^5)/10, round(data.NetLending/10^5)/10, round(data.NetFinancialDebt/10^5)/10];
		// Funding = 	[round([data.GFCF_byAgent(1:2) sum(data.GFCF_byAgent(3:12)) sum(data.GFCF_byAgent)]/(data.I_pFish*10^5))/10,..
		// 			 round([data.GFCF_byAgent(1:2) sum(data.GFCF_byAgent(3:12))]/10^5)/10,..
		// 			 round([data.Disposable_Income(1:2) sum(data.Disposable_Income(3:12)) data.Disposable_Income(13)]/10^5)/10,..
		// 			 round([data.NetLending(1:2) sum(data.NetLending(3:12)) data.NetLending(13)]/10^5)/10,..
 		//			 round([data.NetFinancialDebt(1:2) sum(data.NetFinancialDebt(3:12)) data.NetFinancialDebt(13)]/10^5)/10];

// changement structurel structure de coût / Travail / Production / Commerce
		GDP_sect = data.Labour_income + data.Labour_Tax +  data.Production_Tax - data.ClimPolCompensbySect + data.GrossOpSurplus + data.OtherIndirTax + data.VA_Tax + data.Energy_Tax_IC + data.Energy_Tax_FC + data.Carbon_Tax;
		Structural_Change = [round(GDP_sect/10^3)/10^3 data.Y' data.M' divide(data.M, data.Y, %nan)' data.X' data.Labour divide(data.pM, data.pY, %nan)' sum(data.C,"c")' round(sum(data.C_value,"c")'/10^5)/10];
		clear GDP_sect 
// final 
		tabular(:,4+elt) = [top(4+elt), verif, indexes, nom_tot, real_tot, Mean_Eco, volume, Funding, Structural_Change]';
		clear verif indexes nom_tot real_tot Mean_Eco volume Funding Structural_Change
		clear data
	end
//////////////////////////////////////////////////////////////////////////////////////////////
// Ajouter de l'année de base (2010)
elt = elt + 1;
data = BY;
top_BY = "REF";
// verif --> warning HH
verif = [data.Labour_Tax_Cut, (sum(data.CO2Emis_C) + sum(data.CO2Emis_IC)), round(sum(data.Carbon_Tax)/10^5)/10, round(sum(data.Energy_Tax_IC + data.Energy_Tax_FC)/10^5)/10, round((sum(data.Carbon_Tax + data.Energy_Tax_IC + data.Energy_Tax_FC))/10^5)/10, round(sum(data.ClimPolicyCompens(3))/10^5)/10, round((sum(data.ClimPolCompensbySect))/10^5)/10]; 
//verif = [data.Labour_Tax_Cut, (sum(data.CO2Emis_C) + sum(data.CO2Emis_IC)), round(sum(data.Carbon_Tax)/10^5)/10, round(sum(data.Energy_Tax_IC + data.Energy_Tax_FC)/10^5)/10, round((sum(data.Carbon_Tax + data.Energy_Tax_IC + data.Energy_Tax_FC))/10^5)/10, round(sum(data.ClimPolicyCompens(3:12))/10^5)/10, round((sum(data.ClimPolCompensbySect))/10^5)/10];

// indexes 
	indexes = ones(1,size(var_index,2));

// nominal macro values
		nom_1 = [data.GDP, sum(data.C_value), sum(data.G_value), sum(data.I_value), sum(data.X_value), sum(data.M_value)];
		nom_2 = sum(data.X_value) - sum(data.M_value);
		nom_3 = [data.omega, data.omega/((1+data.Mu)^data.time_since_BY)];
		nom_tot = [round(nom_1/10^5)/10, round(nom_2/10^5)/10, round(nom_3/10^0)/10^6];

// real macro values
		Trade_pLasp = (sum(data.pX.*BY.X)-sum(data.pM.*BY.M))/(sum(BY.pX.*BY.X)-sum(BY.pM.*BY.M)) ;
		Trade_pPaas = (sum(data.pX.*data.X)-sum(data.pM.*data.M))/(sum(BY.pX.*data.X)-sum(BY.pM.*data.M)) ;
		Trade_pFish = sqrt(Trade_pLasp*Trade_pPaas);
		price_index_1 = [1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0];
		price_index_3 = [data.CPI, data.CPI];
		real_1 = [nom_1 nom_2]./price_index_1;
		real_3 = nom_3./price_index_3;
		real_tot = [round(real_1/10^5)/10, round(real_3/10^0)/10^6];
		clear nom_1 nom_2 nom_3 price_index_1 price_index_3 real_1 real_2 real_3

// index - decomp production price
		// final 
		Mean_Eco = [1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0];

// volume
		// M/Y ratio quantity index
		volume = [round((sum(data.Household_savings)/sum(data.H_disposable_income))*10^4)/10^2, round(data.u_tot*10^4)/10^2, 1.0, 1.0, 1.0];

// funding --> warning HH
		Funding = [round(data.GFCF_byAgent(1:3)/10^5)/10, round(sum(data.GFCF_byAgent(1:3))/10^5)/10, round(data.GFCF_byAgent(1:3)/10^5)/10, round(data.Disposable_Income/10^5)/10, round(data.NetLending/10^5)/10, round(data.NetFinancialDebt/10^5)/10];
		// Funding = 	[round([data.GFCF_byAgent(1:2) sum(data.GFCF_byAgent(3:12)) sum(data.GFCF_byAgent)]/(data.I_pFish*10^5))/10,..
		// 			 round([data.GFCF_byAgent(1:2) sum(data.GFCF_byAgent(3:12))]/10^5)/10,..
		// 			 round([data.Disposable_Income(1:2) sum(data.Disposable_Income(3:12)) data.Disposable_Income(13)]/10^5)/10,..
		// 			 round([data.NetLending(1:2) sum(data.NetLending(3:12)) data.NetLending(13)]/10^5)/10,..
 		// 			 round([data.NetFinancialDebt(1:2) sum(data.NetFinancialDebt(3:12)) data.NetFinancialDebt(13)]/10^5)/10];

// changement structurel structure de coût / Travail / Production / Commerce
		GDP_sect = data.Labour_income + data.Labour_Tax +  data.Production_Tax - data.ClimPolCompensbySect + data.GrossOpSurplus + data.OtherIndirTax + data.VA_Tax + data.Energy_Tax_IC + sum(data.Carbon_Tax_IC,"r") + data.Energy_Tax_FC + sum(data.Carbon_Tax_C,"c")' ;
Structural_Change = [round(GDP_sect/10^3)/10^3 data.Y' data.M' divide(data.M, data.Y, %nan)' data.X' data.Labour divide(data.pM, data.pY, %nan)' sum(data.C,"c")' round(sum(data.C_value,"c")'/10^5)/10];
		clear GDP_sect

		tabular(:,4+elt) = [top_BY, verif, indexes, nom_tot, real_tot, Mean_Eco, volume, Funding, Structural_Change]';
		clear verif indexes nom_tot real_tot Mean_Eco volume Funding Structural_Change
		clear data
//////////////////////////////////////////////////////////////////////////////////////////////
// Ajouter de l'année de base (2010)
elt = elt + 1;
load(OUTPUT + Scenarios(1) + sep + "output.sav")
data = BY;
top_BY = "2010";
// verif --> warning HH
//verif = [data.Labour_Tax_Cut, (sum(data.CO2Emis_C) + sum(data.CO2Emis_IC)), round(sum(data.Carbon_Tax)/10^5)/10, round(sum(data.Energy_Tax_IC + data.Energy_Tax_FC)/10^5)/10, round((sum(data.Carbon_Tax + data.Energy_Tax_IC + data.Energy_Tax_FC))/10^5)/10, round(sum(data.ClimPolicyCompens(3:12))/10^5)/10, round((sum(data.ClimPolCompensbySect))/10^5)/10];
verif = [data.Labour_Tax_Cut, (sum(data.CO2Emis_C) + sum(data.CO2Emis_IC)), round(sum(data.Carbon_Tax)/10^5)/10, round(sum(data.Energy_Tax_IC + data.Energy_Tax_FC)/10^5)/10, round((sum(data.Carbon_Tax + data.Energy_Tax_IC + data.Energy_Tax_FC))/10^5)/10, round(sum(data.ClimPolicyCompens(3))/10^5)/10, round((sum(data.ClimPolCompensbySect))/10^5)/10]; 


// indexes 
	indexes = ones(1,size(var_index,2));

// nominal macro values
		nom_1 = [data.GDP, sum(data.C_value), sum(data.G_value), sum(data.I_value), sum(data.X_value), sum(data.M_value)];
		nom_2 = sum(data.X_value) - sum(data.M_value);
		nom_3 = [data.omega, data.omega/((1+data.Mu)^data.time_since_BY)];
		nom_tot = [round(nom_1/10^5)/10, round(nom_2/10^5)/10, round(nom_3/10^0)/10^6];

// real macro values
		Trade_pLasp = (sum(data.pX.*BY.X)-sum(data.pM.*BY.M))/(sum(BY.pX.*BY.X)-sum(BY.pM.*BY.M)) ;
		Trade_pPaas = (sum(data.pX.*data.X)-sum(data.pM.*data.M))/(sum(BY.pX.*data.X)-sum(BY.pM.*data.M)) ;
		Trade_pFish = sqrt(Trade_pLasp*Trade_pPaas);
		price_index_1 = [1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0];
		price_index_3 = [data.CPI, data.CPI];
		real_1 = [nom_1 nom_2]./price_index_1;
		real_3 = nom_3./price_index_3;
		real_tot = [round(real_1/10^5)/10, round(real_3/10^0)/10^6];
		clear nom_1 nom_2 nom_3 price_index_1 price_index_3 real_1 real_2 real_3

// index - decomp production price
		// final 
		Mean_Eco = [1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0];

// volume 
		// M/Y ratio quantity index
		volume = [round((sum(data.Household_savings)/sum(data.H_disposable_income))*10^4)/10^2, round(data.u_tot*10^4)/10^2, 1.0, 1.0, 1.0];

// funding --> warning HH
		Funding = [round(data.GFCF_byAgent(1:3)/10^5)/10, round(sum(data.GFCF_byAgent(1:3))/10^5)/10, round(data.GFCF_byAgent(1:3)/10^5)/10, round(data.Disposable_Income/10^5)/10, round(data.NetLending/10^5)/10, round(data.NetFinancialDebt/10^5)/10];
		// Funding = 	[round([data.GFCF_byAgent(1:2) sum(data.GFCF_byAgent(3:12)) sum(data.GFCF_byAgent)]/(data.I_pFish*10^5))/10,..
		// 			 round([data.GFCF_byAgent(1:2) sum(data.GFCF_byAgent(3:12))]/10^5)/10,..
		// 			 round([data.Disposable_Income(1:2) sum(data.Disposable_Income(3:12)) data.Disposable_Income(13)]/10^5)/10,..
		// 			 round([data.NetLending(1:2) sum(data.NetLending(3:12)) data.NetLending(13)]/10^5)/10,..
 		// 			 round([data.NetFinancialDebt(1:2) sum(data.NetFinancialDebt(3:12)) data.NetFinancialDebt(13)]/10^5)/10];

// changement structurel structure de coût / Travail / Production / Commerce
		GDP_sect = data.Labour_income + data.Labour_Tax +  data.Production_Tax - data.ClimPolCompensbySect + data.GrossOpSurplus + data.OtherIndirTax + data.VA_Tax + data.Energy_Tax_IC + sum(data.Carbon_Tax_IC,"r") + data.Energy_Tax_FC + sum(data.Carbon_Tax_C,"c")' ;
Structural_Change = [round(GDP_sect/10^3)/10^3 data.Y' data.M' divide(data.M, data.Y, %nan)' data.X' data.Labour divide(data.pM, data.pY, %nan)' sum(data.C,"c")' round(sum(data.C_value,"c")'/10^5)/10];
		clear GDP_sect

		tabular(:,4+elt) = [top_BY, verif, indexes, nom_tot, real_tot, Mean_Eco, volume, Funding, Structural_Change]';
		clear verif indexes nom_tot real_tot Mean_Eco volume Funding Structural_Change
//////////////////////////////////////////////////////////////////////////////////////////////
		clear data
		tabular(1,5) = "2016";
		tabular(1,6) = "2018";
	tabular_bis = tabular;
	tabular_bis(:,5) = tabular(:,size(tabular,2));
	tabular_bis(:,6:7) = tabular(:,5:6);
	tabular_bis(:,8) = tabular(:,size(tabular,2)-1);
	tabular_bis(:,9:size(tabular,2)) = tabular(:,7:size(tabular,2)-2);
	execstr("tabular_"+time_step+"=tabular_bis;");
//	csvWrite(tabular_bis,SAVEDIR+"tabular_" + time_step + ".csv", ';');
	csvWrite(tabular_bis,SAVEDIR+"comparative_tabular.csv", ';');
end

clear tabular
