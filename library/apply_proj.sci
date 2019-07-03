function eq = apply_proj_eq(y, var_value, var_name)
    
    eq = y;
    proj_var = Proj(var_name).val;
    ind_of_proj = Proj(var_name).ind_of_proj;
    eq(ind_of_proj,:) = var_value(ind_of_proj,:) - proj_var(ind_of_proj,:);

endfunction

function val = apply_proj_val(var_value, var_name)
    
    val = var_value;
    proj_var = Proj(var_name).val;
    ind_of_proj = Proj(var_name).ind_of_proj;
    val(ind_of_proj,:) = proj_var(ind_of_proj,:);

endfunction
