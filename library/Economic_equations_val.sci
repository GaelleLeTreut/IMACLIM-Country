/// Household_income_1 
function H_disposable_income = H_Income_Const_1_val(NetCompWages_byAgent, GOS_byAgent, Pensions, Unemployment_transfers, Other_social_transfers, Other_Transfers, ClimPolicyCompens, Property_income, Income_Tax, Other_Direct_Tax) ;

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

/// Pensions by household class
function Pensions = Pensions_Const_1_val(Pension_Benefits, Retired)

    // Pension payments accruing to each household class, function of the level pension benefit and the number of pensioners
    Pensions = Pension_Benefits .* Retired  ;

endfunction

/// Unemployment transfers by household class
function Unemployment_transfers = Unemploy_Transf_Const_1_val(UnemployBenefits, Unemployed) ;

    // Unemployment payments accruing to each household class, function of the level unemployment benefit and the number of unemployed
    Unemployment_transfers = UnemployBenefits .* Unemployed ;

endfunction

/// Other social transfers by household class
function Other_social_transfers = OtherSoc_Transf_Const_1_val(Other_SocioBenef, Population) ;

    // Other social transfers payments accruing to each household class, function of the level other social benefits and the number of people
    Other_social_transfers = Other_SocioBenef .* Population ;

endfunction

// Property income
function Property_income = Property_income_val(interest_rate, NetFinancialDebt)
    
    Property_income(Indice_Households) = - interest_rate(Indice_Households) .* NetFinancialDebt(Indice_Households);
    Property_income(Indice_Corporations) = - interest_rate(Indice_Corporations) .* NetFinancialDebt(Indice_Corporations);
    Property_income(Indice_Government) = - interest_rate(Indice_Government) .* NetFinancialDebt(Indice_Government);
    Property_income(Indice_RestOfWorld) = - (Property_income(Indice_Corporations) + sum(Property_income(Indice_Households)) + Property_income(Indice_Government));
    
endfunction

/// Household_savings_constraint_1 : Proportion of disposable income (saving rate)
function Household_savings = H_Savings_Const_1_val(H_disposable_income, Household_saving_rate) ;

    /// Household savings constraint (Household_savings)
    Household_savings = (H_disposable_income .* Household_saving_rate) ;
		
endfunction

/// Corporations_savings_constraint_1: All disposable incomes are savings (used to finance auto-investment or lent: NetLending(Indice_Corporations))
function Corporations_savings = Corp_savings_Const_1_val(Corp_disposable_income)

    /// Corporations savings constraint (Corporations_savings)
    Corporations_savings = Corp_disposable_income ;
		
endfunction

function Government_savings = G_savings_Const_1_val(G_disposable_income, G_Consumption_budget) ;

    /// Government savings constraint (Government_savings)
    Government_savings = (G_disposable_income - G_Consumption_budget) ;

endfunction

