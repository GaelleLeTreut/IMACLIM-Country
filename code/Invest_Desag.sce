////	Investment desegregation into a square matrix
print(out,"Substep 2: DISAGGREGATION of Investment into a square matrix...")

// load file
I_ratio_str = read_csv(DATA_Country+"Invest_Desag.csv",";");
I_ratio_str = I_ratio_str(2:$,2:$);

// record file
I_ratio = evstr(I_ratio_str);

// Check data
sensib = 1D-4;
for line = 1:nb_Sectors
    if ( abs( sum(I_ratio(line,:)) - 1 ) > sensib ) then
        error("Line " + (line+1) + " of Investment ratios matrix is not balanced to 1 : " + DATA_Country + "Invest_Desag.csv");
    end 
end

// Desaggregate I_value
for line = 1:nb_Sectors
    for col = 1:nb_Sectors
        I_value_DESAG(line,col) = initial_value.I_value(line) * I_ratio(line,col);
    end
end

// replace I_value and I by its disaggregations
initial_value.I_value = I_value_DESAG;
initial_value.I = I_value_DESAG ./ (initial_value.pI*ones(1,nb_Sectors));


// clear the intermediate variables
clear("I_ratio_str", "I_ratio", "sensib", "line", "I_value_DESAG");
