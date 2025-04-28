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
test_fra_macro.study = ['SNBC3_RunChoices2'];
test_fra_macro.Optimization_Resol = ['%T'];
test_fra_macro.SystemOpt_Resol = ['SystemOpt_Static_neokeynesien']
test_fra_macro.AGG_type = ['AGG_23TME'];
test_fra_macro.H_DISAGG = ['HH1'];
test_fra_macro.Nb_Iter = ['3'];
test_fra_macro.Macro_nb = ['SNBC3_run3'];
test_fra_macro.Scenario = ['AMS_run3'];
test_fra_macro.proj_alpha = ['true'];
test_fra_macro.proj_kappa = ['true'];
test_fra_macro.proj_invest = ['true'];
test_fra_macro.proj_c = ['true'];
test_fra_macro.proj_imports = ['true'];
test_fra_macro.proj_exports = ['true'];
test_fra_macro.reindustrialisation_imports_bool = ['True'];
test_fra_macro.reindustrialisation_exports_bool = ['True'];
test_fra_macro.Proj_scenario = ['SNBC3_run3']
test_fra_macro.const_c = ['1','2','3','4','5','6','7','8','9']
// test_fra_macro.Proj_scenario = ['SNBC3_run323c1','SNBC3_run323c2','SNBC3_run323c3','SNBC3_run323c4','SNBC3_run323c5']
// test_fra_macro.Proj_scenario = ['SNBC3_run31','SNBC3_run32','SNBC3_run33','SNBC3_run34','SNBC3_run35','SNBC3_run36','SNBC3_run37','SNBC3_run38','SNBC3_run39','SNBC3_run310','SNBC3_run311','SNBC3_run312','SNBC3_run313','SNBC3_run314','SNBC3_run315','SNBC3_run316','SNBC3_run317','SNBC3_run318','SNBC3_run319','SNBC3_run320','SNBC3_run321','SNBC3_run322','SNBC3_run323'];
//test_fra_macro.VAR_sigma_CES = ['0.8','0.85','0.9'];
// test_fra_macro.VAR_ConstrainedShare_Capital = ['0.9'];
//test_fra_macro.VAR_sigma_KE = ['-0.3','-0.15'];
test_fra_macro.skip_calibration = ['True'];

france_macro = new_country(name_fra, iso_fra, test_fra_macro);



// ------------------------- *
// List of countries to test *
// ------------------------- * 

countries = list(france_macro); 
