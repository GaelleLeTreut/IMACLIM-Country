

//////////////// CONFIG DASHBOARD PAR DEFAUT ////////////////
Coef_real_wage_dashboard = "1";
sigma_omegaU_dashboard = "-0.1";
Carbone_ETS = 'False';
Carbon_BTA = '%F';
CarbonTaxDiff = '%F';
Recycling_Option = '';
ClosCarbRev = 'CstNetLend';
ClosPubBudget = '';
System_Resol = 'Systeme_ProjHomothetic';
Optimization_Resol = '%T';
Capital_Dynamics = '%F';
H_DISAGG = 'HH1';
Resol_Mode = 'Dynamic_projection';
Demographic_shift = 'True';
Labour_product = 'True';
World_prices = 'True';
X_nonEnerg = 'True';
Invest_matrix = '%F';
CO2_footprint = 'False';
Output_files = '%T';
Output_prints = '%F';


// Pour pouvoir desactiver les projections qui sont toujours mises a %T dans projection_scenario.csv
proj_alpha = 'true';
proj_imports = 'true';
proj_exports = 'true';
proj_kappa = 'true';
proj_c = 'true';
proj_invest = 'true';
proj_pY = 'true';
proj_spemarg_rates_IC = 'true';


// Valeurs par défaut (developpements faits par Jean)
emissions_bioenergy = 'False';
Scenario_ETS = '';
Time_step_non_etudie = '999';
MaPrimRenov = 'False';
Bonus_vehicule_dashboard = 'False';
stranded_assets = 'False';
pY_gas_reduced_v1 = 'False';
pY_gas_reduced_v2 = 'False';

// Valeurs par défaut (developpements faits par Remy)
eq_G_ConsumpBudget = '';



//////////////// CONFIG DASHBOARD SELON SCENARIOS ////////////////

// Scenarios SNBC3 run 1
if Scenario == 'AME' | Scenario == 'AMS' 
    Macro_nb = 'SNBC3_run2_avec_2035';
    Proj_scenario = 'SNBC3';
    Nb_Iter = 4;
    emissions_bioenergy = 'True';
    SystemOpt_Resol = 'SystemOpt_Static_neokeynesien';
    pY_gas_reduced_v1 = 'True';
    Time_step_non_etudie = 2;
    study = 'SNBC3_RunChoices';
    AGG_type = 'AGG_23TME';
    Invest_matrix = '%T';

// Scenarios SNBC3 run 2
elseif Scenario == 'AME_run2' | Scenario == 'AMS_run2' 
    Macro_nb = 'SNBC3_run2';
    Proj_scenario = 'SNBC3_run2';
    Nb_Iter = 3;
    emissions_bioenergy = 'False';
    SystemOpt_Resol = 'SystemOpt_Static_neokeynesien';
    pY_gas_reduced_v1 = 'True';
    Time_step_non_etudie = 999;
    study = 'SNBC3_RunChoices';
    AGG_type = 'AGG_23TME';
    Invest_matrix = '%T';

elseif Scenario == 'AME_run2test' | Scenario == 'AMS_run2test' | Scenario == 'AME_run20606' | Scenario == 'AMS_run20606' 
    Macro_nb = 'SNBC3_run2';
    Proj_scenario = 'SNBC3test2_run2';
    Nb_Iter = 3;
    emissions_bioenergy = 'True';
    SystemOpt_Resol = 'SystemOpt_Static_neokeynesienlesdemand';
    pY_gas_reduced_v2 = 'True';
    SystemOpt_Resol = 'SystemOpt_Static_neokeynesien';
    pY_gas_reduced = 'True';
    Time_step_non_etudie = 999;
    study = 'SNBC3_RunChoices';
    AGG_type = 'AGG_23TME';
    Invest_matrix = '%T';
    proj_alpha = 'true';
    proj_imports = 'false';
    proj_exports = 'false';
    proj_c = 'false';
    proj_kappa = 'true';
    proj_invest = 'false';
    proj_pY = 'false';
    proj_spemarg_rates_IC = 'false';


// Scenarios Decarbonation industrie - OLD
elseif Scenario == 'AME_TISE' | Scenario == 'AMS_TISE'
    study = 'TESI_RunChoices';
    SystemOpt_Resol = 'SystemOpt_Static_TESI';
    AGG_type = 'AGG_23TME';
    Invest_matrix = '%T';
    Macro_nb = 'SNBC3_sans_2035';
    Proj_scenario = 'TESI';
    Nb_Iter = 3;
    emissions_bioenergy = 'True';
    pY_gas_reduced_v1 = 'True';
    Time_step_non_etudie = 999;
    
    Carbone_ETS = 'True';
    Carbon_BTA = '%T';
    Scenario_ETS = 'AMS_TISE_high_ETS';


// Scenarios Decarbonation industrie - deuxieme iteration
elseif Scenario == 'AME_TESI_iter2' | Scenario == 'AMS_TESI_iter2' | Scenario == 'AME_TESI' | Scenario == 'AMS_TESI' | Scenario == 'AME_M3_CBAM_TESI' | Scenario == 'AMS_M3_CBAM_TESI' | Scenario =='AME_M3_CBAM_TESI'
    study = 'TESI_RunChoices';
    SystemOpt_Resol = 'SystemOpt_Static_TESI';
    AGG_type = 'AGG_23TME';
    Invest_matrix = '%T';
    Macro_nb = 'SNBC3_sans_2035';
    Proj_scenario = 'TESI';
    Nb_Iter = 3;
    emissions_bioenergy = 'True';
    pY_gas_reduced_v1 = 'True';
    Time_step_non_etudie = 999;
    
    Carbone_ETS = 'True';
    Carbon_BTA = '%T';
    Scenario_ETS = 'AMS_TESI_high_ETS';

// Sans CBAM : on desactive juste Carbon_BTA
elseif Scenario == 'AME_M3_sans_CBAM_TESI' | Scenario == 'AMS_M3_sans_CBAM_TESI' | Scenario == 'AME_normal_sans_CBAM_TESI' | Scenario == 'AMS_normal_sans_CBAM_TESI' | Scenario =='AME_normal_sans_CBAM_TESI' | Scenario =='AME_M3_sans_CBAM_TESI'
    study = 'TESI_RunChoices';
    SystemOpt_Resol = 'SystemOpt_Static_TESI';
    AGG_type = 'AGG_23TME';
    Invest_matrix = '%T';
    Macro_nb = 'SNBC3_sans_2035';
    Proj_scenario = 'TESI';
    Nb_Iter = 3;
    emissions_bioenergy = 'True';
    pY_gas_reduced_v1 = 'True';
    Time_step_non_etudie = 999;
    
    Carbone_ETS = 'True';
    Carbon_BTA = '%F';
    Scenario_ETS = 'AMS_TESI_high_ETS';

// Scenarios Ademe incertitudes
elseif Scenario == 'S2' | Scenario == 'S3'
    Macro_nb = 'ademetransitions';
    Proj_scenario = 'branche_macro_incertitudes';
    Nb_Iter = 2;
    SystemOpt_Resol = 'SystemOpt_Static';
    study = 'ademetransitions_RunChoices';
    AGG_type = 'AGG_19TME';

    VAR_Mu = 'ref';
    VAR_sigma_MX = 'ref';
    VAR_saving = 'neutral';
    VAR_sigma_omegaU = 'ademevalue';
    VAR_coef_real_wage = 'ref';
    VAR_C_basic_need = 'low';
    VAR_sigma_ConsoBudget = 'ref';
    VAR_sigma_pC = 'ref';
    VAR_sigma = 'ref';
    VAR_delta_pM = 'ref';
    trade_drive = 'exports_detailed';
    eq_G_ConsumpBudget = 'G_ConsumpBudget_Val_4';
    VAR_import_enersect = 'ref';
    VAR_population = 'ref';
    VAR_emis = 'ref';
    

    if Scenario == 'S2'


    elseif Scenario == 'S3'
        

    end

end




