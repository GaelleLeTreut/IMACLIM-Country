// Load the paths of the code
cd('..');
exec('Load_file_structure.sce');
cd(SIMUS);

// Read the csv of the simulation
simu_file_name = 'SimuTest.csv';
simu_path = SIMUS + simu_file_name;

// Initialisation **********
country_simu = ['Component', 'Name', ''];
dashboard_simu = [];
functions_simu = struct();
variables_simu = struct();
simulations = list();
// simulations category
simu_remove = 'Remove';
simu_add = 'Add';
simu_dash = 'Dash_changes';
remove_var = 'Remove_Var';
add_var = 'Add_Var';
simu_cat = [simu_remove, simu_add, simu_dash, remove_var, add_var];
// *************************

// headers
separation_head = '**********';
country_head = 'Country Selection';
dashboard_head = 'Dashboard';
functions_head = 'Functions';
variables_head = 'Variables';
simulations_head = 'Simulation';

exec('Read_Simu.sce');

// Enable test_mode in ImaclimS.sce
TEST_MODE = %T;

// Parameters of the tests
testing.countMax = 3;
testing.debug_mode = %F;

// To save Country_Selection and Dashboards
mkdir(SAVED_DATA);

getd(TEST_FULLCODE);

country_selection = 'Country_Selection.csv';
country_iso = country_simu(2,3);

// Save the current Country Selection file
save_file(country_selection, STUDY);
// Save the current Dashboard
dashboard_file_name = 'Dashboard_' + country_iso + '.csv';
study_frames_country = STUDY + 'study_frames_' + country_iso + filesep();
data_country = DATA + 'data_' + country_iso + filesep();
save_file(dashboard_file_name, study_frames_country);
// Save all the csv in Systeme_Resolution
// Save the var_resol
save_sys = 'Save_System_Resol' + filesep();
save_var_resol = 'Save_Var_Resol' + filesep();
mkdir(save_sys);
mkdir(save_var_resol);
// save syst resol
for f = listfiles(SYST_RESOL)'
    list_saved_files = listfiles(save_sys);
    if part(f,$-3:$) == '.csv' & (find(list_saved_files == f) == []) then
        copyfile(SYST_RESOL + f, save_sys);
    end
end
// save var resol
pref = 'Index_Imaclim_Var';
for f = listfiles(data_country)'
    list_saved_files = listfiles(save_var_resol);
    if part(f,1:length(pref)) == pref & (find(list_saved_files == f) == []) then
        copyfile(data_country + f, save_var_resol);
    end
end


// Write Country_Selection.csv of the tested country

// ****************************************************
csvWrite(country_simu, STUDY + country_selection, ';');
// ****************************************************

// Test each simulation
for simu = simulations
    // Write the dashboard
    
    // *****************************************************************************
    csvWrite(simu(dashboard_head), study_frames_country + dashboard_file_name, ';');
    // *****************************************************************************
    
    // Write the functions and var_resol
    // Tester que c'est bien sauvegardé
    // -> from the systeme resol
    // TODO : Systeme Resol dans le systeme de résolution !
    
    // Add/remove variables from var resol
     var_resol_file_name = 'Index_Imaclim_VarResol.csv';
     var_resol = read_csv(save_var_resol + var_resol_file_name, ';');
     var_resol = stripblanks(var_resol);
     // remove the variables to remove
     for var_line = simu(remove_var)
         ind_var = find(var_resol == var_line(1));
         if size(ind_var) == [1,1] then
             var_resol(ind_var,:) = [];
         else
             error('The variable ' + var_line(1) + 'cannot be removed, it is not in var resol : ' + var_resol_file_name);
         end
     end
     // add the variables to add
     for var_line = simu(add_var)
         ind_var = find(var_resol == var_line(1));
         if size(ind_var) == [1,1] then
             error('You try to add a variable which is already in Var_Resol : ' + """" var_line(1) + """" + ' / ' + var_resol_file_name );
         else
             var_resol($+1,1:size(var_line,2)) = var_line;
         end
     end
     // record the new file
     
     // ****************************************************
     csvWrite(var_resol, data_country + var_resol_file_name, ';');
     // ****************************************************
     
     // Change / add / remove  functions from system resol
     // teste si le mode optimization est activé
     opt_resol_entry = 'Optimization_Resol';
     systopt_resol_entry = 'SystemOpt_Resol';
     ind_opt_resol = find(simu(dashboard_head)(:,1) == opt_resol_entry);
     if size(ind_opt_resol) == [1,1] then
         val_opt_resol = simu(dashboard_head)(ind_opt_resol,2);
         if val_opt_resol == '%T' then
             ind_systopt = find(simu(dashboard_head)(:,1) == systopt_resol_entry);
             if size(ind_systopt) == [1,1] then
                 // charge le nom du systeme de resolution
                 systopt_resol_name = simu(dashboard_head)(ind_systopt,2);
                 // charge le fichier csv de fonctions
                 SystOpt_resol_Fun = read_csv(save_sys + systopt_resol_name + '.csv', ';');
                 // Supprime les fonctions à supprimer
                 for fun_line = simu(simu_remove)
                     // trouve la ligne à supprimer
                     ind_fun_line = -1;
                     for i = 1:size(SystOpt_resol_Fun,1)
                         sys_line = SystOpt_resol_Fun(i,:);
                         if sys_line(1:2) == fun_line(1:2) then
                             ind_fun_line = i;
                         end
                     end
                     if ind_fun_line == -1 then
                         disp(fun_line);
                         error('This functions is not defined in system opt resol, it cannot be removed.');
                     else
                         SystOpt_resol_Fun(ind_fun_line,:) = [];
                     end
                 end
                 // Ajoute les fonctions à ajouter
                 for fun_line = simu(simu_add)
                     SystOpt_resol_Fun($+1,1:3) = fun_line(1:3);
                 end
                 // enregistre le fichier de fonctions
                 
                 // *************************************
                 csvWrite(SystOpt_resol_Fun, SYST_RESOL + systopt_resol_name + '.csv', ';');
                 // *************************************
                 
             else
                 disp(simu(dashboard_head));
                 error("""" + systopt_resol_entry + """" + ' is not an entry of the dashboard of this simulation');
             end
         else
             warning('Mode optimization not activated in the dashboard : no change in the functions.');
         end
     else
         disp(simu(dashboard_head));
         error("""" + opt_resol_entry + """" + ' is not an entry of the dashboard of this simulation');
     end
     
    // launch imaclimS
    
    cd('..');
    launch_ImaclimS();
    cd(SIMUS);
    
    // TODO : travailler les outputs de la simulation : dans un dossier
    // TODO : affichage des simulations
    
end


// Restore Country_Selection
restore_file(country_selection, STUDY);
// Restore dashboard
restore_file(dashboard_file_name, study_frames_country);
// Restore all csv in Systeme_Resolution
for f = listfiles(save_sys)'
    movefile(save_sys + f, SYST_RESOL);
end
disp('  - Systeme resol files restored');
// restore the var resol
for f = listfiles(save_var_resol)'
    movefile(save_var_resol + f, data_country);
end
disp('  - Var Resol files restored');
