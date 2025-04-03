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
test_fra_macro.proj_invest = ['false'];
test_fra_macro.proj_c = ['false'];
test_fra_macro.proj_imports = ['false'];
test_fra_macro.proj_exports = ['false'];
test_fra_macro.reindustrialisation_imports_bool = ['false'];
test_fra_macro.reindustrialisation_exports_bool = ['false'];
// test_fra_macro.Proj_scenario = ['SNBC3test_run31alpha','SNBC3test_run32alpha','SNBC3test_run33alpha','SNBC3test_run34alpha','SNBC3test_run35alpha','SNBC3test_run36alpha','SNBC3test_run37alpha','SNBC3test_run38alpha','SNBC3test_run39alpha','SNBC3test_run310alpha','SNBC3test_run311alpha','SNBC3test_run312alpha','SNBC3test_run313alpha','SNBC3test_run314alpha','SNBC3test_run315alpha','SNBC3test_run316alpha','SNBC3test_run317alpha','SNBC3test_run318alpha','SNBC3test_run319alpha','SNBC3test_run320alpha','SNBC3test_run321alpha','SNBC3test_run322alpha','SNBC3test_run323alpha'];
test_fra_macro.Proj_scenario = ['SNBC3test_run31','SNBC3test_run32','SNBC3test_run33','SNBC3test_run34','SNBC3test_run35','SNBC3test_run36','SNBC3test_run37','SNBC3test_run38','SNBC3test_run39','SNBC3test_run310','SNBC3test_run311','SNBC3test_run312','SNBC3test_run313','SNBC3test_run314','SNBC3test_run315','SNBC3test_run316','SNBC3test_run317','SNBC3test_run318','SNBC3test_run319','SNBC3test_run320','SNBC3test_run321','SNBC3test_run322','SNBC3test_run323'];
// test_fra_macro.Proj_scenario = ['SNBC3test_run323']
// test_fra_macro.Proj_scenario = ['SNBC3test_irun31','SNBC3test_irun32','SNBC3test_irun33','SNBC3test_irun34','SNBC3test_irun35','SNBC3test_irun36','SNBC3test_irun37','SNBC3test_irun38','SNBC3test_irun39','SNBC3test_irun310','SNBC3test_irun311','SNBC3test_irun312','SNBC3test_irun313','SNBC3test_irun314','SNBC3test_irun315','SNBC3test_irun316','SNBC3test_irun317','SNBC3test_irun318','SNBC3test_irun319','SNBC3test_irun320','SNBC3test_irun321','SNBC3test_irun322','SNBC3test_irun323'];
// test_fra_macro.Proj_scenario = ['SNBC3test_gr1'];
//test_fra_macro.VAR_sigma_CES = ['0.8','0.85','0.9'];
// test_fra_macro.VAR_ConstrainedShare_Capital = ['0.9'];
//test_fra_macro.VAR_sigma_KE = ['-0.3','-0.15'];
test_fra_macro.skip_calibration = ['True'];

france_macro = new_country(name_fra, iso_fra, test_fra_macro);



// ------------------------- *
// List of countries to test *
// ------------------------- * 

countries = list(france_macro); 
