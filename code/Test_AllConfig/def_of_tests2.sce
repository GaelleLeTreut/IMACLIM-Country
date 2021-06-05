// ----------------------------- *
// Define the data for the tests *
// ----------------------------- *



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
// test_fra_stat.Carbon_BTA = ['%T', '%F'];
// test_fra_stat.ClosCarbRev = ['CstNetLend','AllLabTax'];

france_macro = new_country(name_fra, iso_fra, test_fra_macro);

// //// homothetic projection tests
// test_fra_homo.System_Resol = ['Systeme_ProjHomothetic'];
// test_fra_homo.Optimization_Resol = ['%T'];
// test_fra_homo.SystemOpt_Resol = ['SystemOpt_ProjHomo'];
// test_fra_homo.study = ['Recursive_RunChoices'];
// test_fra_homo.AGG_type = ['AGG_SNBC17','AGG_IndEner', ..
// 'AGG_MetMinEn', 'AGG_Ener1', 'AGG_Ener2', 'AGG_4Sec', 'AGG_3Sec', 'AGG_EnComp'];
// test_fra_homo.H_DISAGG = ['HH1', 'H10'];
// test_fra_homo.Macro_nb = ['NDC','2deg'];

// france_homo = new_country(name_fra, iso_fra, test_fra_homo);

// //// Scenario projection tests
// test_fra_scen.System_Resol = ['Systeme_Static'];
// test_fra_scen.Optimization_Resol = ['%T'];
// test_fra_scen.SystemOpt_Resol = ['SystemOpt_Static'];
// test_fra_scen.AGG_type = ['AGG_SNBC17'];
// test_fra_scen.Scenario = ['AME_desag', 'AMS_desag'];
// test_fra_scen.Macro_nb = ['NDC','2deg'];
// test_fra_scen.World_prices = ['True','False'];
// test_fra_scen.X_nonEnerg = ['True','False'];
// test_fra_scen.Recycling_Option = ['PublicDeficit', 'LabTax'];
// // test_fra_scen.Carbon_BTA = ['%T', '%F'];

// france_scen = new_country(name_fra, iso_fra, test_fra_scen);

// //// Recalib tests /// TO CHECK
// test_fra_recalib.System_Resol = ['Systeme_Static_recalib'];
// test_fra_recalib.AGG_type = ['AGG_SNBC15'];
// test_fra_recalib.H_DISAGG = ['HH1', 'H10'];
// test_fra_recalib.Scenario = ['Recalib'];

// france_recalib = new_country(name_fra, iso_fra, test_fra_recalib);

// * ------------------------------------------------------------- *


// ------------------------- *
// List of countries to test *
// ------------------------- * 

// countries = list(argentina, brasil); //, brasil_scenario, france, france_scenario);
countries = list(france_macro); 

// brasil_scenPMR
// TO DO
// countries = list(france_stat);
