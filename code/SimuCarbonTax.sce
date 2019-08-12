exec('Load_file_structure.sce');

CarbonTax_Diff_IC_path = PARAMS + 'params_BRA' + filesep() + 'AGG_PMR19' + filesep() + 'CarbonTax_Diff_IC_AGG_PMR19.csv';

goal_reduc = 0.2 * ones(19,19);
sensib = 0.01 * ones(19,19);

function [continue_adj, Diff_inf, Diff_sup] = adjust_Diff (Diff_inf, Diff_sup)

    // Read CarbonTax_Diff_IC headers
    CarbonTax_Diff_IC_csv = read_csv(CarbonTax_Diff_IC_path, ';');
    CarbonTax_Diff_IC_head_l = CarbonTax_Diff_IC_csv(1:20,1);
    CarbonTax_Diff_IC_head_c = CarbonTax_Diff_IC_csv(1,1:20);

    // Lance Imaclim
    TEST_MODE = %T;
    testing.countMax = 3;
    testing.debug_mode = %F;
    exec('ImaclimS.sce');
    
    CarbonTax_Diff_IC_found = CarbonTax_Diff_IC;
    
    // Réduction d'émission à atteindre
    goal_reduc = 0.2 * ones(19,19);
    sensib = 0.01 * ones(19,19);
    
    // Réduction d'émission atteinte
    CO2Emis_IC_ini = Emission_Coef_IC .* ini.IC;
    CO2Emis_IC = Emission_Coef_IC .* IC;
    current_reduc = divide((CO2Emis_IC_ini - CO2Emis_IC) , CO2Emis_IC_ini, 0);

    // Adapter CarbonTax_Diff_IC en fonction
    for i = 1:size(CarbonTax_Diff_IC,1)
        for j = 1:size(CarbonTax_Diff_IC,2)
            if Emission_Coef_IC(i,j) <> 0 then
                if current_reduc(i,j) > goal_reduc(i,j) then
                    // Réduction des émission trop importante -> baisser la taxe
                    Diff_sup(i,j) = CarbonTax_Diff_IC(i,j);
                    CarbonTax_Diff_IC(i,j) = (Diff_sup(i,j) + Diff_inf(i,j)) / 2;
                elseif current_reduc(i,j) < goal_reduc(i,j)
                    // Réduction des émission trop faible -> augmenter la taxe
                    Diff_inf(i,j) = CarbonTax_Diff_IC(i,j);
                    if Diff_sup(i,j) == -1 then
                        CarbonTax_Diff_IC(i,j) = CarbonTax_Diff_IC(i,j) * 2;
                    else
                        CarbonTax_Diff_IC(i,j) = (Diff_sup(i,j) + Diff_inf(i,j)) / 2;
                    end
                end
            else
                CarbonTax_Diff_IC(i,j) = 0;
            end
        end
    end
    
    // écris le résultat pour la suite
    csv_to_write = []
    for i = 1:20
        for j = 1:20
            if i == 1 then
                csv_to_write(i,j) = CarbonTax_Diff_IC_head_c(1,j);
            elseif j == 1 then
                csv_to_write(i,j) = CarbonTax_Diff_IC_head_l(i,1);
            else
                csv_to_write(i,j) = string(CarbonTax_Diff_IC(i-1,j-1));
            end
        end
    end
    csvWrite(csv_to_write, CarbonTax_Diff_IC_path, ';');
    
    continue_adj = ( (Emission_Coef_IC <> 0) .* (current_reduc > goal_reduc + sensib) ) | ( (Emission_Coef_IC <> 0) .* (current_reduc < goal_reduc - sensib) );
    
endfunction

Diff_inf = 0 * ones(19,19);
Diff_sup = -1 * ones(19,19);
continue_adj = %T * ones(19,19);


while(or(continue_adj))
    
    [continue_adj, Diff_inf, Diff_sup] = adjust_Diff (Diff_inf, Diff_sup);
     
end
