Eq_qties = 	sum(IC,'c')+sum(C,'c')+sum(I,'c')+sum(G,'c')+sum(X,'c')- Y - M;
Eq_val   = 	sum(IC.*pIC,'r') + ..
			Labour_income + Labour_Tax + Capital_income + Production_Tax + Profit_margin + ..
			(pM.*M)' + ..
			Trade_margins + Transp_margins + sum(SpeMarg_IC,'r') + sum(SpeMarg_C,'r') + SpeMarg_X + SpeMarg_I + ..
			VA_Tax + Energy_Tax_IC + Energy_Tax_FC + ClimPolCompensbySect + OtherIndirTax + sum(Carbon_Tax_IC','r') + sum(Carbon_Tax_C','r') - ..
			sum(IC.*pIC,'c')' - sum(C.*pC,'c')' - (G.*pG)' - (X.*pX)'- (I.*pI)'; 
			RoW_disposable_income = sum(pM.*M) - sum(pX.*X) + Property_income(Indice_RestOfWorld) + Other_Transfers(Indice_RestOfWorld);
Eq_TEE	= 	[sum(NetLending) ..
			NetLending - ([Corp_disposable_income G_disposable_income H_disposable_income RoW_disposable_income] - [GFCF_byAgent 0] - [0 sum(pG.*G) sum(pC.*C,"r") 0])..
			];

			clear RoW_disposable_income
			
tolerance = 1E-1;
if norm(Eq_qties)>tolerance
	disp("check Eq_qties")
	pause
end
if norm(Eq_val)>tolerance
	disp("check Eq_val")
	pause
end
if norm(Eq_TEE)>tolerance
	disp("check Eq_TEE")
	pause
end