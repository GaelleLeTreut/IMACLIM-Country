// Index numbers (Used to aggregate prices and quantity) 
  
 // Approximation of quantity variation (Value / Price_index) - Fisher
 function Q_Fish_app = QInd_Fish_app( p0,q0, pf, qf, ind1, ind2) 
 
PInd_Lasp = divide(sum(pf(ind1, ind2) .* q0(ind1, ind2)) , sum(p0(ind1, ind2).*q0(ind1, ind2)),%nan); 
PInd_Paas = divide(sum(pf(ind1, ind2).*qf(ind1, ind2)) , sum(p0(ind1, ind2).*qf(ind1, ind2)),%nan);
PInd_Fish= sqrt(PInd_Lasp.*PInd_Paas);

 // real_consumption
Q_Fish_app = divide(sum(pf(ind1, ind2).*qf(ind1, ind2)) , PInd_Fish,%nan);  
endfunction 

  
 // Price Index - Fisher
 function PInd_Fish = PInd_Fish( p0,q0, pf, qf, ind1, ind2) 
 
PInd_Lasp = divide(sum(pf(ind1, ind2) .* q0(ind1, ind2)) , sum(p0(ind1, ind2).*q0(ind1, ind2)),%nan); 
PInd_Paas = divide(sum(pf(ind1, ind2).*qf(ind1, ind2)), sum(p0(ind1, ind2).*qf(ind1, ind2)),%nan);
PInd_Fish= sqrt(PInd_Lasp.*PInd_Paas);
 
 endfunction 
 
 
  // Quantity Index - Fisher
 function QInd_Fish = QInd_Fish( p0,q0, pf, qf, ind1, ind2) 
 
QInd_Lasp = divide(sum(p0(ind1, ind2) .* qf(ind1, ind2)) , sum(p0(ind1, ind2).*q0(ind1, ind2)),%nan); 
QInd_Paas = divide(sum(pf(ind1, ind2).*qf(ind1, ind2)) , sum(pf(ind1, ind2).*q0(ind1, ind2)),%nan);
QInd_Fish= sqrt(QInd_Lasp.*QInd_Paas);

 endfunction  
 
 
  // Price Index - Laspeyres
 function PInd_Lasp = PInd_Lasp( p0,q0, pf, qf, ind1, ind2) 
 
PInd_Lasp = divide(sum(pf(ind1, ind2) .* q0(ind1, ind2)) , sum(p0(ind1, ind2).*q0(ind1, ind2)),%nan); 
 
 endfunction 
 
 
  // Quantity Index - Laspeyres
 function QInd_Lasp = QInd_Lasp( p0,q0, pf, qf, ind1, ind2) 
 
QInd_Lasp = divide(sum(p0(ind1, ind2) .* qf(ind1, ind2)) , sum(p0(ind1, ind2).*q0(ind1, ind2)),%nan); 

 endfunction  
 
 
  // Price Index - Paasche
 function PInd_Paas = PInd_Paas( p0,q0, pf, qf, ind1, ind2) 
 
PInd_Paas = divide(sum(pf (ind1, ind2).*qf(ind1, ind2)), sum(p0(ind1, ind2).*qf(ind1, ind2)),%nan);
 
 endfunction 
 
 
  // Quantity Index - Paasche
 function QInd_Paas = QInd_Paas( p0,q0, pf, qf, ind1, ind2) 
 
QInd_Paas = divide(sum(pf(ind1, ind2).*qf(ind1, ind2)) , sum(pf(ind1, ind2).*q0(ind1, ind2)),%nan);

 endfunction 


 
 // Cost Share for production 
  function share = Cost_Share( Input , Y_value ) 
 share = divide( sum(Input,"r") , Y_value, %nan);
 endfunction 
 
 
 // Trade Intensity (trade exposure) / Exposition à la concurence internationale
function Trade_Intensity = TradeIntens(M, X, Y);
Trade_Intensity = divide( M+X,  Y, %nan);
endfunction 


// Import penetration rate in demand /Taux de pénétration des importations dans la demande intérieure
// Dans quelle mesure la demande intérieure est satisfaite part des importations
function Import_penet_rate = M_penetRat(M, Y, X);
Import_penet_rate = divide ( M, Y+M-X, %nan) ;
endfunction 

// Gini indicator on source of income (H_disposable_income or effective consumption for instance)
function Gini_HH = Gini_indicator(Income, Population);
	Cum_share_income = [0 cumsum(Income)/sum(Income)];
	Cum_share_pop =[0 cumsum(Population)/sum(Population)];
	Gini_HH = (Cum_share_income(1:nb_Households) + Cum_share_income(2:nb_Households+1)).* (Cum_share_pop(2:nb_Households+1) - Cum_share_pop(1:nb_Households))
endfunction

// Gini indicator on source of income (H_disposable_income or effective consumption for instance)
function Gini = Gini_indicator_bis(Income, Population);
	Cumulative_share = [0 cumsum(Income)/sum(Income)]
	// Cum_share_pop =[0 cumsum(Population)/sum(Population)];
	Gini = 1 - sum((Cumulative_share(1:nb_Households) + Cumulative_share(2:nb_Households+1)).* Population./sum(Population))
	// Gini = 1 - sum((Cumulative_share(1:nb_Households) + Cumulative_share(2:nb_Households+1)).* (Cum_share_pop(2:nb_Households+1) - Cum_share_pop(1:nb_Households)))
endfunction




