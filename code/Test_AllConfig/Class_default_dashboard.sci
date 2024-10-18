// ----------------------- *
// Structure for dashboard *
// ----------------------- *

// /!\ Make sure this default dashboard is consistent with the last
//      version of the program.

function default_dashboard = new_default_dashboard()
    // default_dashboard : structure with dashboard's inputs and 
    //                      values by default
    
    default_dashboard = struct( ..
    'Carbone_ETS' , 'False', ..
    'Carbon_BTA' , '%F', ..
    'CarbonTaxDiff' , '%F', ..
    'Recycling_Option' , '', ..
    'ClosCarbRev' , 'CstNetLend', ..
    'ClosPubBudget' , '', ..
    'System_Resol' , 'Systeme_ProjHomothetic', ..
    'Optimization_Resol' , '%T', ..
    'Capital_Dynamics' , '%F', ..
    'H_DISAGG' , 'HH1', ..
    'Resol_Mode' , 'Dynamic_projection', ..
    'Demographic_shift' , 'True', ..
    'Labour_product' , 'True', ..
    'World_prices' , 'True', ..
    'X_nonEnerg' , 'True', ..
    'Invest_matrix' , '%F', ..
    'CO2_footprint' , 'False', ..
    'Output_files' , '%T', ..
    'Output_prints' , '%F', ..
    'Scenario_ETS' , '', ..
    'MaPrimRenov' , 'False', ..
    'stranded_assets' , 'False', ..
    'pY_gas_reduced_v1' , 'False', ..
    'eq_G_ConsumpBudget' , '', ..
	'skip_calibration','True',..
    'Macro_nb', 'SNBC3_run2', ..
    'Proj_scenario', 'SNBC3test_run2', ..
    'Nb_Iter', '3', ..
    'emissions_bioenergy', 'True', ..
    'pY_gas_reduced_v2', 'True', ..
    'SystemOpt_Resol', 'SystemOpt_Static_neokeynesien', ..
    'Time_step_non_etudie','999',..
    'study', 'SNBC3_RunChoices', ..
    'AGG_type', 'AGG_23TME', ..
    'Invest_matrix', '%T', ..
	'proj_alpha','false',..
    'proj_imports','false',..
    'proj_exports','false',..
    'proj_c','false',..
    'proj_kappa','false',..
    'proj_invest','false',..
    'proj_pY', 'true' ,..
    'proj_spemarg_rates_IC','false',..
    'reindustrialisation_imports_bool','False',..
    'reindustrialisation_exports_bool','False', ..
	'Coef_real_wage_dashboard','1', ..
	'sigma_omegaU_dashboard','-0.1', ..
	'Bonus_vehicule_dashboard','False', ..
	'VAR_sigma_CES','', ..
	'VAR_ConstrainedShare_Capital','', ..
	'VAR_sigma_KE','', ..
	'Scenario','')
 
endfunction
