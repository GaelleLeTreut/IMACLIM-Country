// ----------------------------- *
// Define the data for the tests *
// ----------------------------- *

/// Parameters of the tests
// Enable TEST_MODE in ImaclimS.sce
TEST_MODE = %F;
// No test mode for these tests


// * ------------------------------------------------------------- *
// * France *
// * ------ *

name_fra = 'France';
iso_fra = 'FRA2018';

//// MacroIncer resolution tests
test_fra_macro.System_Resol = ['Systeme_ProjHomothetic'];
test_fra_macro.study = ['ademetransitions_RunChoices'];
test_fra_macro.Optimization_Resol = ['%T'];
test_fra_macro.SystemOpt_Resol = ['SystemOpt_Staticdemandces']
test_fra_macro.AGG_type = ['AGG_19TME'];
test_fra_macro.H_DISAGG = ['HH1'];
test_fra_macro.Nb_Iter = ['2'];
test_fra_macro.Macro_nb = ['ademetransitions'];
test_fra_macro.Scenario = ['S2'];
test_fra_macro.World_prices = ['True'];
test_fra_macro.X_nonEnerg = ['True'];
test_fra_macro.Output_files = ['%T'];
test_fra_macro.eq_G_ConsumpBudget = ['G_ConsumpBudget_Val_4'];
test_fra_macro.VAR_coef_real_wage = ['ref'];
test_fra_macro.VAR_C_basic_need = ['low'];
test_fra_macro.VAR_emis = ['ref'];
test_fra_macro.VAR_Mu = ['ref','low','high'];
test_fra_macro.VAR_saving = ['ref','low','high'];
test_fra_macro.VAR_population = ['ref','low','high'];
test_fra_macro.VAR_import_enersect = ['ref','low','high'];
test_fra_macro.trade_drive = ['exports_detailed','exports_detailed_low','exports_detailed_high'];
test_fra_macro.VAR_sigma_omegaU = ['ademevalue']
test_fra_macro.VAR_sigma_MX = ['ref'];
test_fra_macro.Spe_margs_Profit_margin_gaz_reduced = ['false'];
test_fra_macro.pY_ini_gaz_controlled_eco_eq = ['false'];
test_fra_macro.proj_alpha = ['false'];
test_fra_macro.proj_c = ['false'];
test_fra_macro.proj_kappa = ['false'];
test_fra_macro.Time_step_non_etudie = ['9999'];
// test_fra_macro.VAR_sigma_ConsoBudget = ['ref'];
// test_fra_macro.VAR_sigma_pC = ['ref'];
// test_fra_macro.VAR_delta_pM = ['ref'];
// test_fra_macro.VAR_choice_X = [''];
// test_fra_macro.Recycling_Option = ['LabTax'];
// test_fra_macro.VAR_pM = ['','pM_low','pM_high'];
// test_fra_macro.VAR_Growth = ['','Growth_low','Growth_high'];
// test_fra_macro.VAR_Immo = ['','Immo_low','Immo_high'];
// test_fra_stat.Carbon_BTA = ['%T', '%F'];
// test_fra_stat.ClosCarbRev = ['CstNetLend','AllLabTax'];

france_macro = new_country(name_fra, iso_fra, test_fra_macro);



// ------------------------- *
// List of countries to test *
// ------------------------- * 

countries = list(france_macro); 
