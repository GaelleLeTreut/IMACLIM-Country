//////  Copyright or © or Copr. Ecole des Ponts ParisTech / CNRS 2018
//////  Main Contributor (2017) : Gaëlle Le Treut / letreut[at]centre-cireOut.fr
//////  Contributors : Emmanuel Combet, Ruben Bibas, Julien Lefèvre
//////  
//////  
//////  This software is a computer program whose purpose is to centralise all  
//////  the IMACLIM national versions, a general equilibrium model for energy transition analysis
//////
//////  This software is governed by the CeCILL license under French law and
//////  abiding by the rules of distribution of free software.  You can  use,
//////  modify and/ or redistribute the software under the terms of the CeCILL
//////  license as circulated by CEA, CNRS and INRIA at the following URL
//////  "http://www.cecill.info".
//////  
//////  As a counterpart to the access to the source code and  rights to copy,
//////  modify and redistribute granted by the license, users are provided only
//////  with a limited warranty  and the software's author,  the holder of the
//////  economic rights,  and the successive licensors  have only  limited
//////  liability.
//////  
//////  In this respect, the user's attention is drawn to the risks associated
//////  with loading,  using,  modifying and/or developing or reproducing the
//////  software by the user in light of its specific status of free software,
//////  that may mean  that it is complicated to manipulate,  and  that  also
//////  therefore means  that it is reserved for developers  and  experienced
//////  professionals having in-depth computer knowledge. Users are therefore
//////  encouraged to load and test the software's suitability as regards their
//////  requirements in conditions enabling the security of their systems and/or 
//////  data to be ensured and,  more generally, to use and operate it in the
//////  same conditions as regards security.
//////  
//////  The fact that you are presently reading this means that you have had
//////  knowledge of the CeCILL license and that you accept its terms.
//////////////////////////////////////////////////////////////////////////////////

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
///// Decomposition of the production price variation 
/////	Production Price is a function of variables xi
///// 	Index calculation is used : 
/////		Price variation = sum for xi ( 1/2 * ( partial derivative with respect to xi at initial point + partial derivative at final point)*(variation of xi) ) + Error 
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////												  
///	Definition: Production price = (Theta / Phi) * Cost_Structure / PriceCost_wedge

//	Initial cost structure
BY.Cost_Structure = sum(BY.pIC .* BY.alpha,"r") + sum(BY.pL .* BY.lambda,"r") + sum(BY.pK .* BY.kappa, "r") - BY.ClimPolCompensbySect./BY.Y';

//	Final cost structure
Out.Cost_Structure = sum(Out.pIC .* Out.alpha,"r") + sum(Out.pL .* Out.lambda,"r") + sum(Out.pK .* Out.kappa, "r") - Out.ClimPolCompensbySect./Out.Y';


//////////////////////////
//	Scale effects
//////////////////////////
ScaleEffect_Cost	= (1/2)*( Out.Theta ./ Out.Phi - Out.Phi ./ Out.Theta );
//1
//////////////////////////
//	Price effects
//////////////////////////
// Energy prices
//2
EnergPriceEffect_Cost = (1/2)*sum((BY.alpha(Indice_EnerSect,:)./(ones(nb_EnerSect, 1).*.BY.Cost_Structure) + Out.alpha(Indice_EnerSect,:)./(ones(nb_EnerSect, 1).*.Out.Cost_Structure)).*( Out.pIC(Indice_EnerSect,:) - BY.pIC(Indice_EnerSect,:) ), "r");

// Non energy prices (intermediate consumption + capital consumption)
NonEnergPriceEffect_Cost = (1/2)*( sum((BY.alpha(Indice_NonEnerSect,:)./(ones(nb_NonEnerSect, 1).*.BY.Cost_Structure) + Out.alpha(Indice_NonEnerSect,:)./(ones(nb_NonEnerSect, 1).*.Out.Cost_Structure)).*( Out.pIC(Indice_NonEnerSect,:) - BY.pIC(Indice_NonEnerSect,:) ), "r") + (BY.kappa./BY.Cost_Structure + Out.kappa./Out.Cost_Structure).*(Out.pK - BY.pK) );

// Net-of-tax wage
NetWageEffect_Cost = (1/2)* ( (ones(1, nb_Sectors) + BY.Labour_Tax_rate) .* BY.lambda ./ BY.Cost_Structure + (ones(1, nb_Sectors) + Out.Labour_Tax_rate) .* Out.lambda ./ Out.Cost_Structure ) .* ( Out.w - BY.w );

// Labour tax
LabourTaxEffect_Cost = (1/2)* ( BY.w .* BY.lambda ./ BY.Cost_Structure + Out.w .* Out.lambda ./ Out.Cost_Structure ) .* ( Out.Labour_Tax_rate - BY.Labour_Tax_rate );

//	Profit margin and tax on production effects
//	Price-cost wedge
BY.PriceCost_wedge 	= ones(1, nb_Sectors) - BY.markup_rate - BY.Production_Tax_rate;
Out.PriceCost_wedge   	= ones(1, nb_Sectors) - Out.markup_rate - Production_Tax_rate;		// Rq: modifier si Production_Tax_rate est variable: Out.Production_Tax_rate

MarginEffect_Cost = (1/2)* ( BY.PriceCost_wedge ./ Out.PriceCost_wedge - Out.PriceCost_wedge ./ BY.PriceCost_wedge );

////////////////////////////////////////////////////
//	Technical substitution effects
////////////////////////////////////////////////////
SubstitutionEffect_Cost = (1/2)*sum((BY.pIC(:,:)./(ones(nb_Sectors, 1).*.BY.Cost_Structure) + Out.pIC(:,:)./(ones(nb_Sectors, 1).*.Out.Cost_Structure)).*( Out.alpha(:,:) - BY.alpha(:,:) ), "r") + ( (ones(1, nb_Sectors) + BY.Labour_Tax_rate) .* BY.w ./ BY.Cost_Structure + (ones(1, nb_Sectors) + Out.Labour_Tax_rate) .* Out.w ./ Out.Cost_Structure ) .* ( Out.lambda - BY.lambda ) + (BY.pK./BY.Cost_Structure + Out.pK./Out.Cost_Structure).*(Out.kappa - BY.kappa);

// 	Climate lump sum compensation to sectors
CompensationEffect_Cost = - (1/2)*( ones(1, nb_Sectors)./(BY.Cost_Structure.*BY.Y') + ones(1, nb_Sectors)./(Out.Cost_Structure.*Out.Y') ).*(Out.ClimPolCompensbySect - BY.ClimPolCompensbySect);

//////////////////////////
//	Decomposition Error
//////////////////////////
CostDecompositionError = (divide(d.pY,BY.pY,%nan)-1)' - ( ScaleEffect_Cost + EnergPriceEffect_Cost + NonEnergPriceEffect_Cost + NetWageEffect_Cost + LabourTaxEffect_Cost + MarginEffect_Cost + SubstitutionEffect_Cost + CompensationEffect_Cost);


//////////////////////////
//	Table
//////////////////////////
CostDecompositionTable = [["Sectors (%)", "Production Price", "Scale Effect", "Energy Price Effect", "Other Price Effect", "Net Wage Effect", "Labour Tax effect", "Margin effect", "Substitution effect", "Climate Compensation Effect", "Decomposition Error"]; [Index_Sectors, (divide(d.pY,BY.pY,%nan)-1)*100, ScaleEffect_Cost'*100, EnergPriceEffect_Cost'*100, NonEnergPriceEffect_Cost'*100, NetWageEffect_Cost'*100, LabourTaxEffect_Cost'*100, MarginEffect_Cost'*100, SubstitutionEffect_Cost'*100, CompensationEffect_Cost'*100, CostDecompositionError'*100]];
CostDecompositionTable = CostDecompositionTable';

OutputTable.CostDecomposCOMTable = [
["Carbon Tax rate-"+money+"/tCO2", 		  		(Out.Carbon_Tax_rate*eval(money_unit_data))/10^6 ];..
["Recycling_Option", 		  					Recycling_Option+' '+ClosCarbRev];..
["Production Price Decomposition - Composite (%)",   				""	  				];..
[CostDecompositionTable(2:$,1),CostDecompositionTable(2:$,$)]
];

if Output_files
 csvWrite(OutputTable.CostDecomposCOMTable,SAVEDIR+"TableCostDecomposCOM.csv", ';');
end 
