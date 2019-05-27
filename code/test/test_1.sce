disp("/////////////////////////////////////////////////")
disp("Agrégats Macroéconomiques")
disp("/////////////////////////////////////////////////")
disp("Unemployment rate ")
100*(u_tot - 0.101573450097788)/0.101573450097788
//u_param
disp("real GDP")
100*((GDP/GDP_pFish)/BY.GDP - GDP_index)./(GDP_index)
disp("CPI")
100*(CPI - 1.0718874451)/1.0718874451
disp("Y, M-X")
100*([sum(Y.*pY) (sum(pM.*M) - sum(pX.*X))]*1E-6 - [3894.637494 44.676])./[3894.637494 44.676]
disp("Labour_income")
100*(sum(NetCompWages_byAgent(Indice_Households))*1E-6 - 847.503)/847.503
disp("Disposable Income")
100*([Corp_disposable_income G_disposable_income sum(H_disposable_income) (-sum(pX.*X)+sum(pM.*M) + Property_income(Indice_RestOfWorld) + Other_Transfers(Indice_RestOfWorld))]*1E-6- [276.758446	562.241945	1394.3145608305	30.306921])./[276.758446	562.241945	1394.3145608305	30.306921]
disp("NetLending")
100*([NetLending(Indice_Corporations) NetLending(Indice_Government) sum(NetLending(Indice_Households)) NetLending(Indice_RestOfWorld)]*1E-6 - [-9.419554 -93.927055 73.039688 30.306921])./[-9.419554 -93.927055 73.039688 30.306921]
//////////////////////////////////////////////////////////////////////////

//////////////////////////////////////////////////////////////////////////
disp("/////////////////////////////////////////////////")
disp("Balance énergétique")
disp("/////////////////////////////////////////////////")
//disp("Energy Balance : IC, C, M, X, Y")
//[norm(Projection.IC(Indice_EnerSect,:) -IC(Indice_EnerSect,:)) norm(Projection.C(Indice_EnerSect,:) -sum(C(Indice_EnerSect,:),"c")) norm(Projection.M(Indice_EnerSect) -M(Indice_EnerSect)) norm(Projection.X(Indice_EnerSect) -X(Indice_EnerSect)) norm(Projection.Y(Indice_EnerSect) -Y(Indice_EnerSect))]
disp("HH Energy prices : pC(Gaz, AllFuels & Elec)")
100*(pC([2 4 5],1)./BY.pC([2 4 5],1) - [1.0280235988 0.9678596039 1.3837111671]')./[1.0280235988 0.9678596039 1.3837111671]'
disp("ENT Energy prices : pIC(Gaz & Elec)")
100*((sum(pIC([2,5],:).*IC([2,5],:),"c")./sum(IC([2,5],:),"c"))./(sum(BY.IC_value([2,5],:),"c")./sum(BY.IC([2,5],:),"c")) - [0.8612565445 1.0280235988]')./[0.8612565445 1.0280235988]'
//////////////////////////////////////////////////////////////////////////

//////////////////////////////////////////////////////////////////////////
disp("/////////////////////////////////////////////////")
disp("Factures énergétiques")
disp("/////////////////////////////////////////////////")
disp("Pétrole brut : M")
100*(pM(1)*M(1)*1E-6 - 16.5)/16.5
disp("Gaz naturel : M / Total CF / Résidentiel")
100*(pM(2)*M(2)*1E-3 - 8407.0)/8407.0
100*((sum(pIC(2,Indice_NonEnerSect).*IC(2,Indice_NonEnerSect)) + sum(pC(2,:).*C(2,:)))*1E-3 - 17525.0)/17525.0
100*(sum(pC(2,:).*C(2,:))*1E-3 - 10424.0)/10424.0
disp("Produits Pétroliers (hors non-énergie): M / Y / X / Total CF / Ménages") 
100*(pM(4)*M(4)*1E-3 - (15065.0 - 1823.0))/(15065.0 - 1823.0)
100*(pY(4)*Y(4)*1E-3 - (20428*0.85))/(20428*0.85)
100*(pX(4)*X(4)*1E-3 - (9430.0-2830.0))/(9430.0-2830.0)
100*((sum(pIC(4,:).*IC(4,:)) + sum(pC(4,:).*C(4,:)))*1E-3 - 64546.0)/64546.0
100*(sum(pC(4,:).*C(4,:))*1E-3 - (35884.0 + 5212.0))/(35884.0 + 5212.0)
//////////////////////////////////////////////////////////////////////////

F_opt = [100*abs(((GDP/GDP_pFish)/BY.GDP - GDP_index)/GDP_index) .. 			//1
		100*abs((u_tot - 0.101573450097788)/0.101573450097788) .. 				//2
		100*(NetCompWages_byAgent(Indice_Households)*1E-6 - 847.503)/847.503 ..	//3
		100*abs((CPI - 1.0718874451)/1.0718874451) .. 							//3
		100*abs(((sum(pM.*M) - sum(pX.*X))*1E-6 - 44.676)/44.676) ..		//4
		100*(NetCompWages_byAgent(Indice_Households)*1E-6 - 847.503)/847.503 ..	//5
		100*(pC(2)/BY.pC(2) - 1.0280235988)/1.0280235988 .. 						//6	
		100*(pC(4)/BY.pC(4) - 0.9678596039)/0.9678596039 ..						//7
		100*(pC(5)/BY.pC(5) - 1.3837111671)/1.3837111671 ..						//8	
		];






