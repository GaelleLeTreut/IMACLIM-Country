# -*- coding: utf-8 -*-

import read_outputs as ro
import matplotlib.pyplot as plt
import os 
from math import sqrt, pi
from radar_class import radar_factory
import numpy as np

def red_name(line_name, size_max):
    name_red = ''
    cpt_char = 0
    for c in line_name:
        if cpt_char == size_max:
            name_red += '\n'
            cpt_char = 0
        name_red += c
        cpt_char += 1
    return name_red
    
def create_bar_charts(time_steps, values, gen_title, legend, nb_folds):

    # carré supérieur
    lines_to_draw = list(values.keys())
    nb_lines = int(sqrt(len(lines_to_draw))) + 1 
    # nombre de col qui complète le nombre de lignes
    nb_col = ((len(lines_to_draw)-1) // nb_lines +1)

    figsize=(nb_col*3,nb_lines*3)
    fig, axes = plt.subplots(nb_lines, nb_col, squeeze=False, figsize=figsize)

    for i, ax_row in enumerate(axes):
        for j, ax in enumerate(ax_row):

            if i*nb_col + j < len(lines_to_draw):
                list_rect = [[] for _ in range(nb_folds)]
                line = lines_to_draw[i*nb_col + j]
                
                for time in time_steps:
                    
                    val = values[line][time]
                    for k in range(nb_folds):
                        list_rect[k].append(val[k])
                        
                width = 0.8
                index = np.arange(1,len(time_steps)+1)

                pos = [index + k*width/nb_folds for k in range(nb_folds)]

                for k in range(nb_folds):
                     ax.bar(index + k*width/nb_folds, list_rect[k], width/nb_folds)   

                line_name_red = red_name(line,20)
                ax.set_title(line_name_red)

                lab = []
                if (nb_folds % 2 == 1):
                    lab = pos[nb_folds // 2]
                else:
                    lab = (pos[nb_folds // 2 - 1] + pos[nb_folds // 2]) / 2
                ax.set_xticks(lab)

                labels = [x[-4:] for x in time_steps]
                ax.set_xticklabels(labels, rotation=45)
                
            else:
                ax.axis('off')

    fig.suptitle(gen_title)
    fig.legend(legend, loc='lower center')

    plt.subplots_adjust(top=0.8, hspace=0.9, wspace=0.7, bottom=0.2)

    chart_path = save_path + gen_title + '.png'
    plt.savefig(chart_path)
    plt.close(fig)


def create_radar_charts(values, time_steps, title, colors, legend, nb_folds, ext=''):
    
    lines_to_draw = list(values.keys())
    
    sq = sqrt(len(time_steps))
    nb_lines = int(sq)
    # carré supérieur
    if int(sq) != sq:
        nb_lines += 1

    # nombre de col qui complète le nombre de lignes
    nb_col = ((len(time_steps)-1) // nb_lines +1)
    # Build the radar chart
    N = len(lines_to_draw)
    theta = radar_factory(N, frame='polygon')

    spoke_labels = [red_name(line,13) for line in lines_to_draw]

    fig, axes = plt.subplots(figsize=(10, 10), nrows=nb_lines, ncols=nb_col,
                            subplot_kw=dict(projection='radar'))

    if nb_lines == 1:
        axes = [axes]

    if nb_col == 1:
        axes = [[ax] for ax in axes]

    for i, ax_row in enumerate(axes):
        for j, ax in enumerate(ax_row):

            ax_ind = i*nb_col + j

            if i*nb_col + j < len(time_steps):

                ax.set_rgrids([0.2, 0.4, 0.6, 0.8])
                ax.set_title(time_steps[ax_ind][-4:], weight='bold', size='medium', position=(0.5, 1.25),
                            horizontalalignment='center', verticalalignment='center')
                
                val_data = dict()
                for time in time_steps:
                    val_data[time] = [[] for k in range(nb_folds)]

                for k in range(nb_folds):
                    for line in values.keys():
                        for time in time_steps:
                            val_data[time][k].append(values[line][time][k])

                    ax.plot(theta, val_data[time_steps[ax_ind]][k])
                    
                    ax.set_varlabels(spoke_labels)

                    for lbl, angle in zip(ax.get_xticklabels(), theta):
                        if angle in (0, pi):
                            lbl.set_horizontalalignment('center')
                        elif 0 < angle < pi:
                            lbl.set_horizontalalignment('right')
                        else:
                            lbl.set_horizontalalignment('left')

            else:
                ax.axis('off')

    fig.subplots_adjust(wspace=1.1, hspace=0.2, top=0.85, bottom=0.05)

    fig.suptitle(title)
    fig.legend(legend, loc='upper right')

    plt.savefig(save_path + 'radar_' + title + ext + '.png')

    plt.close(fig)

def build_charts(file_name, charts_to_draw, save_path, colors=['b', 'r', 'g', 'm', 'y'], type_chart='bar', norm_ref=None):

    # Load data of files to read
    outputs, name_of = ro.read_output_file(file_name)

    # lines kept
    lines_to_draw = []
    for chart in charts_to_draw.keys():
        lines_to_draw += charts_to_draw[chart]  

    # Keep the selected lines
    for fold in outputs.keys():
        for time in outputs[fold].keys():
            file = []
            cpt = 0
            for line_name in outputs[fold][time]:
                if line_name[0] in lines_to_draw:
                    file.append(line_name)
                else:
                    cpt += 1
            if not (cpt + len(file) == len(outputs[fold][time])):
                raise Exception('A line to draw is not consistent with \
                    files headers.')
            
            outputs[fold][time] = file

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

    # Read time steps and return an error if inconsistency
    time_steps = ro.record_time_steps(outputs)


    # Create charts
    
    for chart in charts_to_draw.keys():
        lines_to_draw = charts_to_draw[chart]

        # Load data
        values_chart = dict()

        for line_name in lines_to_draw:

            values_chart[line_name] = dict()

            for time in time_steps:

                values_chart[line_name][time] = []
                for fold in outputs.keys():
                    line = ro.get_line(outputs[fold][time], line_name)
                    val = line[1]

                    # Normalise if needed
                    if norm_ref is not None:
                        line_ref = ro.get_line(outputs[norm_ref][time], line_name)
                        val = val / line_ref[1]

                    values_chart[line_name][time].append(val)


        nb_folds = len(list(outputs.keys()))

        # Legend
        ids = list(outputs.keys())
        legend = [name_of[id] for id in ids]

        # BAR CHARTS

        if type_chart == 'bar':

            create_bar_charts(time_steps, values_chart, chart, legend, nb_folds)

        # RADAR CHARTS

        elif type_chart == 'radar':
            nb_max = 4
            ext = 1
            for i in range(0,len(time_steps),nb_max):
                deb = i
                end = min(len(time_steps), i+nb_max)
                time_steps_part = time_steps[deb:end]
                
                create_radar_charts(values_chart, time_steps_part, chart, colors, legend, nb_folds,ext='_'+str(ext))
                ext += 1
        else:
            raise Exception('type_chart unknown')

#def data_macro_2015():
#
#    macro_csv_name = 'TableMacroExtended_2015'
#
#    charts_to_draw = {
#        'Macro' :
#        [
#            'Real GDP (Laspeyres)', 
#            'Households consumption in GDP',
#            'Public consumption in GDP'
#        ],
#        'Chart Titre 2' :
#        [
#            'Imports in GDP',
#            'Imports/Domestic production ratio',
#            'Imports of Non Energy goods in volume',
#            'Real GDP (Laspeyres)', 
#            'Households consumption in GDP',
#            'Labour Intensity (Laspeyres)',
#            'Energy Intensity (Laspeyres)'
#        ]
#    }
#
#    # Folder for results
#    barchart_fold = 'MacroBarChart/'
#    if not os.path.exists(barchart_fold):
#        os.makedirs(barchart_fold)
#
#    return macro_csv_name, charts_to_draw, barchart_fold
        
def data_macro():

    macro_csv_name = 'TableMacroRatioBY_'

    charts_to_draw = {
        'Macro' :
        [
            'GDP (Laspeyres)', 
            'Kappa Intensity (Laspeyres)', 
            'Real Households consumption (Laspeyres)',
            'Total Emissions',
            'Total Employment'
            
        ],
#        'Chart Titre 2' :
#        [
#            'Imports in GDP',
#            'Imports/Domestic production ratio',
#            'Imports of Non Energy goods in volume',
#            'Real GDP (Laspeyres)', 
#            'Households consumption in GDP',
#            'Labour Intensity (Laspeyres)',
#            'Energy Intensity (Laspeyres)'
#        ],
#        'Chart Titre 3' :
#        [
#            'Labour Intensity (Laspeyres)'
#        ]
    }

    # Folder for results
    barchart_fold = 'MacroBarChart/'
    if not os.path.exists(barchart_fold):
        os.makedirs(barchart_fold)

    return macro_csv_name, charts_to_draw, barchart_fold

if __name__ == "__main__":

    work_file, charts_to_draw, save_path = data_macro()
    build_charts(work_file, charts_to_draw, save_path, type_chart='bar')
    
    work_file, charts_to_draw2, save_path = data_macro()
    build_charts(work_file, charts_to_draw, save_path, type_chart='radar')#, norm_ref='CCS')
    