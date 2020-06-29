// MODEL FILE STRUCTURE

sep = filesep(); // "/" or "\" depending on OS

cd("..");
PARENT    = pwd()  + sep;
CODE      = PARENT + "code" + sep;

LIB       = PARENT + "library" + sep;
getd(LIB); // Charge toutes les fonctions dans LIB

OUTPUT    = PARENT + "outputs" + sep + "200624_Run" + sep;
mkdir(OUTPUT);


DATA      = PARENT + "data" + sep; 
STUDY     = PARENT + "study_frames" + sep;
PARAMS    = PARENT + "params" + sep;
ROBOT     = PARENT + "robot" + sep;

SAVEDIR = OUTPUT + "comp_output" + sep;
mkdir(SAVEDIR);

cd(CODE);

// OUTPUT FILES TO IMPORT
CSV_list = ["param_table_sec" "ioQ-run" "io-run" "TechCOef-run" "Prices-run" "ecoT-run" "Prices_Index_Labour"];
year = ['2030', '2050'];
Nb_Iter = size(year,2);

// création du vecteur Scénario en fonction des variables de scénarisation définies ci-dessus
//Scenarios =["AME" "Lab_Tax" "LS_HH" "pY_CA" "pY_Ener" "pY_CO2" "pY_Tax" "pY_K" "Hybrid_CA" "Hybrid_Ener" "Hybrid_CO2" "Hybrid_K" "Hybrid_Tax"];
//Scenarios =["AME" "Lab_Tax" "LS_HH" "pY_CA" "pY_Ener" "pY_K" "Hybrid_CA" "Hybrid_Ener" "Hybrid_K"];
Scenarios =["AME" "AMS"] //Lab_Tax" "LS_HH" "pY_Ener" "Hybrid_Ener"];
// Scenarios =["AME_NDC" "AMS_NDC" "AMS_2°C"];
//Scenarios =["AME" "AMS-0.5" "AMS0" "AMS+0.5"];
//Scenarios =["AME" "Hybrid_Ener" "NoTax" "Tax_NoRecycling"];

// définition de l'en tête
top = 	["type", "Variables", "unit", "Agents/Sectors", Scenarios];

//////////////////////////
// définition des légendes
//////////////////////////

// verification 
type_verif = ["param", "param", "rate", "Volume", "Value", "Value", "Value", "Value"];
var_verif = ["delta_LS_H", "delta_LS_S", "Labour Tax Cut", "Emissions", "Carbon Tax", "Energy Tax", "Clim Tax", "Clim Transfers" ];
unit_verif = ["ratio", "ratio", "ratio", "GtCO2", "G€", "G€","G€", "G€"];
AgSec_verif = ["-", "-", "-", "-","-", "-", "-", "-"];  

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
var_nom_tot = ["GDP", "Consumption", "G_Conso", "Investment", "Trade Balance", "Net-of-tax wages", "Net-of-tax effective wages"];
unit_nom_tot = ["G€"];
AgSec_nom_tot = ["-"];
for elt=1:size(var_nom_tot,2)-1
	type_nom_tot(1,elt+1) = type_nom_tot(1,1);
	unit_nom_tot(1,elt+1) = unit_nom_tot(1,1);
	AgSec_nom_tot(1,elt+1) = AgSec_nom_tot(1,1);
end

// real macro values
type_real_tot = ["real"];
var_real_tot = ["GDP", "Consumption", "G_Conso", "Investment", "Trade Balance", "Net-of-tax wages", "Net-of-tax effective wages"];
unit_real_tot = ["G€"];
AgSec_real_tot = ["-"];
for elt=1:size(var_real_tot,2)-1
	type_real_tot(1,elt+1) = type_real_tot(1,1);
	unit_real_tot(1,elt+1) = unit_real_tot(1,1);
	AgSec_real_tot(1,elt+1) = AgSec_real_tot(1,1);
end

// index - decomp production price
type_mean = ["-", "-"];
var_mean = ["CPI", "mean productive price", "mean export price", "mean import price", "mean labour price", "mean capital price", "mean energy price", "mean non-energy price", "mean labour intensity", "mean capital intensity", "mean energy intensity"];
unit_mean = ["-", "ratio/BY"];
AgSec_mean = type_mean;
indice = size(type_mean,2);

for elt=1:size(var_mean,2)-indice
	type_mean(1,elt+indice) = type_mean(1,indice);
	unit_mean(1,elt+indice) = unit_mean(1,indice);
	AgSec_mean(1,elt+indice) = AgSec_mean(1,indice);
end
clear indice

// volume
type_volume = ["-", "-", "-", "-"];
var_volume = ["Unemployement rate", "M/Y", "Y", "X"];
unit_volume = ["%", "ratio/BY","ratio/BY", "ratio/BY"];
AgSec_volume = type_volume;

// funding
type_fund = ["nominal","nominal","nominal","nominal","nominal","nominal","nominal","nominal", "nominal","nominal", "nominal","nominal","nominal","nominal","nominal"];
var_fund = ["GFCF","GFCF","GFCF","Disposable income", "Disposable income", "Disposable income", "Disposable income", "Net Lending","Net Lending","Net Lending","Net Lending","Net Debt","Net Debt","Net Debt","Net Debt"];
unit_fund = ["G€","G€","G€","G€","G€","G€","G€","G€","G€","G€","G€","G€","G€","G€","G€"];
AgSec_fund = ["Corporations", "Government", "Households", "Corporations", "Government", "Households","Rest of the World", "Corporations", "Government", "Households","Rest of the World", "Corporations", "Government", "Households","Rest of the World"];

// changement structurel 
type_struc_temp = ["nominal" "-" "-" "-" "-" "-" "nominal"];
var_struc_temp = ["GDP sect" "Y" "M/Y" "X" "Jobs" "pM/pY" "VA sect"];
unit_struc_temp = ["G€" "volume" "ratio" "volume" "thousands" "ratio" "G€"];
AgSec_fund_temp = ["Crude_oil" "Natural_gas" "Coal" "AllFuels" "Electricity" "HeatGeoSol_Th" "Heavy_Industry" "Buildings_constr" "Work_constr" "Automobile" "OthThranspEquip" "Load_PipeTransp" "PassTransp" "AirTransp" "Agri_Food_industry" "Property_business" "OthSectors"];

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
		load(OUTPUT + Scenarios(elt) + sep + 'Time_' + year(time_step) + sep + "output_" + year(time_step) + ".sav")
// verif
Energy_Tax = sum(((data.Energy_Tax_rate_FC - BY.Energy_Tax_rate_FC)'.*.ones(1,1)).*data.C) + sum(((data.Energy_Tax_rate_IC - BY.Energy_Tax_rate_IC)'.*.ones(1,size(data.IC,1))).*data.IC);
verif = [data.delta_LS_H, data.delta_LS_S, data.Labour_Tax_Cut, (sum(data.CO2Emis_C_tot) + sum(data.CO2Emis_IC_tot)), round(sum(data.Carbon_Tax)/10^5)/10, round(Energy_Tax/10^5)/10, round((sum(data.Carbon_Tax) + Energy_Tax)/10^5)/10, round((sum(data.ClimPolCompensbySect) +sum(data.ClimPolicyCompens(3)))/10^5)/10];
clear Energy_Tax


// Indexes
		indexes = [data.GDP_pFish data.C_pFish data.G_pFish data.I_pFish data.X_pFish data.Y_pFish data.M_pFish];
		
// nominal macro values
		nom_1 = [data.GDP, sum(data.C_value), sum(data.G_value), sum(data.I_value)];
		nom_2 = sum(data.X_value) - sum(data.M_value);
		nom_3 = [data.omega, data.omega/((1+data.Mu)^data.time_since_BY)];
		nom_tot = [round(nom_1/10^5)/10, round(nom_2/10^5)/10, round(nom_3/10^0)/10^6];

// real macro values
		Trade_pLasp = (sum(data.pX.*BY.X)-sum(data.pM.*BY.M))/(sum(BY.pX.*BY.X)-sum(BY.pM.*BY.M)) ;
		Trade_pPaas = (sum(data.pX.*data.X)-sum(data.pM.*data.M))/(sum(BY.pX.*data.X)-sum(BY.pM.*data.M)) ;
		Trade_pFish = sqrt(abs(Trade_pLasp*Trade_pPaas));
		price_index_1 = [data.GDP_pFish, data.C_pFish, data.G_pFish, data.I_pFish, Trade_pFish];
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
		Mean_Eco = [data.CPI, data.Y_pFish, data.X_pFish, data.M_pFish, L_pFish, K_pFish, IC_Ener_pFish, IC_NonEn_pFish, lambda_pFish, kappa_pFish, alpha_Ener_pFish];
		clear L_pFish K_pFish IC_Ener_pFish IC_NonEn_pFish lambda_pFish kappa_pFish alpha_Ener_pFish

// volume
		// M/Y ratio quantity index
		if abs(data.Y(1))<1E-5
			M_Y_Ratio_qFish = QInd_Fish( BY.pM./BY.pY, BY.M./BY.Y, data.pM./data.pY, data.M./data.Y, [2:size(data.IC,1)], :);
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
		volume = [round(data.u_tot*10^4)/10^2, M_Y_Ratio_qFish, Y_qFish, X_qFish];
		clear M_Y_Ratio_qFish Y_qFish X_qFish

// funding
		Funding = [round(data.GFCF_byAgent/10^5)/10, round(data.Disposable_Income/10^5)/10, round(data.NetLending/10^5)/10, round(data.NetFinancialDebt/10^5)/10];

// changement structurel structure de coût / Travail / Production / Commerce
//		GDP_sect = data.Labour_income + data.Labour_Tax +  data.Production_Tax - data.ClimPolCompensbySect + data.GrossOpSurplus + data.OtherIndirTax + data.VA_Tax + data.Energy_Tax_IC + sum(data.Carbon_Tax_IC,"r") + data.Energy_Tax_FC + data.Carbon_Tax_C' ;
		GDP_sect = data.Labour_income + data.Labour_Tax +  data.Production_Tax - data.ClimPolCompensbySect + data.GrossOpSurplus + data.OtherIndirTax + data.VA_Tax + data.Energy_Tax_IC + data.Energy_Tax_FC + data.Carbon_Tax;
		VA_sect = data.Labour_income + data.Labour_Tax +  data.Production_Tax + data.Capital_income + data.Profit_margin;
		C_sect_share = data.C_value/sum(data.C_value);
		Structural_Change = [round(GDP_sect/10^3)/10^3 data.Y' divide(data.M, data.Y, %nan)' data.X' data.Labour divide(data.pM, data.pY, %nan)' round(100*C_sect_share'*10^3)/10^3];
		clear GDP_sect VA_sect C_sect_share
// final 
		tabular(:,4+elt) = [top(4+elt), verif, indexes, nom_tot, real_tot, Mean_Eco, volume, Funding, Structural_Change]';
		clear verif indexes nom_tot real_tot Mean_Eco volume Funding Structural_Change
		clear data
	end
//////////////////////////////////////////////////////////////////////////////////////////////
// Ajouter de l'année de base 
elt = elt + 1;
data = BY;
top_BY = "2010";
// verif
Energy_Tax = sum(((data.Energy_Tax_rate_FC - BY.Energy_Tax_rate_FC)'.*.ones(1,1)).*data.C) + sum(((data.Energy_Tax_rate_IC - BY.Energy_Tax_rate_IC)'.*.ones(1,size(data.IC,1))).*data.IC);
verif = [data.delta_LS_H, data.delta_LS_S, data.Labour_Tax_Cut, (sum(data.CO2Emis_C_tot) + sum(data.CO2Emis_IC_tot)), round(sum(data.Carbon_Tax)/10^5)/10, round(Energy_Tax/10^5)/10, round((sum(data.Carbon_Tax) + Energy_Tax)/10^5)/10, round((sum(data.ClimPolCompensbySect) +sum(data.ClimPolicyCompens(3)))/10^5)/10];
clear Energy_Tax

// indexes 
	indexes = ones(1,size(var_index,2));

// nominal macro values
		nom_1 = [data.GDP, sum(data.C_value), sum(data.G_value), sum(data.I_value)];
		nom_2 = sum(data.X_value) - sum(data.M_value);
		nom_3 = [data.omega, data.omega/((1+data.Mu)^data.time_since_BY)];
		nom_tot = [round(nom_1/10^5)/10, round(nom_2/10^5)/10, round(nom_3/10^0)/10^6];

// real macro values
		Trade_pLasp = (sum(data.pX.*BY.X)-sum(data.pM.*BY.M))/(sum(BY.pX.*BY.X)-sum(BY.pM.*BY.M)) ;
		Trade_pPaas = (sum(data.pX.*data.X)-sum(data.pM.*data.M))/(sum(BY.pX.*data.X)-sum(BY.pM.*data.M)) ;
		Trade_pFish = sqrt(Trade_pLasp*Trade_pPaas);
		price_index_1 = [1.0, 1.0, 1.0, 1.0, 1.0];
		price_index_3 = [data.CPI, data.CPI];
		real_1 = [nom_1 nom_2]./price_index_1;
		real_3 = nom_3./price_index_3;
		real_tot = [round(real_1/10^5)/10, round(real_3/10^0)/10^6];
		clear nom_1 nom_2 nom_3 price_index_1 price_index_3 real_1 real_2 real_3

// index - decomp production price
		// final 
		Mean_Eco = [data.CPI, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0];

// volume
		// M/Y ratio quantity index
		volume = [round(data.u_tot*10^4)/10^2, 1.0, 1.0, 1.0];

// funding
		Funding = [round(data.GFCF_byAgent(1:3)/10^5)/10, round(data.Disposable_Income/10^5)/10, round(data.NetLending/10^5)/10, round(data.NetFinancialDebt/10^5)/10];

// changement structurel structure de coût / Travail / Production / Commerce
		GDP_sect = data.Labour_income + data.Labour_Tax +  data.Production_Tax - data.ClimPolCompensbySect + data.GrossOpSurplus + data.OtherIndirTax + data.VA_Tax + data.Energy_Tax_IC + sum(data.Carbon_Tax_IC,"r") + data.Energy_Tax_FC + data.Carbon_Tax_C' ;
		VA_sect = data.Labour_income + data.Labour_Tax +  data.Production_Tax - data.ClimPolCompensbySect + data.Capital_income + data.Profit_margin;
		C_sect_share = data.C_value/sum(data.C_value);
		Structural_Change = [round(GDP_sect/10^3)/10^3 data.Y' divide(data.M, data.Y, %nan)' data.X' data.Labour divide(data.pM, data.pY, %nan)' round(100*C_sect_share'/10^3)/10^3];
		clear GDP_sect VA_sect C_sect_share

		tabular(:,4+elt) = [top_BY, verif, indexes, nom_tot, real_tot, Mean_Eco, volume, Funding, Structural_Change]';
		clear verif indexes nom_tot real_tot Mean_Eco volume Funding Structural_Change
//////////////////////////////////////////////////////////////////////////////////////////////
		clear data
	tabular_bis = tabular;
	tabular_bis(:,5) = tabular(:,size(tabular,2));
	tabular_bis(:,6:size(tabular,2)) = tabular(:,5:size(tabular,2)-1);
	execstr("tabular_"+time_step+"=tabular_bis;");
	csvWrite(tabular_bis,SAVEDIR+"tabular_" + time_step + ".csv", ';');
end

clear tabular
tabular_final = tabular_1;
tabular_final(:,size(tabular_1,2)+1:size(tabular_1,2)+size(6:size(tabular_2,2),2)) = tabular_2(:,6:size(tabular_2,2));

csvWrite(tabular_final,SAVEDIR+"tabular_final.csv", ';');
