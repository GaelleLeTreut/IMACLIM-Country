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
	y = (GFCF_byAgent - sum(pI.*I)*GFCF_Distribution_Shares)';
endfunction


function y = Exo_VA_Tax_Const_1(Exo_VA_Tax, VA_Tax)

	y = Exo_VA_Tax - sum(VA_Tax)

endfunction

function y = VA_Tax_rate_Const_1(VA_Tax_rate, tau_VA_Tax_rate);

    y1 = VA_Tax_rate - tau_VA_Tax_rate*BY.VA_Tax_rate;
    y = y1';

endfunction

function y = Exo_Production_Tax_Const_1(Exo_Production_Tax, Production_Tax)

	y = Exo_Production_Tax - sum(Production_Tax)

endfunction

function y = Production_Tax_rate_Const_1(Production_Tax_rate, tau_Production_Tax_rate);

    y1 = Production_Tax_rate - tau_Production_Tax_rate*BY.Production_Tax_rate;
    y = y1';

endfunction


//////////////////////////
// Totaux du TEE
//////////////////////////


// maintien contant de l'investissement réel + Revevenu de la tax carbon
	//    y = (I.*pI - BY.I.*BY.pI.*I_pFish.*(1 + divide(sum(Carbon_Tax_IC) + sum(Carbon_Tax_C), sum(I.*pI),1.0)));
// maintien contant de l'investissement réel
	//    y = (I.*pI- BY.I.*BY.pI.*I_pFish); 




