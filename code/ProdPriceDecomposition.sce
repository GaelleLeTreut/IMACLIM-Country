//////  Copyright or © or Copr. Ecole des Ponts ParisTech / CNRS 2018
//////  Main Contributor (2017) : Gaëlle Le Treut / letreut[at]centre-cired.fr
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

ini.Cost_Structure = sum(ini.pIC .* ini.alpha,"r") + sum(ini.pL .* ini.lambda,"r") + sum(ini.pK .* ini.kappa, "r") - ini.ClimPolCompensbySect./ini.Y';

//	Final cost structure

d.Cost_Structure = sum(d.pIC .* d.alpha,"r") + sum(d.pL .* d.lambda,"r") + sum(d.pK .* d.kappa, "r") - d.ClimPolCompensbySect./d.Y';

//	Scale effects

ScaleEffect_Cost	= (1/2)*( d.Theta ./ d.Phi - d.Phi ./ d.Theta );

//	Price effects

	// Energy prices
	
EnergPriceEffect_Cost = (1/2)*sum((ini.alpha(Indice_EnerSect,:)./(ones(nb_EnerSect, 1).*.ini.Cost_Structure) + d.alpha(Indice_EnerSect,:)./(ones(nb_EnerSect, 1).*.d.Cost_Structure)).*( d.pIC(Indice_EnerSect,:) - ini.pIC(Indice_EnerSect,:) ), "r");

	// Non energy prices (intermediate consumption + capital consumption)
	
NonEnergPriceEffect_Cost = (1/2)*( sum((ini.alpha(Indice_NonEnerSect,:)./(ones(nb_NonEnerSect, 1).*.ini.Cost_Structure) + d.alpha(Indice_NonEnerSect,:)./(ones(nb_NonEnerSect, 1).*.d.Cost_Structure)).*( d.pIC(Indice_NonEnerSect,:) - ini.pIC(Indice_NonEnerSect,:) ), "r") + (ini.kappa./ini.Cost_Structure + d.kappa./d.Cost_Structure).*(d.pK - ini.pK) );

	// Net-of-tax wage
	
NetWageEffect_Cost = (1/2)* ( (ones(1, nb_Sectors) + ini.Labour_Tax_rate) .* ini.lambda ./ ini.Cost_Structure + (ones(1, nb_Sectors) + d.Labour_Tax_rate) .* d.lambda ./ d.Cost_Structure ) .* ( d.w - ini.w );

	// Labour tax
	
LabourTaxEffect_Cost = (1/2)* ( ini.w .* ini.lambda ./ ini.Cost_Structure + d.w .* d.lambda ./ d.Cost_Structure ) .* ( ini.Labour_Tax_rate - d.Labour_Tax_rate );

//	Profit margin and tax on production effects
	
	//	Price-cost wedge
ini.PriceCost_wedge 	= ones(1, nb_Sectors) - ini.markup_rate - ini.Production_Tax_rate;
d.PriceCost_wedge   	= ones(1, nb_Sectors) - d.markup_rate - Production_Tax_rate;		// Rq: modifier si Production_Tax_rate est variable: d.Production_Tax_rate

MarginEffect_Cost = (1/2)* ( ini.PriceCost_wedge ./ d.PriceCost_wedge - d.PriceCost_wedge ./ ini.PriceCost_wedge );
	
//	Technical substitution effects

SubstitutionEffect_Cost = (1/2)*sum((ini.pIC(:,:)./(ones(nb_Sectors, 1).*.ini.Cost_Structure) + d.pIC(:,:)./(ones(nb_Sectors, 1).*.d.Cost_Structure)).*( d.alpha(:,:) - ini.alpha(:,:) ), "r") + ( (ones(1, nb_Sectors) + ini.Labour_Tax_rate) .* ini.w ./ ini.Cost_Structure + (ones(1, nb_Sectors) + d.Labour_Tax_rate) .* d.w ./ d.Cost_Structure ) .* ( d.lambda - ini.lambda ) + (ini.pK./ini.Cost_Structure + d.pK./d.Cost_Structure).*(d.kappa - ini.kappa);

// 	Climate lump sum compensation to sectors

CompensationEffect_Cost = - (1/2)*( ones(1, nb_Sectors)./(ini.Cost_Structure.*ini.Y') + ones(1, nb_Sectors)./(d.Cost_Structure.*d.Y') ).*(d.ClimPolCompensbySect - ini.ClimPolCompensbySect);

//	Decomposition Error

CostDecompositionError = evol.pY' - ( ScaleEffect_Cost + EnergPriceEffect_Cost + NonEnergPriceEffect_Cost + NetWageEffect_Cost + LabourTaxEffect_Cost + MarginEffect_Cost + SubstitutionEffect_Cost + CompensationEffect_Cost);

//	Table

CostDecompositionTable = [["Sectors", "Production Price", "Scale Effect", "Energy Price Effect", "Other Price Effect", "Net Wage Effect", "Labour Tax effect", "Margin effect", "Substitution effect", "Climate Compensation Effect", "Decomposition Error"]; [Index_Sectors, evol.pY*100, ScaleEffect_Cost'*100, EnergPriceEffect_Cost'*100, NonEnergPriceEffect_Cost'*100, NetWageEffect_Cost'*100, LabourTaxEffect_Cost'*100, MarginEffect_Cost'*100, SubstitutionEffect_Cost'*100, CompensationEffect_Cost'*100, CostDecompositionError'*100]];