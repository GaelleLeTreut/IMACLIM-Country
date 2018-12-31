//////  Copyright or © or Copr. Ecole des Ponts ParisTech / CNRS 2018
//////  Main Contributor (2017) : Gaëlle Le Treut / letreut[at]centre-cired.fr
//////  Contributors : Emmanuel Combet, Ruben Bibas, Julien Lefèvre
//////  
//////  
//////  This software is a computer program whose purpose is to centralise all  
//////  the IMACLIM national versions, a general equilibrium model for energy transition analysis
//////
//////  This software is governed by the CeCILL license under French law and
//////  abiding by the rules of distribution of free software.  You can  use,
//////  modify and/ or redistribute the software under the terms of the CeCILL
//////  license as circulated by CEA, CNRS and INRIA at the following URL
//////  "http://www.cecill.info".
//////  
//////  As a counterpart to the access to the source code and  rights to copy,
//////  modify and redistribute granted by the license, users are provided only
//////  with a limited warranty  and the software's author,  the holder of the
//////  economic rights,  and the successive licensors  have only  limited
//////  liability.
//////  
//////  In this respect, the user's attention is drawn to the risks associated
//////  with loading,  using,  modifying and/or developing or reproducing the
//////  software by the user in light of its specific status of free software,
//////  that may mean  that it is complicated to manipulate,  and  that  also
//////  therefore means  that it is reserved for developers  and  experienced
//////  professionals having in-depth computer knowledge. Users are therefore
//////  encouraged to load and test the software's suitability as regards their
//////  requirements in conditions enabling the security of their systems and/or 
//////  data to be ensured and,  more generally, to use and operate it in the
//////  same conditions as regards security.
//////  
//////  The fact that you are presently reading this means that you have had
//////  knowledge of the CeCILL license and that you accept its terms.
//////////////////////////////////////////////////////////////////////////////////


/////////////////////////////////////////////////////////////////////////////////////////////
// STEP 5: DERIVATION RESOLUTION
/////////////////////////////////////////////////////////////////////////////////////////////

/////////////////////////////////////////////////////////////////////////////////////////
// defined in "loading data" : Index_Imaclim_VarResol
/////////////////////////////////////////////////////////////////////////////////////////

//////////////// Defining matrix with dimension of each variable for Resolution file
VarDimMat_resol = eval(Index_Imaclim_VarResol(2:$,2:3));


/////////////////////////////////////////////////////////////////////////
// LOADING STUDY CHANGES
/////////////////////////////////////////////////////////////////////////
// exec(STUDY+study+".sce");
//  Introduire le changement des valeurs par défaut des parametres selon les différentes simulation
[Table_parameters] = struct2Variables(parameters,"parameters");
execstr(Table_parameters);

// Les changements de variables exogènes sont stockées dans la structure dans le fichier study: Deriv_Exogenous 
// Attribuer les changements exogenes aux variables
if exists('Deriv_Exogenous')==1
[Table_Deriv_Exogenous] = struct2Variables(Deriv_Exogenous,"Deriv_Exogenous");
execstr(Table_Deriv_Exogenous);
end

Indice_Immo = find(Index_Sectors == "Property_business") ;


//////////////////////////////////////////////////////////////////////////
// Endogenous variable (set of variables for the system below - fsolve)
/////////////////////////////////////////////////////////////////////////
// list
[listDeriv_Var] = varTyp2list (Index_Imaclim_VarResol, "Var");
// Initial values for variables
Deriv_variables = Variables2struct(listDeriv_Var);
Deriv_variablesStart = Deriv_variables;
// Create X vector column for solver from all variables which are endogenously calculated in derivation
X_Deriv_Var_init = variables2X (Index_Imaclim_VarResol, listDeriv_Var, Deriv_variables);
bounds = createBounds( Index_Imaclim_VarResol , listDeriv_Var );
// [(1:162)' X_Deriv_Var_init >=bounds.inf  bounds.inf X_Deriv_Var_init bounds.sup X_Deriv_Var_init<= bounds.sup]

// list // SOLVE Endogenous variable (set of variables for independant fsolve)
listDeriv_Var_interm = varTyp2list (Index_Imaclim_VarResol, "Var_interm");
Deriv_Var_interm     = Variables2struct(listDeriv_Var_interm);
[Table_Deriv_Var_interm] = struct2Variables(Deriv_Var_interm,"Deriv_Var_interm");
execstr(Table_Deriv_Var_interm);

/////////////////////////////////////////////////////////////////////////
///// Extra calculation
/////////////////////////////////////////////////////////////////////////
warning("ruben: created sigmaM here, instead of Technical_Coef_Const_1, maybe change?");
sigmaM = sigma(1);
if ~or(sigma==sigmaM)
    error("problem with sigma");
end

// BudgetShare for non final energy product
// Dimension (nb_NonFinalEnergy , nb_HH)
NonFinEn_BudgShare_ref = (ini.pC(Indice_NonEnerSect, :) .* ini.C(Indice_NonEnerSect, :))./( (ini.Consumption_budget - sum( ini.pC(Indice_EnerSect,:) .* ini.C(Indice_EnerSect,:),"r" ) ).*.ones(nb_NonEnerSect,1) ) ;

function [M,p,X,pIC,pC,pG,pI,pM,CPI,alpha, lambda, kappa,GrossOpSurplus,Other_Direct_Tax]= f_resol_interm(Deriv_variables)
	// Ajout d'une variable pour forçage
	pM = pM_price_Const_2();
    M = Imports_Const_2 (pM, pY, Y, sigma_M, delta_M_parameter)
	p = Mean_price_Const_1(pY, pM, Y, M );
    X = Exports_Const_2( pM, pX, sigma_X, delta_X_parameter);
	pIC = pIC_price_Const_2( Transp_margins_rates, Trade_margins_rates, SpeMarg_rates_IC, Energy_Tax_rate_IC, OtherIndirTax_rate, Carbon_Tax_rate_IC, Emission_Coef_IC, p);
	pC = pC_price_Const_2( Transp_margins_rates, Trade_margins_rates, SpeMarg_rates_C, Energy_Tax_rate_FC, OtherIndirTax_rate, Carbon_Tax_rate_C, Emission_Coef_C, p, VA_Tax_rate) ;
	pG = pG_price_Const_2( Transp_margins_rates, Trade_margins_rates, Energy_Tax_rate_FC, OtherIndirTax_rate, p, VA_Tax_rate) ;
	pI = pI_price_Const_2( Transp_margins_rates, Trade_margins_rates,SpeMarg_rates_I,OtherIndirTax_rate, Energy_Tax_rate_FC, p, VA_Tax_rate) ;
	CPI = CPI_Const_2( pC, C);
	// 	Specific to any projection in relation to BY
//	[alpha, lambda, kappa] =Technical_Coef_Const_7(Theta, Phi, aIC, sigma, pIC, aL, pL, aK, pK, phi_IC, phi_K, phi_L, ConstrainedShare_IC, ConstrainedShare_Labour, ConstrainedShare_Capital);

	[alpha, lambda, kappa] = Technical_Coef_Const_8(Theta, Phi, aIC, sigma, pIC, aL, pL, aK, pK, phi_IC, phi_K, phi_L, ConstrainedShare_IC, ConstrainedShare_Labour, ConstrainedShare_Capital, Y);

	GrossOpSurplus =  GrossOpSurplus_Const_2( Capital_income, Profit_margin, Trade_margins, Transp_margins,  SpeMarg_rates_IC, SpeMarg_rates_C, SpeMarg_rates_X, SpeMarg_rates_I, p, alpha, Y, C, X); 
	Other_Direct_Tax = Other_Direct_Tax_Const_2( CPI, Other_Direct_Tax_param);
endfunction

	// execstr(fieldnames(Deriv_Var_temp)+"= Deriv_Var_temp." + fieldnames(Deriv_Var_temp));


function [Constraints_Deriv] = f_resolution ( X_Deriv_Var_init, VarDimMat, RowNumCsVDerivVarList, structNumDerivVar , Deriv_variablesStart , listDeriv_Var)

    // Création des variables à partir de x et de info_structure_x
    [Deriv_variables] = X2variablesRuben (RowNumCsVDerivVarList, structNumDerivVar , Deriv_variablesStart , VarDimMat, listDeriv_Var, X_Deriv_Var_init)

    // Affectation des valeurs aux noms de variables,  pour les variables du solveur, les valeurs calibrées, et les parametres
    execstr(fieldnames(Deriv_variables)+"= Deriv_variables." + fieldnames(Deriv_variables));
	
    // Calcul des variables qui ne sont pas des variables d'états
	/// Trois fois plus long avec appel de la fonction 
	[M,p,X,pIC,pC,pG,pI,pM,CPI,alpha, lambda, kappa,GrossOpSurplus, Other_Direct_Tax]= f_resol_interm(Deriv_variables)
	 
    // Création du vecteur colonne Constraints
    [Constraints_Deriv] = [
    // Consump_Units_const_1(Consumption_Units, Consumption_Units_ref)
    // Retired_Const_1(Retired, Retired_ref)
    // Demo_ratio_Const_1(Retired, Retired_ref, Labour_force, Labour_force_ref, Demo_ratio_change)
    H_Income_Const_1(H_disposable_income, NetCompWages_byAgent, GOS_byAgent, Pensions, Unemployment_transfers, Other_social_transfers, Other_Transfers, ClimPolicyCompens, Property_income, Income_Tax, Other_Direct_Tax)
    Pensions_Const_1(Pensions, Pension_Benefits, Retired)
    Unemploy_Transf_Const_1(Unemployment_transfers, UnemployBenefits, Unemployed)
    OtherSoc_Transf_Const_1(Other_social_transfers, Other_SocioBenef, Population)
    H_PropTranf_Const_1(Property_income, interest_rate, NetFinancialDebt)
    Corp_PropTranf_Const_1(Property_income, interest_rate, NetFinancialDebt)
    G_PropTranf_Const_1(Property_income, interest_rate, NetFinancialDebt)
    RoW_PropTranf_Const_2(Property_income) 
    H_Savings_Const_1(Household_savings, H_disposable_income, Household_saving_rate)
    Corp_savings_Const_1(Corporations_savings, Corp_disposable_income)
    G_savings_Const_1(Government_savings, G_disposable_income, G_Consumption_budget)

// Traitement différent de savings, une variable par type d'agent
//    H_Investment_Const_1(GFCF_byAgent, H_disposable_income, H_Invest_propensity)

H_Investment_Const_2(GFCF_byAgent,pC,C)

    Corp_investment_Const_1(GFCF_byAgent, Corp_disposable_income, Corp_invest_propensity)
	//G_investment_Const_1 : indexation de la FBCF des gouv sur les revenus /// G_investment_Const_2 : indexation de la FBCF des gouv sur le pib
    G_investment_Const_2(GFCF_byAgent, G_disposable_income, G_invest_propensity, GDP) 
    // RoW_investment_Const_1(GFCF_byAgent) // Equation supprimee, pas d'investissement direct etranger
    H_NetLending_Const_1(NetLending, GFCF_byAgent, Household_savings)
    Corp_NetLending_Const_1(NetLending, GFCF_byAgent, Corporations_savings)
    G_NetLending_Const_1(NetLending, GFCF_byAgent, Government_savings)
    RoW_NetLending_Const_1(NetLending, pM, M, pX, X, Property_income, Other_Transfers)


    H_NetDebt_Const_1(NetFinancialDebt, time_since_ini, NetLending)
    Corp_NetDebt_Const_1(NetFinancialDebt, time_since_ini, NetLending)
    G_NetDebt_Const_1(NetFinancialDebt, time_since_ini, NetLending)
    RoW_NetDebt_Const_1(NetFinancialDebt, time_since_ini, NetLending)
    ConsumBudget_Const_1(Consumption_budget, H_disposable_income, Household_saving_rate)
    H_demand_Const_2(Consumption_budget, C, ConstrainedShare_C, pC, CPI, sigma_pC, sigma_ConsoBudget)
    Corp_income_Const_1(Corp_disposable_income, GOS_byAgent, Other_Transfers, Property_income , Corporate_Tax) 
    G_income_Const_1(G_disposable_income, Income_Tax, Other_Direct_Tax, Corporate_Tax, Production_Tax, Labour_Tax, Energy_Tax_IC, Energy_Tax_FC, OtherIndirTax, VA_Tax, Carbon_Tax_IC, Carbon_Tax_C, GOS_byAgent, Pensions, Unemployment_transfers, Other_social_transfers, Other_Transfers, Property_income , ClimPolicyCompens, ClimPolCompensbySect)
    Income_Tax_Const_1(Income_Tax, Income_Tax_rate, H_disposable_income, Other_Direct_Tax)
    Corporate_Tax_Const_1(Corporate_Tax, Corporate_Tax_rate, GOS_byAgent)
    Production_Tax_Const_1(Production_Tax, Production_Tax_rate, pY, Y)
    Labour_Tax_Const_1(Labour_Tax, Labour_Tax_rate, w, lambda, Y)
    Energy_Tax_IC_Const_1(Energy_Tax_IC, Energy_Tax_rate_IC, alpha, Y)
    Energy_Tax_FC_Const_1(Energy_Tax_FC, Energy_Tax_rate_FC, C)
    OtherIndirTax_Const_1(OtherIndirTax, OtherIndirTax_rate, alpha, Y, C, G, I)
    VA_Tax_Const_1(VA_Tax, VA_Tax_rate, pC, C, pG, G, pI, I)
    Carbon_Tax_IC_Const_1(Carbon_Tax_IC, Carbon_Tax_rate_IC, alpha, Y, Emission_Coef_IC)
    Carbon_Tax_C_Const_1(Carbon_Tax_C, Carbon_Tax_rate_C, C, Emission_Coef_C) 
   // Retraite indexé sur les salaires Pension_Benefits_Const_1 // Retraite indexé sur le PIB Pension_Benefits_Const_2
    Pension_Benefits_Const_2(Pension_Benefits, NetWage_variation, Pension_Benefits_param, GDP)
    UnemployBenefits_Const_1(UnemployBenefits, NetWage_variation, UnemployBenefits_param)
	//Other_SocioBenef indexé sur les salaires Other_SocioBenef_Const_1 //  Other_SocioBenef indexé sur le PIB
    Other_SocioBenef_Const_2(Other_SocioBenef, NetWage_variation, Other_SocioBenef_param, GDP, Population )
	CTax_rate_IC_Const_1(Carbon_Tax_rate_IC, Carbon_Tax_rate, CarbonTax_Diff_IC) 
    CTax_rate_C_Const_1(Carbon_Tax_rate_C, Carbon_Tax_rate, CarbonTax_Diff_C)
	//LUMP SUM
	// ClimCompensat_Const_1(ClimPolicyCompens) // to HH : Const_1 for NO Transfert Const_2 for Transfert
    S_ClimCompensat_Const_1(ClimPolCompensbySect) //to Sect : Const_1 for NO Transfert Const_2 for Transfert
	// Recycling options // RevenueRecycling_Const_1 for no labour tax cut // RevenueRecycling_Const_2 for all carb tax into labour tax cut RevenueRecycling_Const_3 for labour tax reduction while maintaining netlending constant (with gdp variation)
	RevenueRecycling_Const_3(Labour_Tax, Labour_Tax_rate, Labour_Tax_Cut, w, lambda, Y, Carbon_Tax_IC, Carbon_Tax_C, ClimPolCompensbySect, ClimPolicyCompens, NetLending, GFCF_byAgent, Government_savings, GDP) 
    Labour_Taxe_rate_Const_1(LabTaxRate_BeforeCut, Labour_Tax_rate, Labour_Tax_Cut)
	//  G_ConsumpBudget_Const_1 :Use of consumption budget - Consumption expenditures //// G_ConsumpBudget_Const_2 : Public consumption budget - Proportion of GDP
    G_ConsumpBudget_Const_2(G_Consumption_budget, G, pG, GDP)
    G_demand_Const_2(G, pG, G_Consumption_budget, BudgetShare_GConsump)
	// Trade_Balance_Const_1( pM, pX, X, M, GDP)
    // Public_finance_Const_1(Government_closure) 
    // G_closure_Const_1(Income_Tax_rate, Other_Direct_Tax_param, Pension_Benefits_param, UnemployBenefits_param, Other_SocioBenef_param, Corporate_Tax_rate, Production_Tax_rate, LabTaxRate_BeforeCut, BudgetShare_GConsump, Energy_Tax_rate_IC, Energy_Tax_rate_FC, Carbon_Tax_rate, G_Consumption_budget, G_invest_propensity)
    TechnicProgress_Const_1(Phi, Capital_consumption, sigma_Phi)
    DecreasingReturn_Const_1(Theta, Y, sigma_Theta)
	// Comment Antoine : les fonctions de Theta et Phi les imposent à 1. Créer une fonction généraliser qui permette d'activer le changement technique endogène en prenant un sigma_Theta et un sigma_Phi != 0. Ici en cas désactiver, on ne peut pas faire car la fonction prendre faire une division par sigma_Theta et sigma_Phi
 
    Production_price_Const_1(pY, alpha, pIC, pL, lambda, pK, kappa, markup_rate, Production_Tax_rate)
    // Markup_Const_1(markup_rate)
    Transp_MargRates_Const_2(Transp_margins_rates, Transp_margins, delta_TranspMargins_rate)
    Transp_margins_Const_1(Transp_margins, Transp_margins_rates, p, alpha, Y, C, G, I, X) 
    Trade_MargRates_Const_2(Trade_margins, Trade_margins_rates, delta_TradeMargins_rate)
    Trade_margins_Const_1(Trade_margins, Trade_margins_rates, p, alpha, Y, C, G, I, X)
    // SpeMarg_rates_Const_1(SpeMarg_rates_IC, SpeMarg_rates_C, SpeMarg_rates_X, SpeMarg_rates_I)
    // //	SpeMarg_rates_Const_1 nécessaire ?
    SpeMarg_Const_1(SpeMarg_IC, SpeMarg_rates_IC, SpeMarg_C, SpeMarg_rates_C, SpeMarg_X, SpeMarg_rates_X,SpeMarg_I, SpeMarg_rates_I, p, alpha, Y, C, X)
    Invest_demand_Const_1(Betta, I, kappa, Y) 
    Capital_Cost_Const_1(pK, pI, I)
    MarketBalance_Const_1(Y, IC, C, G, I, X, M)
    IC_Const_1(IC, Y, alpha)
    // //	Voir si nécessaire de garder IC dans les équations
    // Imports_Const_1(M, pM, pY, Y, sigma_M, delta_M_parameter)

    // Antoine : J'ai retiré la marketclosure sinon je ne peux pas forcer le commerce    
    // MarketClosure_Const_1(Y, delta_M_parameter, delta_X_parameter)

    Capital_Consump_Const_1(Capital_consumption, Y, kappa)
    // //	Voir si nécessaire de garder Capital_consumption dans les équations
    // Import_price_Const_1(pM, delta_pM, pM_ref)
    pX_price_Const_1(pX, Transp_margins_rates, Trade_margins_rates, SpeMarg_rates_X, p)
    Employment_Const_1(Labour, lambda, Y)
    LabourByWorker_Const_1(LabourByWorker_coef, u_tot, Labour_force, lambda, Y)

	// Mean_wage_Const_1 for wage curve on nominal wage //  Mean_wage_Const_2 for wage curve on real wage //  Wage_Const_1 for wage curve nominal wages by sectors
    // Mean_wage_Const_2(u_tot, w, lambda, Y, sigma_omegaU)
	// Wage_Const_1(u_tot, w, lambda, Y, sigma_omegaU_sect,Coef_real_wage )
	// Antoine : wage curve en dynamique sans les références (5)
//	Wage_Const_5(u_tot, w, lambda, Y, sigma_omegaU,Coef_real_wage)

   // Antoine : J'ai défini le NetWage_variation par rapport à BY comme le CPI à cause de Pension_Benefits_param / UnemployBenefits_param / Other_SocioBenef_param
    // Wage_Variation_Const_1 // for a mean wage curve // MeanWageVar_Const_1 : for a sectoral wage curve
//	MeanWageVar_Const_1( w, lambda, Y, NetWage_variation)


	
	Mean_wage_Const_5(u_tot, w, lambda, Y, sigma_omegaU, CPI, Coef_real_wage)
	Wage_Variation_Const_1(w, NetWage_variation)



    HH_Unemployment_Const_1(u, u_tot)
    HH_Employment_Const_1(Unemployed, u, Labour_force)
    Labour_Cost_Const_1(pL, w, Labour_Tax_rate)
    MacroClosure_Const_1(GFCF_byAgent, pI, I)

// Antoine : delta_interest_rate défini par rapport à BY pour des questions d'harmonisation avec CPI et NetWage_variation
    Interest_rate_Const_1(interest_rate, delta_interest_rate)

    GDP_Const_1(GDP, Labour_income, GrossOpSurplus, Production_Tax, Labour_Tax, OtherIndirTax, VA_Tax, Energy_Tax_IC, Energy_Tax_FC, Carbon_Tax_IC, Carbon_Tax_C)
    Labour_income_Const_1(Labour_income, Labour, w) 
    Profit_income_Const_1(Profit_margin, markup_rate, pY, Y)
    Capital_income_Const_1(Capital_income, pK, kappa, Y)
    DistributShares_Const_1(Distribution_Shares, Labour_force, Unemployed)
    IncomeDistrib_Const_1bis(NetCompWages_byAgent, GOS_byAgent, Other_Transfers, GDP, Distribution_Shares, Labour_income, GrossOpSurplus)
    ];
    //7076:7087
    if ~isreal(Constraints_Deriv)
        warning("~isreal(Constraints_Deriv)");
        if or(imag(Constraints_Deriv)<>0)
            warning("nb imaginaires")
            // Constraints_Deriv = abs(Constraints_Deriv) * 1e5;
            disp(find(imag(Constraints_Deriv)~=0))
            disp(bounds.name(find(imag(Constraints_Deriv)~=0))')
            pause
        else
            Constraints_Deriv = real(Constraints_Deriv);
        end
    end
	
	// if max(abs(Constraints_Deriv))<10^-5
	// pause
	// end
	

endfunction

//////////////////////////////////////////////////////////////////////////
//	Number of Index and Indice from Index_Imaclim_VarResol used by f_resolution
/////////////////////////////////////////////////////////////////////////

nVarDeriv = size(listDeriv_Var);
RowNumCsVDerivVarList = list();
structNumDerivVar = zeros(nVarDeriv,1);
EltStructDerivVar = getfield(1 , Deriv_variablesStart);
for ind = 1:nVarDeriv
    RowNumCsVDerivVarList($+1) = find(Index_Imaclim_VarResol==listDeriv_Var(ind)) ;
    structNumDerivVar(ind) = find(EltStructDerivVar == listDeriv_Var(ind));
end

///////////////////////////////////////////
// Test function f_resolution and consistency between size of constraint and X vector of variable for fsolve
Constraints_Init =  f_resolution (X_Deriv_Var_init, VarDimMat_resol, RowNumCsVDerivVarList, structNumDerivVar , Deriv_variablesStart , listDeriv_Var);
[maxos,lieu]=max(abs(Constraints_Init));
SizeCst = size(Constraints_Init);
[contrainte_tri , coord] =gsort(Constraints_Init);

if %f
    exec(CODE+"testingSystem.sce");
    return
end

if length(X_Deriv_Var_init) ~= length(Constraints_Init)
    disp("X_Deriv_Var_init is "+length(X_Deriv_Var_init)+" long when Constraints_Init is "+length(Constraints_Init)+" long");
    error("The constraint and solution vectors do not have the same size, check data/Index_Imaclim_VarResol.csv")
end

/////////////////////////////////////////////////
//////SOLVEUR
/////////////////////////////////////////////////
count        = 0;
countMax     = 30;
vMax         = 10000000;
vBest        = 10000000;
sensib       = 1e-5;
sensibFsolve = 1e-15;
Xbest        = X_Deriv_Var_init;
a            = 0.1;

tic();

if %f
    Xinf = ones(Xbest) * -%inf;
    Xsup = -Xinf;
    Xinf(py) = 0;
    [X_Deriv_Var, Constraints_Deriv, info] = leastsq(..
    list(f_resolution, VarDimMat_resol, RowNumCsVDerivVarList, structNumDerivVar , Deriv_variablesStart , listDeriv_Var),..
    "b", Xinf , Xsup,..
    Xbest.*(1 + a*(rand(Xbest)-1/2))..
    );
end

printf("\n\n   count      vBest   info       toc\n");
while (count<countMax)&(vBest>sensib)
    count = count + 1;

    try
        [X_Deriv_Var, Constraints_Deriv, info] = fsolve(Xbest.*(1 + a*(rand(Xbest)-1/2)), list(f_resolution, VarDimMat_resol, RowNumCsVDerivVarList, structNumDerivVar , Deriv_variablesStart , listDeriv_Var),sensibFsolve);
        vMax = norm(Constraints_Deriv);

        if vMax<vBest
            vBest    = vMax;
            infoBest = info;
            Xbest    = X_Deriv_Var;
        end

    catch
        [str,n,line,func]=lasterror(%f);
        disp("Error "+n+" with fsolve: "+str);
        pause
    end

    result(count).xbest = Xbest;
    result(count).vmax  = vMax;
    result(count).vbest = vBest;
    result(count).count = count;
    result(count).info  = info;

    printf("     %3.0f   %3.2e      %1.0f   %3.1e\n",count,vBest,info,toc()/60);
end

exec(CODE+"terminateResolution.sce");


////////////////////////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////
// Reafectation des valeurs aux variables et à la structure après résolution
/////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////
Deriv_variables = X2variables (Index_Imaclim_VarResol, listDeriv_Var, Xbest);
execstr(fieldnames(Deriv_variables)+"= Deriv_variables." + fieldnames(Deriv_variables)+";");

if exists('Deriv_Exogenous')==1
Table_Deriv_Exogenous = struct2Variables(Deriv_Exogenous,"Deriv_Exogenous");
execstr(Table_Deriv_Exogenous)
end

/// Cacul des variables "temp" dans la fonction f_resolution
[M,p,X,pIC,pC,pG,pI,pM,CPI,alpha, lambda, kappa,GrossOpSurplus, Other_Direct_Tax ]= f_resol_interm(Deriv_variables);
execstr("Deriv_Var_interm."+fieldnames(Deriv_Var_interm)+"="+fieldnames(Deriv_Var_interm));

/////////////////////////////////////////////////////////////////
// test f_resolution à zéro ?? Mais pour quel jeu de valeur ?? LA CA FAIT PAS ZERO
Constraints_Deriv_test =  f_resolution (X_Deriv_Var, VarDimMat_resol, RowNumCsVDerivVarList, structNumDerivVar , Deriv_variables , listDeriv_Var);
[maxos,lieu]=max(abs(Constraints_Deriv_test));

//Struture d. created to reunite Deriv_variables and Deriv_Var_temp");
// All d. at initial value first
execstr("d."+fieldnames(calib)+"= calib."+fieldnames(calib)+";");
execstr("d."+fieldnames(initial_value)+"= initial_value."+fieldnames(initial_value)+";");
execstr("d."+fieldnames(parameters)+"= parameters."+fieldnames(parameters)+";");
// introducing changes in variable value
execstr("d."+fieldnames(Deriv_variables)+"= Deriv_variables."+fieldnames(Deriv_variables)+";");
execstr("d."+fieldnames(Deriv_Var_interm)+"= Deriv_Var_interm."+fieldnames(Deriv_Var_interm)+";");
if exists('Deriv_Exogenous')==1
execstr("d."+fieldnames(Deriv_Exogenous)+"= Deriv_Exogenous."+fieldnames(Deriv_Exogenous)+";");
end


