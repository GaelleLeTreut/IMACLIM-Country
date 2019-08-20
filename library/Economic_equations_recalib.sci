//////////////////////////
// Indices de prix réel
//////////////////////////
function GDP_pFish = GDP_pFish_Val_1(pC, C, pG, G, pI, I, pX, X, pM, M, GDP)
	GDP_pLasp = (sum(pC.*BY.C)+sum(pG.*BY.G)+sum(pI.*sum(BY.I,"c"))+sum(pX.*BY.X)-sum(pM.*BY.M))/BY.GDP ;
	GDP_pPaas = GDP / (sum(BY.pC.*C)+sum(BY.pG.*G)+sum(BY.pI.*sum(I,"c"))+sum(BY.pX.*X)-sum(BY.pM.*M)); 
	GDP_pFish = sqrt(GDP_pLasp*GDP_pPaas)
endfunction


function I_pFish = I_pFish_Val_1(pI, I)
	I_pFish = PInd_Fish( BY.pI, sum(BY.I,"c"), pI, sum(I,"c"), :, :);
endfunction


function G_pFish = G_pFish_Val_1(pG, G)
	G_pFish = PInd_Fish( BY.pG, BY.G, pG, G, :, :);
endfunction


//////////////////////////
// Répartition de la FBCF
//////////////////////////

function [y] = GFCF_byAgent_Const_1(GFCF_byAgent,pI,I, GFCF_Distribution_Shares)
	y = (GFCF_byAgent - sum(pI.*I)*GFCF_Distribution_Shares)';
endfunction


function y = Exo_VA_Tax_Const_1(Exo_VA_Tax, VA_Tax)

	y = Exo_VA_Tax - sum(VA_Tax)

endfunction

function y = VA_Tax_rate_Const_1(VA_Tax_rate, tau_VA_Tax_rate);

    y1 = VA_Tax_rate - tau_VA_Tax_rate*(BY.VA_Tax_rate<>0).*BY.VA_Tax_rate;
    y = y1';

endfunction

function y = Exo_ProductTax_Const_1(Exo_Production_Tax, Production_Tax)

	y = Exo_Production_Tax - sum(Production_Tax)

endfunction

function y = ProductTax_rate_Const_1(Production_Tax_rate, tau_Production_Tax_rate);

    y1 = Production_Tax_rate - tau_Production_Tax_rate*BY.Production_Tax_rate;
    y = y1';

endfunction

function y = Exo_GrossOpSurp_Const_1(Exo_GrossOpSurplus, GrossOpSurplus)

	y = Exo_GrossOpSurplus - sum(GrossOpSurplus)

endfunction

function [y] =  Markup_Const_2(markup_rate, tau_markup_rate) ;

    //  Fixed Markup ( markup_rate(nb_Sectors) )
    y1 = markup_rate - tau_markup_rate*BY.markup_rate ;

    y=y1';
endfunction

function [y] = I_ConsumpBudget_Const_1(I_Consumption_budget, I, pI);

    y = I_Consumption_budget - sum(I .* pI) ;

endfunction

function [y] = Betta_Const_2(Betta, tau_Betta) ;

    y = Betta  - tau_Betta*BY.Betta;

endfunction

function [y] = G_investment_Const_3(GFCF_byAgent, I, pI, GDP, I_pFish, delta_LS_I, Carbon_Tax_IC, Carbon_Tax_C) ;

    // Government gross fixed capital formation constraint (GFCF_byAgent(Indice_Government))
    y1 = GFCF_byAgent(Indice_Government) - I_pFish * BY.GFCF_byAgent(Indice_Government) - delta_LS_I*(sum(Carbon_Tax_IC) + sum(Carbon_Tax_C));

    y  = y1' ;
endfunction

function [y] = ConsumBudget_Const_2(Consumption_budget, H_disposable_income, Household_saving_rate, CPI) ;

    /// Source of consumption budget - Constant in real terms
    y1 = Consumption_budget - CPI*BY.Consumption_budget ;
	y=y1';	

endfunction

function [y] = G_ConsumpBudget_Const_3(G_Consumption_budget, G, pG, GDP, G_pFish) ;

    /// Public consumption budget - constant in real terms
    y1 = G_Consumption_budget - (G_pFish *  BY.G_Consumption_budget);
    y = y1' ;

endfunction

function [y] = Invest_demand_Const_3(Betta, I, pI, kappa, Y, I_pFish, delta_LS_I, Carbon_Tax_IC, Carbon_Tax_C, Carbon_Tax_M) ;

	Tax_Base_Carbon = sum(Carbon_Tax_C) + sum(Carbon_Tax_IC) + sum(Carbon_Tax_M) ;
    y = I.*pI- BY.I.*BY.pI.*I_pFish;

    // y = I.*pI - BY.I.*BY.pI.*I_pFish.*(1 + delta_LS_I*divide(Tax_Base_Carbon, sum(I.*pI),1.0));
	// (sum((pI*ones(1,nb_Sectors)).* I,"r") ./ sum(I,"r"))

endfunction
warning( "Invest_demand_Const_3 avec recyclage de la taxe à généraliser")

function I = Invest_demand_Val_3(Betta, pI, kappa, Y, I_pFish, delta_LS_I, Carbon_Tax_IC, Carbon_Tax_C, Carbon_Tax_M)
	
	Tax_Base_Carbon = sum(Carbon_Tax_C) + sum(Carbon_Tax_IC) + sum(Carbon_Tax_M) ;

    value_I = BY.I.*BY.pI.*I_pFish.*(1 + delta_LS_I*divide(Tax_Base_Carbon, sum(I.*pI),1.0));
    I = (pI <> 0) .* divide(value_I,pI,1);

endfunction
