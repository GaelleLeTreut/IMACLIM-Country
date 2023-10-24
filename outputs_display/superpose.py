import pandas as pd 
import numpy as np
import datetime as dt
from tools import *
from pandas import DataFrame

########## input data
df4 = pd.read_csv('/Users/rdo2/Dropbox/PC/Documents/posttraitement/df4_28_02_2023_10_20_06.csv', sep =";")
# ademe = pd.read_excel("/Users/rdo2/Dropbox/PC/Documents/GitHub/IMACLIM-Country/MacroTables/ADEME.xlsx",skiprows=0,sheet_name="Feuil1")
########## end input data  7

############## initialization
current_date_and_time = dt.datetime.now().strftime("%d_%m_%Y_%H_%M_%S")
current_date_and_time_string = str(current_date_and_time)

################################# Graphe superposition nuages de points #########################################################
superpose_results= []

parameters= ['VAR_Mu', 'VAR_population', 'trade_drive', 'VAR_import_enersect', 'VAR_saving']

mydatasuperpose = df4[['taux_emploi','energy_TWh','Scenario_type_2','variante','year','energy_ktoe','energy_ktoe_BY','Real_GDP','Real_GDP_BY','unemployment','VAR_Mu','VAR_population','trade_drive','VAR_saving','VAR_import_enersect','Labour ThousandFTE','energy_ktoe_hab_BY','Real_GDP_hab_BY','energy_ktoe_hab_BY','Labour_ratio']]

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

