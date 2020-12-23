function [d, parameters, Deriv_Exogenous, target, vMax] = GDP_calculation(parameters, Deriv_Exogenous, BY, calib, initial_value, scal, target) ;
	// Indicateurs macroéconomiques

	parameters.Mu = scal(1);
	parameters.phi_L = ones(Indice_Sectors)*parameters.Mu;
	parameters.u_param = scal(2);
	parameters.phi_K = ones(Indice_Sectors)*scal(3);
	parameters.sigma_M = zeros(parameters.sigma_M);
	parameters.delta_M_parameter(Indice_NonEnerSect)=ones(parameters.delta_M_parameter(Indice_NonEnerSect))*scal(4);
	parameters.sigma_X = zeros(parameters.sigma_X);
	parameters.delta_X_parameter(Indice_NonEnerSect)=ones(parameters.delta_X_parameter(Indice_NonEnerSect))*scal(5);
	parameters.sigma_omegaU = scal(6);
	parameters.Coef_real_wage = scal(7);

	// Energy prices (Gaz, AllFuels & Elec)
	parameters.phi_K(target.pIndice) = [scal(8) scal(9) scal(10) scal(11) scal(12) scal(13)]; // scal(8:13) ne fonctionne pas !! 
	parameters.phi_L(target.pIndice)= [scal(8) scal(9) scal(10) scal(11) scal(12) scal(13)];
	parameters.phi_IC = zeros(parameters.phi_IC);
	parameters.phi_IC(Indice_NonEnerSect,target.pIndice) = ones(Indice_NonEnerSect)'.*.[scal(8) scal(9) scal(10) scal(11) scal(12) scal(13)];

	// marge spécifiques 
	// Deriv_Exogenous.SpeMarg_rates_C = BY.SpeMarg_rates_C;
	// Deriv_Exogenous.SpeMarg_rates_C(target.pIndice) = BY.SpeMarg_rates_C(target.pIndice).*[scal(8) scal(9) scal(10) scal(11) scal(12) scal(13)];
	//Deriv_Exogenous.SpeMarg_rates_X = BY.SpeMarg_rates_X;
	//Deriv_Exogenous.SpeMarg_rates_X(4) = BY.SpeMarg_rates_X(4)*scal(9);

	exec('Order_resolution.sce');
    exec('Resolution.sce');
endfunction 

// target definition 
target.u_tot 				= 0.096657603;
target.NetCompWages_byAgent	= 890.989561480099;
target.CPI 					= 1.0847715321481;
target.Trade_balance		= 54.3722247871991;
target.M_value				= 481.634411627445;
target.X_value				= 427.262186840246;
target.pC 	= [1.35909757603164 1.1176459210912 1.11302943713353 	1.25327047141911 	1.27317747456186 	1.37781176761594];
target.pIC 	= [1.0670943534191	1.1176459210912	1.11302943713353	1.25327047141911	1.27317747456186	1.21881908084104];
target.pIndice = [Indice_Gas Indice_HH_Fuels Indice_Elec];

scal = 	[parameters.Mu ..		 		// Mu
		parameters.u_param .. 			// u_param
		0.0	..	 						// phi_K
		0.0 .. 							// delta_M
		0.0 .. 							// delta_X
		parameters.sigma_omegaU ..		// sigma_omegaU
		parameters.Coef_real_wage ..	// CoefRealWage
		zeros(target.pIndice) ..	 		// pEnergy
		];

scal = [0.014725924879305	0.063189084404377..
		0.085212809595301..
		-0.025874271040464	-0.00904627082802..
		-0.303888244477148	1.10414282556564..
		zeros(target.pIndice) ..	 		// pEnergy
		];

scal = [0.014207232778997	0.063652928254141..
		0.075281522183383..
		-0.025829094138012	-0.010488090114064..
		-0.34883119763128	1.32021704250158..
		0.044027632574246	0.080679567192271	-0.120100194903922	-0.092706726915264	0.007908987291204	-0.008570056452083];

scal = [0.013479938172368	0.066173868682517..
		0.073686756678932..
		-0.025367784169615	-0.011498859862948..
		-0.559467206301469	2.01946027534565..
		0.062191070802509	0.014532244560709	-0.133449359806118	-0.141765614263338	-0.001338020171661	-0.016776238930613];

function [y] = System_optimisation(scal)
	[d, parameters, Deriv_Exogenous, target, vMax] = GDP_calculation(parameters, Deriv_Exogenous, BY, calib, initial_value, scal, target);

	mean_pIC_proj 	= (sum(d.pIC(target.pIndice,:).*d.IC(target.pIndice,:),"c")./sum(d.IC(target.pIndice,:),"c"));
	mean_pIC_BY		= (sum(BY.pIC(target.pIndice,:).*BY.IC(target.pIndice,:),"c")./sum(BY.IC(target.pIndice,:),"c"));

	y1 = [100*abs(((d.GDP/d.GDP_pFish)/BY.GDP - GDP_index(time_step))/GDP_index(time_step)) ..
		100*abs(d.u_tot/target.u_tot - 1) ..
		100*abs(d.NetCompWages_byAgent(Indice_Households)*1E-6/target.NetCompWages_byAgent - 1) ..	
		100*abs(d.CPI/target.CPI - 1) .. 
		100*abs(sum(d.pM.*d.M)*1E-6/target.M_value - 1).. 
		100*abs(sum(d.pX.*d.X)*1E-6/target.X_value - 1).. 
		100*abs((sum(d.pM.*d.M) - sum(d.pX.*d.X))*1E-6/target.Trade_balance - 1)..
		100*abs(d.pC(target.pIndice)./(BY.pC(target.pIndice) .* target.pC') - 1)' ..
		100*abs(mean_pIC_proj./(mean_pIC_BY .* target.pIC') - 1)' ..
		vMax..	
		];
	y = norm(y1);
endfunction

opt = optimset ("Display","iter", ..
               "FunValCheck","on", ..
               "MaxFunEvals",500, ..
               "MaxIter",300, ..
               "TolFun",1.e-5, ..
               "TolX",1.e-10);

[scal_opt_1, fval, exitflag, output] = fminsearch(System_optimisation, scal, opt);


SAVEDIR_OPT = OUTPUT+"Optimum"+filesep();
mkdir(SAVEDIR_OPT);
csvWrite(scal_opt_1,SAVEDIR_OPT+"scal_opt_" + BY_Recal + ".csv", ';');

print(out,"abort because of you choose to run an optimisation")
abort
scal = scal_opt_1;