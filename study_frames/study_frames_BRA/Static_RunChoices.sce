// Shocking some parameters default values

Carbon_Tax_rate0 = 1e5; // 100reais / tCO2 
Carbon_Tax_rate1 = 2e5;
Carbon_Tax_rate2 = 3e5;
Carbon_Tax_rate3 = 5e5;

parameters.Carbon_Tax_rate = Carbon_Tax_rate1;


// u_param a clarifier
parameters.u_param = BY.u_tot;


////  Carbon cap to be informed as a reduction cap (0.2 for 20% of reduction)
// parameters.CarbonCap = 0.2 ;
////  Same reduction cap for each sectors and HH classes
// parameters.CarbonCap_Diff_HH = ones(1, nb_Households);
// parameters.CarbonCap_Diff_sect = ones(1, nb_Sectors);

// Adj_Tax_C = ones(1, nb_Households);
// Adj_Tax_IC = ones(nb_Sectors,1);

// CarbonCap_HH = ones(1, nb_Households);
// CarbonCap_sect = ones(1,nb_Sectors);