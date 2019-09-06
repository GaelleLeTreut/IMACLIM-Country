# -*- coding: utf-8 -*-

import os
import read_outputs as ro
import csv

# TODO : def une fonction time_name et fold_name à personnaliser pour les cases du tableau
# TODO : repérer les folders par des *indices* uniques et pas par leurs noms
# TODO : une unique ligne en en-tête du tableau, à construire par l'utilisateur
# TODO : ajouter une ligne légende dans l'en-tête

def output_table(file_name, lines_to_remove, save_path):

    # Load data of file_name
    outputs = ro.read_output_file(file_name)

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
            table[0].append(out_fold)
            table[1].append(time)

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
            
            

def data_macro_abs():

    macro_csv_name = 'TableMacro_Abs'
    
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

if __name__ == '__main__':
    working_file, lines_to_remove, save_path = data_macro()
    output_table(working_file, lines_to_remove, save_path)
#
    working_file2, lines_to_remove2, save_path2 = data_macro_ratio()
    output_table(working_file2, lines_to_remove2, save_path2)
    
    working_file3, lines_to_remove3, save_path3 = data_macro_abs()
    output_table(working_file3, lines_to_remove3, save_path3)
    
#    working_file2, lines_to_remove2, save_path2 = data_macro_2015()
#    output_table(working_file2, lines_to_remove2, save_path2)
