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
	'ClosPubBudget','',..
	'VAR_Mu','ref',..
	'VAR_sigma_MX','ref',..
	'VAR_saving','ref',..
    'VAR_sigma_omegaU','ref',..
    'VAR_coef_real_wage','ref',..
    'VAR_C_basic_need','ref',..
	'VAR_sigma_ConsoBudget','ref',..
	'VAR_sigma_pC','ref',..
	'VAR_sigma','ref',..
	'VAR_delta_pM','ref',..
	'trade_drive','ref',..
	'eq_G_ConsumpBudget','ref',..
	'VAR_import_enersect','ref',..
	'VAR_population','ref',..
	'VAR_emis','ref')
    
endfunction
