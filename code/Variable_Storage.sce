/////////////////////////////////////////////////////////////////////////////////////////////
// Variable stockage for several time steps calculation (Static_comparative or Dynamic_projection)
/////////////////////////////////////////////////////////////////////////////////////////////

// Put back some variables to "equation" from EcoT formats due to "outputs.sce"

if Country == 'France' then

	BY.GFCF_byAgent(Indice_RestOfWorld)=[];
	BY.Income_Tax = -Income_Tax(Indice_Households);
	BY.Corporate_Tax = - Corporate_Tax(Indice_Corporations);
	BY.Production_Tax_byAgent = Production_Tax_byAgent(Indice_Government);
	BY.VA_Tax_byAgent = VA_Tax_byAgent(Indice_Government);

	ini.GFCF_byAgent(Indice_RestOfWorld)=[];
	ini.Income_Tax = -Income_Tax(Indice_Households);
	ini.Corporate_Tax = - Corporate_Tax(Indice_Corporations);
	ini.Production_Tax_byAgent = Production_Tax_byAgent(Indice_Government);
	ini.VA_Tax_byAgent = VA_Tax_byAgent(Indice_Government);

end

d.GFCF_byAgent(Indice_RestOfWorld)=[];
d.Income_Tax = -Income_Tax(Indice_Households);
d.Corporate_Tax = - Corporate_Tax(Indice_Corporations);
d.Production_Tax_byAgent = Production_Tax_byAgent(Indice_Government);
d.VA_Tax_byAgent = VA_Tax_byAgent(Indice_Government);
	
GFCF_byAgent(Indice_RestOfWorld)=[];
Income_Tax = -Income_Tax(Indice_Households);	
Corporate_Tax = - Corporate_Tax(Indice_Corporations);
Production_Tax_byAgent = Production_Tax_byAgent(Indice_Government);
VA_Tax_byAgent = VA_Tax_byAgent(Indice_Government);
	
 if  Country<>"Brasil" then 

	BY.Pensions=Pensions(Indice_Households);
	BY.Unemployment_transfers=Unemployment_transfers(Indice_Households);
	BY.Other_Direct_Tax = -Other_Direct_Tax(Indice_Households);
	BY.Other_social_transfers = Other_social_transfers(Indice_Households);

	ini.Pensions=Pensions(Indice_Households);
	ini.Unemployment_transfers=Unemployment_transfers(Indice_Households);
	ini.Other_Direct_Tax = -Other_Direct_Tax(Indice_Households);
	ini.Other_social_transfers = Other_social_transfers(Indice_Households);

	d.Pensions=Pensions(Indice_Households);
	d.Unemployment_transfers=Unemployment_transfers(Indice_Households);
	d.Other_Direct_Tax = -Other_Direct_Tax(Indice_Households);
	d.Other_social_transfers = Other_social_transfers(Indice_Households);

	Pensions=Pensions(Indice_Households);
	Unemployment_transfers=Unemployment_transfers(Indice_Households);
	Other_Direct_Tax = -Other_Direct_Tax(Indice_Households);
	Other_social_transfers = Other_social_transfers(Indice_Households);


	else
	
	d.Gov_social_transfers = d.Gov_social_transfers(Indice_Households);
	d.Corp_social_transfers = d.Corp_social_transfers(Indice_Households);
	d.Gov_Direct_Tax= -d.Gov_Direct_Tax(Indice_Households);
	d.Corp_Direct_Tax= -d.Corp_Direct_Tax(Indice_Households);
	
	Gov_social_transfers = Gov_social_transfers(Indice_Households);
	Corp_social_transfers = Corp_social_transfers(Indice_Households);
	Gov_Direct_Tax= - Gov_Direct_Tax(Indice_Households);
	Corp_Direct_Tax= - Corp_Direct_Tax(Indice_Households);
	
	end


// stockage des outputs dans data_"time_step"
execstr("data_"+time_step+" = d;")

// list removal
clear ini d

// Restaure current variable as BY (Static_comparative) or last calculation (Dynamic_projection)
if Resol_Mode == "Static_comparative"
    execstr(fieldnames(BY) + "= BY." + fieldnames(BY) + ";");
    execstr("ini." + fieldnames(BY) +" = BY." + fieldnames(BY) + ";");
end

if Resol_Mode == "Dynamic_projection"
    execstr("ini = data_"+time_step+";")
end

// SAVE Data in a .sav file
if Output_files
    execstr("data = data_"+time_step+";")
    data.Indice_EnerSect=Indice_EnerSect;
    data.Indice_NonEnerSect=Indice_NonEnerSect;
    save(SAVEDIR+"output_"+Name_time+".sav","BY", "data");
    clear data
end
