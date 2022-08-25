# -*- coding: utf-8 -*-

# Module imports
import os
import sys
import re
import csv
import pandas as pd
from os import walk
import glob


# Initialisations
var = ['Nominal GDP', 'Real GDP', 'Real C', 'Real G', 'Real I', 'Real X', 'Real M', 'Real Y', 'Labour ThousandFTE', 'Unemployment % points/BY']

df_global = pd.DataFrame(columns=['simu', 'df_fulltemplate', 'df_donnees_pertinentes'])

i=0

# Set current directory
my_path = '/Users/jean/Documents/GitHub/IMACLIM-Country/outputs_display/To_Display'
os.chdir(my_path)

# Pour lister les sous-dossiers
os.walk(my_path) 
for folder_name in next(os.walk('.'))[1]:

    # Initialisation de df
    df = pd.DataFrame()
    
    #print('\n', 'niveau 1 : ', folder_name)
    
    simu_name = folder_name[26:]
    simu_name = re.search('(.*)_SystemOpt', simu_name).group(1)
    print('simu:', simu_name, '\n')
    
    # Set current directory
    os.chdir(folder_name)
    
    # Pour lister les sous-dossiers
    os.walk(folder_name)
    for folder_name2 in next(os.walk('.'))[1]:
        
        #print('niveau 2 : ', folder_name2)
        
        if 'Time_' in folder_name2:
            # Set current directory
            os.chdir(folder_name2)

            # Pour lister les fichiers csv du dossier
            for file_name in glob.glob("*.csv"):
                
                if 'FullTemplate' in file_name:
                    
                    #print('niveau 3 :', file_name)
                    
                    # On importe le fichier full_template.csv
                    full_template = pd.read_csv(file_name, sep=';')
                    
                    # La colonne Variables prend les variables
                    df['Variables'] = full_template[full_template.columns[0]]
                    
                    # Les colonnes Time_20XX prennent leurs valeurs.
                    df[folder_name2] = full_template[full_template.columns[1]]
            
            # On sort du dossier 'Time_20XX'
            os.chdir('..')

    # On renomme les colonnes
    df = df.rename(columns={'Time_2030':'2030', 'Time_2040':'2040', 'Time_2050':'2050', 'Time_2018':'2018'})

    # On met les années dans le bon ordre
    try:
        df = df[['Variables', '2018', '2030', '2040', '2050']]
    except:
        print('WARNING :', simu_name, 'n\'a probablement pas convergé.', '\n')
    
    # On remplace les . par des ,
    for col in df.columns[1:]:
        df[col] = df[col].astype(str).str.replace('.', ',')
    
    # On sélectionne les variables les plus intéressantes (pour les 'donnees_pertinentes')
    df2 = df[df['Variables'].isin(var)]
        
    # On met les données de la simulation dans la i-ème ligne de df_global
    df_global.loc[i] = [simu_name, df, df2]
    i = i+1
    
    # On sort du dossier type 'FRA2018_20220818_16h42m43_AME_PIB_monde...'
    os.chdir('..')

# On va dans le dossier où on écrira nos fichiers
my_path = '/Users/jean/Documents/GitHub/IMACLIM-Country/outputs_display/MacroTables'

# Set current directory
os.chdir(my_path)

# On parcourt les lignes de df_global
for i in range(len(df_global)):

    # Chaque df contient le full template + les données pertinentes d'une simu
    df = df_global.loc[i]
    
    # On enregistre le full_template.csv
    save_name1 = df.simu + ' - full_template.csv'
    full_template = df.df_fulltemplate
    full_template.to_csv(save_name1, sep=';', index=False)
    
    # On enregistre le donnees_pertinentes.csv
    save_name2 = df.simu + ' - donnees_pertinentes.csv'
    donnees_pertinentes = df.df_donnees_pertinentes
    donnees_pertinentes.to_csv(save_name2, sep=';', index=False)

