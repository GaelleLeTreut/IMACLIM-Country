# -*- coding: utf-8 -*-

from read_outputs import read_outputs_files
import matplotlib.pyplot as plt
import numpy as np
import os 

# Créer dossier pour résultat
barchart_dir = 'MacroBarChart/'
if not os.path.exists(barchart_dir):
    os.makedirs(barchart_dir)

# Fichiers à lire
macro_csv = 'TableMacroOutputExtended'
files_to_read = [macro_csv]

# Récupérer ces fichiers dans les outputs
outputs = read_outputs_files(files_to_read)

# Garder les lignes qui ont des chiffres
macros_val = dict()
for d in outputs.keys():
    macros_val[d] = dict()
    for time in outputs[d].keys():
        rows_val = []
        for row in outputs[d][time][macro_csv]:
            r_val = [row[0]]
            try:
                r_val.append(float(row[1]))
                rows_val.append(r_val)
            except ValueError:
                pass
                #print(row[0] + ' is not a value row')
        macros_val[d][time] = rows_val
        
# Enregistrer la liste des bar chart à créer
first_col = []
d0 = list(macros_val.keys())[0]
time0 = list(macros_val[d0].keys())[0]
for row in macros_val[d0][time0]:
    first_col.append(row[0])
    
# TODO : TESTER que les colonnes sont cohérentes entre elles

time_steps = ['Time_1', 'Time_2']

bar_chart_name = ''
x=[]
height=[]

# Créer les bar chart
for i in range(len(first_col)):
    bar_chart_name = first_col[i]
    cpt = 0
    x = []
    height = []
    width = 1.0
    for time in time_steps:
        for d in macros_val.keys():
            line = macros_val[d][time][i]
            cpt += 1
            x.append(cpt)
            height.append(line[1])
    fig = plt.figure()
    plt.bar(x, height, width, color='b')
    try:
        plt.savefig(barchart_dir + bar_chart_name + '.png')
    except:
        print('ERROR with bar chart : ' + bar_chart_name)
    #plt.show()
    plt.close(fig)
    
    
    