import pandas as pd

metadata_csv_path = r"C:\Users\jeanw\Documents\IMACLIM-Country\code" + '/metadata.csv'
metadonnees_csv_path = r"C:\Users\jeanw\Documents\IMACLIM-Country\code" + '/metadonnees_scilab.csv'

# Lire la dernière ligne de metadata.csv si le fichier n'est pas vide
metadata_df = pd.read_csv(metadata_csv_path, sep=';')
if metadata_df.empty:
    dernier_numero_simulation = 0
else:
    dernier_numero_simulation = metadata_df['numero_simulation'].iloc[0]

# Calculer le nouveau numéro_simulation
nouveau_numero_simulation = dernier_numero_simulation + 1

# Lire la ligne à ajouter depuis metadonnees_scilab.csv
metadonnees_df = pd.read_csv(metadonnees_csv_path, sep=';')
colonnes_metadonnees = metadonnees_df.columns
valeurs_metadonnees = metadonnees_df.iloc[0].tolist()

# Ajouter le nouveau numéro_simulation
metadonnees_df.insert(0, 'numero_simulation', nouveau_numero_simulation)

# Ajouter la nouvelle ligne
metadata_df = pd.concat([metadata_df, metadonnees_df], axis=0)

# Mettre la nouvelle ligne au début de metadata.csv
metadata_df = metadata_df.sort_values('numero_simulation', ascending=False)

# Enregistrer le .csv
metadata_df.to_csv(metadata_csv_path, index=False, sep=';')
