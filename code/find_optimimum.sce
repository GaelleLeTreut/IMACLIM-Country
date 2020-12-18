function [d, parameters, Deriv_Exogenous, target] = GDP_calculation(parameters, Deriv_Exogenous, BY, calib, initial_value, scal, target) ;
	exec(STUDY_Country+"Recalib_RunChoices_1.sce");
	exec('Order_resolution.sce');
    exec('Resolution.sce');
endfunction 

	
function [y] = System_optimisation(scal)
	[d, parameters, Deriv_Exogenous, target] = GDP_calculation(parameters, Deriv_Exogenous, BY, calib, initial_value, scal, target)
	y1 = [100*abs(((d.GDP/d.GDP_pFish)/BY.GDP - GDP_index(time_step))/GDP_index(time_step)) .. 	//1
		100*abs((d.u_tot - target(1))/target(1)) ..												//2
		100*(d.NetCompWages_byAgent(Indice_Households)*1E-6 - target(2))/target(2) ..			//3
		100*abs((d.CPI - target(3))/target(3)) .. 												//4
		100*abs(((sum(d.pM.*d.M) - sum(d.pX.*d.X))*1E-6 - target(4))/target(4)) ..				//5
		100*(d.pC(2)/BY.pC(2) - target(5))/target(5) .. 										//6	
		100*(d.pC(4)/BY.pC(4) - target(6))/target(6) ..											//7
		100*(d.pC(5)/BY.pC(5) - target(7))/target(7) ..											//8	
		];
	y = norm(y1);
endfunction

opt = optimset ("Display","iter", ..
               "FunValCheck","on", ..
               "MaxFunEvals",25, ..
               "MaxIter",10, ..
               "TolFun",1.e-5, ..
               "TolX",1.e-10);

[scal_opt_1, fval, exitflag, output] = fminsearch(System_optimisation, scal, opt);
	
SAVEDIR_OPT = OUTPUT+"Optimum"+filesep();
mkdir(SAVEDIR_OPT);
csvWrite(scal_opt_1,SAVEDIR_OPT+"scal_opt_" + BY_Recal + ".csv", ';');

print(out,"abort because of you choose to run an optimisation")
abort
scal = scal_opt_1;