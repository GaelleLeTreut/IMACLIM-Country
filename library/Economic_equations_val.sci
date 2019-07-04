/// Household_income_1 
function H_disposable_income = H_Income_1_val(NetCompWages_byAgent, GOS_byAgent, Pensions, Unemployment_transfers, Other_social_transfers, Other_Transfers, ClimPolicyCompens, Property_income, Income_Tax, Other_Direct_Tax)

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
function Pensions = Pensions_1_val(Pension_Benefits, Retired)

    // Pension payments accruing to each household class, function of the level pension benefit and the number of pensioners
    Pensions = Pension_Benefits .* Retired  ;

endfunction

/// Unemployment transfers by household class
function Unemployment_transfers = Unemploy_Transf_1_val(UnemployBenefits, Unemployed)

    // Unemployment payments accruing to each household class, function of the level unemployment benefit and the number of unemployed
    Unemployment_transfers = UnemployBenefits .* Unemployed ;

endfunction

/// Other social transfers by household class
function Other_social_transfers = OtherSoc_Transf_1_val(Other_SocioBenef, Population)

    // Other social transfers payments accruing to each household class, function of the level other social benefits and the number of people
    Other_social_transfers = Other_SocioBenef .* Population ;

endfunction

// Property income
function Property_income = Property_income_val(interest_rate, NetFinancialDebt)
    
    Property_income(Indice_Households) = - interest_rate(Indice_Households) .* NetFinancialDebt(Indice_Households);
    Property_income(Indice_Corporations) = - interest_rate(Indice_Corporations) .* NetFinancialDebt(Indice_Corporations);
    Property_income(Indice_Government) = - interest_rate(Indice_Government) .* NetFinancialDebt(Indice_Government);
    Property_income(Indice_RestOfWorld) = - (Property_income(Indice_Corporations) + sum(Property_income(Indice_Households)) + Property_income(Indice_Government));
    
    Property_income = Property_income';
    
endfunction

/// Household_savings_constraint_1 : Proportion of disposable income (saving rate)
function Household_savings = H_Savings_1_val(H_disposable_income, Household_saving_rate)

    /// Household savings constraint (Household_savings)
    Household_savings = (H_disposable_income .* Household_saving_rate) ;
		
endfunction

/// Corporations_savings_constraint_1: All disposable incomes are savings (used to finance auto-investment or lent: NetLending(Indice_Corporations))
function Corporations_savings = Corp_savings_1_val(Corp_disposable_income)

    /// Corporations savings constraint (Corporations_savings)
    Corporations_savings = Corp_disposable_income ;
		
endfunction

function Government_savings = G_savings_1_val(G_disposable_income, G_Consumption_budget)

    /// Government savings constraint (Government_savings)
    Government_savings = (G_disposable_income - G_Consumption_budget) ;

endfunction

// GFCF_byAgent
function GFCF_byAgent = GFCF_byAgent_val(H_disposable_income, H_Invest_propensity, G_disposable_income, G_invest_propensity, GDP, pI, I)
    
    /// Household_investment_constraint_1 : Proportion of disposable income ('propensity' to invest)
    GFCF_byAgent(Indice_Households) = (H_disposable_income .* H_Invest_propensity);
    /// Government_investment_constraint_2 : Proportion of GDP
    GFCF_byAgent(Indice_Government) = ini.GFCF_byAgent(Indice_Government)*(GDP/ini.GDP);
    // Current account closure
    GFCF_byAgent(Indice_Corporations) = sum (pI .* sum(I,"c")) - GFCF_byAgent(Indice_Households) - GFCF_byAgent(Indice_Government);
    
    GFCF_byAgent = GFCF_byAgent';
    
endfunction

// NetLending
function NetLending = NetLending_val(GFCF_byAgent, Household_savings, Corporations_savings)
    
    NetLending(Indice_Households) = (Household_savings - GFCF_byAgent(Indice_Households));
    NetLending(Indice_Corporations) = (Corporations_savings - GFCF_byAgent(Indice_Corporations));
    NetLending(Indice_Government) = (Government_savings - GFCF_byAgent(Indice_Government));
    NetLending(Indice_RestOfWorld) = ( sum(pM .* M) - sum(pX .* X) + Property_income(Indice_RestOfWorld) + Other_Transfers(Indice_RestOfWorld) );
    
    NetLending = NetLending';
    
endfunction

// NetFinancialDebt
function NetFinancialDebt = NetFinancialDebt_val() //time_since_ini, NetLending)
    
    NetFinancialDebt(Indice_Households) = BY.NetFinancialDebt(Indice_Households);
    NetFinancialDebt(Indice_Corporations) = BY.NetFinancialDebt(Indice_Corporations);
    NetFinancialDebt(Indice_Government) = BY.NetFinancialDebt(Indice_Government);
    NetFinancialDebt(Indice_RestOfWorld) = BY.NetFinancialDebt(Indice_RestOfWorld);
    
    NetFinancialDebt = NetFinancialDebt';
    
endfunction

/// Household Total consumption budget
function Consumption_budget = ConsumBudget_1_val(H_disposable_income, Household_saving_rate)

    /// Source of consumption budget - Share of disposable income (by household class)
    Consumption_budget = H_disposable_income .* (1 - Household_saving_rate);
	
endfunction

/// Corporations_income_1 :
function Corp_disposable_income = Corp_income_1_val(GOS_byAgent, Other_Transfers, Property_income , Corporate_Tax)

    // Income by sources, redistribution and tax payments
    Corp_Non_Labour_Income =  GOS_byAgent (Indice_Corporations);
    Corp_Other_Income      =  Other_Transfers(Indice_Corporations);
    Corp_Property_income   =  Property_income(Indice_Corporations);
    Corp_Tax_Payments      =  Corporate_Tax;

    // After tax disposable income constraint (H_disposable_income)
    Corp_disposable_income = (Corp_Non_Labour_Income + Corp_Other_Income + Corp_Property_income - Corp_Tax_Payments);

endfunction

/// Government_income_1 :
function G_disposable_income = G_income_1_val(Income_Tax, Other_Direct_Tax, Corporate_Tax, Production_Tax, Labour_Tax, Energy_Tax_IC, Energy_Tax_FC, OtherIndirTax, VA_Tax, Carbon_Tax_IC, Carbon_Tax_C, GOS_byAgent, Pensions, Unemployment_transfers, Other_social_transfers, Other_Transfers, Property_income , ClimPolicyCompens, ClimPolCompensbySect)

    // For one government. Distribution among different government must otherwise be specified.

    // Income by sources, redistribution and tax revenue
    G_Tax_revenue   = sum(Income_Tax + Other_Direct_Tax) + sum( Corporate_Tax ) + sum(Production_Tax + Labour_Tax + OtherIndirTax + VA_Tax) + sum(Energy_Tax_IC) + sum(Carbon_Tax_IC) + sum(Energy_Tax_FC) + sum(Carbon_Tax_C) ;
    G_Non_Labour_Income =  GOS_byAgent (Indice_Government) ;
    G_Other_Income      =  Other_Transfers (Indice_Government) ;
    G_Property_income   =  Property_income(Indice_Government) ;
    G_Social_Transfers  =  sum(Pensions + Unemployment_transfers + Other_social_transfers) ;
    G_Compensations     =  sum(ClimPolicyCompens(Indice_Households)) + sum(ClimPolicyCompens(Indice_Corporations)) + sum (ClimPolCompensbySect) ;

    // After tax disposable income constraint (H_disposable_income)
    G_disposable_income = (G_Tax_revenue + G_Non_Labour_Income + G_Other_Income + G_Property_income - G_Social_Transfers - G_Compensations);

endfunction

/// Corporate Tax (by Corporations)
function Corporate_Tax = Corporate_Tax_1_val(Corporate_Tax_rate, GOS_byAgent)

    // Corporate Tax ( Corporate_Tax(1:nb_Corporations) )
    Corporate_Tax = Corporate_Tax_rate .* GOS_byAgent(Indice_Corporations);

endfunction

/// Production Tax (by productive sector)
function Production_Tax = Production_Tax_1_val(Production_Tax_rate, pY, Y)
	pY= abs(pY);
    // Production Tax ( Production_Tax(1:nb_Commodities) )
    Production_Tax = Production_Tax_rate .* (pY .* Y)';

    //if Y=0 Production_tax_rate =0
    // y1_1 = (Y'==0).*(Production_Tax_rate);
    // y1_2 = (Y'<>0).*(Production_Tax - (Production_Tax_rate .* pY' .* Y'));
    // y1 = (Y'==0).*y1_1  + (Y'<>0).*y1_2;
endfunction

/// Labour Tax (by productive sector)
function Labour_Tax = Labour_Tax_1_val(Labour_Tax_rate, w, lambda, Y)

    // Labour Tax ( Labour_Tax(nb_Sectors) )
    Labour_Tax = (Labour_Tax_rate .* w .* lambda .* Y');

    // y1_1 = (Y'==0).*(Labour_Tax_rate);
    // y1_2 = (Y'<>0).*(Labour_Tax - (Labour_Tax_rate .* w .* lambda .* Y'));
    // y1 = (Y'==0).*y1_1  + (Y'<>0).*y1_2;

endfunction

/// Energy Tax on intermediate energy consumptions (by energy product-by sector)
/// Differentiated rates by consumer type.
function Energy_Tax_IC = Energy_Tax_IC_1_val(Energy_Tax_rate_IC, alpha, Y)

    // Same rate for all sectors
    // y = Energy_Tax_IC' - Energy_Tax_rate_IC' .* sum( alpha .* repmat(Y', nb_Commodities, 1), "c") ;
    Energy_Tax_IC = ( Energy_Tax_rate_IC' .* sum( alpha .*(ones(nb_Commodities, 1).*.Y'), "c") )';

endfunction

/// Energy Tax on final energy consumptions (by energy product-by consumer)
/// Differentiated rates by consumer type.
function Energy_Tax_FC = Energy_Tax_FC_1_val(Energy_Tax_rate_FC, C)

    // Same rates for all household classes
    // Energy_Tax_rate = repmat(Energy_Tax_rate_FC',1, nb_Households);
    // Energy_Tax_rate = ones(1, nb_Households).*.Energy_Tax_rate_FC';

    // Energy Tax paid by final energy consumers: Energy_Tax_FC (nb_Sectors, nb_Households)
    Energy_Tax_FC = ( Energy_Tax_rate_FC'.* sum( C , "c" ) )';


endfunction

/// Other indirect Tax on both Intermediate consumptions and Final consumptions - same rate-  (by product-sector)
function OtherIndirTax = OtherIndirTax_1_val(OtherIndirTax_rate, alpha, Y, C, G, I)

    // Same rates for all sectors

    // y = OtherIndirTax' - OtherIndirTax_rate' .* (sum(alpha.*repmat(Y', nb_Commodities, 1),"c")+sum( C,"c")+sum(G,"c")+I) ;
    OtherIndirTax = ( OtherIndirTax_rate' .* (sum(alpha .*(ones(nb_Commodities, 1).*.Y'),"c")+sum( C,"c")+sum(G,"c")+sum(I, "c")) )';

endfunction

/// Value Added Tax (by product-sector)
function VA_Tax = VA_Tax_1_val(VA_Tax_rate, pC, C, pG, G, pI, I)

    // Same rate for all items of domestic final demand
    VA_Tax = ( (VA_Tax_rate' ./ (1 + VA_Tax_rate')) .* (sum( pC .* C, "c") + sum(pG .* G, "c") + pI .* sum(I, "c")) )';

    //if VA_Tax =0 => VA_Tax_rate=0
    // y_1 = (VA_Tax' ==0).*VA_Tax_rate';
    // y_2 = (VA_Tax' <>0).*( VA_Tax' - ( (VA_Tax_rate' ./ (1 + VA_Tax_rate')) .* (sum( pC .* C, "c") + sum(pG .* G, "c") + pI .* I)));
    // y =(VA_Tax' ==0).*y_1 +  (VA_Tax' <>0).*y_2;

endfunction

/// Carbon Tax on intermediate energy consumptions (by energy product-by sector)
/// Identical or differentiated rates by consumer type.
function Carbon_Tax_IC = Carbon_Tax_IC_1_val(Carbon_Tax_rate_IC, alpha, Y, Emission_Coef_IC)

    // Tax rates potentially differs across sectors
    // y1 = Carbon_Tax_IC - ( Carbon_Tax_rate_IC .* Emission_Coef_IC .* alpha .* repmat(Y', nb_Commodities, 1) ) ;

    Carbon_Tax_IC = ( Carbon_Tax_rate_IC .* Emission_Coef_IC .* alpha .*(ones(nb_Commodities, 1).*.Y') );

    //if  Emission_Coef_IC = 0 => Carbon_Tax_rate_IC = 0
    // y1_1 = (Emission_Coef_IC==0).*(Carbon_Tax_rate_IC);
    // y1_2 =(Emission_Coef_IC<>0).*(Carbon_Tax_IC - ( Carbon_Tax_rate_IC .* Emission_Coef_IC .* alpha .* repmat(Y', nb_Commodities, 1) ));

    // y1 = (Emission_Coef_IC==0).*y1_1 + (Emission_Coef_IC<>0).*y1_2 ;

endfunction

/// Carbon Tax on final energy consumptions (by energy product-by consumer)
/// Identical or differentiated rates by consumer type.
function Carbon_Tax_C = Carbon_Tax_C_1_val(Carbon_Tax_rate_C, C, Emission_Coef_C)

    // Tax rates potentially differs across household classes
    Carbon_Tax_C = ( Carbon_Tax_rate_C .* Emission_Coef_C .* C );

    //if  Emission_Coef_C = 0 => Carbon_Tax_rate_C = 0
    // y1_1 = (Emission_Coef_C==0).*(Carbon_Tax_rate_C);
    // y1_2 =(Emission_Coef_C<>0).*(Carbon_Tax_C - ( Carbon_Tax_rate_C .* Emission_Coef_C .* C ));

    // y1 = (Emission_Coef_C==0).*y1_1 + (Emission_Coef_C<>0).*y1_2 ;

endfunction

///	proj: il faut que ça varie comme le PIB pour homothétie
function Pension_Benefits = Pension_Benefits_2_val(Pension_Benefits_param, GDP)

    // Pension benefits Constraint ( Pension_Benefits(h1_index:hn_index) )
    Pension_Benefits = (GDP/BY.GDP) * Pension_Benefits_param;

endfunction

/// Unemployment benefits (by household class)
function UnemployBenefits = UnemployBenefits_1_val(NetWage_variation, UnemployBenefits_param)

    // Unemployment benefits Constraint ( UnemployBenefits(nb_Households) )
    UnemployBenefits = NetWage_variation * UnemployBenefits_param;

endfunction

///	proj: il faut que ça varie comme le PIB pour homothétie
// peut être dimensionner avec l'évolution du nbre de chômeurs
function Other_SocioBenef = Other_SocioBenef_2_val(Other_SocioBenef_param, GDP, Population)

    // Other social benefits Constraint ( Other_SocioBenef(nb_Households) )
    Other_SocioBenef = (GDP / BY.GDP) * ( BY.Population ./ Population ) .* Other_SocioBenef_param;

endfunction

/// Carbon tax on productive sectors (intermediate energy consumptions)
function Carbon_Tax_rate_IC = CTax_rate_IC_1_val(Carbon_Tax_rate, CarbonTax_Diff_IC)

    // Matrix of carbon tax rates (intermediates consumption of energy, sectors)
    // Unique carbon tax
    Carbon_Tax_rate_IC = Carbon_Tax_rate * CarbonTax_Diff_IC;

endfunction

/// Carbon tax on households (final energy consumptions)
function Carbon_Tax_rate_C = CTax_rate_C_1_val(Carbon_Tax_rate, CarbonTax_Diff_C)

    // Matrix of carbon tax rates (final consumption of energy, household classes)
    // Unique carbon tax
    Carbon_Tax_rate_C = Carbon_Tax_rate * CarbonTax_Diff_C;

endfunction

/// Transfert to households
function ClimPolicyCompens = ClimCompensat_1_val()
    // /// No new direct compensations to households

    ClimPolicyCompens = BY.ClimPolicyCompens;

endfunction

/// Transfert to productive sectors
function ClimPolCompensbySect = S_ClimCompensat_1_val()
    
    /// No new direct compensations to sectors
    ClimPolCompensbySect = BY.ClimPolCompensbySect;

endfunction

// No recycling revenues in labour tax
function Labour_Tax_Cut = RevenueRecycling_1_val()

    // The constraint is used for the calculation of the tax rebate (Labour_Tax_Cut, cf. Labour_Tax_constraint above).
    // Same rebate for all sectors.
    Labour_Tax_Cut = 0;
    
endfunction

// Ex-post labour tax rate
function Labour_Tax_rate = Labour_Taxe_rate_1_val(LabTaxRate_BeforeCut, Labour_Tax_Cut)

    Labour_Tax_rate = LabTaxRate_BeforeCut - Labour_Tax_Cut * ones(1, nb_Sectors);
    
endfunction

///	proj : utiliser G_ConsumpBudget_Const_2 + G_demand_Const_2
/// Government Total consumption budget 
	////- Constant proportion of GDP
function G_Consumption_budget = G_ConsumpBudget_2_val(GDP)

    /// Public consumption budget - Proportion of GDP
    G_Consumption_budget = (GDP/BY.GDP) *  BY.G_Consumption_budget;
    
endfunction

/// General technical progress
function Phi =  TechnicProgress_1_val()
    
    Phi = ones(1, nb_Sectors);

endfunction

/// General decreasing return
function Theta =  DecreasingReturn_1_val()

    Theta =  ones(1, nb_Sectors);

endfunction

// Transport margins
function Transp_margins =  Transp_margins_1_val(Transp_margins_rates, p, alpha, Y, C, G, I, X)

    // y1 = Transp_margins - Transp_margins_rates .* p.* ( sum(alpha .* repmat(Y', nb_Commodities, 1),"c") + sum(C, "c") + sum(G, "c") + I + X )' ;

    Transp_margins = Transp_margins_rates .* p.* ( sum( alpha .*(ones(nb_Commodities, 1).*.Y'), "c") + sum(C, "c") + sum(G, "c") + sum(I, "c") + X )';

endfunction

// Trade margins
function Trade_margins =  Trade_margins_1_val(Trade_margins_rates, p, alpha, Y, C, G, I, X)

    // y1 = Trade_margins - Trade_margins_rates .* p.* ( sum(alpha .* repmat(Y', nb_Commodities, 1),"c") + sum(C, "c") + sum(G, "c") + I + X )' ;

    Trade_margins = Trade_margins_rates .* p.* ( sum( alpha .*(ones(nb_Commodities, 1).*.Y'), "c") + sum(C, "c") + sum(G, "c") + sum(I, "c") + X )';

endfunction

// Entrepreneurs' investment demand equals to an exogenous proportion of fixed capital depreciation
// Constant composition in goods of capital
function I = Invest_demand_1_val(Betta, kappa, Y)
    // Capital expansion coefficient ( Betta ( nb_Sectors) ).
    // This coefficient gives : 1) The incremental level of investment as a function of capital depreciation, and 2) the composition of the fixed capital formation

    if Invest_matrix then
        I = Betta .* ((kappa.* Y') .*. ones(nb_Commodities,1));
    else
        I = Betta * sum( kappa .* Y' );
    end

endfunction

// PAS POUR CALIBRAGE //
// Capital cost (pK)
function pK = Capital_Cost_1_val(pI, I)

    // y = pK' - sum(pI .* I) ./ repmat( sum(I), nb_Sectors, 1) ;
    if Invest_matrix then
        pK = sum((pI*ones(1,nb_Sectors)).* I,"r") ./ sum(I,"r");
    else 
        pK = ( sum(pI .* I) ./ (ones(nb_Sectors, 1).*.sum(I)) )';
    end
    

endfunction


// For calibration
// Total intermediate consumptions in quantities: IC (Sm_index, Sm_index)
function IC = IC_1_val(Y, alpha)

    // y1 = IC - ( alpha .* repmat(Y', nb_Commodities, 1) ) ;

    IC = ( alpha .* (ones(nb_Commodities, 1).*.Y') ) ;

    //If IC= 0 => alpha = 0
    // y1_1 = (IC==0).*(alpha) ;
    // y1_2 = (IC<>0).*(IC - (alpha .* repmat(Y', nb_Commodities, 1)) )
    // y1 = (IC==0).*y1_1 + (IC<>0).*y1_2

    if isdef('Proj') & Proj.IC.apply_proj then
        IC = apply_proj_val(IC, 'IC');
    end

endfunction

// Total Fixed Capital Consumption in quantities: Capital_consumption (nb_Sectors)
function Capital_consumption = Capital_Consump_1_val(Y, kappa)

    Capital_consumption = ( kappa .* Y' );

endfunction

// Export price, after trade, transport and energy margins (no indirect taxation)
function pX = pX_price_1_val(Transp_margins_rates, Trade_margins_rates, SpeMarg_rates_X, p)

    //  Trade, transport and specific margins for energy
    margins_rates = Transp_margins_rates' + Trade_margins_rates' + SpeMarg_rates_X';

    // Export price
    pX =  p' .* (ones(nb_Commodities, 1) + margins_rates);
    
endfunction

// For calibration
// Employment by productive sector
function Labour = Employment_1_val(lambda, Y)

    Labour = ( lambda .* Y' );
    //if Labour=0 => lambda = 0
    // y1_1 = (Labour==0).*(lambda);
    // y1_2 = (Labour<>0).*(Labour - ( lambda .* Y') );
    // y1 = (Labour==0).*y1_1 +(Labour<>0).*y1_2;

endfunction

// PAS POUR CALIBRAGE !
// Net wage by productive sector (w)
function w = Wage_Variation_1_val(NetWage_variation)

    w = NetWage_variation * BY.w;

endfunction

// Unemployment by households class
function u = HH_Unemployment_1_val(u_tot)
    
	u_tot = abs(u_tot);
    u = ini.u * ( u_tot / ini.u_tot );

endfunction

// Unemployment rate and Number of unemployed by household class
function Unemployed = HH_Employment_1_val(u, Labour_force)
    
	u= abs(u);
    // Number of unemployed ( Unemployed (nb_Households) )
    Unemployed = (u .* Labour_force);

endfunction

// Labour cost (pL)
function pL = Labour_Cost_1_val(w, Labour_Tax_rate)

    pL =  w .* ( ones(1, nb_Sectors) + Labour_Tax_rate );

endfunction

// Gross domestic product (GDP) -
function GDP = GDP_1_val(Labour_income, GrossOpSurplus, Production_Tax, Labour_Tax, OtherIndirTax, VA_Tax, Energy_Tax_IC, Energy_Tax_FC, Carbon_Tax_IC, Carbon_Tax_C, ClimPolCompensbySect)

    GDP = (sum(Labour_income) + sum(GrossOpSurplus) + sum(Production_Tax) - sum(ClimPolCompensbySect) + sum(Labour_Tax) + sum(OtherIndirTax) + sum(VA_Tax) + sum(Energy_Tax_IC) + sum(Carbon_Tax_IC) + sum(Energy_Tax_FC) + sum(Carbon_Tax_C));

endfunction

// For calibration
// Compensation of workers by sector (net labour incomes)
function Labour_income = Labour_income_1_val(Labour, w)

    Labour_income = ( Labour .* w );

    // if Labour =0 => w=0
    // y1_1 = (Labour==0).*(w);
    // y1_2 = (Labour<>0).*( Labour_income - ( Labour .* w ));
    // y1 = (Labour==0).*y1_1  + (Labour<>0).*y1_2;

endfunction

// For calibration
// Net profit margins by sector (Net from the valuation of fixed capital consumption)
function Profit_margin = Profit_income_1_val(markup_rate, pY, Y)

    Profit_margin = ( markup_rate .* pY' .* Y' );

    // if Profit_margin = 0 => markup_rate = 0
    // y1_1 = (Profit_margin==0).*markup_rate;
    // y1_2 = (Profit_margin<>0).* ( Profit_margin - ( markup_rate .* pY' .* Y' ) ) ;
    // y1 = (Profit_margin==0).*y1_1 + (Profit_margin<>0).*y1_2 ;

endfunction

// For calibration
// Capital income (valuation of fixed capital consumption)
function Capital_income = Capital_income_1_val(pK, kappa, Y)
    
	pK=abs(pK);
    Capital_income = ( sum(pK .* kappa .* Y', "r") );

    // if Y =0 => kappa=0
    // y1_1 = (Y'==0).*(kappa);
    // y1_2 = (Y'<>0).*(  Capital_income - ( sum(pK .* kappa .* Y', "r") ));
    // y1 = (Y'==0).*y1_1  + (Y'<>0).*y1_2;

endfunction

function Transp_margins_rates =  Transp_MargRates_2_val(delta_TranspMargins_rate)

    delta_transp = delta_TranspMargins_rate * BY.Transp_margins_rates;
    for i = 1:size(BY.Transp_margins_rates,2) 
        if (BY.Transp_margins_rates >= 0) then
            Transp_margins_rates(i) = BY.Transp_margins_rates(i);
        else
            Transp_margins_rates(i) = delta_transp(i);
        end
    end

    Transp_margins_rates = Transp_margins_rates';

endfunction

function y = delta_TranspMarg_rate_eq(Transp_margins)
    
    y = sum(Transp_margins);
    
endfunction

function Trade_margins_rates =  Trade_MargRates_2_val(delta_TradeMargins_rate)

    delta_trade = delta_TradeMargins_rate * BY.Trade_margins_rates;
    for i = 1:size(BY.Trade_margins_rates,2) 
        if (BY.Trade_margins_rates >= 0) then
            Trade_margins_rates(i) = BY.Trade_margins_rates(i);
        else
            Trade_margins_rates(i) = delta_trade(i);
        end
    end

    Trade_margins_rates = Trade_margins_rates';

endfunction

function y = delta_TradeMarg_rate_eq(Trade_margins)
    
    y = sum(Trade_margins);
    
endfunction
