

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
proj_alpha = %T;
proj_imports = %T;
proj_exports = %T;
proj_kappa = %T;
proj_c = %T;
proj_invest = %T;
proj_pY = %T;
proj_spemarg_rates_IC = %T;


// Valeurs par défaut (developpements faits par Jean)
emissions_bioenergy = %F;
Scenario_ETS = '';
Time_step_non_etudie = '999';
MaPrimRenov = %F;
Bonus_vehicule_dashboard = %F;
stranded_assets = %F;
pY_gas_reduced_v1 = %F;
pY_gas_reduced_v2 = %F;

// Valeurs par défaut (developpements faits par Remy)
eq_G_ConsumpBudget = '';



//////////////// CONFIG DASHBOARD SELON SCENARIOS ////////////////

// Scenarios SNBC3 run 1
if Scenario == 'AME' | Scenario == 'AMS' 
    Macro_nb = 'SNBC3_run2_avec_2035';
    Proj_scenario = 'SNBC3';
    Nb_Iter = 4;
    emissions_bioenergy = %T;
    SystemOpt_Resol = 'SystemOpt_Static_neokeynesien';
    pY_gas_reduced_v1 = %T;
    Time_step_non_etudie = 2;
    study = 'SNBC3_RunChoices';
    AGG_type = 'AGG_23TME';
    Invest_matrix = '%T';

elseif Scenario == 'AME_run2' | Scenario == 'AMS_run2'
    Macro_nb = 'SNBC3_run2';
    Proj_scenario = 'SNBC3_run2';
    Nb_Iter = 3;
    emissions_bioenergy = %T;
    pY_gas_reduced_v2 = %T;
    SystemOpt_Resol = 'SystemOpt_Static_neokeynesien';
    Time_step_non_etudie = 999;
    study = 'SNBC3_RunChoices';
    AGG_type = 'AGG_23TME';
    Invest_matrix = '%T';
    proj_alpha = %T;
    proj_imports = %T;
    proj_exports = %T;
    proj_c = %T;
    proj_kappa = %T;
    proj_invest = %T;
    proj_pY = %T;
    proj_spemarg_rates_IC = %F;
    reindustrialisation_imports_bool = %T;
    reindustrialisation_exports_bool = %T;


// Scenarios Decarbonation industrie - deuxieme iteration
elseif Scenario == 'AME_TESI_iter2' | Scenario == 'AMS_TESI_iter2' | Scenario == 'AME_TESI' | Scenario == 'AMS_TESI' | Scenario == 'AME_M3_CBAM_TESI' | Scenario == 'AMS_M3_CBAM_TESI' | Scenario =='AME_M3_CBAM_TESI'
    study = 'TESI_RunChoices';
    SystemOpt_Resol = 'SystemOpt_Static_TESI';
    AGG_type = 'AGG_23TME';
    Invest_matrix = '%T';
    Macro_nb = 'SNBC3_sans_2035';
    Proj_scenario = 'TESI';
    Nb_Iter = 3;
    emissions_bioenergy = %T;
    pY_gas_reduced_v1 = %T;
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
    emissions_bioenergy = %T;
    pY_gas_reduced_v1 = %T;
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




