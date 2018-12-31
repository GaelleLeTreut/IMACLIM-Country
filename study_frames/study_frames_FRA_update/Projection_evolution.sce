
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
Labour_Product = ( GDP_proj / ini.GDP )  / ( ( Labour_force_proj * ( 1 - u_tot_ref ) * ini.LabourByWorker_coef ) / sum(ini.Labour) ) ;

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
 
 ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////// SETTING FOR ECOPA////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

/// Implementation of technical progress for energy (use of Technical_Coef_Const_6 )  
 // Coef_Phi_Sec = 1;
 // Coef_Phi_Sec = 1.3;
 
// sigma_ConsoBudget_ECOPA = ones(nb_SecExcepComp,1) ;
// sigma_pC_ECOPA = ones(nb_SecExcepComp,1);
 
 // sigma_ConsoBudget_ECOPA = [ 1.084402893, 1.084402893, 1.084402893, 0.758328504, 1.084402893, 0.758328504, 1.084402893, 1.084402893, 1.12943496, 1.12943496, 1.12943496, 1.12943496, 1.12943496, 1.12943496, 1.12943496, 1.12943496, 1.12943496, 0.689792179, 0.88936357, 0.88936357]';
 
 // sigma_pC_ECOPA = [ -0.335325014, -0.335325014, -0.335325014, -0.107069748, -0.335325014, -0.107069748, -0.335325014, -0.335325014, -2.035693589, -2.035693589, -2.035693589, -2.035693589, -2.035693589, -2.035693589, -2.035693589, -2.035693589, -2.035693589, -0.527671536, -0.351294309, -0.351294309]';
 
 ////////////////////////////////////////////////////////////////////////////
 ///// IF SPLIT OF COMPOSITE GOOD 
 ///  MANU work for data
 //	Split Composite good between 'Equipment', 'Services', 'Housing', 'Clothes' - Assumption: Same price variations
	// Index_Composite = find(Index_Sectors=="Composite");

	//	Split Composite good between 'Equipment', 'Services', 'Housing', 'Clothes'
	// Share_Equipment =0.0901181055265676;
	// Share_Housing = 0.317922725256654;
	// Share_Clothes = 0.0617566678808701;
	// Share_Services =0.530202501335908;
	
	// Dist_Key_Equipment = [0.037049098, 0.045223947, 0.056224223, 0.071515967, 0.079632841, 0.096164605, 0.10975515, 0.131128824, 0.151478232, 0.221827114];
	// Dist_Key_Housing = [0.084333393, 0.085679651, 0.099748153, 0.100921577, 0.100887633, 0.104057244, 0.104291792, 0.096893149, 0.103970594, 0.119216814];
	// Dist_Key_Clothes = [0.066847629, 0.073917207, 0.077900571, 0.087042461, 0.093510198, 0.100374035, 0.102941799, 0.116803251, 0.128168497, 0.152494353];
	// Dist_Key_Services = [0.055500156, 0.060961752, 0.067590362, 0.079162623, 0.084677738, 0.094898549, 0.107180513, 0.123704834, 0.137370179, 0.188953294];
	
	// sigma_ConsoBudget_ECOPA = [ 1.084402893, 1.084402893, 1.084402893, 0.758328504, 1.084402893, 0.758328504, 1.084402893, 1.084402893, 1.12943496, 1.12943496, 1.12943496, 1.12943496, 1.12943496, 1.12943496, 1.12943496, 1.12943496, 1.12943496, 0.689792179, 0.88936357, 0.88936357, 1.12943496, 1.294048831, 0.88936357, 1.002712465 ]';
	
	// sigma_pC_ECOPA = [ -0.335325014, -0.335325014, -0.335325014, -0.107069748, -0.335325014, -0.107069748, -0.335325014, -0.335325014, -2.035693589, -2.035693589, -2.035693589, -2.035693589, -2.035693589, -2.035693589, -2.035693589, -2.035693589, -2.035693589, -0.527671536, -0.351294309, -0.351294309, -2.035693589, -0.448632393, -0.351294309, -0.421581356 ]';
 

