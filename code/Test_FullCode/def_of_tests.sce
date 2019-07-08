// ***************************** *
// Define the data for the tests *
// ***************************** *

// * ------------------------------------------------------------- *
// * Argentina *
// * --------- *

name = 'Argentina';
iso = 'ARG';

test.System_Resol = ['Systeme_Static'];//, 'Systeme_ProjHomothetic', ..
//'Systeme_Stat_RoW'];
//test.study = ['Static_RunChoices', 'Projection_evolution', 'Recursive_RunChoices'];
//test.Resol_Mode = ['Static_comparative', 'Dynamic_projection'];
//test.Macro_nb = ['', 'Current', 'StrucChgt'];
//test.Demographic_shift = ['True', 'False'];
//test.Labour_product = ['True', 'False'];
//test.World_prices = ['True', 'False'];
//test.X_nonEnerg = ['True', 'False'];
//test.CO2_footprint = ['True', 'False'];
//test.Invest_matrix = ['%T', '%F'];
test.Scenario = ['', 'NDC', 'CCS'];
test.AGG_type = ['AGG_EnComp', ''];

argentina = new_country(name, iso, test);


// * ------------------------------------------------------------- *
// * Brasil *
// * ------ *

name = 'Brasil';
iso = 'BRA';

test = struct();

brasil = new_country(name, iso, test);


// * ------------------------------------------------------------- *
// * France *
// * ------ *

name = 'France';
iso = 'FRA';

test = struct();

france = new_country(name, iso, test);

// * ------------------------------------------------------------- *


// ************************* *
// List of countries to test *
// ************************* * 

countries = list(argentina, brasil, france);
