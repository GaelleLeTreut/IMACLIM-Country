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
// defined in "loading data" : Index_Imaclim_VarResolRed
/////////////////////////////////////////////////////////////////////////////////////////

//////////////// Defining matrix with dimension of each variable for Resolution file
VarDimMat_resol = eval(Index_Imaclim_VarResolRed(2:$,2:3));


/////////////////////////////////////////////////////////////////////////
// LOADING STUDY CHANGES
/////////////////////////////////////////////////////////////////////////
// exec(STUDY+study+".sce");
// Les changements de variables exogènes sont stockées dans la structure dans le fichier study: Deriv_Exogenous 
// Attribuer les changements exogenes aux variables
if exists('Deriv_Exogenous')==1
    [Table_Deriv_Exogenous] = struct2Variables(Deriv_Exogenous,"Deriv_Exogenous");
    execstr(Table_Deriv_Exogenous);
end

Indice_Immo = find(Index_Sectors == "Property_business") ;

//  Introduire le changement des valeurs par défaut des parametres selon les différentes simulation
[Table_parameters] = struct2Variables(parameters,"parameters");
execstr(Table_parameters);


//////////////////////////////////////////////////////////////////////////
// Endogenous variable (set of variables for the system below - fsolve)
/////////////////////////////////////////////////////////////////////////
// list
[listDeriv_Var] = varTyp2list (Index_Imaclim_VarResolRed, "Var");
// Initial values for variables
Deriv_variables = Variables2struct(listDeriv_Var);
Deriv_variablesStart = Deriv_variables;
// Create X vector column for solver from all variables which are endogenously calculated in derivation
X_Deriv_Var_init = variables2X (Index_Imaclim_VarResolRed, listDeriv_Var, Deriv_variables);
bounds = createBounds( Index_Imaclim_VarResolRed , listDeriv_Var );
// [(1:162)' X_Deriv_Var_init >=bounds.inf  bounds.inf X_Deriv_Var_init bounds.sup X_Deriv_Var_init<= bounds.sup]

// list // SOLVE Endogenous variable (set of variables for independant fsolve)
listDeriv_Var_interm = varTyp2list (Index_Imaclim_VarResolRed, "Var_interm");
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

/////////////////////////////////////////////////////////////////////////
///// FUNCTIONS
/////////////////////////////////////////////////////////////////////////

function [NetFinancialDebt,Labour_Tax_Cut,Phi,Theta,G_Consumption_budget,Labour_Tax_rate,Carbon_Tax_rate_IC,Carbon_Tax_rate_C,Transp_margins_rates,Trade_margins_rates,ClimPolicyCompens,ClimPolCompensbySect,M,p,pX,X,pIC,pC,pG,pI,pM,CPI, GDP_pFish, G_pFish, I_pFish, pL,alpha,lambda,kappa,I,pK,IC,Capital_consumption,Transp_margins,Trade_margins,Profit_margin,Capital_income,Labour_income,GrossOpSurplus,GDP,Other_Direct_Tax,Pension_Benefits,UnemployBenefits,Other_SocioBenef,Pensions,u,Unemployed,Unemployment_transfers,Other_social_transfers,Property_income,NetCompWages_byAgent,GOS_byAgent,Other_Transfers,H_disposable_income,Household_savings,Corporate_Tax,Production_Tax,w,Labour_Tax,Energy_Tax_IC,Energy_Tax_FC,OtherIndirTax,VA_Tax,Carbon_Tax_IC,Carbon_Tax_C,Corp_disposable_income,Corporations_savings,G_disposable_income,Government_savings,GFCF_byAgent,NetLending,Consumption_budget,Labour,SpeMarg_IC,SpeMarg_C,SpeMarg_G,SpeMarg_X,SpeMarg_I,Distribution_Shares, delta_LS_S, delta_LS_H, delta_LS_I, delta_LS_LT] = f_resol_interm()

    NetFinancialDebt = NetFinancialDebt_val();
    ClimPolicyCompens = ClimCompensat_1_val();
    ClimPolCompensbySect = S_ClimCompensat_1_val();
    Labour_Tax_Cut = RevenueRecycling_1_val();
    Phi =  TechnicProgress_1_val();
    Theta =  DecreasingReturn_1_val();
    Labour_Tax_rate = Labour_Taxe_rate_1_val(LabTaxRate_BeforeCut, Labour_Tax_Cut);
    Carbon_Tax_rate_IC = CTax_rate_IC_1_val(Carbon_Tax_rate, CarbonTax_Diff_IC);
    Carbon_Tax_rate_C = CTax_rate_C_1_val(Carbon_Tax_rate, CarbonTax_Diff_C);
    Transp_margins_rates =  Transp_MargRates_2_val(delta_TranspMargins_rate);
    Trade_margins_rates =  Trade_MargRates_2_val(delta_TradeMargins_rate);

    pM = pM_price_Const_2(); // check const_1
    M = Imports_Const_2(pM, pY, Y, sigma_M, delta_M_parameter) // check const_1, const_3 & const_4
    p = Mean_price_Const_1(pY, pM, Y, M );
    // const 3 : homothetic projection et const_2 static projection
    pX = pX_price_1_val(Transp_margins_rates, Trade_margins_rates, SpeMarg_rates_X, p);
    X = Exports_Const_2( pM, pX, sigma_X, delta_X_parameter);// check const_1 et const_4
    pIC = pIC_price_Const_2( Transp_margins_rates, Trade_margins_rates, SpeMarg_rates_IC, Energy_Tax_rate_IC, OtherIndirTax_rate, Carbon_Tax_rate_IC, Emission_Coef_IC, p);
    pC = pC_price_Const_2( Transp_margins_rates, Trade_margins_rates, SpeMarg_rates_C, Energy_Tax_rate_FC, OtherIndirTax_rate, Carbon_Tax_rate_C, Emission_Coef_C, p, VA_Tax_rate) ;
    pG =  pG_price_Const_2( Transp_margins_rates, Trade_margins_rates, SpeMarg_rates_G, Energy_Tax_rate_FC, OtherIndirTax_rate, p, VA_Tax_rate) ;
    pI = pI_price_Const_2( Transp_margins_rates, Trade_margins_rates,SpeMarg_rates_I,OtherIndirTax_rate, Energy_Tax_rate_FC, p, VA_Tax_rate) ;

    CPI = CPI_Const_2( pC, C); // defined in relation to BY
	GDP_pFish = GDP_pFish_Const_1(pC, C, pG, G, pI, I, pX, X, pM, M, GDP);
    G_pFish = G_pFish_Const_1(pG, G);
    I_pFish = I_pFish_Const_1(pI, I);

    w = Wage_Variation_1_val(NetWage_variation);
    pL = Labour_Cost_1_val(w, Labour_Tax_rate);

    [alpha, lambda, kappa] = Technical_Coef_Const_9(Theta, Phi, aIC, sigma, pIC, aL, pL, aK, pK, phi_IC, phi_K, phi_L, ConstrainedShare_IC, ConstrainedShare_Labour, ConstrainedShare_Capital, Y);

    I = Invest_demand_1_val(Betta, kappa, Y);
    pK = Capital_Cost_1_val(pI, I);
    IC = IC_1_val(Y, alpha);
    Capital_consumption = Capital_Consump_1_val(Y, kappa);
    Transp_margins =  Transp_margins_1_val(Transp_margins_rates, p, alpha, Y, C, G, I, X);
    Trade_margins =  Trade_margins_1_val(Trade_margins_rates, p, alpha, Y, C, G, I, X);
    Profit_margin = Profit_income_1_val(markup_rate, pY, Y);
    Capital_income = Capital_income_1_val(pK, kappa, Y);
    GrossOpSurplus =  GrossOpSurplus_Const_2( Capital_income, Profit_margin, Trade_margins, Transp_margins,  SpeMarg_rates_IC, SpeMarg_rates_C, SpeMarg_rates_X, SpeMarg_rates_I, SpeMarg_rates_G, p, alpha, Y, C, X); 
    Production_Tax = Production_Tax_1_val(Production_Tax_rate, pY, Y);
    Labour_Tax = Labour_Tax_1_val(Labour_Tax_rate, w, lambda, Y);
    OtherIndirTax = OtherIndirTax_1_val(OtherIndirTax_rate, alpha, Y, C, G, I);
    VA_Tax = VA_Tax_1_val(VA_Tax_rate, pC, C, pG, G, pI, I);
    Energy_Tax_IC = Energy_Tax_IC_1_val(Energy_Tax_rate_IC, alpha, Y);
    Energy_Tax_FC = Energy_Tax_FC_1_val(Energy_Tax_rate_FC, C);
    Carbon_Tax_IC = Carbon_Tax_IC_1_val(Carbon_Tax_rate_IC, alpha, Y, Emission_Coef_IC);
    Carbon_Tax_C = Carbon_Tax_C_1_val(Carbon_Tax_rate_C, C, Emission_Coef_C);
    Labour = Employment_1_val(lambda, Y);
    Labour_income = Labour_income_1_val(Labour, w);
    
    GDP = GDP_1_val(Labour_income, GrossOpSurplus, Production_Tax, Labour_Tax, OtherIndirTax, VA_Tax, Energy_Tax_IC, Energy_Tax_FC, Carbon_Tax_IC, Carbon_Tax_C, ClimPolCompensbySect);
    
    // const_1 : calib / const_2 : CPI / const_3 : GDP
    Other_Direct_Tax = Other_Direct_Tax_Const_2(CPI, Other_Direct_Tax_param);

    Pension_Benefits = Pension_Benefits_2_val(Pension_Benefits_param, GDP);
    UnemployBenefits = UnemployBenefits_1_val(NetWage_variation, UnemployBenefits_param);
    Other_SocioBenef = Other_SocioBenef_2_val(Other_SocioBenef_param, GDP, Population);
    Pensions = Pensions_1_val(Pension_Benefits, Retired);
    u = HH_Unemployment_1_val(u_tot);
    Unemployed = HH_Employment_1_val(u, Labour_force);
    Unemployment_transfers = Unemploy_Transf_1_val(UnemployBenefits, Unemployed);
    Other_social_transfers = OtherSoc_Transf_1_val(Other_SocioBenef, Population);
    Property_income = Property_income_val(interest_rate, NetFinancialDebt);
    Distribution_Shares = DistributShares_1_val(Labour_force, Unemployed);
    [NetCompWages_byAgent, GOS_byAgent, Other_Transfers] = IncomeDistrib_1_val(GDP, Distribution_Shares, Labour_income, GrossOpSurplus);
    H_disposable_income = H_Income_1_val(NetCompWages_byAgent, GOS_byAgent, Pensions, Unemployment_transfers, Other_social_transfers, Other_Transfers, ClimPolicyCompens, Property_income, Income_Tax, Other_Direct_Tax);
    Household_savings = H_Savings_1_val(H_disposable_income, Household_saving_rate);
    Corporate_Tax = Corporate_Tax_1_val(Corporate_Tax_rate, GOS_byAgent);
    Corp_disposable_income = Corp_income_1_val(GOS_byAgent, Other_Transfers, Property_income , Corporate_Tax);
    Corporations_savings = Corp_savings_1_val(Corp_disposable_income);
    G_disposable_income = G_income_1_val(Income_Tax, Other_Direct_Tax, Corporate_Tax, Production_Tax, Labour_Tax, Energy_Tax_IC, Energy_Tax_FC, OtherIndirTax, VA_Tax, Carbon_Tax_IC, Carbon_Tax_C, GOS_byAgent, Pensions, Unemployment_transfers, Other_social_transfers, Other_Transfers, Property_income , ClimPolicyCompens, ClimPolCompensbySect);
    G_Consumption_budget = G_ConsumpBudget_2_val(GDP);
    Government_savings = G_savings_1_val(G_disposable_income, G_Consumption_budget);
    GFCF_byAgent = GFCF_byAgent_val(H_disposable_income, H_Invest_propensity, G_disposable_income, G_invest_propensity, GDP, pI, I);
    NetLending = NetLending_val(GFCF_byAgent, Household_savings, Corporations_savings);
    Consumption_budget = ConsumBudget_1_val(H_disposable_income, Household_saving_rate);
   [SpeMarg_IC,SpeMarg_C,SpeMarg_G,SpeMarg_X,SpeMarg_I] =  SpeMarg_1_val(SpeMarg_rates_IC, SpeMarg_rates_C, SpeMarg_rates_G, SpeMarg_rates_X, SpeMarg_rates_I, p, alpha, Y, C, X);
	
	[delta_LS_S, delta_LS_H, delta_LS_I, delta_LS_LT] = Recycling_Option_Const_1(Carbon_Tax_IC, Carbon_Tax_C);
    
endfunction

// execstr(fieldnames(Deriv_Var_temp)+"= Deriv_Var_temp." + fieldnames(Deriv_Var_temp));

function [Constraints_Deriv] = f_resolution ( X_Deriv_Var_init, VarDimMat, RowNumCsVDerivVarList, structNumDerivVar , Deriv_variablesStart , listDeriv_Var)

    // Création des variables à partir de x et de info_structure_x
    [Deriv_variables] = X2variablesRuben (RowNumCsVDerivVarList, structNumDerivVar , Deriv_variablesStart , VarDimMat, listDeriv_Var, X_Deriv_Var_init);

    // Affectation des valeurs aux noms de variables,  pour les variables du solveur, les valeurs calibrées, et les parametres
    execstr(fieldnames(Deriv_variables)+"= Deriv_variables." + fieldnames(Deriv_variables));

    // Calcul des variables qui ne sont pas des variables d'états
    /// Trois fois plus long avec appel de la fonction 
    [NetFinancialDebt,Labour_Tax_Cut,Phi,Theta,G_Consumption_budget,Labour_Tax_rate,Carbon_Tax_rate_IC,Carbon_Tax_rate_C,Transp_margins_rates,Trade_margins_rates,ClimPolicyCompens,ClimPolCompensbySect,M,p,pX,X,pIC,pC,pG,pI,pM,CPI, GDP_pFish, G_pFish, I_pFish, pL,alpha,lambda,kappa,I,pK,IC,Capital_consumption,Transp_margins,Trade_margins,Profit_margin,Capital_income,Labour_income,GrossOpSurplus,GDP,Other_Direct_Tax,Pension_Benefits,UnemployBenefits,Other_SocioBenef,Pensions,u,Unemployed,Unemployment_transfers,Other_social_transfers,Property_income,NetCompWages_byAgent,GOS_byAgent,Other_Transfers,H_disposable_income,Household_savings,Corporate_Tax,Production_Tax,w,Labour_Tax,Energy_Tax_IC,Energy_Tax_FC,OtherIndirTax,VA_Tax,Carbon_Tax_IC,Carbon_Tax_C,Corp_disposable_income,Corporations_savings,G_disposable_income,Government_savings,GFCF_byAgent,NetLending,Consumption_budget,Labour,SpeMarg_IC,SpeMarg_C,SpeMarg_G,SpeMarg_X,SpeMarg_I,Distribution_Shares, delta_LS_S, delta_LS_H, delta_LS_I, delta_LS_LT] = f_resol_interm();

    // Création du vecteur colonne Constraints
    [Constraints_Deriv] = [

    // C
    // **** CPI -> C -> CPI ****
    H_demand_Const_1(Consumption_budget, C, ConstrainedShare_C, pC, CPI, sigma_pC, sigma_ConsoBudget)

    // Income_Tax
    // **** H_disposable_income -> Income_Tax -> H_disposable_income ****
    Income_Tax_Const_1(Income_Tax, Income_Tax_rate, H_disposable_income, Other_Direct_Tax)

    // G
    // **** G_Consumption_budget -> G -> VA_Tax -> GDP -> G_consumption_budget ****
    G_demand_Const_2(G, pG, G_Consumption_budget, BudgetShare_GConsump) // check const_1

    // pY, Y
    //  **** pIC -> pY -> M -> p -> pIC
    Production_price_Const_1(pY, alpha, pIC, pL, lambda, pK, kappa, markup_rate, Production_Tax_rate, ClimPolCompensbySect, Y)

    // delta_TranspMargins_rate
    // **** Equation to deduce delta_TranspMargins_rate ****
    delta_TranspMarg_rate_eq(Transp_margins)

    // delta_TradeMargins_rate
    // **** Equation to deduce delta_TradeMargins_rate ****
    delta_TradeMarg_rate_eq(Trade_margins)

    // Y, C, G
    // **** IC -> Y -> IC ****
    MarketBalance_Const_1(Y, IC, C, G, I, X, M)

    // u_tot, Y
    LabourByWorker_Const_1(LabourByWorker_coef, u_tot, Labour_force, lambda, Y)

    // u_tot, Y
    Mean_wage_Const_5(u_tot, w, lambda, Y, sigma_omegaU, CPI, Coef_real_wage)

    ];
    
    //7076:7087
    if ~isreal(Constraints_Deriv)
        warning("~isreal(Constraints_Deriv)");
        if or(imag(Constraints_Deriv)<>0)
            warning("nb imaginaires")
            // Constraints_Deriv = abs(Constraints_Deriv) * 1e5;
            print(out,find(imag(Constraints_Deriv)~=0))
            print(out,bounds.name(find(imag(Constraints_Deriv)~=0))')
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
//	Number of Index and Indice from Index_Imaclim_VarResolRed used by f_resolution
/////////////////////////////////////////////////////////////////////////

nVarDeriv = size(listDeriv_Var);
RowNumCsVDerivVarList = list();
structNumDerivVar = zeros(nVarDeriv,1);
EltStructDerivVar = getfield(1 , Deriv_variablesStart);
for ind = 1:nVarDeriv
    RowNumCsVDerivVarList($+1) = find(Index_Imaclim_VarResolRed==listDeriv_Var(ind)) ;
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
    print(out,"X_Deriv_Var_init is "+length(X_Deriv_Var_init)+" long when Constraints_Init is "+length(Constraints_Init)+" long");
    error("The constraint and solution vectors do not have the same size, check data/Index_Imaclim_VarResolRed.csv")
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

if Test_mode then
    countMax = testing.countMax;
end

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
while (count<countMax)& (vBest>sensib)
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
        print(out,"Error "+n+" with fsolve: "+str);
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
Deriv_variables = X2variables (Index_Imaclim_VarResolRed, listDeriv_Var, Xbest);
execstr(fieldnames(Deriv_variables)+"= Deriv_variables." + fieldnames(Deriv_variables)+";");

if exists('Deriv_Exogenous')==1
    Table_Deriv_Exogenous = struct2Variables(Deriv_Exogenous,"Deriv_Exogenous");
    execstr(Table_Deriv_Exogenous)
end

/// Cacul des variables "temp" dans la fonction f_resolution
[NetFinancialDebt,Labour_Tax_Cut,Phi,Theta,G_Consumption_budget,Labour_Tax_rate,Carbon_Tax_rate_IC,Carbon_Tax_rate_C,Transp_margins_rates,Trade_margins_rates,ClimPolicyCompens,ClimPolCompensbySect,M,p,pX,X,pIC,pC,pG,pI,pM,CPI, GDP_pFish, G_pFish, I_pFish, pL,alpha,lambda,kappa,I,pK,IC,Capital_consumption,Transp_margins,Trade_margins,Profit_margin,Capital_income,Labour_income,GrossOpSurplus,GDP,Other_Direct_Tax,Pension_Benefits,UnemployBenefits,Other_SocioBenef,Pensions,u,Unemployed,Unemployment_transfers,Other_social_transfers,Property_income,NetCompWages_byAgent,GOS_byAgent,Other_Transfers,H_disposable_income,Household_savings,Corporate_Tax,Production_Tax,w,Labour_Tax,Energy_Tax_IC,Energy_Tax_FC,OtherIndirTax,VA_Tax,Carbon_Tax_IC,Carbon_Tax_C,Corp_disposable_income,Corporations_savings,G_disposable_income,Government_savings,GFCF_byAgent,NetLending,Consumption_budget,Labour,SpeMarg_IC,SpeMarg_C,SpeMarg_G,SpeMarg_X,SpeMarg_I,Distribution_Shares, delta_LS_S, delta_LS_H, delta_LS_I, delta_LS_LT] = f_resol_interm();

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
