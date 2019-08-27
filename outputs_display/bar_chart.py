# -*- coding: utf-8 -*-

import read_outputs as ro
import matplotlib.pyplot as plt
import numpy as np
import os 

def build_charts(file_name, lines_to_draw, save_path):

    # Load data of files to read
    outputs = ro.read_output_file(file_name)

    # TODO : fonction car besoin dans radar_chart
    # Keep the selected lines
    for fold in outputs.keys():
        for time in outputs[fold].keys():
            file = []
            cpt = 0
            for line in outputs[fold][time]:
                kept_lines = [l for sublist in lines_to_draw \
                    for l in sublist]
                if line[0] in kept_lines:
                    file.append(line)
                else:
                    cpt += 1
            if not (cpt + len(file) == len(outputs[fold][time])):
                raise Exception('A line to draw is not consistent with \
                    files headers.')
            
            outputs[fold][time] = file

    # TODO : fonction car besoin dans radar_chart
    # Convert the lines into numbers
    for fold in outputs.keys():
        for time in outputs[fold].keys():
            try:
                file_str = outputs[fold][time]
                file_numbers = [[row[0], float(row[1])] for row in file_str]
                outputs[fold][time] = file_numbers
            except ValueError:
                raise Exception('Some elements are not numbers \
                    in the lines to draw selected.')
            
    # Enregistrer la liste des bar chart à créer
    first_col = ro.record_first_col(outputs, file_name)

    time_steps = ro.record_time_steps(outputs)
    #list(macros_val[d0].keys())

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
            for fold in outputs.keys():
                line = outputs[fold][time][i]
                cpt += 1
                x.append(cpt)
                height.append(line[1])
        fig = plt.figure()
        plt.bar(x, height, width, color='b')
        try:
            plt.savefig(save_path + bar_chart_name + '.png')
        except:
            print('ERROR with bar chart : ' + bar_chart_name)
        #plt.show()
        plt.close(fig)
        
def data_macro():

    macro_csv_name = 'TableMacroOutputExtended'

    lines_to_draw = [
        [
            'Real GDP (Laspeyres)', 
            'Households consumption in GDP', 
            'Public consumption in GDP'
        ],
        [
            'Exports in GDP',
            'Imports in GDP',
            'Imports/Domestic production ratio',
            'Imports of Non Energy goods in volume'
        ],
        [
            'Labour Intensity (Laspeyres)',
            'Labour tax rate (% points)'
        ]
    ]

    # Folder for results
    barchart_fold = 'MacroBarChart/'
    if not os.path.exists(barchart_fold):
        os.makedirs(barchart_fold)

    return macro_csv_name, lines_to_draw, barchart_fold

if __name__ == "__main__":
    work_file, lines_to_draw, save_path = data_macro()
    build_charts(work_file, lines_to_draw, save_path)
    