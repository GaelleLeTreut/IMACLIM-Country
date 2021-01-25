// build a new set of calibration data based on sav file 

// reload library
getd(LIB);

// define new data dir
DataDir = PARENT + "data" + sep + "data_FRA2018" + sep;
mkdir(DataDir);
mkdir(DataDir + "Data_RoW" + sep);

// common param
fact = 1;
decimals = 5;

// DataAccountTable
Ecotable = buildEcoTabl(data_1.Ecotable, fact, decimals);
Ecotable(size(Ecotable,1)-1:size(Ecotable,1),:)=[];
Ecotable(size(Ecotable,1)+1,:) = ["Thousand of euros", "0", "0", "0", "0"];
csvWrite(Ecotable, DataDir + "DataAccountTable.csv", ";");

// Demography
Demo = read_csv(DATA_Country + "Demography.csv", ";");
Demo(2,2) = string(Population);
Demo(3,2) = string(Retired);
Demo(4,2) = string(Unemployed);
Demo(5,2) = string(Labour_force);
Demo(7,2) = "%nan";
csvWrite(Demo, DataDir + "Demography.csv", ";");

// Copyfile what is identical
data_list = ["Distribution_Shares_form", "Index_EconData", "Index_Imaclim_VarCalib", "Index_Imaclim_VarResol", "Index_Imaclim_VarResCap", "Index_Imaclim_Param"];
for data_elt=1:size(data_list,2)
	copyfile(DATA_Country + data_list(data_elt) + ".csv", DataDir + data_list(data_elt) + ".csv");
end
// "Index_IOT_AGG_30Sect", "Index_IOT_AGG_4SecB" // build from python file

dataRoW_list = ["Index_Region", "CoefCO2_reg", "CoefCO2_reg_AGG_4SecB"]; 
for data_elt=1:size(dataRoW_list,2)
	copyfile(DATA_Country + "Data_RoW" + sep + dataRoW_list(data_elt) + ".csv", DataDir + "Data_RoW" + sep + dataRoW_list(data_elt) + ".csv");
end

dataH10_list = ["DataAccount_rate_H10", "Demography_rate_H10", "Index_EconData_H10", ];
for data_elt=1:size(dataH10_list,2)
	copyfile(DATA_Country + "H10" + sep + dataH10_list(data_elt) + ".csv", DataDir + "H10" + sep + dataH10_list(data_elt) + ".csv");
end
// "Index_IOT_AGG_30Sect_H10", "Index_IOT_AGG_4Sec_H10" // build from python file

// IOT_CO2Emis (using part of buildEmisT function)
CO2Emis = buildEmisT_bis(CO2Emis_IC, CO2Emis_C, CO2Emis_X, CO2Emis_Sec, Tot_CO2Emis_IC, Tot_CO2Emis_C, DOM_CO2, fact, decimals);
csvWrite(CO2Emis, DataDir + "IOT_CO2Emis.csv", ";");

// IOT_Import_rate
	// build from python file 

// IOT_Prices
Prices = buildPriceT_bis(pIC, pFC, w, pL, pK, pY, pM, p, fact, decimals);
csvWrite(Prices, DataDir + "IOT_Prices.csv", ";");

// IOT_Val
iot = buildIot_bis( IC_value , FC_value , OthPart_IOT, Carbon_Tax,Supply, Uses, fact , decimals );
csvWrite(iot, DataDir + "IOT_Val.csv", ";");

// IOT_Qtities & Labour
[iotq, Labour] = buildIotQ_and_Labour(IC, FC, OthQ, fact, decimals);
csvWrite(iotq, DataDir + "IOT_Qtities.csv", ";");
csvWrite(Labour, DataDir + "Labour.csv", ";");
