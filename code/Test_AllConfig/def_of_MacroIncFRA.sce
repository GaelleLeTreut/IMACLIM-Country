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
test_fra_macro.study = ['SNBC3_RunChoices3'];
test_fra_macro.Optimization_Resol = ['%T'];
test_fra_macro.SystemOpt_Resol = ['SystemOpt_Static_neokeynesien']
test_fra_macro.AGG_type = ['AGG_23TME'];
test_fra_macro.H_DISAGG = ['HH1'];
test_fra_macro.Nb_Iter = ['3'];
test_fra_macro.Macro_nb = ['SNBC3_run3dgt2'];
test_fra_macro.Scenario = ['AMSrun3mix2'];
test_fra_macro.proj_alpha = ['false'];
test_fra_macro.proj_kappa = ['false'];
test_fra_macro.proj_invest = ['true'];
test_fra_macro.proj_c = ['false'];
test_fra_macro.proj_imports = ['false'];
test_fra_macro.proj_exports = ['false'];
test_fra_macro.proj_pY = ['false'];
test_fra_macro.pY_gas_reduced_v2 = ['false'];
test_fra_macro.reindustrialisation_imports_bool = ['false'];
test_fra_macro.reindustrialisation_exports_bool = ['false'];
// test_fra_macro.Proj_scenario = ['sx1','sx2','sx3','sx4','sx5','sx6','sx7','sx8','sx9','sx10','sx11','sx12','sx13','sx14','sx15','sx16','sx17','sx18']
test_fra_macro.Proj_scenario = ['SNBC3_run3totalamsmix']
// test_fra_macro.Proj_scenario = ['SNBC3_run323c0','SNBC3_run323c1','SNBC3_run323c2','SNBC3_run323c3','SNBC3_run323c4','SNBC3_run323c5']
// test_fra_macro.Proj_scenario = ['SNBC3_irun3171','SNBC3_irun3172','SNBC3_irun3173']
// test_fra_macro.Proj_scenario = ['SNBC3_irun31','SNBC3_irun32','SNBC3_irun33','SNBC3_irun34','SNBC3_irun35','SNBC3_irun36','SNBC3_irun37','SNBC3_irun38','SNBC3_irun39','SNBC3_irun310','SNBC3_irun311','SNBC3_irun312','SNBC3_irun313','SNBC3_irun314','SNBC3_irun315','SNBC3_irun316','SNBC3_irun317','SNBC3_irun318','SNBC3_irun319','SNBC3_irun320','SNBC3_irun321','SNBC3_irun322','SNBC3_irun323'];
// test_fra_macro.Proj_scenario = ['SNBC3_run3total_ic1', ..
// 'SNBC3_run3total_ic2', ..
// 'SNBC3_run3total_ic3', ..
// 'SNBC3_run3total_ic4', ..
// 'SNBC3_run3total_ic5', ..
// 'SNBC3_run3total_ic6', ..	
// 'SNBC3_run3total_ic7', ..
// 'SNBC3_run3total_ic8', ..
// 'SNBC3_run3total_ic9', ..
// 'SNBC3_run3total_ic10', ..
// 'SNBC3_run3total_ic11', ..
// 'SNBC3_run3total_ic12', ..
// 'SNBC3_run3total_ic13', ..
// 'SNBC3_run3total_ic14', ..
// 'SNBC3_run3total_ic15', ..
// 'SNBC3_run3total_ic16', ..
// 'SNBC3_run3total_ic17', ..
// 'SNBC3_run3total_ic18', ..
// 'SNBC3_run3total_ic19', ..
// 'SNBC3_run3total_ic20', ..
// 'SNBC3_run3total_ic21', ..
// 'SNBC3_run3total_ic22', ..
// 'SNBC3_run3total_ic23']
// test_fra_macro.Proj_scenario = ['SNBC3_run3c1','SNBC3_run3c2','SNBC3_run3c3','SNBC3_run3c4','SNBC3_run3c5','SNBC3_run3c6']
// test_fra_macro.const_c = ['1','2','3','4','5','6','7','8','9']
// test_fra_macro.Proj_scenario = ['SNBC3_run323c1','SNBC3_run323c2','SNBC3_run323c3','SNBC3_run323c4','SNBC3_run323c5']
// test_fra_macro.Proj_scenario = ['SNBC3_run31','SNBC3_run32','SNBC3_run33','SNBC3_run34','SNBC3_run35','SNBC3_run36','SNBC3_run37','SNBC3_run38','SNBC3_run39','SNBC3_run310','SNBC3_run311','SNBC3_run312','SNBC3_run313','SNBC3_run314','SNBC3_run315','SNBC3_run316','SNBC3_run317','SNBC3_run318','SNBC3_run319','SNBC3_run320','SNBC3_run321','SNBC3_run322','SNBC3_run323'];
// test_fra_macro.Proj_scenario = ['SNBC3_run322','SNBC3_run323'];
// test_fra_macro.Proj_scenario = ['SNBC3_run36','SNBC3_run37','SNBC3_run38','SNBC3_run39','SNBC3_run310','SNBC3_run311','SNBC3_run312','SNBC3_run313','SNBC3_run314','SNBC3_run315','SNBC3_run316','SNBC3_run317','SNBC3_run318','SNBC3_run319','SNBC3_run320','SNBC3_run321','SNBC3_run322','SNBC3_run323'];
//test_fra_macro.VAR_sigma_CES = ['0.8','0.85','0.9'];
// test_fra_macro.VAR_ConstrainedShare_Capital = ['0.9'];
//test_fra_macro.VAR_sigma_KE = ['-0.3','-0.15'];
test_fra_macro.skip_calibration = ['True'];
test_fra_macro.VAR_saving = ['99'];

france_macro = new_country(name_fra, iso_fra, test_fra_macro);



// ------------------------- *
// List of countries to test *
// ------------------------- * 

countries = list(france_macro); 
