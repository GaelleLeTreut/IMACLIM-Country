'''
Pour pouvoir exécuter du python depuis Scilab : ajouter python au path si nécessaire

1/ Connaître le chemin d'accès à python
>>> import os
>>> import sys
>>> os.path.dirname(sys.executable)
'c:\\users\\jeanw\\anaconda3'


2/ Préciser ce chemin d'accès dans les paramètres

Chercher "Variables d'environnement" dans les "Paramètres système avancés"
Cliquer sur "Variables d'environnement", puis dans les variables système, cliquer sur "Nouvelle"
En nom, mettre par exemple PythonPath
En valeur, mettre le chemin d'accès à python ('c:\\users\\jeanw\\anaconda3')
'''


# IMPORTS
import pandas as pd
import git

print('toto')
# METADONNEES GIT
repo_path = r"C:\Users\jeanw\Documents\IMACLIM-Country"
repo = git.Repo(repo_path, search_parent_directories=True)

last_commit = repo.head.commit.message # Nom du dernier commit
branch_name = repo.active_branch.name # Branche
sha = repo.head.object.hexsha[:10] # SHA raccourci (ID du dernier commit)

if repo.untracked_files: # Changement par enregistres

    uncommited_changes = 'True'
else:
    uncommited_changes = 'False'

print('toto')
# UPDATE DU FICHIER
metadata_path = r"C:\Users\jeanw\Documents\IMACLIM-Country\outputs_display" + '/metadata.csv'
new_row_path = r"C:\Users\jeanw\Documents\IMACLIM-Country\outputs_display" + '/metadata_new_row.csv'
print('toto')
# Lire la dernière ligne de metadata.csv si le fichier n'est pas vide
metadata_df = pd.read_csv(metadata_path, sep=';')
if metadata_df.empty:
    dernier_numero_simulation = 0
else:
    dernier_numero_simulation = metadata_df['numero_simulation'].iloc[0]
print('toto6')
# Calculer le nouveau numéro_simulation
nouveau_numero_simulation = dernier_numero_simulation + 1
print('toto')
# Lire la ligne à ajouter depuis metadonnees_scilab.csv
new_row_df = pd.read_csv(new_row_path, sep=';')
colonnes_metadonnees = new_row_df.columns
valeurs_metadonnees = new_row_df.iloc[0].tolist()
print('toto')
# Ajouter les informations Git
new_row_df.insert(0, 'uncommited_changes', uncommited_changes)
new_row_df.insert(0, 'SHA', sha)
new_row_df.insert(0, 'branch_name', branch_name)
new_row_df.insert(0, 'last_commit', last_commit)
print('toto')
# Ajouter le nouveau numéro_simulation
new_row_df.insert(0, 'numero_simulation', nouveau_numero_simulation)
print('toto10')
# Ajouter la nouvelle ligne
metadata_df = pd.concat([metadata_df, new_row_df], axis=0)
print('toto')
# Mettre la nouvelle ligne au début de metadata.csv
metadata_df = metadata_df.sort_values('numero_simulation', ascending=False)
print('toto')
# Enregistrer le .csv
metadata_df.to_csv(metadata_path, index=False, sep=';')
print('toto')








