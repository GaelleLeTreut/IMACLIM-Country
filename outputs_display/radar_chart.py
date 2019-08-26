# -*- coding: utf-8 -*-

from test_radar_chart2 import *

from read_outputs import read_outputs_files
import os 

radarchart_name = 'macro_radar'

# Créer dossier pour résultat
radarchart_dir = 'MacroRadarChart/'
if not os.path.exists(radarchart_dir):
    os.makedirs(radarchart_dir)

# Fichiers à lire
macro_csv = 'TableMacroOutputExtended'
files_to_read = [macro_csv]

# Récupérer ces fichiers dans les outputs
outputs = read_outputs_files(files_to_read)

# Lignes à garder
# 'Total Employment'
properties = ['Real GDP (Laspeyres)', \
               'Households consumption in GDP', 'Total Emissions', \
               'Imports/Domestic production ratio', \
               'Real Households consumption (Laspeyres)']

# Lire les données associées aux lignes à garder
macro_prop = dict()
for d in outputs.keys():
    macro_prop[d] = dict()
    for time in outputs[d].keys():
        prop_val = []
        for prop in properties:
            for row in outputs[d][time][macro_csv]:
                if row[0] == prop:
                    prop_val.append(eval(row[1]))
                    break
        if len(prop_val) != len(properties):
            raise Exception('PB lecture properties : ' + outputs[d][time]['path'])
        else:
            macro_prop[d][time] = prop_val
            
# Normaliser
ref = 'NDC'
norm_list = [[x for x in macro_prop[ref][time]] for time in outputs[ref].keys()]
for d in outputs.keys():
    for t in range(len(outputs[d].keys())):
        time = list(outputs[d].keys())[t]
        current_list = macro_prop[d][time]
        for i in range(len(norm_list[t])):
            macro_prop[d][time][i] = current_list[i] / norm_list[t][i]

time_steps = ['Time_1', 'Time_2']

data = [properties]

for time in time_steps:
    data_time = []
    
    for d in macro_prop.keys():
        data_time.append(macro_prop[d][time])
    
    data.append((time,data_time))
    

"""for time in time_steps:
    fig, t, axes = new_radar()
    
    for d in macro_prop.keys():
        values = macro_prop[d][time]
        draw_values(values, t, axes)
        
    # Done
    plt.savefig(radarchart_dir + time + '.png', facecolor='white')
    plt.show()"""
    
# Build the radar chart
N = len(properties)
theta = radar_factory(N, frame='polygon')

spoke_labels = data.pop(0)

fig, axes = plt.subplots(figsize=(9, 9), nrows=2, ncols=1,
                         subplot_kw=dict(projection='radar'))
fig.subplots_adjust(wspace=0.25, hspace=0.20, top=0.85, bottom=0.05)

colors = ['b', 'r', 'g']#, 'm', 'y']
# Plot the four cases from the example data on separate axes
for ax, (title, case_data) in zip(axes.flatten(), data):
    ax.set_rgrids([0.2, 0.4, 0.6, 0.8])
    ax.set_title(title, weight='bold', size='medium', position=(0.5, 1.1),
                 horizontalalignment='center', verticalalignment='center')
    for d, color in zip(case_data, colors):
        ax.plot(theta, d, color=color)
        #ax.fill(theta, d, facecolor=color, alpha=0.25)
    ax.set_varlabels(spoke_labels)

# add legend relative to top-left plot
#ax = axes[0, 0]
list_lab = list(macro_prop.keys())
labels = (list_lab[0], list_lab[1], list_lab[2])#, 'Factor 4', 'Factor 5')
legend = ax.legend(labels, loc=(0.9, .95),
                   labelspacing=0.1, fontsize='small')

fig.text(0.5, 0.965, 'Titre',
         horizontalalignment='center', color='black', weight='bold',
         size='large')

plt.savefig(radarchart_dir + radarchart_name + '.png')
plt.show()