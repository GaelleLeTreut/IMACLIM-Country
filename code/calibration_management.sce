// If skip_calibration != 'True', we execute Calibration.sce, then we save all variables created during Calibration.sce in
// a binary file named "sauvegarde_variables_calibration_" + AGG_type ('AGG_23TME' for example), in IMACLIM-Country/code/
// If skip_calibration = 'True', we only load this binary file.
if ~skip_calibration

    // Get all variable names before calibration
    save('sauvegarde_variables_pre_calibration');
    [variable_names,types,dims,vols] = listvarinfile('sauvegarde_variables_pre_calibration');

    // Execute Calibration.sce
    exec("Calibration.sce");
    
    // Get all variable names after calibration
    save('sauvegarde_variables_post_calibration');
    [variable_names2,types,dims,vols] = listvarinfile('sauvegarde_variables_post_calibration');
    
    // Function to check if a string is in a list
    function [res] = check_string_in_list(list, string)
        for i=1:length(length(list))
            if list(i) == string then
                res = %t;
                return;
            end
        end
        res = %f;
    endfunction
    
    // Select every variable created in calibration
    variables_to_load = [];
    for i = 1:length(length(variable_names2))
        if ~check_string_in_list(variable_names, variable_names2(i)) then
            variables_to_load = [variables_to_load, variable_names2(i)];
        end
    end

    // Save all variables created in calibration. It creates a binary file in IMACLIM-Country/code/
    save('sauvegarde_variables_calibration_' + AGG_type, variables_to_load);

    // Delete the temporary files created
    mdelete('sauvegarde_variables_pre_calibration');
    mdelete('sauvegarde_variables_post_calibration');

else
    printf("Calibration skipped \n");

    // Load all variables created in calibration
    load('sauvegarde_variables_calibration_' + AGG_type);
end