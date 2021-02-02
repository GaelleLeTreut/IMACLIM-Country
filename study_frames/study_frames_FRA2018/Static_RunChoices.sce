// update carbon tax rate
parameters.Carbon_Tax_rate = 150000;

// Basic Need  in ktep/UC
BasicNeed = zeros(nb_Sectors,1);
// Put in sectoral parameters 

BasicNeed(Indice_FinEnerSect) = [0.0001982324600037440, 0.0003789139351315460]';
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
 
