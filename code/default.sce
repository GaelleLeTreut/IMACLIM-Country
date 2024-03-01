

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
pY_gas_reduced = 'False';
emissions_bioenergy = 'False';
Scenario_ETS = '';
Time_step_non_etudie = '999';
MaPrimRenov = 'False';
Bonus_vehicule_dashboard = 'False';
stranded_assets = 'False';


// Valeurs par défaut (developpements faits par Remy)
eq_G_ConsumpBudget = '';



//////////////// CONFIG DASHBOARD SELON SCENARIOS ////////////////

scenarios_SNBC3_run1 = ['AME', 'AMS'];
scenarios_SNBC3_run2 = ['AME_run2', 'AMS_run2'];
scenarios_SNBC3_TISE = ['AME_TISE', 'AMS_TISE'];
scenarios_Ademe_transitions = ['S2', 'S3'];

// Scenarios SNBC3 run 1
if grep(scenarios_SNBC3_run1, Scenario) > 0
    Macro_nb = 'SNBC3';
    Proj_scenario = 'SNBC3';
    Nb_Iter = 4;
    emissions_bioenergy = 'True';
    SystemOpt_Resol = 'SystemOpt_Static_neokeynesien';
    pY_gas_reduced = 'True';
    Time_step_non_etudie = 2;
    study = 'SNBC3_RunChoices';
    AGG_type = 'AGG_23TME';
    Invest_matrix = '%T';

// Scenarios SNBC3 run 2
elseif grep(scenarios_SNBC3_run2, Scenario) > 0
    Macro_nb = 'SNBC3_run2';
    Proj_scenario = 'SNBC3_run2';
    Nb_Iter = 3;
    emissions_bioenergy = 'False';
    SystemOpt_Resol = 'SystemOpt_Static_neokeynesien';
    pY_gas_reduced = 'True';
    Time_step_non_etudie = 999;
    study = 'SNBC3_RunChoices';
    AGG_type = 'AGG_23TME';
    Invest_matrix = '%T';


// Scenarios Decarbonation industrie
elseif grep(scenarios_SNBC3_TISE, Scenario) > 0
    study = 'SNBC3_RunChoices';
    SystemOpt_Resol = 'SystemOpt_Static_neokeynesien';
    AGG_type = 'AGG_23TME';
    Invest_matrix = '%T';
    Macro_nb = 'SNBC3_sans_2035';
    Proj_scenario = 'TISE';
    Nb_Iter = 3;
    emissions_bioenergy = 'True';
    pY_gas_reduced = 'True';
    Time_step_non_etudie = 999;
    
    Carbone_ETS = 'True';
    Carbon_BTA = '%T';
    Scenario_ETS = 'AMS_TISE_high_ETS';


// Scenarios Ademe incertitudes
elseif grep(scenarios_Ademe_transitions, Scenario) > 0
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




