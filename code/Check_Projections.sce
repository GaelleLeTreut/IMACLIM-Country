// error max
err = 1E-3;

function test_proj(var_name , proj_ind)
    d_indexes = getfield(1,d);
    Projection_indexes = getfield(1,Projection);

    ind_in_d = find(d_indexes == var_name);
    ind_in_Proj = find(Projection_indexes == var_name);

    var_value = getfield(ind_in_d,d);
    var_proj = getfield(ind_in_Proj,Projection);

    zero = var_value(proj_ind) - var_proj(proj_ind);

    for z = zero'
        if abs(z) > err then
            error("The projection of " + var_name + " did not go well");
        end
    end
endfunction

if Alpha_BU <> [] then
    test_proj("IC", Alpha_BU);
    test_proj("Y", Alpha_BU);
end

if C_BU <> [] then
    test_proj("C", C_BU);
end

if Trade_BU <> [] then
    test_proj("X", Trade_BU);
    test_proj("M", Trade_BU);
end

disp("Projections checked")
