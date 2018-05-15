/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// ECONOMIC EQUATIONS for projection

// Somes parameters for homothetic projection
parameters.sigma_pC = ones(parameters.sigma_pC);
parameters.sigma_ConsoBudget = ones(parameters.sigma_ConsoBudget);
parameters.ConstrainedShare_C = zeros(parameters.ConstrainedShare_C);
parameters.sigma_M = ones(parameters.sigma_M);
parameters.sigma_X = ones(parameters.sigma_X);

// Projection 
//parameters.time_since_BY = 0 ;
parameters.time_since_BY = 5 ;
parameters.time_since_ini = parameters.time_since_BY ;

if parameters.time_since_BY == 0
GDP_proj = BY.GDP;
Population_proj = BY.Population;
Labour_force_proj = BY.Labour_force;
end

if parameters.time_since_BY == 5
GDP_proj = 1224.1434 * 10^6 ;
Population_proj = 1323011;
Labour_force_proj = 755148;
end

Labour_Product = ( GDP_proj / ini.GDP )  / ( ( Labour_force_proj * ( 1 - BY.u_tot ) * BY.LabourByWorker_coef ) / sum(BY.Labour) ) ;

Deriv_Exogenous.Labour_force = (Labour_force_proj / sum(BY.Labour_force)) * ini.Labour_force ;
Deriv_Exogenous.Population =  (Population_proj / sum(BY.Population)) *BY.Population ;

if parameters.time_since_BY <> 0
parameters.Mu =  Labour_Product^(1/parameters.time_since_BY) - 1 ;
parameters.phi_L =  ones(parameters.phi_L)*parameters.Mu;
end


