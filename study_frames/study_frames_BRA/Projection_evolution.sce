
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


//////////////////////////////////////// SETTING FOR PROJECTION////////////////////////////////////////////////////////////////

// - calculer la Labour_Product (productivité du travail)
parameters.time_period = 20 ;
// parameters.Mu = 1;
// Labour_Product = (1 + parameters.Mu)^time_period ; 


/// GDP in 2015
GDP_2015 = BY.GDP ;
// From 2016-2030 ( random value for tests) 
GDP_rate1 = 1.6 ;
GDP_2030 = GDP_2015*(  GDP_rate1/100 + 1)^(2030-2015) ; 
/// GDP unit : thousand of reais 2015


// Labour force  2030 -  units : thousand of people - Source : random value for tests
Labour_force_2030  = 30143;

Labour_force_proj =  Labour_force_2030 ;
GDP_proj = GDP_2030 ; 

// Estimation du nombre de personnes employées (avec taux de chômage historique) : Labour_force_2035 * ( 1 - u_tot_ref ) ;
// Estimation du nombre d'équivalent temps plein : Labour_force_2035 * ( 1 - u_tot_ref ) * LabourByWorker_coef;

// Labour producitivy level compared to base year - as used in equations
Labour_Product = ( GDP_proj / BY.GDP )  / ( ( Labour_force_proj * ( 1 - BY.u_tot) * BY.LabourByWorker_coef ) / sum(BY.Labour) ) ;

Deriv_Exogenous.Labour_force =  (Labour_force_proj / sum(BY.Labour_force)) * BY.Labour_force ;

parameters.Mu =  Labour_Product^(1/parameters.time_period) - 1 ;


///////////////////////////////////////////////
//// Demography 
///////////////////////////////////////////////
// Deriv_calib.Population_ref = Population;
/// Population 2030 - in thousand of people - Source: random value for tests
Population_2030 = 228663; 


Population_proj = Population_2030;

Deriv_Exogenous.Population =  (Population_proj / sum(BY.Population)) *BY.Population ;
 
 