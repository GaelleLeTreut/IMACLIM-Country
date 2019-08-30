// error max
err = 1E-3;

function test_proj(var_name)

    if var_name <> 'I_value' then
        difference = d(var_name) - Proj_Vol(var_name).val;
    else
        difference = d(var_name)(:,Indice_Elec) - Proj_Vol(var_name).val;
    end

    for ind = Proj_Vol(var_name).ind_of_proj
        zero = difference(ind(1),ind(2));
        zero = matrix(zero,1,-1);

        for z = zero
            if abs(z) > err then
                error("The projection of " + var_name + " did not go well");
            end
        end
    end

endfunction

for var_name = fieldnames(Proj_Vol)'
    if Proj_Vol(var_name).apply_proj then
        test_proj(var_name);
        print(out,'*** ' + var_name + ' has been well projected.');
    else
        print(out,'*** ' + var_name + ' : not projected.');
    end
end

print(out,"** Projections checked");

clear err difference ind_of_proj zero z var_name
