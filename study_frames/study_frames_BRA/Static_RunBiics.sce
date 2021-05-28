//////////////////////////////////////////////////////
///////////////////////////////////////////////////////
//Shocking some parameters default values
//////////////////////////////////////////////////////
//////////////////////////////////////////////////////

////////////////////////////////////
///// Modification of Household saving rate 
////////////////////////////////////
// Exogenous info
Table_Hsav_rate = ["Saving_rate",2015,2020,2025,2030,2035,2040,2045,2050;
"HH1",-0.566,-0.4,-0.3,-0.25,-0.18,-0.18,-0.18,-0.1
"HH2",-0.102,-0.04,0,0,0,0.03,0.03,0.04
"HH3",0.064,0.1,0.1,0.1,0.1,0.1,0.1,0.1
"HH4",0.324,0.3,0.3,0.3,0.3,0.3,0.3,0.3];

if H_DISAGG=="H4"
parameters.Household_saving_rate = eval(Table_Hsav_rate(2:$,time_step+2)');
end


//////////////////////////////////////////////////////
// 2030 - 25 dólares ; 2040 - 50 ; 2050 - 100
//definição da varíavel Carbon_Tax_rate = taxa de C para cada período
//////////////////////////////////////////////////////

Carbon_Tax_rate2025 = 12.5*3.15e3; // reais*cambio / tCO2 
Carbon_Tax_rate2030 = 25*3.15e3;
Carbon_Tax_rate2035 = 35*3.15e3;
Carbon_Tax_rate2040 = 45*3.15e3;
Carbon_Tax_rate2045 = 55*3.15e3;
Carbon_Tax_rate2050 = 65*3.15e3;

//////////////////////////////////////////////////////
///////definição dos períodos
/////////////////////////////////////////////////////
period_0 = [1];
period_1 = [2,3,4,5,6,7];

//////////////////////////////////////////////////////
//informa que é o cenário DDS que terá taxa de carbono
//////////////////////////////////////////////////////
//então cada iteração do DDS terá um valor 
// de taxa de carbono de acordo com a definição da variável Carbon tax
//////////////////////////////////////////////////////

if Scenario=="BIICS_DDS" & AGG_type== "AGG_BIICS19"


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
			if	time_step==1|time_step==2
				Proj_Vol.kappa.ind_of_proj = list(list(1,Indice_BioFuk),list(1,Indice_Plantk),list(1,Indice_Cattlk),list(1,Indice_RestAk),list(1,Indice_Cemenk),list(1,Indice_IronSk),list(1,Indice_Chemik),list(1,Indice_FoodBk),list(1,Indice_Paperk),list(1,Indice_RestIk),list(1,Indice_Freigk),list(1,Indice_PassTk));
			elseif time_step==3
				Proj_Vol.kappa.ind_of_proj = list(list(1,Indice_BioFuk),list(1,Indice_Plantk),list(1,Indice_Cattlk),list(1,Indice_RestAk),list(1,Indice_Cemenk),list(1,Indice_IronSk),list(1,Indice_Chemik),list(1,Indice_FoodBk),list(1,Indice_Paperk),list(1,Indice_RestIk),list(1,Indice_Freigk),list(1,Indice_PassTk));
			else 
				Proj_Vol.kappa.ind_of_proj = list(list(1,Indice_BioFuk),list(1,Indice_Electk),list(1,Indice_Plantk),list(1,Indice_Cattlk),list(1,Indice_RestAk),list(1,Indice_Cemenk),list(1,Indice_IronSk),list(1,Indice_NonFek),list(1,Indice_Chemik),list(1,Indice_FoodBk),list(1,Indice_Paperk),list(1,Indice_RestIk),list(1,Indice_Freigk),list(1,Indice_PassTk));
			end 
	end
end 

////////////////////////////////////
///// Modification of Net Lending to GDP of Government Rate for DDS (based on the CPS) 
////////////////////////////////////
if  Scenario=="BIICS_DDS"

Table_NetLendtoGDP_Gov= ["Year",2015,2020,2025,2030,2035,2040,2045,2050
"Net Lending to GDP of Gov ",-0.077806299,-0.085662334,-0.087964933,-0.095561873,-0.101852334,-0.112052785,-0.12204064,-0.138155503];

Exo_NetLendtoGDP_Gov = eval(Table_NetLendtoGDP_Gov(2,time_step+2)');

end