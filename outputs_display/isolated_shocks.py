repertoire_racine = r"C:\Users\jeanw\Documents\IMACLIM-Country\outputs_display"


# "Energy consumption (C + IC) (ktoe)": "Consommation énergétique (C+IC) - en ktep", soustraire IC par l'énergie !!!
renaming_dict = {
    'Real GDP': 'PIB réel',
    "Population": "Population",
    "Ratio I / PIB (nominal)": "Ratio I / PIB (nominal)",
    "Ratio G / PIB (nominal)": "Ratio G / PIB (nominal)",
    "Ratio C / PIB (nominal)": "Ratio C / PIB (nominal)",
    "Unemployment % points/BY": "Taux de chômage",
    "Net DebtGovernment": "Dette de l'état"
    }



# Library imports
import os
import pandas as pd
import re
import numpy as np


# CREATION D'UN DATAFRAME POUR CHAQUE SIMULATION AVEC LES VALEURS SOUHAITEES
# Créer un dictionnaire pour stocker les valeurs de "values_2050" pour chaque simulation
valeurs_par_fichier = {}

# List all folders in the base directory
base_dir = repertoire_racine + '\Isolated_Shocks'
folders = [folder for folder in os.listdir(base_dir) if os.path.isdir(os.path.join(base_dir, folder))]

# Initialize an empty list to store concatenated dataframes
#list_dfs = []

# Créer un dictionnaire pour stocker les valeurs pour chaque simulation
dict_dfs = {}

# Iterate through each folder
for folder in folders:
    # Get the path to the current folder
    folder_path = os.path.join(base_dir, folder)

    # List all files in the current folder
    fichiers = os.listdir(folder_path)

    # Looking for FullTemplate and Summary
    for fichier in fichiers:

        fichier_path = os.path.join(folder_path, fichier)

        if fichier.endswith(".csv") and "FullTemplate_" in fichier and "FullTemplate_BY" not in fichier:
            df1 = pd.read_csv(fichier_path, on_bad_lines='skip', sep=';', decimal=',')
            # print(fichier)

            # Extraire la partie du nom du fichier entre "FullTemplate_" et ".csv"
            nom_simulation_match = re.search(r"FullTemplate_(.+)\.csv", fichier)
            if nom_simulation_match:
                nom_simulation = nom_simulation_match.group(1)
            else:
                raise ValueError(f"Le format du nom du fichier {fichier} n'est pas conforme.")

        elif fichier.endswith(".csv") and "Summary_" in fichier:
            df2 = pd.read_csv(fichier_path, on_bad_lines='skip', sep=';', decimal=',')
            # print(fichier)

    # print(nom_simulation)
    # print("\n")

    # Concatenate the dataframes
    df = pd.concat([df1, df2])

    # Renommer les variables
    df['Variables'] = df['Variables'].replace(renaming_dict)

    # Selectionner les variables
    selected_rows = df[df["Variables"].isin(renaming_dict.values())]

    # Supprimer les duplicatas
    selected_rows = selected_rows.drop_duplicates(subset='Variables')

    # Renommer les colonnes d'années en 2018, 2030, 2040 et 2050
    selected_rows = selected_rows.rename(columns={'values_2018': '2018', 'values_2030': '2030', 'values_2040': '2040', 'values_2050': '2050'})

    #selected_rows = selected_rows["values_2050"].replace(',', '.')

    # On met "Variable" en index
    selected_rows.set_index('Variables', inplace=True)

    # Calculer le PIB réel par tête
    selected_rows.loc['PIB réel par tête'] = selected_rows.loc['PIB réel'] / selected_rows.loc['Population']

    # print(selected_rows)
    # print("\n")

    # On enregistre le dataframe de la simulation sans_rien à part
    if nom_simulation == 'sans_rien':
        df_sans_rien = selected_rows
    else:
        dict_dfs[nom_simulation] = [selected_rows]



# CREATION D'UN DATAFRAME POUR CHAQUE VARIABLE ET CALCUL DE LA VARIATION PAR RAPPORT A
# LA SIMULATION A VIDE
dict_of_df_by_variable = {}

for variable in df_sans_rien.index:
    df_by_variable = pd.DataFrame(columns = ['Simulation', 'Ecart_Pourcentage', 'Valeur 2050'])

    ecart_pourcentage = 0
    df_by_variable.loc[0] = ['sans_rien', ecart_pourcentage, df_sans_rien['2050'].loc[variable]]

    # print('\n')
    # print(variable)

    for simu in dict_dfs:
        print(simu)

        df_simu = dict_dfs[simu][0]

        valeur_2050 = df_simu['2050'].loc[variable]
        ecart_pourcentage = valeur_2050 / df_sans_rien['2050'].loc[variable] - 1
        df_by_variable.loc[len(df_by_variable)] = [simu, ecart_pourcentage, valeur_2050]


    # print(df_by_variable)

    # Ajouter une colonne 'Type_de_choc' en fonction de la colonne 'Simulation'
    conditions = [
        df_by_variable['Simulation'].isin(['prix_import_fossiles', 'croissance_mondiale', 'population', 'productivite']),
        df_by_variable['Simulation'].isin(['exportations_energetiques', 'coefs_techniques_energetiques', 'importations', 'kappa', 'consommation_des_menages', 'investissement', 'prix_de_production', 'prix_de_production_et_marges_specifiques', 'coefs_techniques_et_imports', 'CBAM']),
        (df_by_variable['Simulation'] == 'sans_rien') | (df_by_variable['Simulation'] == 'ensemble')
    ]

    valeurs = ['Context_shock', 'Policy_shock', '_']
    df_by_variable['Type_de_choc'] = np.select(conditions, valeurs, default='_')

    # Échanger les colonnes de place
    df_by_variable = df_by_variable[['Type_de_choc', 'Simulation','Ecart_Pourcentage', 'Valeur 2050']]

    # Trier les lignes d'abord selon 'Type_de_choc', puis selon 'Ecart_Pourcentage' croissant
    df_by_variable = df_by_variable.sort_values(by=['Type_de_choc', 'Ecart_Pourcentage'])

    # Afficher le DataFrame résultant
    print(df_by_variable)

    # On ajoute le df dans le dict
    dict_of_df_by_variable[variable] = df_by_variable


# SAVE DATA
writer = pd.ExcelWriter(repertoire_racine + '/isolated_shocks_output.xlsx', engine='xlsxwriter')

for variable in dict_of_df_by_variable:
    df_tmp = dict_of_df_by_variable[variable]
    df_tmp.to_excel(writer, sheet_name = variable, index=False)

writer.close()



