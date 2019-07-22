function bool = is_projected(var_name)
    // bool : true if *var_name* has to be projected
    //        false otherwise
    
    bool = isdef('Proj') & Proj(var_name).apply_proj;
    
endfunction
