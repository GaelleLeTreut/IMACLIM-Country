/////////////////////////////////////////////////////////////////////////////////////////////
// Variable stockage for several time steps calculation (Static_comparative or Dynamic_projection)
/////////////////////////////////////////////////////////////////////////////////////////////

// Put back some variables to "equation" from EcoT formats due to "outputs.sce"
if Output_files=="True"
	d.Pensions=Pensions(Indice_Households);
	d.Unemployment_transfers=Unemployment_transfers(Indice_Households);
	d.GFCF_byAgent(Indice_RestOfWorld)=[];
	d.Income_Tax = -Income_Tax(Indice_Households);
	d.Other_Direct_Tax = -Other_Direct_Tax(Indice_Households);
	d.Other_social_transfers = Other_social_transfers(Indice_Households);
	d.Corporate_Tax = - Corporate_Tax(Indice_Corporations);

	Pensions=Pensions(Indice_Households);
	Unemployment_transfers=Unemployment_transfers(Indice_Households);
	GFCF_byAgent(Indice_RestOfWorld)=[];
	Income_Tax = -Income_Tax(Indice_Households);
	Other_Direct_Tax = -Other_Direct_Tax(Indice_Households);
	Other_social_transfers = Other_social_transfers(Indice_Households);
	Corporate_Tax = - Corporate_Tax(Indice_Corporations);
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
