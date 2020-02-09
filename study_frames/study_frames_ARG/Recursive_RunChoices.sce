////////////////////////////////////
// Specific choices for running scenarios 
////////////////////////////////////

// Specific Emis COef for gas under CCS scenario 
if [Scenario=='CCS'| Scenario=='CCS_EnNDC'] & AGG_type==""
	Deriv_Exogenous.Emission_Coef_IC =  ini.Emission_Coef_IC;
	Deriv_Exogenous.Emission_Coef_IC(Indice_Gas,Indice_Elec) =  Emis_Coef_Gas_Elec(time_step);
	parameters.delta_M_parameter(Indice_LightIndus) = 0.01; 
end

if [Scenario=='HydNuc'| Scenario=='HdNc_EnND'] & AGG_type==""
	parameters.delta_M_parameter(Indice_LightIndus) = -0.01; 
	
end
