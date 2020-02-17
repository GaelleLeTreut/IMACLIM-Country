// Capital Market
	
//Calibration stock at BY
if Country =="Brasil" & Macro_nb=="NDC"
// Use an average over 6 years of the expected growth rather than the only one year growth (recession in this case) of the calibration year
	time_step_calib = 6;
else
	time_step_calib = 1;
end
	
Capital_endowment = sum(BY.I) / ( parameters.depreciation_rate + GDP_index(time_step_calib) - 1) ;
x_Capital_consumption = Capital_endowment; 
clear time_step_calib

Capital_consumption = CapitalCons_Dyn_Val_0 ( Capital_income, Capital_endowment);
x_Capital_consumption = Capital_consumption;

pK = Capital_income ./ Capital_consumption ;
x_pK = pK; 

for elt=2:nb_Sectors
	if (round(pK(elt)*1000))/1000 <> (round(pK(elt-1)*1000))/1000
		error ("problem in calibrating pK")		
	end
end

pRental = pK(1);
x_pRental = pRental;

function [const_kappa] =fcalCapIncome_Const_1(x_kappa, Capital_income, pK, Y, Imaclim_VarCalib)
   kappa= indiv_x2variable(Imaclim_VarCalib, "x_kappa");
   y1_1 = (Y==0).*(kappa');
   y1_2 = (Y<>0).*Capital_income_Const_1(Capital_income, pK, kappa, Y);
   const_kappa	= (Y==0).*y1_1  + (Y<>0).*y1_2;
endfunction

[x_kappa, const_kappa, infCal_Capital_income] = fsolve(x_kappa, list(fcalCapIncome_Const_1, Capital_income, pK, Y, Index_Imaclim_VarCalib));

if norm(const_kappa) > sensib
	error( "review calib_kappa")
else
	kappa = indiv_x2variable (Index_Imaclim_VarCalib, "x_kappa");
	kappa = (abs(kappa) > %eps).*kappa;

end


function [const_Phi] =fcalTechnicProg_Const_1(x_Phi, Capital_consumption, sigma_Phi, Imaclim_VarCalib)
    Phi= indiv_x2variable(Imaclim_VarCalib, "x_Phi");
    const_Phi = TechnicProgress_Const_1(Phi, Capital_consumption, sigma_Phi)
endfunction

[x_Phi, const_Phi, infCalPhi] = fsolve(x_Phi, list(fcalTechnicProg_Const_1, Capital_consumption, sigma_Phi, Index_Imaclim_VarCalib));

if norm(const_Phi) > sensib
    error( "review calib_Phi")
else
    Phi = indiv_x2variable (Index_Imaclim_VarCalib, "x_Phi");
    Phi = (abs(Phi) > %eps).*Phi;
end


// CES coefficient - analytical
Coeff_forCES = (sum(pIC.* (1 - ConstrainedShare_IC) .* alpha,"r") + sum(pL .* (1-ConstrainedShare_Labour) .* lambda, "r") + pK .* (1-ConstrainedShare_Capital) .* kappa );

aIC = (ones(nb_Sectors,1)*Coeff_forCES<>0).*pIC.* ((1 - ConstrainedShare_IC) .* alpha) .^ (1 -(ones(nb_Sectors,1)*((sigma-1)./sigma))) .* (ones(nb_Sectors,1)*((Coeff_forCES<>0).*Coeff_forCES + (Coeff_forCES==0))).^(-1);

aL	=  (Coeff_forCES<>0).*pL.* ((1 - ConstrainedShare_Labour) .* lambda) .^ (1 -((sigma-1)./sigma)) .*((Coeff_forCES<>0).*Coeff_forCES + (Coeff_forCES==0)) .^(-1);

aK= (Coeff_forCES<>0) .* (pK.* ((1 - ConstrainedShare_Capital) .* kappa) .^ (1 -((sigma-1)./sigma)) .*((Coeff_forCES<>0).*Coeff_forCES + (Coeff_forCES==0)) .^(-1));

x_aIC = matrix(aIC,nb_Sectors*nb_Commodities, 1) ;
x_aL = matrix(aL,nb_Sectors, 1);
x_aK = matrix(aK,nb_Sectors, 1);

x_TechniCoef = [x_aIC;x_aL;x_aK];



/// Replace all calibrated variables by correct value into calib structure
calib = Variables2struct(list_calib);


//Struture BY. created to reunite all BY values before introducing a choc
execstr("BY."+fieldnames(initial_value)+"= initial_value."+fieldnames(initial_value)+";");
execstr("BY."+fieldnames(calib)+"= calib."+fieldnames(calib)+";");
execstr("BY."+fieldnames(parameters)+"= parameters."+fieldnames(parameters)+";");

ini = BY;

