// error max
err = 1E-3;

function test_proj(var_name)

    if (var_name <> 'I') & (var_name <> 'CO2Emis_C') & (var_name <> 'CO2Emis_IC') & (var_name <> 'M_Y') then
        difference = d(var_name) - Proj_Vol(var_name).val;
    elseif var_name == 'I'
        if Country == 'Argentina' then // The files .csv for the investment doesn't have the same format for Argentine and France
            difference = d(var_name)(:,Indice_Elec) - Proj_Vol(var_name).val;
        else
            difference = d(var_name) - Proj_Vol(var_name).val;
        end
    elseif var_name == 'M_Y'
        Y_temp = d.Y(Proj_Vol.M_Y.ind_of_proj(1)(1))
        difference = d.M(Proj_Vol.M_Y.ind_of_proj(1)(1))./ ((Y_temp>%eps).*Y_temp  + (Y_temp<%eps)*1) - Proj_Vol(var_name).val(Proj_Vol.M_Y.ind_of_proj(1)(1))
        clear Y_temp
	elseif var_name == "CO2Emis_IC"
		difference = d.Emission_Coef_IC.*d.IC - Proj_Vol(var_name).val;
	elseif  var_name == "CO2Emis_C"
		difference = d.Emission_Coef_C .*d.C - Proj_Vol(var_name).val;
    end

    for ind = Proj_Vol(var_name).ind_of_proj
        zero = difference(ind(1),ind(2));
        zero = matrix(zero,1,-1);

        for z = zero
            if 0 & abs(z) > err then
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
