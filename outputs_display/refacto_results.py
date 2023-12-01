import pandas as pd 
import numpy as np
import datetime as dt
from tools import *
from pandas import DataFrame

# ########## input data
df = pd.read_csv('/Users/douda/Documents/GitHub/IMACLIM-Country/outputs_display/MacroTables/FullTemplate_BY_byStep.csv', sep =";", header=None)
# # ademe = pd.read_excel("/Users/rdo2/Dropbox/PC/Documents/GitHub/IMACLIM-Country/MacroTables/ADEME.xlsx",skiprows=0,sheet_name="Feuil1")
# ########## end input data  

############## parameters
nb_scenarios_S2 = 242
nb_scenarios_S3 = 242
years = [2018,2030,2050]
mapping_scenarios = {"S2test_1" : "S2ref", 
                     "S3test_1" : "S3ref",
                     "sTEND_1" : "TENDref"}
mapping_variantes = {"S2" : "Variantes S2", 
                     "S3" : "Variantes S3",
                     "TEND" : "Variantes TEND",
                     "S2 reference": "Reference S2",
                     "S3 reference": "Reference S3",
                     "TEND reference": "Reference TEND"}
mapping_scenarios_2 = {"S2ref" : "S2", 
                       "S3ref" : "S3",
                       "TENDref" : "TEND",  
                       "S2" : "S2", 
                       "S3" : "S3",
                       "TEND" : "TEND"}
mapping_score_type = {"C_energy" : "Energy",
                      "C_energy_rstd" : "Energy",
                      "IC_energy_without_energy" : "Energy", 
                      "IC_energy_rstd" : "Energy",
                      "Energy" : "Energy", 
                      "Energy_rstd" : "Energy",
                      "Unemployment" : "Economy",
                      "Unemployment_rstd" : "Economy",
                      "GDP" : "Economy",
                      "GDP_rstd" : "Economy",
                      "e_h_consumption" : "Economy",
                      "all_goals_ref" : "all"}

scenarios_selection = [["S2","S2_1_2018","S2_1_2030","S2_1_2050"],["S3","S3_1_2018","S3_1_2030","S3_1_2050"]]
# scenarios_selection = [["sTEND","sTEND_1_2018","sTEND_1_2030","sTEND_1_2050"],["S2","S2_1_2018","S2_1_2030","S2_1_2050"],["S3","S3_1_2018","S3_1_2030","S3_1_2050"]]
# scenarios_selection = [["S2","S2_1nm_2018","S2_1nm_2030","S2_1nm_2050"], ["S3","S3_1nm_2018","S3_1nm_2030","S3_1nm_2050"]]
score_years = ["2030","2050"]
score_scenarios = ["S2","S3"]
position = 1
position_2 = 4
############## end parameters

############## initialization
current_date_and_time = dt.datetime.now().strftime("%d_%m_%Y_%H_%M_%S")
current_date_and_time_string = str(current_date_and_time)
results=[]
results_scenario=[]
results_year = []
results_score = []

############## scenarios list : 72 rows * 1 column
scenarios = df.iloc[0].to_frame().drop_duplicates()
scenarios.drop(index=0, inplace=True)
scenarios.rename(columns = {0 : 'Scenario'}, inplace = True)
scenarios.reset_index(inplace=True)
scenarios.drop(columns=['index'], inplace=True)
############## end scenarios

######### dataframe cleaning
df.drop([0,1], inplace=True)
df.reset_index(inplace=True)
df.drop(columns=['index'], inplace=True)
df.columns = df.iloc[0]
df.reset_index(inplace=True)
df.drop(columns=['index'], inplace=True)
df.drop(index=0, inplace=True)
######### end dataframe cleaning

########### list of all variables
variables = df.iloc[:, 0].to_frame()

################ Transform : TCD format
# step 1
for index, scenario in enumerate(scenarios.values.tolist()):
    try:
        df_temp = df.iloc[:, position:position_2]
        df_temp.columns = ["values_2018","values_2030","values_2050"]

        df_temp["Scenario"]= scenario[0]
        df_temp_2 = variables.join(df_temp) 

        results.append(df_temp_2)
    except KeyError:
        pass

    position = position + 3
    position_2 = position_2 + 3

# step 2
tcd_results=pd.concat(results)
df_tcd_format= pd.wide_to_long(tcd_results,stubnames='values_',i=["Variables","Scenario"], j="year")
df_tcd_format.reset_index(inplace=True)
df_tcd_format.to_csv("/Users/rdo2/Dropbox/PC/Documents/GitHub/IMACLIM-Country/MacroTables/df_tcd_format.csv",sep=";")

df_tcd_format = df_tcd_format.pivot(index=['Scenario','year'], columns=['Variables'], values='values_')

######## Mapping
df_tcd_format.rename(columns={"Real GDP": "Real_GDP",
            "Real C": "Real_C",
            "Real G": "Real_G",
            "Real I": "Real_I",
            "Real X": "Real_X",
            "Real M": "Real_M",
            "Real Y": "Real_Y",
            "Real Trade Balance": "Real_trade_balance",
            "pC pFish/BY": "pC_pFish_BY",
            "pM pFish/BY": "pM_pFish_BY",
            "Unemployment % points/BY": "unemployment",
            "IC - Energy ktoe": "IC_energy_ktoe",
            "C - Energy - ktoe": "C_energy_ktoe",
            "	Energy in Households consumption": "e_h_consumption"}, inplace= True)

# ademe = ademe.pivot(index=['Scenario','year'], columns=['Variables'], values='values_')
# ademe['type'] = "REF ThreeME"

################################# Concaténation de colonnes #########################################################################

df_tcd_format["IC_energy_ktoe_without_energy"] = df_tcd_format["IC_energy_ktoe"].astype(float) - df_tcd_format["IC Energy - Oil - ktoe "].astype(float) - df_tcd_format["IC Energy - Electricity - ktoe "].astype(float) - df_tcd_format["IC Energy - Coal_lignite - ktoe "].astype(float) - df_tcd_format["IC Energy - Gas_heating - ktoe "].astype(float) 

# print("test oil")
# print(df_tcd_format["IC Energy - Oil - ktoe "].astype(float))
# print()
# print("test electricity")
# print(df_tcd_format["IC Energy - Electricity - ktoe "].astype(float))
# print()
# print("test coal")
# print(df_tcd_format["IC Energy - Coal_lignite - ktoe "].astype(float))
# print()
# print("test gas")
# print(df_tcd_format["IC Energy - Gas_heating - ktoe "].astype(float))
# print()

df_tcd_format["energy_ktoe"] = df_tcd_format["IC_energy_ktoe_without_energy"].astype(float) + df_tcd_format["C_energy_ktoe"].astype(float)

u_base = 9.6664865

df_tcd_format["unemployment_2"] = df_tcd_format["unemployment"].astype(float) + u_base

df_tcd_format['PIB_hab'] = df_tcd_format["Real_GDP"].astype(float) / df_tcd_format["Population"].astype(float)
df_tcd_format['energy_ktoe_hab'] = df_tcd_format["energy_ktoe"].astype(float) / df_tcd_format["Population"].astype(float)
#df_tcd_format['Labour_ratio'] = df_tcd_format["Labour ThousandFTE"].astype(float) / df_tcd_format["pop_15_64"].astype(float)
df_tcd_format['Labour_ratio_2'] = df_tcd_format["Labour ThousandFTE"].astype(float) / df_tcd_format["Labour_force"].astype(float)

df_tcd_format.reset_index(inplace=True)

df_tcd_format["Scenario_year"] = df_tcd_format["Scenario"].map(str) + "_" + df_tcd_format["year"].map(str) 

################################# Filtres S2/S3 ##################################################################################

# df_tcd_format_f0 = df_tcd_format.loc[df_tcd_format['VAR_saving'] == "neoclassical_macroclosure"]

# df_tcd_format_f1 = df_tcd_format_f0.loc[df_tcd_format_f0['VAR_population'] == "ref"]

# df_tcd_format_f2 = df_tcd_format_f1.loc[df_tcd_format_f1['VAR_sigma_omegaU'] == "ademevalue"]

for index, scenario in enumerate(scenarios_selection) : 

    df_tcd_format_temp = df_tcd_format.loc[df_tcd_format['Scenario'].str.contains(scenario[0])]

    # print()
    # print(df_tcd_format_temp['energy_ktoe'].astype(float))
    # print()
    # print(float(df_tcd_format_temp.loc[df_tcd_format_temp['Scenario_year'] == scenario[1], 'energy_ktoe']))

    pib_y = df_tcd_format_temp['Real_GDP'].astype(float)
    pib_paasche_y = df_tcd_format_temp['Real_GDP_Paasche'].astype(float)
    energy_y = df_tcd_format_temp['energy_ktoe'].astype(float)
    pop_y = df_tcd_format_temp['Population'].astype(float)
    pib_2018 = float(df_tcd_format_temp.loc[df_tcd_format_temp['Scenario_year'] == scenario[1], 'Real_GDP'])
    pop_2018 = float(df_tcd_format_temp.loc[df_tcd_format_temp['Scenario_year'] == scenario[1], 'Population'])
    energy_2018 = float(df_tcd_format_temp.loc[df_tcd_format_temp['Scenario_year'] == scenario[1], 'energy_ktoe'])

    df_tcd_format_temp['energy_ktoe_BY'] = df_tcd_format_temp['energy_ktoe'].astype(float) / float(df_tcd_format_temp.loc[df_tcd_format_temp['Scenario_year'] == scenario[1], 'energy_ktoe'])
    df_tcd_format_temp['energy_ktoe_hab_BY'] = (energy_y / pop_y) / (energy_2018 / pop_2018)
    df_tcd_format_temp['Real_GDP_BY'] = df_tcd_format_temp['Real_GDP'].astype(float) / float(df_tcd_format_temp.loc[df_tcd_format_temp['Scenario_year'] == scenario[1], 'Real_GDP'])
    df_tcd_format_temp['Real_GDP_hab'] = (pib_y / pop_y)
    df_tcd_format_temp['Real_GDP_hab_BY'] = (pib_y / pop_y) / (pib_2018 / pop_2018)
    df_tcd_format_temp['Real_GDP_Paasche_hab'] = (pib_paasche_y / pop_y)
    df_tcd_format_temp['Real_GDP_Paasche_hab_BY'] = (pib_paasche_y / pop_y) / (pib_2018 / pop_2018)
    df_tcd_format_temp['C_energy_ktoe_BY'] = df_tcd_format_temp['C_energy_ktoe'].astype(float) / float(df_tcd_format_temp.loc[df_tcd_format_temp['Scenario_year'] == scenario[1], 'C_energy_ktoe'])
    df_tcd_format_temp['IC_energy_ktoe_without_energy_BY'] = df_tcd_format_temp['IC_energy_ktoe_without_energy'].astype(float) / float(df_tcd_format_temp.loc[df_tcd_format_temp['Scenario_year'] == scenario[1], 'IC_energy_ktoe_without_energy'])
    df_tcd_format_temp['Real_C_BY'] = df_tcd_format_temp['Real_C'].astype(float) / float(df_tcd_format_temp.loc[df_tcd_format_temp['Scenario_year'] == scenario[1], 'Real_C'])
    df_tcd_format_temp['Real_G_BY'] = df_tcd_format_temp['Real_G'].astype(float) / float(df_tcd_format_temp.loc[df_tcd_format_temp['Scenario_year'] == scenario[1], 'Real_G'])
    df_tcd_format_temp['Real_I_BY'] = df_tcd_format_temp['Real_I'].astype(float) / float(df_tcd_format_temp.loc[df_tcd_format_temp['Scenario_year'] == scenario[1], 'Real_I'])
    df_tcd_format_temp['Real_X_BY'] = df_tcd_format_temp['Real_X'].astype(float) / float(df_tcd_format_temp.loc[df_tcd_format_temp['Scenario_year'] == scenario[1], 'Real_X'])
    df_tcd_format_temp['Real_M_BY'] = df_tcd_format_temp['Real_M'].astype(float) / float(df_tcd_format_temp.loc[df_tcd_format_temp['Scenario_year'] == scenario[1], 'Real_M'])
    df_tcd_format_temp['Real_Y_BY'] = df_tcd_format_temp['Real_Y'].astype(float) / float(df_tcd_format_temp.loc[df_tcd_format_temp['Scenario_year'] == scenario[1], 'Real_Y'])


    for index, year in enumerate(years) :

        str_year = str(year)

        df_tcd_format_year = df_tcd_format_temp.loc[df_tcd_format_temp['year'].astype(str).str.contains(str_year)]

        print(str_year)

        # Variation compared to reference configuration
#       df_tcd_format_year['Labour_ratio_BY_ref'] = df_tcd_format_temp['Labour_ratio'].astype(float) / float(df_tcd_format_temp.loc[df_tcd_format_temp['Scenario_year'] == scenario[index+1], 'Labour_ratio'])
        df_tcd_format_year['Labour_ratio_2_BY_ref'] = df_tcd_format_temp['Labour_ratio_2'].astype(float) / float(df_tcd_format_temp.loc[df_tcd_format_temp['Scenario_year'] == scenario[index+1], 'Labour_ratio_2'])
        df_tcd_format_year['Real_GDP_BY_ref'] = df_tcd_format_temp['Real_GDP'].astype(float) / float(df_tcd_format_temp.loc[df_tcd_format_temp['Scenario_year'] == scenario[index+1], 'Real_GDP'])
        df_tcd_format_year['Real_GDP_hab_BY_ref'] = df_tcd_format_temp['Real_GDP_hab'].astype(float) / float(df_tcd_format_temp.loc[df_tcd_format_temp['Scenario_year'] == scenario[index+1], 'Real_GDP_hab'])
        df_tcd_format_year['energy_ktoe_BY_ref'] = df_tcd_format_temp[df_tcd_format_temp.year == year]['energy_ktoe'].astype(float) / float(df_tcd_format_temp.loc[df_tcd_format_temp['Scenario_year'] == scenario[index+1], 'energy_ktoe'])
        df_tcd_format_year['C_energy_ktoe_BY_ref'] = df_tcd_format_temp[df_tcd_format_temp.year == year]['C_energy_ktoe'].astype(float) / float(df_tcd_format_temp.loc[df_tcd_format_temp['Scenario_year'] == scenario[index+1], 'C_energy_ktoe'])
        df_tcd_format_year['IC_energy_ktoe_without_energy_BY_ref'] = df_tcd_format_temp[df_tcd_format_temp.year == year]['IC_energy_ktoe_without_energy'].astype(float) / float(df_tcd_format_temp.loc[df_tcd_format_temp['Scenario_year'] == scenario[index+1], 'IC_energy_ktoe_without_energy'])
        df_tcd_format_year['unemployment_BY_ref'] = df_tcd_format_temp[df_tcd_format_temp.year == year]['unemployment_2'].astype(float) / float(df_tcd_format_temp.loc[df_tcd_format_temp['Scenario_year'] == scenario[index+1], 'unemployment_2'])
        df_tcd_format_year['e_h_consumption_BY_ref'] = df_tcd_format_temp[df_tcd_format_temp.year == year]['e_h_consumption'].astype(float) / float(df_tcd_format_temp.loc[df_tcd_format_temp['Scenario_year'] == scenario[index+1], 'e_h_consumption'])
        df_tcd_format_year['Real_M_BY_ref'] = df_tcd_format_temp[df_tcd_format_temp.year == year]['Real_M'].astype(float) / float(df_tcd_format_temp.loc[df_tcd_format_temp['Scenario_year'] == scenario[index+1], 'Real_M'])

        # Relative standard deviation

        df_tcd_format_year["C_energy_ktoe_rstd"] = np.std(df_tcd_format_temp[df_tcd_format_temp.year == year]["C_energy_ktoe"].astype(float)) / np.mean(df_tcd_format_temp[df_tcd_format_temp.year == year]["C_energy_ktoe"].astype(float))
        df_tcd_format_year["IC_energy_ktoe_without_energy_rstd"] = np.std(df_tcd_format_temp[df_tcd_format_temp.year == year]["IC_energy_ktoe_without_energy"].astype(float)) / np.mean(df_tcd_format_temp[df_tcd_format_temp.year == year]["IC_energy_ktoe_without_energy"].astype(float))
        df_tcd_format_year["energy_ktoe_rstd"] = np.std(df_tcd_format_temp[df_tcd_format_temp.year == year]["energy_ktoe"].astype(float)) / np.mean(df_tcd_format_temp[df_tcd_format_temp.year == year]["energy_ktoe"].astype(float))
        df_tcd_format_year["energy_ktoe_hab_rstd"] = np.std(df_tcd_format_temp[df_tcd_format_temp.year == year]["energy_ktoe_hab"].astype(float)) / np.mean(df_tcd_format_temp[df_tcd_format_temp.year == year]["energy_ktoe_hab"].astype(float))
        df_tcd_format_year["Real_GDP_rstd"] = np.std(df_tcd_format_temp[df_tcd_format_temp.year == year]["Real_GDP"].astype(float)) / np.mean(df_tcd_format_temp[df_tcd_format_temp.year == year]["Real_GDP"].astype(float))
        df_tcd_format_year["PIB_hab_rstd"] = np.std(df_tcd_format_temp[df_tcd_format_temp.year == year]["PIB_hab"].astype(float)) / np.mean(df_tcd_format_temp[df_tcd_format_temp.year == year]["PIB_hab"].astype(float))
        df_tcd_format_year["unemployment_rstd"] = np.std(df_tcd_format_temp[df_tcd_format_temp.year == year]["unemployment"].astype(float)) / np.mean(df_tcd_format_temp[df_tcd_format_temp.year == year]["unemployment"].astype(float))
#        df_tcd_format_year["Labour_ratio_rstd"] = np.std(df_tcd_format_temp[df_tcd_format_temp.year == year]["Labour_ratio"].astype(float)) / np.mean(df_tcd_format_temp[df_tcd_format_temp.year == year]["Labour_ratio"].astype(float))

#        df_tcd_format_year.to_csv("/Users/rdo2/Dropbox/PC/Documents/posttraitement/df_tcd_format" + str_year + ".csv" ,sep=";")

        results_year.append(df_tcd_format_year)

df4 = pd.concat([results_year[0], results_year[1], results_year[2], results_year[3],results_year[4],results_year[5]])

# df4 = pd.concat([results_year[0], results_year[1], results_year[2], results_year[3],results_year[4],results_year[5],results_year[6],results_year[7],results_year[8]])

# df4 = pd.concat([results_year[0], results_year[1], results_year[2]])

df4['Scenario_type'] = df4['Scenario'].map(mapping_scenarios,na_action='ignore')
df4['Scenario_type'].fillna(df4['Scenario'], inplace=True)
test = df4['Scenario_type'].str.replace(r'\S3_\d+', 'S3', regex=True)
test2 = test.str.replace(r'\S2_\d+', 'S2', regex=True)
test3= test2.str.replace(r'\STEND_\d+', 'TEND', regex=True)
df4['Scenario_type'] = test3
################################# Scénarios qui atteignent les objectifs #########################################################

df4 = df4[df4['VAR_sigma_omegaU'] == "ademevalue"]

dfS2 = df4[(df4["unemployment_2"].astype(float) < 9.83803) & (df4["Scenario_type"] == "S2") & (df4["year"] == 2030)]
dfS3 = df4[(df4["unemployment_2"].astype(float) < 10.05457) & (df4["Scenario_type"] == "S3") & (df4["year"] == 2030)]

################################################################################################################

df4["gdp_goal_ref"] = np.where(df4["Real_GDP_BY_ref"].astype(float) >= 1, 1, 0)

df4["energy_goal_ref"] = np.where(df4["energy_ktoe_BY_ref"].astype(float) >= 1, 1, 0)
df4["C_energy_goal_ref"] = np.where(df4["C_energy_ktoe_BY_ref"].astype(float) <= 1, 1, 0)
df4["IC_energy_without_energy_goal_ref"] = np.where(df4["IC_energy_ktoe_without_energy_BY_ref"].astype(float) <= 1, 1, 0)


df4["unemployment_target_ref"] = np.where(df4["unemployment_BY_ref"].astype(float) <= 1, 1, 0)

df4["e_h_consumption_goal_ref"] = np.where(df4["e_h_consumption_BY_ref"].astype(float) >= 1, 1, 0)

df4["all_goals_ref"] = np.where( (df4["energy_ktoe_BY_ref"].astype(float) > 1) &
                             (df4["unemployment_BY_ref"].astype(float) < 1), 1, 0)

################################# Colonnes pour variantes ceteris paribus #########################################################

condition_reference = (df4["VAR_population"] =="ref") &  (df4['VAR_import_enersect'] == "ref") & (df4['VAR_saving'] == "ref") & (df4['trade_drive'] == "exports_detailed") & (df4['VAR_Mu'] == "ref") & (df4['VAR_sigma_omegaU'] == "ademevalue") & (df4['VAR_sigma_MX'] == "ref")

sample_reference = df4.loc[condition_reference,'Scenario'].drop_duplicates().tolist()
mapping_reference = dict.fromkeys(sample_reference, "reference")
mapping_reference = {k:"S2 reference" if ("S2" in k) else "S3 reference" for k, v in mapping_reference.items()}

#### condition mu
condition_mu_low = (df4["VAR_population"] =="ref") &  (df4['VAR_import_enersect'] == "ref") & (df4['VAR_saving'] == "ref") & (df4['trade_drive'] == "exports_detailed") & (df4['VAR_Mu'] == "low")
condition_mu_high = (df4["VAR_population"] =="ref") &  (df4['VAR_import_enersect'] == "ref") & (df4['VAR_saving'] == "ref") & (df4['trade_drive'] == "exports_detailed") & (df4['VAR_Mu'] == "high")

#### condition population
condition_population_low = (df4["VAR_Mu"] =="ref") &  (df4['VAR_import_enersect'] == "ref") & (df4['VAR_saving'] == "ref") & (df4['trade_drive'] == "exports_detailed") & (df4['VAR_population'] == "low")
condition_population_high = (df4["VAR_Mu"] =="ref") &  (df4['VAR_import_enersect'] == "ref") & (df4['VAR_saving'] == "ref") & (df4['trade_drive'] == "exports_detailed") & (df4['VAR_population'] == "high")

#### condition import enersect
condition_import_enersect_low = (df4["VAR_population"] =="ref") &  (df4['VAR_Mu'] == "ref") & (df4['VAR_saving'] == "ref") & (df4['trade_drive'] == "exports_detailed") & (df4['VAR_import_enersect'] == "low")
condition_import_enersect_high = (df4["VAR_population"] =="ref") &  (df4['VAR_Mu'] == "ref") & (df4['VAR_saving'] == "ref") & (df4['trade_drive'] == "exports_detailed") & (df4['VAR_import_enersect'] == "high")

#### condition saving
condition_saving_low = (df4["VAR_population"] =="ref") &  (df4['VAR_import_enersect'] == "ref") & (df4['VAR_Mu'] == "ref") & (df4['trade_drive'] == "exports_detailed") & (df4['VAR_saving'] == "low")
condition_saving_high = (df4["VAR_population"] =="ref") &  (df4['VAR_import_enersect'] == "ref") & (df4['VAR_Mu'] == "ref") & (df4['trade_drive'] == "exports_detailed") & (df4['VAR_saving'] == "high")

#### condition trade_drive
condition_trade_drive_low = (df4["VAR_population"] =="ref") &  (df4['VAR_import_enersect'] == "ref") & (df4['VAR_saving'] == "ref") & (df4['VAR_Mu'] == "ref") & (df4['trade_drive'] == "exports_detailed_low")
condition_trade_drive_high = (df4["VAR_population"] =="ref") &  (df4['VAR_import_enersect'] == "ref") & (df4['VAR_saving'] == "ref") & (df4['VAR_Mu'] == "ref") & (df4['trade_drive'] == "exports_detailed_high")

#### condition sigma_MX
condition_sigma_MX_low = (df4["VAR_population"] =="ref") &  (df4['VAR_import_enersect'] == "ref") & (df4['VAR_saving'] == "ref") & (df4['VAR_Mu'] == "ref") & (df4['trade_drive'] == "exports_detailed") & (df4['VAR_sigma_omegaU'] == "ademevalue") & (df4['VAR_sigma_MX'] == "low")
condition_sigma_MX_high = (df4["VAR_population"] =="ref") &  (df4['VAR_import_enersect'] == "ref") & (df4['VAR_saving'] == "ref") & (df4['VAR_Mu'] == "ref") & (df4['trade_drive'] == "exports_detailed") & (df4['VAR_sigma_omegaU'] == "ademevalue") & (df4['VAR_sigma_MX'] == "high")

#### condition sigma_omegaU
condition_sigma_omegaU_high = (df4["VAR_population"] =="ref") &  (df4['VAR_import_enersect'] == "ref") & (df4['VAR_saving'] == "ref") & (df4['VAR_Mu'] == "ref") & (df4['trade_drive'] == "exports_detailed")  & (df4['VAR_sigma_MX'] == "ref") & (df4['VAR_sigma_omegaU'] == "ref")


#condition_sigma_omegaU = (df4["VAR_population"] =="ref") &  (df4['VAR_import_enersect'] == "ref") & (df4['VAR_saving'] == "ref") & (df4['trade_drive'] == "exports_detailed") & (df4['VAR_Mu'] == "ref") & (df4['VAR_sigma_MX'] == "ref") & (df4['VAR_sigma_omegaU'] == "ref")
#condition_sigma_MX = (df4["VAR_population"] =="ref") &  (df4['VAR_import_enersect'] == "ref") & (df4['VAR_saving'] == "ref") & (df4['trade_drive'] == "exports_detailed") & (df4['VAR_Mu'] == "ref") & (df4['VAR_sigma_omegaU'] == "ademevalue") & (df4['VAR_sigma_MX'] == "low")

sample_mu_low = df4.loc[condition_mu_low,'Scenario'].drop_duplicates().tolist()
mapping_mu_low = dict.fromkeys(sample_mu_low, "productivity_low")
sample_mu_high = df4.loc[condition_mu_high,'Scenario'].drop_duplicates().tolist()
mapping_mu_high = dict.fromkeys(sample_mu_high, "productivity_high")

sample_population_low = df4.loc[condition_population_low,'Scenario'].drop_duplicates().tolist()
mapping_population_low = dict.fromkeys(sample_population_low, "population_low")
sample_population_high = df4.loc[condition_population_high,'Scenario'].drop_duplicates().tolist()
mapping_population_high = dict.fromkeys(sample_population_high, "population_high")

sample_import_enersect_low = df4.loc[condition_import_enersect_low,'Scenario'].drop_duplicates().tolist()
mapping_import_enersect_low = dict.fromkeys(sample_import_enersect_low, "energy_price_low")
sample_import_enersect_high = df4.loc[condition_import_enersect_high,'Scenario'].drop_duplicates().tolist()
mapping_import_enersect_high = dict.fromkeys(sample_import_enersect_high, "energy_price_high")

sample_saving_low = df4.loc[condition_saving_low,'Scenario'].drop_duplicates().tolist()
mapping_saving_low = dict.fromkeys(sample_saving_low, "households_saving_low")
sample_saving_high = df4.loc[condition_saving_high,'Scenario'].drop_duplicates().tolist()
mapping_saving_high = dict.fromkeys(sample_saving_high, "households_saving_high")

test_std = df4.loc[(df4['VAR_saving'] == "ref") ]

test_std = test_std[['Scenario','year','energy_ktoe_BY','Real_GDP_BY','unemployment']]

# print(test_std)

# test_std.to_csv("/Users/rdo2/Dropbox/PC/Documents/posttraitement/test_std_" + current_date_and_time_string +".csv" ,sep=";")

sample_trade_drive_low = df4.loc[condition_trade_drive_low,'Scenario'].drop_duplicates().tolist()
mapping_trade_drive_low = dict.fromkeys(sample_trade_drive_low, "exports_low")
sample_trade_drive_high = df4.loc[condition_trade_drive_high,'Scenario'].drop_duplicates().tolist()
mapping_trade_drive_high = dict.fromkeys(sample_trade_drive_high, "exports_high")

sample_sigma_omegaU_high = df4.loc[condition_sigma_omegaU_high,'Scenario'].drop_duplicates().tolist()
mapping_sigma_omegaU_high = dict.fromkeys(sample_sigma_omegaU_high, "sigma01")

sample_sigma_MX_low = df4.loc[condition_sigma_MX_low,'Scenario'].drop_duplicates().tolist()
mapping_sigma_MX_low = dict.fromkeys(sample_sigma_MX_low, "export_elasticity_low")
sample_sigma_MX_high = df4.loc[condition_sigma_MX_high,'Scenario'].drop_duplicates().tolist()
mapping_sigma_MX_high = dict.fromkeys(sample_sigma_MX_high, "export_elasticity_high")

dict_update = {**mapping_reference, **mapping_mu_low, **mapping_population_low, \
               **mapping_import_enersect_low, **mapping_saving_low, **mapping_trade_drive_low,
               **mapping_mu_high, **mapping_population_high, \
               **mapping_import_enersect_high, **mapping_saving_high, **mapping_trade_drive_high,**mapping_sigma_MX_low, **mapping_sigma_MX_high, **mapping_sigma_omegaU_high }

mapping_level = {"productivity_low" : "low",
                 "productivity_high" : "high",
                 "population_low" : "low", 
                 "population_high" : "high",
                 "energy_price_low" : "low", 
                 "energy_price_high" : "high",
                 "households_saving_low" : "low",
                 "households_saving_high" : "high",
                 "exports_low" : "low",
                 "exports_high" : "high"}

mapping_type = {"productivity_low" : "productivity",
                "productivity_high" : "productivity",
                 "population_low" : "population", 
                 "population_high" : "population",
                 "energy_price_low" : "energy_price", 
                 "energy_price_high" : "energy_price",
                 "households_saving_low" : "households_saving",
                 "households_saving_high" : "households_saving",
                 "exports_low" : "exports",
                 "exports_high" : "exports"}

df4['variante'] = df4['Scenario'].map(dict_update,na_action='ignore')
df4['variante'].fillna("other", inplace=True)

######################## Scenario type ###############################


sample_gdp = df4.loc[(df4['Scenario_type'] == "S2") & (df4['year'] == year) & df4["gdp_goal_ref"]== 1, 'Real_GDP_BY_ref'].tolist()
sample_energy = df4.loc[(df4['Scenario_type'] == "S2") & (df4['year'] == year) & df4["energy_goal_ref"]== 1, 'energy_ktoe_BY_ref'].tolist()
sample_energy_IC = df4.loc[(df4['Scenario_type'] == "S2") & (df4['year'] == year) & df4["IC_energy_without_energy_goal_ref"]== 1, 'IC_energy_ktoe_without_energy_BY_ref'].tolist()
sample_energy_C = df4.loc[(df4['Scenario_type'] == "S2") & (df4['year'] == year) & df4["C_energy_goal_ref"]== 1, 'C_energy_ktoe_BY_ref'].tolist()

try:
    deviation_gdp = deviation(sample_gdp)
    deviation_energy = deviation(sample_energy)
    deviation_energy_IC = deviation(sample_energy_IC)
    deviation_energy_C = deviation(sample_energy_C)
except ZeroDivisionError:
    pass


######################## Scenario type 2 for segment display ###############################
df4['Scenario_type_2'] = df4['Scenario_type'].map(mapping_scenarios_2,na_action='ignore')
df4['Scenario_type_3'] = df4['Scenario_type'].map(mapping_variantes,na_action='ignore')

################################# Colonnes pour ANOVA #########################################################

anova_df= DataFrame()

anova_df["ind_Mu"] = df4["VAR_Mu"]
anova_df["ind_population"] = df4["VAR_population"]
anova_df["ind_import_enersect"] = df4["VAR_import_enersect"]
anova_df["ind_trade_drive"] = df4["trade_drive"]

anova_df["ind_saving"] = df4["VAR_saving"]
anova_df["ind_sigma_MX"] = df4["VAR_sigma_MX"]
anova_df["ind_sigma_omegaU"] = df4["VAR_sigma_omegaU"]

anova_df["IEeur1"] = df4["Real_GDP"]
anova_df["IEeur2"] = df4["energy_ktoe"]
anova_df["IEeur3"] = df4["unemployment_2"]
anova_df["IEeur4"] = df4["Rexp"]
anova_df["IEeur5"] = df4["Real_GDP_Paasche_hab"]
anova_df["IEeur6"] = df4["Labour_ratio_2"]
anova_df["IEeur7"] = df4["energy_ktoe_hab"]

anova_df["year"] = df4["year"]
anova_df["Scenario_type_2"] = df4["Scenario_type_2"]
anova_df["Scenario"] = df4["Scenario"]
anova_df["energy_ktoe_BY_ref"] = df4["energy_ktoe_BY_ref"]
anova_df["Real_GDP_hab_BY_ref"] = df4["Real_GDP_hab_BY_ref"]
anova_df["Labour_ratio_2_BY_ref"] = df4["Labour_ratio_2_BY_ref"]

anova_df["Real_GDP_hab_BY"] = df4["Real_GDP_hab_BY"]
anova_df["Labour_ratio_2"] = df4["Labour_ratio_2"]

# anova_df.set_index('ind_Mu',inplace=True)

########## Contexte ####################################################

anova_df["ind_Mu"] = np.where(anova_df["ind_Mu"] =="low", 0, anova_df["ind_Mu"])
anova_df["ind_Mu"] = np.where(anova_df["ind_Mu"] =="ref", 1, anova_df["ind_Mu"])
anova_df["ind_Mu"] = np.where(anova_df["ind_Mu"] =="high", 2, anova_df["ind_Mu"])

anova_df["ind_population"] = np.where(anova_df["ind_population"] =="low", 0, anova_df["ind_population"])
anova_df["ind_population"] = np.where(anova_df["ind_population"] =="ref", 1, anova_df["ind_population"])
anova_df["ind_population"] = np.where(anova_df["ind_population"] =="high", 2, anova_df["ind_population"])

anova_df["ind_import_enersect"] = np.where(anova_df["ind_import_enersect"] =="low", 0, anova_df["ind_import_enersect"])
anova_df["ind_import_enersect"] = np.where(anova_df["ind_import_enersect"] =="ref", 1, anova_df["ind_import_enersect"])
anova_df["ind_import_enersect"] = np.where(anova_df["ind_import_enersect"] =="high", 2, anova_df["ind_import_enersect"])

anova_df["ind_trade_drive"] = np.where(anova_df["ind_trade_drive"] =="exports_detailed_low", 0, anova_df["ind_trade_drive"])
anova_df["ind_trade_drive"] = np.where(anova_df["ind_trade_drive"] =="exports_detailed", 1, anova_df["ind_trade_drive"])
anova_df["ind_trade_drive"] = np.where(anova_df["ind_trade_drive"] =="exports_detailed_high", 2, anova_df["ind_trade_drive"])

########## Fct économie ################################################

anova_df["ind_sigma_omegaU"] = np.where(anova_df["ind_sigma_omegaU"] =="ref", 1, anova_df["ind_sigma_omegaU"])
anova_df["ind_sigma_omegaU"] = np.where(anova_df["ind_sigma_omegaU"] =="ademevalue", 2, anova_df["ind_sigma_omegaU"])

anova_df["ind_saving"] = np.where(anova_df["ind_saving"] =="low", 0, anova_df["ind_saving"])
anova_df["ind_saving"] = np.where(anova_df["ind_saving"] =="ref", 1, anova_df["ind_saving"])
anova_df["ind_saving"] = np.where(anova_df["ind_saving"] =="high", 2, anova_df["ind_saving"])
anova_df["ind_saving"] = np.where(anova_df["ind_saving"] =="neoclassical_macroclosure", 3, anova_df["ind_saving"])

anova_df["ind_sigma_MX"] = np.where(anova_df["ind_sigma_MX"] =="ref", 1, anova_df["ind_sigma_MX"])
anova_df["ind_sigma_MX"] = np.where(anova_df["ind_sigma_MX"] =="low", 0, anova_df["ind_sigma_MX"])

anova_filter_year_0 = anova_df[anova_df["year"] > 2018]

anova_filter_year = anova_filter_year_0[anova_filter_year_0["ind_sigma_omegaU"] == 2]

anova_filter_year.to_csv("/Users/rdo2/Dropbox/PC/Documents/anova/anova_df"+"_"+"energy"+ current_date_and_time_string+".csv", sep=";")


print(anova_df)

######################## Columns for segments ###############################
df4['combination_Mu'] = df4['VAR_population'] + df4['VAR_saving'] + df4['VAR_import_enersect'] + df4['VAR_sigma_MX'] + df4['VAR_sigma_omegaU'] + df4['trade_drive']
df4['combination_population'] = df4['VAR_Mu'] + df4['VAR_saving'] + df4['VAR_import_enersect'] + df4['VAR_sigma_MX'] + df4['VAR_sigma_omegaU'] + df4['trade_drive']
df4['combination_saving'] = df4['VAR_population'] + df4['VAR_Mu'] + df4['VAR_import_enersect'] + df4['VAR_sigma_MX'] + df4['VAR_sigma_omegaU'] + df4['trade_drive']
df4['combination_import_enersect'] = df4['VAR_population'] + df4['VAR_saving'] + df4['VAR_Mu'] + df4['VAR_sigma_MX'] + df4['VAR_sigma_omegaU'] + df4['trade_drive']

for index, year in enumerate(years) :

################################# Scores et rstd ############################################################################################
    print("Scores for year ", year)
    print()
    print("Energy_scores C")
    C_energy_score_S2 = (df4.loc[(df4['Scenario_type'] == "S2") & (df4['year'] == year), 'C_energy_goal_ref'].sum() / (nb_scenarios_S2-1))*100
    C_energy_score_S3 = (df4.loc[(df4['Scenario_type'] == "S3") & (df4['year'] == year), 'C_energy_goal_ref'].sum() / (nb_scenarios_S3-1))*100
    print("S2", C_energy_score_S2.round(1), "%")
    print("S3", C_energy_score_S3.round(1), "%")
    print()
    print("Energy_scores IC without_energy")
    IC_energy_score_S2 = (df4.loc[(df4['Scenario_type'] == "S2") & (df4['year'] == year), 'IC_energy_without_energy_goal_ref'].sum() / (nb_scenarios_S2-1))*100
    IC_energy_score_S3 = (df4.loc[(df4['Scenario_type'] == "S3") & (df4['year'] == year), 'IC_energy_without_energy_goal_ref'].sum() / (nb_scenarios_S3-1))*100
    print("S2", IC_energy_score_S2.round(1), "%")
    print("S3", IC_energy_score_S3.round(1), "%")
    print()
    print("Energy_scores total")
    energy_score_S2 = (df4.loc[(df4['Scenario_type'] == "S2") & (df4['year'] == year), 'energy_goal_ref'].sum() / len(dfS2))*100
    energy_score_S3 = (df4.loc[(df4['Scenario_type'] == "S3") & (df4['year'] == year), 'energy_goal_ref'].sum() / len(dfS3))*100
    print("S2", energy_score_S2.round(1), "%")
    print("S3", energy_score_S3.round(1), "%")
    print()

    print("Unemployment_scores")
    unemployment_score_S2 = (df4.loc[(df4['Scenario_type'] == "S2") & (df4['year'] == year), 'unemployment_target_ref'].sum() / (nb_scenarios_S2-1))*100
    unemployment_score_S3 = (df4.loc[(df4['Scenario_type'] == "S3") & (df4['year'] == year), 'unemployment_target_ref'].sum() / (nb_scenarios_S3-1))*100
    print("S2", unemployment_score_S2.round(1), "%")
    print("S3", unemployment_score_S3.round(1), "%")
    print()

    print("GDP_scores")
    gdp_score_S2 = (df4.loc[(df4['Scenario_type'] == "S2") & (df4['year'] == year), 'gdp_goal_ref'].sum() / (nb_scenarios_S2-1))*100
    gdp_score_S3 = (df4.loc[(df4['Scenario_type'] == "S3") & (df4['year'] == year), 'gdp_goal_ref'].sum() / (nb_scenarios_S3-1))*100
    print("S2", gdp_score_S2.round(1), "%")
    print("S3", gdp_score_S3.round(1), "%")
    print()

    print("e_h_consumption_score")
    e_h_consumption_score_S2 = (df4.loc[(df4['Scenario_type'] == "S2") & (df4['year'] == year), 'e_h_consumption_goal_ref'].sum() / (nb_scenarios_S2-1))*100
    e_h_consumption_score_S3 = (df4.loc[(df4['Scenario_type'] == "S3") & (df4['year'] == year), 'e_h_consumption_goal_ref'].sum() / (nb_scenarios_S3-1))*100
    print("S2", e_h_consumption_score_S2.round(1), "%")
    print("S3", e_h_consumption_score_S3.round(1), "%")
    print()

#    print(df4["VAR_sigma_omegaU"].unique())
#    exit()

    print("all_goals_ref_score")
    all_goals_ref_score_S2 = (df4.loc[(df4['Scenario_type'] == "S2") & (df4['year'] == year), 'all_goals_ref'].sum() / len(dfS2))*100
    all_goals_ref_score_S3 = (df4.loc[(df4['Scenario_type'] == "S3") & (df4['year'] == year), 'all_goals_ref'].sum() / len(dfS3))*100
    print("S2", all_goals_ref_score_S2.round(1), "%")
    print("S3", all_goals_ref_score_S3.round(1), "%")
    print()

    C_energy_rstd_S2 = df4.loc[(df4['Scenario_type'] == "S2") & (df4['year'] == year), 'C_energy_ktoe_rstd'].mean()
    C_energy_rstd_S3 = df4.loc[(df4['Scenario_type'] == "S3") & (df4['year'] == year), 'C_energy_ktoe_rstd'].mean()

    IC_energy_rstd_S2 = df4.loc[(df4['Scenario_type'] == "S2") & (df4['year'] == year), 'IC_energy_ktoe_without_energy_rstd'].mean()
    IC_energy_rstd_S3 = df4.loc[(df4['Scenario_type'] == "S3") & (df4['year'] == year), 'IC_energy_ktoe_without_energy_rstd'].mean()

    energy_rstd_S2 = df4.loc[(df4['Scenario_type'] == "S2") & (df4['year'] == year), 'energy_ktoe_rstd'].mean()
    energy_rstd_S3 = df4.loc[(df4['Scenario_type'] == "S3") & (df4['year'] == year), 'energy_ktoe_rstd'].mean()

    energy_hab_rstd_S2 = df4.loc[(df4['Scenario_type'] == "S2") & (df4['year'] == year), 'energy_ktoe_hab_rstd'].mean()
    energy_hab_rstd_S3 = df4.loc[(df4['Scenario_type'] == "S3") & (df4['year'] == year), 'energy_ktoe_hab_rstd'].mean()

    unemployment_rstd_S2 = df4.loc[(df4['Scenario_type'] == "S2") & (df4['year'] == year), 'unemployment_rstd'].mean()
    unemployment_rstd_S3 = df4.loc[(df4['Scenario_type'] == "S3") & (df4['year'] == year), 'unemployment_rstd'].mean()

#    Labour_ratio_rstd_S2 = df4.loc[(df4['Scenario_type'] == "S2") & (df4['year'] == year), 'Labour_ratio_rstd'].mean()
#    Labour_ratio_rstd_S3 = df4.loc[(df4['Scenario_type'] == "S3") & (df4['year'] == year), 'Labour_ratio_rstd'].mean()

    real_gdp_rstd_S2 = df4.loc[(df4['Scenario_type'] == "S2") & (df4['year'] == year), 'Real_GDP_rstd'].mean()
    real_gdp_rstd_S3 = df4.loc[(df4['Scenario_type'] == "S3") & (df4['year'] == year), 'Real_GDP_rstd'].mean()

    PIB_hab_rstd_S2 = df4.loc[(df4['Scenario_type'] == "S2") & (df4['year'] == year), 'PIB_hab_rstd'].mean()
    PIB_hab_rstd_S3 = df4.loc[(df4['Scenario_type'] == "S3") & (df4['year'] == year), 'PIB_hab_rstd'].mean()

    objectives = ['C_energy_rstd','IC_energy_without_energy_rstd','Energy_rstd','energy_ktoe_hab_rstd','Unemployment_rstd','Labour_ratio_rstd','GDP_rstd','PIB_hab_rstd','C_energy','IC_energy_without_energy','Energy','Unemployment','GDP','e_h_consumption','all_goals_ref']

    df_results = pd.DataFrame(columns=objectives, index=['S2','S3'])
    df_results.loc['S2'] = pd.Series({'C_energy':C_energy_score_S2.round(1),
                                      'IC_energy_without_energy':IC_energy_score_S2.round(1),
                                      'Energy':energy_score_S2.round(1), 
                                      'Unemployment':unemployment_score_S2.round(1), 
                                      'GDP':gdp_score_S2.round(1), 
                                      'e_h_consumption':e_h_consumption_score_S2.round(1),
                                      'C_energy_rstd':C_energy_rstd_S2,
                                      'IC_energy_without_energy_rstd':IC_energy_rstd_S2,
                                      'Energy_rstd':energy_rstd_S2, 
                                      'energy_ktoe_hab_rstd' : energy_hab_rstd_S2,
                                      'Unemployment_rstd':unemployment_rstd_S2,
                                      'GDP_rstd':real_gdp_rstd_S2,
                                      'PIB_hab_rstd':PIB_hab_rstd_S2,  
                                      'all_goals_ref':all_goals_ref_score_S2})
    
    
    df_results.loc['S3'] = pd.Series({'C_energy':C_energy_score_S3.round(1),
                                      'IC_energy_without_energy':IC_energy_score_S3.round(1),
                                      'Energy':energy_score_S3.round(1), 
                                      'Unemployment':unemployment_score_S3.round(1), 
                                      'GDP':gdp_score_S3.round(1), 
                                      'e_h_consumption':e_h_consumption_score_S3.round(1), 
                                      'C_energy_rstd':C_energy_rstd_S3,
                                      'IC_energy_without_energy_rstd':IC_energy_rstd_S3,
                                      'Energy_rstd':energy_rstd_S3,
                                      'energy_ktoe_hab_rstd' : energy_hab_rstd_S3, 
                                      'Unemployment_rstd':unemployment_rstd_S3, 
                                      'GDP_rstd':real_gdp_rstd_S3, 
                                      'PIB_hab_rstd':PIB_hab_rstd_S3,  
                                      'all_goals_ref':all_goals_ref_score_S3})

#    df_results.to_csv("/Users/rdo2/Dropbox/PC/Documents/posttraitement/goal_scores_"+str(year)+"_"+ current_date_and_time_string+".csv", sep=";")

#    print(df_results)

    df_list = df_results.values.tolist()

#    print(df_list)

    for index, scenario in enumerate(score_scenarios) :

        df_results_2 = pd.DataFrame(columns=['Objective','Score','Scenario','Year','Type'])

        df_results_2['Objective'] = objectives
        df_results_2['Scenario'] = scenario
        df_results_2['Year'] = year
        df_results_2['Type'] = df_results_2['Objective'].map(mapping_score_type,na_action='ignore')
        df_results_2['Score'] = df_list[index]

        results_score.append(df_results_2)

tcd_scores=pd.concat(results_score)

tcd_scores_clean = tcd_scores[tcd_scores['Year'] > 2018]

tcd_scores_clean.to_csv("/Users/rdo2/Dropbox/PC/Documents/posttraitement/goal_scores_"+"_"+ current_date_and_time_string+".csv", sep=";")

df4.set_index('Scenario',inplace=True)

df4.drop('---Intensity and rate---', axis=1, inplace=True)
df4.drop('---Macro Incertitudes ---', axis=1, inplace=True)
df4.drop('---Nominal values at Millions of euro---', axis=1, inplace=True)
df4.drop('---Pseudo Quantities For Non-Energy ---', axis=1, inplace=True)
df4.drop('---Quantities ---', axis=1, inplace=True)
df4.drop('---Quantities Index Fisher ---', axis=1, inplace=True)
df4.drop('---Quantities Index Laspeyres ---', axis=1, inplace=True)
df4.drop('---Real terms at Millions of euro BY---', axis=1, inplace=True)
df4.drop('---Prices Index ratio/BY---', axis=1, inplace=True)

################################# Table pour R #########################################################

df4.to_csv("/Users/rdo2/Dropbox/PC/Documents/posttraitement/df4_" + current_date_and_time_string +".csv" ,sep=";")

################################# Graphes avec flèches #########################################################

mydatakeep = df4[['Scenario_type_2','variante','year','energy_ktoe_BY','Real_GDP_BY','Real_GDP_hab_BY','unemployment','Emissions - MtCO2']]

mydatakeep = mydatakeep[mydatakeep['variante'] != 'other']

mydatakeep = mydatakeep[mydatakeep['year'] != 2018]

# mydatakeep['level'] = mydatakeep['variante'].map(mapping_level,na_action='ignore')
# mydatakeep['type'] = mydatakeep['variante'].map(mapping_type,na_action='ignore')

# mydatakeep=pd.pivot(mydatakeep, index=['Scenario_type_2','level','year'], columns = 'type',values = 'Emissions - MtCO2') 

mydatakeep.to_csv("/Users/rdo2/Dropbox/PC/Documents/posttraitement/mydatakeep_" + current_date_and_time_string +".csv" ,sep=";")



################################# Graphe superposition nuages de points #########################################################
superpose_results= []

parameters= ['VAR_Mu', 'VAR_population', 'trade_drive', 'VAR_import_enersect', 'VAR_saving']

mydatasuperpose = df4[['Scenario_type_2','variante','year','energy_ktoe','energy_ktoe_BY','Real_GDP','Real_GDP_BY','unemployment','VAR_Mu','VAR_population','trade_drive','VAR_saving','VAR_import_enersect','Labour ThousandFTE','energy_ktoe_hab_BY','Real_GDP_hab_BY','energy_ktoe_hab_BY']]

mydatasuperpose.rename(columns={"Labour ThousandFTE": "Labour_ThousandFTE"},inplace=True)

mydatasuperpose= mydatasuperpose[mydatasuperpose['year'] != 2018]

mydatasuperpose2 = mydatasuperpose.astype({'Labour_ThousandFTE': 'float64','energy_ktoe': 'float64'})

for index, param in enumerate(parameters) :
    
    mydatasuperpose3 = mydatasuperpose2.groupby(['Scenario_type_2', 'year', param ]).mean()

    mydatasuperpose3["parameter"] = param

    superpose_results.append(mydatasuperpose3)

superpose_df = pd.concat(superpose_results)

superpose_df.rename(columns={"VAR_Mu": "level"},inplace=True)

superpose_df.to_csv("/Users/rdo2/Dropbox/PC/Documents/posttraitement/mydatasuperpose_" + current_date_and_time_string +".csv" ,sep=";")

exit()


################################# Comparaison au TEND - bouclages #########################################################

tend_stats = df4[(df4['Scenario_type_2'] == 'TEND')]
S2_stats = df4[(df4['Scenario_type_2'] == 'S2')]
S3_stats = df4[(df4['Scenario_type_2'] == 'S3')]

tend_stats= tend_stats.reset_index(level=0)
S2_stats= S2_stats.reset_index(level=0)
S3_stats= S3_stats.reset_index(level=0)

tend_stats = tend_stats[["Scenario","year","VAR_saving","Real_GDP","Household_saving_rate","Real_Trade_Balance", "Real C"]]

S2_stats = S2_stats[["Scenario","year","VAR_saving","Real_GDP","Household_saving_rate","Real_Trade_Balance", "Real C"]]
S2_stats.rename(columns = {'Scenario':'Scenario_S2','Real_GDP':'Real_GDP_S2'}, inplace = True)

S3_stats = S3_stats[["Scenario","year","VAR_saving","Real_GDP","Household_saving_rate","Real_Trade_Balance", "Real C"]]
S3_stats.rename(columns = {'Scenario':'Scenario_S3','Real_GDP':'Real_GDP_S3'}, inplace = True)

test1 = tend_stats.merge(S2_stats , on=['year', 'VAR_saving'])
test2 = test1.merge(S3_stats , on=['year', 'VAR_saving'])

test2 = test2[test2['year'] != 2018]


test2["ecart_GDP_S2"] = (test2["Real_GDP_S2"].astype(float) / test2["Real_GDP"].astype(float) - 1)*100
test2["ecart_GDP_S3"] = (test2["Real_GDP_S3"].astype(float) / test2["Real_GDP"].astype(float) - 1)*100

#test2["ecart_u_S2"] = test2["unemployment_S2"].astype(float) - test2["unemployment"].astype(float)
#test2["ecart_u_S3"] = test2["unemployment_S3"].astype(float) - test2["unemployment"].astype(float)

#test2["ecart_e_S2"] = test2["energy_ktoe_S2"].astype(float) - test2["energy_ktoe_BY"].astype(float) 
#test2["ecart_e_S3"] = test2["energy_ktoe_S3"].astype(float) - test2["energy_ktoe_BY"].astype(float)

test2.to_csv("/Users/rdo2/Dropbox/PC/Documents/posttraitement/ecart_TEND_bouclages" + current_date_and_time_string +".csv" ,sep=";")

################################# Graphes nuage de points #########################################################

scatterplot = df4[['Scenario_type_3','year','energy_ktoe_BY','Real_GDP_BY', 'unemployment']]

scatterplot = scatterplot[scatterplot['year'] != 2018]

scatterplot.to_csv("/Users/rdo2/Dropbox/PC/Documents/posttraitement/scatterplot_" + current_date_and_time_string +".csv" ,sep=";")

# ################################# Comparaison au TEND #########################################################

# df4['concat'] = df4['trade_drive'] + df4['VAR_Mu'] + df4['VAR_import_enersect'] + df4['VAR_population'] + df4['VAR_saving']



# print(df4)
# print()

# tend_stats = df4[(df4['Scenario_type_2'] == 'TEND')]
# S2_stats = df4[(df4['Scenario_type_2'] == 'S2')]
# S3_stats = df4[(df4['Scenario_type_2'] == 'S3')]

# print(tend_stats)
# print()

# tend_stats= tend_stats.reset_index(level=0)
# S2_stats= S2_stats.reset_index(level=0)
# S3_stats= S3_stats.reset_index(level=0)


# tend_stats = tend_stats[["Scenario","year","concat","Real_GDP","unemployment","energy_ktoe_BY"]]

# S2_stats = S2_stats[["Scenario","year","concat","Real_GDP","unemployment","energy_ktoe_BY"]]
# S2_stats.rename(columns = {'Scenario':'Scenario_S2','Real_GDP':'Real_GDP_S2', 'unemployment':'unemployment_S2', "energy_ktoe_BY": 'energy_ktoe_S2'}, inplace = True)

# S3_stats = S3_stats[["Scenario","year","concat","Real_GDP","unemployment","energy_ktoe_BY","trade_drive","VAR_Mu","VAR_population","VAR_saving","VAR_import_enersect"]]
# S3_stats.rename(columns = {'Scenario':'Scenario_S3','Real_GDP':'Real_GDP_S3', 'unemployment':'unemployment_S3', 'energy_ktoe_BY': 'energy_ktoe_S3'}, inplace = True)

# test1 = tend_stats.merge(S2_stats , on=['year', 'concat'])
# test2 = test1.merge(S3_stats , on=['year', 'concat'])

# test2 = test2[test2['year'] != 2018]

# print(test2)

# test2["ecart_GDP_S2"] = (test2["Real_GDP_S2"].astype(float) / test2["Real_GDP"].astype(float) - 1)*100
# test2["ecart_GDP_S3"] = (test2["Real_GDP_S3"].astype(float) / test2["Real_GDP"].astype(float) - 1)*100

# test2["ecart_u_S2"] = test2["unemployment_S2"].astype(float) - test2["unemployment"].astype(float)
# test2["ecart_u_S3"] = test2["unemployment_S3"].astype(float) - test2["unemployment"].astype(float)

# test2["ecart_e_S2"] = test2["energy_ktoe_S2"].astype(float) - test2["energy_ktoe_BY"].astype(float) 
# test2["ecart_e_S3"] = test2["energy_ktoe_S3"].astype(float) - test2["energy_ktoe_BY"].astype(float)

# test2.to_csv("/Users/rdo2/Dropbox/PC/Documents/posttraitement/ecart_TEND_" + current_date_and_time_string +".csv" ,sep=";")




