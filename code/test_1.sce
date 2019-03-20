disp("Unemployment rate ")
100*(u_tot - 0.101573450097788)/0.101573450097788

disp("real GDP")
100*((GDP/GDP_pFish)/BY.GDP - GDP_index)./(GDP_index)

disp("NetFinancialDebt")
100*(NetFinancialDebt - [2132930000.0 1707972000.0 -3583937000.0 -256965000.0])./[2132930000.0 1707972000.0 -3583937000.0 -256965000.0]

disp("GFCF distribution by Agent")
100*(GFCF_byAgent(Indice_DomesticAgents)/sum(GFCF_byAgent) - GFCF_Distribution_Shares)./GFCF_Distribution_Shares

disp("HH saving rate")
100*(Household_saving_rate - 0.13925654620247)/0.13925654620247

disp("Composanste du GDP : C, G, I, X-M")
100*(sum(pC.*C)/GDP - C_share)/C_share
100*(sum(pG.*G)/GDP - G_share)/G_share
100*(sum(pI.*I)/GDP - I_share)/I_share
100*((sum(pX.*X) - sum(pM.*M))/GDP - TradeBalance_share)/TradeBalance_share

disp("Public deficit")
100*(-NetLending(Indice_Government)/GDP - 75886000.0/2204855943.6546)/(75886000.0/2204855943.6546)

disp("TradeBalance, X, M")
100*((sum(pX.*X) - sum(pM.*M)) - 43415000.0)/43415000.0

disp("CPI")
100*(CPI - 1.0718874451)/1.0718874451

disp("Energy Balance : IC, C, M, X, Y")
[norm(Projection.IC(Indice_EnerSect,:) -IC(Indice_EnerSect,:)) norm(Projection.C(Indice_EnerSect,:) -C(Indice_EnerSect,:)) norm(Projection.M(Indice_EnerSect) -M(Indice_EnerSect)) norm(Projection.X(Indice_EnerSect) -X(Indice_EnerSect)) norm(Projection.Y(Indice_EnerSect) -Y(Indice_EnerSect))]

disp("HH Energy prices : pC(Gaz, Elec)")
100*(pC([2,5])./BY.pC([2,5]) - [1.0280235988 1.3837111671]')./[1.0280235988 1.3837111671]'

disp("ENT Energy prices : pC(Gaz, Elec)")
100*((sum(IC_value([2,5],:),"c")./sum(IC([2,5],:),"c"))./(sum(BY.IC_value([2,5],:),"c")./sum(BY.IC([2,5],:),"c")) - [0.8612565445 1.0280235988]')./[0.8612565445 1.0280235988]'




