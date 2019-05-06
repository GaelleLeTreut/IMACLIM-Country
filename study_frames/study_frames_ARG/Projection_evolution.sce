
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// ECONOMIC EQUATIONS for projection
//


////////////////////////////////////// CARBON TAX //////////////////////////////////////
/// Comment for zero carbon tax
// parameters.Carbon_Tax_rate = 3e5;


/////////// ADDITIONAL SETTING FOR HOMOTHETIC PROJECTION////////////////////////////////////////////////////////////////

// - Techniques Asymptotes in production NE PEUT PAS ETRE CHANGER ICI CAR INTERVIENT POUR CALIBRAGE !
// parameters.ConstrainedShare_IC(Indice_EnerSect,:) = parameters.ConstrainedShare_IC(Indice_EnerSect,:);
// parameters.ConstrainedShare_IC(Indice_EnerSect,find(Index_Sectors<> "Composite")) = 0.5*parameters.ConstrainedShare_IC(Indice_EnerSect,find(Index_Sectors<> "Composite"));
// parameters.ConstrainedShare_IC(Indice_EnerSect,find(Index_Sectors== "Composite")) = 0.45*parameters.ConstrainedShare_IC(Indice_EnerSect,find(Index_Sectors== "Composite"));

// - sigma_ConsoBudget = 1
parameters.sigma_ConsoBudget = 1 ; 

// - mettre les ConstrainedShare_C = 0
parameters.ConstrainedShare_C(Indice_EnerSect, :) = 0;

	parameters.sigma_pC = ones(parameters.sigma_pC);
	parameters.sigma_M = ones(parameters.sigma_M);
	parameters.sigma_X = ones(parameters.sigma_X);
	parameters.CarbonTax_Diff_IC = ones(CarbonTax_Diff_IC);





//////////////////////////////////////// SETTING FOR PROJECTION////////////////////////////////////////////////////////////////

// - calculer la Labour_Product (productivité du travail)
parameters.time_period = 20 ;
// parameters.Mu = 1;
// Labour_Product = (1 + parameters.Mu)^time_period ; 


/// GDP in 2015 - thousand of euro 2010 - source : Insee 
GDP_2015 = 2095 * 10^6 ;
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
GDP_rate5 = 1.6 ; // hypothese de continuite
GDP_2050 = GDP_2035*(  GDP_rate5/100 + 1)^(2050-2035) ;
/// GDP unit : thousand of euro 2010


// Labour force  2035 -  units : thousand of people - Source : from INSEE 
Labour_force_2030  = 30143;
Labour_force_2035  = 30122;
Labour_force_2050  = 30784;

Labour_force_proj =  Labour_force_2030 ;
GDP_proj = GDP_2030 ; 

// Estimation du nombre de personnes employées (avec taux de chômage historique) : Labour_force_2035 * ( 1 - u_tot_ref ) ;
// Estimation du nombre d'équivalent temps plein : Labour_force_2035 * ( 1 - u_tot_ref ) * LabourByWorker_coef;

// Labour producitivy level compared to base year - as used in equations
Labour_Product = ( GDP_proj / ini.GDP )  / ( ( Labour_force_proj * ( 1 - ini.u_tot ) * ini.LabourByWorker_coef ) / sum(ini.Labour) ) ;

Deriv_Exogenous.Labour_force =  (Labour_force_proj / sum(ini.Labour_force)) * ini.Labour_force ;

parameters.Mu =  Labour_Product^(1/parameters.time_period) - 1 ;


///////////////////////////////////////////////
//// Demography 
///////////////////////////////////////////////
// Deriv_calib.Population_ref = Population;
/// Population 2035 - in thousand of people - Source: from INSEE ('projection de population à 2070')
Population_2030 = 70281 ; 
/// Population 2035 - in thousand of people - Source: from SNBC 
Population_2035 = 71680 ; 
/// Population 2050 - in thousand of people - Source: from INSEE ('projection de population à 2070')
Population_2050 = 74024 ; 

Population_proj = Population_2030;

Deriv_Exogenous.Population =  (Population_proj / sum(ini.Population)) *ini.Population ;
 
 