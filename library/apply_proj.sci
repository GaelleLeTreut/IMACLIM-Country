function y = apply_proj_eq(eq, var_value, var_name)
    // eq : equation before projection
    // var_value : variable to project
    // var_name : name of the variable to project
    // y : equation after projection
    
    // value of projection
    proj_value = Proj_Vol(var_name).val;
    
    // apply the projection
    y = eq;
    for ind = Proj_Vol(var_name).ind_of_proj
        y(ind(1),ind(2)) = var_value(ind(1),ind(2)) - proj_value(ind(1),ind(2));
    end

endfunction

function var_proj = apply_proj_val(var_value, var_name)
    
    // var_value : variable before projection
    // var_name : name of the variable
    // var_proj : variable after projection
    
    // value of projection
    proj_value = Proj_Vol(var_name).val;
    
    // apply the projection
    var_proj = var_value;
    for ind = Proj_Vol(var_name).ind_of_proj
        var_proj(ind(1),ind(2)) = proj_value(ind(1),ind(2));
    end

endfunction
