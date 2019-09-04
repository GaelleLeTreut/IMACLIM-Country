////////////////////////////////////
// Specific choices for running scenarios 
////////////////////////////////////

// Specific Emis COef for gas under CCS scenario 
if Scenario=='CCS'
	Deriv_Exogenous.Emission_Coef_IC =  ini.Emission_Coef_IC;
	Deriv_Exogenous.Emission_Coef_IC(Indice_Gas,Indice_Elec) =  Emis_Coef_Gas_Elec(time_step);
end
