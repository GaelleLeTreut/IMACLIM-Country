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

// Creer une structure output avec tous les indicateurs qu'on regarde ? 


if (isdef("Indice_PrimEnerSect") == %f)
	Indice_PrimEnerSect = []
end

if (isdef("Indice_FinEnerSect") == %f)
	Indice_FinEnerSect = []
end

////////////////////////////////////////////////////////////
////// Macroeconomic indicators - Indices 
////////////////////////////////////////////////////////////

////////////////////////
//////////// Domestic production Y
////////////////////////
	
 // Price indices (Laspeyres, Paasche and Fisher) - Production
Y_pLasp = PInd_Lasp( BY.pY, BY.Y, d.pY, d.Y, :, :);
Y_pPaas = PInd_Paas( BY.pY, BY.Y, d.pY, d.Y, :, :);
Y_pFish = PInd_Fish( BY.pY, BY.Y, d.pY, d.Y, :, :);

 // Price indices (Laspeyres, Paasche and Fisher) - Energy - Production
Y_En_pLasp = PInd_Lasp( BY.pY, BY.Y, d.pY, d.Y, Indice_EnerSect, :);
Y_En_pPaas = PInd_Paas( BY.pY, BY.Y, d.pY, d.Y, Indice_EnerSect, :);
Y_En_pFish = PInd_Fish( BY.pY, BY.Y, d.pY, d.Y, Indice_EnerSect, :);

 // Price indices (Laspeyres, Paasche and Fisher) - Primary Energy - Production
Y_PrimEn_pLasp = PInd_Lasp( BY.pY, BY.Y, d.pY, d.Y, Indice_PrimEnerSect, :);
Y_PrimEn_pPaas = PInd_Paas( BY.pY, BY.Y, d.pY, d.Y, Indice_PrimEnerSect, :);
Y_PrimEn_pFish = PInd_Fish( BY.pY, BY.Y, d.pY, d.Y, Indice_PrimEnerSect, :);

 // Price indices (Laspeyres, Paasche and Fisher) - Final Energy - Production
Y_FinEn_pLasp = PInd_Lasp( BY.pY, BY.Y, d.pY, d.Y, Indice_FinEnerSect, :);
Y_FinEn_pPaas = PInd_Paas( BY.pY, BY.Y, d.pY, d.Y, Indice_FinEnerSect, :);
Y_FinEn_pFish = PInd_Fish( BY.pY, BY.Y, d.pY, d.Y, Indice_FinEnerSect, :);

 // Price indices (Laspeyres, Paasche and Fisher) - Non Energy Products - Production
Y_NonEn_pLasp = PInd_Lasp( BY.pY, BY.Y, d.pY, d.Y, Indice_NonEnerSect, :);
Y_NonEn_pPaas = PInd_Paas( BY.pY, BY.Y, d.pY, d.Y, Indice_NonEnerSect, :);
Y_NonEn_pFish = PInd_Fish( BY.pY, BY.Y, d.pY, d.Y, Indice_NonEnerSect, :);

 // Quantity indices (Laspeyres, Paasche and Fisher) - Production
Y_qLasp = QInd_Lasp( BY.pY, BY.Y, d.pY, d.Y, :, :);
Y_qPaas = QInd_Paas( BY.pY, BY.Y, d.pY, d.Y, :, :);
Y_qFish = QInd_Fish( BY.pY, BY.Y, d.pY, d.Y, :, :);

////////////////////////
////////////Intermediate consumption
////////////////////////
	
 // Price indices (Laspeyres, Paasche and Fisher) - Intermediate consumption
IC_pLasp = PInd_Lasp( BY.pIC, BY.IC, d.pIC, d.IC, :, :);
IC_pPaas = PInd_Paas( BY.pIC, BY.IC, d.pIC, d.IC, :, :);
IC_pFish = PInd_Fish( BY.pIC, BY.IC, d.pIC, d.IC, :, :);

 // Quantity indices (Laspeyres, Paasche and Fisher) - Intermediate consumption
IC_qLasp = QInd_Lasp( BY.pIC, BY.IC, d.pIC, d.IC, :, :);
IC_qPaas = QInd_Paas( BY.pIC, BY.IC, d.pIC, d.IC, :, :);
IC_qFish = QInd_Fish( BY.pIC, BY.IC, d.pIC, d.IC, :, :);

 // Quantity indices (Laspeyres, Paasche and Fisher) - Intermediate consumption (inputs) - Primary Energy
IC_input_PrimEn_qLasp = QInd_Lasp( BY.pIC, BY.IC, d.pIC, d.IC, :, Indice_PrimEnerSect);
IC_input_PrimEn_qPaas = QInd_Paas( BY.pIC, BY.IC, d.pIC, d.IC, :, Indice_PrimEnerSect);
IC_input_PrimEn_qFish = QInd_Fish( BY.pIC, BY.IC, d.pIC, d.IC, :, Indice_PrimEnerSect);

 // Quantity indices (Laspeyres, Paasche and Fisher) - Intermediate consumption (inputs) - Final Energy
IC_input_FinEn_qLasp = QInd_Lasp( BY.pIC, BY.IC, d.pIC, d.IC, :, Indice_FinEnerSect);
IC_input_FinEn_qPaas = QInd_Paas( BY.pIC, BY.IC, d.pIC, d.IC, :, Indice_FinEnerSect);
IC_input_FinEn_qFish = QInd_Fish( BY.pIC, BY.IC, d.pIC, d.IC, :, Indice_FinEnerSect);

 // Quantity indices (Laspeyres, Paasche and Fisher) - Intermediate consumption (inputs) - Non Energy Products
IC_input_NonEn_qLasp = QInd_Lasp( BY.pIC, BY.IC, d.pIC, d.IC, :, Indice_NonEnerSect);
IC_input_NonEn_qPaas = QInd_Paas( BY.pIC, BY.IC, d.pIC, d.IC, :, Indice_NonEnerSect);
IC_input_NonEn_qFish = QInd_Fish( BY.pIC, BY.IC, d.pIC, d.IC, :, Indice_NonEnerSect);

 // Quantity indices (Laspeyres, Paasche and Fisher) - Intermediate consumption (uses) - Primary Energy
IC_uses_PrimEn_qLasp = QInd_Lasp( BY.pIC, BY.IC, d.pIC, d.IC, Indice_PrimEnerSect, : );
IC_uses_PrimEn_qPaas = QInd_Paas( BY.pIC, BY.IC, d.pIC, d.IC, Indice_PrimEnerSect, : );
IC_uses_PrimEn_qFish = QInd_Fish( BY.pIC, BY.IC, d.pIC, d.IC, Indice_PrimEnerSect, : );

 // Quantity indices (Laspeyres, Paasche and Fisher) - Intermediate consumption (uses) - Final Energy
IC_uses_FinEn_qLasp = QInd_Lasp( BY.pIC, BY.IC, d.pIC, d.IC, Indice_FinEnerSect, : );
IC_uses_FinEn_qPaas = QInd_Paas( BY.pIC, BY.IC, d.pIC, d.IC, Indice_FinEnerSect, : );
IC_uses_FinEn_qFish = QInd_Fish( BY.pIC, BY.IC, d.pIC, d.IC, Indice_FinEnerSect, : );

 // Quantity indices (Laspeyres, Paasche and Fisher) - Intermediate consumption (uses) - Non Energy Products
IC_uses_NonEn_qLasp = QInd_Lasp( BY.pIC, BY.IC, d.pIC, d.IC, Indice_NonEnerSect, : );
IC_uses_NonEn_qPaas = QInd_Paas( BY.pIC, BY.IC, d.pIC, d.IC, Indice_NonEnerSect, : );
IC_uses_NonEn_qFish = QInd_Fish( BY.pIC, BY.IC, d.pIC, d.IC, Indice_NonEnerSect, : );

////////////////////////	
////////////GDP
////////////////////////
	
 // Price indices (Laspeyres, Paasche and Fisher) - GDP
GDP_pLasp = (sum(d.pC.*BY.C)+sum(d.pG.*BY.G)+sum(d.pI.*BY.I)+sum(d.pX.*BY.X)-sum(d.pM.*BY.M))/BY.GDP ;
GDP_pPaas = d.GDP / (sum(BY.pC.*d.C)+sum(BY.pG.*d.G)+sum(BY.pI.*d.I)+sum(BY.pX.*d.X)-sum(BY.pM.*d.M)); 
GDP_pFish = sqrt(GDP_pLasp*GDP_pPaas);
 
 // Approximation Real_GDP (Nominal GDP / GDP Fisher Price Index )
GDP_qFish_app = d.GDP / GDP_pFish;

// Quantity indices (Laspeyres, Paasche and Fisher) - GDP
GDP_qLasp = (sum(BY.pC.*d.C)+sum(BY.pG.*d.G)+sum(BY.pI.*d.I)+sum(BY.pX.*d.X)-sum(BY.pM.*d.M))/BY.GDP ;
GDP_qPaas = d.GDP / (sum(d.pC.*BY.C)+sum(d.pG.*BY.G)+sum(d.pI.*BY.I)+sum(d.pX.*BY.X)-sum(d.pM.*BY.M)); 
GDP_qFish = sqrt(GDP_qLasp*GDP_qPaas);

////////////////////////
////////////Output
////////////////////////
	
// BY and final value for output
BY.Output_value = BY.Y_value + BY.Trade_margins + BY.Transp_margins + sum(BY.SpeMarg_IC, "r") + sum(BY.SpeMarg_C, "r") + BY.SpeMarg_X + BY.SpeMarg_I + sum(BY.Taxes, "r") + sum(BY.Carbon_Tax_IC, "c")' + sum(BY.Carbon_Tax_C, "c")' ;

d.Output_value = d.Y_value + d.Trade_margins + d.Transp_margins + sum(d.SpeMarg_IC, "r") + sum(d.SpeMarg_C, "r") + d.SpeMarg_X + d.SpeMarg_I + sum(d.Taxes, "r") + sum(d.Carbon_Tax_IC, "c")' + sum(d.Carbon_Tax_C, "c")' ;	

//	BY and final value for Total Margins
BY.TotMargins = BY.Trade_margins + BY.Transp_margins + sum(BY.SpeMarg_IC, "r") + sum(BY.SpeMarg_C, "r") + BY.SpeMarg_X + BY.SpeMarg_I + BY.Profit_margin;
d.TotMargins = d.Trade_margins + d.Transp_margins + sum(d.SpeMarg_IC, "r") + sum(d.SpeMarg_C, "r") + d.SpeMarg_X + d.SpeMarg_I + d.Profit_margin;

 // Price indices (Laspeyres, Paasche and Fisher) - Total Output
Output_pLasp = (sum(d.pIC.*BY.IC)+sum(d.pC.*BY.C)+sum(d.pG.*BY.G)+sum(d.pI.*BY.I)+sum(d.pX.*BY.X)-sum(d.pM.*BY.M))/sum(BY.Output_value) ;
Output_pPaas = sum(d.Output_value) / (sum(BY.pIC.*d.IC)+sum(BY.pC.*d.C)+sum(BY.pG.*d.G)+sum(BY.pI.*d.I)+sum(BY.pX.*d.X)-sum(BY.pM.*d.M)); 
Output_pFish = sqrt(Output_pLasp*Output_pPaas);
 
// Quantity indices (Laspeyres, Paasche and Fisher) - Total Output
Output_qLasp = (sum(BY.pIC.*d.IC)+sum(BY.pC.*d.C)+sum(BY.pG.*d.G)+sum(BY.pI.*d.I)+sum(BY.pX.*d.X)-sum(BY.pM.*d.M))/sum(BY.Output_value) ;
Output_qPaas = sum(d.Output_value) / (sum(d.pIC.*BY.IC)+sum(d.pC.*BY.C)+sum(d.pG.*BY.G)+sum(d.pI.*BY.I)+sum(d.pX.*BY.X)-sum(d.pM.*BY.M)); 
Output_qFish = sqrt(Output_qLasp*Output_qPaas);

 // Price indices (Laspeyres, Paasche and Fisher) - Primary Energy
Output_PrimEn_pLasp = (sum(d.pIC(Indice_PrimEnerSect,:).*BY.IC(Indice_PrimEnerSect,:))+sum(d.pC(Indice_PrimEnerSect,:).*BY.C(Indice_PrimEnerSect,:))+sum(d.pG(Indice_PrimEnerSect).*BY.G(Indice_PrimEnerSect))+sum(d.pI(Indice_PrimEnerSect).*BY.I(Indice_PrimEnerSect))+sum(d.pX(Indice_PrimEnerSect).*BY.X(Indice_PrimEnerSect))-sum(d.pM(Indice_PrimEnerSect).*BY.M(Indice_PrimEnerSect)))/sum(BY.Output_value(Indice_PrimEnerSect)) ;
Output_PrimEn_pPaas = sum(d.Output_value(Indice_PrimEnerSect)) / (sum(BY.pIC(Indice_PrimEnerSect,:).*d.IC(Indice_PrimEnerSect,:))+sum(BY.pC(Indice_PrimEnerSect,:).*d.C(Indice_PrimEnerSect,:))+sum(BY.pG(Indice_PrimEnerSect).*d.G(Indice_PrimEnerSect))+sum(BY.pI(Indice_PrimEnerSect).*d.I(Indice_PrimEnerSect))+sum(BY.pX(Indice_PrimEnerSect).*d.X(Indice_PrimEnerSect))-sum(BY.pM(Indice_PrimEnerSect).*d.M(Indice_PrimEnerSect))); 
Output_PrimEn_pFish = sqrt(Output_PrimEn_pLasp*Output_PrimEn_pPaas);
 
// Quantity indices (Laspeyres, Paasche and Fisher) - Primary Energy
Output_PrimEn_qLasp = (sum(BY.pIC(Indice_PrimEnerSect,:).*d.IC(Indice_PrimEnerSect,:))+sum(BY.pC(Indice_PrimEnerSect,:).*d.C(Indice_PrimEnerSect,:))+sum(BY.pG(Indice_PrimEnerSect).*d.G(Indice_PrimEnerSect))+sum(BY.pI(Indice_PrimEnerSect).*d.I(Indice_PrimEnerSect))+sum(BY.pX(Indice_PrimEnerSect).*d.X(Indice_PrimEnerSect))-sum(BY.pM(Indice_PrimEnerSect).*d.M(Indice_PrimEnerSect)))/sum(BY.Output_value(Indice_PrimEnerSect)) ;
Output_PrimEn_qPaas = sum(d.Output_value(Indice_PrimEnerSect)) / (sum(d.pIC(Indice_PrimEnerSect,:).*BY.IC(Indice_PrimEnerSect,:))+sum(d.pC(Indice_PrimEnerSect,:).*BY.C(Indice_PrimEnerSect,:))+sum(d.pG(Indice_PrimEnerSect).*BY.G(Indice_PrimEnerSect))+sum(d.pI(Indice_PrimEnerSect).*BY.I(Indice_PrimEnerSect))+sum(d.pX(Indice_PrimEnerSect).*BY.X(Indice_PrimEnerSect))-sum(d.pM(Indice_PrimEnerSect).*BY.M(Indice_PrimEnerSect))); 
Output_qFish = sqrt(Output_PrimEn_qLasp*Output_PrimEn_qPaas);

 // Price indices (Laspeyres, Paasche and Fisher) - Final Energy
Output_FinEn_pLasp = (sum(d.pIC(Indice_FinEnerSect,:).*BY.IC(Indice_FinEnerSect,:))+sum(d.pC(Indice_FinEnerSect,:).*BY.C(Indice_FinEnerSect,:))+sum(d.pG(Indice_FinEnerSect).*BY.G(Indice_FinEnerSect))+sum(d.pI(Indice_FinEnerSect).*BY.I(Indice_FinEnerSect))+sum(d.pX(Indice_FinEnerSect).*BY.X(Indice_FinEnerSect))-sum(d.pM(Indice_FinEnerSect).*BY.M(Indice_FinEnerSect)))/sum(BY.Output_value(Indice_FinEnerSect)) ;
Output_FinEn_pPaas = sum(d.Output_value(Indice_FinEnerSect)) / (sum(BY.pIC(Indice_FinEnerSect,:).*d.IC(Indice_FinEnerSect,:))+sum(BY.pC(Indice_FinEnerSect,:).*d.C(Indice_FinEnerSect,:))+sum(BY.pG(Indice_FinEnerSect).*d.G(Indice_FinEnerSect))+sum(BY.pI(Indice_FinEnerSect).*d.I(Indice_FinEnerSect))+sum(BY.pX(Indice_FinEnerSect).*d.X(Indice_FinEnerSect))-sum(BY.pM(Indice_FinEnerSect).*d.M(Indice_FinEnerSect))); 
Output_PrimEn_pFish = sqrt(Output_FinEn_pLasp*Output_FinEn_pPaas);
 
// Quantity indices (Laspeyres, Paasche and Fisher) - Final Energy
Output_FinEn_qLasp = (sum(BY.pIC(Indice_FinEnerSect,:).*d.IC(Indice_FinEnerSect,:))+sum(BY.pC(Indice_FinEnerSect,:).*d.C(Indice_FinEnerSect,:))+sum(BY.pG(Indice_FinEnerSect).*d.G(Indice_FinEnerSect))+sum(BY.pI(Indice_FinEnerSect).*d.I(Indice_FinEnerSect))+sum(BY.pX(Indice_FinEnerSect).*d.X(Indice_FinEnerSect))-sum(BY.pM(Indice_FinEnerSect).*d.M(Indice_FinEnerSect)))/sum(BY.Output_value(Indice_FinEnerSect)) ;
Output_FinEn_qPaas = sum(d.Output_value(Indice_FinEnerSect)) / (sum(d.pIC(Indice_FinEnerSect,:).*BY.IC(Indice_FinEnerSect,:))+sum(d.pC(Indice_FinEnerSect,:).*BY.C(Indice_FinEnerSect,:))+sum(d.pG(Indice_FinEnerSect).*BY.G(Indice_FinEnerSect))+sum(d.pI(Indice_FinEnerSect).*BY.I(Indice_FinEnerSect))+sum(d.pX(Indice_FinEnerSect).*BY.X(Indice_FinEnerSect))-sum(d.pM(Indice_FinEnerSect).*BY.M(Indice_FinEnerSect))); 
Output_qFish = sqrt(Output_FinEn_qLasp*Output_FinEn_qPaas);

 // Price indices (Laspeyres, Paasche and Fisher) - Non Energy Products
Output_NonEn_pLasp = (sum(d.pIC(Indice_NonEnerSect,:).*BY.IC(Indice_NonEnerSect,:))+sum(d.pC(Indice_NonEnerSect,:).*BY.C(Indice_NonEnerSect,:))+sum(d.pG(Indice_NonEnerSect).*BY.G(Indice_NonEnerSect))+sum(d.pI(Indice_NonEnerSect).*BY.I(Indice_NonEnerSect))+sum(d.pX(Indice_NonEnerSect).*BY.X(Indice_NonEnerSect))-sum(d.pM(Indice_NonEnerSect).*BY.M(Indice_NonEnerSect)))/sum(BY.Output_value(Indice_NonEnerSect)) ;
Output_NonEn_pPaas = sum(d.Output_value(Indice_NonEnerSect)) / (sum(BY.pIC(Indice_NonEnerSect,:).*d.IC(Indice_NonEnerSect,:))+sum(BY.pC(Indice_NonEnerSect,:).*d.C(Indice_NonEnerSect,:))+sum(BY.pG(Indice_NonEnerSect).*d.G(Indice_NonEnerSect))+sum(BY.pI(Indice_NonEnerSect).*d.I(Indice_NonEnerSect))+sum(BY.pX(Indice_NonEnerSect).*d.X(Indice_NonEnerSect))-sum(BY.pM(Indice_NonEnerSect).*d.M(Indice_NonEnerSect))); 
Output_PrimEn_pFish = sqrt(Output_NonEn_pLasp*Output_NonEn_pPaas);
 
// Quantity indices (Laspeyres, Paasche and Fisher) - Non Energy Products
Output_NonEn_qLasp = (sum(BY.pIC(Indice_NonEnerSect,:).*d.IC(Indice_NonEnerSect,:))+sum(BY.pC(Indice_NonEnerSect,:).*d.C(Indice_NonEnerSect,:))+sum(BY.pG(Indice_NonEnerSect).*d.G(Indice_NonEnerSect))+sum(BY.pI(Indice_NonEnerSect).*d.I(Indice_NonEnerSect))+sum(BY.pX(Indice_NonEnerSect).*d.X(Indice_NonEnerSect))-sum(BY.pM(Indice_NonEnerSect).*d.M(Indice_NonEnerSect)))/sum(BY.Output_value(Indice_NonEnerSect)) ;
Output_NonEn_qPaas = sum(d.Output_value(Indice_NonEnerSect)) / (sum(d.pIC(Indice_NonEnerSect,:).*BY.IC(Indice_NonEnerSect,:))+sum(d.pC(Indice_NonEnerSect,:).*BY.C(Indice_NonEnerSect,:))+sum(d.pG(Indice_NonEnerSect).*BY.G(Indice_NonEnerSect))+sum(d.pI(Indice_NonEnerSect).*BY.I(Indice_NonEnerSect))+sum(d.pX(Indice_NonEnerSect).*BY.X(Indice_NonEnerSect))-sum(d.pM(Indice_NonEnerSect).*BY.M(Indice_NonEnerSect))); 
Output_qFish = sqrt(Output_NonEn_qLasp*Output_NonEn_qPaas);

////////////////////////
////////////Households consumption
////////////////////////
	
 // Price indices (Laspeyres, Paasche and Fisher) - Households consumption
C_pLasp = PInd_Lasp( BY.pC, BY.C, d.pC, d.C, :, :);
C_pPaas = PInd_Paas( BY.pC, BY.C, d.pC, d.C, :, :);
C_pFish = PInd_Fish( BY.pC, BY.C, d.pC, d.C, :, :);

 // Quantity indices (Laspeyres, Paasche and Fisher) - Households consumption
C_qLasp = QInd_Lasp( BY.pC, BY.C, d.pC, d.C, :, :);
C_qPaas = QInd_Paas( BY.pC, BY.C, d.pC, d.C, :, :);
C_qFish = QInd_Fish( BY.pC, BY.C, d.pC, d.C, :, :);

 // Price indices (Laspeyres, Paasche and Fisher) - Households consumption - non energy goods
C_NonEn_pLasp = PInd_Lasp( BY.pC, BY.C, d.pC, d.C, Indice_NonEnerSect, :);
C_NonEn_pPaas = PInd_Paas( BY.pC, BY.C, d.pC, d.C, Indice_NonEnerSect, :);
C_NonEn_pFish = PInd_Fish( BY.pC, BY.C, d.pC, d.C, Indice_NonEnerSect, :);

 // Quantity indices (Laspeyres, Paasche and Fisher) - Households consumption - non energy goods
C_NonEn_qLasp = QInd_Lasp( BY.pC, BY.C, d.pC, d.C, Indice_NonEnerSect, :);
C_NonEn_qPaas = QInd_Paas( BY.pC, BY.C, d.pC, d.C, Indice_NonEnerSect, :);
C_NonEn_qFish = QInd_Fish( BY.pC, BY.C, d.pC, d.C, Indice_NonEnerSect, :);

 // Price indices (Laspeyres, Paasche and Fisher) - Households consumption - Energy goods
C_En_pLasp = PInd_Lasp( BY.pC, BY.C, d.pC, d.C, Indice_EnerSect, :);
C_En_pPaas = PInd_Paas( BY.pC, BY.C, d.pC, d.C, Indice_EnerSect, :);
C_En_pFish = PInd_Fish( BY.pC, BY.C, d.pC, d.C, Indice_EnerSect, :);

 // Quantity indices (Laspeyres, Paasche and Fisher) - Households consumption - Energy goods
C_En_qLasp = QInd_Lasp( BY.pC, BY.C, d.pC, d.C, Indice_EnerSect, :);
C_En_qPaas = QInd_Paas( BY.pC, BY.C, d.pC, d.C, Indice_EnerSect, :);
C_En_qFish = QInd_Fish( BY.pC, BY.C, d.pC, d.C, Indice_EnerSect, :);

 // Price indices (Laspeyres, Paasche and Fisher) - Households consumption - Primary goods
C_PrimEn_pLasp = PInd_Lasp( BY.pC, BY.C, d.pC, d.C, Indice_PrimEnerSect, :);
C_PrimEn_pPaas = PInd_Paas( BY.pC, BY.C, d.pC, d.C, Indice_PrimEnerSect, :);
C_PrimEn_pFish = PInd_Fish( BY.pC, BY.C, d.pC, d.C, Indice_PrimEnerSect, :);

 // Quantity indices (Laspeyres, Paasche and Fisher) - Households consumption - Primary goods
C_PrimEn_qLasp = QInd_Lasp( BY.pC, BY.C, d.pC, d.C, Indice_PrimEnerSect, :);
C_PrimEn_qPaas = QInd_Paas( BY.pC, BY.C, d.pC, d.C, Indice_PrimEnerSect, :);
C_PrimEn_qFish = QInd_Fish( BY.pC, BY.C, d.pC, d.C, Indice_PrimEnerSect, :);

 // Price indices (Laspeyres, Paasche and Fisher) - Households consumption - Final goods
C_FinEn_pLasp = PInd_Lasp( BY.pC, BY.C, d.pC, d.C, Indice_FinEnerSect, :);
C_FinEn_pPaas = PInd_Paas( BY.pC, BY.C, d.pC, d.C, Indice_FinEnerSect, :);
C_FinEn_pFish = PInd_Fish( BY.pC, BY.C, d.pC, d.C, Indice_FinEnerSect, :);

 // Quantity indices (Laspeyres, Paasche and Fisher) - Households consumption - Final goods
C_FinEn_qLasp = QInd_Lasp( BY.pC, BY.C, d.pC, d.C, Indice_FinEnerSect, :);
C_FinEn_qPaas = QInd_Paas( BY.pC, BY.C, d.pC, d.C, Indice_FinEnerSect, :);
C_FinEn_qFish = QInd_Fish( BY.pC, BY.C, d.pC, d.C, Indice_FinEnerSect, :);
 
 // Approximation real Households consumption (Nominal Households consumption / Fisher Price Index for Households consumption)
C_qFish = QInd_Fish( BY.pC,BY.C, d.pC, d.C, :, :) ;

 // Approximation real Households consumption - non energy goods
C_NonEn_qFish_app = QInd_Fish_app( BY.pC,BY.C, d.pC, d.C, Indice_NonEnerSect, :) ;

////////////////////////
////////////Public Consumption
////////////////////////

 // Price indices (Laspeyres, Paasche and Fisher) - Public consumption
G_pLasp = PInd_Lasp( BY.pG, BY.G, d.pG, d.G, :, :);
G_pPaas = PInd_Paas( BY.pG, BY.G, d.pG, d.G, :, :);
G_pFish = PInd_Fish( BY.pG, BY.G, d.pG, d.G, :, :);

 // Quantity indices (Laspeyres, Paasche and Fisher) - Public consumption
G_qLasp = QInd_Lasp( BY.pG, BY.G, d.pG, d.G, :, :);
G_qPaas = QInd_Paas( BY.pG, BY.G, d.pG, d.G, :, :);
G_qFish = QInd_Fish( BY.pG, BY.G, d.pG, d.G, :, :);

 // Price indices (Laspeyres, Paasche and Fisher) - Public consumption - non energy goods
G_NonEn_pLasp = PInd_Lasp( BY.pG, BY.G, d.pG, d.G, Indice_NonEnerSect, :);
G_NonEn_pPaas = PInd_Paas( BY.pG, BY.G, d.pG, d.G, Indice_NonEnerSect, :);
G_NonEn_pFish = PInd_Fish( BY.pG, BY.G, d.pG, d.G, Indice_NonEnerSect, :);

 // Quantity indices (Laspeyres, Paasche and Fisher) - Public consumption - non energy goods
G_NonEn_qLasp = QInd_Lasp( BY.pG, BY.G, d.pG, d.G, Indice_NonEnerSect, :);
G_NonEn_qPaas = QInd_Paas( BY.pG, BY.G, d.pG, d.G, Indice_NonEnerSect, :);
G_NonEn_qFish = QInd_Fish( BY.pG, BY.G, d.pG, d.G, Indice_NonEnerSect, :);

 // Price indices (Laspeyres, Paasche and Fisher) - Public  consumption - Energy goods
G_En_pLasp = PInd_Lasp( BY.pG, BY.G, d.pG, d.G, Indice_EnerSect, :);
G_En_pPaas = PInd_Paas( BY.pG, BY.G, d.pG, d.G, Indice_EnerSect, :);
G_En_pFish = PInd_Fish( BY.pG, BY.G, d.pG, d.G, Indice_EnerSect, :);

 // Quantity indices (Laspeyres, Paasche and Fisher) - Public consumption - Energy goods
G_En_qLasp = QInd_Lasp( BY.pG, BY.G, d.pG, d.G, Indice_EnerSect, :);
G_En_qPaas = QInd_Paas( BY.pG, BY.G, d.pG, d.G, Indice_EnerSect, :);
G_En_qFish = QInd_Fish( BY.pG, BY.G, d.pG, d.G, Indice_EnerSect, :);

 // Price indices (Laspeyres, Paasche and Fisher) - Public consumption - Primary goods
G_PrimEn_pLasp = PInd_Lasp( BY.pG, BY.G, d.pG, d.G, Indice_PrimEnerSect, :);
G_PrimEn_pPaas = PInd_Paas( BY.pG, BY.G, d.pG, d.G, Indice_PrimEnerSect, :);
G_PrimEn_pFish = PInd_Fish( BY.pG, BY.G, d.pG, d.G, Indice_PrimEnerSect, :);

 // Quantity indices (Laspeyres, Paasche and Fisher) - Public consumption - Primary goods
G_PrimEn_qLasp = QInd_Lasp( BY.pG, BY.G, d.pG, d.G, Indice_PrimEnerSect, :);
G_PrimEn_qPaas = QInd_Paas( BY.pG, BY.G, d.pG, d.G, Indice_PrimEnerSect, :);
G_PrimEn_qFish = QInd_Fish( BY.pG, BY.G, d.pG, d.G, Indice_PrimEnerSect, :);

 // Price indices (Laspeyres, Paasche and Fisher) - Public consumption - Final goods
G_FinEn_pLasp = PInd_Lasp( BY.pG, BY.G, d.pG, d.G, Indice_FinEnerSect, :);
G_FinEn_pPaas = PInd_Paas( BY.pG, BY.G, d.pG, d.G, Indice_FinEnerSect, :);
G_FinEn_pFish = PInd_Fish( BY.pG, BY.G, d.pG, d.G, Indice_FinEnerSect, :);

 // Quantity indices (Laspeyres, Paasche and Fisher) - Public consumption - Final goods
G_FinEn_qLasp = QInd_Lasp( BY.pG, BY.G, d.pG, d.G, Indice_FinEnerSect, :);
G_FinEn_qPaas = QInd_Paas( BY.pG, BY.G, d.pG, d.G, Indice_FinEnerSect, :);
G_FinEn_qFish = QInd_Fish( BY.pG, BY.G, d.pG, d.G, Indice_FinEnerSect, :);

////////////////////////	
////////////Investment
////////////////////////

 // Price indices (Laspeyres, Paasche and Fisher) - Investment
I_pLasp = PInd_Lasp( BY.pI, BY.I, d.pI, d.I, :, :);
I_pPaas = PInd_Paas( BY.pI, BY.I, d.pI, d.I, :, :);
I_pFish = PInd_Fish( BY.pI, BY.I, d.pI, d.I, :, :);

 // Quantity indices (Laspeyres, Paasche and Fisher) - Investment
I_qLasp = QInd_Lasp( BY.pI, BY.I, d.pI, d.I, :, :);
I_qPaas = QInd_Paas( BY.pI, BY.I, d.pI, d.I, :, :);
I_qFish = QInd_Fish( BY.pI, BY.I, d.pI, d.I, :, :);

 // Price indices (Laspeyres, Paasche and Fisher) - Investment - non energy goods
I_NonEn_pLasp = PInd_Lasp( BY.pI, BY.I, d.pI, d.I, Indice_NonEnerSect, :);
I_NonEn_pPaas = PInd_Paas( BY.pI, BY.I, d.pI, d.I, Indice_NonEnerSect, :);
I_NonEn_pFish = PInd_Fish( BY.pI, BY.I, d.pI, d.I, Indice_NonEnerSect, :);

 // Quantity indices (Laspeyres, Paasche and Fisher) - Investment - non energy goods
I_NonEn_qLasp = QInd_Lasp( BY.pI, BY.I, d.pI, d.I, Indice_NonEnerSect, :);
I_NonEn_qPaas = QInd_Paas( BY.pI, BY.I, d.pI, d.I, Indice_NonEnerSect, :);
I_NonEn_qFish = QInd_Fish( BY.pI, BY.I, d.pI, d.I, Indice_NonEnerSect, :);

 // Price indices (Laspeyres, Paasche and Fisher) - Investment - Energy goods
I_En_pLasp = PInd_Lasp( BY.pI, BY.I, d.pI, d.I, Indice_EnerSect, :);
I_En_pPaas = PInd_Paas( BY.pI, BY.I, d.pI, d.I, Indice_EnerSect, :);
I_En_pFish = PInd_Fish( BY.pI, BY.I, d.pI, d.I, Indice_EnerSect, :);

 // Quantity indices (Laspeyres, Paasche and Fisher) - Investment - Energy goods
I_En_qLasp = QInd_Lasp( BY.pI, BY.I, d.pI, d.I, Indice_EnerSect, :);
I_En_qPaas = QInd_Paas( BY.pI, BY.I, d.pI, d.I, Indice_EnerSect, :);
I_En_qFish = QInd_Fish( BY.pI, BY.I, d.pI, d.I, Indice_EnerSect, :);

////////////////////////
//////////// Exports
////////////////////////

 // Price indices (Laspeyres, Paasche and Fisher) - Exports
X_pLasp = PInd_Lasp( BY.pX, BY.X, d.pX, d.X, :, :);
X_pPaas = PInd_Paas( BY.pX, BY.X, d.pX, d.X, :, :);
X_pFish = PInd_Fish( BY.pX, BY.X, d.pX, d.X, :, :);

 // Price indices (Laspeyres, Paasche and Fisher) - Energy - Exports
X_En_pLasp = PInd_Lasp( BY.pX, BY.X, d.pX, d.X, Indice_EnerSect, :);
X_En_pPaas = PInd_Paas( BY.pX, BY.X, d.pX, d.X, Indice_EnerSect, :);
X_En_pFish = PInd_Fish( BY.pX, BY.X, d.pX, d.X, Indice_EnerSect, :);

 // Price indices (Laspeyres, Paasche and Fisher) - non Energy Products - Exports
X_NonEn_pLasp = PInd_Lasp( BY.pX, BY.X, d.pX, d.X, Indice_NonEnerSect, :);
X_NonEn_pPaas = PInd_Paas( BY.pX, BY.X, d.pX, d.X, Indice_NonEnerSect, :);
X_NonEn_pFish = PInd_Fish( BY.pX, BY.X, d.pX, d.X, Indice_NonEnerSect, :);

 // Price indices (Laspeyres, Paasche and Fisher) - Primary Energy - Exports
X_PrimEn_pLasp = PInd_Lasp( BY.pX, BY.X, d.pX, d.X, Indice_PrimEnerSect, :);
X_PrimEn_pPaas = PInd_Paas( BY.pX, BY.X, d.pX, d.X, Indice_PrimEnerSect, :);
X_PrimEn_pFish = PInd_Fish( BY.pX, BY.X, d.pX, d.X, Indice_PrimEnerSect, :);

 // Price indices (Laspeyres, Paasche and Fisher) - Final Energy - Exports
X_FinEn_pLasp = PInd_Lasp( BY.pX, BY.X, d.pX, d.X, Indice_FinEnerSect, :);
X_FinEn_pPaas = PInd_Paas( BY.pX, BY.X, d.pX, d.X, Indice_FinEnerSect, :);
X_FinEn_pFish = PInd_Fish( BY.pX, BY.X, d.pX, d.X, Indice_FinEnerSect, :);

 // Quantity indices (Laspeyres, Paasche and Fisher) - Exports
X_qLasp = QInd_Lasp( BY.pX, BY.X, d.pX, d.X, :, :);
X_qPaas = QInd_Paas( BY.pX, BY.X, d.pX, d.X, :, :);
X_qFish = QInd_Fish( BY.pX, BY.X, d.pX, d.X, :, :);

 // Quantity indices (Laspeyres, Paasche and Fisher) - Energy - Exports
X_En_qLasp = QInd_Lasp( BY.pX, BY.X, d.pX, d.X, Indice_EnerSect, :);
X_En_qPaas = QInd_Paas( BY.pX, BY.X, d.pX, d.X, Indice_EnerSect, :);
X_En_qFish = QInd_Fish( BY.pX, BY.X, d.pX, d.X, Indice_EnerSect, :);

 // Quantity indices (Laspeyres, Paasche and Fisher) - non Energy Products - Exports
X_NonEn_qLasp = QInd_Lasp( BY.pX, BY.X, d.pX, d.X, Indice_NonEnerSect, :);
X_NonEn_qPaas = QInd_Paas( BY.pX, BY.X, d.pX, d.X, Indice_NonEnerSect, :);
X_NonEn_qFish = QInd_Fish( BY.pX, BY.X, d.pX, d.X, Indice_NonEnerSect, :);

 // Quantity indices (Laspeyres, Paasche and Fisher) - Primary Energy - Exports
X_PrimEn_qLasp = QInd_Lasp( BY.pX, BY.X, d.pX, d.X, Indice_PrimEnerSect, :);
X_PrimEn_qPaas = QInd_Paas( BY.pX, BY.X, d.pX, d.X, Indice_PrimEnerSect, :);
X_PrimEn_qFish = QInd_Fish( BY.pX, BY.X, d.pX, d.X, Indice_PrimEnerSect, :);

 // Quantity indices (Laspeyres, Paasche and Fisher) - Final Energy - Exports
X_FinEn_qLasp = QInd_Lasp( BY.pX, BY.X, d.pX, d.X, Indice_FinEnerSect, :);
X_FinEn_qPaas = QInd_Paas( BY.pX, BY.X, d.pX, d.X, Indice_FinEnerSect, :);
X_FinEn_qFish = QInd_Fish( BY.pX, BY.X, d.pX, d.X, Indice_FinEnerSect, :);

////////////////////////
//////////// Imports
////////////////////////

 // Price indices (Laspeyres, Paasche and Fisher) - Imports
M_pLasp = PInd_Lasp( BY.pM, BY.M, d.pM, d.M, :, :);
M_pPaas = PInd_Paas( BY.pM, BY.M, d.pM, d.M, :, :);
M_pFish = PInd_Fish( BY.pM, BY.M, d.pM, d.M, :, :);

 // Price indices (Laspeyres, Paasche and Fisher) - Energy - Imports
M_En_pLasp = PInd_Lasp( BY.pM, BY.M, d.pM, d.M, Indice_EnerSect, :);
M_En_pPaas = PInd_Paas( BY.pM, BY.M, d.pM, d.M, Indice_EnerSect, :);
M_En_pFish = PInd_Fish( BY.pM, BY.M, d.pM, d.M, Indice_EnerSect, :);

 // Price indices (Laspeyres, Paasche and Fisher) - Primary Energy - Imports
M_PrimEn_pLasp = PInd_Lasp( BY.pM, BY.M, d.pM, d.M, Indice_PrimEnerSect, :);
M_PrimEn_pPaas = PInd_Paas( BY.pM, BY.M, d.pM, d.M, Indice_PrimEnerSect, :);
M_PrimEn_pFish = PInd_Fish( BY.pM, BY.M, d.pM, d.M, Indice_PrimEnerSect, :);

 // Price indices (Laspeyres, Paasche and Fisher) - Final Energy - Imports
M_FinEn_pLasp = PInd_Lasp( BY.pM, BY.M, d.pM, d.M, Indice_FinEnerSect, :);
M_FinEn_pPaas = PInd_Paas( BY.pM, BY.M, d.pM, d.M, Indice_FinEnerSect, :);
M_FinEn_pFish = PInd_Fish( BY.pM, BY.M, d.pM, d.M, Indice_FinEnerSect, :);

 // Price indices (Laspeyres, Paasche and Fisher) - Non Energy Products - Imports
M_NonEn_pLasp = PInd_Lasp( BY.pM, BY.M, d.pM, d.M, Indice_NonEnerSect, :);
M_NonEn_pPaas = PInd_Paas( BY.pM, BY.M, d.pM, d.M, Indice_NonEnerSect, :);
M_NonEn_pFish = PInd_Fish( BY.pM, BY.M, d.pM, d.M, Indice_NonEnerSect, :);

 // Quantity indices (Laspeyres, Paasche and Fisher) - Imports
M_qLasp = QInd_Lasp( BY.pM, BY.M, d.pM, d.M, :, :);
M_qPaas = QInd_Paas( BY.pM, BY.M, d.pM, d.M, :, :);
M_qFish = QInd_Fish( BY.pM, BY.M, d.pM, d.M, :, :);

 // Quantity indices (Laspeyres, Paasche and Fisher) - Energy - Imports
M_En_qLasp = QInd_Lasp( BY.pM, BY.M, d.pM, d.M, Indice_EnerSect, :);
M_En_qPaas = QInd_Paas( BY.pM, BY.M, d.pM, d.M, Indice_EnerSect, :);
M_En_qFish = QInd_Fish( BY.pM, BY.M, d.pM, d.M, Indice_EnerSect, :);

 // Quantity indices (Laspeyres, Paasche and Fisher) - non Energy Products - Imports
M_NonEn_qLasp = QInd_Lasp( BY.pM, BY.M, d.pM, d.M, Indice_NonEnerSect, :);
M_NonEn_qPaas = QInd_Paas( BY.pM, BY.M, d.pM, d.M, Indice_NonEnerSect, :);
M_NonEn_qFish = QInd_Fish( BY.pM, BY.M, d.pM, d.M, Indice_NonEnerSect, :);

 // Quantity indices (Laspeyres, Paasche and Fisher) - Primary Energy - Imports
M_PrimEn_qLasp = QInd_Lasp( BY.pM, BY.M, d.pM, d.M, Indice_PrimEnerSect, :);
M_PrimEn_qPaas = QInd_Paas( BY.pM, BY.M, d.pM, d.M, Indice_PrimEnerSect, :);
M_PrimEn_qFish = QInd_Fish( BY.pM, BY.M, d.pM, d.M, Indice_PrimEnerSect, :);

 // Quantity indices (Laspeyres, Paasche and Fisher) - Final Energy - Imports
M_FinEn_qLasp = QInd_Lasp( BY.pM, BY.M, d.pM, d.M, Indice_FinEnerSect, :);
M_FinEn_qPaas = QInd_Paas( BY.pM, BY.M, d.pM, d.M, Indice_FinEnerSect, :);
M_FinEn_qFish = QInd_Fish( BY.pM, BY.M, d.pM, d.M, Indice_FinEnerSect, :);


////////////////////////////////////////////////////////////
//	Variations of macroeconomic identities in real terms at the aggregated level 
//
//		Additive property is required for the decomposition of quantity indices : Laspeyres index must be used! ( Important Rq: this property is altered for chained indices ) 
//		But for one time period, and indices = 1 at initial state, we have the additive property: 
//			Laspeyres Quantity index (for the aggregate of components i) = sum (wi * Laspeyres Quantity index for component i)
//				with wi = the value share of component i at the initial state = (q1,0*p1,0) / sum(qi,0*pi,0)	and thus,  sum(wi) = 1
//			

	////////////////////////
////////////  First level macroeconomic identity: Output = Intermediate consumption + GDP  
	//	Rq: Here, Output_value = Y_value + Transport Margins + Trade Margins + Energy Margins + Indirect Taxes 
////////////////////////

// Initial value shares for each components of Output 
BY.IC_output_ValueShare 	= sum(BY.IC_value)/ sum(BY.Output_value);
BY.GDP_output_ValueShare 	= sum(BY.GDP)/ sum(BY.Output_value);

// Decomposition of variations for the first level macroeconomic identity
IC_Output_qLasp 	= BY.IC_output_ValueShare * IC_qLasp ;
GDP_Output_qLasp 	= BY.GDP_output_ValueShare * GDP_qLasp ;

////////////////////////
//////////// Second level macroeconomic identity: GDP = Households Consumption + Public Consumption + Investment + Exports - Imports
////////////////////////
 
// Initial value shares (in output) for each components of GDP
BY.C_Output_ValueShare	= sum(BY.C_value)/ sum(BY.Output_value); 
BY.G_Output_ValueShare	= sum(BY.G_value)/ sum(BY.Output_value); 
BY.I_Output_ValueShare	= sum(BY.I_value)/ sum(BY.Output_value); 
BY.X_Output_ValueShare	= sum(BY.X_value)/ sum(BY.Output_value); 
BY.M_Output_ValueShare	= -sum(BY.M_value)/ sum(BY.Output_value);

// Decomposition of variations for the second level macroeconomic identity
C_GDP_qLasp = BY.C_Output_ValueShare * C_qLasp ;
G_GDP_qLasp = BY.G_Output_ValueShare * G_qLasp ;
I_GDP_qLasp = BY.I_Output_ValueShare * I_qLasp ;
X_GDP_qLasp = BY.X_Output_ValueShare * X_qLasp ;
M_GDP_qLasp = BY.M_Output_ValueShare * M_qLasp ;

////////////////////////
//////////// Households Consumption = Households Non Energy consumption + Households Energy Consumption	
////////////////////////

// Initial value shares for each components of Households Consumption
BY.Ener_C_ValueShare		= sum(BY.C_value(Indice_EnerSect, :))/sum(BY.C_value) ;
BY.NonEner_C_ValueShare	= sum(BY.C_value(Indice_NonEnerSect, :))/sum(BY.C_value) ;

d.Ener_C_ValueShareFish		= (sum(d.C_value(Indice_EnerSect, :)) / C_En_pFish ) /(sum(d.C_value)/C_pFish) ;
d.NonEner_C_ValueShareFish	= (sum(d.C_value(Indice_NonEnerSect, :))/C_NonEn_pFish)/(sum(d.C_value)/C_pFish);

// Decomposition of variations - Households consumption
CEner_C_qLasp 	= BY.Ener_C_ValueShare * C_En_qLasp ;
CNonEner_C_qLasp 	= BY.NonEner_C_ValueShare * C_NonEn_qLasp ;


////////////////////////////////////////////////////////////
//////	Technical coefficients - Indices
////////////////////////////////////////////////////////////

////////////////////////
//////////// Labour intensity
////////////////////////

 //Laspeyres, Paasche and Fisher indices for labour intensity (lambda treated as price)
lambda_pLasp = PInd_Lasp( BY.lambda, BY.Y', d.lambda, d.Y', :, :);
lambda_pPaas = PInd_Paas( BY.lambda, BY.Y', d.lambda, d.Y', :, :);
lambda_pFish = PInd_Fish( BY.lambda, BY.Y', d.lambda, d.Y', :, :);

////////////////////////
//////////// Energy intensity
////////////////////////

 //Laspeyres, Paasche and Fisher indices for energy intensity (alpha treated as price)
alpha_Ener_qLasp = QInd_Lasp( BY.alpha, ones(nb_Commodities, 1).*.BY.Y', d.alpha, ones(nb_Commodities, 1).*.d.Y', Indice_EnerSect, :);
alpha_Ener_qPaas = QInd_Paas( BY.alpha, ones(nb_Commodities, 1).*.BY.Y', d.alpha, ones(nb_Commodities, 1).*.d.Y', Indice_EnerSect, :);
alpha_Ener_qFish = QInd_Fish( BY.alpha, ones(nb_Commodities, 1).*.BY.Y', d.alpha, ones(nb_Commodities, 1).*.d.Y', Indice_EnerSect, :);

////////////////////////////////////////////////////////////
////// Trade Indicators
////////////////////////////////////////////////////////////

////////////////////////
//////////// Trade intensity
////////////////////////

//////// By sectors
BY.TradeInt = TradeIntens(BY.M_value, BY.X_value', BY.Y_value);
d.TradeInt = TradeIntens(d.M_value, d.X_value', d.Y_value);
evol.TradeInt =  (divide(d.TradeInt , BY.TradeInt , %nan ) );

//////// Global
BY.TradeInt_tot = TradeIntens(sum(BY.M_value), sum(BY.X_value), sum(BY.Y_value));
d.TradeInt_tot = TradeIntens(sum(d.M_value), sum(d.X_value), sum(d.Y_value));
evol.TradeInt_tot =  (divide(d.TradeInt_tot , BY.TradeInt_tot , %nan ));

////////////////////////
//////Import penetration ratios :  ratio between the value of imports as a percentage of total domestic demand. The import penetration rate shows to what degree domestic demand D is satisfied by imports M
////////////////////////

//////// By sectors
BY.M_penetRat = M_penetRat(BY.M_value, BY.Y_value, BY.X_value');
d.M_penetRat = M_penetRat(d.M_value, d.Y_value, d.X_value');
evol.M_penetRat =  (divide(d.M_penetRat , BY.M_penetRat , %nan )); 

//////// Global
 BY.M_penetRat_tot = M_penetRat(sum(BY.M_value), sum(BY.Y_value), sum(BY.X_value));
d.M_penetRat_tot = M_penetRat(sum(d.M_value), sum(d.Y_value), sum(d.X_value));
evol.M_penetRat_tot =  (divide(d.M_penetRat_tot , BY.M_penetRat_tot , %nan )); 

////// Price and Quantity Indices for the imports/domestic production ratio in quantities (M/Y)
M_Y_Ratio_pLasp = PInd_Lasp( BY.pM./BY.pY, BY.M./BY.Y, d.pM./d.pY, d.M./d.Y, :, :);
M_Y_Ratio_pPaas = PInd_Paas( BY.pM./BY.pY, BY.M./BY.Y, d.pM./d.pY, d.M./d.Y, :, :);
M_Y_Ratio_pFish = PInd_Fish( BY.pM./BY.pY, BY.M./BY.Y, d.pM./d.pY, d.M./d.Y, :, :);

M_Y_Ratio_qLasp = QInd_Lasp( BY.pM./BY.pY, BY.M./BY.Y, d.pM./d.pY, d.M./d.Y, :, :);
M_Y_Ratio_qPaas = QInd_Paas( BY.pM./BY.pY, BY.M./BY.Y, d.pM./d.pY, d.M./d.Y, :, :);
M_Y_Ratio_qFish = QInd_Fish( BY.pM./BY.pY, BY.M./BY.Y, d.pM./d.pY, d.M./d.Y, :, :);

////////////////////////////////////////////////////////////
////// 	Total Labour (Full-time equivalent)
////////////////////////////////////////////////////////////

BY.Labour_tot = sum(BY.Labour);
d.Labour_tot = sum(d.Labour);
evol.Labour_tot = divide(d.Labour_tot, BY.Labour_tot, %nan);

BY.Unit_Labcost = BY.pL.*BY.lambda;
d.Unit_Labcost = d.pL.*d.lambda;
evol.Unit_Labcost = (divide(d.Unit_Labcost,BY.Unit_Labcost,%nan))  ;

	// Quantity indices (Laspeyres, Paasche and Fisher) - Production in Labour
	// For decomposition: Labour Variation = Index lambda (Paashes) * Index Y_Labour (Laspeyres)
Y_Labour_qLasp = QInd_Lasp( BY.lambda, BY.Y', d.lambda, d.Y', :, :);
	
	
////////////////////////////////////////////////////////////
////// Cost Share
////////////////////////////////////////////////////////////

////////////////////////
//////////// Energy Cost Share
////////////////////////

	// Energy Cost Share - By sectors
BY.ENshare = Cost_Share( BY.IC_value(Indice_EnerSect,:)  , BY.Y_value(:)') ;
d.ENshare = Cost_Share( d.IC_value(Indice_EnerSect,:)  , d.Y_value(:)') ;
evol.ENshare =  ( divide(d.ENshare , BY.ENshare , %nan ) ) ;

 //  Energy Cost Share - For non energetic sectors
 BY.ENshareNONEner = Cost_Share( sum(BY.IC_value(Indice_EnerSect,Indice_NonEnerSect))  ,sum( BY.Y_value(Indice_NonEnerSect))) ;
d.ENshareNONEner = Cost_Share( sum(d.IC_value(Indice_EnerSect,Indice_NonEnerSect))  , sum(d.Y_value(Indice_NonEnerSect))) ;
evol.ENshareNONEner =  ( divide(d.ENshareNONEner , BY.ENshareNONEner , %nan ) ) ;
 
 
	//	Energy Cost Share - All sectors (Macro level)
BY.ENshareMacro = sum(BY.IC_value(Indice_EnerSect,:)) / sum(BY.Y_value(:));
d.ENshareMacro =  sum(d.IC_value(Indice_EnerSect,:)) / sum(d.Y_value(:));
evol.ENshareMacro = divide(d.ENshareMacro , BY.ENshareMacro , %nan ) ; 

/////////////////////////
//////////// Labour Cost share - All sectors (Macro level)	
/////////////////////////
// Plutôt que recalculer voir comment utiliser Labour_income déjà calculé dans iot pour le niveau d'agrégation donné

BY.LabourShareMacro = sum(BY.Labour .* BY.pL) / sum(BY.Y_value(:));
d.LabourShareMacro   = sum(d.Labour .* d.pL) / sum(d.Y_value(:));
evol.LabourShareMacro = divide(d.LabourShareMacro , BY.LabourShareMacro , %nan ) ; 	

////////////////////////
//////////// Energy cost/ Labour cost RATIO
////////////////////////

BY.ShareEN_Lab = divide(( sum(BY.pIC(Indice_EnerSect,:).*BY.alpha(Indice_EnerSect,:),"r") ), BY.Unit_Labcost,%nan) ; 
d.ShareEN_Lab = ( sum(d.pIC(Indice_EnerSect,:).*d.alpha(Indice_EnerSect,:),"r") ) ./ d.Unit_Labcost  ;
evol.ShareEN_Lab = (divide(d.ShareEN_Lab, BY.ShareEN_Lab, %nan)) ;

////////////////////////////////////////////////////////////
////// Input Prices
////////////////////////////////////////////////////////////

////////////////////////
//////////// Mean wage
////////////////////////

BY.omega 	= sum (BY.w .* BY.Labour) / sum(BY.Labour) ;
d.omega 	= sum (d.w .* d.Labour) / sum(d.Labour) ;
evol.omega	= divide(d.omega , BY.omega , %nan ) ;

////////////////////////
//////////// Energy input price - All sectors (Macro) - Price indices (Laspeyres, Paasche and Fisher)
////////////////////////

 // Price indices (Laspeyres, Paasche and Fisher) - Energy - Intermediate Consumption
IC_Ener_pLasp = PInd_Lasp( BY.pIC, BY.IC, d.pIC, d.IC, Indice_EnerSect, :);
IC_Ener_pPaas = PInd_Paas( BY.pIC, BY.IC, d.pIC, d.IC, Indice_EnerSect, :);
IC_Ener_pFish = PInd_Fish( BY.pIC, BY.IC, d.pIC, d.IC, Indice_EnerSect, :);

 // Price indices (Laspeyres, Paasche and Fisher) - Primary Energy - Intermediate Consumption
IC_PrimEn_pLasp = PInd_Lasp( BY.pIC, BY.IC, d.pIC, d.IC, Indice_PrimEnerSect, :);
IC_PrimEn_pPaas = PInd_Paas( BY.pIC, BY.IC, d.pIC, d.IC, Indice_PrimEnerSect, :);
IC_PrimEn_pFish = PInd_Fish( BY.pIC, BY.IC, d.pIC, d.IC, Indice_PrimEnerSect, :);

 // Price indices (Laspeyres, Paasche and Fisher) - Final Energy - Intermediate Consumption
IC_FinEn_pLasp = PInd_Lasp( BY.pIC, BY.IC, d.pIC, d.IC, Indice_FinEnerSect, :);
IC_FinEn_pPaas = PInd_Paas( BY.pIC, BY.IC, d.pIC, d.IC, Indice_FinEnerSect, :);
IC_FinEn_pFish = PInd_Fish( BY.pIC, BY.IC, d.pIC, d.IC, Indice_FinEnerSect, :);

 // Price indices (Laspeyres, Paasche and Fisher) - Non Energy Products - Intermediate Consumption
IC_NonEn_pLasp = PInd_Lasp( BY.pIC, BY.IC, d.pIC, d.IC, Indice_NonEnerSect, :);
IC_NonEn_pPaas = PInd_Paas( BY.pIC, BY.IC, d.pIC, d.IC, Indice_NonEnerSect, :);
IC_NonEn_pFish = PInd_Fish( BY.pIC, BY.IC, d.pIC, d.IC, Indice_NonEnerSect, :);

 // Price indices (Laspeyres, Paasche and Fisher) - All - Intermediate Consumption
IC_pLasp = PInd_Lasp( BY.pIC, BY.IC, d.pIC, d.IC, :, :);
IC_pPaas = PInd_Paas( BY.pIC, BY.IC, d.pIC, d.IC, :, :);
IC_pFish = PInd_Fish( BY.pIC, BY.IC, d.pIC, d.IC, :, :);

	
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////  COMPARAISON TABLE FOR OUTPUT
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

// CompT.BY = [["CompT_BY", "pY", "Y vol","Y val", "pM", "M vol","M val","pX",Index_FC' + " vol",Index_FC' + " val", "Unit Labour cost", "Ener Cost Share","Ener/Labour cost", "Trade Intens", "Import Penet Rate"];[Index_Sectors, BY.pY,  BY.Y, BY.Y_value', BY.pM,  BY.M ,BY.M_value',BY.pX, BY.FC, BY.FC_value,BY.Unit_Labcost', BY.ENshare'.*100,BY.ShareEN_Lab',BY.TradeInt',BY.M_penetRat' ]];
// CompT.run = [["CompT_run", "pY", "Y vol","Y val","pM", "M vol","M val","pX", Index_FC' + " vol", Index_FC' + " val","Unit Labour cost","Ener Cost Share","Ener/Labour cost", "Trade Intens", "Import Penet Rate"];[Index_Sectors, d.pY,  d.Y,d.Y_value',d.pM,  d.M ,d.M_value',d.pX, d.FC,d.FC_value, d.Unit_Labcost', d.ENshare'.*100,d.ShareEN_Lab',d.TradeInt',d.M_penetRat']];
// CompT.evol = [["CompT%", "pY", "Y vol","Y val","pM", "M vol","M val", "pX",Index_FC' + " vol" ,Index_FC' + " val","Unit Labour cost", "Ener Cost Share","Ener/Labour cost", "Trade Intens", "Import Penet Rate"];[Index_Sectors,(divide(d.pY , BY.pY , %nan )-1).*100,  (divide(d.Y , BY.Y , %nan )-1).*100, (divide(d.Y_value' , BY.Y_value' , %nan )-1).*100,(divide(d.pM , BY.pM , %nan )-1).*100,  (divide(d.M , BY.M , %nan )-1).*100,(divide(d.M_value' , BY.M_value' , %nan )-1).*100,(divide(d.pX , BY.pX , %nan )-1).*100, (divide(d.FC , BY.FC , %nan )-1).*100,(divide(d.FC_value , BY.FC_value , %nan )),(evol.Unit_Labcost'-1).*100, d.ENshare'.*100-BY.ENshare'.*100, (evol.TradeInt' - 1).*100,(evol.M_penetRat'-1).*100]];

CompT.BY = [["CompT_BY", "pY", "Y vol", "pM", "M vol",Index_FC' + " vol", "Ener Cost Share","Trade Intens", "Import Penet Rate"];[Index_Sectors, BY.pY,  BY.Y,BY.pM,  BY.M , BY.FC,  BY.ENshare'.*100,BY.TradeInt',BY.M_penetRat' ]];
CompT.run = [["CompT_run",  "pY", "Y vol", "pM", "M vol",Index_FC' + " vol", "Ener Cost Share","Trade Intens", "Import Penet Rate"];[Index_Sectors, d.pY,  d.Y,d.pM,  d.M , d.FC, d.ENshare'.*100,d.TradeInt',d.M_penetRat']];
CompT.evol = [["CompT%",  "pY", "Y vol","pM", "M vol",Index_FC' + " vol", "Ener Cost Share","Trade Intens", "Import Penet Rate"];[Index_Sectors,(divide(d.pY , BY.pY , %nan )-1).*100,  (divide(d.Y , BY.Y , %nan )-1).*100,(divide(d.pM , BY.pM , %nan )-1).*100,  (divide(d.M , BY.M , %nan )-1).*100, (divide((abs(d.FC) > %eps).*d.FC, (abs(BY.FC) > %eps).*BY.FC , %nan )-1).*100, d.ENshare'.*100-BY.ENshare'.*100,(evol.TradeInt' - 1).*100,(evol.M_penetRat'-1).*100]];


csvWrite(CompT.BY,SAVEDIR+"CompT-BY.csv", ';');
csvWrite(CompT.run,SAVEDIR+"CompT-run.csv", ';');
csvWrite(CompT.evol,SAVEDIR+"CompT-evol.csv", ';');

// Tables for Aggregate Macroeconomic Indicators

	// Variations of Macroeconomic Quantity Index Numbers
Indice_NetLending = find(Index_DataAccount=="NetLending");

evol.MacroT1 = [["Variable", "Indice 0", "Indice 1", "% variation"]; ["Nominal Output", "1", sum(d.Output_value)./ sum(BY.Output_value), (sum(d.Output_value)./ sum(BY.Output_value)-1)*100]; ["Real Output", "1", Output_qLasp, "nan"]; ["Output price index", "1", Output_pPaas, "nan"]; ["Contribution of Nominal Intermediate consumptions to Nominal Output variation", sum(BY.IC_value) / sum(BY.Output_value), (sum(BY.IC_value)/ sum(BY.Output_value))*sum(d.IC_value)./ sum(BY.IC_value), (sum(BY.IC_value)/sum(BY.Output_value))*( sum(d.IC_value)./ sum(BY.IC_value)-1)*100]; ["Contribution of Nominal GDP to Nominal Output variation", BY.GDP/ sum(BY.Output_value), ( BY.GDP/ sum(BY.Output_value))*(d.GDP / sum(BY.GDP)), (BY.GDP/sum(BY.Output_value))*( d.GDP / BY.GDP -1 )*100]; ["Contribution of Labour income to Nominal Output variation", sum(BY.Labour_income)/sum(BY.Output_value), (sum(BY.Labour_income)/sum(BY.Output_value))*sum(d.Labour_income)./ sum(BY.Labour_income), (sum(BY.Labour_income)/sum(BY.Output_value))*( sum(d.Labour_income)./ sum(BY.Labour_income)-1)*100]; ["Contribution of Labour tax to Nominal Output variation", sum(BY.Labour_Tax)/sum(BY.Output_value), (sum(BY.Labour_Tax)/sum(BY.Output_value))*sum(d.Labour_Tax)./ sum(BY.Labour_Tax), (sum(BY.Labour_Tax)/sum(BY.Output_value))*( sum(d.Labour_Tax)./ sum(BY.Labour_Tax)-1)*100]; ["Contribution of Production taxes to Nominal Output variation", sum(BY.Production_Tax)/sum(BY.Output_value), (sum(BY.Production_Tax)/sum(BY.Output_value))*sum(d.Production_Tax)./ sum(BY.Production_Tax), (sum(BY.Production_Tax)/sum(BY.Output_value))*( sum(d.Production_Tax)./ sum(BY.Production_Tax)-1)*100]; ["Contribution of Consumption Taxes to Nominal Output variation", (sum(BY.Taxes)+sum(BY.Carbon_Tax)) / sum(BY.Output_value), ( (sum(BY.Taxes)+sum(BY.Carbon_Tax))/sum(BY.Output_value))*(sum(d.Taxes)+sum(d.Carbon_Tax))./ (sum(BY.Taxes)+sum(BY.Carbon_Tax)), ( (sum(BY.Taxes)+sum(BY.Carbon_Tax))/sum(BY.Output_value))*((sum(d.Taxes)+sum(d.Carbon_Tax))./ (sum(BY.Taxes)+sum(BY.Carbon_Tax))-1)*100]; ["Contribution of Capital income to Nominal Output variation", sum(BY.Capital_income) / sum(BY.Output_value), (sum(BY.Capital_income)/sum(BY.Output_value))*sum(d.Capital_income)./ sum(BY.Capital_income), (sum(BY.Capital_income)/sum(BY.Output_value))*( sum(d.Capital_income)./ sum(BY.Capital_income)-1)*100]; ["Contribution of Margins to Nominal Output variation", sum(BY.TotMargins)/sum(BY.Output_value), (sum(BY.TotMargins)/sum(BY.Output_value))*sum(d.TotMargins)./ sum(BY.TotMargins), (sum(BY.TotMargins)/sum(BY.Output_value))*( sum(d.TotMargins)./ sum(BY.TotMargins)-1)*100]];

evol.MacroT2 = [["Variable", "Indice 0", "Indice 1", "% variation"]; ["Contribution of Corporations disposable income to Nominal Output variation", sum(BY.Disposable_Income(Indice_Corporations))/  sum(BY.Output_value), (sum(BY.Disposable_Income(Indice_Corporations))/sum(BY.Output_value))*sum(d.Disposable_Income(Indice_Corporations))./ sum(BY.Disposable_Income(Indice_Corporations)), (sum(BY.Disposable_Income(Indice_Corporations))/sum(BY.Output_value))*( sum(d.Disposable_Income(Indice_Corporations))./ sum(BY.Disposable_Income(Indice_Corporations))-1)*100]; ["Contribution of Households disposable income to Nominal Output variation", sum(BY.Disposable_Income(Indice_Households))/sum(BY.Output_value), (sum(BY.Disposable_Income(Indice_Households))/sum(BY.Output_value))*sum(d.Disposable_Income(Indice_Households))./ sum(BY.Disposable_Income(Indice_Households)), (sum(BY.Disposable_Income(Indice_Households))/sum(BY.Output_value))*( sum(d.Disposable_Income(Indice_Households))./ sum(BY.Disposable_Income(Indice_Households))-1)*100]; ["Contribution of Government disposable income to Nominal Output variation", sum(BY.Disposable_Income(Indice_Government))/sum(BY.Output_value), (sum(BY.Disposable_Income(Indice_Government))/sum(BY.Output_value))*sum(d.Disposable_Income(Indice_Government))./ sum(BY.Disposable_Income(Indice_Government)), (sum(BY.Disposable_Income(Indice_Government))/sum(BY.Output_value))*( sum(d.Disposable_Income(Indice_Government))./ sum(BY.Disposable_Income(Indice_Government))-1)*100]; ["Contribution of Income transfers to the Rest-of-the-world to Nominal Output variation", (BY.Property_income(Indice_RestOfWorld) + BY.Other_Transfers(Indice_RestOfWorld))/sum(BY.Output_value), ((BY.Property_income(Indice_RestOfWorld) + BY.Other_Transfers(Indice_RestOfWorld))/sum(BY.Output_value))*(d.Property_income(Indice_RestOfWorld) + d.Other_Transfers(Indice_RestOfWorld))./ (BY.Property_income(Indice_RestOfWorld) + BY.Other_Transfers(Indice_RestOfWorld)), ((BY.Property_income(Indice_RestOfWorld) + BY.Other_Transfers(Indice_RestOfWorld))/sum(BY.Output_value))*( (d.Property_income(Indice_RestOfWorld) + d.Other_Transfers(Indice_RestOfWorld))./ (BY.Property_income(Indice_RestOfWorld) + BY.Other_Transfers(Indice_RestOfWorld)) -1 )*100]; ["Contribution of Domestic demand to Nominal Output variation", (sum(BY.pC.*BY.C)+sum(BY.pG.*BY.G)+sum(BY.pI.*BY.I)) / sum(BY.Output_value), ((sum(BY.pC.*BY.C)+sum(BY.pG.*BY.G)+sum(BY.pI.*BY.I)) / sum(BY.Output_value))*(sum(d.pC.*d.C)+sum(d.pG.*d.G)+sum(d.pI.*d.I))./(sum(BY.pC.*BY.C)+sum(BY.pG.*BY.G)+sum(BY.pI.*BY.I)), ((sum(BY.pC.*BY.C)+sum(BY.pG.*BY.G)+sum(BY.pI.*BY.I)) / sum(BY.Output_value))*((sum(d.pC.*d.C)+sum(d.pG.*d.G)+sum(d.pI.*d.I))./(sum(BY.pC.*BY.C)+sum(BY.pG.*BY.G)+sum(BY.pI.*BY.I))-1)*100]; ["Contribution of capital flows to Nominal Output variation", -BY.Ecotable(Indice_NetLending, Indice_RestOfWorld)/ sum(BY.Output_value), (-BY.Ecotable(Indice_NetLending, Indice_RestOfWorld)/ sum(BY.Output_value))*(d.Ecotable(Indice_NetLending, Indice_RestOfWorld)./BY.Ecotable(Indice_NetLending, Indice_RestOfWorld)), (-BY.Ecotable(Indice_NetLending, Indice_RestOfWorld)/ sum(BY.Output_value))*(d.Ecotable(Indice_NetLending, Indice_RestOfWorld)./BY.Ecotable(Indice_NetLending, Indice_RestOfWorld)-1)*100]];

evol.MacroT3 = [["Variable", "Indice 0", "Indice 1", "% variation"]; ["Contribution of Households consumption to Nominal Output variation", sum(BY.C_value)/sum(BY.Output_value), (sum(BY.C_value)/sum(BY.Output_value))*sum(d.C_value)./ sum(BY.C_value), (sum(BY.C_value)/sum(BY.Output_value))*( sum(d.C_value)./ sum(BY.C_value)-1)*100]; ["Contribution of Public consumption to Nominal Output variation", sum(BY.G_value) / sum(BY.Output_value), (sum(BY.G_value) / sum(BY.Output_value))*sum(d.G_value)./ sum(BY.G_value), (sum(BY.G_value)/sum(BY.Output_value))*( sum(d.G_value)./ sum(BY.G_value)-1)*100]; ["Contribution of Investment to Nominal Output variation", sum(BY.I_value) / sum(BY.Output_value), (sum(BY.I_value) / sum(BY.Output_value))*sum(d.I_value)./ sum(BY.I_value), (sum(BY.I_value)/sum(BY.Output_value))*( sum(d.I_value)./ sum(BY.I_value)-1)*100]; ["Contribution of Exports to Nominal Output variation", sum(BY.X_value)/ sum(BY.Output_value), (sum(BY.X_value)/sum(BY.Output_value))*sum(d.X_value)./ sum(BY.X_value), (sum(BY.X_value)/sum(BY.Output_value))*( sum(d.X_value)./ sum(BY.X_value)-1)*100]; ["Contribution of Imports to Nominal Output variation", sum(-BY.M_value)/sum(BY.Output_value), (sum(-BY.M_value)/sum(BY.Output_value))*sum(-d.M_value)./ sum(-BY.M_value), (sum(-BY.M_value)/sum(BY.Output_value))*( sum(-d.M_value)./ sum(-BY.M_value)-1)*100]];

evol.MacroT4 = [["Variable", "Indice 0", "Indice 1", "% variation"]; ["Contribution of Intermediate consumption to Real Output variation", BY.IC_output_ValueShare, BY.IC_output_ValueShare*IC_qLasp, "nan"]; ["Contribution of GDP to Real Output variation", BY.GDP_output_ValueShare, BY.GDP_output_ValueShare*GDP_qLasp, "nan"]; ["Contribution of Households consumption to real Output variation", BY.C_Output_ValueShare, BY.C_Output_ValueShare*C_qLasp, "nan"]; ["Contribution of Public consumption to real Output variation", BY.G_Output_ValueShare, BY.G_Output_ValueShare*G_qLasp, "nan"]; ["Contribution of Investment to real Output variation", BY.I_Output_ValueShare, BY.I_Output_ValueShare*I_qLasp, "nan"]; ["Contribution of Exports to real Output variation", BY.X_Output_ValueShare, BY.X_Output_ValueShare*X_qLasp, "nan"]; ["Contribution of Imports to real Output variation", BY.M_Output_ValueShare, BY.M_Output_ValueShare*M_qLasp, "nan"]];

evol.MacroT5 = [["Variable", "Indice 0", "Indice 1", "% variation"]; ["Contribution of Labour income to Real Output variation", sum(BY.Labour_income) / sum(BY.Output_value), (sum(BY.Labour_income)/ sum(BY.Output_value))*(sum(d.Labour_income)./ sum(BY.Labour_income))/GDP_pPaas, "nan"]; ["Contribution of Labour tax to Real Output variation", sum(BY.Labour_Tax) / sum(BY.Output_value), (sum(BY.Labour_Tax) / sum(BY.Output_value))*(sum(d.Labour_Tax)./ sum(BY.Labour_Tax))/GDP_pPaas, "nan"]; ["Contribution of Production taxes to Real Output variation", sum(BY.Production_Tax) / sum(BY.Output_value), (sum(BY.Production_Tax) / sum(BY.Output_value))*(sum(d.Production_Tax)./ sum(BY.Production_Tax))/GDP_pPaas, "nan"]; ["Contribution of Consumption Taxes to Real Output variation", (sum(BY.Taxes)+sum(BY.Carbon_Tax))/ sum(BY.Output_value), ((sum(BY.Taxes)+sum(BY.Carbon_Tax)) / sum(BY.Output_value))*((sum(d.Taxes)+sum(d.Carbon_Tax))./ (sum(BY.Taxes)+sum(BY.Carbon_Tax)))/GDP_pPaas, "nan"]; ["Contribution of Capital income to Real Output variation", sum(BY.Capital_income) / sum(BY.Output_value), (sum(BY.Capital_income) / sum(BY.Output_value))*(sum(d.Capital_income)./ sum(BY.Capital_income))/GDP_pPaas, "nan"]; ["Contribution of Margins to Real Output variation", sum(BY.TotMargins) / sum(BY.Output_value), (sum(BY.TotMargins) / sum(BY.Output_value))*(sum(d.TotMargins)./ sum(BY.TotMargins))/GDP_pPaas, "nan"]; ["GDP price index", "1", GDP_pPaas, (GDP_pPaas-1)*100]];

evol.MacroT6 = [["Variable", "Indice 0", "Indice 1", "% variation"]; ["Production Price (Paashes)", "1", Y_pPaas, (Y_pPaas-1)*100]; ["Intermediate Consumption Price (Paashes)", "1", IC_pPaas, (IC_pPaas-1)*100]; ["Households Consumption Price (Paashes)", "1", C_pPaas, (C_pPaas-1)*100]; ["Public Consumption Price (Paashes)", "1", G_pPaas, (G_pPaas-1)*100]; ["Investment Price (Paashes)", "1", I_pPaas, (I_pPaas-1)*100]; ["Exports Price (Paashes)", "1", X_pPaas, (X_pPaas-1)*100]; ["Imports Price (Paashes)", "1", M_pPaas, (M_pPaas-1)*100]];

//	Sector Disaggregation (Primary Energy, Final Energy, Non Energy Products)

evol.MacroT7 = [["Variable", "Indice 0", "Indice 1", "% variation"]; ["Nominal Output Primary Energy", sum(BY.Output_value(Indice_PrimEnerSect))./ sum(BY.Output_value), sum(d.Output_value(Indice_PrimEnerSect))./ sum(BY.Output_value), 100*(sum(d.Output_value(Indice_PrimEnerSect))- sum(BY.Output_value(Indice_PrimEnerSect)))./ sum(BY.Output_value)] ; ["Nominal Output Final Energy ", sum(BY.Output_value(Indice_FinEnerSect))./ sum(BY.Output_value), sum(d.Output_value(Indice_FinEnerSect))./ sum(BY.Output_value), 100*(sum(d.Output_value(Indice_FinEnerSect))- sum(BY.Output_value(Indice_FinEnerSect)))./ sum(BY.Output_value)] ; ["Nominal Output Non Energy Products", sum(BY.Output_value(Indice_NonEnerSect))./ sum(BY.Output_value), sum(d.Output_value(Indice_NonEnerSect))./ sum(BY.Output_value), 100*(sum(d.Output_value(Indice_NonEnerSect))- sum(BY.Output_value(Indice_NonEnerSect)))./ sum(BY.Output_value)] ; ["Output Real Index - Primary Energy", sum(BY.Output_value(Indice_PrimEnerSect))/sum(BY.Output_value), Output_PrimEn_qLasp*sum(BY.Output_value(Indice_PrimEnerSect))/sum(BY.Output_value), "nan"] ; ["Output Real Index - Energy Products", sum(BY.Output_value(Indice_FinEnerSect))/sum(BY.Output_value), Output_FinEn_qLasp*sum(BY.Output_value(Indice_FinEnerSect))/sum(BY.Output_value), "nan"] ; ["Output Real Index - Non Energy Products", sum(BY.Output_value(Indice_NonEnerSect))/sum(BY.Output_value), Output_NonEn_qLasp*sum(BY.Output_value(Indice_NonEnerSect))/sum(BY.Output_value), "nan"] ; ["Output Price Index - Primary Energy", "1", Output_PrimEn_pPaas, (Output_PrimEn_pPaas-1)*100] ; ["Output Price Index - Energy Products", "1", Output_FinEn_pPaas, (Output_FinEn_pPaas-1)*100] ; ["Output Price Index - Non Energy Products", "1", Output_NonEn_pPaas, (Output_NonEn_pPaas-1)*100]]; 

evol.MacroT8 = [["Contribution of Nominal Intermediate consumptions (inputs) of Primary Energy to Nominal Output variation", sum(BY.IC_value(:,Indice_PrimEnerSect)) / sum(BY.Output_value), sum(d.IC_value(:,Indice_PrimEnerSect))/sum(BY.Output_value), 100*(sum(d.IC_value(:,Indice_PrimEnerSect))-sum(BY.IC_value(:,Indice_PrimEnerSect)))/sum(BY.Output_value)] ; ["Contribution of Nominal Intermediate consumptions (inputs) of Final Energy to Nominal Output variation", sum(BY.IC_value(:,Indice_FinEnerSect)) / sum(BY.Output_value), sum(d.IC_value(:,Indice_FinEnerSect))/sum(BY.Output_value), 100*(sum(d.IC_value(:,Indice_FinEnerSect))-sum(BY.IC_value(:,Indice_FinEnerSect)))/sum(BY.Output_value)]; ["Contribution of Nominal Intermediate consumptions (inputs) of Non Energy Products to Nominal Output variation", sum(BY.IC_value(:,Indice_NonEnerSect)) / sum(BY.Output_value), sum(d.IC_value(:,Indice_NonEnerSect))/sum(BY.Output_value), 100*(sum(d.IC_value(:,Indice_NonEnerSect))-sum(BY.IC_value(:,Indice_NonEnerSect)))/sum(BY.Output_value)] ; ["Contribution of the Value Added of Primary Energy to Nominal Output variation", (sum(BY.Output_value(Indice_PrimEnerSect))- sum(BY.IC_value(:,Indice_PrimEnerSect))) / sum(BY.Output_value), (sum(d.Output_value(Indice_PrimEnerSect))- sum(d.IC_value(:,Indice_PrimEnerSect)))/ sum(BY.Output_value), 100*((sum(d.Output_value(Indice_PrimEnerSect))- sum(d.IC_value(:,Indice_PrimEnerSect)))-(sum(BY.Output_value(Indice_PrimEnerSect))- sum(BY.IC_value(:,Indice_PrimEnerSect))))/ sum(BY.Output_value)] ; ["Contribution of the Value Added of Final Energy to Nominal Output variation", (sum(BY.Output_value(Indice_FinEnerSect))- sum(BY.IC_value(:,Indice_FinEnerSect))) / sum(BY.Output_value), (sum(d.Output_value(Indice_FinEnerSect))- sum(d.IC_value(:,Indice_FinEnerSect)))/ sum(BY.Output_value), 100*((sum(d.Output_value(Indice_FinEnerSect))- sum(d.IC_value(:,Indice_FinEnerSect)))-(sum(BY.Output_value(Indice_FinEnerSect))- sum(BY.IC_value(:,Indice_FinEnerSect))))/ sum(BY.Output_value)] ; ["Contribution of the Value Added of Non Energy Products to Nominal Output variation", (sum(BY.Output_value(Indice_NonEnerSect))- sum(BY.IC_value(:,Indice_NonEnerSect))) / sum(BY.Output_value), (sum(d.Output_value(Indice_NonEnerSect))- sum(d.IC_value(:,Indice_NonEnerSect)))/ sum(BY.Output_value), 100*((sum(d.Output_value(Indice_NonEnerSect))- sum(d.IC_value(:,Indice_NonEnerSect)))-(sum(BY.Output_value(Indice_NonEnerSect))- sum(BY.IC_value(:,Indice_NonEnerSect))))/ sum(BY.Output_value)]];

evol.MacroT9 = [["Variable", "Indice 0", "Indice 1", "% variation"]; ["Contribution of Households consumption of Primary Energy to Nominal Output variation", sum(BY.C_value(Indice_PrimEnerSect,:))/sum(BY.Output_value), sum(d.C_value(Indice_PrimEnerSect,:))/ sum(BY.Output_value), 100*(sum(d.C_value(Indice_PrimEnerSect,:))-sum(BY.C_value(Indice_PrimEnerSect,:)))/sum(BY.Output_value)] ; ["Contribution of Households consumption of Final Energy to Nominal Output variation", sum(BY.C_value(Indice_FinEnerSect,:))/sum(BY.Output_value), sum(d.C_value(Indice_FinEnerSect,:))/ sum(BY.Output_value), 100*(sum(d.C_value(Indice_FinEnerSect,:))-sum(BY.C_value(Indice_FinEnerSect,:)))/sum(BY.Output_value)] ; ["Contribution of Households consumption of Non Energy Products to Nominal Output variation", sum(BY.C_value(Indice_NonEnerSect,:))/sum(BY.Output_value), sum(d.C_value(Indice_NonEnerSect,:))/ sum(BY.Output_value), 100*(sum(d.C_value(Indice_NonEnerSect,:))-sum(BY.C_value(Indice_NonEnerSect,:)))/sum(BY.Output_value)] ; ["Contribution of Public consumption of Primary Energy to Nominal Output variation", sum(BY.G_value(Indice_PrimEnerSect))/sum(BY.Output_value), sum(d.G_value(Indice_PrimEnerSect))/ sum(BY.Output_value), 100*(sum(d.G_value(Indice_PrimEnerSect))-sum(BY.G_value(Indice_PrimEnerSect)))/sum(BY.Output_value)] ; ["Contribution of Public Consumption of Final Energy to Nominal Output variation", sum(BY.G_value(Indice_FinEnerSect))/sum(BY.Output_value), sum(d.G_value(Indice_FinEnerSect))/ sum(BY.Output_value), 100*(sum(d.G_value(Indice_FinEnerSect))-sum(BY.G_value(Indice_FinEnerSect)))/sum(BY.Output_value)] ; ["Contribution of Public Consumption of Non Energy Products to Nominal Output variation", sum(BY.G_value(Indice_NonEnerSect))/sum(BY.Output_value), sum(d.G_value(Indice_NonEnerSect))/ sum(BY.Output_value), 100*(sum(d.G_value(Indice_NonEnerSect))-sum(BY.G_value(Indice_NonEnerSect)))/sum(BY.Output_value)] ; ["Contribution of Investment of Primary Energy to Nominal Output variation", sum(BY.I_value(Indice_PrimEnerSect))/sum(BY.Output_value), sum(d.I_value(Indice_PrimEnerSect))/ sum(BY.Output_value), 100*(sum(d.I_value(Indice_PrimEnerSect))-sum(BY.I_value(Indice_PrimEnerSect)))/sum(BY.Output_value)] ; ["Contribution of Investment of Final Energy to Nominal Output variation", sum(BY.I_value(Indice_FinEnerSect))/sum(BY.Output_value), sum(d.I_value(Indice_FinEnerSect))/ sum(BY.Output_value), 100*(sum(d.I_value(Indice_FinEnerSect))-sum(BY.I_value(Indice_FinEnerSect)))/sum(BY.Output_value)] ; ["Contribution of Investment of Non Energy Products to Nominal Output variation", sum(BY.I_value(Indice_NonEnerSect))/sum(BY.Output_value), sum(d.I_value(Indice_NonEnerSect))/ sum(BY.Output_value), 100*(sum(d.I_value(Indice_NonEnerSect))- sum(BY.I_value(Indice_NonEnerSect)))/sum(BY.Output_value)]];

evol.MacroT10 = [["Contribution of Exports of Primary Energy to Nominal Output variation", sum(BY.X_value(Indice_PrimEnerSect))/sum(BY.Output_value), sum(d.X_value(Indice_PrimEnerSect))/ sum(BY.Output_value), 100*(sum(d.X_value(Indice_PrimEnerSect))-sum(BY.X_value(Indice_PrimEnerSect)))/sum(BY.Output_value)] ; ["Contribution of Exports of Final Energy to Nominal Output variation", sum(BY.X_value(Indice_FinEnerSect))/sum(BY.Output_value), sum(d.X_value(Indice_FinEnerSect))/ sum(BY.Output_value), 100*(sum(d.X_value(Indice_FinEnerSect))-sum(BY.X_value(Indice_FinEnerSect)))/sum(BY.Output_value)] ; ["Contribution of Exports of Non Energy Products to Nominal Output variation", sum(BY.X_value(Indice_NonEnerSect))/sum(BY.Output_value), sum(d.X_value(Indice_NonEnerSect))/ sum(BY.Output_value), 100*(sum(d.X_value(Indice_NonEnerSect))-sum(BY.X_value(Indice_NonEnerSect)))/sum(BY.Output_value)] ; ["Contribution of Imports of Primary Energy to Nominal Output variation", sum(-BY.M_value(Indice_PrimEnerSect))/sum(BY.Output_value), sum(-d.M_value(Indice_PrimEnerSect))/ sum(BY.Output_value), 100*(sum(BY.M_value(Indice_PrimEnerSect))-sum(d.M_value(Indice_PrimEnerSect)))/sum(BY.Output_value)] ; ["Contribution of Imports of Final Energy to Nominal Output variation", sum(-BY.M_value(Indice_FinEnerSect))/sum(BY.Output_value), sum(-d.M_value(Indice_FinEnerSect))/ sum(BY.Output_value), 100*(sum(BY.M_value(Indice_FinEnerSect))-sum(d.M_value(Indice_FinEnerSect)))/sum(BY.Output_value)] ; ["Contribution of Imports of Non Energy Products to Nominal Output variation", sum(-BY.M_value(Indice_NonEnerSect))/sum(BY.Output_value), sum(-d.M_value(Indice_NonEnerSect))/ sum(BY.Output_value), 100*(sum(BY.M_value(Indice_NonEnerSect))-sum(d.M_value(Indice_NonEnerSect)))/sum(BY.Output_value)]] ;

evol.MacroT11 = [["Variable", "Indice 0", "Indice 1", "% variation"] ; ["Contribution of Intermediate consumption (inputs) of Primary Energy to Real Output variation", sum(BY.IC_value(:,Indice_PrimEnerSect))/ sum(BY.Output_value), IC_input_PrimEn_qLasp*sum(BY.IC_value(:,Indice_PrimEnerSect))/ sum(BY.Output_value), "nan"]; ["Contribution of Intermediate consumption (inputs) of Final Energy to Real Output variation", sum(BY.IC_value(:,Indice_FinEnerSect))/ sum(BY.Output_value), IC_input_FinEn_qLasp*sum(BY.IC_value(:,Indice_FinEnerSect))/ sum(BY.Output_value), "nan"] ; ["Contribution of Intermediate consumption (inputs) of Non Energy Products to Real Output variation", sum(BY.IC_value(:,Indice_NonEnerSect))/ sum(BY.Output_value), IC_input_NonEn_qLasp*sum(BY.IC_value(:,Indice_NonEnerSect))/ sum(BY.Output_value), "nan"] ; ["Contribution of Intermediate consumption (uses) of Primary Energy to Real Output variation", sum(BY.IC_value(Indice_PrimEnerSect,:))/ sum(BY.Output_value), IC_uses_PrimEn_qLasp*sum(BY.IC_value(Indice_PrimEnerSect,:))/ sum(BY.Output_value), "nan"]; ["Contribution of Intermediate consumption (uses) of Final Energy to Real Output variation", sum(BY.IC_value(Indice_FinEnerSect,:))/ sum(BY.Output_value), IC_uses_FinEn_qLasp*sum(BY.IC_value(Indice_FinEnerSect,:))/ sum(BY.Output_value), "nan"] ; ["Contribution of Intermediate consumption (uses) of Non Energy Products to Real Output variation", sum(BY.IC_value(Indice_NonEnerSect,:))/ sum(BY.Output_value), IC_uses_NonEn_qLasp*sum(BY.IC_value(Indice_NonEnerSect,:))/ sum(BY.Output_value), "nan"]];

evol.MacroT12 = [["Contribution of Households consumption of Primary Energy to real Output variation", sum(BY.C_value(Indice_PrimEnerSect,:))/ sum(BY.Output_value), C_PrimEn_qLasp*sum(BY.C_value(Indice_PrimEnerSect,:))/ sum(BY.Output_value), "nan"]; ["Contribution of Households consumption of Final Energy to real Output variation", sum(BY.C_value(Indice_FinEnerSect,:))/ sum(BY.Output_value), C_FinEn_qLasp*sum(BY.C_value(Indice_FinEnerSect,:))/ sum(BY.Output_value), "nan"] ; ["Contribution of Households consumption of Non Energy Products to real Output variation", sum(BY.C_value(Indice_NonEnerSect,:))/ sum(BY.Output_value), C_NonEn_qLasp*sum(BY.C_value(Indice_NonEnerSect,:))/ sum(BY.Output_value), "nan"] ; ["Contribution of Public consumption of Primary Energy to real Output variation", sum(BY.G_value(Indice_PrimEnerSect))/ sum(BY.Output_value), G_PrimEn_qLasp*sum(BY.G_value(Indice_PrimEnerSect))/ sum(BY.Output_value), "nan"]; ["Contribution of Public Consumption of Final Energy to real Output variation", sum(BY.G_value(Indice_FinEnerSect))/ sum(BY.Output_value), G_FinEn_qLasp*sum(BY.G_value(Indice_FinEnerSect))/ sum(BY.Output_value), "nan"] ; ["Contribution of Public Consumption of Non Energy Products to real Output variation", sum(BY.G_value(Indice_NonEnerSect))/ sum(BY.Output_value), G_NonEn_qLasp*sum(BY.G_value(Indice_NonEnerSect))/ sum(BY.Output_value), "nan"] ; ["Contribution of Investment of Non Energy Products to real Output variation", sum(BY.I_value(Indice_NonEnerSect))/ sum(BY.Output_value), I_NonEn_qLasp*sum(BY.I_value(Indice_NonEnerSect))/ sum(BY.Output_value), "nan"] ; ["Contribution of Exports of Primary Energy to real Output variation", sum(BY.X_value(Indice_PrimEnerSect))/ sum(BY.Output_value), X_PrimEn_qLasp*sum(BY.X_value(Indice_PrimEnerSect))/ sum(BY.Output_value), "nan"]; ["Contribution of Exports of Final Energy to real Output variation", sum(BY.X_value(Indice_FinEnerSect))/ sum(BY.Output_value), X_FinEn_qLasp*sum(BY.X_value(Indice_FinEnerSect))/ sum(BY.Output_value), "nan"] ; ["Contribution of Exports of Non Energy Products to real Output variation", sum(BY.X_value(Indice_NonEnerSect))/ sum(BY.Output_value), X_NonEn_qLasp*sum(BY.X_value(Indice_NonEnerSect))/ sum(BY.Output_value), "nan"] ; ["Contribution of Imports of Primary Energy to real Output variation", sum(-BY.M_value(Indice_PrimEnerSect))/ sum(BY.Output_value), M_PrimEn_qLasp*sum(-BY.M_value(Indice_PrimEnerSect))/ sum(BY.Output_value), "nan"]; ["Contribution of Imports of Final Energy to real Output variation", sum(-BY.M_value(Indice_FinEnerSect))/ sum(BY.Output_value), M_FinEn_qLasp*sum(-BY.M_value(Indice_FinEnerSect))/ sum(BY.Output_value), "nan"] ; ["Contribution of Imports of Non Energy Products to real Output variation", sum(-BY.M_value(Indice_NonEnerSect))/ sum(BY.Output_value), M_NonEn_qLasp*sum(-BY.M_value(Indice_NonEnerSect))/ sum(BY.Output_value), "nan"]];

evol.MacroT13 = [["Variable", "Indice 0", "Indice 1", "% variation"]; ["Total Energy", (sum(BY.Y(Indice_EnerSect))+sum(BY.M(Indice_EnerSect)))/(sum(BY.Y(Indice_EnerSect))+sum(BY.M(Indice_EnerSect))), (sum(d.Y(Indice_EnerSect))+sum(d.M(Indice_EnerSect)))/(sum(BY.Y(Indice_EnerSect))+sum(BY.M(Indice_EnerSect))), ((sum(d.Y(Indice_EnerSect))+sum(d.M(Indice_EnerSect)))/(sum(BY.Y(Indice_EnerSect))+sum(BY.M(Indice_EnerSect)))-1)*100]; ["Domestic production Primary Energy (Crude Oil, Gas, Coal)", sum(BY.Y(Indice_PrimEnerSect)) / (sum(BY.Y(Indice_EnerSect))+sum(BY.M(Indice_EnerSect))), sum(d.Y(Indice_PrimEnerSect)) / (sum(BY.Y(Indice_EnerSect))+sum(BY.M(Indice_EnerSect))), (sum(d.Y(Indice_PrimEnerSect)) - sum(BY.Y(Indice_PrimEnerSect)))/ (sum(BY.Y(Indice_EnerSect))+sum(BY.M(Indice_EnerSect)))*100]; ["Imports Primary Energy (Crude Oil, Gas, Coal)", sum(BY.M(Indice_PrimEnerSect)) / (sum(BY.Y(Indice_EnerSect))+sum(BY.M(Indice_EnerSect))), sum(d.M(Indice_PrimEnerSect)) / (sum(BY.Y(Indice_EnerSect))+sum(BY.M(Indice_EnerSect))), (sum(d.M(Indice_PrimEnerSect))- sum(BY.M(Indice_PrimEnerSect)))/ (sum(BY.Y(Indice_EnerSect))+sum(BY.M(Indice_EnerSect)))*100]; ["Exports Primary Energy (Crude Oil, Gas, Coal)", sum(BY.X(Indice_PrimEnerSect)) / (sum(BY.Y(Indice_EnerSect))+sum(BY.M(Indice_EnerSect))), sum(d.X(Indice_PrimEnerSect)) / (sum(BY.Y(Indice_EnerSect))+sum(BY.M(Indice_EnerSect))), (sum(d.X(Indice_PrimEnerSect))- sum(BY.X(Indice_PrimEnerSect)))/ (sum(BY.Y(Indice_EnerSect))+sum(BY.M(Indice_EnerSect)))*100]; ["Domestic production Final Energy", sum(BY.Y(Indice_FinEnerSect)) / (sum(BY.Y(Indice_EnerSect))+sum(BY.M(Indice_EnerSect))), sum(d.Y(Indice_FinEnerSect)) / (sum(BY.Y(Indice_EnerSect))+sum(BY.M(Indice_EnerSect))), (sum(d.Y(Indice_FinEnerSect))- sum(BY.Y(Indice_FinEnerSect)))/ (sum(BY.Y(Indice_EnerSect))+sum(BY.M(Indice_EnerSect)))*100]; ["Imports Final Energy", sum(BY.M(Indice_FinEnerSect)) / (sum(BY.Y(Indice_EnerSect))+sum(BY.M(Indice_EnerSect))), sum(d.M(Indice_FinEnerSect)) / (sum(BY.Y(Indice_EnerSect))+sum(BY.M(Indice_EnerSect))), (sum(d.M(Indice_FinEnerSect))- sum(BY.M(Indice_FinEnerSect)))/ (sum(BY.Y(Indice_EnerSect))+sum(BY.M(Indice_EnerSect)))*100]; ["Exports Final Energy", sum(BY.X(Indice_FinEnerSect)) / (sum(BY.Y(Indice_EnerSect))+sum(BY.M(Indice_EnerSect))), sum(d.X(Indice_FinEnerSect)) / (sum(BY.Y(Indice_EnerSect))+sum(BY.M(Indice_EnerSect))), (sum(d.X(Indice_FinEnerSect))- sum(BY.X(Indice_FinEnerSect)))/ (sum(BY.Y(Indice_EnerSect))+sum(BY.M(Indice_EnerSect)))*100]; ["Intermediate Energy Consumptions", sum(BY.IC(Indice_EnerSect,:)) / (sum(BY.Y(Indice_EnerSect))+sum(BY.M(Indice_EnerSect))), sum(d.IC(Indice_EnerSect,:)) / (sum(BY.Y(Indice_EnerSect))+sum(BY.M(Indice_EnerSect))), (sum(d.IC(Indice_EnerSect,:))- sum(BY.IC(Indice_EnerSect,:)))/ (sum(BY.Y(Indice_EnerSect))+sum(BY.M(Indice_EnerSect)))*100]; ["Final Energy Consumptions", sum(BY.C(Indice_EnerSect,:)) / (sum(BY.Y(Indice_EnerSect))+sum(BY.M(Indice_EnerSect))), sum(d.C(Indice_EnerSect,:)) / (sum(BY.Y(Indice_EnerSect))+sum(BY.M(Indice_EnerSect))), (sum(d.C(Indice_EnerSect,:))- sum(BY.C(Indice_EnerSect,:)))/ (sum(BY.Y(Indice_EnerSect))+sum(BY.M(Indice_EnerSect)))*100]] ;

evol.MacroT14 = [["Production Price Primary Energy (Crude Oil, Gas, Coal)", "1", Y_PrimEn_pPaas, (Y_PrimEn_pPaas-1)*100]; ["Production Price Final Energy", "1", Y_FinEn_pPaas, (Y_FinEn_pPaas-1)*100]; ["Production Price Non Energy Products", "1", Y_NonEn_pPaas, (Y_NonEn_pPaas-1)*100] ; ["Imports Price for Primary Energy (Crude Oil, Gas, Coal)", "1", M_PrimEn_pPaas, (M_PrimEn_pPaas-1)*100]; ["Exports Price for Primary Energy (Crude Oil, Gas, Coal)", "1", X_PrimEn_pPaas, (X_PrimEn_pPaas-1)*100]; ["Imports Price for Final Energy", "1", M_FinEn_pPaas, (M_FinEn_pPaas-1)*100]; ["Exports Price for Final Energy", "1", X_FinEn_pPaas, (X_FinEn_pPaas-1)*100]; ["Imports Price for Non Energy Products", "1", M_NonEn_pPaas, (M_NonEn_pPaas-1)*100]; ["Exports Price for Non Energy Products", "1", X_NonEn_pPaas, (X_NonEn_pPaas-1)*100] ; ["Primary Energy Consumption Price (Paashes)", "1", C_PrimEn_pPaas, (C_PrimEn_pPaas-1)*100]; ["Final Energy Consumption Price (Paashes)", "1", C_FinEn_pPaas, (C_FinEn_pPaas-1)*100] ; ["Non Energy Products Consumption Price (Paashes)", "1", C_NonEn_pPaas, (C_NonEn_pPaas-1)*100] ; ["Primary Energy Public Consumption Price (Paashes)", "1", G_PrimEn_pPaas, (G_PrimEn_pPaas-1)*100]; ["Final Energy Public Consumption Price (Paashes)", "1", G_FinEn_pPaas, (G_FinEn_pPaas-1)*100] ; ["Non Energy Products Public Consumption Price (Paashes)", "1", G_NonEn_pPaas, (G_NonEn_pPaas-1)*100] ; ["Non Energy Products Investment Price (Paashes)", "1", I_NonEn_pPaas, (I_NonEn_pPaas-1)*100] ; ["Intermediate Primary Energy Consumption Price (Paashes)", "1", IC_PrimEn_pPaas, (IC_PrimEn_pPaas-1)*100]; ["Intermediate Final Energy Consumption Price (Paashes)", "1", IC_FinEn_pPaas, (IC_FinEn_pPaas-1)*100] ; ["Intermediate Non Energy Products Consumption Price (Paashes)", "1", IC_NonEn_pPaas, (IC_NonEn_pPaas-1)*100] ; ["Nominal Investment in the Energy Sector", "1", sum(Betta * sum(d.kappa(Indice_EnerSect).*d.Y(Indice_EnerSect)').*d.pI)/sum(Betta * sum(BY.kappa(Indice_EnerSect).*BY.Y(Indice_EnerSect)').*BY.pI), (sum(Betta * sum(d.kappa(Indice_EnerSect).*d.Y(Indice_EnerSect)').*d.pI)/sum(Betta * sum(BY.kappa(Indice_EnerSect).*BY.Y(Indice_EnerSect)').*BY.pI)-1)*100]; ["Investment share in the Energy Sector", "1", (sum(Betta * sum(d.kappa(Indice_EnerSect).*d.Y(Indice_EnerSect)').*d.pI) / sum(Betta * sum(d.kappa.*d.Y').*d.pI))/(sum(Betta * sum(BY.kappa(Indice_EnerSect).*BY.Y(Indice_EnerSect)').*BY.pI) / sum(Betta * sum(BY.kappa.*BY.Y').*BY.pI)), ((sum(Betta * sum(d.kappa(Indice_EnerSect).*d.Y(Indice_EnerSect)').*d.pI) / sum(Betta * sum(d.kappa.*d.Y').*d.pI))/(sum(Betta * sum(BY.kappa(Indice_EnerSect).*BY.Y(Indice_EnerSect)').*BY.pI) / sum(Betta * sum(BY.kappa.*BY.Y').*BY.pI))-1)*100]];

	// Simulated Values

// Aggregated 
evol.MacroT15 = [["Variable", "Value 0", "Value 1", "Unit"]; ["Total Output", sum(BY.Output_value)/10^6, sum(d.Output_value)/10^6, "billion Euros"]; ["Total Intermediate Consumptions", sum(BY.IC_value)/10^6, sum(d.IC_value)/10^6, "billion Euros"]; ["Total Value-Added (GDP)", sum(BY.GDP)/10^6, sum(d.GDP)/10^6, "billion Euros"]; ["Total Labour Income", sum(BY.Labour_income)/10^6, sum(d.Labour_income)/10^6, "billion Euros"]; ["Total Labour Tax", sum(BY.Labour_Tax)/10^6, sum(d.Labour_Tax)/10^6, "billion Euros"]; ["Total Production Tax", sum(BY.Production_Tax)/10^6, sum(d.Production_Tax)/10^6, "billion Euros"]; ["Total Consumption Tax", (sum(BY.Taxes)+sum(BY.Carbon_Tax))/10^6, (sum(d.Taxes)+sum(d.Carbon_Tax))/10^6, "billion Euros"]; ["Total Capital income", sum(BY.Capital_income)/10^6, sum(d.Capital_income)/10^6, "billion Euros"]; ["Total Margins", sum(BY.TotMargins)/10^6, sum(d.TotMargins)/10^6, "billion Euros"]; ["Total Private Consumption", sum(BY.C_value)/10^6, sum(d.C_value)/10^6, "billion Euros"]; ["Total Public Consumption", sum(BY.G_value)/10^6, sum(d.G_value)/10^6, "billion Euros"]; ["Total Gross fixed Capital Formation", sum(BY.I_value)/10^6, sum(d.I_value)/10^6, "billion Euros"]; ["Total Exports", sum(BY.X_value)/10^6, sum(d.X_value)/10^6, "billion Euros"]; ["Total Imports", -sum(BY.M_value)/10^6, -sum(d.M_value)/10^6, "billion Euros"]; ["Net Income Transfers to the rest-of-the-world", BY.Property_income(Indice_RestOfWorld)/10^6 + BY.Other_Transfers(Indice_RestOfWorld)/10^6, d.Property_income(Indice_RestOfWorld)/10^6 + d.Other_Transfers(Indice_RestOfWorld)/10^6, "billion Euros"]; ["Corporations Disposable Income", sum(BY.Disposable_Income(Indice_Corporations))/10^6, sum(d.Disposable_Income(Indice_Corporations))/10^6, "billion Euros"]; ["Private Disposable Income", sum(BY.Disposable_Income(Indice_Households))/10^6, sum(d.Disposable_Income(Indice_Households))/10^6, "billion Euros"]; ["Public Disposable Income", sum(BY.Disposable_Income(Indice_Government))/10^6, sum(d.Disposable_Income(Indice_Government))/10^6, "billion Euros"]; ["Domestic Demand",  (sum(BY.C_value)+sum(BY.G_value)+sum(BY.I_value))/10^6, (sum(d.C_value)+sum(d.G_value)+sum(d.I_value))/10^6, "billion Euros"]; ["Capital Flows",  -BY.Ecotable(Indice_NetLending, Indice_RestOfWorld)/10^6, -d.Ecotable(Indice_NetLending, Indice_RestOfWorld)/10^6, "billion Euros"] ];

// Primary Energies
evol.MacroT16 = [["Variable", "Value 0", "Value 1", "Unit"]; ["Primary Energies - Output", sum(BY.Output_value(Indice_PrimEnerSect))/10^6, sum(d.Output_value(Indice_PrimEnerSect))/10^6, "billion Euros"]; ["Primary Energies - Intermediate Consumptions (Inputs)", sum(BY.IC_value(:, Indice_PrimEnerSect))/10^6, sum(d.IC_value(:, Indice_PrimEnerSect))/10^6, "billion Euros"]; ["Primary Energies - Intermediate Consumptions (Outputs)", sum(BY.IC_value(Indice_PrimEnerSect,:))/10^6, sum(d.IC_value(Indice_PrimEnerSect,:))/10^6, "billion Euros"]; ["Primary Energies - Value-Added", sum(BY.Output_value(Indice_PrimEnerSect))/10^6- sum(BY.IC_value(:,Indice_PrimEnerSect))/10^6, sum(d.Output_value(Indice_PrimEnerSect))/10^6- sum(d.IC_value(:,Indice_PrimEnerSect))/10^6, "billion Euros"]; ["Primary Energies - Labour Income", sum(BY.Labour_income(Indice_PrimEnerSect))/10^6, sum(d.Labour_income(Indice_PrimEnerSect))/10^6, "billion Euros"]; ["Primary Energies - Labour Tax", sum(BY.Labour_Tax(Indice_PrimEnerSect))/10^6, sum(d.Labour_Tax(Indice_PrimEnerSect))/10^6, "billion Euros"]; ["Primary Energies - Production Tax", sum(BY.Production_Tax(Indice_PrimEnerSect))/10^6, sum(d.Production_Tax(Indice_PrimEnerSect))/10^6, "billion Euros"]; ["Primary Energies - Consumption Tax", sum(BY.Taxes(:,Indice_PrimEnerSect))/10^6+sum(BY.Carbon_Tax(:,Indice_PrimEnerSect))/10^6, sum(d.Taxes(:,Indice_PrimEnerSect))/10^6+sum(d.Carbon_Tax(:,Indice_PrimEnerSect))/10^6, "billion Euros"]; ["Primary Energies - Capital income", sum(BY.Capital_income(Indice_PrimEnerSect))/10^6, sum(d.Capital_income(Indice_PrimEnerSect))/10^6, "billion Euros"]; ["Primary Energies - Margins", sum(BY.TotMargins(Indice_PrimEnerSect))/10^6, sum(d.TotMargins(Indice_PrimEnerSect))/10^6, "billion Euros"]; ["Primary Energies - Private Consumption", sum(BY.C_value(Indice_PrimEnerSect))/10^6, sum(d.C_value(Indice_PrimEnerSect))/10^6, "billion Euros"]; ["Primary Energies - Public Consumption", sum(BY.G_value(Indice_PrimEnerSect))/10^6, sum(d.G_value(Indice_PrimEnerSect))/10^6, "billion Euros"]; ["Primary Energies - Gross fixed Capital Formation", sum(BY.I_value(Indice_PrimEnerSect))/10^6, sum(d.I_value(Indice_PrimEnerSect))/10^6, "billion Euros"]; ["Primary Energies - Exports", sum(BY.X_value(Indice_PrimEnerSect))/10^6, sum(d.X_value(Indice_PrimEnerSect))/10^6, "billion Euros"]; ["Primary Energies - Imports", -sum(BY.M_value(Indice_PrimEnerSect))/10^6, -sum(d.M_value(Indice_PrimEnerSect))/10^6, "billion Euros"] ];

// Final Energies
evol.MacroT17 = [["Variable", "Value 0", "Value 1", "Unit"]; ["Final Energies - Output", sum(BY.Output_value(Indice_FinEnerSect))/10^6, sum(d.Output_value(Indice_FinEnerSect))/10^6, "billion Euros"]; ["Final Energies - Intermediate Consumptions (Inputs)", sum(BY.IC_value(:, Indice_FinEnerSect))/10^6, sum(d.IC_value(:, Indice_FinEnerSect))/10^6, "billion Euros"]; ["Final Energies - Intermediate Consumptions (Outputs)", sum(BY.IC_value(Indice_FinEnerSect,:))/10^6, sum(d.IC_value(Indice_FinEnerSect,:))/10^6, "billion Euros"]; ["Final Energies - Value-Added", sum(BY.Output_value(Indice_FinEnerSect))/10^6 - sum(BY.IC_value(:,Indice_FinEnerSect))/10^6, sum(d.Output_value(Indice_FinEnerSect))/10^6 - sum(d.IC_value(:,Indice_FinEnerSect))/10^6, "billion Euros"]; ["Final Energies - Labour Income", sum(BY.Labour_income(Indice_FinEnerSect))/10^6, sum(d.Labour_income(Indice_FinEnerSect))/10^6, "billion Euros"]; ["Final Energies - Labour Tax", sum(BY.Labour_Tax(Indice_FinEnerSect))/10^6, sum(d.Labour_Tax(Indice_FinEnerSect))/10^6, "billion Euros"]; ["Final Energies - Production Tax", sum(BY.Production_Tax(Indice_FinEnerSect)/10^6), sum(d.Production_Tax(Indice_FinEnerSect))/10^6, "billion Euros"]; ["Final Energies - Consumption Tax", sum(BY.Taxes(:,Indice_FinEnerSect))/10^6 + sum(BY.Carbon_Tax(:,Indice_FinEnerSect))/10^6, sum(d.Taxes(:,Indice_FinEnerSect))/10^6 + sum(d.Carbon_Tax(:,Indice_FinEnerSect))/10^6, "billion Euros"]; ["Final Energies - Capital income", sum(BY.Capital_income(Indice_FinEnerSect))/10^6, sum(d.Capital_income(Indice_FinEnerSect))/10^6, "billion Euros"]; ["Final Energies - Margins", sum(BY.TotMargins(Indice_FinEnerSect))/10^6, sum(d.TotMargins(Indice_FinEnerSect))/10^6, "billion Euros"]; ["Final Energies - Private Consumption", sum(BY.C_value(Indice_FinEnerSect))/10^6, sum(d.C_value(Indice_FinEnerSect))/10^6, "billion Euros"]; ["Final Energies - Public Consumption", sum(BY.G_value(Indice_FinEnerSect))/10^6, sum(d.G_value(Indice_FinEnerSect))/10^6, "billion Euros"]; ["Final Energies - Gross fixed Capital Formation", sum(BY.I_value(Indice_FinEnerSect))/10^6, sum(d.I_value(Indice_FinEnerSect))/10^6, "billion Euros"]; ["Final Energies - Exports", sum(BY.X_value(Indice_FinEnerSect))/10^6, sum(d.X_value(Indice_FinEnerSect))/10^6, "billion Euros"]; ["Final Energies - Imports", -sum(BY.M_value(Indice_FinEnerSect))/10^6, -sum(d.M_value(Indice_FinEnerSect))/10^6, "billion Euros"] ];

// Non Energy Products
evol.MacroT18 = [["Variable", "Value 0", "Value 1", "Unit"]; ["Non Energy Products - Output", sum(BY.Output_value(Indice_NonEnerSect))/10^6, sum(d.Output_value(Indice_NonEnerSect))/10^6, "billion Euros"]; ["Non Energy Products - Intermediate Consumptions (Inputs)", sum(BY.IC_value(:, Indice_NonEnerSect))/10^6, sum(d.IC_value(:, Indice_NonEnerSect))/10^6, "billion Euros"]; ["Non Energy Products - Intermediate Consumptions (Outputs)", sum(BY.IC_value(Indice_NonEnerSect,:))/10^6, sum(d.IC_value(Indice_NonEnerSect,:))/10^6, "billion Euros"]; ["Non Energy Products - Value-Added", sum(BY.Output_value(Indice_NonEnerSect))/10^6 - sum(BY.IC_value(:,Indice_NonEnerSect))/10^6, sum(d.Output_value(Indice_NonEnerSect))/10^6 - sum(d.IC_value(:,Indice_NonEnerSect))/10^6, "billion Euros"]; ["Non Energy Products - Labour Income", sum(BY.Labour_income(Indice_NonEnerSect))/10^6, sum(d.Labour_income(Indice_NonEnerSect))/10^6, "billion Euros"]; ["Non Energy Products - Labour Tax", sum(BY.Labour_Tax(Indice_NonEnerSect))/10^6, sum(d.Labour_Tax(Indice_NonEnerSect))/10^6, "billion Euros"]; ["Non Energy Products - Production Tax", sum(BY.Production_Tax(Indice_NonEnerSect))/10^6, sum(d.Production_Tax(Indice_NonEnerSect))/10^6, "billion Euros"]; ["Non Energy Products - Consumption Tax", sum(BY.Taxes(:,Indice_NonEnerSect))/10^6 + sum(BY.Carbon_Tax(:,Indice_NonEnerSect))/10^6, sum(d.Taxes(:,Indice_NonEnerSect))/10^6 + sum(d.Carbon_Tax(:,Indice_NonEnerSect))/10^6, "billion Euros"]; ["Non Energy Products - Capital income", sum(BY.Capital_income(Indice_NonEnerSect))/10^6, sum(d.Capital_income(Indice_NonEnerSect))/10^6, "billion Euros"]; ["Non Energy Products - Margins", sum(BY.TotMargins(Indice_NonEnerSect))/10^6, sum(d.TotMargins(Indice_NonEnerSect))/10^6, "billion Euros"]; ["Non Energy Products - Private Consumption", sum(BY.C_value(Indice_NonEnerSect))/10^6, sum(d.C_value(Indice_NonEnerSect))/10^6, "billion Euros"]; ["Non Energy Products - Public Consumption", sum(BY.G_value(Indice_NonEnerSect))/10^6, sum(d.G_value(Indice_NonEnerSect))/10^6, "billion Euros"]; ["Non Energy Products - Gross fixed Capital Formation", sum(BY.I_value(Indice_NonEnerSect))/10^6, sum(d.I_value(Indice_NonEnerSect))/10^6, "billion Euros"]; ["Non Energy Products - Exports", sum(BY.X_value(Indice_NonEnerSect))/10^6, sum(d.X_value(Indice_NonEnerSect))/10^6, "billion Euros"]; ["Non Energy Products - Imports", -sum(BY.M_value(Indice_NonEnerSect))/10^6, -sum(d.M_value(Indice_NonEnerSect))/10^6, "billion Euros"] ];
 
//	Demography
evol.MacroT19 = [ ["Variable", "Value 0", "Value 1", "Unit"]; ["Total population ", sum(BY.Population), sum(d.Population), "Thousands of people"]; ["Active Population", sum(BY.Labour_force), sum(d.Labour_force), "Thousands of people"]; ["Inactive Population", sum(BY.Population) - sum(BY.Labour_force), sum(d.Population) - sum(d.Labour_force), "Thousands of people"]; ["Working Population", (1-BY.u_tot)*sum(BY.Labour_force), (1-d.u_tot)*sum(d.Labour_force), "Thousands of people"]; ["Unemployed", BY.u_tot*sum(BY.Labour_force), d.u_tot*sum(d.Labour_force), "Thousands of people"]; ["Formal Labour", sum(BY.Labour), sum(d.Labour), "Full Time equivalents"];  ["Formal Labour - Primary Energies", sum(BY.Labour(Indice_PrimEnerSect) ), sum(d.Labour(Indice_PrimEnerSect)), "Full Time equivalents"]; ["Formal Labour", sum(BY.Labour(Indice_FinEnerSect)), sum(d.Labour(Indice_FinEnerSect)), "Full Time equivalents"]; ["Formal Labour", sum(BY.Labour(Indice_NonEnerSect)), sum(d.Labour(Indice_NonEnerSect)), "Full Time equivalents"]] ;
 
	//	Energy - Physical Quantities

// Total Energy
evol.MacroT20 = [["Variable", "Value 0", "Value 1", "Unit"] ; ["Total Energy", sum(BY.Y(Indice_EnerSect)) + sum(BY.M(Indice_EnerSect)), sum(d.Y(Indice_EnerSect)) + sum(d.M(Indice_EnerSect)), "kTons Oil Equivalent"] ; ["Total Energy Output", sum(BY.Y(Indice_EnerSect)), sum(d.Y(Indice_EnerSect)), "kTons Oil Equivalent"] ; ["Total Intermediate Energy Consumption (Inputs)", sum(BY.IC(:,Indice_EnerSect)), sum(d.IC(:,Indice_EnerSect)), "kTons Oil Equivalent"] ; ["Total Energy Imports", sum(BY.M(Indice_EnerSect)), sum(d.M(Indice_EnerSect)), "kTons Oil Equivalent"] ; ["Total Intermediate Energy Consumption (Demand)", sum(BY.IC(Indice_EnerSect,:)), sum(d.IC(Indice_EnerSect,:)), "kTons Oil Equivalent"] ; ["Total Final Energy Demand", sum(BY.C(Indice_EnerSect,:)) + sum(BY.X(Indice_EnerSect)), sum(d.X(Indice_EnerSect)) + sum(d.C(Indice_EnerSect,:)), "kTons Oil Equivalent"] ; ["Total Private Energy Consumption", sum(BY.C(Indice_EnerSect,:)), sum(d.C(Indice_EnerSect,:)), "kTons Oil Equivalent"] ; ["Total Energy Exports", sum(BY.X(Indice_EnerSect)), sum(d.X(Indice_EnerSect)), "kTons Oil Equivalent"]];

// Primary Energy
evol.MacroT21 = [["Variable", "Value 0", "Value 1", "Unit"] ; ["Total Primary Energy", sum(BY.Y(Indice_PrimEnerSect)) + sum(BY.M(Indice_PrimEnerSect)), sum(d.Y(Indice_PrimEnerSect)) + sum(d.M(Indice_PrimEnerSect)), "kTons Oil Equivalent"] ; ["Total Primary Energy Output", sum(BY.Y(Indice_PrimEnerSect)), sum(d.Y(Indice_PrimEnerSect)), "kTons Oil Equivalent"] ; ["Total Intermediate Energy Consumption - Primary Energy (Inputs)", sum(BY.IC(:,Indice_PrimEnerSect)), sum(d.IC(:,Indice_PrimEnerSect)), "kTons Oil Equivalent"] ; ["Total Primary Energy Imports", sum(BY.M(Indice_PrimEnerSect)), sum(d.M(Indice_PrimEnerSect)), "kTons Oil Equivalent"] ; ["Total Intermediate Energy Consumption - Primary Energy (Demand)", sum(BY.IC(Indice_PrimEnerSect,:)), sum(d.IC(Indice_PrimEnerSect,:)), "kTons Oil Equivalent"] ; ["Total Final Energy Demand - Primary Energy", sum(BY.C(Indice_PrimEnerSect,:)) + sum(BY.X(Indice_PrimEnerSect)), sum(d.X(Indice_PrimEnerSect)) + sum(d.C(Indice_PrimEnerSect,:)), "kTons Oil Equivalent"] ; ["Total Private Primary Energy Consumption", sum(BY.C(Indice_PrimEnerSect,:)), sum(d.C(Indice_PrimEnerSect,:)), "kTons Oil Equivalent"] ; ["Total Primary Energy Exports", sum(BY.X(Indice_PrimEnerSect)), sum(d.X(Indice_PrimEnerSect)), "kTons Oil Equivalent"]];

// Final Energy
evol.MacroT22 = [["Variable", "Value 0", "Value 1", "Unit"] ; ["Total Final Energy", sum(BY.Y(Indice_FinEnerSect)) + sum(BY.M(Indice_FinEnerSect)), sum(d.Y(Indice_FinEnerSect)) + sum(d.M(Indice_FinEnerSect)), "kTons Oil Equivalent"] ; ["Total Final Energy Output", sum(BY.Y(Indice_FinEnerSect)), sum(d.Y(Indice_FinEnerSect)), "kTons Oil Equivalent"] ; ["Total Intermediate Energy Consumption - Final Energies (Inputs)", sum(BY.IC(:,Indice_FinEnerSect)), sum(d.IC(:,Indice_FinEnerSect)), "kTons Oil Equivalent"] ; ["Total Final Energy Imports", sum(BY.M(Indice_FinEnerSect)), sum(d.M(Indice_FinEnerSect)), "kTons Oil Equivalent"] ; ["Total Intermediate Energy Consumption - Final Energies (Demand)", sum(BY.IC(Indice_FinEnerSect,:)), sum(d.IC(Indice_FinEnerSect,:)), "kTons Oil Equivalent"] ; ["Total Final Energy Demand - Final Energies ", sum(BY.C(Indice_FinEnerSect,:)) + sum(BY.X(Indice_FinEnerSect)), sum(d.X(Indice_FinEnerSect)) + sum(d.C(Indice_FinEnerSect,:)), "kTons Oil Equivalent"] ; ["Total Private Final Energy Consumption", sum(BY.C(Indice_FinEnerSect,:)), sum(d.C(Indice_FinEnerSect,:)), "kTons Oil Equivalent"] ; ["Total Final Energy Exports", sum(BY.X(Indice_FinEnerSect)), sum(d.X(Indice_FinEnerSect)), "kTons Oil Equivalent"]];

	//	Energy - Physical Prices

// Total Energy 
evol.MacroT23 = [["Variable", "Value 0", "Value 1", "Unit"] ; ["Total Energy (Pre-tax price)", (sum(BY.Y_value(Indice_EnerSect))+sum(BY.M_value(Indice_EnerSect)))/(sum(BY.Y(Indice_EnerSect)) + sum(BY.M(Indice_EnerSect))), (sum(d.Y_value(Indice_EnerSect))+sum(d.M_value(Indice_EnerSect)))/(sum(d.Y(Indice_EnerSect)) + sum(d.M(Indice_EnerSect))), "Euros per Ton Oil Equivalent"] ;["Total Energy (After-tax Price)", (sum(BY.Output_value(Indice_EnerSect))+sum(BY.M_value(Indice_EnerSect)))/(sum(BY.Y(Indice_EnerSect)) + sum(BY.M(Indice_EnerSect))), (sum(d.Output_value(Indice_EnerSect))+sum(d.M_value(Indice_EnerSect)))/(sum(d.Y(Indice_EnerSect)) + sum(d.M(Indice_EnerSect))), "Euros per Ton Oil Equivalent"] ; ["Total Energy Output", sum(BY.Y_value(Indice_EnerSect)) / sum(BY.Y(Indice_EnerSect)), sum(d.Y_value(Indice_EnerSect)) / sum(d.Y(Indice_EnerSect)), "Euros per Ton Oil Equivalent"] ; ["Total Intermediate Energy Consumption (Inputs)", sum(BY.IC_value(Indice_EnerSect,Indice_EnerSect)) / sum(BY.IC(Indice_EnerSect,Indice_EnerSect)), sum(d.IC_value(Indice_EnerSect,Indice_EnerSect)) / sum(d.IC(Indice_EnerSect,Indice_EnerSect)), "Euros per Ton Oil Equivalent"] ; ["Total Energy Imports", sum(BY.M_value(Indice_EnerSect)) / sum(BY.M(Indice_EnerSect)), sum(d.M_value(Indice_EnerSect)) / sum(d.M(Indice_EnerSect)), "Euros per Ton Oil Equivalent"] ; ["Total Intermediate Energy Consumption (Demand)", sum(BY.IC_value(Indice_EnerSect,:)) / sum(BY.IC(Indice_EnerSect,:)), sum(d.IC_value(Indice_EnerSect,:)) / sum(d.IC(Indice_EnerSect,:)), "Euros per Ton Oil Equivalent"] ; ["Total Final Energy Demand", (sum(BY.C_value(Indice_EnerSect,:)) + sum(BY.X_value(Indice_EnerSect))) / (sum(BY.C(Indice_EnerSect,:)) + sum(BY.X(Indice_EnerSect))), (sum(d.C_value(Indice_EnerSect,:)) + sum(d.X_value(Indice_EnerSect))) / (sum(d.C(Indice_EnerSect,:)) + sum(d.X(Indice_EnerSect))), "Euros per Ton Oil Equivalent"] ; ["Total Private Energy Consumption", sum(BY.C_value(Indice_EnerSect,:)) / sum(BY.C(Indice_EnerSect,:)), sum(d.C_value(Indice_EnerSect,:)) / sum(d.C(Indice_EnerSect,:)), "kTons Oil Equivalent"] ; ["Total Energy Exports", sum(BY.X_value(Indice_EnerSect)) / sum(BY.X(Indice_EnerSect)), sum(d.X_value(Indice_EnerSect)) / sum(d.X(Indice_EnerSect)), "Euros per Ton Oil Equivalent"]];

// Primary Energy
evol.MacroT24 = [["Variable", "Value 0", "Value 1", "Unit"] ; ["Total Primary Energy (Pre-tax price)", (sum(BY.Y_value(Indice_PrimEnerSect))+sum(BY.M_value(Indice_PrimEnerSect)))/(sum(BY.Y(Indice_PrimEnerSect)) + sum(BY.M(Indice_PrimEnerSect))), (sum(d.Y_value(Indice_PrimEnerSect))+sum(d.M_value(Indice_PrimEnerSect)))/(sum(d.Y(Indice_PrimEnerSect)) + sum(d.M(Indice_PrimEnerSect))), "Euros per Ton Oil Equivalent"] ;["Total primary Energy (After-tax Price)", (sum(BY.Output_value(Indice_PrimEnerSect))+sum(BY.M_value(Indice_PrimEnerSect)))/(sum(BY.Y(Indice_PrimEnerSect)) + sum(BY.M(Indice_PrimEnerSect))), (sum(d.Output_value(Indice_PrimEnerSect))+sum(d.M_value(Indice_PrimEnerSect)))/(sum(d.Y(Indice_PrimEnerSect)) + sum(d.M(Indice_PrimEnerSect))), "Euros per Ton Oil Equivalent"] ; ["Total Primary Energy Output", sum(BY.Y_value(Indice_PrimEnerSect)) / sum(BY.Y(Indice_PrimEnerSect)), sum(d.Y_value(Indice_PrimEnerSect)) / sum(d.Y(Indice_PrimEnerSect)), "Euros per Ton Oil Equivalent"] ; ["Total Intermediate Energy Consumption - Primary Energy (Inputs)", sum(BY.IC_value(Indice_EnerSect,Indice_PrimEnerSect)) / sum(BY.IC(Indice_EnerSect,Indice_PrimEnerSect)), sum(d.IC_value(Indice_EnerSect,Indice_PrimEnerSect)) / sum(d.IC(Indice_EnerSect,Indice_PrimEnerSect)), "Euros per Ton Oil Equivalent"] ; ["Total Primary Energy Imports", sum(BY.M_value(Indice_PrimEnerSect)) / sum(BY.M(Indice_PrimEnerSect)), sum(d.M_value(Indice_PrimEnerSect)) / sum(d.M(Indice_PrimEnerSect)), "Euros per Ton Oil Equivalent"] ; ["Total Intermediate Energy Consumption - Primary Energy (Demand)", sum(BY.IC_value(Indice_PrimEnerSect,:)) / sum(BY.IC(Indice_PrimEnerSect,:)), sum(d.IC_value(Indice_PrimEnerSect,:)) / sum(d.IC(Indice_PrimEnerSect,:)), "Euros per Ton Oil Equivalent"] ; ["Total Final Primary Energy Demand", (sum(BY.C_value(Indice_PrimEnerSect,:)) + sum(BY.X_value(Indice_PrimEnerSect))) / (sum(BY.C(Indice_PrimEnerSect,:)) + sum(BY.X(Indice_PrimEnerSect))), (sum(d.C_value(Indice_PrimEnerSect,:)) + sum(d.X_value(Indice_PrimEnerSect))) / (sum(d.C(Indice_PrimEnerSect,:)) + sum(d.X(Indice_PrimEnerSect))), "Euros per Ton Oil Equivalent"] ; ["Total Private Primary Energy Consumption", sum(BY.C_value(Indice_PrimEnerSect,:)) / sum(BY.C(Indice_PrimEnerSect,:)), sum(d.C_value(Indice_PrimEnerSect,:)) / sum(d.C(Indice_PrimEnerSect,:)), "kTons Oil Equivalent"] ; ["Total Primary Energy Exports", sum(BY.X_value(Indice_PrimEnerSect)) / sum(BY.X(Indice_PrimEnerSect)), sum(d.X_value(Indice_PrimEnerSect)) / sum(d.X(Indice_PrimEnerSect)), "Euros per Ton Oil Equivalent"]];

// Final Energy Products
evol.MacroT25 = [["Variable", "Value 0", "Value 1", "Unit"] ; ["Total Final Energy (Pre-tax price)", (sum(BY.Y_value(Indice_FinEnerSect))+sum(BY.M_value(Indice_FinEnerSect)))/(sum(BY.Y(Indice_FinEnerSect)) + sum(BY.M(Indice_FinEnerSect))), (sum(d.Y_value(Indice_FinEnerSect))+sum(d.M_value(Indice_FinEnerSect)))/(sum(d.Y(Indice_FinEnerSect)) + sum(d.M(Indice_FinEnerSect))), "Euros per Ton Oil Equivalent"] ;["Total Final Energy (After-tax Price)", (sum(BY.Output_value(Indice_FinEnerSect))+sum(BY.M_value(Indice_FinEnerSect)))/(sum(BY.Y(Indice_FinEnerSect)) + sum(BY.M(Indice_FinEnerSect))), (sum(d.Output_value(Indice_FinEnerSect))+sum(d.M_value(Indice_FinEnerSect)))/(sum(d.Y(Indice_FinEnerSect)) + sum(d.M(Indice_FinEnerSect))), "Euros per Ton Oil Equivalent"] ; ["Total Energy Output", sum(BY.Y_value(Indice_FinEnerSect)) / sum(BY.Y(Indice_FinEnerSect)), sum(d.Y_value(Indice_FinEnerSect)) / sum(d.Y(Indice_FinEnerSect)), "Euros per Ton Oil Equivalent"] ; ["Total Intermediate Energy Consumption - Final Energies (Inputs)", sum(BY.IC_value(Indice_EnerSect,Indice_FinEnerSect)) / sum(BY.IC(Indice_EnerSect,Indice_FinEnerSect)), sum(d.IC_value(Indice_EnerSect,Indice_FinEnerSect)) / sum(d.IC(Indice_EnerSect,Indice_FinEnerSect)), "Euros per Ton Oil Equivalent"] ; ["Total Final Energy Imports", sum(BY.M_value(Indice_FinEnerSect)) / sum(BY.M(Indice_FinEnerSect)), sum(d.M_value(Indice_FinEnerSect)) / sum(d.M(Indice_FinEnerSect)), "Euros per Ton Oil Equivalent"] ; ["Total Intermediate Energy Consumption - Final Energies (Demand)", sum(BY.IC_value(Indice_FinEnerSect,:)) / sum(BY.IC(Indice_FinEnerSect,:)), sum(d.IC_value(Indice_FinEnerSect,:)) / sum(d.IC(Indice_FinEnerSect,:)), "Euros per Ton Oil Equivalent"] ; ["Total Final Energy Demand - Final Energies ", (sum(BY.C_value(Indice_FinEnerSect,:)) + sum(BY.X_value(Indice_FinEnerSect))) / (sum(BY.C(Indice_FinEnerSect,:)) + sum(BY.X(Indice_FinEnerSect))), (sum(d.C_value(Indice_FinEnerSect,:)) + sum(d.X_value(Indice_FinEnerSect))) / (sum(d.C(Indice_FinEnerSect,:)) + sum(d.X(Indice_FinEnerSect))), "Euros per Ton Oil Equivalent"] ; ["Total Private Final Energy Consumption", sum(BY.C_value(Indice_FinEnerSect,:)) / sum(BY.C(Indice_FinEnerSect,:)), sum(d.C_value(Indice_FinEnerSect,:)) / sum(d.C(Indice_FinEnerSect,:)), "kTons Oil Equivalent"] ; ["Total Final Energy Exports", sum(BY.X_value(Indice_FinEnerSect)) / sum(BY.X(Indice_FinEnerSect)), sum(d.X_value(Indice_FinEnerSect)) / sum(d.X(Indice_FinEnerSect)), "Euros per Ton Oil Equivalent"]];

	//	CO2 Emissions
	
evol.MacroT27 = [["Variable", "Value 0", "Value 1", "Unit"] ; ["Total Emissions", BY.DOM_CO2, d.DOM_CO2, "Mega Ton CO2"] ; ["Emissions from intermediate Consumptions", sum(BY.CO2Emis_IC), sum(d.CO2Emis_IC), "Mega Ton CO2"] ; ["Emissions from Private Consumption", sum(BY.CO2Emis_C), sum(d.CO2Emis_C), "Mega Ton CO2"] ; ["Total Emissions - Primary Energies", sum(BY.CO2Emis_IC(Indice_PrimEnerSect,:)) + sum(BY.CO2Emis_C(Indice_PrimEnerSect,:)), sum(d.CO2Emis_IC(Indice_PrimEnerSect,:)) + sum(d.CO2Emis_C(Indice_PrimEnerSect,:)), "Mega Ton CO2"] ; ["Emissions from intermediate Consumptions - Primary energies", sum(BY.CO2Emis_IC(Indice_PrimEnerSect,:)), sum(d.CO2Emis_IC(Indice_PrimEnerSect,:)), "Mega Ton CO2"] ; ["Emissions from Private Consumption - Primary energies", sum(BY.CO2Emis_C(Indice_PrimEnerSect,:)), sum(d.CO2Emis_C(Indice_PrimEnerSect,:)), "Mega Ton CO2"] ; ["Total Emissions - Final Energies", sum(BY.CO2Emis_IC(Indice_FinEnerSect,:)) + sum(BY.CO2Emis_C(Indice_FinEnerSect,:)), sum(d.CO2Emis_IC(Indice_FinEnerSect,:)) + sum(d.CO2Emis_C(Indice_FinEnerSect,:)), "Mega Ton CO2"] ; ["Emissions from intermediate Consumptions - Final energies", sum(BY.CO2Emis_IC(Indice_FinEnerSect,:)), sum(d.CO2Emis_IC(Indice_FinEnerSect,:)), "Mega Ton CO2"] ; ["Emissions from Private Consumption - Final energies", sum(BY.CO2Emis_C(Indice_FinEnerSect,:)), sum(d.CO2Emis_C(Indice_FinEnerSect,:)), "Mega Ton CO2"]];

	// Other 
	
evol.MacroT28 = [["Variable", "Indice 0", "Indice 1", "% variation"]; ["Real Households consumption", "1", C_qLasp, (C_qLasp-1)*100]; ["Energy in real Households consumption", BY.Ener_C_ValueShare, BY.Ener_C_ValueShare*C_En_qLasp, BY.Ener_C_ValueShare*(C_En_qLasp-1)*100]; ["Non energy goods in real Households consumption", BY.NonEner_C_ValueShare, BY.NonEner_C_ValueShare*C_NonEn_qLasp, BY.NonEner_C_ValueShare*(C_NonEn_qLasp-1)*100]; ["Real Imports/Domestic production ratio","1", M_Y_Ratio_qLasp, (M_Y_Ratio_qLasp-1)*100];["Unemployment rate (indice, % points)", "1", d.u_tot/BY.u_tot, d.u_tot - BY.u_tot]; ["Total Employment", "1", d.Labour_tot/BY.Labour_tot, (evol.Labour_tot-1)*100]; ["Production contribution to labour variation (Laspeyres)", "1", Y_Labour_qLasp, (Y_Labour_qLasp-1)*100]; ["Labour Intensity (Paashes)","1", lambda_pPaas, (lambda_pPaas-1)*100]; ["Production Price (Laspeyres)", "1", Y_pLasp, (Y_pLasp-1)*100]; ["Production Price (Paashes)", "1", Y_pPaas, (Y_pPaas-1)*100]; ["Energy Intensity (Paashes)", "1", alpha_Ener_qPaas, (alpha_Ener_qPaas-1)*100]; ["Energy cost share", "1", d.ENshareMacro/BY.ENshareMacro, (evol.ENshareMacro - 1)*100]; ["Labour cost share", "1", d.LabourShareMacro/BY.LabourShareMacro, (evol.LabourShareMacro - 1)*100]; ["Energy Input Price (Laspeyres)", "1", IC_Ener_pLasp, (IC_Ener_pLasp-1)*100]; ["Energy Input Price (Paashes)", "1", IC_Ener_pPaas, (IC_Ener_pPaas-1)*100]; ["Mean Labour Cost", "1", d.omega/BY.omega, (evol.omega - 1)*100]; ["Net-of-tax wages", "1", NetWage_variation, (NetWage_variation-1)*100]; ["Labour tax rate (% points)", "0", "nan",- Labour_Tax_Cut]; ["Total Emissions", "1", d.DOM_CO2/BY.DOM_CO2, evol.DOM_CO2*100]; ["Households Consumption Price (Laspeyres)", "1", C_pLasp, (C_pLasp-1)*100]; ["Households Consumption Price (Paashes)", "1", C_pPaas, (C_pPaas-1)*100]; ["Households energy Consumption Price (Laspeyres)", "1", C_En_pLasp, (C_En_pLasp-1)*100]; ["Households Energy Consumption Price (Paashes)", "1", C_En_pPaas, (C_En_pPaas-1)*100]; ["Households energy Consumption Price (Laspeyres)", "1", C_NonEn_pLasp, (C_NonEn_pLasp-1)*100]; ["Households Non Energy Consumption Price (Paashes)", "1", C_NonEn_pPaas, (C_NonEn_pPaas-1)*100]; ["Public Deficits", "1", d.Ecotable(Indice_NetLending, Indice_Government)/BY.Ecotable(Indice_NetLending, Indice_Government), evol.Ecotable(Indice_NetLending, Indice_Government)*100]];
 
//// GLT TABLE - JANUARY 2017
 if abs(d.Labour_Tax_Cut)> %eps
 DispLabTabl = "Labour tax reduction";
 else
  DispLabTabl = "No recycling revenues";
  d.Labour_Tax_Cut = (abs(d.Labour_Tax_Cut) > %eps).*d.Labour_Tax_Cut;
 end

if  ConstrainedShare_C(Indice_EnerSect ) <> 0
Decarb_HH_config = "High";
else
Decarb_HH_config="Low";
end

if  ConstrainedShare_IC(Indice_EnerSect ) <> 0
Decarb_F_config = "High";
else
Decarb_F_config="Low";
end


OutputTable.GDP_decomBIS = [["Variable", "Nominal 0 (G€)", "Nominal 1 (G€)", "Price Index (Paasche)", "Real 1 (G€)", "Real term ratio"]; ["GDP", round(BY.GDP/10^5)/10, round(d.GDP/10^5)/10, GDP_pPaas, round((d.GDP/GDP_pPaas)/10^5)/10, GDP_qLasp];["Households consumption", round(sum(d.C_value)/10^5)/10, round(sum(d.C_value)/10^5)/10, C_pPaas, round((sum(d.C_value)/C_pPaas)/10^5)/10, C_qLasp]; ["Households consumption - Non-energy goods", round(sum(d.C_value(Indice_NonEnerSect,:))/10^5)/10, round(sum(d.C_value(Indice_NonEnerSect,:))/10^5)/10, C_NonEn_pPaas, round((sum(d.C_value(Indice_NonEnerSect,:))/C_NonEn_pPaas)/10^5)/10, C_NonEn_qLasp];["Households consumption - Energy goods", round(sum(d.C_value(Indice_EnerSect,:))/10^5)/10, round(sum(d.C_value(Indice_EnerSect,:))/10^5)/10, C_En_pPaas, round((sum(d.C_value(Indice_EnerSect,:))/C_En_pPaas)/10^5)/10, C_En_qLasp]; ["Government consumption", round(sum(d.G_value)/10^5)/10, round(sum(d.G_value)/10^5)/10, G_pPaas, round((sum(d.G_value)/G_pPaas)/10^5)/10, G_qLasp];["Government consumption - Non-energy goods", round(sum(d.G_value(Indice_NonEnerSect))/10^5)/10, round(sum(d.G_value(Indice_NonEnerSect))/10^5)/10, G_NonEn_pPaas, round((sum(d.G_value(Indice_NonEnerSect,:))/G_NonEn_pPaas)/10^5)/10, G_NonEn_qLasp]; ["Government consumption - Energy goods", round(sum(d.G_value(Indice_EnerSect))/10^5)/10, round(sum(d.G_value(Indice_EnerSect))/10^5)/10, G_En_pPaas, round((sum(d.G_value(Indice_EnerSect))/G_En_pPaas)/10^5)/10, G_En_qLasp];["Investment", round(sum(d.I_value)/10^5)/10, round(sum(d.I_value)/10^5)/10, I_pPaas, round((sum(d.I_value)/I_pPaas)/10^5)/10, I_qLasp];["Investment - Non-energy goods", round(sum(d.I_value(Indice_NonEnerSect))/10^5)/10, round(sum(d.I_value(Indice_NonEnerSect))/10^5)/10, I_NonEn_pPaas, round((sum(d.I_value(Indice_NonEnerSect,:))/I_NonEn_pPaas)/10^5)/10, I_NonEn_qLasp]; ["Investment - Energy goods", round(sum(d.I_value(Indice_EnerSect))/10^5)/10, round(sum(d.I_value(Indice_EnerSect))/10^5)/10, I_En_pPaas, round((sum(d.I_value(Indice_EnerSect))/I_En_pPaas)/10^5)/10, I_En_qLasp];["Exports", round(sum(d.X_value)/10^5)/10, round(sum(d.X_value)/10^5)/10, X_pPaas, round((sum(d.X_value)/X_pPaas)/10^5)/10, X_qLasp];["Exports - Non-energy goods", round(sum(d.X_value(Indice_NonEnerSect))/10^5)/10, round(sum(d.X_value(Indice_NonEnerSect))/10^5)/10, X_NonEn_pPaas, round((sum(d.X_value(Indice_NonEnerSect,:))/X_NonEn_pPaas)/10^5)/10, X_NonEn_qLasp]; ["Exports - Energy goods", round(sum(d.X_value(Indice_EnerSect))/10^5)/10, round(sum(d.X_value(Indice_EnerSect))/10^5)/10, X_En_pPaas, round((sum(d.X_value(Indice_EnerSect))/X_En_pPaas)/10^5)/10, X_En_qLasp];["Imports", round(sum(d.M_value)/10^5)/10, round(sum(d.M_value)/10^5)/10, M_pPaas, round((sum(d.M_value)/M_pPaas)/10^5)/10, M_qLasp];["Imports - Non-energy goods", round(sum(d.M_value(Indice_NonEnerSect))/10^5)/10, round(sum(d.M_value(Indice_NonEnerSect))/10^5)/10, M_NonEn_pPaas, round((sum(d.M_value(Indice_NonEnerSect))/M_NonEn_pPaas)/10^5)/10, M_NonEn_qLasp];["Imports - Energy goods", round(sum(d.M_value(Indice_EnerSect))/10^5)/10, round(sum(d.M_value(Indice_EnerSect))/10^5)/10, M_En_pPaas, round((sum(d.M_value(Indice_EnerSect))/M_En_pPaas)/10^5)/10, M_En_qLasp]; ["Net-of-tax wages", "-" , "-" ,"-" , "for nominal ratio:" ,NetWage_variation] ;["Total Employment", "-" , "-" ,"-" , "Abs ratio:" ,evol.Labour_tot]];

 // OutputTable.GDP_decom = [[ ["Real Macro results", "in Ratio"];["Real GDP (Laspeyres)", (GDP_qLasp)];["Households consumption in GDP",(sum(BY.C_value)/BY.GDP) *(C_qLasp)]; ["Public consumption in GDP", (sum(BY.G_value)/BY.GDP)*(G_qLasp)]; ["Investment in GDP",(sum(BY.I_value)/BY.GDP)*(I_qLasp)]; ["Exports in GDP", (sum(BY.X_value)/BY.GDP)*(X_qLasp)]; ["Imports in GDP", (sum(BY.M_value)/BY.GDP)*(M_qLasp)]],[ ["Nominal Macro results", "in Ratio"];["Nominal GDP", (d.GDP/BY.GDP)];["Households consumption in GDP",(sum(d.C_value)/BY.GDP) ]; ["Public consumption in GDP", (sum(d.G_value)/BY.GDP)]; ["Investment in GDP",(sum(d.I_value)/BY.GDP)]; ["Exports in GDP", (sum(d.X_value)/BY.GDP)]; ["Imports in GDP", (sum(d.M_value)/BY.GDP)]]];
 

// Test_quantity= [["variable", " ratio quantity"];["GDP", (d.GDP/GDP_pPaas)/BY.GDP];["Households consumption", (sum(d.C_value)/C_pPaas)/sum(BY.C_value)];["Households consumption - Non-energy goods", (sum(d.C_value(Indice_NonEnerSect,:))/C_NonEn_pPaas)/sum(BY.C_value(Indice_NonEnerSect,:))];["Households consumption - Energy goods", (sum(d.C_value(Indice_EnerSect,:))/C_En_pPaas)/sum(BY.C_value(Indice_EnerSect,:))];["Government consumption", (sum(d.G_value)/G_pPaas)/sum(BY.G_value)];["Government consumption - Non-energy goods", (sum(d.G_value(Indice_NonEnerSect))/G_NonEn_pPaas)/sum(BY.G_value(Indice_NonEnerSect))];["Government consumption - Energy goods", divide(sum(d.G_value(Indice_EnerSect,:))/G_En_pPaas,sum(BY.G_value(Indice_EnerSect,:)),%nan)];["Investment", (sum(d.I_value)/I_pPaas)/sum(BY.I_value)];["Investment - Non-energy goods", (sum(d.I_value(Indice_NonEnerSect))/C_NonEn_pPaas)/sum(BY.I_value(Indice_NonEnerSect))];["Investment - Energy goods", divide(sum(d.I_value(Indice_EnerSect,:))/I_En_pPaas,sum(BY.I_value(Indice_EnerSect,:)),%nan)]; ["Exports", (sum(d.X_value)/X_pPaas)/sum(BY.X_value)];["Exports - Non-energy goods", (sum(d.X_value(Indice_NonEnerSect))/X_NonEn_pPaas)/sum(BY.X_value(Indice_NonEnerSect))];["Exports - Energy goods", divide(sum(d.X_value(Indice_EnerSect,:))/X_En_pPaas,sum(BY.X_value(Indice_EnerSect,:)),%nan)]; ["Imports", (sum(d.M_value)/M_pPaas)/sum(BY.M_value)];["Imports - Non-energy goods", (sum(d.M_value(Indice_NonEnerSect))/M_NonEn_pPaas)/sum(BY.M_value(Indice_NonEnerSect))];["Imports - Energy goods", divide(sum(d.M_value(Indice_EnerSect))/M_En_pPaas,sum(BY.M_value(Indice_EnerSect)),%nan)]];
 
 // OutputTable.MacroT = [ ["Macro results", "in %"];["Carbon Tax rate", parameters.Carbon_Tax_rate / 10^3 + " euro/tCO2"];["Labour Tax cut", DispLabTabl];["Real GDP (Laspeyres)", (GDP_qLasp-1)*100];["Households consumption in GDP",(sum(BY.C_value)/BY.GDP) *(C_qLasp-1)*100]; ["Public consumption in GDP", (sum(BY.G_value)/BY.GDP)*(G_qLasp-1)*100]; ["Investment in GDP",(sum(BY.I_value)/BY.GDP)*(I_qLasp-1)*100]; ["Exports in GDP", (sum(BY.X_value)/BY.GDP)*(X_qLasp-1)*100]; ["Imports in GDP", (sum(BY.M_value)/BY.GDP)*(M_qLasp-1)*100]; ["Imports/Domestic production ratio",(M_Y_Ratio_qLasp-1)*100]; ["Trade balance", (((sum(d.X_value) - sum(d.M_value))/(sum(BY.X_value) - sum(BY.M_value)))-1)*100];["Imports of Non Energy goods in volume", (divide(sum(d.M(Indice_NonEnerSect,:)), sum(BY.M(Indice_NonEnerSect,:)),%nan ) -1)*100 ];["Exports of Non Energy goods in volume", (divide(sum(d.X(Indice_NonEnerSect,:)), sum(BY.X(Indice_NonEnerSect,:)),%nan ) -1)*100 ];["Total Employment", (evol.Labour_tot-1)*100];["Unemployment rate (% points)", d.u_tot - BY.u_tot];["Labour Intensity (Laspeyres)",(lambda_pLasp-1)*100];["Labour cost share", (evol.LabourShareMacro-1)*100];["Labour tax rate (% points)", - Labour_Tax_Cut];  ["Net-of-tax wages", (NetWage_variation-1)*100]; ["Production Price (Laspeyres)", (Y_pLasp-1)*100]; ["Production Price Non Energy goods (Laspeyres)", (Y_NonEn_pLasp-1)*100];  ["Energy Input Price (Laspeyres)", (IC_Ener_pLasp-1)*100];  ["Energy Intensity (Laspeyres)", (alpha_Ener_qLasp-1)*100]; ["Real Households consumption (Laspeyres)", (C_qLasp-1)*100]; ["	Energy in Households consumption", BY.Ener_C_ValueShare*(C_En_qLasp-1)*100]; ["	Non Energy goods in Households consumption", BY.NonEner_C_ValueShare*(C_NonEn_qLasp-1)*100];["Households Consumption Price (Laspeyres)", (C_pLasp-1)*100];["	Energy Consumption Price for HH(Laspeyres", (C_En_pLasp-1)*100];["	Non Energy Consumption Price for HH(Laspeyres)", (C_NonEn_pLasp-1)*100]; ["Public Deficits", evol.Ecotable(Indice_NetLending, Indice_Government)*100]; ["Total Emissions", evol.DOM_CO2*100];["",""];["Import Elasticity for Non Energy goods",unique(sigma_M(Indice_NonEnerSect))];[" Most sensitif export Elasticity ",max(sigma_X(Indice_NonEnerSect))];[" Global mean wage/Unemployment Elasticity",sigma_omegaU]];
 
  OutputTable.MacroT = [ ["Macro results", "in %"];["Carbon Tax rate", parameters.Carbon_Tax_rate / 10^3 + " euro/tCO2"];["Labour Tax cut", DispLabTabl];["Real GDP (Laspeyres)", (GDP_qLasp-1)*100];["Households consumption in GDP",(sum(BY.C_value)/BY.GDP) *(C_qLasp-1)*100]; ["Public consumption in GDP", (sum(BY.G_value)/BY.GDP)*(G_qLasp-1)*100]; ["Investment in GDP",(sum(BY.I_value)/BY.GDP)*(I_qLasp-1)*100]; ["Exports in GDP", (sum(BY.X_value)/BY.GDP)*(X_qLasp-1)*100]; ["Imports in GDP", (sum(BY.M_value)/BY.GDP)*(M_qLasp-1)*100]; ["Imports/Domestic production ratio",(M_Y_Ratio_qLasp-1)*100]; ["Imports of Non Energy goods in volume", (divide(sum(d.M(Indice_NonEnerSect,:)), sum(BY.M(Indice_NonEnerSect,:)),%nan ) -1)*100 ];["Exports of Non Energy goods in volume", (divide(sum(d.X(Indice_NonEnerSect,:)), sum(BY.X(Indice_NonEnerSect,:)),%nan ) -1)*100 ];["Total Employment", (evol.Labour_tot-1)*100];["Unemployment rate (% points)", d.u_tot - BY.u_tot];["Net-of-tax wages", (NetWage_variation-1)*100];["Labour Intensity (Laspeyres)",(lambda_pLasp-1)*100];["Labour tax rate (% points)", - Labour_Tax_Cut];  ["Energy Input Price (Laspeyres)", (IC_Ener_pLasp-1)*100]; ["Energy Intensity (Laspeyres)", (alpha_Ener_qLasp-1)*100]; ["Energy cost share for non-energetic sector", (evol.ENshareNONEner-1)*100 ]; ["Production Price (Laspeyres)", (Y_pLasp-1)*100]; ["Production Price Energy goods (Laspeyres)", (Y_En_pLasp-1)*100]; ["Production Price Non Energy goods (Laspeyres)", (Y_NonEn_pLasp-1)*100]; ["Real Households consumption (Laspeyres)", (C_qLasp-1)*100]; ["	Energy in Households consumption", BY.Ener_C_ValueShare*(C_En_qLasp-1)*100]; ["	Non Energy goods in Households consumption", BY.NonEner_C_ValueShare*(C_NonEn_qLasp-1)*100];["Public Deficits", evol.Ecotable(Indice_NetLending, Indice_Government)*100]; ["Total Emissions", evol.DOM_CO2*100];["",""];["Most sensitif import Elasticity for NonEner",max(sigma_M(Indice_NonEnerSect))];[" Most sensitif export Elasticity for NonEner ",max(sigma_X(Indice_NonEnerSect))];[" Global mean wage/Unemployment Elasticity",sigma_omegaU]];

 
OutputTable.CompSectTable = [["Variation (%)", Index_Sectors']; ["Production Price", ((divide(d.pY , BY.pY , %nan )-1)*100)']; ["Real Households consumption_"+Index_Households , ((divide(d.C , BY.C , %nan )-1)*100)']; ["Exports in volume", ((divide(d.X , BY.X , %nan )-1)*100)'];["Imports in volume", ((divide(d.M , BY.M, %nan )-1)*100)'];["Trade balance ",((divide((d.X_value' - d.M_value),(BY.X_value' - BY.M_value),%nan))-1)*100]; ["Energy Cost share variation", (evol.ENshare-1)*100 ]; [ " Energy/Labour cost variation" , (evol.ShareEN_Lab-1)*100]; ["Labour", (divide(d.Labour , BY.Labour, %nan )-1)*100]; ["Unitary Labour Cost variation", (evol.Unit_Labcost-1)*100]; ["Net nominal wages", (divide(d.w , BY.w, %nan )-1)*100]; ["Net real wages (Consumer Price Index)", (((d.w./CPI)./(BY.w./BY.CPI))-1)*100];["Purchasing power of wages_"+Index_Households, divide((ones(nb_Households,1).*.d.w)./d.pC' , (ones(nb_Households,1).*.BY.w)./BY.pC', %nan )]];

OutputTable.CompSectTable($+1,1)=  "Carbon Taxe rate";
OutputTable.CompSectTable($,2)=  [parameters.Carbon_Tax_rate / 10^3 + " euro/tCO2"];
OutputTable.CompSectTable($+1,1)=  "Revenue-reclycling option";
OutputTable.CompSectTable($,2)=  [DispLabTabl] ;
 

 //// Comparaison intersectorielle des echanges 
 // OutputTable.Trade_Sect =  [["Variable/Sectoral value", Index_Sectors']; ["Households consumption Nominal 0", round(sum(BY.C_value,"c")'/10^5)/10 ]; ["Households consumption Nominal 1", round(sum(d.C_value,"c")'/10^5)/10 ]; ["HPrice Index (Paasche)", (sum(d.C_value,"c")'./(BY.pC'.*d.C'))]; [ "Households consumption Real 1 (G€)",round((BY.pC'.*d.C')/10^5)./10];["Households consumption Nominal 0 %share", (round(sum(BY.C_value,"c")'/sum(BY.C_value')*10000)/100) ];["Households consumption Nominal 1 share(%)", (round(sum(d.C_value,"c")'/sum(d.C_value')*10000)/100) ];["Real Households consumption 1 share(%)", round(((BY.pC'.*d.C')./sum((BY.pC'.*d.C')))*10000)./100];
 // ["Government consumption Nominal 0", round(BY.G_value'/10^5)/10 ]; ["Government consumption Nominal 1", round(d.G_value'/10^5)/10 ];  ["G Price Index (Paasche)", (d.G_value'./(BY.pG'.*d.G'))]; [ "Government consumption Real 1 (G€)",round((BY.pG'.*d.G')/10^5)./10];["Government consumption Nominal 0 %share", (round(BY.G_value'/sum(BY.G_value')*10000)/100) ];["Government consumption Nominal 1 share(%)", (round(d.G_value'/sum(d.G_value')*10000)/100) ];["Real Government consumption 1 share(%)", round(((BY.pG'.*d.G')./sum((BY.pG'.*d.G')))*10000)./100];
// ["Investment Nominal 0", round(BY.I_value'/10^5)/10 ]; ["Investment Nominal 1", round(d.I_value'/10^5)/10 ];  ["I Price Index (Paasche)", (d.I_value'./(BY.pI'.*d.I'))]; [ "Investment Real 1 (G€)",round((BY.pI'.*d.I')/10^5)./10];["Investment Nominal 0 %share", (round(BY.I_value'/sum(BY.I_value')*10000)/100) ];["Investment Nominal 1 share(%)", (round(d.I_value'/sum(d.I_value')*10000)/100) ];["Real Investment 1 share(%)", round(((BY.pI'.*d.I')./sum((BY.pI'.*d.I')))*10000)./100];
// ["Exports Nominal 0", round(BY.X_value'/10^5)/10 ]; ["Exports Nominal 1", round(d.X_value'/10^5)/10 ];  ["X Price Index (Paasche)", (d.X_value'./(BY.pX'.*d.X'))]; [ "Exports Real 1 (G€)",round((BY.pX'.*d.X')/10^5)./10];["Exports Nominal 0 share(%)", (round(BY.X_value'/sum(BY.X_value')*10000)/100) ];["Exports Nominal 1 share(%)", (round(d.X_value'/sum(d.X_value')*10000)/100) ];["Real Exports 1 share(%)", round(((BY.pX'.*d.X')./sum((BY.pX'.*d.X')))*10000)./100];
// ["Imports Nominal 0", round(BY.M_value/10^5)/10 ]; ["Imports Nominal 1", round(d.M_value/10^5)/10 ];  ["M Price Index (Paasche)", (d.M_value./(BY.pM'.*d.M'))]; [ "Imports Real 1 (G€)",round((BY.pM'.*d.M')/10^5)./10]; ["Imports Nominal 0 share(%)", (round(BY.M_value/sum(BY.M_value)*10000)/100) ];["Imports Nominal 1 share(%)", (round(d.M_value/sum(d.M_value)*10000)/100) ]] ; 

 OutputTable.Trade_Sect =  [["Variable/Sectoral value", Index_Sectors']; ["Households consumption Nominal 0", round(sum(BY.C_value,"c")'/10^5)/10 ]; ["Households consumption Nominal 1", round(sum(d.C_value,"c")'/10^5)/10 ]; ["HPrice Index (Paasche)", divide(sum(d.C_value,"c")',sum(BY.pC.*d.C,"c")',%nan)]; [ "Households consumption Real 1 (G€)",round(sum(BY.pC.*d.C,"c")'/10^5)./10];
 ["Government consumption Nominal 0", round(BY.G_value'/10^5)/10 ]; ["Government consumption Nominal 1", round(d.G_value'/10^5)/10 ];  ["G Price Index (Paasche)", (d.G_value'./(BY.pG'.*d.G'))]; [ "Government consumption Real 1 (G€)",round((BY.pG'.*d.G')/10^5)./10];
["Investment Nominal 0", round(BY.I_value'/10^5)/10 ]; ["Investment Nominal 1", round(d.I_value'/10^5)/10 ];  ["I Price Index (Paasche)", divide(d.I_value',(BY.pI'.*d.I'),%nan)]; [ "Investment Real 1 (G€)",round((BY.pI'.*d.I')/10^5)./10];
["Exports Nominal 0", round(BY.X_value'/10^5)/10 ]; ["Exports Nominal 1", round(d.X_value'/10^5)/10 ];  ["X Price Index (Paasche)", (d.X_value'./(((BY.pX'.*d.X')>%eps).*(BY.pX'.*d.X') + ((BY.pX'.*d.X')<%eps)))]; [ "Exports Real 1 (G€)",round((BY.pX'.*d.X')/10^5)./10];
["Imports Nominal 0", round(BY.M_value/10^5)/10 ]; ["Imports Nominal 1", round(d.M_value/10^5)/10 ];  ["M Price Index (Paasche)", (d.M_value./(((BY.pM'.*d.M')>%eps).*(BY.pM'.*d.M') + ((BY.pM'.*d.M')<%eps)))]; [ "Imports Real 1 (G€)",round((BY.pM'.*d.M')/10^5)./10]] ; 


 
  OutputTable.Trade_Sect_Share  =  [["Variable/Sectoral value", Index_Sectors']; ["Households consumption Nominal 0 %share", (round(sum(BY.C_value,"c")'/sum(BY.C_value')*10000)/100) ];["Government consumption Nominal 0 %share", (round(BY.G_value'/sum(BY.G_value')*10000)/100) ];["Investment Nominal 0 %share", (round(BY.I_value'/sum(BY.I_value')*10000)/100) ];["Exports Nominal 0 share(%)", (round(BY.X_value'/sum(BY.X_value')*10000)/100) ]; ["Imports Nominal 0 share(%)", (round(BY.M_value/sum(BY.M_value)*10000)/100) ];] ; 
 
 
 OutputTable.EnerNonEnTable = [["Ratio", "Primary Energy", "Final Energy", "Non-energy goods"];["Production Price (Laspeyres)", (Y_PrimEn_pLasp-1)*100, (Y_FinEn_pLasp-1)*100, (Y_NonEn_pLasp-1)*100 ]; ["Real Households consumption (Laspeyres)", (C_PrimEn_qLasp-1)*100, (C_FinEn_qLasp-1)*100, (C_NonEn_qLasp-1)*100 ]; ["Exports in volume", (divide(sum(d.X(Indice_PrimEnerSect,:)), sum(BY.X(Indice_PrimEnerSect,:)),%nan )-1)*100, (divide(sum(d.X(Indice_FinEnerSect,:)), sum(BY.X(Indice_FinEnerSect,:)),%nan )-1)*100 , (divide(sum(d.X(Indice_NonEnerSect,:)), sum(BY.X(Indice_NonEnerSect,:)),%nan ) -1)*100 ];["Imports in volume", (divide(sum(d.M(Indice_PrimEnerSect,:)), sum(BY.M(Indice_PrimEnerSect,:)),%nan)-1)*100, (divide(sum(d.M(Indice_FinEnerSect,:)), sum(BY.M(Indice_FinEnerSect,:)),%nan )-1)*100 , (divide(sum(d.M(Indice_NonEnerSect,:)), sum(BY.M(Indice_NonEnerSect,:)),%nan )-1)*100 ]];

OutputTable.EnerNonEnTable($+1,1)=  "Carbon Taxe rate";
OutputTable.EnerNonEnTable($,2)=  [parameters.Carbon_Tax_rate / 10^3 + " euro/tCO2"];
OutputTable.EnerNonEnTable($+1,1)=  "Revenue-reclycling option";
OutputTable.EnerNonEnTable($,2)=  [DispLabTabl] ;

if (d.pX ./ BY.pX ) <> 1 
OutputTable.Elasticities = [ ["Elasticities" , Index_Sectors'];["Exports Price" , ((divide(d.X , BY.X, %nan) - 1) ./ ((d.pX ./ BY.pX) - 1))' ]; ["Exports - pX/pM ration" , ((divide(d.X , BY.X , %nan) - 1) ./ (((d.pX./d.pM) ./ (BY.pX./BY.pM) ) - 1))' ];["Import/Output ratio" ,((divide(d.M , d.Y , %nan) ./ divide(BY.M , BY.Y , %nan) - 1) ./ ((d.pM./d.pY) ./ (BY.pM./BY.pY) - 1))']];
OutputTable.Elasticities($+1,1)=  "Carbon Taxe rate";
OutputTable.Elasticities($,2)=  [parameters.Carbon_Tax_rate / 10^3 + " euro/tCO2"];
OutputTable.Elasticities($+1,1)=  "Revenue-reclycling option";
OutputTable.Elasticities($,2)=  [DispLabTabl] ;
end


disp "===== MAIN MACRO OUTPUT =============================="
disp(OutputTable.MacroT);



 csvWrite(OutputTable.MacroT,SAVEDIR+"TableMacroOutput.csv", ';');
 csvWrite(OutputTable.CompSectTable,SAVEDIR+"TableSectOutput.csv", ';');
 csvWrite(OutputTable.EnerNonEnTable,SAVEDIR+"TableENnonEnOutput.csv", ';');
 // csvWrite(OutputTable.Elasticities,SAVEDIR+"TableElasticities.csv", ';');
 // csvWrite(OutputTable.GDP_decom,SAVEDIR+"GDP_decom.csv", ';');
 csvWrite(OutputTable.GDP_decomBIS,SAVEDIR+"GDP_decomBIS.csv", ';');
  csvWrite(OutputTable.Trade_Sect,SAVEDIR+"Trade_Sect.csv", ';');
    csvWrite(OutputTable.Trade_Sect_Share,SAVEDIR+"Trade_Sect_Share.csv", ';');
  
  
 
  /////////////////////////  /////////////////////////  /////////////////////////
////// Specific calcul for distinct AGG_type 
  /////////////////////////  /////////////////////////  /////////////////////////
  
  if AGG_type == "AGG_IndEner"
	
	/////////////////////////	
	/// Aggregation of Metals  (Steel_Iron + NonFerrousMetals)
	  /////////////////////////
	  
	Met  = [ find( Index_Sectors== "Steel_Iron" ), find( Index_Sectors== "NonFerrousMetals" ) ];
	C_Met_qFish = QInd_Fish( BY.pC,BY.C, d.pC, d.C, Met, :);
	Y_Met_qFish = QInd_Fish( BY.pY,BY.Y, d.pY, d.Y, Met, :);
	pY_Met_pFish = PInd_Fish( BY.pY,BY.Y, d.pY, d.Y, Met, :);
	M_Met_qFish = QInd_Fish( BY.pM,BY.M, d.pM, d.M, Met, :);
	pM_Met_pFish = PInd_Fish( BY.pM,BY.M, d.pM, d.M, Met, :);
	X_Met_qFish = QInd_Fish( BY.pX,BY.X, d.pX, d.X, Met, :);
	pX_Met_pFish = PInd_Fish( BY.pX,BY.X, d.pX, d.X, Met, :);
	
		// Variations of macroeconomic identities in real terms at the aggregated level: Production = Private Consumption + Public Consumption + Investment + Exports - Imports

	// Initial value shares for each components of GDP
	BY.IC_Met_Prod_ValueShare	=  sum(BY.IC_value(Met,:))./sum(BY.Output_value(Met)) ;
	BY.C_Met_Prod_ValueShare	=  sum(BY.C_value(Met))   ./sum(BY.Output_value(Met)) ;
	BY.G_Met_Prod_ValueShare	=  sum(BY.G_value(Met))   ./sum(BY.Output_value(Met)) ;
	BY.I_Met_Prod_ValueShare	=  sum(BY.I_value(Met))   ./sum(BY.Output_value(Met)) ;
	BY.X_Met_Prod_ValueShare	=  sum(BY.X_value(Met))   ./sum(BY.Output_value(Met)) ;
	BY.M_Met_Prod_ValueShare	= -sum(BY.M_value(Met))   ./sum(BY.Output_value(Met)) ;
	
	// Laspeyres Quantity indices
	Y_qLasp  = QInd_Lasp( BY.pC, BY.C, d.pC, d.C, Met, :);	
	IC_Met_qLasp = QInd_Lasp( BY.pC, BY.C, d.pC, d.C, Met, :);
	G_Met_qLasp  = QInd_Lasp( BY.pG, BY.G, d.pG, d.G, Met, :);
	C_Met_qLasp  = QInd_Lasp( BY.pC, BY.C, d.pC, d.C, Met, :);
	I_Met_qLasp  = QInd_Lasp( BY.pI, BY.I, d.pI, d.I, Met, :);
	X_Met_qLasp  = QInd_Lasp( BY.pX, BY.X, d.pX, d.X, Met, :);
	M_Met_qLasp  = QInd_Lasp( BY.pM, BY.M, d.pM, d.M, Met, :);
	
	// Decomposition of variations for the second level macroeconomic identity
	IC_Met_Prod_qLasp = BY.IC_Met_Prod_ValueShare  .* IC_Met_qLasp ;
	C_Met_Prod_qLasp   = BY.C_Met_Prod_ValueShare  .*  C_Met_qLasp ;
	G_Met_Prod_qLasp   = BY.G_Met_Prod_ValueShare  .*  G_Met_qLasp ;
	I_Met_Prod_qLasp   = BY.I_Met_Prod_ValueShare  .*  I_Met_qLasp ;
	X_Met_Prod_qLasp   = BY.X_Met_Prod_ValueShare  .*  X_Met_qLasp ;
	M_Met_Prod_qLasp   = BY.M_Met_Prod_ValueShare  .*  M_Met_qLasp ;
	
	 /////////////////////////
	/// Aggregation of Minerals  (Cement + Other Minerals)
	 /////////////////////////
	
	Miner  = [ find( Index_Sectors== "Cement" ), find( Index_Sectors== "OthMin" ) ];
	C_Miner_qFish = QInd_Fish( BY.pC,BY.C, d.pC, d.C, Miner, :);
	Y_Miner_qFish = QInd_Fish( BY.pY,BY.Y, d.pY, d.Y, Miner, :);
	pY_Miner_pFish = PInd_Fish( BY.pY,BY.Y, d.pY, d.Y, Miner, :);
    M_Miner_qFish = QInd_Fish( BY.pM,BY.M, d.pM, d.M, Miner, :);
	pM_Miner_pFish = PInd_Fish( BY.pM,BY.M, d.pM, d.M, Miner, :);
	X_Miner_qFish = QInd_Fish( BY.pX,BY.X, d.pX, d.X, Miner, :);
	pX_Miner_pFish = PInd_Fish( BY.pX,BY.X, d.pX, d.X, Miner, :);
	
		// Variations of macroeconomic identities in real terms at the aggregated level: Production = Private Consumption + Public Consumption + Investment + Exports - Imports

	// Initial value shares for each components of GDP
	BY.IC_Miner_Prod_ValueShare	=  sum(BY.IC_value(Miner,:))./sum(BY.Output_value(Miner)) ;
	 BY.C_Miner_Prod_ValueShare	 =  sum(BY.C_value(Miner))  ./sum(BY.Output_value(Miner)) ;
	 BY.G_Miner_Prod_ValueShare	 =  sum(BY.G_value(Miner))  ./sum(BY.Output_value(Miner)) ;
	 BY.I_Miner_Prod_ValueShare	 =  sum(BY.I_value(Miner))  ./sum(BY.Output_value(Miner)) ;
	 BY.X_Miner_Prod_ValueShare	 =  sum(BY.X_value(Miner))  ./sum(BY.Output_value(Miner)) ;
	 BY.M_Miner_Prod_ValueShare	 = -sum(BY.M_value(Miner))  ./sum(BY.Output_value(Miner)) ;
	
	// Laspeyres Quantity indices
	Y_Miner_qLasp  = QInd_Lasp( BY.pC, BY.C, d.pC, d.C, Miner, :);
	
	IC_Miner_qLasp = QInd_Lasp( BY.pC, BY.C, d.pC, d.C, Miner, :);
	 C_Miner_qLasp  = QInd_Lasp( BY.pC, BY.C, d.pC, d.C, Miner, :);
	 G_Miner_qLasp  = QInd_Lasp( BY.pG, BY.G, d.pG, d.G, Miner, :);
	 I_Miner_qLasp  = QInd_Lasp( BY.pI, BY.I, d.pI, d.I, Miner, :);
	 X_Miner_qLasp  = QInd_Lasp( BY.pX, BY.X, d.pX, d.X, Miner, :);
	 M_Miner_qLasp  = QInd_Lasp( BY.pM, BY.M, d.pM, d.M, Miner, :);
	
	// Decomposition of variations for the second level macroeconomic identity
	IC_Met_Prod_qLasp = BY.IC_Miner_Prod_ValueShare  .* IC_Miner_qLasp ;
	C_Met_Prod_qLasp   = BY.C_Miner_Prod_ValueShare  .* C_Miner_qLasp ;
	G_Met_Prod_qLasp   = BY.G_Miner_Prod_ValueShare  .* G_Miner_qLasp ;
	I_Met_Prod_qLasp   = BY.I_Miner_Prod_ValueShare  .* I_Miner_qLasp ;
	X_Met_Prod_qLasp   = BY.X_Miner_Prod_ValueShare  .* X_Miner_qLasp ;
	M_Met_Prod_qLasp   = BY.M_Miner_Prod_ValueShare  .* M_Miner_qLasp ;
	
	/////////////////////////
	// Calcul des cost shares
	/////////////////////////
	
	///// Energy cost share
	BY.ENshareMET = Cost_Share( sum(BY.IC_value(Indice_EnerSect,Met))  , sum(BY.Y_value(Met))) * 100;
	BY.ENshareMINER = Cost_Share( sum(BY.IC_value(Indice_EnerSect,Miner))  , sum(BY.Y_value(Miner))) * 100;
	d.ENshareMET =  Cost_Share( sum(d.IC_value(Indice_EnerSect,Met))  , sum(d.Y_value(Met))) * 100;
	d.ENshareMINER = Cost_Share( sum(d.IC_value(Indice_EnerSect,Miner))  , sum(d.Y_value(Miner))) * 100;
	evol.ENshareMET = (divide(d.ENshareMET , BY.ENshareMET , %nan ) -1)*100 ;
	evol.ENshareMINER =(divide(d.ENshareMINER , BY.ENshareMINER , %nan ) -1)*100 ;
	
	///// Labour cost share
	// BY.Unit_LabcostMET = BY.pL_MET.*BY.lambdaMET);// pL agrégé et lambda agrégé à calculer
	// d.Unit_LabcostMET = sum(d.pL_MET.*d.lambdaMET); // pL agrégé et lambda agrégé à calculer
	// evol.Unit_LabcostMET = (divide(d.Unit_LabcostMET,BY.Unit_LabcostMET,%nan) - 1) * 100 ;
	// BY.Unit_LabcostMINER = BY.pL_MINER.*BY.lambdaMINER  //pL agrégé et lambda agrégé à calculer
	// d.Unit_LabcostMINER = d.pL_MINER.*d.lambdalambdaMINER; // pL agrégé et lambda agrégé à calculer
	// evol.Unit_LabcostMINER = (divide(d.Unit_LabcostMINER,BY.Unit_LabcostMINER,%nan) - 1) * 100 ;
	
	///// Ratio Ener/Labour cost
	// BY.ShareEN_LabMET = ( sum(BY.pIC_MET(Indice_EnerSect).*BY.alphaMET(Indice_EnerSect),"r") ) ./ BY.Unit_LabcostMET ; // pIC agrégé et alpha agrégé à calculer
	// d.ShareEN_LabMET = ( sum(d.pIC_MET(Indice_EnerSect).*d.alphaMET(Indice_EnerSect),"r") ) ./ d.Unit_LabcostMET  ;
	// evol.ShareEN_LabMET = (divide(d.ShareEN_LabMET, BY.ShareEN_LabMET, %nan)-1) * 100 ; 
	// BY.ShareEN_LabMINER = ( sum(BY.pIC_MINER(Indice_EnerSect).*BY.alphaMINER(Indice_EnerSect),"r") ) ./ BY.Unit_LabcostMINER ; //// pIC agrégé et alpha agrégé à calculer
	// d.ShareEN_LabMINER= ( sum(d.pIC_MINER(Indice_EnerSect).*d.alphaMINER(Indice_EnerSect),"r") ) ./ d.Unit_LabcostMINER  ; //// pIC agrégé et alpha agrégé à calculer
	// evol.ShareEN_LabMINER = (divide(d.ShareEN_LabMINER, BY.ShareEN_LabMINER, %nan)-1) * 100 ;

	/////////////////////////
	// Calcul Trade intensity
	/////////////////////////
	
	BY.TradeIntMETMIN = TradeIntens([sum(BY.M_value(Met)),sum(BY.M_value(Miner))], [sum(BY.X_value(Met)),sum(BY.X_value(Miner))],[sum(BY.Y_value(Met)),sum(BY.Y_value(Miner))]);
	d.TradeIntMETMIN  = TradeIntens([sum(d.M_value(Met)),sum(d.M_value(Miner))], [sum(d.X_value(Met)),sum(d.X_value(Miner))],[sum(d.Y_value(Met)),sum(d.Y_value(Miner))]);
	evol.TradeIntMETMIN =  (divide(d.TradeIntMETMIN , BY.TradeIntMETMIN , %nan ) -1 )*100;

	BY.M_penetRatMETMIN = M_penetRat([sum(BY.M_value(Met)),sum(BY.M_value(Miner))],[sum(BY.Y_value(Met)),sum(BY.Y_value(Miner))], [sum(BY.X_value(Met)),sum(BY.X_value(Miner))]);
	d.M_penetRatMETMIN = M_penetRat([sum(d.M_value(Met)),sum(d.M_value(Miner))],[sum(d.Y_value(Met)),sum(d.Y_value(Miner))], [sum(d.X_value(Met)),sum(d.X_value(Miner))]);
	evol.M_penetRatMETMIN = ( divide(d.M_penetRatMETMIN , BY.M_penetRatMETMIN , %nan ) -1 )*100; 

	CompAGG.BY = [["CompT_BY","Ener Cost Share", "Trade Intens", "Import Penet Rate"];[["Metals";"Non Metallic Minerals"], [BY.ENshareMET;BY.ENshareMINER],BY.TradeIntMETMIN',BY.M_penetRatMETMIN' ]];
	CompAGG.run = [["CompT_run", "Ener Cost Share", "Trade Intens", "Import Penet Rate"];[["Metals";"Non Metallic Minerals"], [d.ENshareMET;d.ENshareMINER] ,d.TradeIntMETMIN',d.M_penetRatMETMIN']];
	CompAGG.evol = [["CompT%", "pY - p Fisher", "Y - qFisher","pM - p Fisher", "M - qFisher","pX - p Fisher","X - qFisher", "C- qFisher", "Ener Cost Share", "Trade Intens", "Import Penet Rate"];[["Metals";"Non Metallic Minerals"],[ (pY_Met_pFish-1)*100;(pY_Miner_pFish-1)*100],  [ (Y_Met_qFish-1)*100;(Y_Miner_qFish-1)*100], [ (pM_Met_pFish-1)*100;(pM_Miner_pFish-1)*100],  [(M_Met_qFish-1)*100;(M_Miner_qFish-1)*100], [ (pX_Met_pFish-1)*100;(pX_Miner_pFish-1)*100],  [(X_Met_qFish-1)*100;(X_Miner_qFish-1)*100],[(C_Met_qFish-1)*100;(C_Miner_qFish-1)*100], [evol.ENshareMET;evol.ENshareMINER],evol.TradeIntMETMIN',evol.M_penetRatMETMIN']];
			
	csvWrite(CompAGG.BY,SAVEDIR+"CompAGG-BY.csv", ';');
	csvWrite(CompAGG.run,SAVEDIR+"CompAGG-run.csv", ';');
	csvWrite(CompAGG.evol,SAVEDIR+"CompAGG-evol.csv", ';');
	
	
   end
 
 







