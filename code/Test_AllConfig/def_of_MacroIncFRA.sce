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
test_fra_macro.study = ['SNBC3_RunChoices'];
test_fra_macro.Optimization_Resol = ['%T'];
test_fra_macro.SystemOpt_Resol = ['SystemOpt_Static_neokeynesien']
test_fra_macro.AGG_type = ['AGG_23TME'];
test_fra_macro.H_DISAGG = ['HH1'];
test_fra_macro.Nb_Iter = ['3'];
test_fra_macro.Macro_nb = ['SNBC3_run2'];
test_fra_macro.Scenario = ['AME_run20606'];
test_fra_macro.Proj_scenario = ['SNBC3test_run21'];
test_fra_macro.proj_alpha = ['true'];
test_fra_macro.proj_c = ['false'];
test_fra_macro.proj_kappa = ['true'];
// test_fra_macro.Proj_scenario = ['SNBC3test_run21','SNBC3test_run22','SNBC3test_run23','SNBC3test_run24','SNBC3test_run25','SNBC3test_run26','SNBC3test_run27','SNBC3test_run28','SNBC3test_run29','SNBC3test_run230','SNBC3test_run231'];


france_macro = new_country(name_fra, iso_fra, test_fra_macro);



// ------------------------- *
// List of countries to test *
// ------------------------- * 

countries = list(france_macro); 
