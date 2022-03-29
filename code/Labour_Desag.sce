////	Labour desegregation into a matrix with two rows (formal & informal)
print(out,"Substep 2: DISAGGREGATION of Labour into a a matrix with two rows (formal & informal)...")

// load file
L_ratio_str = read_csv(DATA_Country+"Labour_Desag.csv",";");
L_ratio_str = L_ratio_str(2:$,2:$);

// record file
L_ratio = evstr(L_ratio_str);


// Disaggregate Labour_value
Labour_size = 2
for col = 1:nb_Sectors
    for line = 1:Labour_size
        Labour_DESAG(line,col) = L_ratio(line,col)* initial_value.Labour(col);
    end
end

// Check data
sensib = 1D-4;
for col = 1:nb_Sectors
    if ( abs( sum(Labour_DESAG(:,col)) - initial_value.Labour(col) ) > sensib ) then
        error("Colunm " + (col) + " of Labour  matrix. Check if ratio sum 1 : " + DATA_Country + "Labour_Desag.csv");
    end 
end

// replace Labour by it disaggregation
Labour = Labour_DESAG;
initial_value.Labour = Labour;

//initial_value.Labour = Labour_DESAG;
// CUIDADO - tiramos o initial_value dessa linha mas isso pode dar problema a frente
//initial_value.Labour = Labour_DESAG ./ (initial_value.pL*ones(Labour_size,1));


// clear the intermediate variables
clear("L_ratio_str", "L_ratio", "sensib", "col");
