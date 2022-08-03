// update carbon tax rate
// parameters.Carbon_Tax_rate = 110000;

// Basic Need  in ktep/UC
BasicNeed = zeros(nb_Sectors,1);
// Put in sectoral parameters 

if AGG_type== 'AGG_4SecB'
BasicNeed(Indice_FinEnerSect) = [0.0001982324600037440, 0.0003789139351315460]';
end
BasicNeed_HH = (BasicNeed .*.ones(1,nb_Households));

// Data for Households are in thousand of people
Coef_HH_unitpeople = 10^3;


 if Recycling_Option=="LSBasicNeed_Exo" 
// Only certain classes of HH are exempted 
	if nb_Households==10
	///No exemption for the 20% richer income classes
		parameters.Exo_HH(1,9:10)=0;
	end 
	
	if unique(Exo_HH) == 1
	warning("Exo_HH == 1 for each HH class ; the model is then running in a equivalent config to the LSBasicNeed options: no exemption for the unique HH")
	end
 end

 if ClosCarbRev <> "ExoAdjTransf"
 	parameters.AdjRecycle = 0;
	BY.AdjRecycle = parameters.AdjRecycle;	
	AdjRecycle = parameters.AdjRecycle;
 end



// sensitivity analysis 
parameters.sigma_X = parameters.sigma_X * (1+strtod(Trade_elast_var));
parameters.sigma_M = parameters.sigma_M * (1+strtod(Trade_elast_var));

if Fix_w == "True"
	parameters.sigma_omegaU = 0;
	parameters.Coef_real_wage = 1;
end

