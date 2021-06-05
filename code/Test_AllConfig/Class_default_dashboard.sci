// ----------------------- *
// Structure for dashboard *
// ----------------------- *

// /!\ Make sure this default dashboard is consistent with the last
//      version of the program.

function default_dashboard = new_default_dashboard()
    // default_dashboard : structure with dashboard's inputs and 
    //                      values by default
    
    default_dashboard = struct( ..
    'System_Resol', 'System_StatRed', ..
    'Optimization_Resol', '%T', ..
    'SystemOpt_Resol', 'SystemOpt_Static', ..
    'study', 'Recursive_RunChoices', ..
	'Capital_Dynamics','%F',..
    'AGG_type', '', ..
    'H_DISAGG', 'HH1', ..
    'Resol_Mode', 'Dynamic_projection', ..
    'Nb_Iter', '1', ..
    'Macro_nb', '', ..
    'Demographic_shift', 'True', ..
    'Labour_product', 'True', ..
    'World_prices', 'False', ..
    'X_nonEnerg', 'False', ..
    'Invest_matrix', '%F', ..
    'Scenario', '', ..
    'CO2_footprint', 'False', ..
    'Output_files', '%F', ..
	'Output_prints', '%F', ..
	'CarbonTaxDiff','%F',..
	'Carbon_BTA','%F',..
    'Recycling_Option', '',..
	'ClosCarbRev','CstNetLend',..
	'VAR_MU','',..
	'VAR_pM','',..
	'VAR_Growth','',..
	'VAR_Immo','')
    
endfunction
