function default_dashboard = new_default_dashboard()
    default_dashboard = struct( ..
    'System_Resol', 'Systeme_Static', ..
    'study', 'Recursive_RunChoices', ..
    'AGG_type', '', ..
    'H_DISAGG', 'HH1', ..
    'Resol_Mode', 'Dynamic_Projection', ..
    'Nb_Iter', '1', ..
    'Macro_nb', '', ..
    'Demographic_shift', 'True', ..
    'Labour_product', 'True', ..
    'World_prices', 'False', ..
    'X_nonEnerg', 'False', ..
    'Invest_matrix', '%F', ..
    'Scenario', '', ..
    'CO2_footprint', 'False', ..
    'Output_files', 'False');
endfunction

function country = fill(data, test)

    country = data;
    country.test = test;

    country.dashboard_file = 'Dashboard_' + country.iso + '.csv';
    country.study_frames = 'study_frames_' + country.iso + filesep();

    country.dashboard = new_default_dashboard();

    tests_inputs = fieldnames(country.test);
    for name = tests_inputs'
        country.dashboard(name) = country.test(name);
    end

endfunction

// * ------------------------------------------------------------------------ *

country_selection = 'Country_Selection.csv';

// * ------------------------------------------------------------------------ *

argentina.name = 'Argentina';
argentina.iso = 'ARG';

test.Systeme_Resol = ['Systeme_Static', 'Systeme_ProjHomothetic', 'Systeme_Stat_RoW'];
//test.study = ['Static_RunChoices', 'Projection_evolution', 'Recursive_RunChoices'];
//test.Resol_Mode = ['Static_comparative', 'Dynamic_projection'];
//test.Macro_nb = ['', 'Current', 'StrucChgt'];
//test.Demographic_shift = ['True', 'False'];
//test.Labour_product = ['True', 'False'];
//test.World_prices = ['True', 'False'];
//test.X_nonEnerg = ['True', 'False'];
//test.CO2_footprint = ['True', 'False'];
test.Invest_matrix = ['%T', '%F'];
test.Scenario = ['', 'NDC', 'CCS'];
test.AGG_type = ['AGG_EnComp', ''];

argentina = fill(argentina, test);

// * ------------------------------------------------------------------------ *

brasil.name = 'Brasil';
brasil.iso = 'BRA';

test = struct();

brasil = fill(brasil, test);

// * ------------------------------------------------------------------------ *

france.name = 'France';
france.iso = 'FRA_update';

test = struct();

france = fill(france, test);

// * ------------------------------------------------------------------------ *

countries = [argentina, brasil, france];

// for i = 1:nb_countries 
// exec_test(countries(i))
//end

// -> CE FICHIER EST LE FICHIER DATA QUE L'UTILISATEUR DOIT VOIR EN PREMIER POUR MODIFIER

// QUAND ON CREE LES DASHBOARD APRES LE MELANGE, GARDER EN EN MEMOIRE LES VALEURS DES ELEMENTS DE 'TEST' POUR LES AFFICHER PENDANT LES EXECUTIONS

// TODO : tableau avec les pays, c'est lui qui est appelé, on écrit plus jamais le nom des pays dans le code
//Remplir ici les dashboards des pays
//Mettre la fonction dashboard par défaut ?
//Renommer le fichier -> params des tests !
//Dans les autres fichiers -> on connait pas le nombre de pays, on sait pas ce qu'ils sont etc on connait juste la structure générale
//-> classe pays ??
