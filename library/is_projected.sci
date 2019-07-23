function bool = is_projected(var_name)
    // bool : true if *var_name* has to be projected
    //        false otherwise
    
    if isdef('Proj') then
        bool = Proj(var_name).apply_proj;
    else
        bool = %F;
    end
    
endfunction
