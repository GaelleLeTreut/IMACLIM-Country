
# Library imports
import os
import pandas as pd
import glob
import re


pd.options.mode.chained_assignment = None  # default='warn' # Pour désactiver des warnings


# Path to output folder
#repo_path = r"C:\Users\jeanw\Documents\IMACLIM-Country"
repo_path = os.path.dirname(os.path.realpath(__file__))
output_folder_path = open(repo_path + "\\output_folder_path.txt", "r")
for line in output_folder_path:
    output_folder_path = line[:-1]

# List csv file in folder
os.chdir(output_folder_path)
csv_in_folder = glob.glob('*.{}'.format('csv'))

# Look for FullTemplate and Summary
for file in csv_in_folder:
    if "FullTemplate" in file:
        filename_full_template = file
    if "Summary" in file:
        filename_summary = file

# Extraire le nom du scénario
Scenario_match = re.search(r"FullTemplate_(.+)\.csv", filename_full_template)
if Scenario_match:
    Scenario = Scenario_match.group(1)
else:
    raise ValueError(f"Le format du nom du fichier {filename_full_template} n'est pas conforme.")


# Charger les fichiers dans un DataFrame
df1 = pd.read_csv(output_folder_path + '/' + filename_full_template, on_bad_lines='skip', sep=';', decimal=',')
df2 = pd.read_csv(output_folder_path + '/' + filename_summary, on_bad_lines='skip', sep=';', decimal=',')

df = pd.concat([df1, df2])


# Supprimer les duplicatas
df = df.drop_duplicates(subset='Variables')

# Renommer les colonnes d'années en 2018, 2030, 2040 et 2050
df = df.rename(columns={'values_2018': '2018', 'values_2030': '2030', 'values_2040': '2040', 'values_2050': '2050'})

# Renommer les variables avec des noms plus simples
renaming_dict = {
    "Real GDP": "PIB réel",
    "Natural growth": "Croissance naturelle",
    "Labour productivity (1 + Mu)^time_since_BY": "Productivité du travail",
    "Non-energy output": "Production non énergétique",
    "Energy output": "Production énergétique",
    "Non-energy consumption (C+G)": "Consommation non énergétique (C+G)",
    "Energy consumption (C + IC except energy) (ktoe)": "Consommation énergétique (hors production d'énergie) - en ktep",
    "Households Energy consumption (ktoe)": "Consommation énergétique des ménages (ktep)",
    "Households Non-energy consumption (pseudoquantities)": "Consommation non énergétique des ménages (pseudoquantités)",
    "Emissions - MtCO2": "Emissions - MtCO2",
    "Volume of investment": "Volume d'investissement",
    "Unemployment % points/BY": "Taux de chômage",
    "Disposable income_Households": "Revenu disponible brut des ménages",
    "pC pFish/BY": "Déflateur de la dépense de consommation finale",
    "Real Net-of-tax wages": "Salaire net réel moyen",
    "Net DebtHouseholds": "Dette des ménages",
    "Net DebtCorporations": "Dette des entreprises",
    "Net DebtGovernment": "Dette de l'état",
    "Net Lending_Households": "Déficit des ménages",
    "Net Lending_Corporations": "Déficit des entreprises",
    "Net Lending_Government": "Déficit public",
    "Disposable income_Government": "Budget public après transferts",
    "G_Tax_revenue": "G_Tax_revenue",
    "G_Non_Labour_Income": "G_Non_Labour_Income",
    "G_Other_Income": "G_Other_Income",
    "G_Property_income": "G_Property_income",
    "G_Social_Transfers": "G_Social_Transfers",
    "G_Compensations": "G_Compensations",
    "Ratio I / PIB (nominal)": "Ratio I / PIB (nominal)",
    "Ratio G / PIB (nominal)": "Ratio G / PIB (nominal)",
    "Ratio C / PIB (nominal)": "Ratio C / PIB (nominal)",
    "Real C": "C réel",
    "Real G": "G réel",
    "Real I": "I réel",
    "Real X": "X réel",
    "Real M": "M réel",
    "Nominal GDP": "PIB nominal",
    "H_Labour_Income": "Revenu du travail",
    "H_Non_Labour_Income": "Revenu hors travail des ménages",
    "Pensions": "Retraites",
    "Households Energy consumption (Millions of euro)": "Consommation énergétique des ménages (m€)",
    "Unemployment transfers": "Montant chomage",
    "Population": "Population"
}


df['Variables'] = df['Variables'].replace(renaming_dict)


# VARIABLES MACRO
# Sélectionner les lignes correspondant aux variables spécifiées
selected_rows = df[df["Variables"].isin(renaming_dict.values())]

# Trier les lignes selon le même ordre que renaming_dict
selected_rows['Variables_cat'] = pd.Categorical(
    selected_rows['Variables'],
    categories=renaming_dict.values(),
    ordered=True
)

selected_rows = selected_rows.sort_values('Variables_cat')

selected_rows = selected_rows.drop('Variables_cat', axis=1)


# On met le taux de chômage et non pas la différence de taux de chômage avec l'année de base
initial_unemployment = 9.66649
selected_rows.loc[selected_rows['Variables'] == "Taux de chômage", ['2018', '2030', '2040', '2050']] = initial_unemployment + selected_rows.loc[selected_rows['Variables'] == "Taux de chômage"][['2018', '2030', '2040', '2050']]


# Convertir les valeurs numériques en float (sauf la colonne Variable)
#numeric_columns = df.columns.difference(['Variables'])
#df[numeric_columns] = df[numeric_columns].apply(pd.to_numeric, errors='coerce')

print('VARIABLES MACRO', '\n', selected_rows.head(), '\n')


# EMPLOI
employment_variables = ["Labour Crude_oil ThousandFTE", "Labour Liquid_fuels ThousandFTE", "Labour Gas_fuels ThousandFTE",
    "Labour Solid_fuels ThousandFTE", "Labour Elec_heating ThousandFTE", "Labour Steel_Iron ThousandFTE",
    "Labour NonFerrousMetals ThousandFTE", "Labour Cement ThousandFTE", "Labour OthMin ThousandFTE",
    "Labour ChemicalPharma ThousandFTE", "Labour Paper ThousandFTE", "Labour Auto_indus ThousandFTE",
    "Labour OthEquip ThousandFTE", "Labour Electronics ThousandFTE", "Labour Food_industry ThousandFTE",
    "Labour OthManuf ThousandFTE", "Labour LandTransp ThousandFTE", "Labour NavalTransp ThousandFTE",
    "Labour AirTransp ThousandFTE", "Labour AgriForest_Fish ThousandFTE", "Labour Construction ThousandFTE",
    "Labour Property_business ThousandFTE", "Labour Compo ThousandFTE"]

# Select rows corresponding to employment variables
employment_rows = df[df["Variables"].isin(employment_variables)]

# Rename variables' names
employment_rows['Variables'] = employment_rows['Variables'].replace("Labour ", "", regex=True)
employment_rows['Variables'] = employment_rows['Variables'].replace(" ThousandFTE", "", regex=True)

print('EMPLOI', '\n', employment_rows.head(), '\n')


# PRODUCTION
production_rows = df[df['Variables'].str.startswith('Real Y')]

production_rows['Variables'] = production_rows['Variables'].replace("Real Y_", "", regex=True)

print('PRODUCTION', '\n', production_rows.head(), '\n')


# PRIX
prices_rows = df[df['Variables'].str.startswith('pY ')]
prices_rows = prices_rows[prices_rows['Variables'].str.endswith('/BY')]

prices_rows['Variables'] = prices_rows['Variables'].replace("pY pFish/BY", "pY_pFish", regex=True)
prices_rows['Variables'] = prices_rows['Variables'].replace("pLasp/BY", "", regex=True)
prices_rows['Variables'] = prices_rows['Variables'].replace("pY ", "", regex=True)

# Déplacer la ligne "Non Energy", qui est au milieu, au début
prices_rows = prices_rows.reset_index(drop=True)
non_energy_index = prices_rows[prices_rows['Variables'] == 'Non-Energy '].index[0]
line = prices_rows.iloc[[non_energy_index]]
prices_rows = pd.concat([prices_rows.iloc[:non_energy_index], line, prices_rows.iloc[non_energy_index+1:]]).reset_index(drop=True)
prices_rows = pd.concat([prices_rows.iloc[:2], line, prices_rows.iloc[2:non_energy_index:], prices_rows.iloc[non_energy_index+1:]]).reset_index(drop=True)

print('PRIX', '\n', prices_rows.head(), '\n')


# CONSOMMATION DES MENAGES EN VOLUME
household_nonE_rows = df[df['Variables'].str.startswith('C_')]
household_nonE_rows['Variables'] = household_nonE_rows['Variables'].replace("C_", "", regex=True)

household_E_rows = df[df['Variables'].str.startswith('C -')][1:]
household_E_rows['Variables'] = household_E_rows['Variables'].replace("C - ", "", regex=True)

household_rows = pd.concat([household_E_rows, household_nonE_rows])


# SAVE DATA
writer = pd.ExcelWriter(output_folder_path + '/temporal_analysis_' + Scenario + '.xlsx', engine='xlsxwriter')

selected_rows.to_excel(writer, sheet_name = 'variables_macro', index=False)
employment_rows.to_excel(writer, sheet_name = 'Emploi - kETP', index=False)
production_rows.to_excel(writer, sheet_name = 'Real Y', index=False)
prices_rows.to_excel(writer, sheet_name = 'pY', index=False)
household_rows.to_excel(writer, sheet_name = 'C', index=False)

writer.close()




