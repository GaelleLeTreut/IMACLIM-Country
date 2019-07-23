function bool = is_projected(var_name)
    // bool : true if *var_name* has to be projected
    //        false otherwise
    
    if isdef('Proj_Vol') then
		if find(fieldnames(Proj_Vol) == var_name )<> [] then
			bool = Proj_Vol(var_name).apply_proj;
		else
			bool = %F;
		end
    else
        bool = %F;
    end
    
endfunction
