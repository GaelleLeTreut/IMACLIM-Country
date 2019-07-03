// error max
err = 1E-3;

function test_proj(var_name , proj_ind)
    
    difference = d(var_name) - Proj(var_name).val;
    
    ind_of_proj = Proj(var_name).ind_of_proj;
    zero = difference(ind_of_proj);

    for z = zero'
        if abs(z) > err then
            error("The projection of " + var_name + " did not go well");
        end
    end
    
endfunction

for var_name = fieldnames(Proj)'
    if Proj(var_name).apply_proj then
        test_proj(var_name);
        disp('*** ' + var_name + ' has been well projected.');
    else
        disp('*** ' + var_name + ' : not projected.');
    end
end

disp("** Projections checked");
