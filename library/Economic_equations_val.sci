
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


