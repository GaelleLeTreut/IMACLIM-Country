//////////////////////////
// Indices de prix réel
//////////////////////////
function GDP_pFish = GDP_pFish_Const_1(pC, C, pG, G, pI, I, pX, X, pM, M, GDP)
	GDP_pLasp = (sum(pC.*BY.C)+sum(pG.*BY.G)+sum(pI.*BY.I)+sum(pX.*BY.X)-sum(pM.*BY.M))/BY.GDP ;
	GDP_pPaas = GDP / (sum(BY.pC.*C)+sum(BY.pG.*G)+sum(BY.pI.*I)+sum(BY.pX.*X)-sum(BY.pM.*M)); 
	GDP_pFish = sqrt(GDP_pLasp*GDP_pPaas)
endfunction

function I_pFish = I_pFish_Const_1(pI, I)
	I_pFish = PInd_Fish( BY.pI, BY.I, pI, I, :, :);
endfunction

function G_pFish = G_pFish_Const_1(pG, G)
	G_pFish = PInd_Fish( BY.pG, BY.G, pG, G, :, :);
endfunction

//////////////////////////
// Répartition de la FBCF
//////////////////////////

function [y] = GFCF_byAgent_Const_1(GFCF_byAgent,pI,I, GFCF_Distribution_Shares)
//	y = (GFCF_byAgent - sum(GFCF_byAgent)*GFCF_Distribution_Shares)';
	y = (GFCF_byAgent - sum(pI.*I)*GFCF_Distribution_Shares)';
endfunction


//////////////////////////
// Composente du PIB 
//////////////////////////
function [y] = Invest_demand_Const_3(I, pI, GDP);
	y = I.*pI - I_share.*GDP.*ones(pI);
endfunction

function [y] = ConsumBudget_Const_2(Consumption_budget, GDP) ;
	y1 = Consumption_budget - C_share * GDP ;
	y=y1';		
endfunction

function [y] = G_ConsumpBudget_Const_3(G_Consumption_budget, G, pG, GDP ) ;

    /// Public consumption budget - Proportion of GDP
    y1 = G_Consumption_budget - G_share * GDP ;
    y = y1' ;
endfunction

/// Trade balance constant to GDP growth
function y = Trade_Balance_Const_3( pM, pX, X, M, GDP);

  y = (sum(pX.*X) - sum(pM.*M)) - TradeBalance_share*GDP;

endfunction


// maintien contant de l'investissement réel + Revevenu de la tax carbon
	//    y = (I.*pI - BY.I.*BY.pI.*I_pFish.*(1 + divide(sum(Carbon_Tax_IC) + sum(Carbon_Tax_C), sum(I.*pI),1.0)));
// maintien contant de l'investissement réel
	//    y = (I.*pI- BY.I.*BY.pI.*I_pFish); 




