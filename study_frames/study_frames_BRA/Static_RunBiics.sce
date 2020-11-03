//Shocking some parameters default values

// 2030 - 25 dólares ; 2040 - 50 ; 2050 - 100
//definir as taxas aqui para cada período - definição da varíavel Carbon_Tax_rate
Carbon_Tax_rate2025 = 12.5*3.15e3; // reais / tCO2 
Carbon_Tax_rate2030 = 25*3.15e3;
Carbon_Tax_rate2035 = 37.5*3.15e3;
Carbon_Tax_rate2040 = 50*3.15e3;
Carbon_Tax_rate2045 = 75*3.15e3;
Carbon_Tax_rate2050 = 100*3.15e3;


period_0 = [1];
period_1 = [2,3,4,5,6,7];




////////////////////////////////////
///// Capital_consumption or Kappa never informed in first period
////////////////////////////////////

if Proj_Vol.Capital_consumption.apply_proj & ~Proj_Vol.Capital_consumption.intens

	if or(time_step==period_0)
		Proj_Vol.Capital_consumption.apply_proj = %F;
	elseif or(time_step<>period_0)
		Proj_Vol.Capital_consumption.apply_proj = %T; 
	end
end 

if ( find("kappa"==fieldnames(Proj_Vol))<> [] ) & Proj_Vol.kappa.intens
if or(time_step==period_0)
		Proj_Vol.kappa.apply_proj = %F;
	elseif or(time_step<>period_0)
		Proj_Vol.kappa.apply_proj = %T; 
	end
end 

//isso quer dizer que cada iteração terá um valor de taxa de carbono


if Scenario=="DDS" & AGG_type== "AGG_BIICS19"

if time_step == 2 
parameters.Carbon_Tax_rate = Carbon_Tax_rate2025;
end 

if time_step == 3 
parameters.Carbon_Tax_rate = Carbon_Tax_rate2030;
end

if time_step == 4 
parameters.Carbon_Tax_rate = Carbon_Tax_rate2035;
end 

if time_step == 5 
parameters.Carbon_Tax_rate = Carbon_Tax_rate2040;
end 

if time_step == 6 
parameters.Carbon_Tax_rate = Carbon_Tax_rate2045;
end 

if time_step == 7 
parameters.Carbon_Tax_rate = Carbon_Tax_rate2050;
end 

end
