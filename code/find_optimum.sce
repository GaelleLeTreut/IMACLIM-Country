//////////////////////////////////////////////////////////////////////////
// Target and resolutions parameters
//////////////////////////////////////////////////////////////////////////

// Indicateurs macroéconomiques
target.u_tot 				= 0.096657603;
target.NetCompWages_byAgent	= 890.989561480099;
target.CPI 					= 1.0847715321481;
target.Trade_balance		= 54.3722247871991;
target.M_value				= 481.634411627445;
target.X_value				= 427.262186840246;

// Prix de l'énergie 
target.pC 	= [1.35909757603164 1.1176459210912 1.25327047141911 1.27317747456186 1.37781176761594];
target.Indice_HH = [Indice_Gas Indice_HH_Fuels Indice_Elec];
// Gas, Gasoline, diesel, heating_oil, electricity
target.pIC 	= [1.0670943534191	1.21881908084104];
target.Indice_Ind = [Indice_Gas Indice_Elec];
// Gas, electricity

// resolution parameters
opt = optimset ("Display","iter", ..
               "FunValCheck","on", ..
               "MaxFunEvals",200, ..
               "MaxIter",100, ..
               "TolFun",1.e-5, ..
               "TolX",1.e-10);

// SAVEDIR
SAVEDIR_OPT = OUTPUT+"Optimum"+filesep();
mkdir(SAVEDIR_OPT);
mydate = mydate();

//////////////////////////////////////////////////////////////////////////
// init parameters
//////////////////////////////////////////////////////////////////////////

scal_1 = [parameters.Mu ..		 		// Mu
		parameters.u_param .. 			// u_param
		0.0	..	 						// phi_K
		0.0 .. 							// delta_M
		0.0 .. 							// delta_X
		parameters.sigma_omegaU ..		// sigma_omegaU
		parameters.Coef_real_wage ..	// CoefRealWage
		];

scal_2 = [	0.0 1.0 1.0 .. // Gaz
			0.0 1.0 1.0 .. // Elec
			1.0 1.0.. // Coal
		];

scal_3 = [	0.0 0.0 0.0 .. // Fuels cost structure
			1.0 1.0 1.0 .. // Fuels SpeMar_rates_C
			1.0 1.0 1.0 .. // Fuels SpeMar_rates_IC
		];

//////////////////////////////////////////////////////////////////////////
// def main function
//////////////////////////////////////////////////////////////////////////
function [d, parameters, Deriv_Exogenous, target, vMax] = Run(parameters, Deriv_Exogenous, BY, calib, initial_value, scal_1, scal_2, scal_3, target) ;

	// set results of previsous optimisation
	parameters.Mu = scal_1(1);
	parameters.phi_L = ones(Indice_Sectors)*parameters.Mu;
	parameters.u_param = scal_1(2);
	parameters.phi_K = ones(Indice_Sectors)*scal_1(3);
	parameters.sigma_M = zeros(parameters.sigma_M);
	parameters.delta_M_parameter(Indice_NonEnerSect)=ones(parameters.delta_M_parameter(Indice_NonEnerSect))*scal_1(4);
	parameters.sigma_X = zeros(parameters.sigma_X);
	parameters.delta_X_parameter(Indice_NonEnerSect)=ones(parameters.delta_X_parameter(Indice_NonEnerSect))*scal_1(5);
	parameters.sigma_omegaU = scal_1(6);
	parameters.Coef_real_wage = scal_1(7);

	// init SpeMarg
	Deriv_Exogenous.SpeMarg_rates_C 	= BY.SpeMarg_rates_C;
	Deriv_Exogenous.SpeMarg_rates_IC 	= BY.SpeMarg_rates_IC;

	// Gaz
	parameters.phi_K(Indice_Gas) 		= scal_2(1);
	parameters.phi_L(Indice_Gas)	= scal_2(1);
	parameters.phi_IC(Indice_NonEnerSect,Indice_Gas) = ones(size(Indice_NonEnerSect,2),size(Indice_Gas,1))*scal_2(1);
	Deriv_Exogenous.SpeMarg_rates_C(Indice_Gas)		= scal_2(2) * Deriv_Exogenous.SpeMarg_rates_C(Indice_Gas);
	Deriv_Exogenous.SpeMarg_rates_IC(:,Indice_Gas)	= scal_2(3) * Deriv_Exogenous.SpeMarg_rates_IC(:,Indice_Gas);

	// Électricité
	parameters.phi_K(Indice_Elec) 	= scal_2(4);
	parameters.phi_L(Indice_Elec)	= scal_2(4);
	parameters.phi_IC(Indice_NonEnerSect,Indice_Elec) = ones(size(Indice_NonEnerSect,2),size(Indice_Elec,1))*scal_2(4);
	Deriv_Exogenous.SpeMarg_rates_C(Indice_Elec)		= scal_2(5) * Deriv_Exogenous.SpeMarg_rates_C(Indice_Elec);
	Deriv_Exogenous.SpeMarg_rates_IC(:,Indice_Elec)	= scal_2(6) * Deriv_Exogenous.SpeMarg_rates_IC(:,Indice_Elec);

	// Crude_coal 
	Deriv_Exogenous.SpeMarg_rates_C(3)	= scal_2(7) * Deriv_Exogenous.SpeMarg_rates_C(3);
	Deriv_Exogenous.SpeMarg_rates_IC(:,3)	= scal_2(8) * Deriv_Exogenous.SpeMarg_rates_IC(:,3);

	// Fuels 
	parameters.phi_K(Indice_HH_Fuels) 	= [scal_3(1), scal_3(2), scal_3(3)];
	parameters.phi_L(Indice_HH_Fuels)	= [scal_3(1), scal_3(2), scal_3(3)];
	parameters.phi_IC(Indice_NonEnerSect,Indice_HH_Fuels) = ones(Indice_NonEnerSect').*.[scal_3(1), scal_3(2), scal_3(3)];
	Deriv_Exogenous.SpeMarg_rates_C(Indice_HH_Fuels)	= Deriv_Exogenous.SpeMarg_rates_C(Indice_HH_Fuels).*[scal_3(4), scal_3(5), scal_3(6)];
	Deriv_Exogenous.SpeMarg_rates_IC(:,Indice_HH_Fuels)	= Deriv_Exogenous.SpeMarg_rates_IC(:,Indice_HH_Fuels).*(ones(Indice_Sectors').*.[scal_3(7), scal_3(8), scal_3(9)]);

	exec('Order_resolution.sce');
    exec('Resolution.sce');

endfunction 

//////////////////////////////////////////////////////////////////////////
// def optim functions
//////////////////////////////////////////////////////////////////////////

// macro indicators
function [y] = System_optimisation_1(scal_1)

	[d, parameters, Deriv_Exogenous, target, vMax] = Run(parameters, Deriv_Exogenous, BY, calib, initial_value, scal_1, scal_2, scal_3, target);

	y1 = [100*abs(((d.GDP/d.GDP_pFish)/BY.GDP - GDP_index(time_step))/GDP_index(time_step)) ..
		100*abs(d.u_tot/target.u_tot - 1) ..
		100*abs(d.NetCompWages_byAgent(Indice_Households)*1E-6/target.NetCompWages_byAgent - 1) ..	
		100*abs(d.CPI/target.CPI - 1) .. 
		100*abs(sum(d.pM.*d.M)*1E-6/target.M_value - 1).. 
		100*abs(sum(d.pX.*d.X)*1E-6/target.X_value - 1).. 
		100*abs((sum(d.pM.*d.M) - sum(d.pX.*d.X))*1E-6/target.Trade_balance - 1)..
		vMax..
		];

	y = norm(y1);

endfunction

// Gas, Elec and coal prices
function [y] = System_optimisation_2(scal_2)

	[d, parameters, Deriv_Exogenous, target, vMax] = Run(parameters, Deriv_Exogenous, BY, calib, initial_value, scal_1, scal_2, scal_3, target) ;

	mean_pIC_proj	= (sum(d.pIC([Indice_Gas Indice_Elec],:).*d.IC([Indice_Gas Indice_Elec],:),"c")./sum(d.IC([Indice_Gas Indice_Elec],:),"c"));
	mean_pIC_BY		= (sum(BY.pIC([Indice_Gas Indice_Elec],:).*BY.IC([Indice_Gas Indice_Elec],:),"c")./sum(BY.IC([Indice_Gas Indice_Elec],:),"c"));

	y1 = [100*abs(d.pC([Indice_Gas Indice_Elec])./(BY.pC([Indice_Gas Indice_Elec]) .* target.pC([1 5])') - 1)' ..
		100*abs(mean_pIC_proj./(mean_pIC_BY .* target.pIC') - 1)' ..
		100*abs(sum(d.SpeMarg_IC,"r") + d.SpeMarg_C + d.SpeMarg_X + d.SpeMarg_G + d.SpeMarg_I)./(d.pY.*d.Y + d.pM.*pM)'..
		vMax..	
		];

	y = norm(y1);

endfunction

// Fuel prices
function [y] = System_optimisation_3(scal_3)

	[d, parameters, Deriv_Exogenous, target, vMax] = Run(parameters, Deriv_Exogenous, BY, calib, initial_value, scal_1, scal_2, scal_3, target) ;

	mean_pIC_proj	= (sum(d.pIC(Indice_HH_Fuels,:).*d.IC(Indice_HH_Fuels,:),"c")./sum(d.IC(Indice_HH_Fuels,:),"c"));
	mean_pIC_BY		= (sum(BY.pIC(Indice_HH_Fuels,:).*BY.IC(Indice_HH_Fuels,:),"c")./sum(BY.IC(Indice_HH_Fuels,:),"c"));

	y1 = [100*abs(d.pC(Indice_HH_Fuels)./(BY.pC(Indice_HH_Fuels) .* target.pC(2:4)') - 1)' ..
		100*abs(sum(d.SpeMarg_IC,"r") + d.SpeMarg_C + d.SpeMarg_X + d.SpeMarg_G + d.SpeMarg_I)./(d.pY.*d.Y + d.pM.*pM)'..
		vMax..	
		];

	y = norm(y1);

endfunction

//////////////////////////////////////////////////////////////////////////
// run nested optimization process
//////////////////////////////////////////////////////////////////////////

if Optimum_Recal

	diary(SAVEDIR_OPT+ mydate + "_summary" + ".log");

	for elt=1:10

	printf("--------------------------- \n");
	printf("Start loop: " + elt + " \n");
	printf("--------------------------- \n");

	[scal_opt_1, fval, exitflag, output] = fminsearch(System_optimisation_1, scal_1, opt);
	csvWrite(scal_opt_1,SAVEDIR_OPT+ mydate() + "_scal_1" + ".csv", ';');

	scal_1 = scal_opt_1;

	printf("--------------------------- \n");

	[scal_opt_2, fval, exitflag, output] = fminsearch(System_optimisation_2, scal_2, opt);
	csvWrite(scal_opt_2,SAVEDIR_OPT+ mydate() + "_scal_2" + ".csv", ';');

	scal_2 = scal_opt_2;

	printf("--------------------------- \n");


	[scal_opt_3, fval, exitflag, output] = fminsearch(System_optimisation_3, scal_3, opt);
	csvWrite(scal_opt_3,SAVEDIR_OPT+ mydate() + "_scal_3" + ".csv", ';');

	scal_3 = scal_opt_3;

	end

	diary(0);
	print(out,"abort because of you choose to run an optimisation")
	abort
end

//////////////////////////////////////////////////////////////////////////
// Idea to update
//////////////////////////////////////////////////////////////////////////

// améliorer les choses pour avoir le nom des variables et afficher la convergence des paramètres
// idée sup: supprimer l'hybridation des biens non énergétiques pour l'instant : simplification
// ajouter une contrainte généraliser sur tous les biens hybridés Indice_HybridCommod
// Unique cible non atteinte : NetCompWages_byAgent. 10% inférieures...
// Vérifier les données d'entrée 
// possibilité de le caler autrement ? Impact sur le système ? 
// utiliser une désagrégation à 10 classes de ménages + fonction KLEMS de production ? 