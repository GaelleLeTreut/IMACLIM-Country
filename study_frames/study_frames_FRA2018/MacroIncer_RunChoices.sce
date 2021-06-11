////////////////////////////////////
// Specific to homothetic projection
////////////////////////////////////

// Actualise Emission factors embodied in imported goods
if CO2_footprint == "True" & Scenario <>"" then
	if time_step == 1
		ini.CoefCO2_reg = CoefCO2_reg;
	end
	execstr("Deriv_Exogenous.CoefCO2_reg = CoefCO2_reg_" + time_step + "_" + Macro_nb);
end


parameters.Coef_real_wage = 1;
//////EXAMPLES

// To define and select by Dashboard_FRA2018
// VAR_MU;Mu_low
// VAR_MU;Mu_high

// VAR_MU="Mu_high";
//Variante on Mu - Productivity
///For example , range of +/-10%
///In this case; variation "homothetic" for all sectors (Mu) // (phi_L sectoral changes)
scal_Mu = 0.1 ;
if VAR_MU=="Mu_low"
	parameters.Mu = parameters.Mu.*(1-scal_Mu);
	//parameters.phi_L = parameters.phi_L.*(1-scal_Mu);
elseif VAR_MU=="Mu_high"
	parameters.Mu = parameters.Mu.*(1+scal_Mu);
	//parameters.phi_L = parameters.phi_L.*(1+scal_Mu);
end

scal_pM = 0.1;

if VAR_pM=="pM_low"
	//parameters.delta_pM_parameter(Indice_OilS) = (1+parameters.delta_pM_parameter(Indice_OilS)).^time_since_ini*(1-scal_pM);
	//parameters.delta_pM_parameter(Indice_GasS) = (1+parameters.delta_pM_parameter(Indice_GasS)).^time_since_ini*(1-scal_pM);
	//parameters.delta_pM_parameter(Indice_CoalS) = (1+parameters.delta_pM_parameter(Indice_CoalS)).^time_since_ini*(1-scal_pM);
	parameters.delta_pM_parameter(Indice_OilS) = parameters.delta_pM_parameter(Indice_OilS)*(1-scal_pM);
	parameters.delta_pM_parameter(Indice_GasS) = parameters.delta_pM_parameter(Indice_GasS)*(1-scal_pM);
	parameters.delta_pM_parameter(Indice_CoalS) = parameters.delta_pM_parameter(Indice_CoalS)*(1-scal_pM);
elseif VAR_pM=="pM_high"
	//parameters.delta_pM_parameter(Indice_OilS) = (1+parameters.delta_pM_parameter(Indice_OilS)).^time_since_ini*(1+scal_pM);
	//parameters.delta_pM_parameter(Indice_GasS) = (1+parameters.delta_pM_parameter(Indice_GasS)).^time_since_ini*(1+scal_pM);
	//parameters.delta_pM_parameter(Indice_CoalS) = (1+parameters.delta_pM_parameter(Indice_CoalS)).^time_since_ini*(1+scal_pM);
	parameters.delta_pM_parameter(Indice_OilS) = parameters.delta_pM_parameter(Indice_OilS)*(1+scal_pM);
	parameters.delta_pM_parameter(Indice_GasS) = parameters.delta_pM_parameter(Indice_GasS)*(1+scal_pM);
	parameters.delta_pM_parameter(Indice_CoalS) = parameters.delta_pM_parameter(Indice_CoalS)*(1+scal_pM);
end

scal_Growth = 0.1;

if VAR_Growth=="Growth_low"
	parameters.delta_X_parameter(1,Indice_NonEnerSect) = parameters.delta_X_parameter(1,Indice_NonEnerSect)*(1-scal_Growth);
elseif VAR_Growth=="Growth_high"
	parameters.delta_X_parameter(1,Indice_NonEnerSect) = parameters.delta_X_parameter(1,Indice_NonEnerSect)*(1+scal_Growth);
end

scal_Immo = 0.05;

if VAR_Immo=="Immo_low"
	parameters.Household_saving_rate = BY.Household_saving_rate - scal_Immo;
elseif VAR_Immo=="Immo_high"
	parameters.Household_saving_rate = BY.Household_saving_rate + scal_Immo;
end


if  VAR_sigma<>""
	if time_step == 1
		scal_sigma = 0.4;
			if VAR_sigma=="sigma_low"
				parameters.sigma = parameters.sigma - scal_sigma;
			elseif VAR_sigma=="sigma_high"
				parameters.sigma = parameters.sigma + scal_sigma;
			end
	end	
		sigma = parameters.sigma;
		Coeff_forCES = (sum(BY.pIC.* (1 - ConstrainedShare_IC) .* BY.alpha,"r") + sum(BY.pL .* (1-ConstrainedShare_Labour) .* BY.lambda, "r") + BY.pK .* (1-ConstrainedShare_Capital) .* BY.kappa );
		aIC = (ones(nb_Sectors,1)*Coeff_forCES<>0).*BY.pIC.* ((1 - ConstrainedShare_IC) .* BY.alpha) .^ (1 -(ones(nb_Sectors,1)*((sigma-1)./sigma))) .* (ones(nb_Sectors,1)*((Coeff_forCES<>0).*Coeff_forCES + (Coeff_forCES==0))).^(-1);
		aL	=  (Coeff_forCES<>0).*BY.pL.* ((1 - ConstrainedShare_Labour) .* BY.lambda) .^ (1 -((sigma-1)./sigma)) .*((Coeff_forCES<>0).*Coeff_forCES + (Coeff_forCES==0)) .^(-1);
		aK = (Coeff_forCES<>0) .* (BY.pK.* ((1 - ConstrainedShare_Capital) .* BY.kappa) .^ (1 -((sigma-1)./sigma)) .*((Coeff_forCES<>0).*Coeff_forCES + (Coeff_forCES==0)) .^(-1));
		
		x_aIC = matrix(aIC,nb_Sectors*nb_Commodities, 1) ;
		x_aL = matrix(aL,nb_Sectors, 1);
		x_aK = matrix(aK,nb_Sectors, 1);
		
		x_TechniCoef = [x_aIC;x_aL;x_aK];	
end
