//Shocking some parameters default values

//definir as taxas aqui para cada período - definição da varíavel Carbon_Tax_rate
Carbon_Tax_rate2025 = 1e6; // 100reais / tCO2 
Carbon_Tax_rate2030 = 1e6;
Carbon_Tax_rate2035 = 1e6;
Carbon_Tax_rate2040 = 1e6;
Carbon_Tax_rate2045 = 1e6;
Carbon_Tax_rate2050 = 1e6;

//isso quer dizer que cada iteração terá um valor de taxa de carbono

if time_step == 2 
parameters.Carbon_Tax_rate = Carbon_Tax_rate2025;
end 

if time_step == 3 
parameters.Carbon_Tax_rate = Carbon_Tax_rate2030;
end

if time_step == 4 
parameters.Carbon_Tax_rate = Carbon_Tax_rate2035;
end 

if time_step == 5 
parameters.Carbon_Tax_rate = Carbon_Tax_rate2040;
end 

if time_step == 6 
parameters.Carbon_Tax_rate = Carbon_Tax_rate2045;
end 

if time_step == 7 
parameters.Carbon_Tax_rate = Carbon_Tax_rate2050;
end 

