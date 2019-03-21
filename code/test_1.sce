disp("/////////////////////////////////////////////////")
disp("Agrégats Macroéconomiques")
disp("/////////////////////////////////////////////////")
disp("Unemployment rate ")
100*(u_tot - 0.101573450097788)/0.101573450097788
//u_param
disp("real GDP")
100*((GDP/GDP_pFish)/BY.GDP - GDP_index)./(GDP_index)
disp("GFCF share by Agent")
100*(GFCF_byAgent(Indice_DomesticAgents)/sum(GFCF_byAgent) - GFCF_Distribution_Shares)./GFCF_Distribution_Shares
//disp("Composanste du GDP : C, G, I, X-M")
//100*(sum(pC.*C)/GDP - C_share)/C_share
//100*(sum(pG.*G)/GDP - G_share)/G_share
//100*(sum(pI.*I)/GDP - I_share)/I_share
//100*((sum(pX.*X) - sum(pM.*M))/GDP - TradeBalance_share)/TradeBalance_share
disp("CPI")
100*(CPI - 1.0718874451)/1.0718874451

disp("/////////////////////////////////////////////////")
disp("Balance énergétique")
disp("/////////////////////////////////////////////////")
disp("Energy Balance : IC, C, M, X, Y")
[norm(Projection.IC(Indice_EnerSect,:) -IC(Indice_EnerSect,:)) norm(Projection.C(Indice_EnerSect,:) -C(Indice_EnerSect,:)) norm(Projection.M(Indice_EnerSect) -M(Indice_EnerSect)) norm(Projection.X(Indice_EnerSect) -X(Indice_EnerSect)) norm(Projection.Y(Indice_EnerSect) -Y(Indice_EnerSect))]
disp("HH Energy prices : pC(Gaz, AllFuels & Elec)")
100*(pC([2 4 5])./BY.pC([2 4 5]) - [1.0280235988 0.9678596039 1.3837111671]')./[1.0280235988 0.9678596039 1.3837111671]'
disp("ENT Energy prices : pIC(Gaz & Elec)")
100*((sum(pIC([2,5],:).*IC([2,5],:),"c")./sum(IC([2,5],:),"c"))./(sum(BY.IC_value([2,5],:),"c")./sum(BY.IC([2,5],:),"c")) - [0.8612565445 1.0280235988]')./[0.8612565445 1.0280235988]'

disp("/////////////////////////////////////////////////")
disp("Factures énergétiques")
disp("/////////////////////////////////////////////////")
disp("Pétrole brut : M")
100*(pM(1)*M(1)*1E-6 - 16.5)/16.5
disp("Gaz naturel : M / Total CF / Agri + Industrie / Tertiaire + Transport / Résidentiel")
100*(pM(2)*M(2)*1E-3 - 8407.0)/8407.0
100*((sum(pIC(2,Indice_NonEnerSect).*IC(2,Indice_NonEnerSect)) + sum(pC(2,:).*C(2,:)))*1E-3 - 17525.0)/17525.0
100*(sum(pIC(2,[7:10 13]).*IC(2,[7:10 13]))*1E-3 - (99.0 + 3403.0))/(99.0 + 3403.0)
100*(sum(pIC(2,[11:12 14:15]).*IC(2,[11:12 14:15]))*1E-3 - (3599.0))/(3599.0)
100*(sum(pC(2,:).*C(2,:))*1E-3 - 10424.0)/10424.0
disp("Produits Pétroliers : M / Y / X / Total CF / TranspMarch / Ménages (Transp + Rés) / Tertiaire + Agri + Industrie") 
100*(pM(4)*M(4)*1E-3 - 15065.0)/15065.0
100*(pY(4)*Y(4)*1E-3 - 15065.0)/15065.0
100*(pX(4)*X(4)*1E-3 - 20428.0)/20428.0
100*((sum(pIC(4,Indice_NonEnerSect).*IC(4,Indice_NonEnerSect)) + sum(pC(4,:).*C(4,:)))*1E-3 - 64546.0)/64546.0
100*(pIC(4,11).*IC(4,11)*1E-3 -  17383.0)/17383.0
100*(sum(pC(4,:).*C(4,:))*1E-3 - (35884.0 + 5212.0))/(35884.0 + 5212.0)
100*(sum(pIC(2,[7:10 12:15]).*IC(2,[7:10 12:15]))*1E-3 - (999.0 + 2019.0 + 998.0 + 2057.0))/(999.0 + 2019.0 + 998.0 + 2057.0)

disp("/////////////////////////////////////////////////")
disp("Composantes du TEE")
disp("/////////////////////////////////////////////////")
disp("GOS_byAgent")
100*(GOS_byAgent(Indice_DomesticAgents)*1E-6 - [472.0320001809 80.143 179.16402])./[472.0320001809 80.143 179.16402]
disp("Labour_income")
100*(NetCompWages_byAgent(Indice_Households)*1E-6 - 847.503)/847.503
//disp("Labour_Tax_rate")
//100*(sum(Labour_Tax)*1E-6 - 383.8861873126)/383.8861873126
//disp("Production_Tax")
//100*(sum(Production_Tax)*1E-6 - 57.0357330598)/57.0357330598
//disp("VA_Tax")
//100*(sum(VA_Tax)*1E-6 - 154.43)/154.43
//disp("Income_Tax")
//100*(sum(Income_Tax)*1E-6 - 204.9277817862)/204.9277817862
//disp("Corporate_Tax")
//100*(sum(Corporate_Tax)*1E-6 - 52.703884202)/52.703884202
disp("Disposable Income")
100*([Corp_disposable_income G_disposable_income H_disposable_income (-sum(pX.*X)+sum(pM.*M) + Property_income(Indice_RestOfWorld) + Other_Transfers(Indice_RestOfWorld))]*1E-6- [289.396296 578.721 1343.187408 17.932296])./[289.396296 578.721 1343.187408 17.932296]
disp("FC : C, G, I, Y")
100*([sum(C.*pC) sum(G.*pG) sum(I.*pI) sum(Y.*pY)]*1E-6 - [1164.859 576.37 488.008 3894.637494])./[1164.859 576.37 488.008 3894.637494]
disp("NetLending")
100*(NetLending*1E-6 - [3.218296 -77.448 56.297408 17.932296])./[3.218296 -77.448 56.297408 17.932296]










