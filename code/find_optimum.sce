//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// Target and resolutions parameters
//////////////////////////////////////////////////////////////////////////

// Indicateurs macroéconomiques
target.u_tot 				= 0.096657603;
target.NetCompWages_byAgent	= 903.255;
target.CPI 					= 1.0847715321481;
target.Trade_balance		= 24.572;
target.M_value				= 773.362;
target.X_value				= 748.79;

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
               "MaxFunEvals",300, ..
               "MaxIter",150, ..
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

scal_2 = [0.0 1.0 1.0 .. // elec
		0.0 1.0 1.0 .. // Gaz
		];  //

scal_3 = [0.0 0.0 0.0 .. //Fuels cost structure
		1.0 1.0 1.0 .. 	// Fuels SpeMarg
		1.0 1.0 1.0 .. 	// Fuels SpeMarg
		]; // 
		
scal_4 =[ones(Indice_OtherEner) ones(Indice_OtherEner)]; // other SpeMarg

// scals
scal_1 = [0.003445295389303	0.113321491404601	-0.107704736198401	0.056906796418956	0.050549191290381	-0.135757269399127	1.10517753037372];
scal_2 = [0.106764001773717	1.8400276428314	1.07095238220527	-0.000107473660823	2.17277703077935	1.42663104601224];
scal_3 = [0.02330359757791	-0.125596610044839	-0.153493337720825	0.054288574551023	1.47133758111109	1.13993880083635	0.117584537166667	2.20653628738035	2.06967852706102];
scal_4 = [1.0708544301228	0.401406203524259	1.14595141268998	1.34759886367218	1.11835881110889	1.17952951977283	1.25974269548617	1.41998910093386	1.06957016813065	1.40430257823024	0.90192874551227	0.932465953846021	1.17692683652303	0.097058400778571];

//////////////////////////////////////////////////////////////////////////
// def main function
//////////////////////////////////////////////////////////////////////////
function [d, parameters, Deriv_Exogenous, target, vMax] = Run(parameters, Deriv_Exogenous, BY, calib, initial_value, scal_1, scal_2, scal_3, scal_4, target) ;

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
	Deriv_Exogenous.SpeMarg_rates_G 	= BY.SpeMarg_rates_G;
	Deriv_Exogenous.SpeMarg_rates_I 	= BY.SpeMarg_rates_I;
	Deriv_Exogenous.SpeMarg_rates_X 	= BY.SpeMarg_rates_X;
	Deriv_Exogenous.SpeMarg_rates_IC 	= BY.SpeMarg_rates_IC;

	// Gaz
	parameters.phi_K(Indice_Gas) 		= scal_2(1);
	parameters.phi_L(Indice_Gas)	= scal_2(1);
	parameters.phi_IC(Indice_NonEnerSect,Indice_Gas) = ones(size(Indice_NonEnerSect,2),size(Indice_Gas,1))*scal_2(1);
	Deriv_Exogenous.SpeMarg_rates_C(Indice_Gas)	= BY.SpeMarg_rates_C(Indice_Gas) .* [(BY.SpeMarg_rates_C(Indice_Gas) >= 0).*scal_2(2) + (BY.SpeMarg_rates_C(Indice_Gas) < 0).*scal_2(3)];
	Deriv_Exogenous.SpeMarg_rates_G(Indice_Gas)	= BY.SpeMarg_rates_G(Indice_Gas) .* [(BY.SpeMarg_rates_G(Indice_Gas) >= 0).*scal_2(2) + (BY.SpeMarg_rates_G(Indice_Gas) < 0).*scal_2(3)];
	Deriv_Exogenous.SpeMarg_rates_I(Indice_Gas)	= BY.SpeMarg_rates_I(Indice_Gas) .* [(BY.SpeMarg_rates_I(Indice_Gas) >= 0).*scal_2(2) + (BY.SpeMarg_rates_I(Indice_Gas) < 0).*scal_2(3)];
	Deriv_Exogenous.SpeMarg_rates_X(Indice_Gas)	= BY.SpeMarg_rates_X(Indice_Gas) .* [(BY.SpeMarg_rates_X(Indice_Gas) >= 0).*scal_2(2) + (BY.SpeMarg_rates_X(Indice_Gas) < 0).*scal_2(3)];
	Deriv_Exogenous.SpeMarg_rates_IC(:,Indice_Gas)= BY.SpeMarg_rates_IC(:,Indice_Gas).*[(BY.SpeMarg_rates_IC(:,Indice_Gas) >= 0).*(ones(Indice_Sectors').*.scal_2(2)) + (BY.SpeMarg_rates_IC(:,Indice_Gas) < 0).*(ones(Indice_Sectors').*.scal_2(3))];

	// Électricité
	parameters.phi_K(Indice_Elec) 	= scal_2(4);
	parameters.phi_L(Indice_Elec)	= scal_2(4);
	parameters.phi_IC(Indice_NonEnerSect,Indice_Elec) = ones(size(Indice_NonEnerSect,2),size(Indice_Elec,1))*scal_2(4);
	Deriv_Exogenous.SpeMarg_rates_C(Indice_Elec)	= BY.SpeMarg_rates_C(Indice_Elec) .* [(BY.SpeMarg_rates_C(Indice_Elec) >= 0).*scal_2(5) + (BY.SpeMarg_rates_C(Indice_Elec) < 0).*scal_2(6)];
	Deriv_Exogenous.SpeMarg_rates_G(Indice_Elec)	= BY.SpeMarg_rates_G(Indice_Elec) .* [(BY.SpeMarg_rates_G(Indice_Elec) >= 0).*scal_2(5) + (BY.SpeMarg_rates_G(Indice_Elec) < 0).*scal_2(6)];
	Deriv_Exogenous.SpeMarg_rates_I(Indice_Elec)	= BY.SpeMarg_rates_I(Indice_Elec) .* [(BY.SpeMarg_rates_I(Indice_Elec) >= 0).*scal_2(5) + (BY.SpeMarg_rates_I(Indice_Elec) < 0).*scal_2(6)];
	Deriv_Exogenous.SpeMarg_rates_X(Indice_Elec)	= BY.SpeMarg_rates_X(Indice_Elec) .* [(BY.SpeMarg_rates_X(Indice_Elec) >= 0).*scal_2(5) + (BY.SpeMarg_rates_X(Indice_Elec) < 0).*scal_2(6)];
	Deriv_Exogenous.SpeMarg_rates_IC(:,Indice_Elec)= BY.SpeMarg_rates_IC(:,Indice_Elec).*[(BY.SpeMarg_rates_IC(:,Indice_Elec) >= 0).*(ones(Indice_Sectors').*.scal_2(5)) + (BY.SpeMarg_rates_IC(:,Indice_Elec) < 0).*(ones(Indice_Sectors').*.scal_2(6))];

	// Fuels 
	parameters.phi_K(Indice_HH_Fuels) 	= [scal_3(1), scal_3(2), scal_3(3)];
	parameters.phi_L(Indice_HH_Fuels)	= [scal_3(1), scal_3(2), scal_3(3)];
	parameters.phi_IC(Indice_NonEnerSect,Indice_HH_Fuels) = ones(Indice_NonEnerSect').*.[scal_3(1), scal_3(2), scal_3(3)];
	Deriv_Exogenous.SpeMarg_rates_C(Indice_HH_Fuels)	= BY.SpeMarg_rates_C(Indice_HH_Fuels) .* [(BY.SpeMarg_rates_C(Indice_HH_Fuels) >= 0).*[scal_3(4), scal_3(5), scal_3(6)] + (BY.SpeMarg_rates_C(Indice_HH_Fuels) < 0).*[scal_3(7), scal_3(8), scal_3(9)]];
	Deriv_Exogenous.SpeMarg_rates_G(Indice_HH_Fuels)	= BY.SpeMarg_rates_G(Indice_HH_Fuels) .* [(BY.SpeMarg_rates_G(Indice_HH_Fuels) >= 0).*[scal_3(4), scal_3(5), scal_3(6)] + (BY.SpeMarg_rates_G(Indice_HH_Fuels) < 0).*[scal_3(7), scal_3(8), scal_3(9)]];
	Deriv_Exogenous.SpeMarg_rates_I(Indice_HH_Fuels)	= BY.SpeMarg_rates_I(Indice_HH_Fuels) .* [(BY.SpeMarg_rates_I(Indice_HH_Fuels) >= 0).*[scal_3(4), scal_3(5), scal_3(6)] + (BY.SpeMarg_rates_I(Indice_HH_Fuels) < 0).*[scal_3(7), scal_3(8), scal_3(9)]];
	Deriv_Exogenous.SpeMarg_rates_X(Indice_HH_Fuels)	= BY.SpeMarg_rates_X(Indice_HH_Fuels) .* [(BY.SpeMarg_rates_X(Indice_HH_Fuels) >= 0).*[scal_3(4), scal_3(5), scal_3(6)] + (BY.SpeMarg_rates_X(Indice_HH_Fuels) < 0).*[scal_3(7), scal_3(8), scal_3(9)]];
	Deriv_Exogenous.SpeMarg_rates_IC(:,Indice_HH_Fuels) = BY.SpeMarg_rates_IC(:,Indice_HH_Fuels).*[(BY.SpeMarg_rates_IC(:,Indice_HH_Fuels) >= 0).*(ones(Indice_Sectors').*.[scal_3(4), scal_3(5), scal_3(6)]) + (BY.SpeMarg_rates_IC(:,Indice_HH_Fuels) < 0).*(ones(Indice_Sectors').*.[scal_3(7), scal_3(8), scal_3(9)])];

	//other energ
	Deriv_Exogenous.SpeMarg_rates_C(Indice_OtherEner)	= BY.SpeMarg_rates_C(Indice_OtherEner) .* [(BY.SpeMarg_rates_C(Indice_OtherEner) >= 0).*[scal_4(1) scal_4(2) scal_4(3) scal_4(4) scal_4(5) scal_4(6) scal_4(7)] + (BY.SpeMarg_rates_C(Indice_OtherEner) < 0).*[scal_4(8) scal_4(9) scal_4(10) scal_4(11) scal_4(12) scal_4(13) scal_4(14)]];
	Deriv_Exogenous.SpeMarg_rates_G(Indice_OtherEner)	= BY.SpeMarg_rates_G(Indice_OtherEner) .* [(BY.SpeMarg_rates_G(Indice_OtherEner) >= 0).*[scal_4(1) scal_4(2) scal_4(3) scal_4(4) scal_4(5) scal_4(6) scal_4(7)] + (BY.SpeMarg_rates_G(Indice_OtherEner) < 0).*[scal_4(8) scal_4(9) scal_4(10) scal_4(11) scal_4(12) scal_4(13) scal_4(14)]];
	Deriv_Exogenous.SpeMarg_rates_I(Indice_OtherEner)	= BY.SpeMarg_rates_I(Indice_OtherEner) .* [(BY.SpeMarg_rates_I(Indice_OtherEner) >= 0).*[scal_4(1) scal_4(2) scal_4(3) scal_4(4) scal_4(5) scal_4(6) scal_4(7)] + (BY.SpeMarg_rates_I(Indice_OtherEner) < 0).*[scal_4(8) scal_4(9) scal_4(10) scal_4(11) scal_4(12) scal_4(13) scal_4(14)]];
	Deriv_Exogenous.SpeMarg_rates_X(Indice_OtherEner)	= BY.SpeMarg_rates_X(Indice_OtherEner) .* [(BY.SpeMarg_rates_X(Indice_OtherEner) >= 0).*[scal_4(1) scal_4(2) scal_4(3) scal_4(4) scal_4(5) scal_4(6) scal_4(7)] + (BY.SpeMarg_rates_X(Indice_OtherEner) < 0).*[scal_4(8) scal_4(9) scal_4(10) scal_4(11) scal_4(12) scal_4(13) scal_4(14)]];
	Deriv_Exogenous.SpeMarg_rates_IC(:,Indice_OtherEner)= BY.SpeMarg_rates_IC(:,Indice_OtherEner).*[..
		(BY.SpeMarg_rates_IC(:,Indice_OtherEner) >= 0).*(ones(Indice_Sectors').*.[scal_4(1) scal_4(2) scal_4(3) scal_4(4) scal_4(5) scal_4(6) scal_4(7)]) + ..
		(BY.SpeMarg_rates_IC(:,Indice_OtherEner) < 0).*(ones(Indice_Sectors').*.[scal_4(8) scal_4(9) scal_4(10) scal_4(11) scal_4(12) scal_4(13) scal_4(14)]) ..
		];

	exec('Order_resolution.sce');
    exec('Resolution.sce');

endfunction 

//////////////////////////////////////////////////////////////////////////
// def optim functions
//////////////////////////////////////////////////////////////////////////

// macro indicators
function [y] = System_optimisation_1(scal_1)

	[d, parameters, Deriv_Exogenous, target, vMax] = Run(parameters, Deriv_Exogenous, BY, calib, initial_value, scal_1, scal_2, scal_3, scal_4, target);

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

	[d, parameters, Deriv_Exogenous, target, vMax] = Run(parameters, Deriv_Exogenous, BY, calib, initial_value, scal_1, scal_2, scal_3, scal_4, target) ;

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

	[d, parameters, Deriv_Exogenous, target, vMax] = Run(parameters, Deriv_Exogenous, BY, calib, initial_value, scal_1, scal_2, scal_3, scal_4, target) ;

	mean_pIC_proj	= (sum(d.pIC(Indice_HH_Fuels,:).*d.IC(Indice_HH_Fuels,:),"c")./sum(d.IC(Indice_HH_Fuels,:),"c"));
	mean_pIC_BY		= (sum(BY.pIC(Indice_HH_Fuels,:).*BY.IC(Indice_HH_Fuels,:),"c")./sum(BY.IC(Indice_HH_Fuels,:),"c"));

	y1 = [100*abs(d.pC(Indice_HH_Fuels)./(BY.pC(Indice_HH_Fuels) .* target.pC(2:4)') - 1)' ..
		100*abs(sum(d.SpeMarg_IC,"r") + d.SpeMarg_C + d.SpeMarg_X + d.SpeMarg_G + d.SpeMarg_I)./(d.pY.*d.Y + d.pM.*pM)'..
		vMax..	
		];

	y = norm(y1);

endfunction

// Other energy prices 
function [y] = System_optimisation_4(scal_4)

	[d, parameters, Deriv_Exogenous, target, vMax] = Run(parameters, Deriv_Exogenous, BY, calib, initial_value, scal_1, scal_2, scal_3, scal_4, target) ;

	y1 = [100*abs(sum(d.SpeMarg_IC,"r") + d.SpeMarg_C + d.SpeMarg_X + d.SpeMarg_G + d.SpeMarg_I)./(d.pY.*d.Y + d.pM.*pM)'..
		vMax..	
		];

	y = norm(y1);

endfunction

//////////////////////////////////////////////////////////////////////////
// run nested optimization process
//////////////////////////////////////////////////////////////////////////

if Optimum_Recal

	Nb_iter = 4;

	scal_out_1 = ones(Nb_iter, size(scal_1,2)+1);
	scal_out_2 = ones(Nb_iter, size(scal_2,2)+1);
	scal_out_3 = ones(Nb_iter, size(scal_3,2)+1);
	scal_out_4 = ones(Nb_iter, size(scal_4,2)+1);

	diary(SAVEDIR_OPT+ mydate + "_summary" + ".log");

	for elt=1:Nb_iter

		printf("--------------------------- \n");
		printf("Start loop: " + elt + " \n");
		printf("--------------------------- \n");

		// first system (macro)
		[scal_opt_1, fval, exitflag, output] = fminsearch(System_optimisation_1, scal_1, opt);
		scal_out_1(elt, :) = [scal_opt_1, fval];
		scal_1 = scal_opt_1;

		printf("--------------------------- \n");

		// second system (elec and gas prices)
		[scal_opt_2, fval, exitflag, output] = fminsearch(System_optimisation_2, scal_2, opt);
		scal_out_2(elt, :) = [scal_opt_2, fval];
		scal_2 = scal_opt_2;

		printf("--------------------------- \n");

		// third system (fossil fuels prices)
		[scal_opt_3, fval, exitflag, output] = fminsearch(System_optimisation_3, scal_3, opt);
		scal_out_3(elt, :) = [scal_opt_3, fval];
		scal_3 = scal_opt_3;

		printf("--------------------------- \n");

		// third system (fossil fuels prices)
		[scal_opt_4, fval, exitflag, output] = fminsearch(System_optimisation_4, scal_4, opt);
		scal_out_4(elt, :) = [scal_opt_4, fval];
		scal_4 = scal_opt_4;

	end

	// output
	csvWrite(scal_out_1,SAVEDIR_OPT+ mydate() + "_scal_out_1.csv", ';');
	csvWrite(scal_out_2,SAVEDIR_OPT+ mydate() + "_scal_out_2.csv", ';');
	csvWrite(scal_out_3,SAVEDIR_OPT+ mydate() + "_scal_out_3.csv", ';');
	csvWrite(scal_out_4,SAVEDIR_OPT+ mydate() + "_scal_out_4.csv", ';');

	diary(0);
	print(out,"abort because of you choose to run an optimisation")
	abort

end


