////	Labour desegregation into a matrix with two rows (formal & informal)
print(out,"Substep 2: DISAGGREGATION of Labour into a a matrix with two rows (formal & informal)...")
pause
// load file
L_ratio_str = read_csv(DATA_Country+"Labour_Desag.csv",";");
L_ratio_str = L_ratio_str(2:$,2:$);

// record file
L_ratio = evstr(L_ratio_str);

// Check data
// sensib = 1D-4;
// for line = 1:nb_Sectors
    // if ( abs( sum(I_ratio(line,:)) - 1 ) > sensib )
			// error("Line " + (line+1) + " of Investment ratios matrix is not balanced to 1 : " + DATA_Country + "Invest_Desag.csv");
    // end 
// end

// Disaggregate Labour_value
Labour_size = 2
for col = 1:nb_Sectors
    for line = 1:Labour_size
        L_value_DESAG(line,col) = initial_value.L_value(col) * L_ratio(line,col);
    end
end

// Check data
sensib = 1D-4;
for col = 1:nb_Sectors
    if ( abs( sum(L_value_DESAG(col,:)) - initial_value.L_value(col) ) > sensib ) then
        error("Colunm " + (col) + " of Labour  matrix. Check if ratio sum 1 : " + DATA_Country + "Labour_Desag.csv");
    end 
end

// replace L_value and L by its disaggregations
initial_value.L_value = L_value_DESAG;
initial_value.L = L_value_DESAG ./ (initial_value.pL*ones(Labour_size,1));


pause
// clear the intermediate variables
clear("L_ratio_str", "L_ratio", "sensib", "col", "L_value_DESAG");
