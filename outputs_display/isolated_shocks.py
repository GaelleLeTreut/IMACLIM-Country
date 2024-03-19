repertoire_racine = r"C:\Users\jeanw\Documents\IMACLIM-Country\outputs_display"



# Library imports
import os
import pandas as pd
import re
import numpy as np

# Fonction pour lister tous les FullTemplate
def lister_fichiers_csv(repertoire):
    fichiers_csv = []
    for dossier_racine, _, fichiers in os.walk(repertoire):
        for fichier in fichiers:
            if fichier.endswith(".csv") and "FullTemplate_" in fichier and "FullTemplate_BY" not in fichier:
                fichiers_csv.append(os.path.join(dossier_racine, fichier))
    return fichiers_csv

# Liste pour stocker les chemins des fichiers CSV qui correspondent aux critères
fichiers_csv_correspondants = lister_fichiers_csv(repertoire_racine + '\Isolated_Shocks')

# Créer un dictionnaire pour stocker les valeurs de "values_2050" pour chaque fichier
valeurs_par_fichier = {}

# Parcourir tous les fichiers CSV correspondants
for fichier in fichiers_csv_correspondants:
    try:
        # Lire le fichier CSV
        df = pd.read_csv(fichier, on_bad_lines='skip', sep=';')

        # Extraire la partie du nom du fichier entre "FullTemplate_" et ".csv"
        nom_fichier_match = re.search(r"FullTemplate_(.+)\.csv", fichier)
        if nom_fichier_match:
            nom_fichier = nom_fichier_match.group(1)
        else:
            raise ValueError(f"Le format du nom du fichier {fichier} n'est pas conforme.")


        # Extraire les valeurs de PIB réel et de population en 2050
        pib_2050 = df[df['Variables'] == 'Real GDP']['values_2050'].values[0]
        pop_2050 = df[df['Variables'] == 'Population']['values_2050'].values[0]

        # Convertir les valeurs en type numérique
        pib_2050 = pib_2050.replace(',', '.')
        pib_2050 = float(pib_2050)
        pop_2050 = pop_2050.replace(',', '.')
        pop_2050 = float(pop_2050)

        # Calculer le PIB réel par tête
        valeur_2050 = pib_2050 / pop_2050

        # Ajouter la valeur au dictionnaire
        valeurs_par_fichier[nom_fichier] = valeur_2050

    except (pd.errors.ParserError, IndexError) as e:
        print(f"Erreur lors de la lecture du fichier {fichier}: {e}")

# Créer un DataFrame à partir du dictionnaire
df_final = pd.DataFrame(list(valeurs_par_fichier.items()), columns=['Simulation', 'Valeur_2050'])

# Calculer le pourcentage de variation par rapport à la simu "sans rien"
df_final['Ecart_Pourcentage'] = (df_final['Valeur_2050'] / df_final[df_final["Simulation"]=="sans_rien"].Valeur_2050.values - 1)

# Renommer la colonne 'Valeur_2050'
df_final = df_final.rename(columns={'Valeur_2050': 'PIB_reel_par_tete_2050'})

# Ajouter une colonne 'Type_de_choc' en fonction de la colonne 'Simulation'
conditions = [
    df_final['Simulation'].isin(['prix_import_fossiles', 'croissance_mondiale', 'population', 'productivite']),
    df_final['Simulation'].isin(['exportations_energetiques', 'coefs_techniques_energetiques', 'importations', 'kappa', 'consommation_des_menages', 'investissement', 'prix_de_production', 'prix_de_production_et_marges_specifiques', 'coefs_techniques_et_imports', 'CBAM']),
    (df_final['Simulation'] == 'sans_rien') | (df_final['Simulation'] == 'ensemble')
]

valeurs = ['Context_shock', 'Policy_shock', '_']
df_final['Type_de_choc'] = np.select(conditions, valeurs, default='_')

# Échanger les colonnes de place
df_final = df_final[['Type_de_choc', 'Simulation', 'PIB_reel_par_tete_2050','Ecart_Pourcentage']]

# Trier les lignes d'abord selon 'Type_de_choc', puis selon 'Ecart_Pourcentage' croissant
df_final = df_final.sort_values(by=['Type_de_choc', 'Ecart_Pourcentage'])

# Afficher le DataFrame résultant
print(df_final)

df_final.to_csv(repertoire_racine + '/isolated_shocks_output.csv', sep=';', index=False, decimal=',')

