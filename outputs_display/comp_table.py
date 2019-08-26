# -*- coding: utf-8 -*-

import os
from read_outputs import read_outputs_files
import csv

# Nom fichier sortie
table_name = 'macro_data.csv'

# Créer dossier pour résultat
table_dir = 'MacroTables/'
if not os.path.exists(table_dir):
    os.makedirs(table_dir)

# Fichiers à lire
macro_csv = 'TableMacroOutputExtended'
files_to_read = [macro_csv]

# Récupérer ces fichiers dans les outputs
outputs = read_outputs_files(files_to_read)

# Supprimer la 1ère ligne
for d in outputs.keys():
    for time in outputs[d].keys():
        file = outputs[d][time][macro_csv]
        outputs[d][time][macro_csv] = file[1:]

# Enregistrer la 1ère colonne 
first_col = []
d0 = list(outputs.keys())[0]
time0 = list(outputs[d0].keys())[0]
for row in outputs[d0][time0][macro_csv]:
    first_col.append(row[0])
    
# Vérifier que c'est la même colonne pour tous
for d in outputs.keys():
    for time in outputs[d].keys():
        file = outputs[d][time][macro_csv]
        first_col_file = []
        for row in file:
            first_col_file.append(row[0])
        if first_col_file != first_col:
            raise Exception('Different first column in : ' + \
                            outputs[d][time]['path'] + macro_csv)
    
# Ajouter 2 premières lignes vides
first_col = ['',''] + first_col
    
# Remplir le tableau
table = [[first_col[i]] for i in range(len(first_col))]

for d in outputs.keys():
    for time in outputs[d].keys():
        file = outputs[d][time][macro_csv]
        table[0].append(d)
        table[1].append(time)
        for i in range(len(file)):
            table[i+2].append(file[i][1])
        
# Enregistrer le tableau
with open(table_dir + table_name, 'w', newline='') as csvfile:
    spamwriter = csv.writer(csvfile, delimiter=';')
    for row in table:
        spamwriter.writerow(row)