////////////////////////////////////////////////////////////////////////
// load of macroeconomic and demographic context for the first step only
////////////////////////////////////////////////////////////////////////
if time_step==1 then

	execstr( "Table_Macro= Macro_Framework_"+Macro_nb+";")
	list_macro_var= Table_Macro(1:$-1,1);
	Macro_NumRow = size(list_macro_var,"r");

	for elt=1:size(list_macro_var,"r");
		indtemp= find(Table_Macro(:,1)==list_macro_var(elt));
		valtemp = evstr(Table_Macro(indtemp,2:$));
		execstr("Proj_Macro."+list_macro_var(elt)+"=valtemp;")
	end
	
	if World_prices == "True"
	/// Stocker les variations des prix des importations dans une autre structures
	Index_Worldprice = "pM_";
	Indice_Worldprice = find( part(list_macro_var,1:length(Index_Worldprice))==Index_Worldprice);
		if Indice_Worldprice==[]
		error("World_prices option is asking by the Dashboard but there is no information about any world prices within the macroeconomic economic study selected")
		end
	
	list_Worldprice = [];
		for elt = 1:size(Indice_Worldprice,"c")
		list_Worldprice(elt) = list_macro_var(evstr(Indice_Worldprice(elt)));
		end
		
	SectDefineWP = part(list_Worldprice,length(Index_Worldprice)+1:$);
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
	parameters.time_since_ini = Proj_Macro.current_year(time_step) - Proj_Macro.reference_year(time_step);
	parameters.time_since_BY = Proj_Macro.current_year(time_step) - Proj_Macro.reference_year(1);
end

// Set up demographic context
Homo_Shortname = "Systeme_ProjHomo";
OptHomo_Shortname ="SystemOpt_ProjHomo";
if Demographic_shift == "True"
    Deriv_Exogenous.Labour_force =  ((1+Proj_Macro.Labour_force(time_step)).^(parameters.time_since_ini))*ini.Labour_force;
    Deriv_Exogenous.Population =  ((1+Proj_Macro.Population(time_step)).^(parameters.time_since_ini))*ini.Population;
    if Optimization_Resol then
        if part(SystemOpt_Resol,1:length(OptHomo_Shortname))<> OptHomo_Shortname
            Deriv_Exogenous.Retired =  ((1+Proj_Macro.Retired(time_step)).^(parameters.time_since_ini))*ini.Retired;
        end 
    else
        if part(System_Resol,1:length(Homo_Shortname))<> Homo_Shortname
            Deriv_Exogenous.Retired =  ((1+Proj_Macro.Retired(time_step)).^(parameters.time_since_ini))*ini.Retired;
        end 
    end
else
	Deriv_Exogenous.Labour_force = BY.Labour_force;
end

// Set up macroeconomic context
if Labour_product == "True"
	if time_step == 1 
		for elt = 1:Nb_Iter
			GDP_index(elt) = prod((1 + Proj_Macro.GDP(1:elt)).^(Proj_Macro.current_year(1:elt) - Proj_Macro.reference_year(1:elt)));
		end
	// Last step with same growth ( use for capital dynamics)
		if Capital_Dynamics
			GDP_index($+1) = GDP_index($)*( 1 + Proj_Macro.GDP(Nb_Iter) )  ;	
		end 

	end
	parameters.Mu = (GDP_index(time_step)/(sum(Deriv_Exogenous.Labour_force)*(1-BY.u_tot)* BY.LabourByWorker_coef/(sum(BY.Labour))))^(1/parameters.time_since_BY)-1;
	//parameters.Mu = (GDP_index(time_step)/(sum(Deriv_Exogenous.Labour_force)*(1-BY.u_tot)/(sum(BY.Labour))))^(1/parameters.time_since_BY)-1;
	parameters.phi_L = ones(parameters.phi_L).*parameters.Mu;
else
	GDP_index = ones(1, Nb_Iter);
end

//Set imported prices as Macro_framework
if World_prices == "True"
	for k=1:size(Indice_Worldprice,"c")
		name = SectDefineWP(k);
		if find(Index_Sectors==name)<>[]
			Match_Ind = find(Index_Sectors==name);
            execstr("parameters.delta_pM_parameter("+Match_Ind+") = Proj_Macro.pM_"+name+"(time_step);");
        else
            warning("the import variation price of "+ name +" does not fit with any sectors used in this run: this information is not used");
        end
    end
end 


//////// Exportation in volume 
// Export growth of non-energy sectors as GDP_world
if X_nonEnerg == "True"
	if time_step == 1 	
		for elt = 1:Nb_Iter
			GDP_world_index(elt) = prod((1 + Proj_Macro.GDP_world(1:elt)).^(Proj_Macro.current_year(1:elt) - Proj_Macro.reference_year(1:elt)));
			delta_X_parameter_indBY = zeros(Nb_Iter,nb_Sectors);
		end
	end
		
	parameters.delta_X_parameter(1,Indice_NonEnerSect) = (GDP_world_index(time_step) ^ (1/parameters.time_since_BY) - 1) * ones(parameters.delta_X_parameter(1,Indice_NonEnerSect));
end


/// Capital Dynamic and Investment/GDP path 
if Capital_Dynamics&Exo_ShareI_GDP&(find(fieldnames(Proj_Macro)=="ShareI_GDP")=="")
 error("Dashboard says that an exogenous Share of investment to GDP path is required but it is not definedin the Macro_Framework file");
end 

/// Capital Dynamic and Investment/GDP path 
if Capital_Dynamics&Exo_u_tot&(find(fieldnames(Proj_Macro)=="u_tot")=="")
 error("Dashboard says that an exogenous unemployment path is required but it is not defined in the Macro_Framework file");
end 

/// Capital Dynamic and Investment/GDP path 
if Capital_Dynamics&Exo_Kstock_Adj&(find(fieldnames(Proj_Macro)=="delta_Kstock_Adj")=="")
 error("Dashboard says that an exogenous adjustment of K stock is required but it is not defined in the Macro_Framework file");
end 

// clear programming trick for Static_comparative
if Resol_Mode == "Static_comparative"
	time_step=time_step_temp;
	clear time_step_temp
end
