disp("/////////////////////////////////////////////////")
disp("Agrégats Macroéconomiques")
disp("/////////////////////////////////////////////////")
disp("Unemployment rate ")
100*(u_tot/target.u_tot - 1)
disp("real GDP")
100*((GDP/GDP_pFish)/BY.GDP - GDP_index(time_step))./(GDP_index(time_step))
disp("nominal GDP")
100*(GDP*1E-6 - 2350.0)/2350.0
disp("CPI")
100*(CPI/target.CPI - 1)
// disp("Y, M-X")
// 100*([sum(Y.*pY) (sum(pM.*M) - sum(pX.*X))]*1E-6 - [3894.637494 44.676])./[3894.637494 44.676]
disp("M-X")
100*((sum(pM.*M) - sum(pX.*X))*1E-6./target.Trade_balance -1)
disp("Labour_income")
100*(sum(NetCompWages_byAgent(Indice_Households))*1E-6./target.NetCompWages_byAgent -1)
disp("Disposable Income")
100*([Corp_disposable_income G_disposable_income sum(H_disposable_income) (-sum(pX.*X)+sum(pM.*M) + Property_income(Indice_RestOfWorld) + Other_Transfers(Indice_RestOfWorld))]*1E-6 - ..
	[291.310207488795	625.175552847327	1454.32603543607	12.1880200000003])./[291.310207488795	625.175552847327	1454.32603543607	12.1880200000003]
disp("NetLending")
100*([NetLending(Indice_Corporations) NetLending(Indice_Government) sum(NetLending(Indice_Households)) NetLending(Indice_RestOfWorld)]* 1E-6 - .. 
	[-9.36933000000045	-59.77088	56.9521900000001	12.1880200000003])./[-9.36933000000045	-59.77088	56.9521900000001	12.1880200000003]
//////////////////////////////////////////////////////////////////////////

//////////////////////////////////////////////////////////////////////////
disp("/////////////////////////////////////////////////")
disp("Balance énergétique")
disp("/////////////////////////////////////////////////")
disp("HH Energy prices : pC(Natural_gas	Gasoline LPG Road_diesel Heating_oil Electricity)")
pIC_to_reach	= [1.0670943534191	1.1176459210912	1.11302943713353	1.25327047141911	1.27317747456186	1.21881908084104];
100*(pC(target.pIndice,1)./BY.pC(target.pIndice,1) - target.pC')./target.pC'
disp("ENT Energy prices : pIC(Natural_gas Gasoline LPG	Road_diesel Heating_oil Electricity)")
100*((sum(pIC(target.pIndice,:).*IC(target.pIndice,:),"c")./sum(IC(target.pIndice,:),"c"))./(sum(BY.IC_value(target.pIndice,:),"c")./sum(BY.IC(target.pIndice,:),"c")) - pIC_to_reach')./pIC_to_reach'
//////////////////////////////////////////////////////////////////////////

//////////////////////////////////////////////////////////////////////////
disp("/////////////////////////////////////////////////")
disp("Factures énergétiques")
disp("/////////////////////////////////////////////////")
disp("Pétrole brut : M")
100*(pM(Indice_Oil)*M(Indice_Oil)*1E-3 - 24463.5694073419)/24463.5694073419
disp("Gaz naturel : M / Total CF / Résidentiel")
100*(pM(Indice_Gas)*M(Indice_Gas)*1E-3 - 12121.7621744309)/12121.7621744309
100*((sum(pIC(Indice_Gas,Indice_NonEnerSect).*IC(Indice_Gas,Indice_NonEnerSect)) + sum(pC(Indice_Gas,:).*C(Indice_Gas,:)))*1E-3 - 18291.8603350077)/18291.8603350077
100*(sum(pC(Indice_Gas,:).*C(Indice_Gas,:))*1E-3 - 10869.4833886892)/10869.4833886892
// disp("Produits Pétroliers (hors non-énergie): M / Y-supprimé / X / Total CF / Ménages") 
// Indice_PP = [Indice_HH_Fuels Indice_NonHH_Fuels]
// 100*(sum(pM(Indice_PP).*M(Indice_PP))*1E-3 - 24583.9902680768/24583.9902680768
// 100*(sum(pY(Indice_PP).*Y(Indice_PP))*1E-3 - (20428*0.85))/(20428*0.85)
// 100*(sum(pX(Indice_PP).*X(Indice_PP))*1E-3 - (13120.6563512371-4012.77787675022))/(13120.6563512371-4012.77787675022)
// 100*((sum(pIC(Indice_PP,:).*IC(Indice_PP,:)) + sum(pC(Indice_PP,:).*C(Indice_PP,:)))*1E-3 - 82171.716536691)/82171.716536691
// 100*(sum(pC(Indice_PP,:).*C(Indice_PP,:))*1E-3 - (35884.0 + 5212.0))/(35884.0 + 5212.0)
//////////////////////////////////////////////////////////////////////////


F_opt = [100*abs(((d.GDP/d.GDP_pFish)/BY.GDP - GDP_index(time_step))/GDP_index(time_step)) ..
		100*abs(d.u_tot/target.u_tot - 1) ..
		100*abs(d.NetCompWages_byAgent(Indice_Households)*1E-6/target.NetCompWages_byAgent - 1) ..	
		100*abs(d.CPI/target.CPI - 1) .. 
		100*abs(sum(d.pM.*d.M)*1E-6/target.M_value - 1).. 
		100*abs(sum(d.pX.*d.X)*1E-6/target.X_value - 1).. 
		100*abs((sum(d.pM.*d.M) - sum(d.pX.*d.X))*1E-6/target.Trade_balance - 1)..
		100*abs(d.pC(target.pIndice)./(BY.pC(target.pIndice) .* target.pC') - 1)' ..
		];

F_norm = norm(F_opt)