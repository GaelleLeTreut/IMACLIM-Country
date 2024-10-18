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
test_fra_macro.Scenario = ['AMS_run20606'];
// test_fra_macro.Proj_scenario = ['SNBC3test_run21'];
test_fra_macro.proj_alpha = ['true'];
test_fra_macro.proj_kappa = ['true'];
test_fra_macro.proj_invest = ['false'];
test_fra_macro.proj_c = ['false'];
test_fra_macro.proj_imports = ['false'];
test_fra_macro.proj_exports = ['false'];
test_fra_macro.reindustrialisation_imports_bool = ['false'];
test_fra_macro.reindustrialisation_exports_bool = ['false'];
// test_fra_macro.Proj_scenario = ['SNBC3test_run21','SNBC3test_run25'];
//test_fra_macro.Proj_scenario = ['SNBC3test_run21','SNBC3test_run22','SNBC3test_run23','SNBC3test_run24','SNBC3test_run25','SNBC3test_run26','SNBC3test_run27','SNBC3test_run28','SNBC3test_run29','SNBC3test_run210','SNBC3test_run211','SNBC3test_run212','SNBC3test_run213','SNBC3test_run214','SNBC3test_run215','SNBC3test_run216','SNBC3test_run217','SNBC3test_run218','SNBC3test_run219','SNBC3test_run220','SNBC3test_run221','SNBC3test_run222','SNBC3test_run223'];
//test_fra_macro.Proj_scenario = ['SNBC3test_irun21','SNBC3test_irun22','SNBC3test_irun23','SNBC3test_irun24','SNBC3test_irun25','SNBC3test_irun26','SNBC3test_irun27','SNBC3test_irun28','SNBC3test_irun29','SNBC3test_irun210','SNBC3test_irun211','SNBC3test_irun212','SNBC3test_irun213','SNBC3test_irun214','SNBC3test_irun215','SNBC3test_irun216','SNBC3test_irun217','SNBC3test_irun218','SNBC3test_irun219','SNBC3test_irun220','SNBC3test_irun221','SNBC3test_irun222','SNBC3test_irun223'];
test_fra_macro.Proj_scenario = ['SNBC3test_run21','SNBC3test_run22','SNBC3test_run23','SNBC3test_run24']
// test_fra_macro.Proj_scenario = ['SNBC3test_runall'];
//test_fra_macro.VAR_sigma_CES = ['0.8','0.85','0.9'];
// test_fra_macro.VAR_ConstrainedShare_Capital = ['0.9'];
//test_fra_macro.VAR_sigma_KE = ['-0.3','-0.15'];
test_fra_macro.skip_calibration = ['True'];

france_macro = new_country(name_fra, iso_fra, test_fra_macro);



// ------------------------- *
// List of countries to test *
// ------------------------- * 

countries = list(france_macro); 
