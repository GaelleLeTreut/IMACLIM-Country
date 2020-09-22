
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// ECONOMIC EQUATIONS
//
// This file is a library of economic equations for building the economic systems
//  Those equations are listed by "economic blocks". These blocks appear in most versions of IMACLIM models.
//  There are two kinds of equations in each block:  1) Accounting identities (always verified)
//               2) Behavioural equations (reflecting some particular assumptions on behaviours)
//  The flexibility of the model allows substitutions of alternative behavioural equations to test the sensibility of the results
//  to different assumptions (conceptions or theories) about economic behaviours.
//  Those alternatives behavioural equations are indexed and included into the system according to the SIMALULATION PLAN
//
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////


/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//// A)  Demography (for each household class h1,h2,..hn )
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////


//	Enlever - a mettre dans projection
/// Number of consumption units (CU) - according to the OECD equivalence scale
function [y] = Consump_Units_const_1(Consumption_Units, Consumption_Units_ref);

    /// Exogenous number
    y1 = Consumption_Units - Consumption_Units_ref ;

    y=y1';
endfunction

//	Enlever - a mettre dans projection
/// Number of retired
function [y] = Retired_Const_1(Retired, Retired_ref);

    /// Exogenous number
    y1 = Retired - Retired_ref ;

    y=y1';
endfunction

//	Enlever - a mettre dans projection
/// Active population (Labour_force) and Number of retires ( receiving pension benefits )
/// Exogenous demographic ratio and number of retired
function [y] = Demo_ratio_Const_1(Retired, Retired_ref, Labour_force, Labour_force_ref, Demo_ratio_change);

    /// Reference demographic ratio
    Demo_ratio_ref = Labour_force_ref ./ Retired_ref ;

    /// Demographic ratio
    Demo_ratio = Labour_force ./ Retired ;

    /// Rate of change of the demographic ratio, according to the exogenous parameter: Demo_ratio_change
    y1 = Demo_ratio - ( ones(1, nb_Households) + Demo_ratio_change ) .* Demo_ratio_ref ;

    y=y1';
endfunction

// Proj : Pop = (1+ delta)^t * popo initial
//	Voir pou pop totele et pop active

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//// B)  Behaviours of institutional agents
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////


/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//////   B.1 Households (for each household class h1,h2,..hn )
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////


// Disposable income accruing to each household class after redistribution (primary income distribution, redistribution and tax payments)
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

/// Household_income_1 :

function y = H_Income_Const_1(H_disposable_income, NetCompWages_byAgent, GOS_byAgent, Pensions, Unemployment_transfers, Other_social_transfers, Other_Transfers, ClimPolicyCompens, Property_income, Income_Tax, Other_Direct_Tax) ;

    // Income by sources, redistribution and tax payments
    H_Labour_Income     = NetCompWages_byAgent (Indice_Households) ;
    H_Non_Labour_Income = GOS_byAgent (Indice_Households) ;
    H_Social_Transfers  = Pensions + Unemployment_transfers + Other_social_transfers;
    H_Other_Income      = Other_Transfers(Indice_Households) + ClimPolicyCompens(Indice_Households);
    H_Property_income   = Property_income(Indice_Households) ;
    H_Tax_Payments      = Income_Tax + Other_Direct_Tax;

    // After tax household classes disposable income constraint (H_disposable_income)
    y1 = H_disposable_income - (H_Labour_Income + H_Non_Labour_Income + H_Social_Transfers + H_Other_Income + H_Property_income - H_Tax_Payments) ;
 
	y=y1';
endfunction

function H_disposable_income = H_Income_Val_1(NetCompWages_byAgent, GOS_byAgent, Pensions, Unemployment_transfers, Other_social_transfers, Other_Transfers, ClimPolicyCompens, Property_income, Income_Tax, Other_Direct_Tax)

    // Income by sources, redistribution and tax payments
    H_Labour_Income     = NetCompWages_byAgent (Indice_Households) ;
    H_Non_Labour_Income = GOS_byAgent (Indice_Households) ;
    H_Social_Transfers  = Pensions + Unemployment_transfers + Other_social_transfers;
    H_Other_Income      = Other_Transfers(Indice_Households) + ClimPolicyCompens(Indice_Households);
    H_Property_income   = Property_income(Indice_Households) ;
    H_Tax_Payments      = Income_Tax + Other_Direct_Tax;

    // After tax household classes disposable income constraint (H_disposable_income)
    H_disposable_income = (H_Labour_Income + H_Non_Labour_Income + H_Social_Transfers + H_Other_Income + H_Property_income - H_Tax_Payments) ;

endfunction

// for Brasil
function y = H_Income_Const_2(H_disposable_income, NetCompWages_byAgent, GOS_byAgent, Gov_social_transfers, Corp_social_transfers, Other_Transfers, ClimPolicyCompens, Property_income, Income_Tax, Gov_Direct_Tax, Corp_Direct_Tax) ;

    // Income by sources, redistribution and tax payments
    H_Labour_Income     = NetCompWages_byAgent (Indice_Households) ;
    H_Non_Labour_Income = GOS_byAgent (Indice_Households) ;
    H_Social_Transfers  = Gov_social_transfers + Corp_social_transfers;
    H_Other_Income      = Other_Transfers(Indice_Households) + ClimPolicyCompens(Indice_Households);
    H_Property_income   = Property_income(Indice_Households) ;
    H_Tax_Payments      = Income_Tax + Gov_Direct_Tax + Corp_Direct_Tax;

    // After tax household classes disposable income constraint (H_disposable_income)
    y1 = H_disposable_income - (H_Labour_Income + H_Non_Labour_Income + H_Social_Transfers + H_Other_Income + H_Property_income - H_Tax_Payments) ;
 
	y=y1';
endfunction

function H_disposable_income = H_Income_Val_2(NetCompWages_byAgent, GOS_byAgent, Gov_social_transfers, Corp_social_transfers, Other_Transfers, ClimPolicyCompens, Property_income, Income_Tax, Gov_Direct_Tax, Corp_Direct_Tax)

    // Income by sources, redistribution and tax payments
    H_Labour_Income     = NetCompWages_byAgent (Indice_Households) ;
    H_Non_Labour_Income = GOS_byAgent (Indice_Households) ;
    H_Social_Transfers  = Gov_social_transfers + Corp_social_transfers;
    H_Other_Income      = Other_Transfers(Indice_Households) + ClimPolicyCompens(Indice_Households);
    H_Property_income   = Property_income(Indice_Households) ;
    H_Tax_Payments      = Income_Tax + Gov_Direct_Tax + Corp_Direct_Tax;

    // After tax household classes disposable income constraint (H_disposable_income)
    H_disposable_income = (H_Labour_Income + H_Non_Labour_Income + H_Social_Transfers + H_Other_Income + H_Property_income - H_Tax_Payments) ;
    
endfunction

/// Pensions by household class
function y = Pensions_Const_1(Pensions, Pension_Benefits, Retired)

    // Pension payments accruing to each household class, function of the level pension benefit and the number of pensioners
    y1 = Pensions - Pension_Benefits .* Retired  ;

	y=y1';
endfunction

function Pensions = Pensions_Val_1(Pension_Benefits, Retired)

    // Pension payments accruing to each household class, function of the level pension benefit and the number of pensioners
    Pensions = Pension_Benefits .* Retired  ;

endfunction

/// Unemployment transfers by household class
function [y] = Unemploy_Transf_Const_1(Unemployment_transfers, UnemployBenefits, Unemployed) ;

    // Unemployment payments accruing to each household class, function of the level unemployment benefit and the number of unemployed
    y1 = Unemployment_transfers - UnemployBenefits .* Unemployed ;

	y=y1';	
endfunction

function Unemployment_transfers = Unemploy_Transf_Val_1(UnemployBenefits, Unemployed)

    // Unemployment payments accruing to each household class, function of the level unemployment benefit and the number of unemployed
    Unemployment_transfers = UnemployBenefits .* Unemployed ;

endfunction

/// Other social transfers by household class
function y = OtherSoc_Transf_Const_1(Other_social_transfers, Other_SocioBenef, Population) ;


    // Other social transfers payments accruing to each household class, function of the level other social benefits and the number of people
    y1 = Other_social_transfers - Other_SocioBenef .* Population ;

	y=y1';		
endfunction

function Other_social_transfers = OtherSoc_Transf_Val_1(Other_SocioBenef, Population)

    // Other social transfers payments accruing to each household class, function of the level other social benefits and the number of people
    Other_social_transfers = Other_SocioBenef .* Population ;
	
endfunction


/// Property incomes (Financial transfers) by household class
function y = H_PropTranf_Const_1(Property_income, interest_rate, NetFinancialDebt) ;

    // Financial transfers are positive if Household classes hold net financial assets ( i.e. NetFinancialDebt(Indice_Households) < 0 )
    y = (Property_income(Indice_Households) + interest_rate(Indice_Households) .* NetFinancialDebt(Indice_Households))';

endfunction

///	proj: il faut que ça varie comme le PIB pour homothétie
function y = H_PropTranf_Const_2(Property_income, GDP) ;

    // Financial transfers are positive if Household classes hold net financial assets ( i.e. NetFinancialDebt(Indice_Households) < 0 )
    y = (Property_income(Indice_Households) - (GDP/BY.GDP) * BY.Property_income(Indice_Households))';

endfunction

function Property_income = PropTranf_Const_2(GDP) ;

    // Financial transfers are positive if Household classes hold net financial assets ( i.e. NetFinancialDebt(Indice_Households) < 0 )
    Property_income(Indice_Households) = (GDP/BY.GDP) * BY.Property_income(Indice_Households);
    Property_income(Indice_Corporations) = (GDP/BY.GDP) * BY.Property_income(Indice_Corporations);
    Property_income(Indice_Government) = (GDP/BY.GDP) * BY.Property_income(Indice_Government);
    Property_income(Indice_RestOfWorld) = - ( Property_income(Indice_Corporations) + sum(Property_income(Indice_Households)) + Property_income(Indice_Government) ) ;

endfunction

// Household savings and consumption budgets (by household class)
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

/// Household_savings_constraint_1 : Proportion of disposable income (saving rate)

function y = H_Savings_Const_1(Household_savings, H_disposable_income, Household_saving_rate) ;

    /// Household savings constraint (Household_savings)
    y1 = Household_savings - (H_disposable_income .* Household_saving_rate) ;

	y=y1';		
endfunction

function Household_savings = H_Savings_Val_1(H_disposable_income, Household_saving_rate)

    /// Household savings constraint (Household_savings)
    Household_savings = (H_disposable_income .* Household_saving_rate) ;
		
endfunction


// Household gross fixed capital formation (by household class)
// A proportion of disposable income is used directly by household classes to accumulate capital stocks (houses, lands, business goodwill of individual entrepreneurs, etc.)
// The household gross fixed capital formation differs from household savings (if higher, they lend money in financial markets; if lower, they borrow in financial markets)
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////


/// Household_investment_constraint_1 : Proportion of disposable income ('propensity' to invest)

function y = H_Investment_Const_1(GFCF_byAgent, H_disposable_income, H_Invest_propensity) ;

    // Household gross fixed capital formation constraint (GFCF_byAgent(Indice_Households))
    y1 = GFCF_byAgent(Indice_Households) - (H_disposable_income .* H_Invest_propensity) ;

	y=y1';		
endfunction

function y = H_Investment_Const_2(GFCF_byAgent, pC, C) ;

    // Indice_Immo = find(Index_Sectors == Index_Property_business);

    // Household gross fixed capital formation constraint (GFCF_byAgent(Indice_Households))
    y1 = GFCF_byAgent(Indice_Households) - BY.GFCF_byAgent(Indice_Households)*sum(C(Indice_Immo,:).*pC(Indice_Immo,:))/sum(BY.C(Indice_Immo,:).*BY.pC(Indice_Immo,:));

	y=y1';		
endfunction

// Household net lending (+) / net borrowing (-) (by household class)
// Difference between disposable income and expenditures (consumption and gross fixed capital formation)
// The current account is balanced (if = 0) / imbalanced (if <> 0); current account surplus if >0 / current account deficit if <0
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////


/// Household_NetLending_constraint_1

function y = H_NetLending_Const_1(NetLending, GFCF_byAgent, Household_savings) ;

    /// Household net lending constraint (NetLending)
    y1 = NetLending(Indice_Households) - (Household_savings - GFCF_byAgent(Indice_Households)) ;

	y=y1';		
endfunction


// Household net financial position: stock of debt (+) / liabilities (-) (by household class)
// Counter-part of past accumulated net lending / net borrowing
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////


// PAS NECESSAIRE CALIBRAGE //
/// Household_NetDebt_constraint_1 : linear deviation from a reference level (Household_NetDebt_ref)
/// The Debt deviation is proportional to the deviation of net lending/borrowing from its reference level (NetLending_ref(Indice_Households))

function y = H_NetDebt_Const_1(NetFinancialDebt, time_since_ini, NetLending) ;

    /// Household net Debt constraint (NetFinancialDebt)
    y1 = NetFinancialDebt(Indice_Households) - ( ini.NetFinancialDebt(Indice_Households) + (time_since_ini / 2) * (ini.NetLending(Indice_Households) - NetLending(Indice_Households) ) ) ;

	y=y1';		
endfunction

function y = H_NetDebt_Const_2(NetFinancialDebt, time_since_ini, NetLending) ;

    /// Household net Debt constraint (NetFinancialDebt)
    y1 = NetFinancialDebt(Indice_Households) - BY.NetFinancialDebt(Indice_Households);

	y=y1';		
endfunction


// Household consumption (by products, by household class)
// Aggregated demand functions (may not assume identical and perfect aggregation preferences, identical constraints and maximisation programs)
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////


/// Household Total consumption budget
function y = ConsumBudget_Const_1(Consumption_budget, H_disposable_income, Household_saving_rate) ;

    /// Source of consumption budget - Share of disposable income (by household class)
    y1 = Consumption_budget - H_disposable_income .* (1 - Household_saving_rate) ;

	y=y1';		
endfunction

function Consumption_budget = ConsumBudget_Val_1(H_disposable_income, Household_saving_rate)

    /// Source of consumption budget - Share of disposable income (by household class)
    Consumption_budget = H_disposable_income .* (1 - Household_saving_rate);
	
endfunction

// PAS NECESSAIRE CALIBRAGE //
/// Balance between consumption budgets and expenditures
function [y] = BudgetBalance_Const_1(Consumption_budget, C, pC) ;

    /// Use of consumption budget - Consumption expenditures (by consumption item and household class)
    y1 = Consumption_budget - sum(C .* pC, "r") ;

    y=y1' ;
endfunction

/// Consumption budget shares - by commodity and by household class
function [y] = BudgetShares_Const_1(Budget_Shares, Consumption_budget, C_value) ;

    /// Consumption budget by consumption item by household class: Household_Budget (nb_Commodities, nb_Households)
    y1 = C_value - ( Budget_Shares .* (ones(nb_Commodities, 1).*.Consumption_budget) ) ;
    y  = matrix(y1, -1 , 1) ;

endfunction

/// Consumption Expenditures - by commodity and by household class
function [y] = ConsumExpend_Const_1(C_value, C, pC) ;

    /// Consumption expenditures (in monetary unit)
    y1 = C_value - ( C .* pC ) ;
    y  = matrix(y1, -1 , 1) ;

endfunction

// PAS NECESSAIRE CALIBRAGE //
/// Household_demand_constraint_1 : Demand functions only for energy final products,
///         The demand for the non-energy product balances the consumption budget
///         The distribution of budget shares for non-energy products is exogenous
///         Same demand functions for all household classes

// Val not possible : this function depends on C
function y = H_demand_Const_1(Consumption_budget, C, ConstrainedShare_C, pC, CPI, sigma_pC, sigma_ConsoBudget) ;
    signRuben = sign(pC);
    pC = abs ( pC);
	Consumption_budget = abs(Consumption_budget);
    /// They number of demand functions is equal to the number of productive sectors times the number of household classes
    /// Here, a productive sector produces only one consumption product
    /// Some productive sectors produce only intermediate consumptions. In this case, the final demand is zero.

    /// Household demand constraint: C (nb_Sectors, nb_Households)
    y1 = zeros(nb_Commodities, nb_Households) ;

    /// Final energy consumption ( when Commodities indices = Indice_EnerSect )
    ///. Constrained level of demand
    /// . Variable consumption level
    ///. Variation with relative prices (price-elasticities sigma_pC)
    ///. Variation with consumption budget (income-elasticities : sigma_ConsoBudget)

	// IF only one elasticities for all sectors ( in Brazil, sectoral differenciation) 
	if size(sigma_ConsoBudget,"r")==1
		sigma_ConsoBudget = sigma_ConsoBudget .*. ones(nb_Sectors, 1);
	end
	

    y1(Indice_EnerSect, :) = C(Indice_EnerSect, :) - ((1+delta_C_parameter(Indice_EnerSect)').^time_since_BY).*.(ones(1,nb_Households)).* .. 
(ConstrainedShare_C(Indice_EnerSect, :) .* BY.C(Indice_EnerSect, :) + (1 - ConstrainedShare_C(Indice_EnerSect, :)) .* BY.C(Indice_EnerSect, :) .* ( (pC(Indice_EnerSect, :)/CPI) ./ (BY.pC(Indice_EnerSect, :)/BY.CPI) ).^ sigma_pC(Indice_EnerSect, :) .* (( ( (Consumption_budget.*.ones(nb_EnerSect, 1))./CPI) ./ ((BY.Consumption_budget.*.ones(nb_EnerSect, 1))./BY.CPI) ) .^ sigma_ConsoBudget(Indice_EnerSect, :)) );

	if is_projected('C') then
		// As it is ; H_demand_Const_1 only works if only energy are forced. Checking if it's the case
		check_ind =[];
			for ind = Proj_Vol.C.ind_of_proj
				check_ind(1+$:size(ind(1),"c")+$,1) =ind(1)'
			end
		if ~Indice_EnerSect == check_ind'
			error("H_demand_Const_1 can not inform other values than the C from Energy - use H_demand_Const_2 or improve H_demand_Const_1 required")
		end
	
        y1 = apply_proj_eq(y1,C,'C');
    end
	
    /// Non energy consumption (when Commodities = Indice_NonEnerSect )
    /// Exogenous distribution of budget shares among non final energy consumption items (Budget_Shares_ref)
    // y1(Indice_NonEnerSect, :) = pC(Indice_NonEnerSect, :) .* C(Indice_NonEnerSect, :) - Budget_Shares_ref(Indice_NonEnerSect, :) * Consumption_budget ;

    NonFinEn_budget =  Consumption_budget - sum(pC(Indice_EnerSect,:) .* C(Indice_EnerSect,:),"r");

    y1(Indice_NonEnerSect, :) = pC(Indice_NonEnerSect, :) .* C(Indice_NonEnerSect, :) - NonFinEn_BudgShare_ref .* ( NonFinEn_budget .*. ones(nb_NonEnerSect, 1) ) ;



    y = matrix(y1 .* signRuben, -1 , 1) ;

endfunction


///	Linear demand function with price and income elasticities for all goods - 
// Val not possible : this function depends on C
function y = H_demand_Const_2(Consumption_budget, C, ConstrainedShare_C, pC, CPI, sigma_pC, sigma_ConsoBudget) ;
    signRuben = sign(pC);
    pC = abs ( pC);
	Consumption_budget = abs(Consumption_budget);

	y1 = zeros(nb_Commodities, nb_Households) ;
	
	// IF only one elasticities for all sectors ( in Brazil, sectoral differenciation) 
	if size(sigma_ConsoBudget,"r")==1
	sigma_ConsoBudget = sigma_ConsoBudget .*. ones(nb_Sectors, 1);
	end

	//// Warning code: assuming that the last sector in the matrix is the composite one 
    y1(1:nb_Sectors-1, :) = C(1:nb_Sectors-1, :) - (1+delta_C_parameter(1:nb_Sectors-1)').^time_since_BY.*.(ones(1,nb_Households)).* .. 
(ConstrainedShare_C(1:nb_Sectors-1, :) .* BY.C(1:nb_Sectors-1, :) + (1 - ConstrainedShare_C(1:nb_Sectors-1, :)) .* BY.C(1:nb_Sectors-1, :) .* ( (pC(1:nb_Sectors-1, :)/CPI) ./ (BY.pC(1:nb_Sectors-1, :)/BY.CPI) ).^ sigma_pC(1:nb_Sectors-1, :) .* (( ((Consumption_budget.*.ones(nb_Sectors-1, 1))./CPI) ./ ((BY.Consumption_budget.*.ones(nb_Sectors-1, 1))./BY.CPI) ) .^ sigma_ConsoBudget(1:nb_Sectors-1, :) ) );

	/// Replace C by the one that are informed if so
    if is_projected('C') then
        y1 = apply_proj_eq(y1,C,'C');
    end
	
	// Remaining budget goes to composite
    Composite_budget =  Consumption_budget - sum(pC(1:nb_Sectors-1, :) .* C(1:nb_Sectors-1, :),"r");
	y1 (nb_Sectors,:) = pC(nb_Sectors,:) .* C(nb_Sectors,:) - Composite_budget ;
	
    y = matrix(y1 .* signRuben, -1 , 1) ;
endfunction

function C = H_demand_Val_2(Consumption_budget, ConstrainedShare_C, pC, CPI, sigma_pC, sigma_ConsoBudget)
    signRuben = sign(pC);
    pC = abs ( pC);
	Consumption_budget = abs(Consumption_budget);
	
	// IF only one elasticities for all sectors ( in Brazil, sectoral differenciation) 
	if size(sigma_ConsoBudget,"r")==1
	sigma_ConsoBudget = sigma_ConsoBudget .*. ones(nb_Sectors, 1);
	end

    C = zeros(C);

    C(1:nb_Sectors-1, :) = (1+delta_C_parameter(1:nb_Sectors-1)').^time_since_BY.*.(ones(1,nb_Households)).* .. 
(ConstrainedShare_C(1:nb_Sectors-1, :) .* BY.C(1:nb_Sectors-1, :) + (1 - ConstrainedShare_C(1:nb_Sectors-1, :)) .* BY.C(1:nb_Sectors-1, :) .* ( (pC(1:nb_Sectors-1, :)/CPI) ./ (BY.pC(1:nb_Sectors-1, :)/BY.CPI) ).^ sigma_pC(1:nb_Sectors-1, :) .* (( ((Consumption_budget.*.ones(nb_Sectors-1, 1))./CPI) ./ ((BY.Consumption_budget.*.ones(nb_Sectors-1, 1))./BY.CPI) ).^ sigma_ConsoBudget(1:nb_Sectors-1, :) ) );

    /// Replace C by the one that are informed if so
    if is_projected('C') then
        C = apply_proj_val(C,'C');
    end
	
	// Remaining budget goes to composite
    Composite_budget =  Consumption_budget - sum(pC(1:nb_Sectors-1, :) .* C(1:nb_Sectors-1, :),"r");
    C(nb_Sectors,:) = (pC(nb_Sectors,:) <> 0) .* divide(Composite_budget, pC(nb_Sectors,:), 1);
    
endfunction


/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//////    B.2 Corporations
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////


//  Disposable income accruing to all businesses after redistribution (primary income distribution, redistribution and tax payments)
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

/// Corporations_income_1 :

function y = Corp_income_Const_1(Corp_disposable_income, GOS_byAgent, Other_Transfers, Property_income , Corporate_Tax) ;

    // Income by sources, redistribution and tax payments
    Corp_Non_Labour_Income =  GOS_byAgent (Indice_Corporations) ;
    Corp_Other_Income      =  Other_Transfers(Indice_Corporations) ;
    Corp_Property_income   =  Property_income(Indice_Corporations);
    Corp_Tax_Payments      =  Corporate_Tax ;

    // After tax disposable income constraint (H_disposable_income)
    y1 = Corp_disposable_income - (Corp_Non_Labour_Income + Corp_Other_Income + Corp_Property_income - Corp_Tax_Payments);

	y=y1';		
endfunction

function Corp_disposable_income = Corp_income_Val_1(GOS_byAgent, Other_Transfers, Property_income , Corporate_Tax) ;

    // Income by sources, redistribution and tax payments
    Corp_Non_Labour_Income =  GOS_byAgent (Indice_Corporations) ;
    Corp_Other_Income      =  Other_Transfers(Indice_Corporations) ;
    Corp_Property_income   =  Property_income(Indice_Corporations);
    Corp_Tax_Payments      =  Corporate_Tax ;

    // After tax disposable income constraint (H_disposable_income)
    Corp_disposable_income = (Corp_Non_Labour_Income + Corp_Other_Income + Corp_Property_income - Corp_Tax_Payments);

	
endfunction

// Brasil
function y = Corp_income_Const_2(Corp_disposable_income, GOS_byAgent, Labour_Corp_Tax, Corp_Direct_Tax, Corp_social_transfers, Other_Transfers, Property_income , Corporate_Tax) ;
    
    // Income by sources, redistribution and tax payments
    Corp_Non_Labour_Income =  GOS_byAgent (Indice_Corporations) + sum(Labour_Corp_Tax) + sum(Corp_Direct_Tax) - sum(Corp_social_transfers);
    Corp_Other_Income      =  Other_Transfers(Indice_Corporations) ;
    Corp_Property_income   =  Property_income(Indice_Corporations);
    Corp_Tax_Payments      =  Corporate_Tax ;

    // After tax disposable income constraint (H_disposable_income)
    y1 = Corp_disposable_income - (Corp_Non_Labour_Income + Corp_Other_Income + Corp_Property_income - Corp_Tax_Payments);

	y=y1';		
endfunction

function Corp_disposable_income = Corp_income_Val_2(GOS_byAgent, Labour_Corp_Tax, Corp_Direct_Tax, Corp_social_transfers, Other_Transfers, Property_income , Corporate_Tax)
    
    // Income by sources, redistribution and tax payments
    Corp_Non_Labour_Income =  GOS_byAgent (Indice_Corporations) + sum(Labour_Corp_Tax) + sum(Corp_Direct_Tax) - sum(Corp_social_transfers);
    Corp_Other_Income      =  Other_Transfers(Indice_Corporations) ;
    Corp_Property_income   =  Property_income(Indice_Corporations);
    Corp_Tax_Payments      =  Corporate_Tax ;

    // After tax disposable income constraint (H_disposable_income)
    Corp_disposable_income = (Corp_Non_Labour_Income + Corp_Other_Income + Corp_Property_income - Corp_Tax_Payments);
    
endfunction

/// Financial transfers from/to Corporations
function y = Corp_PropTranf_Const_1(Property_income, interest_rate, NetFinancialDebt);

    // Financial transfers are negative if Corporations hold net financial debts ( i.e. NetFinancialDebt(Indice_Corporations) > 0 )
    y1 = Property_income(Indice_Corporations) + interest_rate(Indice_Corporations) .* NetFinancialDebt(Indice_Corporations) ;

	y=y1';		
endfunction

///	proj: il faut que ça varie comme le PIB pour homothétie
function y = Corp_PropTranf_Const_2(Property_income, GDP) ;

    y = Property_income(Indice_Corporations) - (GDP/BY.GDP) * BY.Property_income(Indice_Corporations)';

endfunction


// Corporations savings
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

/// Corporations_savings_constraint_1: All disposable incomes are savings (used to finance auto-investment or lent: NetLending(Indice_Corporations))

function y = Corp_savings_Const_1(Corporations_savings, Corp_disposable_income)

    /// Corporations savings constraint (Corporations_savings)
    y1 = Corporations_savings - Corp_disposable_income ;

	y=y1';		
endfunction

function Corporations_savings = Corp_savings_Val_1(Corp_disposable_income)

    /// Corporations savings constraint (Corporations_savings)
    Corporations_savings = Corp_disposable_income ;
		
endfunction


// Corporations gross fixed capital formation
// A proportion of disposable income is used directly by businesses to accumulate capital stocks (Investment expenditures of companies)
// The companies gross fixed capital formation differs from their savings (if higher, they lend money in financial markets; if lower, they borrow in financial markets)
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

/// Corporations_investment_constraint_1: Proportion of disposable income ('propensity' to invest)

function y = Corp_investment_Const_1(GFCF_byAgent, Corp_disposable_income, Corp_invest_propensity)

    // Corporations gross fixed capital formation constraint (GFCF_byAgent(Indice_Corporations))
    y1 = GFCF_byAgent(Indice_Corporations) - (Corp_disposable_income .* Corp_invest_propensity ) ;

	y=y1';		
endfunction


// Corporations net lending (+) / net borrowing (-)
// Difference between disposable income and expenditures (Gross fixed capital formation)
// The current account is balanced (if = 0) / imbalanced (if <> 0); current account surplus if >0 / current account deficit if <0
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

// PAS NECESSAIRE CALIBRAGE //
/// Corp__NetLending_constraint_1

function y = Corp_NetLending_Const_1(NetLending, GFCF_byAgent, Corporations_savings) ;

    /// Corporations net lending constraint (NetLending)
    y1 = NetLending(Indice_Corporations) - (Corporations_savings - GFCF_byAgent(Indice_Corporations));

	y=y1';		
endfunction

// Corporations net financial position: stock of debt (+) / liabilities (-)
// Counter-part of past accumulated net lending / net borrowing
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

/// Corporations_NetDebt_constraint_1: linear deviation from a reference level (NetFinancialDebt_ref)
/// The Debt deviation is proportional to the deviation of net lending/borrowing from its reference level (NetLending_ref(Indice_Corporations))

function y = Corp_NetDebt_Const_1(NetFinancialDebt, time_since_ini, NetLending) ;

    /// Household net lending constraint (NetLending(Indice_Households))
    y1 = NetFinancialDebt(Indice_Corporations) - (ini.NetFinancialDebt(Indice_Corporations) + (time_since_ini / 2) * (ini.NetLending(Indice_Corporations) - NetLending(Indice_Corporations))) ;

	y=y1';		
endfunction

function y = Corp_NetDebt_Const_2(NetFinancialDebt, time_since_ini, NetLending) ;

    /// Household net lending constraint (NetLending(Indice_Households))
    y1 = NetFinancialDebt(Indice_Corporations) - BY.NetFinancialDebt(Indice_Corporations) ; 

	y=y1';		
endfunction


/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
/////    B.3 Public administrations
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

//  Disposable income accruing to public administrations after redistribution (primary income distribution, redistribution and tax revenue)
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

/// Government_income_1 :

function y = G_income_Const_1(G_disposable_income, Income_Tax, Other_Direct_Tax, Corporate_Tax, Production_Tax, Labour_Tax, Energy_Tax_IC, Energy_Tax_FC, OtherIndirTax, VA_Tax, Carbon_Tax_IC, Carbon_Tax_C, GOS_byAgent, Pensions, Unemployment_transfers, Other_social_transfers, Other_Transfers, Property_income , ClimPolicyCompens, ClimPolCompensbySect, Carbon_Tax_M) ;

    // For one government. Distribution among different government must otherwise be specified.

    // Income by sources, redistribution and tax revenue
    G_Tax_revenue   = sum(Income_Tax + Other_Direct_Tax) + sum( Corporate_Tax ) + sum(Production_Tax + Labour_Tax + OtherIndirTax + VA_Tax) + sum(Energy_Tax_IC) + sum(Carbon_Tax_IC) + sum(Energy_Tax_FC) + sum(Carbon_Tax_C)+sum(Carbon_Tax_M);

    G_Non_Labour_Income =  GOS_byAgent (Indice_Government) ;
    G_Other_Income      =  Other_Transfers (Indice_Government) ;
    G_Property_income   =  Property_income(Indice_Government) ;
    G_Social_Transfers  =  sum(Pensions + Unemployment_transfers + Other_social_transfers) ;
    G_Compensations     =  sum(ClimPolicyCompens(Indice_Households)) + sum(ClimPolicyCompens(Indice_Corporations));
	// G_Compensations     =  sum(ClimPolicyCompens(Indice_Households)) + sum(ClimPolicyCompens(Indice_Corporations)) + sum (ClimPolCompensbySect);

    // After tax disposable income constraint (H_disposable_income)
    y1 = G_disposable_income - (G_Tax_revenue + G_Non_Labour_Income + G_Other_Income + G_Property_income - G_Social_Transfers - G_Compensations);

	y=y1';
endfunction

function G_disposable_income = G_income_Val_1(Income_Tax, Other_Direct_Tax, Corporate_Tax, Production_Tax, Labour_Tax, Energy_Tax_IC, Energy_Tax_FC, OtherIndirTax, VA_Tax, Carbon_Tax_IC, Carbon_Tax_C, GOS_byAgent, Pensions, Unemployment_transfers, Other_social_transfers, Other_Transfers, Property_income , ClimPolicyCompens, ClimPolCompensbySect, Carbon_Tax_M)

    // For one government. Distribution among different government must otherwise be specified.

    // Income by sources, redistribution and tax revenue
    G_Tax_revenue   = sum(Income_Tax + Other_Direct_Tax) + sum( Corporate_Tax ) + sum(Production_Tax + Labour_Tax + OtherIndirTax + VA_Tax) + sum(Energy_Tax_IC) + sum(Carbon_Tax_IC) + sum(Energy_Tax_FC) + sum(Carbon_Tax_C) + sum(Carbon_Tax_M) ;

    G_Non_Labour_Income =  GOS_byAgent (Indice_Government) ;
    G_Other_Income      =  Other_Transfers (Indice_Government) ;
    G_Property_income   =  Property_income(Indice_Government) ;
    G_Social_Transfers  =  sum(Pensions + Unemployment_transfers + Other_social_transfers) ;
    G_Compensations     =  sum(ClimPolicyCompens(Indice_Households)) + sum(ClimPolicyCompens(Indice_Corporations)) ;
	// G_Compensations     =  sum(ClimPolicyCompens(Indice_Households)) + sum(ClimPolicyCompens(Indice_Corporations)) + sum (ClimPolCompensbySect) ;

    // After tax disposable income constraint (H_disposable_income)
    G_disposable_income = (G_Tax_revenue + G_Non_Labour_Income + G_Other_Income + G_Property_income - G_Social_Transfers - G_Compensations);

endfunction

/// Government_income_2 :

function y = G_income_Const_2(G_disposable_income, Income_Tax, Gov_Direct_Tax, Corporate_Tax, Production_Tax, Labour_Tax, Energy_Tax_IC, Energy_Tax_FC, OtherIndirTax, Cons_Tax, Carbon_Tax_IC, Carbon_Tax_C, GOS_byAgent, Gov_social_transfers, Other_Transfers, Property_income, ClimPolicyCompens, ClimPolCompensbySect,Carbon_Tax_M) ;

    // For one government. Distribution among different government must otherwise be specified.

    // Income by sources, redistribution and tax revenue
    G_Tax_revenue   = sum(Income_Tax + Gov_Direct_Tax) + sum( Corporate_Tax ) + sum(Production_Tax + Labour_Tax + OtherIndirTax + Cons_Tax) + sum(Energy_Tax_IC) + sum(Carbon_Tax_IC) + sum(Energy_Tax_FC) + sum(Carbon_Tax_C) + sum(Carbon_Tax_M) ;
    G_Non_Labour_Income =  GOS_byAgent (Indice_Government) ;
    G_Other_Income      =  Other_Transfers (Indice_Government) ;
    G_Property_income   =  Property_income(Indice_Government) ;
    G_Social_Transfers  =  sum(Gov_social_transfers) ;
    G_Compensations     =  sum(ClimPolicyCompens(Indice_Households)) + sum(ClimPolicyCompens(Indice_Corporations)) ;
	// G_Compensations     =  sum(ClimPolicyCompens(Indice_Households)) + sum(ClimPolicyCompens(Indice_Corporations)) + sum (ClimPolCompensbySect) ;

    // After tax disposable income constraint (H_disposable_income)
    y1 = G_disposable_income - (G_Tax_revenue + G_Non_Labour_Income + G_Other_Income + G_Property_income - G_Social_Transfers - G_Compensations);

	y=y1';
endfunction

function G_disposable_income = G_income_Val_2(Income_Tax, Gov_Direct_Tax, Corporate_Tax, Production_Tax, Labour_Tax, Energy_Tax_IC, Energy_Tax_FC, OtherIndirTax, Cons_Tax, Carbon_Tax_IC, Carbon_Tax_C, GOS_byAgent, Gov_social_transfers, Other_Transfers, Property_income, ClimPolicyCompens, ClimPolCompensbySect, Carbon_Tax_M)

    // For one government. Distribution among different government must otherwise be specified.

    // Income by sources, redistribution and tax revenue
    G_Tax_revenue   = sum(Income_Tax + Gov_Direct_Tax) + sum( Corporate_Tax ) + sum(Production_Tax + Labour_Tax + OtherIndirTax + Cons_Tax) + sum(Energy_Tax_IC) + sum(Carbon_Tax_IC) + sum(Energy_Tax_FC) + sum(Carbon_Tax_C) + sum(Carbon_Tax_M);
	
    G_Non_Labour_Income =  GOS_byAgent (Indice_Government) ;
    G_Other_Income      =  Other_Transfers (Indice_Government) ;
    G_Property_income   =  Property_income(Indice_Government) ;
    G_Social_Transfers  =  sum(Gov_social_transfers) ;
    G_Compensations     =  sum(ClimPolicyCompens(Indice_Households)) + sum(ClimPolicyCompens(Indice_Corporations)) ;
	// G_Compensations     =  sum(ClimPolicyCompens(Indice_Households)) + sum(ClimPolicyCompens(Indice_Corporations)) + sum (ClimPolCompensbySect);

    // After tax disposable income constraint (H_disposable_income)
    G_disposable_income = (G_Tax_revenue + G_Non_Labour_Income + G_Other_Income + G_Property_income - G_Social_Transfers - G_Compensations);
    
endfunction

/// Financial transfers from/to Government
function [y] = G_PropTranf_Const_1(Property_income, interest_rate, NetFinancialDebt);

    // Financial transfers are negative if Corporations hold net financial debts ( i.e. NetFinancialDebt(Indice_Government) > 0 )
    y1 = Property_income(Indice_Government) + interest_rate(Indice_Government) .* NetFinancialDebt(Indice_Government) ;
	
	y=y1';
endfunction

///	proj: il faut que ça varie comme le PIB pour homothétie
function y = G_PropTranf_Const_2(Property_income, GDP) ;

    // Financial transfers are positive if Household classes hold net financial assets ( i.e. NetFinancialDebt(Indice_Households) < 0 )
    y = (Property_income(Indice_Government) - (GDP/BY.GDP) * BY.Property_income(Indice_Government))';

endfunction


/// Tax and benefit system

/// Tax Structure

/// Income Tax (by household class)

function y = Income_Tax_Const_1(Income_Tax, Income_Tax_rate, H_disposable_income, Other_Direct_Tax) ;

    // Income Tax Constraint by household classes
    y1 = Income_Tax - Income_Tax_rate .* (H_disposable_income + Income_Tax + Other_Direct_Tax) ;

	y=y1';
endfunction

function Income_Tax = Income_Tax_Val_1(Income_Tax_rate, H_disposable_income, Other_Direct_Tax)

    // Renvoie une erreur si Income_Tax == 1
    Income_Tax = (Income_Tax_rate .* (H_disposable_income  + Other_Direct_Tax)) ./ (1 - Income_Tax_rate);

endfunction

function y = Income_Tax_Const_2(Income_Tax, Income_Tax_rate, H_disposable_income, Gov_Direct_Tax, Corp_Direct_Tax) ;

    // Income Tax Constraint by household classes
    y1 = Income_Tax - Income_Tax_rate .* (H_disposable_income + Income_Tax + Gov_Direct_Tax + Corp_Direct_Tax) ;

	y=y1';
endfunction

function Income_Tax = Income_Tax_Val_2(Income_Tax_rate, H_disposable_income, Gov_Direct_Tax, Corp_Direct_Tax)

    // Income Tax Constraint by household classes
    Income_Tax = Income_Tax_rate .* (H_disposable_income + Gov_Direct_Tax + Corp_Direct_Tax) ./ (1 - Income_Tax_rate);

endfunction

/// Other direct Tax (by household class)
function y = Other_Direct_Tax_Const_1(Other_Direct_Tax, CPI, Other_Direct_Tax_param) ;
    
	CPI = abs(CPI)
    // Other direct Tax ( Other_Direct_Tax(1:nb_Households )
    y1 = Other_Direct_Tax - CPI * Other_Direct_Tax_param ;

	y=y1';	
endfunction


function Other_Direct_Tax = Other_Direct_Tax_Val_1( CPI, Other_Direct_Tax_param) ;

    // Other direct Tax ( Other_Direct_Tax(1:nb_Households )
    Other_Direct_Tax = CPI * Other_Direct_Tax_param ;

endfunction


///	proj: il faut que ça varie comme le PIB pour homothétie
///	Other Direct Tax indexed on GDP
function Other_Direct_Tax = Other_Direct_Tax_Val_2( GDP, Other_Direct_Tax_param) ;
    
    // Other direct Tax ( Other_Direct_Tax(1:nb_Households )
    Other_Direct_Tax = (GDP/BY.GDP) * Other_Direct_Tax_param ;
	
endfunction


// Brazil
function y = OthDirTax_rate_Const_1(Direct_Tax, Labour_income, Direct_Tax_rate) ;
    y1 = Direct_Tax - Direct_Tax_rate .* sum(Labour_income,"c");
    
    y=y1';
	
endfunction

function Direct_Tax = OthDirTax_rate_Val_1(Labour_income, Direct_Tax_rate) ;
    
    Direct_Tax = Direct_Tax_rate .* sum(Labour_income,"c");
	
endfunction


 ///	VOIR AJOUTER AUSSI SOUS CETTE FORME PROJ

/// Corporate Tax (by Corporations)

function y = Corporate_Tax_Const_1(Corporate_Tax, Corporate_Tax_rate, GOS_byAgent);

    // Corporate Tax ( Corporate_Tax(1:nb_Corporations) )
    y1 = Corporate_Tax - Corporate_Tax_rate .* GOS_byAgent(Indice_Corporations) ;

	y=y1';	
endfunction

function Corporate_Tax = Corporate_Tax_Val_1(Corporate_Tax_rate, GOS_byAgent)

    // Corporate Tax ( Corporate_Tax(1:nb_Corporations) )
    Corporate_Tax = Corporate_Tax_rate .* GOS_byAgent(Indice_Corporations);

endfunction

/// Production Tax (by productive sector)
function y = Production_Tax_Const_1(Production_Tax, Production_Tax_rate, pY, Y);
	
	pY= abs(pY);
    y = Production_Tax - Production_Tax_rate .* (pY .* Y)' ;
    y=y';

endfunction

function Production_Tax = Production_Tax_Val_1(Production_Tax_rate, pY, Y)
	pY= abs(pY);
    Production_Tax = Production_Tax_rate .* (pY .* Y)';

endfunction

/// Labour Tax (by productive sector)

function y = Labour_Tax_Const_1(Labour_Tax, Labour_Tax_rate, w, lambda, Y);

    // Labour Tax ( Labour_Tax(nb_Sectors) )
    y1 = Labour_Tax - (Labour_Tax_rate .* w .* lambda .* Y') ;
    y=y1';

endfunction

function Labour_Tax = Labour_Tax_Val_1(Labour_Tax_rate, w, lambda, Y)

    // Labour Tax ( Labour_Tax(nb_Sectors) )
    Labour_Tax = (Labour_Tax_rate .* w .* lambda .* Y');

endfunction

/// Energy Tax on intermediate energy consumptions (by energy product-by sector)
/// Differentiated rates by consumer type.

function y = Energy_Tax_IC_Const_1(Energy_Tax_IC, Energy_Tax_rate_IC, alpha, Y);

    // Same rate for all sectors
    y = Energy_Tax_IC' - Energy_Tax_rate_IC' .* sum( alpha .*(ones(nb_Commodities, 1).*.Y'), "c") ;

endfunction

function Energy_Tax_IC = Energy_Tax_IC_Val_1(Energy_Tax_rate_IC, alpha, Y)

    // Same rate for all sectors
    Energy_Tax_IC = ( Energy_Tax_rate_IC' .* sum( alpha .*(ones(nb_Commodities, 1).*.Y'), "c") )';

endfunction

/// Energy Tax on final energy consumptions (by energy product-by consumer)
/// Differentiated rates by consumer type.

function y = Energy_Tax_FC_Const_1(Energy_Tax_FC, Energy_Tax_rate_FC, C);

    // Same rates for all household classes
    y = Energy_Tax_FC' - Energy_Tax_rate_FC'.* sum( C , "c" ) ;

endfunction

function Energy_Tax_FC = Energy_Tax_FC_Val_1(Energy_Tax_rate_FC, C)

    // Same rates for all household classes
    Energy_Tax_FC = ( Energy_Tax_rate_FC'.* sum( C , "c" ) )';

endfunction

/// Other indirect Tax on both Intermediate consumptions and Final consumptions - same rate-  (by product-sector)

function y = OtherIndirTax_Const_1(OtherIndirTax, OtherIndirTax_rate, alpha, Y, C, G, I);

    // Same rates for all sectors
    y = OtherIndirTax' - OtherIndirTax_rate' .* (sum(alpha .*(ones(nb_Commodities, 1).*.Y'),"c")+sum( C,"c")+sum(G,"c")+sum(I, "c")) ;

endfunction

function OtherIndirTax = OtherIndirTax_Val_1(OtherIndirTax_rate, alpha, Y, C, G, I)

    // Same rates for all sectors
    OtherIndirTax = ( OtherIndirTax_rate' .* (sum(alpha .*(ones(nb_Commodities, 1).*.Y'),"c")+sum( C,"c")+sum(G,"c")+sum(I, "c")) )';

endfunction

/// Value Added Tax (by product-sector)

function y = VA_Tax_Const_1(VA_Tax, VA_Tax_rate, pC, C, pG, G, pI, I);

    // Same rate for all items of domestic final demand
    y = VA_Tax' - ( (VA_Tax_rate' ./ (1 + VA_Tax_rate')) .* (sum( pC .* C, "c") + sum(pG .* G, "c") + pI .* sum(I, "c")) ) ;

endfunction

function VA_Tax = VA_Tax_Val_1(VA_Tax_rate, pC, C, pG, G, pI, I)

    // Same rate for all items of domestic final demand
    VA_Tax = ( (VA_Tax_rate' ./ (1 + VA_Tax_rate')) .* (sum( pC .* C, "c") + sum(pG .* G, "c") + pI .* sum(I, "c")) )';

endfunction

/// Consumption Tax (by product-sector)

function y = Cons_Tax_Const_1(Cons_Tax, Cons_Tax_rate, pIC, IC, pC, C, pG, G, pI, I,Transp_margins_rates,Trade_margins_rates,SpeMarg_rates_C,SpeMarg_rates_IC,SpeMarg_rates_G,SpeMarg_rates_I);
	pIC = abs(pIC);
	
	// margins_rates_C= (ones(nb_Households,1) .*. ( Transp_margins_rates + Trade_margins_rates ) + SpeMarg_rates_C )' ;
	// Indirect_tax_rates_C =  (ones(nb_Households,1) .*. ( Energy_Tax_rate_FC + OtherIndirTax_rate ) )';
	// pC_BT = ( (ones(1, nb_Households).*.p') .* ( 1 + margins_rates_C )  + Indirect_tax_rates_C);
		
	// margins_rates_IC = ones(1,nb_Sectors).*. (Transp_margins_rates' + Trade_margins_rates') + SpeMarg_rates_IC' ;
	// Indirect_tax_rates_IC = ones(1,nb_Sectors).*.(Energy_Tax_rate_IC' + OtherIndirTax_rate') ;
	// pIC_BT = ( (ones(1, nb_Sectors).*.p') .* ( 1 + margins_rates_IC )+ Indirect_tax_rates_IC) ;
	
	// margins_rates_G = (Transp_margins_rates' + Trade_margins_rates').*. ones(1, nb_Government) + SpeMarg_rates_G';
	// Indirect_tax_rates_G = (Energy_Tax_rate_FC' + OtherIndirTax_rate').*. ones(1, nb_Government) ;
	// pG_BT = ( (p'.*.ones(1, nb_Government)) .* ( 1 + margins_rates_G ) + Indirect_tax_rates_G) ;
	
	// margins_rates_I = Transp_margins_rates' + Trade_margins_rates' + SpeMarg_rates_I'
	// Indirect_tax_rates_I = OtherIndirTax_rate'+Energy_Tax_rate_FC' ;
	// pI_BT = ( p' .* ( ones(nb_Commodities, 1) + margins_rates_I) + Indirect_tax_rates_I);
   
   //// Same rate for all items of domestic final demand
    // y = Cons_Tax' - ( ( (Cons_Tax_rate' ) .* (sum( pC_BT .* C, "c") + sum(pG_BT .* G, "c") + sum(pIC_BT .* IC, "c")+ pI_BT .* sum(I,"c")) ) ) ;

    ///// Same rate for all items of domestic final demand
    y = Cons_Tax' - ( (Cons_Tax_rate' ./ (1 + Cons_Tax_rate')) .* (sum( pC .* C, "c") + sum(pG .* G, "c") + sum(pIC .* IC, "c")+ pI .* sum(I,"c")) ) ;
    // y = Cons_Tax' - ( ( (Cons_Tax_rate' ) .* (sum( pC.* C, "c") + sum(pG.* G, "c") + sum(pIC.* IC, "c")+ pI .* sum(I,"c")) ) ) ;

	
endfunction

function Cons_Tax = Cons_Tax_Val_1(Cons_Tax_rate, pIC, IC, pC, C, pG, G, pI, I,Transp_margins_rates,Trade_margins_rates,SpeMarg_rates_C,SpeMarg_rates_IC,SpeMarg_rates_G,SpeMarg_rates_I)
	pIC = abs(pIC);
	
	// margins_rates_C= (ones(nb_Households,1) .*. ( Transp_margins_rates + Trade_margins_rates ) + SpeMarg_rates_C )' ;
	// Indirect_tax_rates_C =  (ones(nb_Households,1) .*. ( Energy_Tax_rate_FC + OtherIndirTax_rate ) )';
	// pC_BT = ( (ones(1, nb_Households).*.p') .* ( 1 + margins_rates_C )  + Indirect_tax_rates_C);
		
	// margins_rates_IC = ones(1,nb_Sectors).*. (Transp_margins_rates' + Trade_margins_rates') + SpeMarg_rates_IC' ;
	// Indirect_tax_rates_IC = ones(1,nb_Sectors).*.(Energy_Tax_rate_IC' + OtherIndirTax_rate') ;
	// pIC_BT = ( (ones(1, nb_Sectors).*.p') .* ( 1 + margins_rates_IC )+ Indirect_tax_rates_IC) ;
	
	// margins_rates_G = (Transp_margins_rates' + Trade_margins_rates').*. ones(1, nb_Government) + SpeMarg_rates_G';
	// Indirect_tax_rates_G = (Energy_Tax_rate_FC' + OtherIndirTax_rate').*. ones(1, nb_Government) ;
	// pG_BT = ( (p'.*.ones(1, nb_Government)) .* ( 1 + margins_rates_G ) + Indirect_tax_rates_G) ;
	
	// margins_rates_I = Transp_margins_rates' + Trade_margins_rates' + SpeMarg_rates_I'
	// Indirect_tax_rates_I = OtherIndirTax_rate'+Energy_Tax_rate_FC' ;
	// pI_BT = ( p' .* ( ones(nb_Commodities, 1) + margins_rates_I) + Indirect_tax_rates_I);
	
	///// Same rate for all items of domestic final demand
	// Cons_Tax =( ( (Cons_Tax_rate' ) .* (sum( pC_BT .* C, "c") + sum(pG_BT .* G, "c") + sum(pIC_BT .* IC, "c")+ pI_BT .* sum(I,"c")) ) )';
	
	///// Same rate for all items of domestic final demand
	Cons_Tax = ( ( (Cons_Tax_rate' ./ (1 + Cons_Tax_rate')) .* (sum( pC .* C, "c") + sum(pG .* G, "c") + sum(pIC .* IC, "c")+ pI .* sum(I,"c")) ) )';
	// Cons_Tax =( ( (Cons_Tax_rate' ) .* (sum( pC .* C, "c") + sum(pG .* G, "c") + sum(pIC .* IC, "c")+ pI .* sum(I,"c")) ) )';

endfunction

/// Carbon Tax on intermediate energy consumptions (by energy product-by sector)
/// Identical or differentiated rates by consumer type.

function y = Carbon_Tax_IC_Const_1(Carbon_Tax_IC, Carbon_Tax_rate_IC, alpha, Y, Emission_Coef_IC) ;

    // Tax rates potentially differs across sectors
    y1 = Carbon_Tax_IC - ( Carbon_Tax_rate_IC .* Emission_Coef_IC .* alpha .*(ones(nb_Commodities, 1).*.Y') ) ;
    y = matrix(y1, -1 , 1) ;
endfunction

function Carbon_Tax_IC = Carbon_Tax_IC_Val_1(Carbon_Tax_rate_IC, alpha, Y, Emission_Coef_IC)

    Carbon_Tax_IC = ( Carbon_Tax_rate_IC .* Emission_Coef_IC .* alpha .*(ones(nb_Commodities, 1).*.Y') );

endfunction


/// Carbon Tax on final energy consumptions (by energy product-by consumer)
/// Identical or differentiated rates by consumer type.

function [y] = Carbon_Tax_C_Const_1(Carbon_Tax_C, Carbon_Tax_rate_C, C, Emission_Coef_C) ;

    // Tax rates potentially differs across household classes
    y1 = Carbon_Tax_C - ( Carbon_Tax_rate_C .* Emission_Coef_C .* C ) ;

    y = matrix(y1, -1 , 1) ;
endfunction

function Carbon_Tax_C = Carbon_Tax_C_Val_1(Carbon_Tax_rate_C, C, Emission_Coef_C)

    // Tax rates potentially differs across household classes
    Carbon_Tax_C = ( Carbon_Tax_rate_C .* Emission_Coef_C .* C );

endfunction

/// Border Carbon Tax
/// Identical or differentiated rates by sectors

function [y] = Carbon_Tax_M_Const_1(Carbon_Tax_M, Carbon_Tax_rate_M, M, Emission_Coef_M) ;

    // Tax rates potentially differs across sectors
    y1 = Carbon_Tax_M - ( Carbon_Tax_rate_M .* Emission_Coef_M .* M' ) ;
    y = matrix(y1, -1 , 1) ;
	
endfunction

function Carbon_Tax_M = Carbon_Tax_M_Val_1(Carbon_Tax_rate_M, M, Emission_Coef_M)

    // Tax rates potentially differs across sectors
    Carbon_Tax_M = ( Carbon_Tax_rate_M .* Emission_Coef_M .* M' );

endfunction

//////
/// Social benefits
//////

/// Pension benefits (by household class)
//// Opt 1 = function of net wage variation
function [y] = Pension_Benefits_Const_1(Pension_Benefits, NetWage_variation, Pension_Benefits_param, GDP, CPI, Population) ;

    y1 = Pension_Benefits - NetWage_variation * Pension_Benefits_param ;

    y=y1';
endfunction

function [Pension_Benefits] = Pension_Benefits_Val_1(NetWage_variation, Pension_Benefits_param, GDP, CPI, Population) ;

    Pension_Benefits = NetWage_variation * Pension_Benefits_param ;

endfunction

//// Opt 2 = function of GDP variation - >  only for hometetic proj
function [y] = Pension_Benefits_Const_2(Pension_Benefits, NetWage_variation, Pension_Benefits_param, GDP, CPI, Population) ;

    y1 = Pension_Benefits - (GDP/BY.GDP) * Pension_Benefits_param ;

    y=y1';
endfunction

function Pension_Benefits = Pension_Benefits_Val_2(NetWage_variation, Pension_Benefits_param, GDP, CPI, Population)

    Pension_Benefits = (GDP/BY.GDP) * Pension_Benefits_param;

endfunction

//// Opt 3 = constant
function [y] = Pension_Benefits_Const_3(Pension_Benefits, NetWage_variation, Pension_Benefits_param, GDP, CPI, Population) ;

    y1 = Pension_Benefits - BY.Pension_Benefits ;

    y=y1';
endfunction

//// Opt 4 = function of CPI
function [y] = Pension_Benefits_Const_4(Pension_Benefits, NetWage_variation, Pension_Benefits_param, GDP, CPI, Population) ;

    y1 = Pension_Benefits - CPI .* Pension_Benefits_param ;

    y=y1';
endfunction

function [Pension_Benefits] = Pension_Benefits_Val_4(NetWage_variation, Pension_Benefits_param, GDP, CPI, Population) ;

    Pension_Benefits = CPI .* Pension_Benefits_param ;

endfunction

//// Opt 5 = function of GDP/Capita
function [y] = Pension_Benefits_Const_5(Pension_Benefits, NetWage_variation, Pension_Benefits_param, GDP, CPI, Population) ;

    y1 = Pension_Benefits - (GDP / BY.GDP) * ( BY.Population ./ Population )  * Pension_Benefits_param ;
    y=y1';
	
endfunction

function [Pension_Benefits] = Pension_Benefits_Val_5(NetWage_variation, Pension_Benefits_param, GDP, CPI, Population) ;

	Pension_Benefits = (GDP / BY.GDP) .* ( BY.Population ./ Population )  * Pension_Benefits_param ;

endfunction

/// Unemployment benefits (by household class)
//// Opt 1 = function of net wage variation
function [y] = UnemployBenefits_Const_1(UnemployBenefits, NetWage_variation, UnemployBenefits_param, GDP, Unemployed) ;

    y1 = UnemployBenefits - NetWage_variation * UnemployBenefits_param ;

    y=y1';
endfunction

function UnemployBenefits = UnemployBenefits_Val_1(NetWage_variation, UnemployBenefits_param, GDP, Unemployed)

    UnemployBenefits = NetWage_variation * UnemployBenefits_param;

endfunction

//// Opt 2 = function of GDP/unemployed variation - >  for hometetic proj
function [y] = UnemployBenefits_Const_2(UnemployBenefits, NetWage_variation, UnemployBenefits_param, GDP, Unemployed) ;

    y1 = UnemployBenefits - (GDP / BY.GDP) * ( BY.Unemployed ./ Unemployed ) .* UnemployBenefits_param ;

    y=y1';
endfunction

function UnemployBenefits = UnemployBenefits_Val_2(NetWage_variation, UnemployBenefits_param, GDP, Unemployed)

    UnemployBenefits = (GDP / BY.GDP) * ( BY.Unemployed ./ Unemployed ) .* UnemployBenefits_param ;

endfunction

//// Opt 3 = constant
function [y] = UnemployBenefits_Const_3(UnemployBenefits, NetWage_variation, UnemployBenefits_param, GDP, Unemployed) ;

    y1 = UnemployBenefits - BY.UnemployBenefits;

    y=y1';
endfunction

/// Other social benefits (by household class)
//// Opt 1 = function of net wage variation
function [y] = Other_SocioBenef_Const_1(Other_SocioBenef, NetWage_variation, Other_SocioBenef_param, GDP, CPI, Population, AdjRecycle ) 

	if ClosCarbRev <>"AdjTransf" 
		y1 = Other_SocioBenef - NetWage_variation * Other_SocioBenef_param ;
	else
		y1 = Other_SocioBenef - NetWage_variation * Other_SocioBenef_param .* (AdjRecycle.*ones(1,nb_Households).*Exo_HH + ones(1,nb_Households) );
	end
    y=y1';
	
endfunction

function [Other_SocioBenef] = Other_SocioBenef_Val_1(NetWage_variation, Other_SocioBenef_param, GDP, CPI, Population, AdjRecycle) ;

	if ClosCarbRev <>"AdjTransf" 
		Other_SocioBenef  = NetWage_variation * Other_SocioBenef_param ;
	else	
		Other_SocioBenef  = NetWage_variation * Other_SocioBenef_param .* (AdjRecycle.*ones(1,nb_Households).*Exo_HH + ones(1,nb_Households) ) ;
	end

endfunction

//// Opt 2 = function of GDP/capita variation - > hometetic proj
function [y] = Other_SocioBenef_Const_2(Other_SocioBenef, NetWage_variation, Other_SocioBenef_param, GDP, CPI, Population, AdjRecycle )
	
	if ClosCarbRev <>"AdjTransf" 
		y1 = Other_SocioBenef - (GDP / BY.GDP) * ( BY.Population ./ Population ) .* Other_SocioBenef_param ;
	else
		y1 = Other_SocioBenef - (GDP / BY.GDP) * ( BY.Population ./ Population ).*  (AdjRecycle.*ones(1,nb_Households).*Exo_HH + ones(1,nb_Households) ).* Other_SocioBenef_param ;
	end
	
    y=y1';
	
endfunction

function Other_SocioBenef = Other_SocioBenef_Val_2(NetWage_variation, Other_SocioBenef_param, GDP, CPI, Population, AdjRecycle )
	
	if ClosCarbRev <>"AdjTransf" 
		Other_SocioBenef = (GDP / BY.GDP) * ( BY.Population ./ Population ) .* Other_SocioBenef_param;
	else
		Other_SocioBenef = (GDP / BY.GDP) * ( BY.Population ./ Population ) .* (AdjRecycle.*ones(1,nb_Households).*Exo_HH + ones(1,nb_Households) )  .* Other_SocioBenef_param
	
	end

endfunction

//// Opt 3 = constant
function [y] = Other_SocioBenef_Const_3(Other_SocioBenef, NetWage_variation, Other_SocioBenef_param, GDP, CPI, Population, AdjTransf )

	if ClosCarbRev <>"AdjTransf" 
		y1 = Other_SocioBenef - BY.Other_SocioBenef;
	else
		y1 = Other_SocioBenef - BY.Other_SocioBenef.* (AdjRecycle.*ones(1,nb_Households).*Exo_HH + ones(1,nb_Households) );
	end
	
    y=y1';
	
endfunction

function [Other_SocioBenef] = Other_SocioBenef_Val_3(Other_SocioBenef, NetWage_variation, Other_SocioBenef_param, GDP, CPI, Population, AdjTransf )

	if ClosCarbRev <>"AdjTransf" 
		Other_SocioBenef = BY.Other_SocioBenef;
	else
		Other_SocioBenef = BY.Other_SocioBenef.* (AdjRecycle.*ones(1,nb_Households).*Exo_HH + ones(1,nb_Households) );
	end
	
endfunction

//// Opt 4 = function of CPI
function [y] = Other_SocioBenef_Const_4(Other_SocioBenef, NetWage_variation, Other_SocioBenef_param, GDP, CPI, Population, AdjTransf) ;

	if ClosCarbRev <>"AdjTransf" 
		y1 = Other_SocioBenef - CPI .* Other_SocioBenef_param ;
	else
		y1 = Other_SocioBenef - CPI .* Other_SocioBenef_param.* (AdjRecycle.*ones(1,nb_Households).*Exo_HH + ones(1,nb_Households) ) ;
	end
	
    y=y1';
	
endfunction

function [Other_SocioBenef] = Other_SocioBenef_Val_4(NetWage_variation, Other_SocioBenef_param, GDP, CPI, Population, AdjTransf ) ;

	if ClosCarbRev <>"AdjTransf" 
		Other_SocioBenef = CPI .* Other_SocioBenef_param ;
	else
		Other_SocioBenef = CPI .* Other_SocioBenef_param.* (AdjRecycle.*ones(1,nb_Households).*Exo_HH + ones(1,nb_Households) ) ;
	end

endfunction

// Climate policy
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

/// Scope of the carbon price (exemptions, differentiated rates, etc.)

/// Carbon tax on productive sectors (intermediate energy consumptions)

function y = CTax_rate_IC_Const_1(Carbon_Tax_rate_IC, Carbon_Tax_rate, CarbonTax_Diff_IC) ;

    // Matrix of carbon tax rates (intermediates consumption of energy, sectors)
    // Unique carbon tax
    y1 = Carbon_Tax_rate_IC - Carbon_Tax_rate * CarbonTax_Diff_IC ;

    y = matrix(y1, -1 , 1) ;
endfunction

function Carbon_Tax_rate_IC = CTax_rate_IC_Val_1(Carbon_Tax_rate, CarbonTax_Diff_IC)

    // Matrix of carbon tax rates (intermediates consumption of energy, sectors)
    // Unique carbon tax
    Carbon_Tax_rate_IC = Carbon_Tax_rate * CarbonTax_Diff_IC;

endfunction

// Carbon cap
function y = CTax_rate_IC_Const_2(Carbon_Tax_rate, Carbon_Tax_rate_IC, CarbonTax_Diff_IC, CO2Emis_IC)
	CarbonTax_Diff_IC = abs(CarbonTax_Diff_IC);	
	y1 = CarbonTax_Diff_IC - (( CO2Emis_IC==0).*0 + (CO2Emis_IC<>0) .* Carbon_Tax_rate_IC./Carbon_Tax_rate )   ;
    y = matrix(y1, -1 , 1) ;

endfunction

// Carbon cap
function CarbonTax_Diff_IC = CTax_rate_IC_Val_2(Carbon_Tax_rate, Carbon_Tax_rate_IC, CO2Emis_IC)
	
	Carbon_Tax_rate_IC = abs(Carbon_Tax_rate_IC);
	CarbonTax_Diff_IC = (CO2Emis_IC==0).*0;
	CarbonTax_Diff_IC = CarbonTax_Diff_IC + (CO2Emis_IC<>0) .* Carbon_Tax_rate_IC./Carbon_Tax_rate

endfunction

/// Carbon tax on households (final energy consumptions)

function [y] = CTax_rate_C_Const_1(Carbon_Tax_rate_C, Carbon_Tax_rate, CarbonTax_Diff_C) ;

    // Matrix of carbon tax rates (final consumption of energy, household classes)
    // Unique carbon tax
    y1 = Carbon_Tax_rate_C - Carbon_Tax_rate * CarbonTax_Diff_C ;
    y = matrix(y1, -1 , 1) ;
	
endfunction

function Carbon_Tax_rate_C = CTax_rate_C_Val_1(Carbon_Tax_rate, CarbonTax_Diff_C)
	CarbonTax_Diff_C = abs(CarbonTax_Diff_C); 
    // Matrix of carbon tax rates (final consumption of energy, household classes)
    // Unique carbon tax
    Carbon_Tax_rate_C = Carbon_Tax_rate * CarbonTax_Diff_C;

endfunction

function [y] =  CTax_rate_C_Const_2(Carbon_Tax_rate_C, Carbon_Tax_rate, CarbonTax_Diff_C, Adj_Tax_C) ;

    // Matrix of carbon tax rates (final consumption of energy, household classes)
	CarbonTax_Diff_C= repmat(Adj_Tax_C,nb_Sectors,1);	
    y1 = Carbon_Tax_rate_C - Carbon_Tax_rate * CarbonTax_Diff_C ;
    y = matrix(y1, -1 , 1) ;
	
endfunction

/// Border tax adjustment for imports
function y = CTax_rate_M_Const_1(Carbon_Tax_rate_M, Carbon_Tax_rate, CarbonTax_Diff_M)

    // Matrix of carbon tax rates (final consumption of energy, household classes)
    // Unique carbon tax
    y1 = Carbon_Tax_rate_M - Carbon_Tax_rate * CarbonTax_Diff_M;
	
	if ~Carbon_BTA
		y1 = Carbon_Tax_rate_M  - zeros (1 , nb_Sectors);
	end
	
	y = y1';
	

endfunction

function Carbon_Tax_rate_M = CTax_rate_M_Val_1(Carbon_Tax_rate, CarbonTax_Diff_M)

    // Matrix of carbon tax rates (final consumption of energy, household classes)
    // Unique carbon tax
    Carbon_Tax_rate_M = Carbon_Tax_rate * CarbonTax_Diff_M;
	
	if ~Carbon_BTA
	Carbon_Tax_rate_M = zeros ( 1 , nb_Sectors);
	end

endfunction



/////////////////////
/// CLIMATE POLICIES COMPENSATION
/////////////////////


/// Transfers and compensation according to Dashboard selection

function [delta_LS_S, delta_LS_H, delta_LS_I, delta_LS_LT] = Recycling_Option_Val_1(Carbon_Tax_IC, Carbon_Tax_C, Carbon_Tax_M); 

Tax_Base_Carbon = sum(Carbon_Tax_C) + sum(Carbon_Tax_IC) + sum(Carbon_Tax_M);
// Carbon_Tax_C_withTVA = Carbon_Tax_C.*(1+ones(1,nb_Households).*.VA_Tax_rate') / /put VA_Tax_rate everywhere + add it in Ctot (also in recycling rvenus equations)
// Tax_Base_LS_HH = Carbon_Tax_C_withTVA;

/// WARNING : all recycling options that involve delta_LS_I can only work with a Invest_demand_Val_3
	
	if Recycling_Option=="PublicDeficit"|Recycling_Option==""
		delta_LS_S = zeros(1,nb_Sectors);
		delta_LS_H = zeros(1,nb_Households);
		delta_LS_I = 0;
		delta_LS_LT = 0;
		
	elseif Recycling_Option=="LabTax"
		// No transfers for HH and Sect, only labour cut
		delta_LS_S = zeros(1,nb_Sectors);
		delta_LS_H = zeros(1,nb_Households);
		delta_LS_I = 0;
		delta_LS_LT = 1;

	elseif Recycling_Option=="LumpSumHH"
		// All carbon tax revenues return to HH  with identical amount per Consumption units
		// Check if all carbon tax revenues or just the one from HH -> If  only HH  + ConstNetLend ==  Labour_Tax_LumpSum + ConstNetLend 
		delta_LS_S = zeros(1,nb_Sectors);
		delta_LS_H = divide(Consumption_Units.*Nb_Households,sum(Consumption_Units.*Nb_Households),1)* Tax_Base_Carbon;
		delta_LS_I = 0;
		delta_LS_LT = 0;
		
	elseif Recycling_Option=="LabTax_LumpSumHH"
	// Carbon tax revenues from HH return to HH  with identical amount per Consumption units, what remains are for labour cut
		delta_LS_S = zeros(1,nb_Sectors);
		delta_LS_H = divide(Consumption_Units.*Nb_Households,sum(Consumption_Units.*Nb_Households),1)* (sum(Carbon_Tax_C));
		delta_LS_I = 0;
		delta_LS_LT = 1 ; 
		
	elseif Recycling_Option=="ExactRestitution"
		// All payments are returned ( in case of BTA, revenues from border goes to public finance
		delta_LS_S = sum(Carbon_Tax_IC,"r")
		delta_LS_H = sum(Carbon_Tax_C,"r");
		delta_LS_I = 0;
		delta_LS_LT = 0;

	elseif Recycling_Option=="GreenInvest" 
	// All carbon tax revenues invested 
		delta_LS_S = zeros(1,nb_Sectors);
		delta_LS_H = zeros(1,nb_Households);
		delta_LS_I = Tax_Base_Carbon ;
		delta_LS_LT = 0;

		
	elseif Recycling_Option=="LabTax_GreenInvest"
	// Carbon tax revenues from HH invested, what remains are used for labour tax cut 
		delta_LS_S = zeros(1,nb_Sectors);
		delta_LS_H = zeros(1,nb_Households);
		delta_LS_I = sum(Carbon_Tax_C) ; 
		delta_LS_LT = 1 ;

	elseif Recycling_Option=="LSBasicNeed" 
		if ~ BasicNeed_HH
		warning("Basic needs in Ktep/UC have to be define first; in your run choices or as parameters")
		end
		//// exemptions money/UC - (Sec,HH) dimension
		BasicNeed_HH_Exemp = BasicNeed_HH.* Carbon_Tax_rate_C.* Emission_Coef_C;
		ExempHH = (Nb_Households*Coef_HH_unitpeople) .* Consumption_Units .*.ones(size(BasicNeed_HH_Exemp,"r"),1).*BasicNeed_HH_Exemp;
		
		delta_LS_S = zeros(1, nb_Sectors);
		delta_LS_H = sum(ExempHH,"r");
		delta_LS_I = 0;
		delta_LS_LT = 1;
		
		elseif Recycling_Option=="LSBasicNeed_Exo" 
		if ~ BasicNeed_HH
		warning("Basic needs in Ktep/UC have to be define first; in your run choices or as parameters")
		end
		//// exemptions money/UC - (Sec,HH) dimension
		BasicNeed_HH_Exemp = BasicNeed_HH.* Carbon_Tax_rate_C.* Emission_Coef_C;
		ExempHH = (Nb_Households*Coef_HH_unitpeople) .* Consumption_Units .*.ones(size(BasicNeed_HH_Exemp,"r"),1).*BasicNeed_HH_Exemp;
		
		delta_LS_S = zeros(1, nb_Sectors);
		delta_LS_H = sum(ExempHH.*(Exo_HH.*.ones(size(ExempHH,"r"),1)),"r");
		delta_LS_I = 0;
		delta_LS_LT = 1;
		
	elseif Recycling_Option=="LabTax_PublicDeficit" // PAS COMPRIS : to delete? Pour l'instant revient au meme que labour tax
		delta_LS_S = zeros(1, nb_Sectors);
		delta_LS_H = zeros(1,nb_Households);
		delta_LS_I = 0;
		delta_LS_LT = 1;
				
	else
		error("Recycling option selected is not defined") 
	end 
endfunction


///////////////
////// LUMP SUM TRANSFERT -Compensation to institutional agents
// PAS POUR CALIBRAGE //


/// Transfert to institutional agents // A REVOIR : Un transfert sur les agents HH devrait être suffisant! Le transfert sur les sociétés se fait dans une autre fonction

function [y] = ClimCompensat_Const_1(ClimPolicyCompens, GDP, delta_LS_H, ClimPolCompensbySect);
    // /// No new direct compensations to institutional agents
	
   y1 = zeros(1,nb_InstitAgents); 
   y1(Indice_RestOfWorld)  = ClimPolicyCompens(Indice_RestOfWorld)  - BY.ClimPolicyCompens(Indice_RestOfWorld);
   y1(Indice_Government)   = ClimPolicyCompens(Indice_Government)   - BY.ClimPolicyCompens(Indice_Government);
   y1(Indice_Corporations) = ClimPolicyCompens(Indice_Corporations) - BY.ClimPolicyCompens(Indice_Corporations);
   y1(Indice_Households)   = ClimPolicyCompens(Indice_Households)   - BY.ClimPolicyCompens(Indice_Households) ;

    y=y1';
endfunction

function ClimPolicyCompens = ClimCompensat_Val_1()
    // /// No new direct compensations to households

    ClimPolicyCompens = BY.ClimPolicyCompens;

endfunction

/// proj: il faut que ça varie comme le PIB pour homothétie
function [y] = ClimCompensat_Const_2(ClimPolicyCompens, GDP, delta_LS_H, ClimPolCompensbySect) ;

    // No compensations ( H_ClimatePolicy_Compens(nb_Households)=0 )
    // y1 = ClimPolicyCompens - (GDP/BY.GDP) * BY.ClimPolicyCompens ;
	y1 = zeros(1,nb_InstitAgents); 
	y1(Indice_RestOfWorld)  = ClimPolicyCompens(Indice_RestOfWorld)  - (GDP/BY.GDP) * BY.ClimPolicyCompens(Indice_RestOfWorld);
	y1(Indice_Government)   = ClimPolicyCompens(Indice_Government)   - (GDP/BY.GDP) * BY.ClimPolicyCompens(Indice_Government);
    y1(Indice_Corporations) = ClimPolicyCompens(Indice_Corporations) - (GDP/BY.GDP) * BY.ClimPolicyCompens(Indice_Corporations);
    y1(Indice_Households)   = ClimPolicyCompens(Indice_Households)   - (GDP/BY.GDP) * BY.ClimPolicyCompens(Indice_Households) ;
	
    y=y1';
endfunction

function [ClimPolicyCompens] = ClimCompensat_Val_2(GDP, delta_LS_H, ClimPolCompensbySect) ;

    // No compensations ( H_ClimatePolicy_Compens(nb_Households)=0 )
    // y1 = ClimPolicyCompens - (GDP/BY.GDP) * BY.ClimPolicyCompens ;
	
	ClimPolicyCompens = zeros(1,nb_InstitAgents); 
	ClimPolicyCompens(Indice_RestOfWorld)  = (GDP/BY.GDP) * BY.ClimPolicyCompens(Indice_RestOfWorld);
	ClimPolicyCompens(Indice_Government)   = (GDP/BY.GDP) * BY.ClimPolicyCompens(Indice_Government);
    ClimPolicyCompens(Indice_Corporations) = (GDP/BY.GDP) * BY.ClimPolicyCompens(Indice_Corporations);
    ClimPolicyCompens(Indice_Households)   = (GDP/BY.GDP) * BY.ClimPolicyCompens(Indice_Households) ;
	
	ClimPolicyCompens = matrix(ClimPolicyCompens,1,-1);

endfunction


function [y] = ClimCompensat_Const_3(ClimPolicyCompens, GDP, delta_LS_H, ClimPolCompensbySect);

// /// Compensations to institutional agents consistent with the LUMP SUM options selected in dashboard	
    y1 = zeros(1,nb_InstitAgents);
    y1(Indice_RestOfWorld)  = ClimPolicyCompens(Indice_RestOfWorld)  - BY.ClimPolicyCompens(Indice_RestOfWorld);
	y1(Indice_Corporations) = ClimPolicyCompens(Indice_Corporations) - sum(ClimPolCompensbySect); 
    y1(Indice_Households)   = ClimPolicyCompens(Indice_Households) - delta_LS_H;
	
	y1(Indice_Government) = ClimPolicyCompens(Indice_Government) + (sum(y1(Indice_Households))+y1(Indice_Corporations));

    y=y1';

endfunction

function ClimPolicyCompens = ClimCompensat_Val_3(GDP, delta_LS_H, ClimPolCompensbySect)

// /// Compensations to institutional agents consistent with the LUMP SUM options selected in dashboard
    ClimPolicyCompens = zeros(1,nb_InstitAgents);
    ClimPolicyCompens(Indice_RestOfWorld) = BY.ClimPolicyCompens(Indice_RestOfWorld);
	ClimPolicyCompens(Indice_Corporations) = sum(ClimPolCompensbySect);
    ClimPolicyCompens(Indice_Households) = delta_LS_H;
	ClimPolicyCompens(Indice_Government) = - (sum(ClimPolicyCompens(Indice_Households))+ClimPolicyCompens(Indice_Corporations));

    ClimPolicyCompens = matrix(ClimPolicyCompens,1,-1);

endfunction


/// Transfert to productive sectors 

function [y] = S_ClimCompensat_Const_1(ClimPolCompensbySect,GDP, delta_LS_S)  ;
    /// No new direct compensations to sectors
    y1 = ClimPolCompensbySect - BY.ClimPolCompensbySect ;
    y=y1';
	
endfunction


function ClimPolCompensbySect = S_ClimCompensat_Val_1()
    
    /// No new direct compensations to sectors
    ClimPolCompensbySect = BY.ClimPolCompensbySect;

endfunction

/// proj: il faut que ça varie comme le PIB pour homothétie
function [y] = S_ClimCompensat_Const_2(ClimPolCompensbySect,GDP, delta_LS_S)  ;

    y1 = ClimPolCompensbySect - (GDP/BY.GDP) * BY.ClimPolCompensbySect ;
    y=y1';
	
endfunction


function [ClimPolCompensbySect] = S_ClimCompensat_Val_2(GDP, delta_LS_S)  ;

    ClimPolCompensbySect = (GDP/BY.GDP) * BY.ClimPolCompensbySect ;

endfunction

function [y] = S_ClimCompensat_Const_3(ClimPolCompensbySect,GDP, delta_LS_S) ;

    y1 = ClimPolCompensbySect - delta_LS_S ;
    y=y1';
	
endfunction


function ClimPolCompensbySect = S_ClimCompensat_Val_3(GDP, delta_LS_S)

    ClimPolCompensbySect = delta_LS_S;

endfunction


//////////////////
/// CARBON REVENUE RECYCLING OPTIONS (use of the carbon tax revenue after direct compensations)
// Used for calibration
// No recycling revenues in labour tax /// 
function [y] = RevenueRecycling_Const_1(Labour_Tax, Labour_Tax_rate, Labour_Tax_Cut, w, lambda, Y, delta_LS_LT, Carbon_Tax_IC, Carbon_Tax_C, ClimPolCompensbySect, ClimPolicyCompens, NetLending, GFCF_byAgent, Government_savings, GDP, Carbon_Tax_M)  ;

    // The constraint is used for the calculation of the tax rebate (Labour_Tax_Cut, cf. Labour_Tax_constraint above).
    // Same rebate for all sectors.
    y1 = Labour_Tax_Cut - 0 ;

    y=y1';
endfunction

function Labour_Tax_Cut = RevenueRecycling_Val_1()

    // The constraint is used for the calculation of the tax rebate (Labour_Tax_Cut, cf. Labour_Tax_constraint above).
    // Same rebate for all sectors.
    Labour_Tax_Cut = 0;
    
endfunction


function [y] = RevenueRecycling_Const_2(Labour_Tax, Labour_Tax_rate, Labour_Tax_Cut, w, lambda, Y, delta_LS_LT, Carbon_Tax_IC, Carbon_Tax_C, ClimPolCompensbySect, ClimPolicyCompens, NetLending, GFCF_byAgent, Government_savings, GDP, Carbon_Tax_M) ;
		
	 if ClosCarbRev=="AllLabTax"
	//All tax base after climate compensation ( for HH or sectors) for labour tax reduction
		y1 = sum(Labour_Tax) - (..
			sum((Labour_Tax_rate + Labour_Tax_Cut * ones(1, nb_Sectors)).* w .* lambda .* Y') - ..
			delta_LS_LT*(sum(Carbon_Tax_IC) + sum(Carbon_Tax_C)+ sum(Carbon_Tax_M) + ClimPolicyCompens(Indice_Government) -delta_LS_I)..
					) ;
		y1(1, 1+$ ) = AdjRecycle - BY.AdjRecycle;

	elseif ClosCarbRev=="CstNetLend"
		if Recycling_Option=="PublicDeficit"|Recycling_Option==""
			 y1 = Labour_Tax_Cut - 0 ;
			 y1(1, 1+$ ) = AdjRecycle - BY.AdjRecycle;
		else 
			//Part of remaining revenues from carbon tax for labour tax reduction under Public deficit constant 
			y1 = NetLending(Indice_Government) - BY.NetLending(Indice_Government)*(GDP/BY.GDP) ;
			y1(1, 1+$ ) = AdjRecycle - BY.AdjRecycle;
		end
		
	elseif ClosCarbRev=="AdjTransf"
		if Recycling_Option=="PublicDeficit"|Recycling_Option==""
			 y1 = Labour_Tax_Cut - 0 ;
			 y1(1, 1+$ ) = AdjRecycle - BY.AdjRecycle;
		else 
			//All tax base after climate compensation ( for HH or sectors) for labour tax reduction
			y1 = sum(Labour_Tax) - (..
				sum((Labour_Tax_rate + Labour_Tax_Cut * ones(1, nb_Sectors)).* w .* lambda .* Y') - ..
				delta_LS_LT*(sum(Carbon_Tax_IC) + sum(Carbon_Tax_C)+ sum(Carbon_Tax_M) + ClimPolicyCompens(Indice_Government) -delta_LS_I)..
						) ;
			// Public deficit constant		
			y1(1, 1+$ ) = NetLending(Indice_Government) - BY.NetLending(Indice_Government)*(GDP/BY.GDP) ;
			// => AdjRecycle variable (scalar)  to adjust other social transfers
		end
	end 

    y=y1';
endfunction


// Ex-post labour tax rate
function [y] = Labour_Taxe_rate_Const_1(LabTaxRate_BeforeCut, Labour_Tax_rate, Labour_Tax_Cut) ;
    y1 = LabTaxRate_BeforeCut - ( Labour_Tax_rate + Labour_Tax_Cut * ones(1, nb_Sectors) ) ;
    y=y1';
endfunction

function Labour_Tax_rate = Labour_Taxe_rate_Val_1(LabTaxRate_BeforeCut, Labour_Tax_Cut)
    Labour_Tax_rate = LabTaxRate_BeforeCut - Labour_Tax_Cut * ones(1, nb_Sectors);
endfunction

// Government savings and consumption budgets
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

/// Government_savings_constraint_1 : Proportion of disposable income (saving rate)

function [y] = G_savings_Const_1(Government_savings, G_disposable_income, G_Consumption_budget) ;

    /// Government savings constraint (Government_savings)
    y1 = Government_savings - (G_disposable_income - G_Consumption_budget) ;

    y=y1';
endfunction

function Government_savings = G_savings_Val_1(G_disposable_income, G_Consumption_budget)

    /// Government savings constraint (Government_savings)
    Government_savings = (G_disposable_income - G_Consumption_budget) ;

endfunction


// Government consumption demand
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

	////- Constant real public consumption G
function [y] = G_ConsumpBudget_Const_1(G_Consumption_budget, G, pG, GDP) ;

    /// Use of consumption budget - Consumption expenditures (by consumption item and government class)
    y1 = G_Consumption_budget - sum(G .* pG, "r") ;
	
    y = y1' ;
endfunction

///	proj : utiliser G_ConsumpBudget_Const_2 + G_demand_Const_2
/// Government Total consumption budget 
	////- Constant proportion of GDP
function [y] = G_ConsumpBudget_Const_2(G_Consumption_budget, G, pG, GDP ) ;

    /// Public consumption budget - Proportion of GDP
    y1 = G_Consumption_budget - (GDP/BY.GDP) *  BY.G_Consumption_budget ;
    y = y1' ;
endfunction

function G_Consumption_budget = G_ConsumpBudget_Val_2(GDP)

    /// Public consumption budget - Proportion of GDP
    G_Consumption_budget = (GDP/BY.GDP) *  BY.G_Consumption_budget;
    
endfunction

/// Balance between consumption budgets and expenditures
function [y] = G_BudgetBalance_Const_1(G_Consumption_budget, G, pG) ;

    /// Use of consumption budget - Consumption expenditures (by consumption item and government class)
    y1 = G_Consumption_budget - sum(G .* pG, "r") ;
    y  = y1' ;
endfunction

/// Government_demand_constraint_1  : No direct energy consumption by the government (by convention, energy is an intermediate input in public service production)

	// Constant real public consumption
function [y] = G_demand_Const_1(G, pG, G_Consumption_budget, BudgetShare_GConsump) ;
    y1 = G - BY.G ;	
    y = matrix(y1, -1 , 1) ;	
endfunction

function G = G_demand_Val_1(pG, G_Consumption_budget, BudgetShare_GConsump)
    
    G = BY.G;
    
endfunction


///	proj : utiliser G_ConsumpBudget_Const_2 + G_demand_Const_2
///         The public budget is an exogenous proportion of the GDP
///         The distribution of budget shares for non-energy products is exogenous

function [y] = G_demand_Const_2(G, pG, G_Consumption_budget, BudgetShare_GConsump) ;
    /// Exogenous distribution of budget shares among consumption items
    y1 = pG .* G - BudgetShare_GConsump .* (ones( nb_Commodities, 1).*.G_Consumption_budget);
    y = matrix(y1, -1 , 1) ;
endfunction

function G = G_demand_Val_2(pG, G_Consumption_budget, BudgetShare_GConsump)
    /// Exogenous distribution of budget shares among consumption items
    
    value_G = BudgetShare_GConsump .* (ones( nb_Commodities, 1).*.G_Consumption_budget);
    
    G = (pG <> 0) .* divide(value_G, pG, 1);
	
	
	if is_projected('G') then
        G = apply_proj_val(G, 'G');
    end
    
endfunction

// Government gross fixed capital formation
// A proportion of disposable income is used directly by Government to accumulate capital stocks (public infrastructures, public buildings, etc.)
// The Government gross fixed capital formation differs from Government savings (if higher, they lend money in financial markets; if lower, they borrow in financial markets)
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////


/// Government_investment_constraint_1 : Proportion of disposable income ('propensity' to invest)

function [y] = G_investment_Const_1(GFCF_byAgent, G_disposable_income, G_invest_propensity, GDP) ;

    // Government gross fixed capital formation constraint (GFCF_byAgent(Indice_Government))
    y1 = GFCF_byAgent(Indice_Government) - (G_disposable_income .* G_invest_propensity) ;

    y  = y1' ;
endfunction


/// Government_investment_constraint_2 : Proportion of GDP
function [y] = G_investment_Const_2(GFCF_byAgent, G_disposable_income, G_invest_propensity, GDP) ;
    // Government gross fixed capital formation constraint (GFCF_byAgent(Indice_Government))
    y1 = GFCF_byAgent(Indice_Government) - ini.GFCF_byAgent(Indice_Government)*(GDP/ini.GDP) ;
    y  = y1' ;
endfunction


// Government net lending (+) / net borrowing (-)
// Difference between disposable income and expenditures (consumption and gross fixed capital formation)
// The current account is balanced (if = 0) / imbalanced (if <> 0); current account surplus if >0 / current account deficit if <0
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////


// PAS POUR CALIBRAGE //
/// Government_NetLending_constraint_1

function y = G_NetLending_Const_1(NetLending, GFCF_byAgent, Government_savings);
    /// Government net lending constraint (NetLending(Indice_Government))
    y1 = NetLending(Indice_Government) - (Government_savings - GFCF_byAgent(Indice_Government)) ;
    
	y  = y1' ;
endfunction


// Government net financial position: stock of debt (+) / liabilities (-)
// Counter-part of past accumulated net lending / net borrowing
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

// PAS POUR CALIBRAGE //
/// Government_NetDebt_constraint_1 : linear deviation from a reference level (NetFinancialDebt_ref(Indice_Government))
/// The Debt deviation is proportional to the deviation of net lending/borrowing from its reference level (NetLending_ref(Indice_Government))

function y = G_NetDebt_Const_1(NetFinancialDebt, time_since_ini, NetLending);

    /// Government net lending constraint (NetLending(Indice_Government))
    y1 = NetFinancialDebt(Indice_Government) - (ini.NetFinancialDebt(Indice_Government) + (time_since_ini / 2) * (ini.NetLending(Indice_Government) - NetLending(Indice_Government)));
	
	y  = y1' ;
endfunction

function y = G_NetDebt_Const_2(NetFinancialDebt, time_since_ini, NetLending);

    /// Government net lending constraint (NetLending(Indice_Government))
    y1 = NetFinancialDebt(Indice_Government) - BY.NetFinancialDebt(Indice_Government);
	
	y  = y1' ;
endfunction

// Public finance "closure"
// Set of variables and exogenous constraints that balances the government account
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

// Additional constraints on public finances

/// No additional constraint on public finance
/// Equivalently, an additional variable is equal to zero: Government_closure

function [y] = Public_finance_Const_1(Government_closure) ;

    // Default closure: The public account adjusts with the level of public deficits (NetLending(Indice_Government)). The level of public debt evolves as well.
    y1 = Government_closure - zeros(1,nb_Government) ;

    y=y1';
endfunction

function Government_closure = Public_finance_Val_1()

    // Default closure: The public account adjusts with the level of public deficits (NetLending(Indice_Government)). The level of public debt evolves as well.
    Government_closure = zeros(1,nb_Government) ;

endfunction

// PAS POUR CALIBRAGE //
// Fixed and adjustment variable of the public account

// Default closure
// Closure 1 : 14 exogenous (fixed) variables: Exogenous tax rates and expenditures rules (government consumption and investment)
//    One adjustment variable: public deficit/surplus (NetLending(Indice_Government)). Public debt evolves consequently (NetFinancialDebt(Indice_Government))

function [y] = G_closure_Const_1(Income_Tax_rate, Other_Direct_Tax_param, Pension_Benefits_param, UnemployBenefits_param, Other_SocioBenef_param, Corporate_Tax_rate, Production_Tax_rate, LabTaxRate_BeforeCut, BudgetShare_GConsump, Energy_Tax_rate_IC, Energy_Tax_rate_FC, Carbon_Tax_rate, G_Consumption_budget, G_invest_propensity) ;

    // 14 Exogenous variables :
    //  Income_Tax_rate, Other_Direct_Tax_param, Pension_Benefits_param, UnemployBenefits_param, Other_SocioBenef_param,
    //  Corporate_Tax_rate, Production_Tax_rate, LabTaxRate_BeforeCut, BudgetShare_GConsump, Energy_Tax_rate_IC
    //  Energy_Tax_rate_FC, Carbon_Tax_rate, G_Consumption_budget, G_invest_propensity

    dimension = length(Income_Tax_rate)+length(Other_Direct_Tax)+length(Pension_Benefits)+length(UnemployBenefits)+length(Other_SocioBenef)+length(Production_Tax)+length(Labour_Tax_rate)+length(Corporate_Tax_rate)+length(BudgetShare_GConsump)+length(Energy_Tax_rate_IC)+length(Energy_Tax_rate_FC)+length(Carbon_Tax_rate)+length(G_Consumption_budget)+length(G_invest_propensity) ;

    y = zeros(dimension , 1);

    // Parameters = values of fixed variables
    i = 0;
    y(i + 1 : i + length(Income_Tax_rate) )  = matrix(Income_Tax_rate - BY.Income_Tax_rate, length(Income_Tax_rate), 1) ;
    i = i + length(Income_Tax_rate);

    y(i + 1 : i + length(Other_Direct_Tax) ) = matrix(Other_Direct_Tax_param - BY.Other_Direct_Tax, length(Other_Direct_Tax), 1) ;
    i = i + length(Other_Direct_Tax);

    y(i + 1 : i + length(Pension_Benefits) ) = matrix(Pension_Benefits_param - BY.Pension_Benefits, length(Pension_Benefits), 1) ;
    i = i + length(Pension_Benefits);

    y(i + 1 : i + length(UnemployBenefits) ) = matrix(UnemployBenefits_param - BY.UnemployBenefits, length(UnemployBenefits), 1) ;
    i = i + length(UnemployBenefits);

    y(i + 1 : i + length(Other_SocioBenef) ) = matrix(Other_SocioBenef_param - BY.Other_SocioBenef, length(Other_SocioBenef), 1) ;
    i = i + length(Other_SocioBenef);

    y(i + 1 : i + length(Corporate_Tax_rate) ) = matrix(Corporate_Tax_rate - BY.Corporate_Tax_rate, length(Corporate_Tax_rate), 1) ;
    i = i + length(Corporate_Tax_rate);

    y(i + 1 : i + length(Production_Tax_rate) ) = matrix(Production_Tax_rate - BY.Production_Tax_rate, length(Production_Tax_rate), 1) ;
    i = i + length(Production_Tax_rate);

    y(i + 1 : i + length(LabTaxRate_BeforeCut) )= matrix(LabTaxRate_BeforeCut - BY.LabTaxRate_BeforeCut, length(LabTaxRate_BeforeCut), 1) ;
    i = i + length(LabTaxRate_BeforeCut);

    y(i + 1 : i + length(BudgetShare_GConsump) )= matrix(BudgetShare_GConsump - BY.BudgetShare_GConsump, length(BudgetShare_GConsump), 1) ;
    i = i + length(BudgetShare_GConsump);

    y(i + 1 : i + length(Energy_Tax_rate_IC) ) = matrix(Energy_Tax_rate_IC - BY.Energy_Tax_rate_IC, length(Energy_Tax_rate_IC), 1) ;
    i = i + length(Energy_Tax_rate_IC);

    y(i + 1 : i + length(Energy_Tax_rate_FC) ) = matrix(Energy_Tax_rate_FC - BY.Energy_Tax_rate_FC, length(Energy_Tax_rate_FC), 1) ;
    i = i + length(Energy_Tax_rate_FC);

    y(i + 1 : i + length(Carbon_Tax_rate) )  = matrix(Carbon_Tax_rate - BY.Carbon_Tax_rate, length(Carbon_Tax_rate), 1) ;
    i = i + length(Carbon_Tax_rate);

    y(i + 1 : i + length(G_Consumption_budget) )= matrix(G_Consumption_budget - BY.G_Consumption_budget, length(G_Consumption_budget), 1) ;
    i = i + length(G_Consumption_budget);

    y(i + 1 : i + length(G_invest_propensity) ) = matrix(G_invest_propensity - BY.G_invest_propensity, length(G_invest_propensity), 1) ;
    i = i + length(G_invest_propensity);

endfunction


/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
///////   B.4 Rest-of-the-world
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

/// The rest-of-world has no explicit 'active' behaviour in the default model ("small country hypothesis")
/// Implicit behavioural assumptions are embedded in trade equations (exports X and imports M), and the closure of financial (NetLending of the rest-of-the-world) - current account balance

/// Voir s'il faut calculer : Financial transfers from/to the Rest-of-the-world


/// Financial transfers from/to Rest of World
function [y] = RoW_PropTranf_Const_1(Property_income, interest_rate, NetFinancialDebt) ;

    y1 = Property_income(Indice_RestOfWorld) + interest_rate(Indice_RestOfWorld) .* NetFinancialDebt(Indice_RestOfWorld) ;

    y=y1';
endfunction

/// Financial transfers from/to Rest of World (Balance of transfers)
function [y] = RoW_PropTranf_Const_2(Property_income) ;

    y1 = Property_income(Indice_RestOfWorld) + ( Property_income(Indice_Corporations) + sum(Property_income(Indice_Households)) + Property_income(Indice_Government) ) ;

    y=y1';
endfunction

//   /// Direct investment from abroad
// function [y] = RoW_investment_Const_1(GFCF_byAgent) ;
//
//  // Government gross fixed capital formation constraint (GFCF_byAgent(Indice_Government))
//  y1 = GFCF_byAgent(Indice_RestOfWorld) - zeros(size(GFCF_byAgent(Indice_RestOfWorld),1),size(GFCF_byAgent(Indice_RestOfWorld),2)) ;
//
//     y=y1';
// endfunction

/// RestOfTheWorld_NetLending_constraint_1
function y = RoW_NetLending_Const_1(NetLending, pM, M, pX, X, Property_income, Other_Transfers)

    /// Government net lending constraint (NetLending(Indice_Government))
    y1 = NetLending(Indice_RestOfWorld) - ( sum(pM .* M) - sum(pX .* X) + Property_income(Indice_RestOfWorld) + Other_Transfers(Indice_RestOfWorld) )
	// y1 = NetLending(Indice_RestOfWorld) - ( sum(pM .* M) - sum(pX .* X) - sum(Property_income(Indice_DomesticAgents)) - sum(Other_Transfers(Indice_DomesticAgents)) ) 	;

    y=y1';
endfunction


/// RestOfTheWorld_NetDebt_constraint_1 : linear deviation from a reference level (NetFinancialDebt_ref(Indice_RestOfWorld))
/// The Debt deviation is proportional to the deviation of net lending/borrowing from its reference level (NetLending_ref(Indice_RestOfWorld))
function y = RoW_NetDebt_Const_1(NetFinancialDebt, time_since_ini, NetLending) ;

    /// Government net lending constraint (NetLending(Indice_Government))
    y1 = NetFinancialDebt(Indice_RestOfWorld) - (ini.NetFinancialDebt(Indice_RestOfWorld) + (time_since_ini / 2) * (ini.NetLending(Indice_RestOfWorld) - NetLending(Indice_RestOfWorld)));

	y=y1';
endfunction

function y = RoW_NetDebt_Const_2(NetFinancialDebt, time_since_ini, NetLending) ;

    /// Government net lending constraint (NetLending(Indice_Government))
    y1 = NetFinancialDebt(Indice_RestOfWorld) - BY.NetFinancialDebt(Indice_RestOfWorld);

	y=y1';
endfunction


/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// C)  Trade-offs in productive systems
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////


/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
///////   C.1  Technical change in production
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////


/// General technical progress

function y =  TechnicProgress_Const_1(Phi, Capital_consumption, sigma_Phi)
    y1 = Phi - ones(1, nb_Sectors);
    y=y1';
	
endfunction

function Phi =  TechnicProgress_Val_1()
    
    Phi = ones(1, nb_Sectors);

endfunction

function Phi =  TechnicProgress_Val_2(Capital_consumption, sigma_Phi)
    
    Phi = ones(1, nb_Sectors);
    Phi(nb_Sectors) = (Capital_consumption(nb_Sectors)/BY.Capital_consumption(nb_Sectors))^sigma_Phi(nb_Sectors)

endfunction

function y =  TechnicProgress_Const_2(Capital_consumption, sigma_Phi)

    y1 = (Phi.^(1 ./sigma_Phi)).*BY.Capital_consumption - Capital_consumption;
    y=y1';
	
endfunction

function y =  TechnicProgress_Const_3(Phi, Capital_consumption, sigma_Phi)
	
    y1 = Phi - Coef_Phi_Sec*ones(1, nb_Sectors);
    y=y1';
	
endfunction



/// General decreasing return
function [y] =  DecreasingReturn_Const_2(Theta, Y, sigma_Theta) ;

    y1 =(Theta.^ (1 ./sigma_Theta)).*BY.Y' - Y' ;
    y=y1';
	
endfunction

/// General decreasing return
function [y] =  DecreasingReturn_Const_1(Theta, Y, sigma_Theta) ;

    y1 = Theta -  ones(1, nb_Sectors);
    y=y1';
	
endfunction

function Theta =  DecreasingReturn_Val_1()

    Theta =  ones(1, nb_Sectors);

endfunction

function Theta =  DecreasingReturn_Val_2(Y, sigma_Theta)

    Theta =  ones(1, nb_Sectors);
    Theta(nb_Sectors) = (Y(nb_Sectors)/BY.Y(nb_Sectors))^sigma_Theta(nb_Sectors)

endfunction


/// Technical substitution



///	proj & homothétie: utiliser DecreasingReturn_Const_1 + TechnicProgress_Const_1  ( soit =1)
///		Gain de productivité sur le travail lambda = 1/(1+Mhu)^t * equation actuelle 
///		Prix pL remplacé par pL / (1+Mhu)^t dans les équations d'arbitrage : le salaire récupère les gains de productivité, ce qui ne change pas les arbitrages techniques dans la production
///		le calcul de la productivité du travail Labour_Product = (1+Mhu)^t est fait dans Homothetic_projection.sce

function [alpha, lambda, kappa] = Technical_Coef_Val_1(Theta, Phi, aIC, sigma, pIC, aL, pL, aK, pK, pRental, phi_IC, phi_K, phi_L, ConstrainedShare_IC, ConstrainedShare_Labour, ConstrainedShare_Capital, Y)
    test_pL = pL == 0;
    pIC = abs(pIC);
    pL = abs(pL);
    pL(test_pL) = 1;
	if ~Capital_Dynamics
		pK = abs(pK);
		FPI = sum((aIC .^ (sigma.*.ones(nb_Sectors,1))) .* (pIC.^(1 - sigma.*.ones(nb_Sectors,1))),"r") + ..
			(aL .^ sigma) .* ((pL ./ ((1+phi_L).^time_since_BY)) .^(1 - sigma)) + ..
			(aK .^ sigma) .* (pK.^(1 - sigma)) ;
	
	elseif Capital_Dynamics
		pRental = abs(pRental);
		FPI = sum((aIC .^ (sigma.*.ones(nb_Sectors,1))) .* (pIC.^(1 - sigma.*.ones(nb_Sectors,1))),"r") + ..
			(aL .^ sigma) .* ((pL ./ ((1+phi_L).^time_since_BY)) .^(1 - sigma)) + ..
			(aK .^ sigma) .* ((pRental).^(1 - sigma)) ;
	end

    test_FPI = FPI == 0;
    FPI(test_pL|test_FPI) = 1;
    
    alpha = (ones(nb_Sectors, 1).*.(Theta ./ Phi)) .* (ones(nb_Sectors,nb_Sectors)./(1+phi_IC).^time_since_BY).* ..
    (ConstrainedShare_IC .* BY.alpha + ((aIC ./ pIC) .^ (sigma.*.ones(nb_Sectors,1))) .* ..
    (ones(nb_Sectors, 1).*.(FPI.^(sigma./(1 - sigma))))) ;

    lambda = (Theta ./ Phi) .*(ones(1,nb_Sectors)./(1+phi_L).^time_since_BY) .* ..
    ( ConstrainedShare_Labour .* BY.lambda + ((aL ./ (pL ./ ((1+phi_L).^time_since_BY)) ) .^ sigma) .* ..
    (FPI .^(sigma./(1 - sigma)))) ;

	if ~Capital_Dynamics
			
		kappa = (Theta ./ Phi) .*(ones(1,nb_Sectors)./(1+phi_K).^time_since_BY) .* ..
				( ConstrainedShare_Capital .* BY.kappa + ((aK ./ pK) .^ sigma) .* ..
				(FPI .^(sigma./(1 - sigma)))) ;
		
		
		/// Adjustement of kappa for non energy sectors according to the evolution of the energy intensity 
		if AdjustKappaOnly|AdjustKappaWithSubst
			
			AdjustKappa = divide(sum(Proj_Vol.IC.val(Indice_EnerSect,Indice_NonEnerSect),"r")./Y_obj.val(Indice_NonEnerSect)',sum(BY.IC(Indice_EnerSect,Indice_NonEnerSect),"r")./BY.Y(Indice_NonEnerSect)',1);
			sigmaKE = -ones(Indice_NonEnerSect).*0.15;
				 
			if AdjustKappaOnly
			
					kappa(Indice_NonEnerSect)= BY.kappa(Indice_NonEnerSect).*AdjustKappa.^sigmaKE; 
					
			elseif AdjustKappaWithSubst
				
					kappa(Indice_NonEnerSect)= kappa(Indice_NonEnerSect).*AdjustKappa.^sigmaKE;
			end 
	
		end 
		
	elseif Capital_Dynamics
	// Unique price of capital
	    kappa = (Theta ./ Phi) .*(ones(1,nb_Sectors)./(1+phi_K).^time_since_BY) .* ..
				( ConstrainedShare_Capital .* BY.kappa + ((aK ./ (pRental)) .^ sigma) .* ..
				(FPI .^(sigma./(1 - sigma)))) ;

	end

    
    // Proj structure for parameters
	Proj_param = struct();

	//// Projection Volume
    if is_projected('Labour') then
        Proj_param.lambda.val = Proj_Vol.Labour.val ./ Y';
        Proj_param.lambda.ind_of_proj = Proj_Vol.Labour.ind_of_proj;
        lambda = apply_proj_val(lambda, 'lambda', Proj_param);
    end
	
    if is_projected('Capital_consumption') then
        Proj_param.kappa.val = Proj_Vol.Capital_consumption.val ./ Y';
        Proj_param.kappa.ind_of_proj = Proj_Vol.Capital_consumption.ind_of_proj;
        kappa = apply_proj_val(kappa, 'kappa', Proj_param)
    end
	
    if is_projected('IC') then
        Proj_param.alpha.val = Proj_Vol.IC.val ./ (ones(nb_Sectors,1) * Y');
        Proj_param.alpha.ind_of_proj = Proj_Vol.IC.ind_of_proj;
        alpha = apply_proj_val(alpha, 'alpha', Proj_param);
    end
		
	//// Projection Intensities
	if is_projected('alpha') then
        alpha = apply_proj_val(alpha, 'alpha');
    end

    if is_projected('lambda') then
        lambda = apply_proj_val(lambda, 'lambda');
    end

    if is_projected('kappa') then
        kappa = apply_proj_val(kappa, 'kappa');
    end

endfunction


//	Fixed technical coefficients
function [alpha, lambda, kappa] = Technical_Coef_Val_2( aIC, sigma, pIC, aL, pL, aK, pK, Theta, Phi, ConstrainedShare_IC, ConstrainedShare_Labour, ConstrainedShare_Capital,Labour, Capital_consumption, IC) ;
    alpha 	=  BY.alpha ;
    lambda = BY.lambda ;
    kappa 	= BY.kappa ;
    
    if is_projected('alpha') then
        alpha = apply_proj_val(alpha, 'alpha');
    end

    if is_projected('lambda') then
        lambda = apply_proj_val(lambda, 'lambda');
    end

    if is_projected('kappa') then
        kappa = apply_proj_val(kappa, 'kappa');
    end
    
endfunction

/// function for assessing carbon tax resulting of a carbon cap
function [alpha, lambda, kappa] = Technical_Coef_Val_3(IC, Theta, Phi, aIC, sigma, pIC, aL, pL, aK, pK, phi_IC, phi_K, phi_L, ConstrainedShare_IC, ConstrainedShare_Labour, ConstrainedShare_Capital, Y,Labour, Capital_consumption, IC)
    test_pL = pL == 0;
    pIC = abs(pIC);
    pL = abs(pL);
    pL(test_pL) = 1;
    pK = abs(pK);

    FPI = sum((aIC .^ (sigma.*.ones(nb_Sectors,1))) .* (pIC.^(1 - sigma.*.ones(nb_Sectors,1))),"r") + ..
    (aL .^ sigma) .* ((pL ./ ((1+phi_L).^time_since_BY)) .^(1 - sigma)) + ..
    (aK .^ sigma) .* (pK.^(1 - sigma)) ;

    test_FPI = FPI == 0;
    FPI(test_pL|test_FPI) = 1;
    
    alpha = (CO2Emis_IC == 0).*((ones(nb_Sectors, 1).*.(Theta ./ Phi)) .* (ones(nb_Sectors,nb_Sectors)./(1+phi_IC).^time_since_BY).* ..
    (ConstrainedShare_IC .* BY.alpha + ((aIC ./ pIC) .^ (sigma.*.ones(nb_Sectors,1))) .* ..
    (ones(nb_Sectors, 1).*.(FPI.^(sigma./(1 - sigma))))) );
	alpha = alpha + (CO2Emis_IC <> 0).* divide(IC,ones(nb_Commodities, 1).*.Y',0);
	

    lambda = (Theta ./ Phi) .*(ones(1,nb_Sectors)./(1+phi_L).^time_since_BY) .* ..
    ( ConstrainedShare_Labour .* BY.lambda + ((aL ./ (pL ./ ((1+phi_L).^time_since_BY)) ) .^ sigma) .* ..
    (FPI .^(sigma./(1 - sigma)))) ;

    //lambda(test_pL|test_FPI) = 0;

    kappa = (Theta ./ Phi) .*(ones(1,nb_Sectors)./(1+phi_K).^time_since_BY) .* ..
    ( ConstrainedShare_Capital .* BY.kappa + ((aK ./ pK) .^ sigma) .* ..
    (FPI .^(sigma./(1 - sigma)))) ;


endfunction


//Labour productivity semi-endogenous (power sector)
function [phi_L]=Phi_L_const_1(phi_L_a, phi_L_b, Mu_b, time_period,Indice)
//    A = phi_L_a;

//    B = (phi_L_b==1).*phi_L_b + (phi_L_b<>1).*phi_L_b./pI';
    
//    phi_L= (((A./lambda_ref') + ((1+Mu_b)^(-time_period))*(1-B./pI)).^(-1/time_period) - 1)';
    phi_L= ((phi_L_a./lambda_ref) + ((1+Mu_b).^(-time_period)).*(1-phi_L_b)).^(-1/time_period) - 1;

endfunction

function [y]=Mu_b_const_1(Mu_b, Mu, Y, phi_L_a, phi_L_b, time_period, Indice)
    
    phi_L = Phi_L_const_1(phi_L_a, phi_L_b, Mu_b, time_period, Indice)';
    y = Mu - sum(phi_L.*Y)./sum(Y);
    
endfunction 

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
///////   C.2  Pricing rules
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////


// PAS POUR CALIBRAGE //
// Production Price
function y =  Production_price_Const_1(pY, alpha, pIC, pL, lambda, pK, kappa, markup_rate, Production_Tax_rate, ClimPolCompensbySect, Y)
    pY=abs(pY);
	pIC = abs(pIC);
	pK = abs(pK);
    pL = abs(pL);
	// Mark-up pricing rule ( pY(nb_Sectors) ). The formula enables the use of different types of labour and capital inputs
    y1 = pY' - (sum(pIC .* alpha,"r") + sum(pL .* lambda,"r") + sum(pK .* kappa, "r") - ClimPolCompensbySect./((abs(Y)<%eps)+(abs(Y)>%eps).*Y)' + Production_Tax_rate .* pY' + markup_rate .* pY')  ;

    y=y1';
endfunction

function pY =  Production_price_Val_1(alpha, pIC, pL, lambda, pK, kappa, markup_rate, Production_Tax_rate, ClimPolCompensbySect, Y)
    pY=abs(pY);
	pIC = abs(pIC);
	pK = abs(pK);
    pL = abs(pL);
	// Mark-up pricing rule ( pY(nb_Sectors) ). The formula enables the use of different types of labour and capital inputs
    pY = (sum(pIC .* alpha,"r") + sum(pL .* lambda,"r") + sum(pK .* kappa, "r") - ClimPolCompensbySect./((abs(Y)<%eps)+(abs(Y)>%eps).*Y)' + Production_Tax_rate .* pY' + markup_rate .* pY')' ;

endfunction

// PAS POUR CALIBRAGE //
// Mark-up
function [y] =  Markup_Const_1(markup_rate) ;

    //  Fixed Markup ( markup_rate(nb_Sectors) )
    y1 = markup_rate - BY.markup_rate ;

    y=y1';
endfunction

// PAS POUR CALIBRAGE //
// Transport margins rates
function [y] =  Transp_MargRates_Const_1(Transp_margins_rates, Transp_margins) ;

    y1 = (BY.Transp_margins_rates >= 0) .* (Transp_margins_rates - BY.Transp_margins_rates) + (BY.Transp_margins_rates < 0) .* sum(Transp_margins) ;

    y=y1';
endfunction

function [y] =  Transp_MargRates_Const_2(Transp_margins_rates, Transp_margins, delta_TranspMargins_rate) ;

    y1 = (BY.Transp_margins_rates >= 0).*(Transp_margins_rates - BY.Transp_margins_rates)..
	+(BY.Transp_margins_rates < 0).*(Transp_margins_rates - delta_TranspMargins_rate * BY.Transp_margins_rates) ;
    y1($+1) =  sum(Transp_margins);

    y=y1';
endfunction

// /!\ Décomposition de Transp_MargRates_Const_2 en 2 fonctions !!
function Transp_margins_rates = Transp_MargRates_Val_2(delta_TranspMargins_rate)
    
    Transp_margins_rates = (BY.Transp_margins_rates >= 0) .* BY.Transp_margins_rates + ..
    (BY.Transp_margins_rates < 0) .* (delta_TranspMargins_rate * BY.Transp_margins_rates);
    
endfunction

   function y = delta_TranspMargin_Const(Transp_margins)
    
    y = sum(Transp_margins);
    
endfunction


// Transport margins
function [y] =  Transp_margins_Const_1(Transp_margins, Transp_margins_rates, p, alpha, Y, C, G, I, X) ;

    y1 = Transp_margins - Transp_margins_rates .* p.* ( sum( alpha .*(ones(nb_Commodities, 1).*.Y'), "c") + sum(C, "c") + sum(G, "c") + sum(I, "c") + X )' ;
    y=y1';
	
endfunction

function Transp_margins =  Transp_margins_Val_1(Transp_margins_rates, p, alpha, Y, C, G, I, X)

    Transp_margins = Transp_margins_rates .* p.* ( sum( alpha .*(ones(nb_Commodities, 1).*.Y'), "c") + sum(C, "c") + sum(G, "c") + sum(I, "c") + X )';

endfunction


// PAS POUR CALIBRAGE //
// Trade margins rates
function [y] =  Trade_MargRates_Const_1(Trade_margins, Trade_margins_rates)

    y1 = (BY.Trade_margins_rates >= 0) .* (Trade_margins_rates - BY.Trade_margins_rates) + (BY.Trade_margins_rates < 0) .* sum(Trade_margins) ;
    y=y1';
	
endfunction

function [y] =  Trade_MargRates_Const_2(Trade_margins, Trade_margins_rates, delta_TradeMargins_rate)

    y1 = (BY.Trade_margins_rates >= 0).*(Trade_margins_rates - BY.Trade_margins_rates)..
	+(BY.Trade_margins_rates < 0).*(Trade_margins_rates - delta_TradeMargins_rate*BY.Trade_margins_rates) ;
    y1($+1) =  sum(Trade_margins);

    y=y1';

endfunction

// /!\ Décomposition de Trade_MargRates_Const_2 en 2 fonctions !!
function Trade_margins_rates = Trade_MargRates_Val_2(delta_TradeMargins_rate)
    
    Trade_margins_rates = (BY.Trade_margins_rates >= 0) .* BY.Trade_margins_rates + ..
    (BY.Trade_margins_rates < 0) .* (delta_TradeMargins_rate * BY.Trade_margins_rates);
    
endfunction

function y = delta_TradeMargin_Const(Trade_margins)
    
    y = sum(Trade_margins);
    
endfunction


// Trade margins
function [y] =  Trade_margins_Const_1(Trade_margins, Trade_margins_rates, p, alpha, Y, C, G, I, X);

    y1 = Trade_margins - Trade_margins_rates .* p.* ( sum( alpha .*(ones(nb_Commodities, 1).*.Y'), "c") + sum(C, "c") + sum(G, "c") + sum(I, "c") + X )' ;
    y=y1';

endfunction

function Trade_margins =  Trade_margins_Val_1(Trade_margins_rates, p, alpha, Y, C, G, I, X)

    Trade_margins = Trade_margins_rates .* p.* ( sum( alpha .*(ones(nb_Commodities, 1).*.Y'), "c") + sum(C, "c") + sum(G, "c") + sum(I, "c") + X )';

endfunction

// PAS POUR CALIBRAGE //
// Specific margin rates on hydrid sector purchases
function [y] = SpeMarg_rates_Const_1(SpeMarg_rates_IC, SpeMarg_rates_C, SpeMarg_rates_X, SpeMarg_rates_I) ;

    // Different rates, by products, for intermediate consumptions (nb_Commodities*nb_Sectors), household classes (nb_Commodities*nb_Households), and exports (nb_Commodities)

    y1 = SpeMarg_rates_IC - BY.SpeMarg_rates_IC ;
    y2 = SpeMarg_rates_C - BY.SpeMarg_rates_C ;
    y3 = SpeMarg_rates_X - BY.SpeMarg_rates_X ;
    y4 = SpeMarg_rates_I - BY.SpeMarg_rates_I ;

    y1 = matrix(y1, -1 , 1);
    y2 = matrix(y2, -1 , 1);
    y3 = matrix(y3, -1 , 1);
    y4 = matrix(y4, -1 , 1);

    y = [y1;y2;y3;y3];

endfunction

// A UTILISER POUR LE CALIBRAGE
// Specific margin rates on hydrid sector purchases

function [y] =  SpeMarg_Const_1(SpeMarg_IC, SpeMarg_rates_IC, SpeMarg_C, SpeMarg_rates_C, SpeMarg_G, SpeMarg_rates_G, SpeMarg_I, SpeMarg_rates_I, SpeMarg_X, SpeMarg_rates_X, p, alpha, Y, C, G, I, X) ;

    // Different margins, by products, for intermediate consumptions (nb_Sectors*Sm_index), household classes (nb_Sectors*hn_index), and exports (nb_Sectors*1)
    // if IC is equal to zero
    if Country == 'Argentina' then
        y1 = (SpeMarg_IC - SpeMarg_rates_IC .* ( (ones(1, nb_Sectors).*.p') .* alpha .* (ones(nb_Sectors, 1).*.Y') )');
    else
        // if IC is equal to zero
        y1_1 = (IC'==0).*(SpeMarg_rates_IC) ;
        // if IC is equal to zero
        // y1_2 = (IC'<>0).*(SpeMarg_IC - SpeMarg_rates_IC .* ( repmat(p', 1, nb_Sectors) .* alpha .* repmat(Y', nb_Sectors, 1) )');
        y1_2 = (IC'<>0).*(SpeMarg_IC - SpeMarg_rates_IC .* ( (ones(1, nb_Sectors).*.p') .* alpha .* (ones(nb_Sectors, 1).*.Y') )');
        
        y1 = y1_1 + y1_2 ;
    end

    y1 =matrix (y1, -1, 1);

    // if C is equal to zero
    y2_1 = (C'==0).*(SpeMarg_rates_C) ;
    // if C is equal to zero
    // y2_2 = (C'<>0).*(SpeMarg_C - SpeMarg_rates_C .* ( repmat(p', 1, nb_Households) .* C)');
    y2_2 = (C'<>0).*(SpeMarg_C - SpeMarg_rates_C .* ( (ones(1, nb_Households).*.p') .* C)');

    y2 = y2_1 + y2_2 ;
    y2 =matrix (y2, -1, 1);

    y3_1 = (G'==0).*(SpeMarg_rates_G) ;
    y3_2 = (G'<>0).*(SpeMarg_G - SpeMarg_rates_G .* (p' .* G)');

    y3 = y3_1 + y3_2 ;
    y3 =matrix (y3, -1, 1);
    
    y4_1 = (sum(I,"c")'==0).*(SpeMarg_rates_I) ;
    y4_2 = (sum(I,"c")'<>0).*(SpeMarg_I - SpeMarg_rates_I .* (p' .* sum(I,"c"))');

    y4 = y4_1 + y4_2 ;
    y4 =matrix (y4, -1, 1);

    if Country == 'Brasil' then
        y5 = (SpeMarg_X - SpeMarg_rates_X .* ( p' .* X )');
    else
        y5_1 = (X'==0).*(SpeMarg_rates_X) ;
        y5_2 = (X'<>0).*(SpeMarg_X - SpeMarg_rates_X .* ( p' .* X )');
        y5 = y5_1 + y5_2 ;
    end
    
    y5 =matrix (y5, -1, 1);

    y =[y1;y2;y3;y4;y5];


endfunction

function [y] =  SpeMarg_Const_1_2(SpeMarg_IC, SpeMarg_rates_IC, SpeMarg_C, SpeMarg_rates_C,SpeMarg_G, SpeMarg_rates_G, SpeMarg_X, SpeMarg_rates_X,SpeMarg_I, SpeMarg_rates_I, p, alpha, Y, C, X, I, G) ;

    // Different margins, by products, for intermediate consumptions (nb_Sectors*Sm_index), household classes (nb_Sectors*hn_index), and exports (nb_Sectors*1)

    y1 = SpeMarg_IC - SpeMarg_rates_IC .* ( (ones(1, nb_Sectors).*.p') .* alpha .* (ones(nb_Sectors, 1).*.Y') )';
    y1 =matrix (y1, -1, 1);

    y2 = SpeMarg_C - SpeMarg_rates_C .* ( (ones(1, nb_Households).*.p') .* C)';
    y2 =matrix (y2, -1, 1);
	
	y3 = SpeMarg_G - SpeMarg_rates_G .* ( p' .* G )';
    y3 =matrix (y3, -1, 1);

    y4 = SpeMarg_X - SpeMarg_rates_X .* ( p' .* X )';
    y4 =matrix (y4, -1, 1);

    y5 = SpeMarg_I - SpeMarg_rates_I .* ( p' .* sum(I,"c"))';
    y5 =matrix (y5, -1, 1);

    y =[y1;y2;y3;y4;y5];

endfunction

function [SpeMarg_IC,SpeMarg_C,SpeMarg_G,SpeMarg_X,SpeMarg_I] =  SpeMarg_Val_1(SpeMarg_rates_IC, SpeMarg_rates_C, SpeMarg_rates_G, SpeMarg_rates_X, SpeMarg_rates_I, p, alpha, Y, C, X, G, I)

    // Different margins, by products, for intermediate consumptions (nb_Sectors*Sm_index), household classes (nb_Sectors*hn_index), and exports (nb_Sectors*1)

    SpeMarg_IC = SpeMarg_rates_IC .* ( (ones(1, nb_Sectors).*.p') .* alpha .* (ones(nb_Sectors, 1).*.Y') )';
    SpeMarg_C = SpeMarg_rates_C .* ( (ones(1, nb_Households).*.p') .* C)';
	SpeMarg_G = SpeMarg_rates_G .* ( p' .* G )'
    SpeMarg_X = SpeMarg_rates_X .* ( p' .* X )';
    SpeMarg_I = SpeMarg_rates_I .* ( p' .* sum(I,"c"))';

endfunction


/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
///////   C.3  Investment decision
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////


// Entrepreneurs' investment demand equals to an exogenous proportion of fixed capital depreciation
// Constant composition in goods of capital

function [y] = Invest_demand_Const_1(Betta, I, kappa, Y, GDP, pI)

	if ~Capital_Dynamics
	// Capital expansion coefficient ( Betta ( nb_Sectors) ).
    // This coefficient gives : 1) The incremental level of investment as a function of capital depreciation, and 2) the composition of the fixed capital formation
		if Invest_matrix then
		
			y1 = I - Betta .* ((kappa.* Y') .*. ones(nb_Commodities,1));
			
				// so far, only to inform the electric vector of investments
				if is_projected('I') then
					y1(:,Indice_Elec) = apply_proj_eq(y1(:,Indice_Elec), I(:,Indice_Elec), 'I(:,Indice_Elec)');
				end
	
			y = matrix(y1, -1 , 1)
	
		else
			y = I - Betta * sum( kappa .* Y' ) ;
		end
		
	elseif Capital_Dynamics
	// If Capital Market - Investment is a share of GDP - Give the repartition of I
			if ~Exo_ShareI_GDP
				ShareI_GDP = BY.ShareI_GDP * ( GDP_index(time_step + 1) / GDP_index(time_step)  -  ( 1 - depreciation_rate) ) * ( BY.Capital_endowment./ sum(BY.I) ) ;
			else 
				ShareI_GDP = Proj_Macro.ShareI_GDP(time_step);
			end		
		
		//Ventilated by BY Shares
		y1 = I - ( ((ShareI_GDP*GDP)./( sum(pI*ones(1,nb_size_I).*BY.I))).*BY.I );
		
		// so far, only to inform the electric vector of investments
		if is_projected('I') then
				I(:,Indice_Elec) = apply_proj_val(I(:,Indice_Elec), 'I');
			end
		
			
		y = matrix(y1, -1 , 1);
		
	end

endfunction

function I = Invest_demand_Val_1(Betta, kappa, Y, GDP, pI)
    // Capital expansion coefficient ( Betta ( nb_Sectors) ).
    // This coefficient gives : 1) The incremental level of investment as a function of capital depreciation, and 2) the composition of the fixed capital formation
	if ~Capital_Dynamics
    // Capital expansion coefficient ( Betta ( nb_Sectors) ).
    // This coefficient gives : 1) The incremental level of investment as a function of capital depreciation, and 2) the composition of the fixed capital formation
		if Invest_matrix then
			I = Betta .* ((kappa.* Y') .*. ones(nb_Commodities,1));
	
				// so far, only to inform the electric vector of investments
				if is_projected('I') then
					I(:,Indice_Elec) = apply_proj_val(I(:,Indice_Elec), 'I');
				end
		else
			I = Betta * sum( kappa .* Y' );
		end
		
	elseif Capital_Dynamics
	// If Capital Market - Investment is a share of GDP - Give the repartition of I
			if ~Exo_ShareI_GDP
				ShareI_GDP = BY.ShareI_GDP * ( GDP_index(time_step + 1) / GDP_index(time_step)  -  ( 1 - depreciation_rate) ) * ( BY.Capital_endowment./ sum(BY.I) ) ;
			else 
				ShareI_GDP = Proj_Macro.ShareI_GDP(time_step);
			end		
		
		//Ventilated by BY Shares
		// I = "beta" Io 
		I = ((ShareI_GDP*GDP)./( sum(pI*ones(1,nb_size_I).*BY.I))).*BY.I;		

			// so far, only to inform the electric vector of investments
			if is_projected('I') then
				I(:,Indice_Elec) = apply_proj_val(I(:,Indice_Elec), 'I');
			end	
	end

endfunction


///////// 
// Betta calculation function of K cost & pI
// Index_Sectors : indice des colonnes de betta != betta_ref
// dimension de Betta cohérente
// to use for investment matrix
function [Betta_proj]=Betta_Const_1(Betta_ref, pI, pBetta, Indice, Adjustment)
    Indice_bis = Indice_Sectors;
    Indice_bis(Indice)=[];
    y1=zeros(nb_Sectors,nb_Sectors);
    for k=Indice_bis
        y1(:,k) = Betta_ref(:,k);
    end

    y1(:,Indice) = (pBetta'./pI)*((Adjustment == 0) + (Adjustment == 1)*sum(Betta_ref(:,Indice))/sum(pBetta'./pI)) + (Adjustment == 2)*Betta_ref(:,Indice);
    
    
    //Betta_proj = matrix(y1, -1 , 1)
    Betta_proj = y1;

endfunction

// PAS POUR CALIBRAGE //
// Capital cost (pK)
function [y] = Capital_Cost_Const_1(pK, pI, I, pRental) ;
	pK=abs(pK);
	
	if ~Capital_Dynamics
		if Invest_matrix then
			y = pK' - (sum((pI*ones(1,nb_Sectors)).* I,"r") ./ sum(I,"r"))';
		else 
			y = pK' - sum(pI .* I) ./ (ones(nb_Sectors, 1).*.sum(I)) ;
		end
	
	elseif Capital_Dynamics
	// Unique rental price
		y1  = pK - pRental*ones(1,nb_Sectors);
		y= y1';
	
	end
	
    
endfunction

function pK = Capital_Cost_Val_1(pI, I, pRental)

	if ~Capital_Dynamics
		
		if Invest_matrix then
			pK = sum((pI*ones(1,nb_Sectors)).* I,"r") ./ sum(I,"r");
		else 
			pK = ( sum(pI .* I) ./ (ones(nb_Sectors, 1).*.sum(I)) )';
		end
		
	elseif Capital_Dynamics
	// Unique rental price
	
		pK = pRental.*ones(1,nb_Sectors);	
		
	end
    
endfunction

/// IF Capital Market - Introducing the rental price

function y = Capital_Cost_Const_2(pK, pRental)

y1  = pK - pRental*ones(1,nb_Sectors);
y= y1';
 
endfunction

function pK = Capital_Cost_Val_2(pRental)

pK = pRental.*ones(1,nb_Sectors);	
endfunction

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
///////   D)  Market Functioning
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////


/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
///////   D.1  Goods and services markets
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////


/// Quantities
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

// PAS POUR CALIBRAGE //
// Market balance
function [y] = MarketBalance_Const_1(Y, IC, C, G, I, X, M) ;

    y = Y - ( sum( IC,"c") + sum(C, "c") + G + sum(I, "c") + X - M ) ;

endfunction

function Y = MarketBalance_Val_1(IC, C, G, I, X, M)

    Y = ( sum( IC,"c") + sum(C, "c") + G + sum(I, "c") + X - M );

endfunction

// For calibration
// Total intermediate consumptions in quantities: IC (Sm_index, Sm_index)
function [y] = IC_Const_1(IC, Y, alpha) ;

    y1 = IC - ( alpha .* (ones(nb_Commodities, 1).*.Y') ) ;


    y = matrix(y1, -1 , 1);
endfunction

function IC = IC_Val_1(Y, alpha)

    IC = ( alpha .* (ones(nb_Commodities, 1).*.Y') ) ;


endfunction

function IC = IC_Val_2(Y, alpha, CO2Emis_IC)

    IC =  (CO2Emis_IC == 0).*( alpha .* (ones(nb_Commodities, 1).*.Y') );
	IC = IC + (CO2Emis_IC <> 0).* divide(CO2Emis_IC, Emission_Coef_IC, 0);

endfunction



// Imports function
function [y] = Imports_Const_1(M, pM, pY, Y, sigma_M, delta_M_parameter)

	pY=abs(pY);
    y1 = ( M'.^ (1 ./sigma_M)) -  ( ( (1 + delta_M_parameter) .* Y' .* (BY.M' ./ BY.Y' ) ).^(1 ./sigma_M)  .*  (BY.pM' ./ BY.pY') .* (pY' ./ pM') );
    y=y1';

endfunction

// Imports function
function M = Imports_Val_1 (pM, pY, Y, sigma_M, delta_M_parameter);

	pY=abs(pY);
	M = ( (1 + delta_M_parameter).^(time_since_BY) .* Y' .* (BY.M' ./ BY.Y') .* ( (BY.pM' ./ BY.pY') .* (pY' ./ pM') ) .^ sigma_M )';

    if is_projected('M') then
        M = apply_proj_val(M, 'M');
    end

    if is_projected('M_Y') then
       Proj_param.M.val = Proj_Vol.M_Y.val .* Y;
       Proj_param.M.ind_of_proj = Proj_Vol.M_Y.ind_of_proj;
       M = apply_proj_val(M, 'M', Proj_param)
    end
    
endfunction


// Imports function in value
function M = Imports_Val_2 (pM, pY, Y, sigma_M, delta_M_parameter);
	pY=abs(pY);
	M = (( (1 + delta_M_parameter) .* (pY.*Y)' .* ( (ini.pM.*ini.M)' ./ (pY.*ini.Y)') .* ( (ini.pM' ./ ini.pY') .* (pY' ./ pM') ) .^ sigma_M )./pM')';
endfunction


// Exports function
function [y] = Exports_Const_1(X, pM, pX, sigma_X, delta_X_parameter);

    X = abs(X);
	pX=abs(pX);
    delta_X_parameter = abs(delta_X_parameter);
    y =( X.^ (1 ./sigma_X')) - ( ( (ones(nb_Sectors, 1) + delta_X_parameter') .* BY.X).^(1 ./sigma_X') ).* ( (BY.pX ./ BY.pM) .* (pM ./ pX) ) ;

endfunction

// Exports function
function X = Exports_Val_1( pM, pX, sigma_X, delta_X_parameter);

    pX = abs(pX);
    pM = abs(pM);
    X = ( (ones(nb_Sectors, 1) + delta_X_parameter').^time_since_BY .* BY.X .* ( (BY.pX ./ BY.pM) .* (pM ./ pX) ) .^ sigma_X' )
    
    if is_projected('X') then
        X = apply_proj_val(X, 'X');
    end

endfunction


//	proj: les exports croient comme la croissance naturelle dans le pays à termes de l'échanges inchangés 
function X = Exports_Val_2( pM, pX, sigma_X, delta_X_parameter, GDP);

    delta_X_parameter = abs(delta_X_parameter);
    pX = abs(pX);
    pM = abs(pM);
    X = (ones(nb_Sectors, 1) + delta_X_parameter').^time_since_BY .* BY.X * (GDP/BY.GDP) .* ( (BY.pX ./ BY.pM) .* (pM ./ pX) ) .^ sigma_X'

endfunction


/// Trade balance constant to GDP growth
function y = Trade_Balance_Const_1( pM, pX, X, M, GDP);

  y = (sum(pX.*X) - sum(pM.*M))/(GDP/CPI) - (sum(ini.pX.*ini.X) - sum(ini.pM.*ini.M))/ini.GDP

endfunction

/// Trade balance constant to GDP growth
function y = Trade_Balance_Const_2( pM, pX, X, M, GDP);

  y = (sum(pX.*X) - sum(pM.*M))/GDP - (sum(ini.pX.*ini.X) - sum(ini.pM.*ini.M))/ini.GDP


endfunction


// Market closure (adjustment of supply or demand in quantities)

//  Product markets closure 1 : the adjustment variables are Y (domestic production) or M (imports)
// For all products exports X are constrained by the export function
// Domestic supply meats demand (Y adjust), except for fully imported products ( Indice_NonSupplierSect ) whose production is constrained (Y is fixed)
//  e. g. crude oil for oil imported countries
// For those products, imports meat the domestic demand (M adjust)

function [y] = MarketClosure_Const_1(Y, delta_M_parameter, delta_X_parameter) ;

    // There are 3 potential variables (Y, X, M) for the market closure
    // A closure rule must determine 2 of the 3
    // y = zeros(2*nb_Sectors, 1);

    // Fixed levels of domestic supply for fully imported products (Y is fixed)
    // All domestic demand is balanced by imports (M adjusts)

    // for i = Indice_NonSupplierSect
    //  y(i) = ( Y(i) - Y_ref(i) ) ;
    // end

    ybis = (delta_M_parameter - ini.delta_M_parameter)';
    // ybis(Indice_NonSupplierSect) = Y(Indice_NonSupplierSect) - Y_ref(Indice_NonSupplierSect);


    // Constrained level of imports for domestically produced goods ( M is determined by the Imports function)
    // All domestic demand is balanced by domestic production (Y adjust)

    // for i = 1:nb_Sectors
    //  if  i ~= Indice_NonSupplierSect
    //   y(i) =  delta_M_parameter(i) - delta_M_parameter_ref(i) ;
    //  end
    // end

    // Constrained level of exports for all produced goods ( X is determined by the Export function)
    // All domestic demand is balanced by domestic production (fully imported products) or imports (domestically produced goods)

    // y(nb_Sectors + 1 : 2*nb_Sectors) =  delta_X_parameter' - delta_X_parameter_ref' ;
    // yter = [ ybis ; (delta_X_parameter - delta_X_parameter_ref)' ];

    y = [ ybis ; (delta_X_parameter - ini.delta_X_parameter)' ];

    // if or(yter~=y)
    //     pause
    // end

endfunction

// Total Fixed Capital Consumption in quantities: Capital_consumption (nb_Sectors)
function [y] = Capital_Consump_Const_1(Capital_consumption, Y, kappa) ;

    y1 = Capital_consumption - ( kappa .* Y' ) ;

    y=y1';
endfunction

function Capital_consumption = Capital_Consump_Val_1(Y, kappa)

    Capital_consumption = ( kappa .* Y' );

endfunction

/// Prices
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

// Import price
function [y] = Import_price_Const_1(pM, delta_pM) ;

    // Constant import price
    // delta_pM:  import price chocks parameter
    y1 = pM' - delta_pM' .* BY.pM' ;

    y=y1';
endfunction


// import price evolving at the same rate than domestic prices
// a faire évoluer éventuellement en (1+delta_pM)^t
function [pM] = pM_price_Val_1(pY);
    
    Index_Services = size(pM,1);
    pM(1:Index_Services-1) = BY.pM(1:Index_Services-1).*(pY(1:Index_Services-1)./BY.pY(1:Index_Services-1));
    pM(Index_Services) = BY.pM(Index_Services);

endfunction 

// Import price : forcing from macro context
function [pM] = pM_price_Val_2(Carbon_Tax_rate_M, Emission_Coef_M);
    
    pM = ini.pM .* (1+delta_pM_parameter').^time_since_ini
	
	if Carbon_BTA
	pM = ini.pM .* (1+delta_pM_parameter').^time_since_ini + (Carbon_Tax_rate_M .* Emission_Coef_M)'
	end 
	

endfunction 

			
// Mean resource price, before indirect taxation
// NOT A VARIABLE FOR THE SOLVER
function [p] = Mean_price_Val_1(pY, pM, Y, M ,p) ;
	pY=abs(pY);
    // Mean resource price 
    p = ( pY' .* Y' + pM' .* M') ./ (Y' + M') ;

endfunction


// Purchase price (Intermediate consumptions) after trade, transport and energy margins, and indirect tax
function y = pIC_price_Const_1(pIC, Transp_margins_rates, Trade_margins_rates, SpeMarg_rates_IC, Energy_Tax_rate_IC, OtherIndirTax_rate, Carbon_Tax_rate_IC, Emission_Coef_IC, p)
	
	pIC=abs(pIC);
    //  Trade, transport and specific margins for energy
    margins_rates = ones(1,nb_Sectors).*. (Transp_margins_rates' + Trade_margins_rates') + SpeMarg_rates_IC' ;

    // Indirect tax
    Indirect_tax_rates = ones(1,nb_Sectors).*.(Energy_Tax_rate_IC' + OtherIndirTax_rate') + Carbon_Tax_rate_IC .* Emission_Coef_IC ;

    // Intermediate consumption price: pIC (Sm_index, Sm_index)
    y1 = pIC - ( (ones(1, nb_Sectors).*.p') .* ( 1 + margins_rates ) + Indirect_tax_rates ) ;

    y =matrix(y1, -1 , 1);
endfunction

// Purchase price (Intermediate consumptions) after trade, transport and energy margins, and indirect tax
function pIC = pIC_price_Val_1( Transp_margins_rates, Trade_margins_rates, SpeMarg_rates_IC, Energy_Tax_rate_IC, OtherIndirTax_rate, Carbon_Tax_rate_IC, Emission_Coef_IC, p)

    //  Trade, transport and specific margins for energy
    margins_rates = ones(1,nb_Sectors).*. (Transp_margins_rates' + Trade_margins_rates') + SpeMarg_rates_IC' ;

    // Indirect tax
    Indirect_tax_rates = ones(1,nb_Sectors).*.(Energy_Tax_rate_IC' + OtherIndirTax_rate') + Carbon_Tax_rate_IC .* Emission_Coef_IC ;

    // Intermediate consumption price: pIC (Sm_index, Sm_index)
    pIC = ( (ones(1, nb_Sectors).*.p') .* ( 1 + margins_rates ) + Indirect_tax_rates ) ;
	
endfunction

// Purchase price (Intermediate consumptions) after trade, transport and energy margins, indirect tax and tax on consumption (Brazil)
function y = pIC_price_Const_2(pIC, Transp_margins_rates, Trade_margins_rates, SpeMarg_rates_IC, Energy_Tax_rate_IC, OtherIndirTax_rate, Carbon_Tax_rate_IC, Emission_Coef_IC, p, Cons_Tax_rate)

    //  Trade, transport and specific margins for energy
    margins_rates = ones(1,nb_Sectors).*. (Transp_margins_rates' + Trade_margins_rates') + SpeMarg_rates_IC' ;

    // Indirect tax
    Indirect_tax_rates = ones(1,nb_Sectors).*.(Energy_Tax_rate_IC' + OtherIndirTax_rate') + Carbon_Tax_rate_IC .* Emission_Coef_IC ;

    // Intermediate consumption price: pIC (Sm_index, Sm_index)
   y1 = pIC - ( (ones(1, nb_Sectors).*.p') .* ( 1 + margins_rates )+ Indirect_tax_rates).*(1 + (ones( 1, nb_Sectors).*.Cons_Tax_rate') );
    y =matrix(y1, -1 , 1);
endfunction


// Purchase price (Intermediate consumptions) after trade, transport and energy margins, indirect tax and tax on consumption (Brazil)
function pIC = pIC_price_Val_2( Transp_margins_rates, Trade_margins_rates, SpeMarg_rates_IC, Energy_Tax_rate_IC, OtherIndirTax_rate, Carbon_Tax_rate_IC, Emission_Coef_IC, p, Cons_Tax_rate)

    //  Trade, transport and specific margins for energy
    margins_rates = ones(1,nb_Sectors).*. (Transp_margins_rates' + Trade_margins_rates') + SpeMarg_rates_IC' ;

    // Indirect tax
    Indirect_tax_rates = ones(1,nb_Sectors).*.(Energy_Tax_rate_IC' + OtherIndirTax_rate') + Carbon_Tax_rate_IC .* Emission_Coef_IC ;
	// Indirect_tax_rates = ones(1,nb_Sectors).*.(Energy_Tax_rate_IC' + OtherIndirTax_rate') ;

    // Intermediate consumption price: pIC (Sm_index, Sm_index)
    pIC = ( (ones(1, nb_Sectors).*.p') .* ( 1 + margins_rates )+ Indirect_tax_rates).*(1 + (ones( 1, nb_Sectors).*.Cons_Tax_rate') ) ;
    // pIC = ( (ones(1, nb_Sectors).*.p') .* ( 1 + margins_rates )+ Indirect_tax_rates).*(1 + (ones( 1, nb_Sectors).*.Cons_Tax_rate') ) + Carbon_Tax_rate_IC .* Emission_Coef_IC ;

endfunction



//  Carbon CAP - Purchase price (Intermediate consumptions) after trade, transport and energy margins, and tax on consumption (Brazil)
function y = pIC_price_Const_3(pIC, Transp_margins_rates, Trade_margins_rates, SpeMarg_rates_IC, Energy_Tax_rate_IC, OtherIndirTax_rate, Carbon_Tax_rate_IC, Emission_Coef_IC, p, Cons_Tax_rate, Theta, Phi, aIC, sigma, aL, pL, aK, pK, phi_IC, phi_K, phi_L, ConstrainedShare_IC, ConstrainedShare_Labour, ConstrainedShare_Capital, Y)
	
	test_pL = pL == 0;
    pIC = abs(pIC);
    pL = abs(pL);
    pL(test_pL) = 1;
    pK = abs(pK);
 //  Trade, transport and specific margins for energy
    margins_rates = ones(1,nb_Sectors).*. (Transp_margins_rates' + Trade_margins_rates') + SpeMarg_rates_IC' ;

    // Indirect tax
    Indirect_tax_rates = ones(1,nb_Sectors).*.(Energy_Tax_rate_IC' + OtherIndirTax_rate') + Carbon_Tax_rate_IC .* Emission_Coef_IC ;

    // Intermediate consumption price: pIC (Sm_index, Sm_index)
    y1 = pIC - ( ( (ones(1, nb_Sectors).*.p') .* ( 1 + margins_rates )+ Indirect_tax_rates).*(1 + (ones( 1, nb_Sectors).*.Cons_Tax_rate') )) ;
	
	/// pIC that matches the alpha of cap emissions
	pL = abs(pL);
    pL(test_pL) = 1;
    pK = abs(pK);

    FPI = sum((aIC .^ (sigma.*.ones(nb_Sectors,1))) .* (pIC.^(1 - sigma.*.ones(nb_Sectors,1))),"r") + ..
    (aL .^ sigma) .* ((pL ./ ((1+phi_L).^time_since_BY)) .^(1 - sigma)) + ..
    (aK .^ sigma) .* (pK.^(1 - sigma)) ;

    test_FPI = FPI == 0;
    FPI(test_pL|test_FPI) = 1;
    	
	y2 = alpha - ((ones(nb_Sectors, 1).*.(Theta ./ Phi)) .* (ones(nb_Sectors,nb_Sectors)./(1+phi_IC).^time_since_BY).* ..
    (ConstrainedShare_IC .* BY.alpha + ((aIC ./ pIC) .^ (sigma.*.ones(nb_Sectors,1))) .* ..
    (ones(nb_Sectors, 1).*.(FPI.^(sigma./(1 - sigma))))) );
	
	y3 = ( CO2Emis_IC== 0) .* y1 + (CO2Emis_IC <> 0) .* y2;
	
    y = matrix(y3, -1 , 1);
endfunction

//  Carbon CAP - Purchase price (Intermediate consumptions) after trade, transport and energy margins, and va tax
function y = pIC_price_Const_4(pIC, Transp_margins_rates, Trade_margins_rates, SpeMarg_rates_IC, Energy_Tax_rate_IC, OtherIndirTax_rate, Carbon_Tax_rate_IC, Emission_Coef_IC, p, Theta, Phi, aIC, sigma, aL, pL, aK, pK, phi_IC, phi_K, phi_L, ConstrainedShare_IC, ConstrainedShare_Labour, ConstrainedShare_Capital, Y)
	
	test_pL = pL == 0;
    pIC = abs(pIC);
    pL = abs(pL);
    pL(test_pL) = 1;
    pK = abs(pK);
    //  Trade, transport and specific margins for energy
    margins_rates = ones(1,nb_Sectors).*. (Transp_margins_rates' + Trade_margins_rates') + SpeMarg_rates_IC' ;

    // Indirect tax
    Indirect_tax_rates = ones(1,nb_Sectors).*.(Energy_Tax_rate_IC' + OtherIndirTax_rate') + Carbon_Tax_rate_IC .* Emission_Coef_IC ;

    // Intermediate consumption price: pIC (Sm_index, Sm_index)
    y1 = pIC -  ( (ones(1, nb_Sectors).*.p') .* ( 1 + margins_rates ) + Indirect_tax_rates ) ;
	
	/// pIC that matches the alpha of cap emissions
	pL = abs(pL);
    pL(test_pL) = 1;
    pK = abs(pK);

    FPI = sum((aIC .^ (sigma.*.ones(nb_Sectors,1))) .* (pIC.^(1 - sigma.*.ones(nb_Sectors,1))),"r") + ..
    (aL .^ sigma) .* ((pL ./ ((1+phi_L).^time_since_BY)) .^(1 - sigma)) + ..
    (aK .^ sigma) .* (pK.^(1 - sigma)) ;

    test_FPI = FPI == 0;
    FPI(test_pL|test_FPI) = 1;
    	
	y2 = alpha - ((ones(nb_Sectors, 1).*.(Theta ./ Phi)) .* (ones(nb_Sectors,nb_Sectors)./(1+phi_IC).^time_since_BY).* ..
    (ConstrainedShare_IC .* BY.alpha + ((aIC ./ pIC) .^ (sigma.*.ones(nb_Sectors,1))) .* ..
    (ones(nb_Sectors, 1).*.(FPI.^(sigma./(1 - sigma))))) );
	
	y3 = ( CO2Emis_IC== 0) .* y1 + (CO2Emis_IC <> 0) .* y2;
	
    y = matrix(y3, -1 , 1);
endfunction

// Purchase price (Households Final consumptions) after trade, transport and energy margins, and indirect tax
function [y] = pC_price_Const_1(pC, Transp_margins_rates, Trade_margins_rates, SpeMarg_rates_C, Energy_Tax_rate_FC, OtherIndirTax_rate, Carbon_Tax_rate_C, Emission_Coef_C, p, VA_Tax_rate) ;

    // Rq: A modifier si l'on considère des marges ou taxes ou coefficients d'émission différents selon les classes de ménages

    //  Trade, transport and specific margins for energy
    margins_rates = (ones(nb_Households,1) .*. ( Transp_margins_rates + Trade_margins_rates ) + SpeMarg_rates_C )' ;

    // Indirect tax
    Indirect_tax_rates =  (ones(nb_Households,1) .*. ( Energy_Tax_rate_FC + OtherIndirTax_rate ) )' + Carbon_Tax_rate_C .* Emission_Coef_C  ;
	
    // Household consumption price: pC (nb_Commodities, nb_Households)
    y1 = pC - ( (ones(1, nb_Households).*.p') .* ( 1 + margins_rates ) + Indirect_tax_rates) .* (1 + (ones( 1, nb_Households).*.VA_Tax_rate') ) ;

    y = matrix(y1, -1 , 1);

endfunction

// Purchase price (Households Final consumptions) after trade, transport and energy margins, and indirect tax
function pC = pC_price_Val_1( Transp_margins_rates, Trade_margins_rates, SpeMarg_rates_C, Energy_Tax_rate_FC, OtherIndirTax_rate, Carbon_Tax_rate_C, Emission_Coef_C, p, VA_Tax_rate) ;

    // Rq: A modifier si l'on considère des marges ou taxes ou coefficients d'émission différents selon les classes de ménages

    //  Trade, transport and specific margins for energy
    margins_rates = (ones(nb_Households,1) .*. ( Transp_margins_rates + Trade_margins_rates ) + SpeMarg_rates_C )' ;

    // Indirect tax
    Indirect_tax_rates =  (ones(nb_Households,1) .*. ( Energy_Tax_rate_FC + OtherIndirTax_rate ) )' + Carbon_Tax_rate_C .* Emission_Coef_C  ;

    // Household consumption price: pC (nb_Commodities, nb_Households)
    pC = ( (ones(1, nb_Households).*.p') .* ( 1 + margins_rates ) + Indirect_tax_rates) .* (1 + (ones( 1, nb_Households).*.VA_Tax_rate') ) ;
endfunction


// Purchase price (Households Final consumptions) after trade, transport and energy margins, indirect tax and tax on consumption (Brazil)
function pC = pC_price_Val_2( Transp_margins_rates, Trade_margins_rates, SpeMarg_rates_C, Energy_Tax_rate_FC, OtherIndirTax_rate, Carbon_Tax_rate_C, Emission_Coef_C, p, Cons_Tax_rate) ;

    // Rq: A modifier si l'on considère des marges ou taxes ou coefficients d'émission différents selon les classes de ménages

    //  Trade, transport and specific margins for energy
    margins_rates = (ones(nb_Households,1) .*. ( Transp_margins_rates + Trade_margins_rates ) + SpeMarg_rates_C )' ;

    // Indirect tax
    Indirect_tax_rates =  (ones(nb_Households,1) .*. ( Energy_Tax_rate_FC + OtherIndirTax_rate ) )' + Carbon_Tax_rate_C .* Emission_Coef_C  ;
	// Indirect_tax_rates =  (ones(nb_Households,1) .*. ( Energy_Tax_rate_FC + OtherIndirTax_rate ) )';
	
    // Household consumption price: pC (nb_Commodities, nb_Households)
    pC = ( (ones(1, nb_Households).*.p') .* ( 1 + margins_rates )  + Indirect_tax_rates).* (1 + (ones( 1, nb_Households).*.Cons_Tax_rate') ) ;
    // pC = ( (ones(1, nb_Households).*.p') .* ( 1 + margins_rates )  + Indirect_tax_rates).* (1 + (ones( 1, nb_Households).*.Cons_Tax_rate') )  + Carbon_Tax_rate_C .* Emission_Coef_C  ;
	
	
endfunction


// Purchase price (Government Final consumptions) after trade, transport and indirect tax (no final energy consumption by the government)
function [y] = pG_price_Const_1(pG, Transp_margins_rates, Trade_margins_rates, SpeMarg_rates_G, Energy_Tax_rate_FC, OtherIndirTax_rate, p, VA_Tax_rate) ;

    //  Trade and transport
    margins_rates = (Transp_margins_rates' + Trade_margins_rates').*. ones(1, nb_Government) + SpeMarg_rates_G' ;

    // Indirect tax
    Indirect_tax_rates = (Energy_Tax_rate_FC' + OtherIndirTax_rate').*. ones(1, nb_Government) ;

    // Government price: pG (Sm_index)
    y1 = pG - ( (p'.*.ones(1, nb_Government)) .* ( 1 + margins_rates ) + Indirect_tax_rates) .* (1 + (VA_Tax_rate'.*.ones(1, nb_Government)) );

    y = matrix(y1, -1 , 1);
endfunction

// Purchase price (Government Final consumptions) after trade, transport and indirect tax (no final energy consumption by the government)
function pG = pG_price_Val_1( Transp_margins_rates, Trade_margins_rates, SpeMarg_rates_G, Energy_Tax_rate_FC, OtherIndirTax_rate, p, VA_Tax_rate) ;

    //  Trade and transport
    margins_rates = (Transp_margins_rates' + Trade_margins_rates').*. ones(1, nb_Government) + SpeMarg_rates_G' ;

    // Indirect tax
    Indirect_tax_rates = (Energy_Tax_rate_FC' + OtherIndirTax_rate').*. ones(1, nb_Government) ;

    // Government price: pG (Sm_index)
    pG = ( (p'.*.ones(1, nb_Government)) .* ( 1 + margins_rates ) + Indirect_tax_rates) .* (1 + (VA_Tax_rate'.*.ones(1, nb_Government)) );

endfunction


// Purchase price (Government Final consumptions) after trade, transport, indirect tax and tax on consumption (Brasil + no final energy consumption by the government)
function pG = pG_price_Val_2(Transp_margins_rates, Trade_margins_rates, SpeMarg_rates_G, Energy_Tax_rate_FC, OtherIndirTax_rate, p, Cons_Tax_rate) ;

    //  Trade and transport
    margins_rates = (Transp_margins_rates' + Trade_margins_rates').*. ones(1, nb_Government) + SpeMarg_rates_G';

    // Indirect tax
    Indirect_tax_rates = (Energy_Tax_rate_FC' + OtherIndirTax_rate').*. ones(1, nb_Government) ;

    // Government price: pG (Sm_index)
    pG = ( (p'.*.ones(1, nb_Government)) .* ( 1 + margins_rates ) + Indirect_tax_rates) .* (1 + (Cons_Tax_rate'.*.ones(1, nb_Government)) );

endfunction


// Purchase price (Investment) after trade, transport and indirect tax (no investment of energy)
function [y] = pI_price_Const_1(pI, Transp_margins_rates, Trade_margins_rates,SpeMarg_rates_I,OtherIndirTax_rate, Energy_Tax_rate_FC, p, VA_Tax_rate) ;

    //  Trade and transport and specific margins
    margins_rates = Transp_margins_rates' + Trade_margins_rates' + SpeMarg_rates_I'

    // Indirect tax
    Indirect_tax_rates = OtherIndirTax_rate'+Energy_Tax_rate_FC' ;

    // Investment price: pI (nb_Sectors)
    y = pI - ( p' .* ( ones(nb_Commodities, 1) + margins_rates) + Indirect_tax_rates) .* (ones(nb_Commodities, 1) + VA_Tax_rate') ;
endfunction

// Purchase price (Investment) after trade, transport and indirect tax (no investment of energy)
function pI = pI_price_Val_1( Transp_margins_rates, Trade_margins_rates,SpeMarg_rates_I,OtherIndirTax_rate, Energy_Tax_rate_FC, p, VA_Tax_rate) ;

    //  Trade and transport and specific margins
    margins_rates = Transp_margins_rates' + Trade_margins_rates' + SpeMarg_rates_I'

    // Indirect tax
    Indirect_tax_rates = OtherIndirTax_rate'+Energy_Tax_rate_FC' ;

    // Investment price: pI (nb_Sectors)
    pI = ( p' .* ( ones(nb_Commodities, 1) + margins_rates) + Indirect_tax_rates) .* (ones(nb_Commodities, 1) + VA_Tax_rate') ;
endfunction

// Purchase price (Investment) after trade, transport and indirect tax (no investment of energy)
function pI = pI_price_Val_2( Transp_margins_rates, Trade_margins_rates,SpeMarg_rates_I,OtherIndirTax_rate, Energy_Tax_rate_FC, p, Cons_Tax_rate) ;

    //  Trade and transport and specific margins
    margins_rates = Transp_margins_rates' + Trade_margins_rates' + SpeMarg_rates_I'

    // Indirect tax
    Indirect_tax_rates = OtherIndirTax_rate'+Energy_Tax_rate_FC' ;

    // Investment price: pI (nb_Sectors)
    pI = ( p' .* ( ones(nb_Commodities, 1) + margins_rates) + Indirect_tax_rates) .* (ones(nb_Commodities, 1) + Cons_Tax_rate') ;
    
endfunction


// Consumer price index (CPI) - Fisher Index
function y = CPI_Const_1(CPI, pC, C)

    y = CPI^2 -  sum(pC .* C) ./ sum(BY.pC .* C) .* sum(pC .* BY.C) ./ sum(BY.pC .* BY.C)
	
endfunction


// Consumer price index (CPI) - Fisher Index - Uniquement pour calibration
function y = CPI_Const_2(CPI, pC, C)

    y = CPI^2 -  1
	
endfunction

// Consumer price index (CPI) - Fisher Index
function CPI = CPI_Val_1( pC, C)

	C=abs(C);
	pC=abs(pC);
	CPI = sqrt( sum(pC .* C) ./ sum(BY.pC .* C) .* sum(pC .* BY.C) ./ sum(BY.pC .* BY.C) );
	
endfunction


// Consumer price index (CPI) - Stone Index - Note that the Stone Index is a geometric mean, it does not compare two situations, its calibration value is not equal to 1
//	We normalise it to 1 at the calibrated situation 
function CPI = CPI_Val_2( pC, C)
	C=abs(C);
	
	BudgetShares = (pC .* C) / sum(pC .* C);
	BudgetShares_ref = (BY.pC .* BY.C) / sum(BY.pC.* BY.C);
    
	CPI_Stone = prod( pC .^ BudgetShares) ;
	CPI_Stone_ref = prod( BY.pC .^ BudgetShares_ref) ;
	
	CPI = CPI_Stone / CPI_Stone_ref;
endfunction


// Export price, after trade, transport and energy margins (no indirect taxation)
function [y] = pX_price_Const_1(pX, Transp_margins_rates, Trade_margins_rates, SpeMarg_rates_X, p) ;

    //  Trade, transport and specific margins for energy
    margins_rates = Transp_margins_rates' + Trade_margins_rates' + SpeMarg_rates_X' ;

    // Export price
    y = pX -  p' .* (ones(nb_Commodities, 1) + margins_rates) ;
endfunction

function pX = pX_price_Val_1(Transp_margins_rates, Trade_margins_rates, SpeMarg_rates_X, p)

    //  Trade, transport and specific margins for energy
    margins_rates = Transp_margins_rates' + Trade_margins_rates' + SpeMarg_rates_X';

    // Export price
    pX =  p' .* (ones(nb_Commodities, 1) + margins_rates);
    
endfunction

 
/// Values
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////


// Market balance in value terms
function [y] = MarketBalValue_Const_1(Y_value, Trade_margins, Transp_margins, SpeMarg_IC, SpeMarg_C, SpeMarg_G, SpeMarg_I, SpeMarg_X, VA_Tax, Energy_Tax_IC, Energy_Tax_FC, ClimPolCompensbySect, OtherIndirTax, Carbon_Tax_IC, Carbon_Tax_C, IC_value, C_value, G_value, I_value, X_value, M_value) ;

    y = (Y_value + Trade_margins + Transp_margins + sum(SpeMarg_IC,"r") + sum(SpeMarg_C,"r") + sum(SpeMarg_G,"r") + sum(SpeMarg_I,"r") + sum(SpeMarg_X,"r") + VA_Tax + Energy_Tax_IC + Energy_Tax_FC - ClimPolCompensbySect + OtherIndirTax + sum(Carbon_Tax_IC',"r") + sum(Carbon_Tax_C',"r") )' - ( sum( IC_value,"c") + sum(C_value, "c") + G_value + I_value + X_value - M_value' ) ;
	
endfunction

// For calibration

function val = value ( price, quantity)
val = price.*quantity
endfunction

// Value of domestic production ( Y_value )
function [y] = Y_value_Const_1(Y_value, Y, pY) ;

    y1 = Y_value - ( Y' .* pY' ) ;
    y=y1';
	
endfunction

// For calibration
// Value of Intermediate consumptions ( IC_value )
function [y] = IC_value_Const_1(IC_value, IC,  pIC) ;

    y1  = IC_value - ( IC .* pIC ) ;
    y = matrix(y1, -1 , 1) ;
	
endfunction


//  For Calibration
// Values of Government expenditures
function [y] = G_value_Const_1(G_value, G, pG) ;

    y1 = G_value - ( G .* pG ) ;
    y = matrix(y1, -1 , 1);
	
endfunction

//  For Calibration
// Values of Investment expenditures
function [y] = I_value_Const_1(I_value, I, pI) ;

    y1 = I_value - ( I .* (pI*ones(1,nb_size_I)) ) ;
    y = matrix(y1, -1, 1);
	
endfunction

//  For Calibration
// Values of Imports
function [y] = M_value_Const_1(M_value, M, pM) ;

    y1 = M_value - ( M' .* pM' ) ;
    y  = y1';
	
endfunction

//  For Calibration
// Values of Exports
function [y] = X_value_Const_1(X_value, X, pX) ;

    y = X_value - ( X .* pX ) ;
endfunction


/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
///////   D.2  Labour market
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

// For calibration
// Employment by productive sector
function [y] = Employment_Const_1(Labour, lambda, Y) ;

    y1 = Labour - ( lambda .* Y' );

    y = y1';
endfunction

function Labour = Employment_Val_1(lambda, Y)

    Labour = ( lambda .* Y' );

endfunction

// Balance between Supply and Use of Labour
function [y] = LabourByWorker_Const_1(LabourByWorker_coef, u_tot, Labour_force, lambda, Y) ;
	u_tot= abs(u_tot);
    y = (1 - u_tot) * sum(Labour_force) * LabourByWorker_coef - sum( lambda .* Y' ) ;
endfunction

function u_tot = LabourByWorker_Val_1(LabourByWorker_coef, Labour_force, lambda, Y)

    u_tot = 1 - sum( lambda .* Y' ) / LabourByWorker_coef / sum(Labour_force);

endfunction

// Unemployment rate and Number of unemployed by household class
function [y] = HH_Employment_Const_1(Unemployed, u, Labour_force) ;
	u= abs(u);
    // Number of unemployed ( Unemployed (nb_Households) )
    y1 = Unemployed - (u .* Labour_force) ;

    y=y1';
endfunction

function Unemployed = HH_Employment_Val_1(u, Labour_force)
    
	u= abs(u);
    // Number of unemployed ( Unemployed (nb_Households) )
    Unemployed = (u .* Labour_force);

endfunction

//  Ajouter une contrainte pour le nombre d'employed ?

// Unemployment rate and Number of unemployed by household class
function [y] = Unemployment_Const_1(u_tot, Unemployed, Labour_force) ;

    // Mean rate of unemployment
	u_tot= abs(u_tot);
    y = u_tot - sum(Unemployed) / sum(Labour_force) ;

endfunction

// Unemployment by households class
function [y] = HH_Unemployment_Const_1(u, u_tot) ;
	u_tot = abs(u_tot);
    y1 = u - ini.u * ( u_tot / ini.u_tot ) ;

    y=y1';
endfunction

function u = HH_Unemployment_Val_1(u_tot)
    
	u_tot = abs(u_tot);
    u = ini.u * ( u_tot / ini.u_tot );

endfunction

/// Rq : Si l'on prend en compte du progrès technique sur le travail récupéré par les salaires, et que l'on ne veut pas que la hausse des salaires induite change le niveau de chômage de long terme, alors il faut corriger les wages curves (diviser le salaire qui entre dans la wage curve par la hausse de la productivité) : 1/(1+Mhu)^t

// PAS POUR CALIBRAGE !
// Wage curve by sector: Sectoral wage curve with different indexation of wages 
function y = Wage_Const_1(u_tot, w, lambda, Y, sigma_omegaU_sect, CPI, Coef_real_wage_sect, phi_L);
    w=abs(w);
    lambda = abs(lambda);
    u_tot = abs(u_tot);
	
    // Sectoral Wage curve
	// Coef_real_wage_sect defined in parameter => indexation allowed by sectors
	// Coef_real_wage_sect = 1 =>  real wage curve for the sector
	// Coef_real_wage_sect = 0 =>  nominal wage curve for the sector
	// If no macroframework for projection =>  phi_L = 0  
	y = w    - ( ini.w.* ( ones(1,nb_Sectors).*.(u_tot ./ ini.u_tot) ).^ sigma_omegaU_sect .*(Coef_real_wage_sect*CPI + (1-Coef_real_wage_sect)).*(1+phi_L).^(time_since_ini) ) ; 
	
	y = y';
endfunction

function w = Wage_Val_1(u_tot, lambda, Y, sigma_omegaU_sect, CPI, Coef_real_wage_sect, phi_L)
    
    lambda = abs(lambda);
    u_tot = abs(u_tot);
	
    // Sectoral Wage curve
	// Coef_real_wage_sect defined in parameter => indexation allowed by sectors
	// Coef_real_wage_sect = 1 =>  real wage curve for the sector
	// Coef_real_wage_sect = 0 =>  nominal wage curve for the sector
	// If no macroframework for projection =>  phi_L = 0  
	w = ( ini.w.* ( ones(1,nb_Sectors).*.(u_tot ./ ini.u_tot) ).^ sigma_omegaU_sect .*(Coef_real_wage_sect*CPI + (1-Coef_real_wage_sect)).*(1+phi_L).^(time_since_ini) ) ; 

endfunction


// Wage setting (implicitly determines the overall variation of net wages : NetWage_variation )
//	Wage curve on the level of the economy-wide mean nominal wage
function y = Mean_wage_Const_1(u_tot, w, lambda, Y, sigma_omegaU, CPI, Coef_real_wage); 
    w=abs(w);
    lambda = abs(lambda);
    u_tot = abs(u_tot);
    
    // Mean wage (omega).
    omega = sum (w .* lambda .* Y') / sum(lambda .* Y') ;

    // Mean wage reference (omega_ref).
    omega_ref = sum (BY.w .* BY.lambda .* BY.Y') / sum(BY.lambda .* BY.Y') ;
	
    // Wage curve
	// Coef_real_wage defined in parameter
	// Coef_real_wage = 1 => mean real wage curve 
	// Coef_real_wage = 0 => mean nominal wage curve
    // If no macroframework for projection =>  Mu = 0  
	
	y = omega  - ( omega_ref * ((u_tot / BY.u_tot)^(sigma_omegaU))*(Coef_real_wage*CPI + (1-Coef_real_wage))*(1+Mu)^(time_since_BY)) ;
      
endfunction

//	Fixed economy-wide mean wage
function y = Mean_wage_Const_2(u_tot, w, lambda, Y, sigma_omegaU)

    w=abs(w);
    lambda = abs(lambda);
    u_tot = abs(u_tot);
    
    // Mean wage (omega).
    omega = sum (w .* lambda .* Y') / sum(lambda .* Y') ;

    // Mean wage reference (omega_ref).
    omega_ref = sum (BY.w .* BY.lambda .* BY.Y') / sum(BY.lambda .* BY.Y') ;
  
    // Wage curve
	// Coef_real_wage defined in parameter
	// Coef_real_wage = 1 => mean real wage curve 
	// Coef_real_wage = 0 => mean nominal wage curve

	y = omega - ( omega_ref * (Coef_real_wage*CPI + (1-Coef_real_wage))) ;
endfunction

// Similar than Mean_wage_Const_1 but indexed by u_param instead of BY.u_tot
function y = Mean_wage_Const_3(u_tot, w, lambda, Y, sigma_omegaU, CPI, Coef_real_wage); 
    w=abs(w);
    lambda = abs(lambda);
    u_tot = abs(u_tot);
    
    // Mean wage (omega).
    omega = sum (w .* lambda .* Y') / sum(lambda .* Y') ;

    // Mean wage reference (omega_ref).
    omega_ref = sum (BY.w .* BY.lambda .* BY.Y') / sum(BY.lambda .* BY.Y') ;
    
    // Wage curve
    // Coef_real_wage defined in parameter
    // Coef_real_wage = 1 => mean real wage curve 
    // Coef_real_wage = 0 => mean nominal wage curve
    // If no macroframework for projection =>  Mu = 0  
    
    y = omega  - ( omega_ref * ((u_tot / u_param)^(sigma_omegaU))*(Coef_real_wage*CPI + (1-Coef_real_wage))*(1+Mu)^(time_since_BY)) ;
      
endfunction

// PAS POUR CALIBRAGE !
// Net wage by productive sector (w)
function [y] = Wage_Variation_Const_1(w, NetWage_variation) ;

    y1 = w - NetWage_variation * BY.w ;

    y=y1';
endfunction

function w = Wage_Variation_Val_1(NetWage_variation)

    w = NetWage_variation * BY.w;

endfunction

   function y = MeanWageVar_Const_1( w, lambda, Y, NetWage_variation)

    w=abs(w);
    lambda = abs(lambda);

    // Mean wage (omega).
    omega = sum (w .* lambda .* Y') / sum(lambda .* Y') ;

    // Mean wage reference (omega_ref).
    omega_ref = sum (BY.w .* BY.lambda .* BY.Y') / sum(BY.lambda .* BY.Y') ;

    // Wage curve. Wage bargaining over the mean wage
    y = omega - NetWage_variation * omega_ref ;

endfunction


// Labour cost (pL)
function [y] = Labour_Cost_Const_1(pL, w, Labour_Tax_rate) ;

    y1 = pL -  w .* ( ones(1, nb_Sectors) + Labour_Tax_rate );

    y=y1';
endfunction

function pL = Labour_Cost_Val_1(w, Labour_Tax_rate)

    pL =  w .* ( ones(1, nb_Sectors) + Labour_Tax_rate );

endfunction

function [y] = Labour_Cost_Const_2(pL, w, Labour_Tax_rate, Labour_Corp_Tax_rate) ;

    y1 = pL -  w .* ( ones(1, nb_Sectors) + Labour_Tax_rate + Labour_Corp_Tax_rate);

    y=y1';
endfunction

function pL = Labour_Cost_Val_2(w, Labour_Tax_rate, Labour_Corp_Tax_rate)

    pL =  w .* ( ones(1, nb_Sectors) + Labour_Tax_rate + Labour_Corp_Tax_rate);

endfunction

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
///////   D.3  Loanable funds and financial markets
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

// Current account closure

//  PAS POUR CALIBRAGE !
// Current account constraint 1: the income distribution adjusts to finance investment with fixed investment and consumption propensity of households
// The adjustment variable is: interest_rate
function [y] = MacroClosure_Const_1(GFCF_byAgent, pI, I) ;

    y1 = ( sum(GFCF_byAgent(Indice_Households)) + sum(GFCF_byAgent(Indice_Corporations)) + sum(GFCF_byAgent(Indice_Government)) ) - sum (pI .* sum(I,"c")) ;
    y=y1';
	
endfunction

// new equation Antoine pour passer GFCF_byAgent en variable intermédiaire
function [GFCF_byAgent] = GFCF_Const_1(H_disposable_income, H_Invest_propensity, Corp_disposable_income, Corp_invest_propensity, pI, I);
    y1 = Corp_disposable_income .* Corp_invest_propensity;
    y2 = sum (pI .* sum(I,"c")) - (sum(GFCF_byAgent(Indice_Households)) + sum(GFCF_byAgent(Indice_Corporations)) + sum(GFCF_byAgent(Indice_Government)));
    y3 = H_disposable_income .* H_Invest_propensity;
 
    GFCF_byAgent = [y1 y2 y3];

endfunction

//  PAS POUR CALIBRAGE !
// Homothetical adjustment of interest rates
function [y] = Interest_rate_Const_1(interest_rate, delta_interest_rate) ;

    // interest_rate for each national institutional agents (household classes, businesses and government)
    // delta_interest_rate stands for the variation of the mean interest rate
    y1 = interest_rate - delta_interest_rate * BY.interest_rate ;
    y=y1';
	
endfunction


// The previous constraint on investment flows is equivalent to the following constraint on financial flows
// function [y] = Current_account_closure(Imports_function_1, X, X_ref, pX_ref, pM_ref, pM, pX, sigma_X, interest_rate, interest_rate_ref, delta_interest_rate, NetFinancialDebt(Indice_Households), NetFinancialDebt(Indice_Corporations), NetFinancialDebt(Indice_Government), NetLending(Indice_Households), NetLending(Indice_Corporations), NetLending(Indice_Government)) ;

// M = Imports_function_1(X, X_ref, pX_ref, pM_ref, pM, pX, sigma_X) ;

// interest_rate = interest_rate_ref * delta_interest_rate ;

// World_NetLanding = sum( pM'.* M ) - sum (pX .* X) + sum(interest_rate(h1_index:hn_index) .* NetFinancialDebt) + interest_rate(Government_index) * NetFinancialDebt(Indice_Corporations) + interest_rate(Government_index) * NetFinancialDebt(Indice_Government) ;

// y1 = sum(NetLending)  ;

// y=y1';
//  endfunction


/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
///////   D.4  "Primary" and "Secondary" income distribution (Redistribution)
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

// Gross domestic product (GDP) -
function [y] = GDP_Const_1(GDP, Labour_income, GrossOpSurplus, Production_Tax, Labour_Tax, OtherIndirTax, VA_Tax, Energy_Tax_IC, Energy_Tax_FC, Carbon_Tax_IC, Carbon_Tax_C, ClimPolCompensbySect) ;

    y = GDP - (sum(Labour_income) + sum(GrossOpSurplus) + sum(Production_Tax) - sum(ClimPolCompensbySect) + sum(Labour_Tax) + sum(OtherIndirTax) + sum(VA_Tax) + sum(Energy_Tax_IC) + sum(Carbon_Tax_IC) + sum(Energy_Tax_FC) + sum(Carbon_Tax_C)) ;

endfunction

function GDP = GDP_Val_1(Labour_income, GrossOpSurplus, Production_Tax, Labour_Tax, OtherIndirTax, VA_Tax, Energy_Tax_IC, Energy_Tax_FC, Carbon_Tax_IC, Carbon_Tax_C, ClimPolCompensbySect)

    GDP = (sum(Labour_income) + sum(GrossOpSurplus) + sum(Production_Tax) - sum(ClimPolCompensbySect) + sum(Labour_Tax) + sum(OtherIndirTax) + sum(VA_Tax) + sum(Energy_Tax_IC) + sum(Carbon_Tax_IC) + sum(Energy_Tax_FC) + sum(Carbon_Tax_C));

endfunction

function [y] = GDP_Const_2(GDP, Labour_income, GrossOpSurplus, Production_Tax, Labour_Tax, Labour_Corp_Tax, OtherIndirTax, Cons_Tax, Energy_Tax_IC, Energy_Tax_FC, Carbon_Tax_IC, Carbon_Tax_C, ClimPolCompensbySect) ;

    y = GDP - (sum(Labour_income) + sum(GrossOpSurplus) + sum(Production_Tax) - sum(ClimPolCompensbySect) + sum(Labour_Tax)+sum(Labour_Corp_Tax) + sum(OtherIndirTax) + sum(Cons_Tax) + sum(Energy_Tax_IC) + sum(Carbon_Tax_IC) + sum(Energy_Tax_FC) + sum(Carbon_Tax_C)) ;

endfunction

function GDP = GDP_Val_2(Labour_income, GrossOpSurplus, Production_Tax, Labour_Tax, Labour_Corp_Tax, OtherIndirTax, Cons_Tax, Energy_Tax_IC, Energy_Tax_FC, Carbon_Tax_IC, Carbon_Tax_C, ClimPolCompensbySect)
	
    GDP = (sum(Labour_income) + sum(GrossOpSurplus) + sum(Production_Tax) - sum(ClimPolCompensbySect) + sum(Labour_Tax)+sum(Labour_Corp_Tax) + sum(OtherIndirTax) + sum(Cons_Tax) + sum(Energy_Tax_IC) + sum(Carbon_Tax_IC) + sum(Energy_Tax_FC) + sum(Carbon_Tax_C));

endfunction

// Gross operating surplus
function [y] =  GrossOpSurplus_Const_1(GrossOpSurplus, Capital_income, Profit_margin, Trade_margins, Transp_margins,  SpeMarg_rates_IC, SpeMarg_rates_C, SpeMarg_rates_X, SpeMarg_rates_I, SpeMarg_rates_G, p, alpha, Y, C, X, G, I)

    SpeMarg_IC = SpeMarg_rates_IC .* ((ones(1, nb_Sectors).*.(p')) .* alpha .* (ones(nb_Sectors, 1).*.(Y')) )';
    SpeMarg_C =  SpeMarg_rates_C .* ( (ones(1, nb_Households).*.p') .* C)';
    SpeMarg_X = SpeMarg_rates_X .* ( p' .* X )';
    SpeMarg_I= SpeMarg_rates_I .* ( p' .* sum(I,"c"))';
	SpeMarg_G= SpeMarg_rates_G .* ( p' .* G)';


    y1 = GrossOpSurplus - ( Capital_income + Profit_margin + Trade_margins + Transp_margins + sum(SpeMarg_IC, "r") + sum(SpeMarg_C, "r") + SpeMarg_X + SpeMarg_I +SpeMarg_G) ;

    y  = y1';
endfunction

// Gross operating surplus
function GrossOpSurplus = GrossOpSurplus_Val_1(Capital_income, Profit_margin, Trade_margins, Transp_margins,  SpeMarg_rates_IC, SpeMarg_rates_C, SpeMarg_rates_X, SpeMarg_rates_I, SpeMarg_rates_G, p, alpha, Y, C, X, G, I)

    SpeMarg_IC = SpeMarg_rates_IC .* ((ones(1, nb_Sectors).*.(p')) .* alpha .* (ones(nb_Sectors, 1).*.(Y')) )';
    SpeMarg_C =  SpeMarg_rates_C .* ( (ones(1, nb_Households).*.p') .* C)';
    SpeMarg_X = SpeMarg_rates_X .* ( p' .* X )';
    SpeMarg_I= SpeMarg_rates_I .* ( p' .* sum(I,"c"))';
	 SpeMarg_G= SpeMarg_rates_G .* ( p' .* G)';

    GrossOpSurplus = Capital_income + Profit_margin + Trade_margins + Transp_margins + sum(SpeMarg_IC, "r") + sum(SpeMarg_C, "r") + SpeMarg_X + SpeMarg_I +SpeMarg_G;

endfunction


// Value-added sharing (Between labour incomes, non labour incomes, taxes)

// For calibration
// Compensation of workers by sector (net labour incomes)
function [y] = Labour_income_Const_1(Labour_income, Labour, w) ;

    y1 = Labour_income - ( Labour .* w ) ;
    y  = y1';

endfunction

function Labour_income = Labour_income_Val_1(Labour, w)

    Labour_income = ( Labour .* w );

endfunction

// For calibration
// Net profit margins by sector (Net from the valuation of fixed capital consumption)
function [y] = Profit_income_Const_1(Profit_margin, markup_rate, pY, Y) ;

    y1 = Profit_margin - ( markup_rate .* pY' .* Y' ) ;
    y  = y1';

endfunction

function Profit_margin = Profit_income_Val_1(markup_rate, pY, Y)

    Profit_margin = ( markup_rate .* pY' .* Y' );

endfunction

// For calibration
// Capital income (valuation of fixed capital consumption)
function [y] = Capital_income_Const_1(Capital_income, pK, kappa, Y) ;
	
	pK=abs(pK);
    y1 = Capital_income - ( sum(pK .* kappa .* Y', "r") ) ;
    y  = y1';

endfunction

function Capital_income = Capital_income_Val_1(pK, kappa, Y)
    
	pK=abs(pK);
    Capital_income = ( sum(pK .* kappa .* Y', "r") );

endfunction

///	proj: il faut que ça varie comme le PIB pour homothétie
/// Total amount of Other Transfers
function [y] = TotalOtherTransf_Const_1(Other_Transfers, GDP) ;

    // The total amount of Other transfers is a fraction of GDP
    y1 = sum((Other_Transfers>0).*Other_Transfers) - BY.Other_Transfers * (GDP/BY.GDP) ;

    y  = y1';
endfunction


// Extended primary income distribution (Between institutional agents: Government, businesses, households classes, rest-of-world)

// PAS POUR CALIBRAGE !
// Distribution shares (matrix: in columns, institutional agents : household classes, businesses, government ; and in rows, income sources)
function [y] = DistributShares_Const_1(Distribution_Shares, Labour_force, Unemployed) ;

    // Distribution Matrix for n households classes (hn_index), 1 aggregated government and 1 aggregated business, and 3 different sources of incomes (Labour, Non-labour (gross operating surpluses), and other transfers)
    y1 = zeros (nb_IncomeSources, nb_InstitAgents) ;

    // Distribution of labour income (endogenous)
    // Change in labour force by household class
    Labour_change = ( Labour_force - Unemployed ) ./ ( BY.Labour_force - BY.Unemployed ) ;
	

    // Share of Labour income accruing to each household class
    y1(Indice_Labour_Income, Indice_Households) = Distribution_Shares(Indice_Labour_Income, Indice_Households) - ( Labour_change .* ini.Distribution_Shares(Indice_Labour_Income, Indice_Households) ) ./ sum( Labour_change .* ini.Distribution_Shares(Indice_Labour_Income, Indice_Households) ) ;

    // Share of Labour income accruing to other institutional agents
    j=[Indice_Corporations, Indice_Government, Indice_RestOfWorld]

    y1(Indice_Labour_Income, j) = Distribution_Shares(Indice_Labour_Income, j) - BY.Distribution_Shares(Indice_Labour_Income, j) ;


    // Distribution of non-Labour incomes: Gross operating surplus (exogenous)
    y1(Indice_Non_Labour_Income, :) = Distribution_Shares(Indice_Non_Labour_Income, :) - BY.Distribution_Shares(Indice_Non_Labour_Income, :) ;

    // Distribution of other transfers incomes
    y1(Indice_Other_Transfers, :) = Distribution_Shares(Indice_Other_Transfers, :) - BY.Distribution_Shares(Indice_Other_Transfers, :) ;

    y = matrix(y1, -1 , 1) ;
endfunction

function Distribution_Shares = DistributShares_Val_1(Labour_force, Unemployed)

    // Distribution Matrix for n households classes (hn_index), 1 aggregated government and 1 aggregated business, and 3 different sources of incomes (Labour, Non-labour (gross operating surpluses), and other transfers)
    Distribution_Shares = zeros (nb_IncomeSources, nb_InstitAgents);

    // Distribution of labour income (endogenous)
    // Change in labour force by household class
    Labour_change = ( Labour_force - Unemployed ) ./ ( BY.Labour_force - BY.Unemployed );

    // Share of Labour income accruing to each household class
    Distribution_Shares(Indice_Labour_Income, Indice_Households) = ( Labour_change .* ini.Distribution_Shares(Indice_Labour_Income, Indice_Households) ) ./ sum( Labour_change .* ini.Distribution_Shares(Indice_Labour_Income, Indice_Households) );

    // Share of Labour income accruing to other institutional agents
    j = [Indice_Corporations, Indice_Government, Indice_RestOfWorld];

    Distribution_Shares(Indice_Labour_Income, j) = BY.Distribution_Shares(Indice_Labour_Income, j);

    // Distribution of non-Labour incomes: Gross operating surplus (exogenous)
    Distribution_Shares(Indice_Non_Labour_Income, :) = BY.Distribution_Shares(Indice_Non_Labour_Income, :);

    // Distribution of other transfers incomes
    Distribution_Shares(Indice_Other_Transfers, :) = BY.Distribution_Shares(Indice_Other_Transfers, :);

endfunction


// For calibration
// Distribution of incomes (according to the distribution shares)
function [y] = IncomeDistrib_Const_1(NetCompWages_byAgent, GOS_byAgent, Other_Transfers, GDP, Distribution_Shares, Labour_income, GrossOpSurplus) ;

    // Amount of labour income received by each institutional agent: NetCompWages_byAgent ( h1_index : hn_index + Government_index + businesses_index )
    y1 = NetCompWages_byAgent - Distribution_Shares(Indice_Labour_Income, : ) .* sum(Labour_income) ;
    y1 = matrix ( y1, -1, 1);

    // Amount of Gross operating surplus received by each institutional agent: GOS_byAgent ( h1_index : hn_index + Government_index + businesses_index )
    y2 = GOS_byAgent - Distribution_Shares(Indice_Non_Labour_Income, : ) .* sum(GrossOpSurplus) ;
    y2 = matrix ( y2, -1, 1);

    // Other transfers payments accruing to each agent is a share of a total amount of Other transfers
    y3 = Other_Transfers - Distribution_Shares (Indice_Other_Transfers, :) .* sum((BY.Other_Transfers>0).*BY.Other_Transfers) * (GDP/BY.GDP) ;
    y3 = matrix ( y3, -1, 1);

    y = [y1;y2;y3];

endfunction

function [NetCompWages_byAgent, GOS_byAgent, Other_Transfers] = IncomeDistrib_Val_1(GDP, Distribution_Shares, Labour_income, GrossOpSurplus)

    // Amount of labour income received by each institutional agent: NetCompWages_byAgent ( h1_index : hn_index + Government_index + businesses_index )
    NetCompWages_byAgent = Distribution_Shares(Indice_Labour_Income, : ) .* sum(Labour_income);

    // Amount of Gross operating surplus received by each institutional agent: GOS_byAgent ( h1_index : hn_index + Government_index + businesses_index )
    GOS_byAgent = Distribution_Shares(Indice_Non_Labour_Income, : ) .* sum(GrossOpSurplus);

    // Other transfers payments accruing to each agent is a share of a total amount of Other transfers
    Other_Transfers = Distribution_Shares (Indice_Other_Transfers, :) .* sum((BY.Other_Transfers>0).*BY.Other_Transfers) * (GDP/BY.GDP);

endfunction

function [NetCompWages_byAgent, GOS_byAgent, Other_Transfers] = IncomeDistrib_Val_2(GDP, Distribution_Shares, Labour_income, GrossOpSurplus)

    // Amount of labour income received by each institutional agent: NetCompWages_byAgent ( h1_index : hn_index + Government_index + businesses_index )
    NetCompWages_byAgent = Distribution_Shares(Indice_Labour_Income, : ) .* sum(Labour_income);

    // Amount of Gross operating surplus received by each institutional agent: GOS_byAgent ( h1_index : hn_index + Government_index + businesses_index )
    GOS_byAgent = Distribution_Shares(Indice_Non_Labour_Income, : ) .* sum(GrossOpSurplus);

    // Other transfers payments accruing to each agent is a share of a total amount of Other transfers
    Other_Transfers = Distribution_Shares (Indice_Other_Transfers, :) .* sum((BY.Other_Transfers>0).*BY.Other_Transfers) * (GDP/BY.GDP) + LowCarb_Transfers;

endfunction

// For calibration - review
// Distribution of incomes (according to the distribution shares)
function [y] = IncomeDistrib_Const_2(NetCompWages_byAgent, GOS_byAgent, Other_Transfers, GDP, Distribution_Shares, Labour_income, GrossOpSurplus) ;

    // Amount of labour income received by each institutional agent: NetCompWages_byAgent ( h1_index : hn_index + Government_index + businesses_index )
    y1 = NetCompWages_byAgent - Distribution_Shares(Indice_Labour_Income, : ) .* sum(Labour_income) ;
    y1 = matrix ( y1, -1, 1);

    // Amount of Gross operating surplus received by each institutional agent: GOS_byAgent ( h1_index : hn_index + Government_index + businesses_index )
    y2 = GOS_byAgent - Distribution_Shares(Indice_Non_Labour_Income, : ) .* sum(GrossOpSurplus) ;
    y2 = matrix ( y2, -1, 1);

    // Other transfers payments accruing to each agent is a share of a total amount of Other transfers
    y3 = Other_Transfers - Distribution_Shares (Indice_Other_Transfers, :) .* sum((Other_Transfers_ref>0).*Other_Transfers_ref) ;
    y3 = matrix ( y3, -1, 1);

    y = [y1;y2;y3];

endfunction

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
///////   D.2  Capital market
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////


///  Calibration of Capital Consumption according to Capital Stock endowment
function Capital_consumption = CapitalCons_Dyn_Val_0 ( Capital_income, Capital_endowment)

Capital_consumption = Capital_endowment .* (Capital_income./sum(Capital_income));

endfunction

///  Capital Stock endowment: inter period calculation of Capital_endowment (1,1)
function y = Capital_Dynamic_Const_1 ( Capital_endowment )
	
	if Capital_Dynamics
		y = Capital_endowment - (ini.Capital_endowment * ( 1- depreciation_rate ) + sum (ini.I));
		// y = u_tot - BY.u_tot ;
	else 	
		y = Capital_endowment - BY.Capital_endowment ; 
	end
	
endfunction

///  Capital Stock endowment: inter period calculation of Capital_endowment (1,1)
function Capital_endowment = Capital_Dynamic_Val_1 ( )
	
	if Capital_Dynamics
		Capital_endowment = ini.Capital_endowment * ( 1- depreciation_rate ) + sum (ini.I);
	else 	
		Capital_endowment = BY.Capital_endowment ; 
	end
	
endfunction


//  Demands of capital productions balance out capital endowment K adjusting r as rental price (r unique price)
function y = Capital_Market_Const_1 (Capital_endowment, kappa, Y, pRental)
	if Capital_Dynamics
		
		// If exogenous unemployment rate, capital stock constraint is substitute for an unemployment rate constraint
		if ~Exo_u_tot
			if ~Exo_Kstock_Adj 
				y = Capital_endowment - sum (kappa.*Y');
			else
				y = Capital_endowment * ( 1 + Proj_Macro.delta_Kstock_Adj(time_step) ) - sum (kappa.*Y');
			end
			
		else
			y =  u_tot - Proj_Macro.u_tot (time_step) ;
		end 
		// y = Capital_endowment *( 1+ delta)  - sum (kappa.*Y');
	else
		y = pRental - BY.pRental;
	end
endfunction


///  Used to calibrate a trajectory of Invesment that stabilise unemployment
// - > substitute with the equation of capital  stock : capital endowment is caculated to maintain a unemployment constant
function u_tot = Unemployment_Val_2 ( )
	// u_tot = BY.u_tot ;	
	 u_tot = Proj_Macro.u_tot (time_step) 
endfunction

function [I_obj,I_obj_value,shareI_GDP_obj] = Post_InvestTraj_Val_1 ()

		I_obj = d.Capital_endowment - ( 1 - depreciation_rate)*ini.Capital_endowment;
		Iobj_sect = share_Ii .* I_obj; 
		// adapter a matrix invest
		I_obj_value = sum(Iobj_sect .* pI);
		shareI_GDP_obj = I_obj_value/GDP;

endfunction


/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// E)  Environmental equations
//////////////////////////////////////

// CO2 intensity function for intermediate consumption

function [y] = CO2_intensity_IC( CO2Emis_IC, Emission_Coef_IC , IC)
    y1 = CO2Emis_IC - Emission_Coef_IC .* IC ;

    y = matrix(y1,-1 , 1) ;
endfunction

function CO2Emis_IC = CO2_intensity_IC_Val_1( Emission_Coef_IC , IC)
   CO2Emis_IC = Emission_Coef_IC .* IC ;

endfunction

// CO2 intensity function for final consumption (households)

function [y] = CO2_intensity_C( CO2Emis_C, Emission_Coef_C , C)
    y1 = CO2Emis_C - Emission_Coef_C .* C ;
    y = matrix(y1, -1 , 1) ;
endfunction

function CO2Emis_C = CO2_intensity_C_Val_1(  Emission_Coef_C , C)
    CO2Emis_C = Emission_Coef_C .* C ;

endfunction

/////////// CO2 intensity applied for BORDER TAX ADJUSMENT
// First case, Emiss Coef given to M are those of domestic intermediate consumption ( co2/tep)
function Emission_Coef_M = CO2_intensity_M_Val_1(  CO2Emis_IC , IC)
    Emission_Coef_M =  divide(sum(CO2Emis_IC,"r") ,sum(IC(Indice_Sectors,:),"r"),0);

endfunction



///// Exogenous emissions

// Emissions fixed by a reduction objective- Intermediate Consumption Emissions 
function [y] = CapCO2_IC_Const_1( CO2Emis_IC, CO2Emis_IC_ref, CarbonCap_IC )
    y1 = CO2Emis_IC - (1-CarbonCap_IC).*CO2Emis_IC_ref;
    y = matrix(y1,-1 , 1) ;
endfunction

function CO2Emis_IC = CapCO2_IC_Val_1( )
   CO2Emis_IC = (1-CarbonCap_IC).*BY.CO2Emis_IC;
endfunction


// Emissions fixed by a reduction objective  - Intermediate Consumption Emissions  \\ [1, sect dimension] 
function [y] = CapCO2_IC_tot( CO2Emis_IC, CO2Emis_IC_ref, CarbonCap_sect )

	CO2Emis_IC_tot = sum(CO2Emis_IC,"r"); 
	CO2Emis_IC_tot_ref = sum(CO2Emis_IC_ref,"r"); 
	
    y1 = CO2Emis_IC_tot - (1-CarbonCap_sect).*CO2Emis_IC_tot_ref;
    y = matrix(y1,-1 , 1) ;
endfunction

// DImensions (nb_Commodities*1)
function y = CarbonCap_sect_Const_1(CarbonCap_sect, CarbonCap, CarbonCap_Diff_sect) ;
    y1 = CarbonCap_sect - CarbonCap * CarbonCap_Diff_sect ;
    y = matrix(y1, -1 , 1) ;
endfunction

// DImensions (nb_Commodities*nb_Sectors)
function y = CarbonCap_IC_Const_1(CarbonCap_IC, CarbonCap, CarbonCap_Diff_IC) ;
    y1 = CarbonCap_IC - CarbonCap * CarbonCap_Diff_IC ;
    y = matrix(y1, -1 , 1) ;
endfunction

// Emissions fixed by a reduction objective - Final Consumption Emissions
function [y] = CapCO2_C_Const_1( CO2Emis_C, CO2Emis_C_ref, CarbonCap_C )
    y1 = CO2Emis_C - (1-CarbonCap_C).*CO2Emis_C_ref;
    y = matrix(y1,-1 , 1) ;
endfunction

function CO2Emis_C = CapCO2_C_Val_1( )
   CO2Emis_C = (1-CarbonCap_C).*BY.CO2Emis_C;
   
endfunction

/// Dimension (1*nb_Households)
function [y] = CapCO2_C_tot( CO2Emis_C, CO2Emis_C_ref, CarbonCap_HH )

	CO2Emis_C_tot = sum(CO2Emis_C,"r");
	CO2Emis_C_tot_ref = sum(CO2Emis_C_ref,"r"); 

    y1 = CO2Emis_C_tot - (1-CarbonCap_HH).*CO2Emis_C_tot_ref;
    y = matrix(y1,-1 , 1) ;
endfunction

/// Dimension (1*nb_Households)
function y = CarbonCap_HH_Const_1(CarbonCap_HH, CarbonCap, CarbonCap_Diff_HH) ;
    y1 = CarbonCap_HH - CarbonCap * CarbonCap_Diff_HH ;
    y = matrix(y1, -1 , 1) ;
endfunction
/// Dimension (nb_Commodities*nb_Households)
function y = CarbonCap_C_Const_1(CarbonCap_C, CarbonCap, CarbonCap_Diff_C) ;
    y1 = CarbonCap_C - CarbonCap * CarbonCap_Diff_C ;
    y = matrix(y1, -1 , 1) ;
endfunction


/// Closure carbon cap (Brasil)
function Carbon_Tax_rate_IC = CTax_rate_pIC_Val_1(Transp_margins_rates, Trade_margins_rates ,SpeMarg_rates_IC, pIC, Cons_Tax_rate, p, Energy_Tax_rate_IC, OtherIndirTax_rate, Emission_Coef_IC, CO2Emis_IC)

	//  Trade, transport and specific margins for energy
    margins_rates = ones(1,nb_Sectors).*. (Transp_margins_rates' + Trade_margins_rates') + SpeMarg_rates_IC' ;


	Carbon_Tax_rate_IC = zeros(nb_Sectors,nb_Sectors);
    Carbon_Tax_rate_IC = (CO2Emis_IC==0).*0
	Carbon_Tax_rate_IC = Carbon_Tax_rate_IC + (CO2Emis_IC<>0).* divide(((pIC./(1 + (ones( 1, nb_Sectors).*.Cons_Tax_rate'))) - ( (ones(1, nb_Sectors).*.p') .* ( 1 + margins_rates )) -  (ones(1,nb_Sectors).*.(Energy_Tax_rate_IC' + OtherIndirTax_rate'))),Emission_Coef_IC,0);
	
	// Carbon_Tax_rate_IC = abs(Carbon_Tax_rate_IC);
endfunction

/// Closure carbon cap 
function Carbon_Tax_rate_IC = CTax_rate_pIC_Val_2(Transp_margins_rates, Trade_margins_rates ,SpeMarg_rates_IC, pIC, p, Energy_Tax_rate_IC, OtherIndirTax_rate, Emission_Coef_IC, CO2Emis_IC)

	//  Trade, transport and specific margins for energy
    margins_rates = ones(1,nb_Sectors).*. (Transp_margins_rates' + Trade_margins_rates') + SpeMarg_rates_IC' ;


	Carbon_Tax_rate_IC = zeros(nb_Sectors,nb_Sectors);
    Carbon_Tax_rate_IC = (CO2Emis_IC==0).*0
	Carbon_Tax_rate_IC = Carbon_Tax_rate_IC + (CO2Emis_IC<>0).* divide( pIC - ((ones(1, nb_Sectors).*.p').* ( 1 + margins_rates )) - (ones(1,nb_Sectors).*.(Energy_Tax_rate_IC' + OtherIndirTax_rate')),Emission_Coef_IC,0);

endfunction






