# -*- coding: utf-8 -*-

import read_outputs as ro
import matplotlib.pyplot as plt
import os 
from math import sqrt

def bar_chart(values, title, label=[], color='b'):
    
    x = range(1,len(values)+1)
    plt.bar(x, values, color=color)
    plt.title(title)
    # plt.xlabel('Genre')
    # plt.ylabel('No of Movies')
    index = range(1,len(label)+1)
    plt.xticks(index, label, rotation=45)


def build_charts(file_name, charts_to_draw, save_path, colors=['b', 'r', 'g', 'm', 'y']):

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
        values = dict()
        label = dict()
        for line_name in lines_to_draw:
            values[line_name] = dict()
            label[line_name] = []
            for time in time_steps:
                values[line_name][time] = []
                for fold in outputs.keys():
                    line = ro.get_line(outputs[fold][time], line_name)
                    values[line_name][time].append(line[1])
                    label[line_name].append(fold)

        # BAR CHARTS
        # carré supérieur
        nb_lines = int(sqrt(len(lines_to_draw))) + 1 #min(3,len(lines_to_draw))
        # nombre de col qui complète le nombre de lignes
        nb_col = ((len(lines_to_draw)-1) // nb_lines +1) # * len(time_steps)
        figsize=(nb_col*3,nb_lines*3)
        fig, axes = plt.subplots(nb_lines, nb_col, squeeze=False, figsize=figsize)
        for i, ax_row in enumerate(axes):
            for j, ax in enumerate(ax_row):
                if i*nb_col + j < len(lines_to_draw):
                    line = lines_to_draw[i*nb_col + j]
                    deb=1
                    for time in values[line].keys():
                        val = values[line][time]
                        index = range(deb,len(val)+deb)
                        deb += len(val)
                        ax.bar(index, val, color=col_time[time])
                    line_name_red = red_name(line)
                    ax.set_title(line_name_red)
                    ax.set_xticks(range(1,len(label[line])+1))
                    ax.set_xticklabels(label[line], rotation=45)
                else:
                    ax.axis('off')

        #fig.legend(time_steps)
        fig.suptitle(chart)
        fig.legend(time_steps, loc='lower center')#,labelspacing=0.1, fontsize='small')

        plt.subplots_adjust(top=0.8, hspace=0.9, wspace=0.7, bottom=0.2)

        chart_path = save_path + chart + '.png'
        plt.savefig(chart_path)
        plt.close(fig)




        """
        # carré
        nb_lines = int(sqrt(len(time_steps)*len(lines_to_draw))) #min(3,len(lines_to_draw))
        # nombre de col qui complète le nombre de lignes
        nb_col = ((len(lines_to_draw)-1) // nb_lines +1) # * len(time_steps)
        num_subplot = 0
        #figsize=(nb_col*3,nb_lines*3)
        #fig = plt.figure(num=None, figsize=figsize, facecolor='w', edgecolor='k', dpi=150)

        fig, ax_array = plt.subplots(nb_lines, nb_col, squeeze=False)

        for chart_name in values.keys():
            name_size_max = 20
            new_chart_name = ''
            cpt_char = 0
            for c in chart_name:
                if cpt_char == name_size_max:
                    new_chart_name += '\n'
                    cpt = 0
                new_chart_name += c
                cpt_char += 1

            num_subplot += 1
            plt.subplot(nb_lines, nb_col, num_subplot)
            title = new_chart_name
            bar_chart(values[chart_name], title, label[chart_name])

        plt.subplots_adjust(top=0.7, hspace=0.9, wspace=0.7)"""

        """fig.text(0.5, 0.965, chart,
        horizontalalignment='center', color='black', weight='bold',
        size='large')"""
        
        """fig.suptitle("Title centered above all subplots")

        chart_path = save_path + chart + '.png'
        plt.savefig(chart_path)
        plt.close(fig)"""

        
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
            'Exports of Non Energy goods in volume',
            'Real GDP (Laspeyres)', 
            'Households consumption in GDP', 
            #'Public consumption in GDP',
            'Labour Intensity (Laspeyres)'
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
    build_charts(work_file, charts_to_draw, save_path, colors)
    