// Ecrire dans l'interpréteur python pour connaître le chemin d'accès à python :
// >>> import os
// >>> import sys
// >>> os.path.dirname(sys.executable)
// 'C:\Users\jeanw\anaconda3'

// Ajouter le chemin d'accès de python aux paramètres du PC :
// Chercher "Variables d'environnement" dans les paramètres. Ajouter une nouvelle variable système : l'appeler par exemple PythonPath, et renseigner le chemin d'accès de python (par exemple 'C:\Users\jeanw\anaconda3')

// Calculate some variables
Real_GDP_metadata = money_disp_adj .* Out.GDP ./ GDP_pFish;
Non_energy_output_metadata = sum(Out.Y(Indice_NonEnerSect));
Energy_output_metadata = sum(Out.Y(Indice_EnerSect));
Non_energy_consumption_metadata = sum(Out.C(Indice_NonEnerSect, :)) + sum(Out.G(Indice_NonEnerSect, :));
Energy_consumption_metadata = sum(Out.C(Indice_EnerSect, :)) + sum(Out.IC(Indice_EnerSect, :));
Unemployment_rate_metadata = Out.u_tot * 100;
Volume_of_investment_metadata = sum(Out.I_value);
Real_Net_of_tax_wages_metadata = Out.omega / Out.CPI;
CPI_metadata = Out.CPI;
Emissions_MtCO2_metadata = Out.DOM_CO2;

// Create the metadata row with additional variables
column_names = ["Scenario", "Country", "Datehour", "Model version", "Commentary", "Macro_nb", "Proj_scenario", "SystemOpt_Resol", "study", "Nb_Iter", "AGG_type", "Demographic_shift", "Labour_product", "World_prices", "X_nonEnerg", "Invest_matrix", "Real_GDP_metadata", "Non_energy_output_metadata", "Energy_output_metadata", "Non_energy_consumption_metadata", "Energy_consumption_metadata", "Unemployment_rate_metadata", "Volume_of_investment_metadata", "Real_Net_of_tax_wages_metadata", "CPI_metadata", "Emissions_MtCO2_metadata"];
metadata_values = [Scenario, Country_ISO, datehour, "Model version", Commentary, Macro_nb, Proj_scenario, SystemOpt_Resol, study, Nb_Iter, AGG_type, Demographic_shift, Labour_product, World_prices, X_nonEnerg, Invest_matrix, Real_GDP_metadata, Non_energy_output_metadata, Energy_output_metadata, Non_energy_consumption_metadata, Energy_consumption_metadata, Unemployment_rate_metadata, Volume_of_investment_metadata, Real_Net_of_tax_wages_metadata, CPI_metadata, Emissions_MtCO2_metadata];

new_row = [column_names; metadata_values];

// Save the new row in a .csv file
csvWrite(new_row, PARENT + "outputs_display\" + "metadata_new_row.csv", ";", ",");


// check if the meta .xlsx file is being created or modified by another run
[fd,err]=mopen(PARENT + "outputs_display\" + "metadata_is_available.txt");
mclose(fd);
file_updated=%f;
if err == 0 // check .xls file availability only if the exchange file xlsx_diagnos_filename+"_available.txt" exists
    i=0;
    while i<100 & ~file_updated
        fd=csvRead(PARENT + "outputs_display\" + "metadata_is_available.txt");
        if fd == 1
            file_updated=%t;
        end
        i=i+1;
        sleep(1000); // wait 1 second before trying again
    end
else
    file_updated=%t;
end
if file_updated==%t
    // Exécution du code python pour ajouter la ligne a l'excel recapitulatif des simulations
    cd(PARENT + "outputs_display\");
    unix_s("C:\Users\jeanw\anaconda3\python update_metadata_file.py");
end

cd(CODE);