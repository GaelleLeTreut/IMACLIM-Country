function y = apply_proj_eq(eq, var_value, var_name)
    // eq : equation before projection
    // var_value : variable to project
    // var_name : name of the variable to project
    // y : equation after projection
    
    // value of projection
    proj_value = Proj(var_name).val;
    
    // indexes of projection
    ind_of_proj = Proj(var_name).ind_of_proj;
    
    // apply the projection
    y = eq;
    y(ind_of_proj,:) = var_value(ind_of_proj,:) - proj_value(ind_of_proj,:);

endfunction

function var_proj = apply_proj_val(var_value, var_name)
    
    // var_value : variable before projection
    // var_name : name of the variable
    // var_proj : variable after projection
    
    // value of projection
    proj_value = Proj(var_name).val;
    
    // indexes of projection
    ind_of_proj = Proj(var_name).ind_of_proj;
    
    // apply the projection
    var_proj = var_value;
    var_proj(ind_of_proj,:) = proj_value(ind_of_proj,:);

endfunction
