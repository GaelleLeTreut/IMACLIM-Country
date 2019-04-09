////////////////////////////////////////////////////////////////////////
// load of macroeconomic and demographic context for the first step only
////////////////////////////////////////////////////////////////////////
if time_step==1 then
    for elt=1:size(Row_Column,"r")
        NameTemp = Row_Column(elt);
        TempIndicElt = find( NameTemp ==Index_Macro_Framework(:,1));
        TableTemp = Index_Macro_Framework(TempIndicElt,:);
        TableTemp(:,1)=[];
        if NameTemp=="Row"
            Index_Var_Macro = TableTemp;
            nb_Var_Macro = size(Index_Var_Macro,1);
        end
    end

    for var=1:nb_Var_Macro
        varname=Index_Var_Macro(var);
        execstr("Projection."+varname+"=evstr(Macro_Framework_"+Macro_nb+"(find(Macro_Framework_"+Macro_nb+"==varname),2:$));");
    end
end

/////////////////////////
// Macroeconomic context
/////////////////////////
// Définition des time_since_BY et time_since_ini
if Resol_Mode == "Static_comparative"
	time_step_temp = time_step;
	time_step=1;
end
if Resol_Mode == "Dynamic_projection"
	parameters.time_since_ini = Projection.current_year(time_step) - Projection.reference_year(time_step);
	parameters.time_since_BY = Projection.current_year(time_step) - Projection.reference_year(1);
end

// Set up demographic context
if Demographic_shift == "True"
	Deriv_Exogenous.Labour_force =  ((1+Projection.Labour_force(time_step)).^(parameters.time_since_ini))*ini.Labour_force;
	Deriv_Exogenous.Population =  ((1+Projection.Population(time_step)).^(parameters.time_since_ini))*ini.Population;
//	if [System_Resol<>"Systeme_ProjHomothetic"]&[System_Resol<>"Systeme_ProjHomot_BRA"] then
	Deriv_Exogenous.Retired =  ((1+Projection.Retired(time_step)).^(parameters.time_since_ini))*ini.Retired;
//	end
end

// Set up macroeconomic context
if Labour_product == "True"
	GDP_index(time_step) = prod((1 + Projection.GDP(1:time_step)).^(Projection.current_year(1:time_step) - Projection.reference_year(1:time_step)));
	parameters.Mu = (GDP_index(time_step)/(sum(Deriv_Exogenous.Labour_force)*(1-BY.u_tot)* BY.LabourByWorker_coef/(sum(BY.Labour))))^(1/parameters.time_since_BY)-1;
	//parameters.Mu = (GDP_index(time_step)/(sum(Deriv_Exogenous.Labour_force)*(1-BY.u_tot)/(sum(BY.Labour))))^(1/parameters.time_since_BY)-1;
	parameters.phi_L = ones(parameters.phi_L).*parameters.Mu;
end

//Set imported prices as Macro_framework
//if World_energy_prices <> []
if World_prices == "True"
//	for k=1:size(World_energy_prices,2)
	for k=1:size(Index_Sectors,1)
//		name = World_energy_prices(k);
		name = Index_Sectors(k);
		if sum(Index_Sectors == name)==1
			execstr("parameters.delta_pM_parameter("+k+") = Projection.pM_"+name+"(time_step);");
		else
			warning("the energy quantity "+ name +" does not fit with the agregation level used: the related prices won't be informed.");  
		end
	end
end

// Export growth of non-energy sectors as GDP_world
if X_nonEnerg == "True"
	parameters.delta_X_parameter(1,Indice_NonEnerSect) = ones(parameters.delta_X_parameter(1,Indice_NonEnerSect))*Projection.GDP_world(time_step);
end

// clear programming trick for Static_comparative
if Resol_Mode == "Static_comparative"
	time_step=time_step_temp;
	clear time_step_temp
end
