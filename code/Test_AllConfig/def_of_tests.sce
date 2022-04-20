// ----------------------------- *
// Define the data for the tests *
// ----------------------------- *

// * ------------------------------------------------------------- *
// * Argentina *
// * --------- *

name_arg = 'Argentina';
iso_arg = 'ARG';

//// Homothetic projection tests
test_arg_homo.System_Resol = ['Systeme_ProjHomothetic',''];
test_arg_homo.Optimization_Resol = ['%T'];
test_arg_homo.SystemOpt_Resol = ['SystemOpt_ProjHomo'];
test_arg_homo.study = ['Recursive_RunChoices'];
test_arg_homo.AGG_type = ['AGG_EnComp', ''];
test_arg_homo.Macro_nb = ['Current'];

argentina_homo = new_country(name_arg, iso_arg, test_arg_homo);


//// Scenario projection tests
test_arg_scen.System_Resol = ['Systeme_Static'];
test_arg_scen.Optimization_Resol = ['%T'];
test_arg_scen.SystemOpt_Resol = ['SystemOpt_Static'];

test_arg_scen.AGG_type = ['AGG_EnComp', ''];
test_arg_scen.Macro_nb = ['Current'];
test_arg_scen.Scenario = ['', 'NDC', 'CCS'];
test_arg_scen.Invest_matrix = ['%T', '%F'];
test_arg_scen.Carbon_BTA = ['%T', '%F'];

argentina_scen = new_country(name_arg, iso_arg, test_arg_scen);


// * ------------------------------------------------------------- *
// * Brasil *
// * ------ *

name_bra = 'Brasil';
iso_bra = 'BRA';

//// System static resolution test
test_bra_stat.System_Resol = ['Systeme_Ref_BRA'];
test_bra_stat.Optimization_Resol = ['%T'];
test_bra_stat.SystemOpt_Resol = ['SystemOpt_Ref_BRA'];

test_bra_stat.study = ['Static_RunChoices'];
test_bra_stat.AGG_type = ['AGG_PMR19', 'AGG_EnComp'];
test_bra_stat.H_DISAGG = ['HH1', 'H3', 'H4'];
test_bra_stat.Recycling_Option = ['PublicDeficit', 'LabTax'];
test_bra_stat.Carbon_BTA = ['%T', '%F'];

brasil_stat = new_country(name_bra, iso_bra, test_bra_stat);

//// homothetic projection tests
test_bra_homo.System_Resol = ['Systeme_ProjHomot_BRA'];
test_bra_homo.Optimization_Resol = ['%T'];
test_bra_homo.SystemOpt_Resol=['SystemOpt_ProjHomo_BRA'];
test_bra_homo.study = ['Recursive_RunChoices'];
test_bra_homo.AGG_type = ['AGG_PMR19', 'AGG_EnComp'];
test_bra_homo.H_DISAGG = ['HH1', 'H3', 'H4'];
test_bra_homo.Macro_nb = ['NDC'];

brasil_homo = new_country(name_bra, iso_bra, test_bra_homo);

//// Scenario projection tests
test_bra_scen.System_Resol = ['Systeme_Ref_BRA'];
test_bra_scen.Optimization_Resol = ['%T'];
test_bra_scen.SystemOpt_Resol = ['SystemOpt_Ref_BRA'];
test_bra_scen.Capital_Dynamics = ['%T', '%F'];
test_bra_scen.AGG_type = ['AGG_PMR19', 'AGG_EnComp'];
test_bra_scen.H_DISAGG = ['HH1', 'H3', 'H4'];
test_bra_scen.Scenario = ['PMR_Ref_Disag'];
test_bra_scen.Macro_nb = ['NDC'];
test_bra_scen.World_prices = ['True','False'];
// test_bra_scen.Recycling_Option = ['PublicDeficit', 'LabTax'];
test_bra_scen.Carbon_BTA = ['%T', '%F'];

brasil_scen = new_country(name_bra, iso_bra, test_bra_scen);

//// Specific scenario
test_bra_scenPMR.System_Resol = ['Systeme_Ref_BRA'];
test_bra_scenPMR.Optimization_Resol = ['%T'];
test_bra_scenPMR.SystemOpt_Resol = ['SystemOpt_Ref_BRA'];
test_bra_scenPMR.Capital_Dynamics = ['%T', '%F'];
test_bra_scenPMR.AGG_type = ['AGG_PMR19'];
test_bra_scenPMR.H_DISAGG = ['HH1', 'H3', 'H4'];
test_bra_scenPMR.Scenario = ['PMR_Ref'];
test_bra_scenPMR.Macro_nb = ['NDC'];
test_bra_scenPMR.World_prices = ['True','False'];
test_bra_scenPMR.Carbon_BTA = ['%T', '%F'];
// test_bra_scenPMR.Recycling_Option = ['PublicDeficit', 'LabTax'];

brasil_scenPMR = new_country(name_bra, iso_bra, test_bra_scenPMR);

// * ------------------------------------------------------------- *
// * France *
// * ------ *

name_fra = 'France';
iso_fra = 'FRA';

//// Static resolution tests
test_fra_stat.System_Resol = ['Systeme_Static'];
test_fra_stat.study = ['Static_RunChoices'];
test_fra_stat.Optimization_Resol = ['%T'];
test_fra_stat.SystemOpt_Resol = ['SystemOpt_Static'];
test_fra_stat.AGG_type = ['AGG_SNBC17', 'AGG_IndEner', ..
'AGG_MetMinEn', 'AGG_Ener1', 'AGG_Ener2', 'AGG_4Sec', 'AGG_3Sec', 'AGG_EnComp'];
test_fra_stat.H_DISAGG = ['HH1', 'H10'];
test_fra_stat.Recycling_Option = ['PublicDeficit', 'LabTax'];
//// test_fra_stat.Carbon_BTA = ['%T', '%F'];
//// test_fra_stat.ClosCarbRev = ['CstNetLend','AllLabTax'];


france_stat = new_country(name_fra, iso_fra, test_fra_stat);

//// homothetic projection tests
test_fra_homo.System_Resol = ['Systeme_ProjHomothetic'];
test_fra_homo.Optimization_Resol = ['%T'];
test_fra_homo.SystemOpt_Resol = ['SystemOpt_ProjHomo'];
test_fra_homo.study = ['Recursive_RunChoices'];
test_fra_homo.AGG_type = ['AGG_SNBC17','AGG_IndEner', ..
'AGG_MetMinEn', 'AGG_Ener1', 'AGG_Ener2', 'AGG_4Sec', 'AGG_3Sec', 'AGG_EnComp'];
test_fra_homo.H_DISAGG = ['HH1', 'H10'];
test_fra_homo.Macro_nb = ['NDC','2deg'];

france_homo = new_country(name_fra, iso_fra, test_fra_homo);

////Scenario projection tests
test_fra_scen.System_Resol = ['Systeme_Static'];
test_fra_scen.Optimization_Resol = ['%T'];
test_fra_scen.SystemOpt_Resol = ['SystemOpt_Static'];
test_fra_scen.AGG_type = ['AGG_SNBC17'];
test_fra_scen.Scenario = ['AME_desag', 'AMS_desag'];
test_fra_scen.Macro_nb = ['NDC','2deg'];
test_fra_scen.World_prices = ['True','False'];
test_fra_scen.X_nonEnerg = ['True','False'];
test_fra_scen.Recycling_Option = ['PublicDeficit', 'LabTax'];
// test_fra_scen.Carbon_BTA = ['%T', '%F'];

france_scen = new_country(name_fra, iso_fra, test_fra_scen);

// Recalib tests /// TO CHECK
// test_fra_recalib.System_Resol = ['Systeme_Static_recalib'];
// test_fra_recalib.AGG_type = ['AGG_SNBC15'];
// test_fra_recalib.H_DISAGG = ['HH1', 'H10'];
// test_fra_recalib.Scenario = ['Recalib'];

// france_recalib = new_country(name_fra, iso_fra, test_fra_recalib);

// * ------------------------------------------------------------- *


// name_fra = 'France';
// iso_fra = 'FRA2018';

//// MacroIncer resolution tests
// test_fra_macro.System_Resol = ['Systeme_ProjHomothetic'];
// test_fra_macro.study = ['MacroIncer_RunChoices'];
// test_fra_macro.Optimization_Resol = ['%T'];
// test_fra_macro.SystemOpt_Resol = ['SystemOpt_MacroInc'];
// test_fra_macro.AGG_type = ['AGG_18TME'];
// test_fra_macro.H_DISAGG = ['HH1'];
// test_fra_macro.Recycling_Option = ['LabTax'];
// test_fra_macro.Nb_Iter = ['2'];
// test_fra_macro.Macro_nb = ['RefBC'];
// test_fra_macro.Scenario = ['RefBC'];
// test_fra_macro.World_prices = ['True'];
// test_fra_macro.X_nonEnerg = ['True'];
// test_fra_macro.Output_files = ['%T'];
// test_fra_macro.VAR_MU = ['','Mu_low','Mu_high'];
// test_fra_macro.VAR_pM = ['','pM_low','pM_high'];
// test_fra_macro.VAR_Growth = ['','Growth_low','Growth_high'];
// test_fra_macro.VAR_Immo = ['','Immo_low','Immo_high'];
// test_fra_macro.VAR_sigma = ['','sigma_low','sigma_high'];
/////// test_fra_macro.Carbon_BTA = ['%T', '%F'];
// test_fra_macro.ClosCarbRev = ['CstNetLend'];
// test_fra_macro.ClosPubBudget = ['CstNetLend','CstConsumpt'];

// france_macro = new_country(name_fra, iso_fra, test_fra_macro);


// ------------------------- *
// List of countries to test *
// ------------------------- * 

countries = list(argentina_homo, argentina_scen, brasil_stat, brasil_scen, brasil_scenPMR, france_stat, france_scen);
// countries = list(france_macro); 

// brasil_scenPMR
// TO DO
// countries = list(france_stat);
