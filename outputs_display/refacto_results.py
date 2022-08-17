import pandas as pd 
import numpy as np
import datetime as dt

########## input data
df = pd.read_csv('/Users/rdo2/Dropbox/PC/Documents/GitHub/IMACLIM-Country/MacroTables/FullTemplate_BY_byStep.csv', sep =";", header=None)
# ademe = pd.read_excel("/Users/rdo2/Dropbox/PC/Documents/GitHub/IMACLIM-Country/MacroTables/ADEME.xlsx",skiprows=0,sheet_name="Feuil1")
########## end input data  

############## parameters
nb_scenarios = 36
years = [2030,2050]
mapping_scenarios = {"S2_1" : "S2ref", "S3_1" : "S3ref"}
scenarios_selection = [["S2","S2_1_2018","S2_1_2050"], ["S3","S3_1_2018","S3_1_2050"]]
position = 1
position_2 = 4
############## end parameters

############## initialization
current_date_and_time = dt.datetime.now().strftime("%d_%m_%Y_%H_%M_%S")
current_date_and_time_string = str(current_date_and_time)
results=[]
results_2=[]

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
            "Unemployment % points/BY": "unemployment",
            "IC - Energy ktoe": "IC_energy_ktoe",
            "C - Energy - ktoe": "C_energy_ktoe",
            "Energy in Households consumption": "e_h_consumption"}, inplace= True)

# ademe = ademe.pivot(index=['Scenario','year'], columns=['Variables'], values='values_')
# ademe['type'] = "REF ThreeME"


################################# Concaténation de colonnes #########################################################################

df_tcd_format["energy_ktoe"] = df_tcd_format["IC_energy_ktoe"].astype(float) + df_tcd_format["C_energy_ktoe"].astype(float)

df_tcd_format.reset_index(inplace=True)

df_tcd_format["Scenario_year"] = df_tcd_format["Scenario"].map(str) + "_" + df_tcd_format["year"].map(str) 

################################# Filtres S2/S3 ##################################################################################

for index, scenario in enumerate(scenarios_selection) : 

    df_tcd_format_temp = df_tcd_format.loc[df_tcd_format['Scenario'].str.contains(scenario[0])]

    df_tcd_format_temp['energy_ktoe_BY'] = df_tcd_format_temp['energy_ktoe'].astype(float) / float(df_tcd_format_temp.loc[df_tcd_format_temp['Scenario_year'] == scenario[1], 'energy_ktoe'])
    df_tcd_format_temp['Real_GDP_BY'] = df_tcd_format_temp['Real_GDP'].astype(float) / float(df_tcd_format_temp.loc[df_tcd_format_temp['Scenario_year'] == scenario[1], 'Real_GDP'])
    df_tcd_format_temp['C_energy_ktoe_BY'] = df_tcd_format_temp['C_energy_ktoe'].astype(float) / float(df_tcd_format_temp.loc[df_tcd_format_temp['Scenario_year'] == scenario[1], 'C_energy_ktoe'])
    df_tcd_format_temp['IC_energy_ktoe_BY'] = df_tcd_format_temp['IC_energy_ktoe'].astype(float) / float(df_tcd_format_temp.loc[df_tcd_format_temp['Scenario_year'] == scenario[1], 'IC_energy_ktoe'])
    df_tcd_format_temp['Real_C_BY'] = df_tcd_format_temp['Real_C'].astype(float) / float(df_tcd_format_temp.loc[df_tcd_format_temp['Scenario_year'] == scenario[1], 'Real_C'])
    df_tcd_format_temp['Real_G_BY'] = df_tcd_format_temp['Real_G'].astype(float) / float(df_tcd_format_temp.loc[df_tcd_format_temp['Scenario_year'] == scenario[1], 'Real_G'])
    df_tcd_format_temp['Real_I_BY'] = df_tcd_format_temp['Real_I'].astype(float) / float(df_tcd_format_temp.loc[df_tcd_format_temp['Scenario_year'] == scenario[1], 'Real_I'])
    df_tcd_format_temp['Real_X_BY'] = df_tcd_format_temp['Real_X'].astype(float) / float(df_tcd_format_temp.loc[df_tcd_format_temp['Scenario_year'] == scenario[1], 'Real_X'])
    df_tcd_format_temp['Real_M_BY'] = df_tcd_format_temp['Real_M'].astype(float) / float(df_tcd_format_temp.loc[df_tcd_format_temp['Scenario_year'] == scenario[1], 'Real_M'])
    df_tcd_format_temp['Real_Y_BY'] = df_tcd_format_temp['Real_Y'].astype(float) / float(df_tcd_format_temp.loc[df_tcd_format_temp['Scenario_year'] == scenario[1], 'Real_Y'])

    df_tcd_format_temp['Real_GDP_BY_ref'] = df_tcd_format_temp['Real_GDP'].astype(float) / float(df_tcd_format_temp.loc[df_tcd_format_temp['Scenario_year'] == scenario[2], 'Real_GDP'])
    df_tcd_format_temp['energy_ktoe_BY_ref'] = df_tcd_format_temp['energy_ktoe'].astype(float) / float(df_tcd_format_temp.loc[df_tcd_format_temp['Scenario_year'] == scenario[2], 'energy_ktoe'])
    df_tcd_format_temp['C_energy_ktoe_BY_ref'] = df_tcd_format_temp['C_energy_ktoe'].astype(float) / float(df_tcd_format_temp.loc[df_tcd_format_temp['Scenario_year'] == scenario[2], 'C_energy_ktoe'])
    df_tcd_format_temp['IC_energy_ktoe_BY_ref'] = df_tcd_format_temp['IC_energy_ktoe'].astype(float) / float(df_tcd_format_temp.loc[df_tcd_format_temp['Scenario_year'] == scenario[2], 'IC_energy_ktoe'])
    df_tcd_format_temp['unemployment_BY_ref'] = df_tcd_format_temp['unemployment'].astype(float) / float(df_tcd_format_temp.loc[df_tcd_format_temp['Scenario_year'] == scenario[2], 'unemployment'])

    results_2.append(df_tcd_format_temp)

df4 = pd.concat([results_2[0], results_2[1]])


################################# Scénarios qui atteignent les objectifs #########################################################

df4["energy_goal"] = np.where(df4["energy_ktoe_BY"].astype(float) <= 1.05, 1, 0)
df4["gdp_goal"] = np.where(df4["Real_GDP_BY"].astype(float) >= 0.95, 1, 0)
df4["unemployment_target"] = np.where(df4["unemployment"].astype(float) <= 0, 1, 0)
df4["all_goals"] = np.where( (df4["energy_ktoe_BY"].astype(float) <= 1.05) & (df4["unemployment"].astype(float) <= 0) & (df4["Real_GDP_BY"].astype(float) >= 0.95), 1, 0)


######################## Scenario type ###############################
df4['Scenario_type'] = df4['Scenario'].map(mapping_scenarios,na_action='ignore')
df4['Scenario_type'].fillna(df4['Scenario'], inplace=True)
test = df4['Scenario_type'].str.replace(r'\S3_\d+', 'S3', regex=True)
test2 = test.str.replace(r'\S2_\d+', 'S2', regex=True)
df4['Scenario_type'] = test2

for index, year in enumerate(years) :

################################# Scores ############################################################################################
    print("Scores for year ", year)
    print()
    print("Energy_scores")
    energy_score_S2 = (df4.loc[(df4['Scenario_type'] == "S2") & (df4['year'] == year), 'energy_goal'].sum() / (nb_scenarios-1))*100
    energy_score_S3 = (df4.loc[(df4['Scenario_type'] == "S3") & (df4['year'] == year), 'energy_goal'].sum() / (nb_scenarios-1))*100
    print("S2", energy_score_S2.round(1), "%")
    print("S3", energy_score_S3.round(1), "%")
    print()

    print("Unemployment_scores")
    unemployment_score_S2 = (df4.loc[(df4['Scenario_type'] == "S2") & (df4['year'] == year), 'unemployment_target'].sum() / (nb_scenarios-1))*100
    unemployment_score_S3 = (df4.loc[(df4['Scenario_type'] == "S3") & (df4['year'] == year), 'unemployment_target'].sum() / (nb_scenarios-1))*100
    print("S2", unemployment_score_S2.round(1), "%")
    print("S3", unemployment_score_S3.round(1), "%")
    print()

    print("GDP_scores")
    gdp_score_S2 = (df4.loc[(df4['Scenario_type'] == "S2") & (df4['year'] == year), 'gdp_goal'].sum() / (nb_scenarios-1))*100
    gdp_score_S3 = (df4.loc[(df4['Scenario_type'] == "S3") & (df4['year'] == year), 'gdp_goal'].sum() / (nb_scenarios-1))*100
    print("S2", gdp_score_S2.round(1), "%")
    print("S3", gdp_score_S3.round(1), "%")
    print()

    print("All_goals_score")
    all_goals_score_S2 = (df4.loc[(df4['Scenario_type'] == "S2") & (df4['year'] == year), 'all_goals'].sum() / (nb_scenarios-1))*100
    all_goals_score_S3 = (df4.loc[(df4['Scenario_type'] == "S3") & (df4['year'] == year), 'all_goals'].sum() / (nb_scenarios-1))*100
    print("S2", all_goals_score_S2.round(1), "%")
    print("S3", all_goals_score_S3.round(1), "%")
    print()

    df_results = pd.DataFrame(columns=['Energy','Unemployment','GDP','All_goals'], index=['S2','S3'])
    df_results.loc['S2'] = pd.Series({'Energy':energy_score_S2.round(1), 'Unemployment':unemployment_score_S2.round(1), 'GDP':gdp_score_S2.round(1), 'All_goals':all_goals_score_S2.round(1)})
    df_results.loc['S3'] = pd.Series({'Energy':energy_score_S3.round(1), 'Unemployment':unemployment_score_S3.round(1), 'GDP':gdp_score_S3.round(1), 'All_goals':all_goals_score_S3.round(1)})

    df_results.to_csv("/Users/rdo2/Dropbox/PC/Documents/posttraitement/goal_scores_"+str(year)+"_"+ current_date_and_time_string+".csv", sep=";")

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

df4.to_csv("/Users/rdo2/Dropbox/PC/Documents/posttraitement/df4_" + current_date_and_time_string +".csv" ,sep=";")

