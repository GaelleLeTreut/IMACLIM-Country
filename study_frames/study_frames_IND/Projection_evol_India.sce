
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// ECONOMIC EQUATIONS for projection
//

// - mettre les ConstrainedShare_C = 0
//dipti-commenting lines 8, 11; making line 22 from 20 years to 38
//parameters.ConstrainedShare_C(Indice_EnerSect, :) = 0;

// - Techniques Asymptotes in production
//parameters.ConstrainedShare_IC(Indice_EnerSect,:) = parameters.ConstrainedShare_IC(Indice_EnerSect,:);
// parameters.ConstrainedShare_IC(Indice_EnerSect,find(Index_Sectors<> "Composite")) = 0.5*parameters.ConstrainedShare_IC(Indice_EnerSect,find(Index_Sectors<> "Composite"));
// parameters.ConstrainedShare_IC(Indice_EnerSect,find(Index_Sectors== "Composite")) = 0.45*parameters.ConstrainedShare_IC(Indice_EnerSect,find(Index_Sectors== "Composite"));


// - sigma_ConsoBudget = 1
parameters.sigma_ConsoBudget = 1 ; 

// - calculer u_tot

// - calculer la Labour_Product (productivité du travail)
parameters.time_period = 38 ;
// parameters.Mu = 1;
// Labour_Product = (1 + parameters.Mu)^time_period ; 

// parameters.Carbon_Tax_rate = 1e5;

/// GDP in 2015 - thousand of euro 2010 - source : Insee
// Dipti- GDP in 2015 - Lakh Rs- source: India stat
//GDP_2015 = 2095 * 10^6 ;
GDP_2015 = 1224.1434 * 10^6 ;

////// Source: SNBC - Reference scénario (AMS2)
// From 2016-2020 ( adapt to 2015 here) 
GDP_rate1 = 1.6 ;
GDP_2020 = GDP_2015*(  GDP_rate1/100 + 1)^(2020-2015) ; 
// From 2021-2025 
GDP_rate2 = 1.9 ; 
GDP_2025 = GDP_2020*(  GDP_rate2/100 + 1)^(2025-2020) ;
// From 2026-2030 
GDP_rate3 = 1.7 ; 
GDP_2030 = GDP_2025*(  GDP_rate3/100 + 1)^(2030-2025) ;
// From 2031-2035 
GDP_rate4 = 1.6 ;
GDP_2035 = GDP_2030*(  GDP_rate4/100 + 1)^(2035-2030) ;
/// GDP unit : thousand of euro 2010
// Dipti- GDP_rate5 and further added
// From 2036-3040
GDP_rate5 = 1.6 ;
GDP_2040 = GDP_2035*(  GDP_rate5/100 + 1)^(2040-2035) ;
//From 2041-2045
GDP_rate6 = 1.6 ;
GDP_2045 = GDP_2040*(  GDP_rate6/100 + 1)^(2045-2040) ;
// From 2046-2050
GDP_rate6 = 1.6 ;
GDP_2050 = GDP_2045*(  GDP_rate6/100 + 1)^(2050-2045) ;


// Labour force  2035 -  units : thousand of people - Source : from INSEE 
// Dipti changes the labour_force numbers for lines 63 and 64 and added further lines
Labour_force_2030  = 608283;
Labour_force_2035  = 638866;
Labour_force_2040  = 665782;
Labour_force_2045  = 687403;
Labour_force_2050  = 702726;

Labour_force_proj =  Labour_force_2050 ;
GDP_proj = GDP_2050 ; 

// Estimation du nombre de personnes employées (avec taux de chômage historique) : Labour_force_2035 * ( 1 - u_tot_ref ) ;
// Dipti- above translated- Estimated number of persons employed (with historical unemployment rate);
// Estimation du nombre d'équivalent temps plein : Labour_force_2035 * ( 1 - u_tot_ref ) * LabourByWorker_coef;

// Labour producitivy level compared to base year - as used in equations
Labour_Product = ( GDP_proj / ini.GDP )  / ( ( Labour_force_proj * ( 1 - u_tot_ref ) * ini.LabourByWorker_coef ) / sum(ini.Labour) ) ;

Deriv_Exogenous.Labour_force =  (Labour_force_proj / sum(ini.Labour_force)) * ini.Labour_force ;

parameters.Mu =  Labour_Product^(1/parameters.time_period) - 1 ;


// - voir si Distribution_Shares(Indice_Labour_Income, Indice_Households) 
// change


//	Import prices are exogenous but evolve like domestic prices
// pM = pM * Labour_Product

///////////////////////////////////////////////
//// Demography 
///////////////////////////////////////////////
// Deriv_calib.Population_ref = Population;
// Dipti - changing population figures; source UNPD
// Dipti - changing population figures- in thousands of people; source UNPD
/// Population 2035 - in thousand of people - Source: from INSEE ('projection de population à 2070')
Population_2050 = 1705333 ; 
/// Population 2035 - in thousand of people - Source: from SNBC 
//Population_2035 = 71680 ; 

Population_proj = Population_2050;

Deriv_Exogenous.Population =  (Population_proj / sum(ini.Population)) *ini.Population ;
 
// Population_growth_rate = (Population_2035 - initial_value.Population) / initial_value.Population ; 

// Proj : Pop = (1+ delta)^t * popo initial
//	Voir pou pop totele et pop active

/// Number of people by household class
 // Population = Population*(1 + Population_growth_rate)^t ;

 // Retired = Retired*(1 + Retired_growth_rate)^t ; 
 // homothetique : Retired_growth_rate=0
///////////////////////////////////////////////
//// Prices
///////////////////////////////////////////////

// u_tot = u_tot_proj
//	Le taux de chômage n'est plus une variable dans la proj (drop wage curve)
// il faut retirer u_tot des variables du systeme / et retirer la fonction

///////////////////////////////////////////////
//// Final demand
///////////////////////////////////////////////


///////////////////////////////////////////////
//// Production
///////////////////////////////////////////////
// Labour_Product = (1 + Population_growth_rate)^t ;

///////////////////////////////////////////////
//// Trade
///////////////////////////////////////////////



