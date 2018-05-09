// Shocking some parameters default values

//Carbon_Tax_rate0 = 8e4;
//Carbon_Tax_rate1 = 1e5;
//Carbon_Tax_rate2 = 3e5;
//Carbon_Tax_rate3 = 5e5;

//parameters.Carbon_Tax_rate = Carbon_Tax_rate3;
	
// Deriv_Exogenous.ConstrainedShare_C(Indice_EnerSect, :) = 0;
// Deriv_Exogenous.ConstrainedShare_C(Indice_EnerSect, :) = parameters.ConstrainedShare_C(Indice_EnerSect, :)./2;
// Deriv_Exogenous.sigma_pC = parameters.sigma_pC.*3;
// Deriv_Exogenous.sigma_ConsoBudget = 0;
// Deriv_Exogenous.pC = pC *1.2;
// Deriv_Exogenous.sigma_X = parameters.sigma_X/4;
// Deriv_Exogenous.sigma_M = parameters.sigma_M/4;


// Elasticité chomage/salaire
// Elasticité du chomage forte ( -0.1 en reférence)
 // Deriv_Exogenous.sigma_omegaU = -0.8 ;
// Elasticité du chomage faible ( -0.1 en reférence)
// Deriv_Exogenous.sigma_omegaU =parameters.sigma_omegaU/8;


// Potentiel de décarbonisation des entreprises fort : les valeurs doivent directement changer dans les dossiers parametres car ils servent au moment du calibrage
// parameters.ConstrainedShare_IC(Indice_EnerSect, :) = 0.4;
// parameters.sigma = parameters.sigma.*2 ;


// Potentiel de décarbonisation des entreprises faible : les valeurs doivent directement changer dans les dossiers parametres car ils servent au moment du calibrage
// parameters.ConstrainedShare_IC(Indice_EnerSect, :) = 0.9;
// parameters.sigma = parameters.sigma./2 ;

// Potentiel de décarbonisation des menages fort : 
// Deriv_Exogenous.ConstrainedShare_C = parameters.ConstrainedShare_C./2
// Deriv_Exogenous.sigma_pC = parameters.sigma_pC.*2 ;

// Potentiel de décarbonisation des menages faible : 
// Deriv_Exogenous.ConstrainedShare_C = parameters.ConstrainedShare_C.*2
// Deriv_Exogenous.sigma_pC = parameters.sigma_pC./2 ;

