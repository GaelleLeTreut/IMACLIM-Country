exec('Load_file_structure.sce');

CarbonTax_Diff_IC_path = PARAMS + 'params_BRA' + filesep() + 'AGG_PMR19' + filesep() + 'CarbonTax_Diff_IC_AGG_PMR19.csv';

nb_sectors = 19;

H_desag = 'H4';
H_size = 4;

CarbonTax_Diff_C_path = PARAMS + 'params_BRA' + filesep() + 'AGG_PMR19' + filesep() + 'CarbonTax_Diff_C_AGG_PMR19_'+ H_desag + '.csv';

function [continue_adj_IC, Diff_inf_IC, Diff_sup_IC, continue_adj_C, Diff_inf_C, Diff_sup_C] = adjust_Diff (Diff_inf_IC, Diff_sup_IC, Diff_inf_C, Diff_sup_C)

    // Read CarbonTax_Diff_IC headers
    CarbonTax_Diff_IC_csv = read_csv(CarbonTax_Diff_IC_path, ';');
    CarbonTax_Diff_IC_head_l = CarbonTax_Diff_IC_csv(1:(nb_sectors+1),1);
    CarbonTax_Diff_IC_head_c = CarbonTax_Diff_IC_csv(1,1:(nb_sectors+1));
    
    CarbonTax_Diff_C_csv = read_csv(CarbonTax_Diff_C_path, ';');
    CarbonTax_Diff_C_head_l = CarbonTax_Diff_C_csv(1:(nb_sectors+1),1);
    CarbonTax_Diff_C_head_c = CarbonTax_Diff_C_csv(1,1:(H_size+1));

    // Lance Imaclim
    TEST_MODE = %T;
    testing.countMax = 3;
    testing.debug_mode = %F;
    exec('ImaclimS.sce');
    
    // Réduction d'émission à atteindre
    goal_reduc_IC = 0.2 * ones(nb_sectors, nb_sectors);
    sensib_IC = 0.003 * ones(nb_sectors, nb_sectors);
    
    goal_reduc_C = 0.2 * ones(nb_sectors, H_size);
    sensib_C = 0.01 * ones(nb_sectors, H_size);
    
    // Réduction d'émission atteinte
    CO2Emis_IC_ini = Emission_Coef_IC .* ini.IC;
    CO2Emis_IC = Emission_Coef_IC .* IC;
    current_reduc_IC = divide((CO2Emis_IC_ini - CO2Emis_IC) , CO2Emis_IC_ini, 0);
    
    CO2Emis_C_ini = Emission_Coef_C .* ini.C;
    CO2Emis_C = Emission_Coef_C .* C;
    current_reduc_C = divide((CO2Emis_C_ini - CO2Emis_C) , CO2Emis_C_ini, 0);

    // Adapter CarbonTax_Diff_IC en fonction
    for i = 1:size(CarbonTax_Diff_IC,1)
        for j = 1:size(CarbonTax_Diff_IC,2)
            if Emission_Coef_IC(i,j) <> 0 then
                if current_reduc_IC(i,j) > goal_reduc_IC(i,j) then
                    // Réduction des émission trop importante -> baisser la taxe
                    Diff_sup_IC(i,j) = CarbonTax_Diff_IC(i,j);
                    CarbonTax_Diff_IC(i,j) = (Diff_sup_IC(i,j) + Diff_inf_IC(i,j)) / 2;
                elseif current_reduc_IC(i,j) < goal_reduc_IC(i,j)
                    // Réduction des émission trop faible -> augmenter la taxe
                    Diff_inf_IC(i,j) = CarbonTax_Diff_IC(i,j);
                    if Diff_sup_IC(i,j) == -1 then
                        CarbonTax_Diff_IC(i,j) = CarbonTax_Diff_IC(i,j) * 2;
                    else
                        CarbonTax_Diff_IC(i,j) = (Diff_sup_IC(i,j) + Diff_inf_IC(i,j)) / 2;
                    end
                end
            else
                CarbonTax_Diff_IC(i,j) = 0;
            end
        end
    end

    for i = 1:size(CarbonTax_Diff_C,1)
        for j = 1:size(CarbonTax_Diff_C,2)
            if Emission_Coef_C(i,j) <> 0 then
                if current_reduc_C(i,j) > goal_reduc_C(i,j) then
                    // Réduction des émission trop importante -> baisser la taxe
                    Diff_sup_C(i,j) = CarbonTax_Diff_C(i,j);
                    CarbonTax_Diff_C(i,j) = (Diff_sup_C(i,j) + Diff_inf_C(i,j)) / 2;
                elseif current_reduc_C(i,j) < goal_reduc_C(i,j)
                    // Réduction des émission trop faible -> augmenter la taxe
                    Diff_inf_C(i,j) = CarbonTax_Diff_C(i,j);
                    if Diff_sup_C(i,j) == -1 then
                        CarbonTax_Diff_C(i,j) = CarbonTax_Diff_C(i,j) * 2;
                    else
                        CarbonTax_Diff_C(i,j) = (Diff_sup_C(i,j) + Diff_inf_C(i,j)) / 2;
                    end
                end
            else
                CarbonTax_Diff_C(i,j) = 0;
            end
        end
    end
    
    // écris le résultat pour la suite
    csv_to_write_IC = []
    for i = 1:(nb_sectors+1)
        for j = 1:(nb_sectors+1)
            if i == 1 then
                csv_to_write_IC(i,j) = CarbonTax_Diff_IC_head_c(1,j);
            elseif j == 1 then
                csv_to_write_IC(i,j) = CarbonTax_Diff_IC_head_l(i,1);
            else
                csv_to_write_IC(i,j) = string(CarbonTax_Diff_IC(i-1,j-1));
            end
        end
    end
    
    csv_to_write_C = []
    for i = 1:(nb_sectors+1)
        for j = 1:(H_size+1)
            if i == 1 then
                csv_to_write_C(i,j) = CarbonTax_Diff_C_head_c(1,j);
            elseif j == 1 then
                csv_to_write_C(i,j) = CarbonTax_Diff_C_head_l(i,1);
            else
                csv_to_write_C(i,j) = string(CarbonTax_Diff_C(i-1,j-1));
            end
        end
    end
    
    csvWrite(csv_to_write_IC, CarbonTax_Diff_IC_path, ';');
    csvWrite(csv_to_write_C, CarbonTax_Diff_C_path, ';');
    
    continue_adj_IC = ( ( (Emission_Coef_IC <> 0) .* (current_reduc_IC > goal_reduc_IC + sensib_IC) ) | ( (Emission_Coef_IC <> 0) .* (current_reduc_IC < goal_reduc_IC - sensib_IC) ) ) & (CarbonTax_Diff_IC > 10e-5);
    continue_adj_C = ( ( (Emission_Coef_C <> 0) .* (current_reduc_C > goal_reduc_C + sensib_C) ) | ( (Emission_Coef_C <> 0) .* (current_reduc_C < goal_reduc_C - sensib_C) ) ) & (CarbonTax_Diff_C > 10e-5);


    interval_min = 1e-3;
    dimin = 0.1;

    for i = 1:size(CarbonTax_Diff_IC,1)
        for j = 1:size(CarbonTax_Diff_IC,2)
            if continue_adj_IC(i,j) then
                if abs(Diff_sup_IC(i,j) - Diff_inf_IC(i,j)) < interval_min then
                    Diff_inf_IC(i,j) = Diff_inf_IC(i,j) * (1 - dimin);
                    Diff_sup_IC(i,j) = Diff_sup_IC(i,j) * (1 + dimin);
                end
            end
        end
    end
    
    
    for i = 1:size(CarbonTax_Diff_C,1)
        for j = 1:size(CarbonTax_Diff_C,2)
            if continue_adj_C(i,j) then
                if abs(Diff_sup_C(i,j) - Diff_inf_C(i,j)) < interval_min then
                    Diff_inf_C(i,j) = 0;
                    Diff_sup_C(i,j) = -1;
                end
            end
        end
    end

endfunction

Diff_inf_IC = 0 * ones(nb_sectors, nb_sectors);
Diff_sup_IC = -1 * ones(nb_sectors, nb_sectors);
continue_adj_IC = %T * ones(nb_sectors, nb_sectors);

Diff_inf_C = 0 * ones(nb_sectors, H_size);
Diff_sup_C = -1 * ones(nb_sectors, H_size);
continue_adj_C = %T * ones(nb_sectors, H_size);

nb_exec = 0;
while(or(continue_adj_IC) | or(continue_adj_C))
    
    nb_exec = nb_exec + 1;
    
    disp('');
    printf('------------\n');
    printf('- EXEC N°' + string(nb_exec) + ' -\n');
    printf('------------\n');
    
    [continue_adj_IC, Diff_inf_IC, Diff_sup_IC, continue_adj_C, Diff_inf_C, Diff_sup_C] = adjust_Diff (Diff_inf_IC, Diff_sup_IC, Diff_inf_C, Diff_sup_C);
     
     
     
end

disp('CarbonTax_Diff IC & C found in ' + string(nb_exec) + ' executions of ImaclimS.sce.');
