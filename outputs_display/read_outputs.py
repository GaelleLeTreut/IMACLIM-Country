# -*- coding: utf-8 -*-

import os
import csv

outputs_dir = '../outputs/'

def read_outputs_files(files_to_read):
    
    outputs = dict()
    recorded_csv = dict()
    
    # liste des dossiers dans outputs
    list_outputs = os.listdir(outputs_dir)
    # enregistrer le chemin complet des dossiers
    list_outputs = [outputs_dir + dir + '/' for dir in list_outputs]
    
    # enregistrer les fichiers de ces dossiers
    for dir in list_outputs:
        if not os.path.isdir(dir):
            print('Warning : ' + dir + ' is not a directory')   
        else:
            # Enregistrer le nom du dossier 
            name = ''
            if 'name.txt' in os.listdir(dir):
                fichier = open(dir + 'name.txt', 'r')
                name = fichier.read()
                name = name.strip()
                fichier.close() 
            else:
                raise Exception('No field name.txt found')
                
            # enregistrer le dossier
            outputs[name] = dict()
            recorded_csv[name] = dict()
                
            # Sous-dossier Time_
            for time in os.listdir(dir):
                if time[:5] == 'Time_':
                    
                    # Enregistrer le sous dossier Time_
                    outputs[name][time] = dict()
                    recorded_csv[name][time] = dict()
                    
                    # enregistrer le chemin d'accès
                    time_path = dir + time + '/'
                    outputs[name][time]['path'] = time_path
                    
                    # enregistrer le nom des fichiers recherchés
                    files_of_time = os.listdir(time_path)
                    
                    for file_name in files_to_read:
                        len_file_name = len(file_name)
                        file_found = False
                        for f in files_of_time:
                            if f[:len_file_name] == file_name:
                                if not f[-4:] == '.csv':
                                    raise Exception(file_name + 'is not a .csv \
                                                    file, if you want to read \
                                                    it, write a specific code')
                                else:
                                    recorded_csv[name][time][file_name] = f
                                    file_found = True
                        
                        if not file_found:
                            raise Exception(file_name + ' is not a prefix of \
                                            a file of ' + time_path)
                        
                    # enregistrer leur contenu
                    for file_name in recorded_csv[name][time].keys():
                        csv_file = recorded_csv[name][time][file_name]
                        csv_path = time_path + csv_file
                        with open(csv_path, 'r') as csvFile:
                            file = csv.reader(csvFile, delimiter = ';', \
                                              skipinitialspace=True)
                            rows = []
                            for r in file:
                                # supprimer les lignes vides
                                is_empty = True
                                for elt in r:
                                    if len(elt) != 0:
                                        is_empty = False
                                        break
                                if not is_empty:
                                    rows.append(r)
                            outputs[name][time][file_name] = rows
                        csvFile.close()
                            
            
    return outputs
