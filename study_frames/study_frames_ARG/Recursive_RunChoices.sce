////////////////////////////////////
// Specific choices for running scenarios 
////////////////////////////////////

// Specific Emis COef for gas under CCS scenario 
if Scenario<>"" 
	
	CCS_Shortname = "CCS";
	
	if  (part(Scenario,1:length(CCS_Shortname))== CCS_Shortname & AGG_type=="" ) 
		
		Deriv_Exogenous.Emission_Coef_IC =  ini.Emission_Coef_IC;
		Deriv_Exogenous.Emission_Coef_IC(Indice_Gas,Indice_Elec) =  Emis_Coef_Gas_Elec(time_step);
		// parameters.delta_M_parameter(Indice_LightIndus) = 0.01; 
	
	end

	
	HydNuc_Shortname = "HydNuc";
	HydNuc_Shortname2 = "HdNC";
	
	if  (part(Scenario,1:length(HydNuc_Shortname))== HydNuc_Shortname & AGG_type=="" ) |  (part(Scenario,1:length(HydNuc_Shortname2))== HydNuc_Shortname2 & AGG_type=="" )
		
		// parameters.delta_M_parameter(Indice_LightIndus) = -0.01; 
		
	end

end


