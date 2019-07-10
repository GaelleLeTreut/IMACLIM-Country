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

argentina = new_country(name_arg, iso_arg, test_arg);


// * ------------------------------------------------------------- *
// * Brasil *
// * ------ *

name_bra = 'Brasil';
iso_bra = 'BRA';

test_bra.System_Resol = ['Systeme_Static_BRA'];
test_bra.Scenario = ['PMR_Ref_Disag'];
test_bra.AGG_type = ['AGG_PMR19'];

brasil = new_country(name_bra, iso_bra, test_bra);


// * ------------------------------------------------------------- *
// * France *
// * ------ *

name_fra = 'France';
iso_fra = 'FRA';

test_fra.System_Resol = ['Systeme_Static_FRA'];
test_fra.Scenario = ['Recalib'];
test_fra.AGG_type = ['AGG_SNBC2'];

france = new_country(name_fra, iso_fra, test_fra);

// * ------------------------------------------------------------- *


// ------------------------- *
// List of countries to test *
// ------------------------- * 

countries = list(argentina, brasil, france);
