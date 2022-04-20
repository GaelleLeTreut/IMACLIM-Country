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
test_fra_macro.study = ['MacroIncer_RunChoices'];
test_fra_macro.Optimization_Resol = ['%T'];
test_fra_macro.SystemOpt_Resol = ['SystemOpt_Static'];
test_fra_macro.AGG_type = ['AGG_18TME'];
test_fra_macro.H_DISAGG = ['HH1'];
test_fra_macro.Recycling_Option = ['LabTax'];
test_fra_macro.Nb_Iter = ['2'];
test_fra_macro.Macro_nb = ['RefBC'];
test_fra_macro.Scenario = ['RefBC'];
test_fra_macro.World_prices = ['True'];
test_fra_macro.X_nonEnerg = ['True'];
test_fra_macro.Output_files = ['%T'];
test_fra_macro.VAR_MU = ['','Mu_low','Mu_high'];
test_fra_macro.VAR_pM = ['','pM_low','pM_high'];
test_fra_macro.VAR_Growth = ['','Growth_low','Growth_high'];
test_fra_macro.VAR_Immo = ['','Immo_low','Immo_high'];
test_fra_macro.VAR_sigma = ['','sigma_low','sigma_high'];
// test_fra_stat.Carbon_BTA = ['%T', '%F'];
// test_fra_stat.ClosCarbRev = ['CstNetLend','AllLabTax'];

france_macro = new_country(name_fra, iso_fra, test_fra_macro);



// ------------------------- *
// List of countries to test *
// ------------------------- * 

countries = list(france_macro); 
