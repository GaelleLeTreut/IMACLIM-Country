# -*- coding: utf-8 -*-

import read_outputs as ro
import matplotlib.pyplot as plt
import os 
from math import sqrt, pi
from radar_class import radar_factory
import numpy as np

def red_name(line_name):
    name_size_max = 20
    name_red = ''
    cpt_char = 0
    for c in line_name:
        if cpt_char == name_size_max:
            name_red += '\n'
            cpt_char = 0
        name_red += c
        cpt_char += 1
    return name_red
    
def create_bar_charts(time_steps, values, gen_title, legend, colors, nb_folds):
    # carré supérieur
    lines_to_draw = list(values.keys())
    nb_lines = int(sqrt(len(lines_to_draw))) + 1 #min(3,len(lines_to_draw))
    # nombre de col qui complète le nombre de lignes
    nb_col = ((len(lines_to_draw)-1) // nb_lines +1) # * len(time_steps)
    figsize=(nb_col*3,nb_lines*3)
    fig, axes = plt.subplots(nb_lines, nb_col, squeeze=False, figsize=figsize)
    for i, ax_row in enumerate(axes):
        for j, ax in enumerate(ax_row):
            if i*nb_col + j < len(lines_to_draw):
                list_rect = [[] for _ in range(nb_folds)]
                line = lines_to_draw[i*nb_col + j]
                #deb=1
                for time in time_steps:
                    # pour i qui parcourt val:
                    # rect(i) enregistre val(i)
                    # puis APRES on dessiner bien, avec les couleurs par défaut c'est ok
                    val = values[line][time]
                    for k in range(nb_folds):
                        list_rect[k].append(val[k])
                    #index = range(deb,len(val)+deb)
                    #deb += len(val)
                    #ax.bar(index, val, color=col_time[time])
                width = 0.8
                index = np.arange(1,len(time_steps)+1)
                #ax.bar(index - width/2, list_rect[0], width)
                #ax.bar(index + width/2, list_rect[1], width)

                pos = [index + k*width/nb_folds for k in range(nb_folds)]

                for k in range(nb_folds):
                 #   ax.bar(index, rect)    
                     ax.bar(index + k*width/nb_folds, list_rect[k], width/nb_folds)#, color=colors[i])    
                line_name_red = red_name(line)
                ax.set_title(line_name_red)
                #ax.set_xticks(range(1,len(label[line])+1))
                #ax.set_xticklabels(label[line], rotation=45)
                #ax.set_xticks(range(1,len(time_steps)+1))
                lab = []
                if (nb_folds % 2 == 1):
                    lab = pos[nb_folds // 2]
                else:
                    lab = (pos[nb_folds // 2 - 1] + pos[nb_folds // 2]) / 2
                ax.set_xticks(lab)
                ax.set_xticklabels(time_steps)
            else:
                ax.axis('off')

    #fig.legend(time_steps)
    fig.suptitle(gen_title)
    fig.legend(legend, loc='lower center')#,labelspacing=0.1, fontsize='small')

    plt.subplots_adjust(top=0.8, hspace=0.9, wspace=0.7, bottom=0.2)

    chart_path = save_path + gen_title + '.png'
    plt.savefig(chart_path)
    plt.close(fig)
    #plt.show()


def create_radar_charts(values, time_steps, title, colors, legend, nb_folds):

    # TODO : si 1 seul élément, mettre un warning et ne rien faire

    lines_to_draw = list(values.keys())

    # Build the radar chart
    N = len(lines_to_draw)
    theta = radar_factory(N, frame='polygon')

    spoke_labels = [red_name(line) for line in lines_to_draw]

    fig, axes = plt.subplots(figsize=(9, 9), nrows=2, ncols=1,
                            subplot_kw=dict(projection='radar'))
                            #facecolor = 'white')

    fig.subplots_adjust(wspace=0.25, hspace=0.4, top=0.85, bottom=0.05)

    #colors = ['b', 'r', 'g']#, 'm', 'y']
    # Plot the four cases from the example data on separate axes
    #for ax, (title, case_data) in zip(axes.flatten(), data):
    for k in range(len(axes.flatten())):
        ax = axes.flatten()[k]
        ax.set_rgrids([0.2, 0.4, 0.6, 0.8])
        ax.set_title(time_steps[k], weight='bold', size='medium', position=(0.5, 1.1),
                    horizontalalignment='center', verticalalignment='center')
        
        val_data = dict()
        for time in time_steps:
            val_data[time] = [[] for i in range(nb_folds)]

        for i in range(nb_folds):
            for line in values.keys():
                for time in values[line].keys():
                     val_data[time][i].append(values[line][time][i])


            ax.plot(theta, val_data[time][i])#, color=colors[i])
            #ax.fill(theta, d, facecolor=color, alpha=0.25)
            ax.set_varlabels(spoke_labels)
            #ax.set_facecolor('white')
            # Go through labels and adjust alignment based on where
            # it is in the circle.
            for lbl, angle in zip(ax.get_xticklabels(), theta):
                if angle in (0, pi):
                    lbl.set_horizontalalignment('center')
                elif 0 < angle < pi:
                    lbl.set_horizontalalignment('right')
                else:
                    lbl.set_horizontalalignment('left')

    # add legend relative to top-left plot
    #ax = axes[0, 0]
    #list_lab = list(macro_prop.keys())
    #labels = (list_lab[0], list_lab[1], list_lab[2])#, 'Factor 4', 'Factor 5')
    #ax.legend(label[line], loc=(0.9, .95),
    #                labelspacing=0.1, fontsize='small')

    

    #fig.text(0.5, 0.965, title,
    #        horizontalalignment='center', color='black', weight='bold',
    #        size='large')

    fig.suptitle(title)
    fig.legend(legend, loc='right')

    plt.savefig(save_path + 'radar_' + title + '.png')
    #plt.show()
    plt.close(fig)

def build_charts(file_name, charts_to_draw, save_path, colors=['b', 'r', 'g', 'm', 'y'], type_chart='bar', norm_ref=None):

    # Load data of files to read
    outputs = ro.read_output_file(file_name)

    # lines kept
    lines_to_draw = []
    for chart in charts_to_draw.keys():
        lines_to_draw += charts_to_draw[chart]  

    # TODO : fonction car besoin dans radar_chart
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

    # TODO : autoriser tous les time step, et faire une liste avec TOUS, pour la légende
    time_steps = ro.record_time_steps(outputs)

    col_time = dict()
    col_ind = 0
    for time in time_steps:
        col_time[time] = colors[col_ind]
        col_ind += 1

    # Create bar charts
    
    for chart in charts_to_draw.keys():
        lines_to_draw = charts_to_draw[chart]

        # DATA
        values_chart = dict()
        label = dict()
        for line_name in lines_to_draw:
            values_chart[line_name] = dict()
            label[line_name] = []
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
                    label[line_name].append(fold)



        #print(values_chart)

        nb_folds = len(list(outputs.keys()))

        # BAR CHARTS
        if type_chart == 'bar':
            create_bar_charts(time_steps, values_chart, chart, list(outputs.keys()), colors, nb_folds)
        # RADAR CHARTS
        elif type_chart == 'radar':
            create_radar_charts(values_chart, time_steps, chart, colors, list(outputs.keys()), nb_folds)
        else:
            raise Exception('type_chart unknown')

        
def data_macro():

    macro_csv_name = 'TableMacroOutputExtended'

    charts_to_draw = {
        'Chart Titre 1' :
        [
            'Real GDP (Laspeyres)', 
            'Households consumption in GDP', 
            'Public consumption in GDP'
        ],
        'Chart Titre 2' :
        [
            'Exports in GDP',
            'Imports in GDP',
            'Imports/Domestic production ratio',
            'Imports of Non Energy goods in volume',
            #'Exports of Non Energy goods in volume',
            'Real GDP (Laspeyres)', 
            'Households consumption in GDP',
            'Labour Intensity (Laspeyres)',
            'Energy Intensity (Laspeyres)'
        ],
        'Chart Titre 3' :
        [
            'Labour Intensity (Laspeyres)'
        ]
    }

    # Folder for results
    barchart_fold = 'MacroBarChart/'
    if not os.path.exists(barchart_fold):
        os.makedirs(barchart_fold)

    return macro_csv_name, charts_to_draw, barchart_fold

if __name__ == "__main__":

    work_file, charts_to_draw, save_path = data_macro()
    build_charts(work_file, charts_to_draw, save_path, type_chart='bar')
    build_charts(work_file, charts_to_draw, save_path, type_chart='radar', norm_ref='NDC')
    