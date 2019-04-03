// clean
clear

// main executable script
//PREAMBULE

disp("=====IMACLIM-Country Platform========");
 
/////////////////////////////////////////////////////////////////////////////////////////////
//	STEP 0: SYSTEM DEFINITION & SAVEDIR SETUP
/////////////////////////////////////////////////////////////////////////////////////////////
disp("STEP 0: loading Dashboard ");
exec ("preambule.sce");
exec("Dashboard.sce");

if Output_files=='True'
	runName = study + "_" + mydate();
	SAVEDIR = OUTPUT+Country_ISO+"_" +runName + filesep();
	mkdir(SAVEDIR);
	diary(SAVEDIR+"summary.log");

	SAVEDIR_IOA = OUTPUT+Country_ISO+"_"+runName + filesep()+ "outputs_IOA"+filesep();
	mkdir(SAVEDIR_IOA);	
	
	// Save Dashbord.csv & System_Resol.csv in output
	copyfile(STUDY_Country + "Dashboard_" + Country_ISO + ".csv", SAVEDIR);
	copyfile(CODE + System_Resol + ".sce", SAVEDIR);
end

/////////////////////////////////////////////////////////////////////////////////////////////
//	STEP 1: LOADING DATA
/////////////////////////////////////////////////////////////////////////////////////////////

disp("STEP 1: DATA...");
exec("Loading_data.sce");

exec("IOT_DecompImpDom.sce");
 
//Execute Households_Disagg.sce file if Index_HouseholdsDISAGG is defined
if H_DISAGG <> "HH1"
	exec("Households_Desag.sce");
end

//Execute agreagation.sce file if Index_SectorsAGG is defined
if AGG_type <> ""
	exec("Aggregation.sce");
	exec("Hybridisation.sce" );
else
	exec("Hybridisation.sce" );
end

exec("Loading_params.sce");

/////////////////////////////////////////////////////////////////////////////////////////////
//	STEP 2: CHECKING BENCHMARK DATA
/////////////////////////////////////////////////////////////////////////////////////////////
disp("STEP 2: CHECKING CONSISTENCY of BENCHMARK DATA...")
exec("Checks_loads.sce");

/////////////////////////////////////////////////////////////////////////////////////////////
//	STEP 3: CALIBRATION
/////////////////////////////////////////////////////////////////////////////////////////////
disp("STEP 3: CODE CALIBRATION...");
exec("Check_CalibSyst.sce");
exec("Calibration.sce");

////////////////////////////////////////////////////////////
// 	STEP 4: RESOLUTION - EQUILIBRIUM 2016
////////////////////////////////////////////////////////////
disp("STEP 4: RESOLUTION AND EQUILIBRIUM 2016");

// Loop initialisation for various time step calculation
time_step=1;

// Creation of a new output subdirectory for each time step in case of several time steps calculation
if Nb_Iter<>1
	if Output_files=='True'
		SAVEDIR = OUTPUT+Country_ISO+"_" +runName + filesep() + time_step + filesep();
		mkdir(SAVEDIR);
	end
end

// Loading macro framework (common feature for each country) 
if Macro_nb <> ""
	exec(STUDY+"External_Module"+sep+"Macro_Framework.sce");
end

// Loading other study changes (specific feature)
exec(STUDY_Country+study+".sce");


// Recherche d'optimum ou simple résolution
//scal = [Mu    		u_param  	sigma_omegaU	CoefRealWage	phi_K		phi_Gaz		phi_AllFuels	phi_Elec];
//scal = [0.0080503		0.0934638	-0.1043347		0.6054980		-0.0054703	-0.3790052 -0.1719113 -0.0754572];

//scal = [Mu    	u_param  	sigma_omegaU	CoefRealWage	phi_K		delta_sigma_X	delta_sigma_X];
scal = [0.0063590   0.1239476   -0.1018518      0.7180815		-0.0054703	0.1				0.1];
scal = [0.0081679   0.1313348   -1.8020404   	-4.663783    	0.0363876  	-0.1893047  	-0.0567423];

Optimum = "False";
	if Optimum == "True"

		function [d, parameters, Deriv_Exogenous] = GDP_calculation(parameters, Deriv_Exogenous, BY, calib, initial_value, scal) ;

			exec(STUDY_Country+"Recalib_RunChoices_1.sce");
			exec(System_Resol+".sce");

		endfunction 

//		function [y] = System_optimisation(scal)
//
//			[d, parameters, Deriv_Exogenous] = GDP_calculation(parameters, Deriv_Exogenous, BY, calib, initial_value, scal)
//			y1 = [100*abs(((d.GDP/d.GDP_pFish)/BY.GDP - GDP_index)/GDP_index) .. 			//1
//				100*abs((d.u_tot - 0.101573450097788)/0.101573450097788) .. 				//2
//				100*abs((d.CPI - 1.0718874451)/1.0718874451) .. 							//3
//				100*abs(((sum(d.pM.*d.M) - sum(d.pX.*d.X))*1E-6 - 44.676)/44.676) ..		//4
//				100*(d.NetCompWages_byAgent(Indice_Households)*1E-6 - 847.503)/847.503 ..	//5
//				100*(d.pC(2)/BY.pC(2) - 1.0280235988)/1.0280235988 .. 						//6	
//				100*(d.pC(4)/BY.pC(4) - 0.9678596039)/0.9678596039 ..						//7
//				100*(d.pC(5)/BY.pC(5) - 1.3837111671)/1.3837111671 ..						//8	
//				100*((sum(d.pIC(2,Indice_NonEnerSect).*d.IC(2,Indice_NonEnerSect)) + sum(d.pC(2,:).*d.C(2,:)))*1E-3 - 17525.0)/17525.0 ..
//				100*((sum(d.pIC(4,:).*d.IC(4,:)) + sum(d.pC(4,:).*d.C(4,:)))*1E-3 - 64546.0)/64546.0];
//			y = norm(y1');
//		endfunction

		function [y] = System_optimisation(scal)
			[d, parameters, Deriv_Exogenous] = GDP_calculation(parameters, Deriv_Exogenous, BY, calib, initial_value, scal)
			y1 = [100*abs(((d.GDP/d.GDP_pFish)/BY.GDP - GDP_index)/GDP_index) .. 			//1
				100*abs((d.u_tot - 0.101573450097788)/0.101573450097788) .. 				//2
				100*(d.NetCompWages_byAgent(Indice_Households)*1E-6 - 847.503)/847.503 ..	//3
				100*abs((d.CPI - 1.0718874451)/1.0718874451) .. 							//3
				100*abs(((sum(d.pM.*d.M) - sum(d.pX.*d.X))*1E-6 - 44.676)/44.676) ..		//4
				100*(d.NetCompWages_byAgent(Indice_Households)*1E-6 - 847.503)/847.503 ..	//5
				];
			y = norm(y1');
		endfunction


//		options = optimset ( "fminsearch" );

		opt = optimset ("Display","iter", ..
		               "FunValCheck","on", ..
		               "MaxFunEvals",1000, ..
		               "MaxIter",500, ..
		               "TolFun",5.e-1, ..
		               "TolX",1.e-5);

		[scal_opt, fval, exitflag, output] = fminsearch(System_optimisation, scal, opt);
		// https://wiki.scilab.org/Non%20linear%20optimization%20for%20parameter%20fitting%20example
		// https://help.scilab.org/doc/5.5.2/en_US/section_e75956809590b9cc1bb1d9aec86b31b8.html
		// essayer d'autres fonctions

//		stop = [1.d+1,1.d-8,1.d-5,100,0,100];//[ftol,xtol,gtol,maxfev,epsfcn,factor]
//		scal_opt = lsqrsolve(scal, System_optimisation, size(scal,2));
		disp("abort because of you choose to run an optimisation")
		abort
	end
	if Optimum == "False"
		exec(STUDY_Country+"Recalib_RunChoices_1.sce");
		exec(System_Resol+".sce");
	end	

////////////////////////////////////////////////////////////
// 	STEP 5: OUTPUT EXTRACTION AND RESULTS DISPLAY 2016
////////////////////////////////////////////////////////////
disp("STEP 5: OUTPUT EXTRACTION AND RESULTS DISPLAY 2016");
if Output_files=='True'
	disp("STEP 6: OUTPUT EXTRACTION AND RESULTS DISPLAY...");
	exec(CODE+"outputs.sce");
	if time_step == 1
		BY = ini; // Carbon_Tax absent de BY mais pas de ini et nécessaire pour outputs_indic.sce
	end
	exec(CODE+"outputs_indic.sce");
end

////////////////////////////////////////////////////////////
// 	STEP 7: VARIABLE STORAGE FOR RECURSIVE VERSION
////////////////////////////////////////////////////////////
if Nb_Iter <> 1
	exec(CODE+"Variable_Storage.sce");
else
	disp("Variable Storage not executed for the Nb_Iter = "+Nb_Iter)
end

exec("test_1.sce");






////////////////////////////////////////////////////////////
// 	STEP Final: SHUT DOWN THE DIARY
////////////////////////////////////////////////////////////
if Output_files=='True'
diary(0)
end
