# -*- coding: utf-8 -*-

import os

# Paragraphe specifique a Jean Wolff
import sys
path = '/Users/rdo2/Dropbox/PC/Documents/GitHub/IMACLIM-Country/outputs_display'
sys.path.append(path)
os.chdir(path)

import read_outputs as ro
import csv

# TODO : def une fonction time_name et fold_name à personnaliser pour les cases du tableau
# TODO : repérer les folders par des *indices* uniques et pas par leurs noms
# TODO : une unique ligne en en-tête du tableau, à construire par l'utilisateur
# TODO : ajouter une ligne légende dans l'en-tête

def output_table(file_name, lines_to_remove, save_path):

    # Load data of file_name
    outputs, name_of = ro.read_output_file(file_name)

    # Remove lines
    for out_fold in outputs.keys():
        for time in outputs[out_fold].keys():
            file = []
            cpt = 0
            for row in outputs[out_fold][time]:
                if row[0] in lines_to_remove:
                    cpt += 1
                else:
                    file.append(row)
            outputs[out_fold][time] = file
            if cpt != len(lines_to_remove):
                raise Exception('Lines to remove not consistent with header.')

    # Record first column and check consistency
    first_col = ro.record_first_col(outputs, file_name)
        
    # Add 2 empty lines at the beginning, for the legend
    first_col = ['',''] + first_col
        
    # Fill the output table

    table = [[first_col[i]] for i in range(len(first_col))]

    for out_fold in outputs.keys():
        for time in outputs[out_fold].keys():
            file = outputs[out_fold][time]

            # Legend for the column
            table[0].append(name_of[out_fold])
            table[1].append(time[-4:])

            # Data of the column
            for i in range(len(file)):
                table[i+2].append(file[i][1])
            
    # Save the table
    with open(save_path, 'w', newline='') as csvfile:
        spamwriter = csv.writer(csvfile, delimiter=';')
        for row in table:
            spamwriter.writerow(row)

#def data_macro_2015():
#
#    macro_csv_name = 'TableMacroExtended_2015'
#
#    lines_to_remove = [
#        'Labour Tax cut',
#        'Global mean wage/Unemployment Elasticity'
#    ]
#    
#    # Path to record the created table
#    table_fold = 'MacroTables/'
#    if not os.path.exists(table_fold):
#        os.makedirs(table_fold)
#    table_name = 'macro_data_2015.csv'
#    table_path = table_fold + table_name
#
#    return macro_csv_name, lines_to_remove, table_path
def data_capital_cons():

    macro_csv_name = 'Capital_Cons_BY'
    
    lines_to_remove = [
    ]

    # Path to record the created table
    table_fold = 'MacroTables/'
    if not os.path.exists(table_fold):
        os.makedirs(table_fold)
    table_name = 'Capital_Cons.csv'
    table_path = table_fold + table_name

    return macro_csv_name, lines_to_remove, table_path
            
def data_equity():

    macro_csv_name = 'TableMacro_Equity_BY'
    
    lines_to_remove = [
    ]

    # Path to record the created table
    table_fold = 'MacroTables/'
    if not os.path.exists(table_fold):
        os.makedirs(table_fold)
    table_name = 'table_equity.csv'
    table_path = table_fold + table_name

    return macro_csv_name, lines_to_remove, table_path
            

def data_macro_abs():

    macro_csv_name = 'TableMacro_Abs_BY'
    
    lines_to_remove = [
    ]

    # Path to record the created table
    table_fold = 'MacroTables/'
    if not os.path.exists(table_fold):
        os.makedirs(table_fold)
    table_name = 'macro_data_abs.csv'
    table_path = table_fold + table_name

    return macro_csv_name, lines_to_remove, table_path

def data_macro_ratio():

    macro_csv_name = 'TableMacroRatioBY'
    
    lines_to_remove = [
    ]

    # Path to record the created table
    table_fold = 'MacroTables/'
    if not os.path.exists(table_fold):
        os.makedirs(table_fold)
    table_name = 'macro_data_ratio.csv'
    table_path = table_fold + table_name

    return macro_csv_name, lines_to_remove, table_path


def data_macro():

    macro_csv_name = 'TableMacroExtended_BY'

    lines_to_remove = [
        'Labour Tax cut',
        'Global mean wage/Unemployment Elasticity'
    ]
    
    # Path to record the created table
    table_fold = 'MacroTables/'
    if not os.path.exists(table_fold):
        os.makedirs(table_fold)
    table_name = 'macro_data.csv'
    table_path = table_fold + table_name

    return macro_csv_name, lines_to_remove, table_path

def data_template():

    macro_csv_name = 'FullTemplate_BY_'
    
    lines_to_remove = [
    ]

    # Path to record the created table
    table_fold = 'MacroTables/'
    if not os.path.exists(table_fold):
        os.makedirs(table_fold)
    table_name = 'FullTemplate_BY_byStep.csv'
    table_path = table_fold + table_name

    return macro_csv_name, lines_to_remove, table_path

if __name__ == '__main__':
    working_file, lines_to_remove, save_path = data_macro()
    output_table(working_file, lines_to_remove, save_path)
#
    working_file2, lines_to_remove2, save_path2 = data_macro_ratio()
    output_table(working_file2, lines_to_remove2, save_path2)

    working_file3, lines_to_remove3, save_path3 = data_macro_abs()
    output_table(working_file3, lines_to_remove3, save_path3)

    working_file4, lines_to_remove4, save_path4 = data_template()
    output_table(working_file4, lines_to_remove4, save_path4) 
    
    working_file5, lines_to_remove5, save_path5 = data_equity()
    output_table(working_file5, lines_to_remove5, save_path5) 
    
    working_file6, lines_to_remove6, save_path6 = data_capital_cons()
    output_table(working_file6, lines_to_remove6, save_path6) 
    
#    working_file2, lines_to_remove2, save_path2 = data_macro_2015()
#    output_table(working_file2, lines_to_remove2, save_path2)


# ON EXTRAIT LES QUELQUES VALEURS QUI NOUS INTERESSENT DU FULL TEMPLATE
import pandas as pd
df = pd.read_csv(save_path4, sep=';')

# On renomme les colonnes et on met les années dans le bon ordre
# SI AME
#df = df.rename(columns={'Unnamed: 0': 'variables', 'AME':'2030', 'AME.1':'2040', 'AME.2':'2050', 'AME.3':'2018'})
# SI AMS
#df = df.rename(columns={'Unnamed: 0': 'variables', 'AMS':'2030', 'AMS.1':'2040', 'AMS.2':'2050', 'AMS.3':'2018'})
# SI AUCUN SCENARIO
df = df.rename(columns={'Unnamed: 0': 'variables', 'NoScen':'2030', 'NoScen.1':'2040', 'NoScen.2':'2050', 'NoScen.3':'2018'})


df = df[['variables', '2018', '2030', '2040', '2050']]

var = ['Nominal GDP', 'Real GDP', 'Real C', 'Real G', 'Real I', 'Real X', 'Real M', 'Real Y', 'Labour ThousandFTE', 'Unemployment % points/BY']

df = df[df['variables'].isin(var)]

#df['a'] = df['a'].str.replace(',', '.').astype(float)

for col in df.columns[1:]:
    df[col] = df[col].str.replace('.', ',')

save_path7 = 'MacroTables/donnees_pertinentes.csv'
df.to_csv(save_path7, sep=';', index=False)


