// ----------------------------- *
// Define the data for the tests *
// ----------------------------- *

// * ------------------------------------------------------------- *
// * Argentina *
// * --------- *

name_arg = 'Argentina';
iso_arg = 'ARG';

test_arg.System_Resol = ['Systeme_Static'];
test_arg.Scenario = ['', 'NDC', 'CCS'];
test_arg.AGG_type = ['AGG_EnComp', ''];
//test_arg.Invest_matrix = ['%T', '%F'];

argentina = new_country(name_arg, iso_arg, test_arg);


// * ------------------------------------------------------------- *
// * Brasil *
// * ------ *

name_bra = 'Brasil';
iso_bra = 'BRA';

test_bra.System_Resol = ['Systeme_Static_BRA'];
//test_bra.AGG_type = ['', 'AGG_PMR19', 'AGG_EnComp'];
//test_bra.H_DISAGG = ['HH1', 'H3', 'H4'];

brasil = new_country(name_bra, iso_bra, test_bra);

test_bra_scen.System_Resol = ['Systeme_Static_BRA'];
test_bra_scen.Scenario = ['PMR_Ref_Disag'];

brasil_scenario = new_country(name_bra, iso_bra, test_bra_scen);

// * ------------------------------------------------------------- *
// * France *
// * ------ *

name_fra = 'France';
iso_fra = 'FRA';

test_fra.System_Resol = ['Systeme_Static_FRA', 'Systeme_ProjHomothetic_FRA'];
test_fra.AGG_type = ['', 'AGG_SNBC2', 'AGG_MetMin', 'AGG_IndEner', ..
'AGG_MetMinEn', 'AGG_Ener1', 'AGG_Ener2', 'AGG_4Sec', 'AGG_3Sec', 'AGG_EnComp'];
test_fra.H_DISAGG = ['HH1', 'H10'];

france = new_country(name_fra, iso_fra, test_fra);

test_fra_scen.System_Resol = ['Systeme_Static_FRA'];
test_fra_scen.Scenario = ['Recalib', 'AME', 'AMS'];
test_fra_scen.AGG_type = ['AGG_SNBC2'];

france_scenario = new_country(name_fra, iso_fra, test_fra_scen);

// * ------------------------------------------------------------- *


// ------------------------- *
// List of countries to test *
// ------------------------- * 

countries = list(argentina, brasil); //, brasil_scenario, france, france_scenario);
