////////////////////////////////////
// Specific to homothetic projection
////////////////////////////////////
if [System_Resol == "Systeme_ProjHomothetic"]
    parameters.sigma_pC = ones(parameters.sigma_pC);
    parameters.sigma_ConsoBudget = ones(parameters.sigma_ConsoBudget);
    parameters.ConstrainedShare_C = zeros(parameters.ConstrainedShare_C);
    parameters.sigma_M = ones(parameters.sigma_M);
    parameters.sigma_X = ones(parameters.sigma_X);
    parameters.CarbonTax_Diff_IC = ones(CarbonTax_Diff_IC);
    parameters.CarbonTax_Diff_IC = ones(CarbonTax_Diff_IC);
    parameters.Carbon_Tax_rate = 0.0;
    parameters.u_param = BY.u_tot;
end

// Load the projections for forcing

//exec('Import_Proj_Volume.sce');
exec(STUDY + "Import_Proj_Volume.sce");

exec('Load_Projections.sce');
