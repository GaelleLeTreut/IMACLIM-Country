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


// For if there is desaggregation of investment
Out.pI = Out.pI * ones(1,nb_size_I);
ref.pI = ref.pI * ones(1,nb_size_I);
// Put back to normal before the end of the file, with :
// Out.pI = Out.pI(:,1);
// ref.pI = ref.pI(:,1);

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

// Price indices for all energy sectors
for ind = 1:nb_Sectors
Y_pLasp_temp(ind) = PInd_Lasp( ref.pY, ref.Y, Out.pY, Out.Y, ind, :);
Y_pPaas_temp(ind) = PInd_Paas( ref.pY, ref.Y, Out.pY, Out.Y, ind, :);
Y_pFish_temp(ind) = PInd_Fish( ref.pY, ref.Y, Out.pY, Out.Y, ind, :);
end

execstr ( "Y_"+Index_Sectors+"_pLasp = "+Y_pLasp_temp);
execstr ( "Y_"+Index_Sectors+"_pPaas = "+Y_pPaas_temp);
execstr ( "Y_"+Index_Sectors+"_pFish = "+Y_pFish_temp);
clear Y_pFish_temp Y_pLasp_temp Y_pPaas_temp

// Price indices (Laspeyres, Paasche and Fisher) - Production
Y_pLasp = PInd_Lasp( ref.pY, ref.Y, Out.pY, Out.Y, :, :);
Y_pPaas = PInd_Paas( ref.pY, ref.Y, Out.pY, Out.Y, :, :);
Y_pFish = PInd_Fish( ref.pY, ref.Y, Out.pY, Out.Y, :, :);

// Price indices (Laspeyres, Paasche and Fisher) - Energy - Production
Y_En_pLasp = PInd_Lasp( ref.pY, ref.Y, Out.pY, Out.Y, Indice_EnerSect, :);
Y_En_pPaas = PInd_Paas( ref.pY, ref.Y, Out.pY, Out.Y, Indice_EnerSect, :);
Y_En_pFish = PInd_Fish( ref.pY, ref.Y, Out.pY, Out.Y, Indice_EnerSect, :);

// Price indices (Laspeyres, Paasche and Fisher) - Primary Energy - Production
Y_PrimEn_pLasp = PInd_Lasp( ref.pY, ref.Y, Out.pY, Out.Y, Indice_PrimEnerSect, :);
Y_PrimEn_pPaas = PInd_Paas( ref.pY, ref.Y, Out.pY, Out.Y, Indice_PrimEnerSect, :);
Y_PrimEn_pFish = PInd_Fish( ref.pY, ref.Y, Out.pY, Out.Y, Indice_PrimEnerSect, :);

// Price indices (Laspeyres, Paasche and Fisher) - Final Energy - Production
Y_FinEn_pLasp = PInd_Lasp( ref.pY, ref.Y, Out.pY, Out.Y, Indice_FinEnerSect, :);
Y_FinEn_pPaas = PInd_Paas( ref.pY, ref.Y, Out.pY, Out.Y, Indice_FinEnerSect, :);
Y_FinEn_pFish = PInd_Fish( ref.pY, ref.Y, Out.pY, Out.Y, Indice_FinEnerSect, :);

// Price indices (Laspeyres, Paasche and Fisher) - Non Energy Products - Production
Y_NonEn_pLasp = PInd_Lasp( ref.pY, ref.Y, Out.pY, Out.Y, Indice_NonEnerSect, :);
Y_NonEn_pPaas = PInd_Paas( ref.pY, ref.Y, Out.pY, Out.Y, Indice_NonEnerSect, :);
Y_NonEn_pFish = PInd_Fish( ref.pY, ref.Y, Out.pY, Out.Y, Indice_NonEnerSect, :);

// Quantity indices (Laspeyres, Paasche and Fisher) - Production
Y_qLasp = QInd_Lasp( ref.pY, ref.Y, Out.pY, Out.Y, :, :);
Y_qPaas = QInd_Paas( ref.pY, ref.Y, Out.pY, Out.Y, :, :);
Y_qFish = QInd_Fish( ref.pY, ref.Y, Out.pY, Out.Y, :, :);

////////////////////////
////////////Intermediate consumption
////////////////////////

// Price indices (Laspeyres, Paasche and Fisher) - Intermediate consumption
IC_pLasp = PInd_Lasp( ref.pIC, ref.IC, Out.pIC, Out.IC, :, :);
IC_pPaas = PInd_Paas( ref.pIC, ref.IC, Out.pIC, Out.IC, :, :);
IC_pFish = PInd_Fish( ref.pIC, ref.IC, Out.pIC, Out.IC, :, :);

// Quantity indices (Laspeyres, Paasche and Fisher) - Intermediate consumption
IC_qLasp = QInd_Lasp( ref.pIC, ref.IC, Out.pIC, Out.IC, :, :);
IC_qPaas = QInd_Paas( ref.pIC, ref.IC, Out.pIC, Out.IC, :, :);
IC_qFish = QInd_Fish( ref.pIC, ref.IC, Out.pIC, Out.IC, :, :);

// Quantity indices (Laspeyres, Paasche and Fisher) - Intermediate consumption (inputs) - Primary Energy
IC_input_PrimEn_qLasp = QInd_Lasp( ref.pIC, ref.IC, Out.pIC, Out.IC, :, Indice_PrimEnerSect);
IC_input_PrimEn_qPaas = QInd_Paas( ref.pIC, ref.IC, Out.pIC, Out.IC, :, Indice_PrimEnerSect);
IC_input_PrimEn_qFish = QInd_Fish( ref.pIC, ref.IC, Out.pIC, Out.IC, :, Indice_PrimEnerSect);

// Quantity indices (Laspeyres, Paasche and Fisher) - Intermediate consumption (inputs) - Final Energy
IC_input_FinEn_qLasp = QInd_Lasp( ref.pIC, ref.IC, Out.pIC, Out.IC, :, Indice_FinEnerSect);
IC_input_FinEn_qPaas = QInd_Paas( ref.pIC, ref.IC, Out.pIC, Out.IC, :, Indice_FinEnerSect);
IC_input_FinEn_qFish = QInd_Fish( ref.pIC, ref.IC, Out.pIC, Out.IC, :, Indice_FinEnerSect);

// Quantity indices (Laspeyres, Paasche and Fisher) - Intermediate consumption (inputs) - Non Energy Products
IC_input_NonEn_qLasp = QInd_Lasp( ref.pIC, ref.IC, Out.pIC, Out.IC, :, Indice_NonEnerSect);
IC_input_NonEn_qPaas = QInd_Paas( ref.pIC, ref.IC, Out.pIC, Out.IC, :, Indice_NonEnerSect);
IC_input_NonEn_qFish = QInd_Fish( ref.pIC, ref.IC, Out.pIC, Out.IC, :, Indice_NonEnerSect);

// Quantity indices (Laspeyres, Paasche and Fisher) - Intermediate consumption (uses) - Primary Energy
IC_uses_PrimEn_qLasp = QInd_Lasp( ref.pIC, ref.IC, Out.pIC, Out.IC, Indice_PrimEnerSect, : );
IC_uses_PrimEn_qPaas = QInd_Paas( ref.pIC, ref.IC, Out.pIC, Out.IC, Indice_PrimEnerSect, : );
IC_uses_PrimEn_qFish = QInd_Fish( ref.pIC, ref.IC, Out.pIC, Out.IC, Indice_PrimEnerSect, : );

// Quantity indices (Laspeyres, Paasche and Fisher) - Intermediate consumption (uses) - Final Energy
IC_uses_FinEn_qLasp = QInd_Lasp( ref.pIC, ref.IC, Out.pIC, Out.IC, Indice_FinEnerSect, : );
IC_uses_FinEn_qPaas = QInd_Paas( ref.pIC, ref.IC, Out.pIC, Out.IC, Indice_FinEnerSect, : );
IC_uses_FinEn_qFish = QInd_Fish( ref.pIC, ref.IC, Out.pIC, Out.IC, Indice_FinEnerSect, : );

// Quantity indices (Laspeyres, Paasche and Fisher) - Intermediate consumption (uses) - Non Energy Products
IC_uses_NonEn_qLasp = QInd_Lasp( ref.pIC, ref.IC, Out.pIC, Out.IC, Indice_NonEnerSect, : );
IC_uses_NonEn_qPaas = QInd_Paas( ref.pIC, ref.IC, Out.pIC, Out.IC, Indice_NonEnerSect, : );
IC_uses_NonEn_qFish = QInd_Fish( ref.pIC, ref.IC, Out.pIC, Out.IC, Indice_NonEnerSect, : );

////////////////////////	
////////////GDP
////////////////////////

// Price indices (Laspeyres, Paasche and Fisher) - GDP
GDP_pLasp = (sum(Out.pC.*ref.C)+sum(Out.pG.*ref.G)+sum(Out.pI.*ref.I)+sum(Out.pX.*ref.X)-sum(Out.pM.*ref.M))/ref.GDP ;
GDP_pPaas = Out.GDP / (sum(ref.pC.*Out.C)+sum(ref.pG.*Out.G)+sum(ref.pI.*Out.I)+sum(ref.pX.*Out.X)-sum(ref.pM.*Out.M)); 
GDP_pFish = sqrt(GDP_pLasp*GDP_pPaas);

// Approximation Real_GDP (Nominal GDP / GDP Fisher Price Index )
GDP_qFish_app = Out.GDP / GDP_pFish;

// Quantity indices (Laspeyres, Paasche and Fisher) - GDP
GDP_qLasp = (sum(ref.pC.*Out.C)+sum(ref.pG.*Out.G)+sum(ref.pI.*Out.I)+sum(ref.pX.*Out.X)-sum(ref.pM.*Out.M))/ref.GDP ;
GDP_qPaas = Out.GDP / (sum(Out.pC.*ref.C)+sum(Out.pG.*ref.G)+sum(Out.pI.*ref.I)+sum(Out.pX.*ref.X)-sum(Out.pM.*ref.M)); 
GDP_qFish = sqrt(GDP_qLasp*GDP_qPaas);

////////////////////////
////////////Output
////////////////////////

// ref and final value for output
ref.Output_value = ref.Y_value + ref.Trade_margins + ref.Transp_margins + sum(ref.SpeMarg_IC, "r") + sum(ref.SpeMarg_C, "r") + ref.SpeMarg_X + ref.SpeMarg_I + sum(ref.Taxes, "r") + sum(ref.Carbon_Tax_IC, "c")' + sum(ref.Carbon_Tax_C, "c")' + sum(ref.Carbon_Tax_M, "c")';

Out.Output_value = Out.Y_value + Out.Trade_margins + Out.Transp_margins + sum(Out.SpeMarg_IC, "r") + sum(Out.SpeMarg_C, "r") + Out.SpeMarg_X + Out.SpeMarg_I + sum(Out.Taxes, "r") + sum(Out.Carbon_Tax_IC, "c")' + sum(Out.Carbon_Tax_C, "c")'+ sum(Out.Carbon_Tax_M, "c")';	

//	ref and final value for Total Margins
ref.TotMargins = ref.Trade_margins + ref.Transp_margins + sum(ref.SpeMarg_IC, "r") + sum(ref.SpeMarg_C, "r") + ref.SpeMarg_X + ref.SpeMarg_I + ref.Profit_margin;
Out.TotMargins = Out.Trade_margins + Out.Transp_margins + sum(Out.SpeMarg_IC, "r") + sum(Out.SpeMarg_C, "r") + Out.SpeMarg_X + Out.SpeMarg_I + Out.Profit_margin;

// Price indices (Laspeyres, Paasche and Fisher) - Total Output
Output_pLasp = (sum(Out.pIC.*ref.IC)+sum(Out.pC.*ref.C)+sum(Out.pG.*ref.G)+sum(Out.pI.*ref.I)+sum(Out.pX.*ref.X)-sum(Out.pM.*ref.M))/sum(ref.Output_value) ;
Output_pPaas = sum(Out.Output_value) / (sum(ref.pIC.*Out.IC)+sum(ref.pC.*Out.C)+sum(ref.pG.*Out.G)+sum(ref.pI.*Out.I)+sum(ref.pX.*Out.X)-sum(ref.pM.*Out.M)); 
Output_pFish = sqrt(Output_pLasp*Output_pPaas);

// Quantity indices (Laspeyres, Paasche and Fisher) - Total Output
Output_qLasp = (sum(ref.pIC.*Out.IC)+sum(ref.pC.*Out.C)+sum(ref.pG.*Out.G)+sum(ref.pI.*Out.I)+sum(ref.pX.*Out.X)-sum(ref.pM.*Out.M))/sum(ref.Output_value) ;
Output_qPaas = sum(Out.Output_value) / (sum(Out.pIC.*ref.IC)+sum(Out.pC.*ref.C)+sum(Out.pG.*ref.G)+sum(Out.pI.*ref.I)+sum(Out.pX.*ref.X)-sum(Out.pM.*ref.M)); 
Output_qFish = sqrt(Output_qLasp*Output_qPaas);

// Price indices (Laspeyres, Paasche and Fisher) - Primary Energy
Output_PrimEn_pLasp = (sum(Out.pIC(Indice_PrimEnerSect,:).*ref.IC(Indice_PrimEnerSect,:))+sum(Out.pC(Indice_PrimEnerSect,:).*ref.C(Indice_PrimEnerSect,:))+sum(Out.pG(Indice_PrimEnerSect).*ref.G(Indice_PrimEnerSect))+sum(Out.pI(Indice_PrimEnerSect).*ref.I(Indice_PrimEnerSect))+sum(Out.pX(Indice_PrimEnerSect).*ref.X(Indice_PrimEnerSect))-sum(Out.pM(Indice_PrimEnerSect).*ref.M(Indice_PrimEnerSect)))/sum(ref.Output_value(Indice_PrimEnerSect)) ;
Output_PrimEn_pPaas = sum(Out.Output_value(Indice_PrimEnerSect)) / (sum(ref.pIC(Indice_PrimEnerSect,:).*Out.IC(Indice_PrimEnerSect,:))+sum(ref.pC(Indice_PrimEnerSect,:).*Out.C(Indice_PrimEnerSect,:))+sum(ref.pG(Indice_PrimEnerSect).*Out.G(Indice_PrimEnerSect))+sum(ref.pI(Indice_PrimEnerSect).*Out.I(Indice_PrimEnerSect))+sum(ref.pX(Indice_PrimEnerSect).*Out.X(Indice_PrimEnerSect))-sum(ref.pM(Indice_PrimEnerSect).*Out.M(Indice_PrimEnerSect))); 
Output_PrimEn_pFish = sqrt(Output_PrimEn_pLasp*Output_PrimEn_pPaas);

// Quantity indices (Laspeyres, Paasche and Fisher) - Primary Energy
Output_PrimEn_qLasp = (sum(ref.pIC(Indice_PrimEnerSect,:).*Out.IC(Indice_PrimEnerSect,:))+sum(ref.pC(Indice_PrimEnerSect,:).*Out.C(Indice_PrimEnerSect,:))+sum(ref.pG(Indice_PrimEnerSect).*Out.G(Indice_PrimEnerSect))+sum(ref.pI(Indice_PrimEnerSect).*Out.I(Indice_PrimEnerSect))+sum(ref.pX(Indice_PrimEnerSect).*Out.X(Indice_PrimEnerSect))-sum(ref.pM(Indice_PrimEnerSect).*Out.M(Indice_PrimEnerSect)))/sum(ref.Output_value(Indice_PrimEnerSect)) ;
Output_PrimEn_qPaas = sum(Out.Output_value(Indice_PrimEnerSect)) / (sum(Out.pIC(Indice_PrimEnerSect,:).*ref.IC(Indice_PrimEnerSect,:))+sum(Out.pC(Indice_PrimEnerSect,:).*ref.C(Indice_PrimEnerSect,:))+sum(Out.pG(Indice_PrimEnerSect).*ref.G(Indice_PrimEnerSect))+sum(Out.pI(Indice_PrimEnerSect).*ref.I(Indice_PrimEnerSect))+sum(Out.pX(Indice_PrimEnerSect).*ref.X(Indice_PrimEnerSect))-sum(Out.pM(Indice_PrimEnerSect).*ref.M(Indice_PrimEnerSect))); 
Output_qFish = sqrt(Output_PrimEn_qLasp*Output_PrimEn_qPaas);

// Price indices (Laspeyres, Paasche and Fisher) - Final Energy
Output_FinEn_pLasp = (sum(Out.pIC(Indice_FinEnerSect,:).*ref.IC(Indice_FinEnerSect,:))+sum(Out.pC(Indice_FinEnerSect,:).*ref.C(Indice_FinEnerSect,:))+sum(Out.pG(Indice_FinEnerSect).*ref.G(Indice_FinEnerSect))+sum(Out.pI(Indice_FinEnerSect).*ref.I(Indice_FinEnerSect))+sum(Out.pX(Indice_FinEnerSect).*ref.X(Indice_FinEnerSect))-sum(Out.pM(Indice_FinEnerSect).*ref.M(Indice_FinEnerSect)))/sum(ref.Output_value(Indice_FinEnerSect)) ;
Output_FinEn_pPaas = sum(Out.Output_value(Indice_FinEnerSect)) / (sum(ref.pIC(Indice_FinEnerSect,:).*Out.IC(Indice_FinEnerSect,:))+sum(ref.pC(Indice_FinEnerSect,:).*Out.C(Indice_FinEnerSect,:))+sum(ref.pG(Indice_FinEnerSect).*Out.G(Indice_FinEnerSect))+sum(ref.pI(Indice_FinEnerSect).*Out.I(Indice_FinEnerSect))+sum(ref.pX(Indice_FinEnerSect).*Out.X(Indice_FinEnerSect))-sum(ref.pM(Indice_FinEnerSect).*Out.M(Indice_FinEnerSect))); 
Output_PrimEn_pFish = sqrt(Output_FinEn_pLasp*Output_FinEn_pPaas);

// Quantity indices (Laspeyres, Paasche and Fisher) - Final Energy
Output_FinEn_qLasp = (sum(ref.pIC(Indice_FinEnerSect,:).*Out.IC(Indice_FinEnerSect,:))+sum(ref.pC(Indice_FinEnerSect,:).*Out.C(Indice_FinEnerSect,:))+sum(ref.pG(Indice_FinEnerSect).*Out.G(Indice_FinEnerSect))+sum(ref.pI(Indice_FinEnerSect).*Out.I(Indice_FinEnerSect))+sum(ref.pX(Indice_FinEnerSect).*Out.X(Indice_FinEnerSect))-sum(ref.pM(Indice_FinEnerSect).*Out.M(Indice_FinEnerSect)))/sum(ref.Output_value(Indice_FinEnerSect)) ;
Output_FinEn_qPaas = sum(Out.Output_value(Indice_FinEnerSect)) / (sum(Out.pIC(Indice_FinEnerSect,:).*ref.IC(Indice_FinEnerSect,:))+sum(Out.pC(Indice_FinEnerSect,:).*ref.C(Indice_FinEnerSect,:))+sum(Out.pG(Indice_FinEnerSect).*ref.G(Indice_FinEnerSect))+sum(Out.pI(Indice_FinEnerSect).*ref.I(Indice_FinEnerSect))+sum(Out.pX(Indice_FinEnerSect).*ref.X(Indice_FinEnerSect))-sum(Out.pM(Indice_FinEnerSect).*ref.M(Indice_FinEnerSect))); 
Output_qFish = sqrt(Output_FinEn_qLasp*Output_FinEn_qPaas);

// Price indices (Laspeyres, Paasche and Fisher) - Non Energy Products
Output_NonEn_pLasp = (sum(Out.pIC(Indice_NonEnerSect,:).*ref.IC(Indice_NonEnerSect,:))+sum(Out.pC(Indice_NonEnerSect,:).*ref.C(Indice_NonEnerSect,:))+sum(Out.pG(Indice_NonEnerSect).*ref.G(Indice_NonEnerSect))+sum(Out.pI(Indice_NonEnerSect).*ref.I(Indice_NonEnerSect))+sum(Out.pX(Indice_NonEnerSect).*ref.X(Indice_NonEnerSect))-sum(Out.pM(Indice_NonEnerSect).*ref.M(Indice_NonEnerSect)))/sum(ref.Output_value(Indice_NonEnerSect)) ;
Output_NonEn_pPaas = sum(Out.Output_value(Indice_NonEnerSect)) / (sum(ref.pIC(Indice_NonEnerSect,:).*Out.IC(Indice_NonEnerSect,:))+sum(ref.pC(Indice_NonEnerSect,:).*Out.C(Indice_NonEnerSect,:))+sum(ref.pG(Indice_NonEnerSect).*Out.G(Indice_NonEnerSect))+sum(ref.pI(Indice_NonEnerSect).*Out.I(Indice_NonEnerSect))+sum(ref.pX(Indice_NonEnerSect).*Out.X(Indice_NonEnerSect))-sum(ref.pM(Indice_NonEnerSect).*Out.M(Indice_NonEnerSect))); 
Output_PrimEn_pFish = sqrt(Output_NonEn_pLasp*Output_NonEn_pPaas);

// Quantity indices (Laspeyres, Paasche and Fisher) - Non Energy Products
Output_NonEn_qLasp = (sum(ref.pIC(Indice_NonEnerSect,:).*Out.IC(Indice_NonEnerSect,:))+sum(ref.pC(Indice_NonEnerSect,:).*Out.C(Indice_NonEnerSect,:))+sum(ref.pG(Indice_NonEnerSect).*Out.G(Indice_NonEnerSect))+sum(ref.pI(Indice_NonEnerSect).*Out.I(Indice_NonEnerSect))+sum(ref.pX(Indice_NonEnerSect).*Out.X(Indice_NonEnerSect))-sum(ref.pM(Indice_NonEnerSect).*Out.M(Indice_NonEnerSect)))/sum(ref.Output_value(Indice_NonEnerSect)) ;
Output_NonEn_qPaas = sum(Out.Output_value(Indice_NonEnerSect)) / (sum(Out.pIC(Indice_NonEnerSect,:).*ref.IC(Indice_NonEnerSect,:))+sum(Out.pC(Indice_NonEnerSect,:).*ref.C(Indice_NonEnerSect,:))+sum(Out.pG(Indice_NonEnerSect).*ref.G(Indice_NonEnerSect))+sum(Out.pI(Indice_NonEnerSect).*ref.I(Indice_NonEnerSect))+sum(Out.pX(Indice_NonEnerSect).*ref.X(Indice_NonEnerSect))-sum(Out.pM(Indice_NonEnerSect).*ref.M(Indice_NonEnerSect))); 
Output_qFish = sqrt(Output_NonEn_qLasp*Output_NonEn_qPaas);

////////////////////////
////////////Households consumption
////////////////////////

// Price indices (Laspeyres, Paasche and Fisher) - Households consumption
C_pLasp = PInd_Lasp( ref.pC, ref.C, Out.pC, Out.C, :, :);
C_pPaas = PInd_Paas( ref.pC, ref.C, Out.pC, Out.C, :, :);
C_pFish = PInd_Fish( ref.pC, ref.C, Out.pC, Out.C, :, :);

// Quantity indices (Laspeyres, Paasche and Fisher) - Households consumption
C_qLasp = QInd_Lasp( ref.pC, ref.C, Out.pC, Out.C, :, :);
C_qPaas = QInd_Paas( ref.pC, ref.C, Out.pC, Out.C, :, :);
C_qFish = QInd_Fish( ref.pC, ref.C, Out.pC, Out.C, :, :);

/// By Households classes if required
if nb_Households <> 1
	for ind=1:nb_Households
		HH_qFish(1,ind) = QInd_Fish( ref.pC, ref.C, Out.pC, Out.C, :, ind);
		HH_pFish(1,ind) = PInd_Fish( ref.pC, ref.C, Out.pC, Out.C, :,ind);
	end
end


// Price indices (Laspeyres, Paasche and Fisher) - Households consumption - non energy goods
C_NonEn_pLasp = PInd_Lasp( ref.pC, ref.C, Out.pC, Out.C, Indice_NonEnerSect, :);
C_NonEn_pPaas = PInd_Paas( ref.pC, ref.C, Out.pC, Out.C, Indice_NonEnerSect, :);
C_NonEn_pFish = PInd_Fish( ref.pC, ref.C, Out.pC, Out.C, Indice_NonEnerSect, :);

// Quantity indices (Laspeyres, Paasche and Fisher) - Households consumption - non energy goods
C_NonEn_qLasp = QInd_Lasp( ref.pC, ref.C, Out.pC, Out.C, Indice_NonEnerSect, :);
C_NonEn_qPaas = QInd_Paas( ref.pC, ref.C, Out.pC, Out.C, Indice_NonEnerSect, :);
C_NonEn_qFish = QInd_Fish( ref.pC, ref.C, Out.pC, Out.C, Indice_NonEnerSect, :);

// Price indices (Laspeyres, Paasche and Fisher) - Households consumption - Energy goods
C_En_pLasp = PInd_Lasp( ref.pC, ref.C, Out.pC, Out.C, Indice_EnerSect, :);
C_En_pPaas = PInd_Paas( ref.pC, ref.C, Out.pC, Out.C, Indice_EnerSect, :);
C_En_pFish = PInd_Fish( ref.pC, ref.C, Out.pC, Out.C, Indice_EnerSect, :);

// Quantity indices (Laspeyres, Paasche and Fisher) - Households consumption - Energy goods
C_En_qLasp = QInd_Lasp( ref.pC, ref.C, Out.pC, Out.C, Indice_EnerSect, :);
C_En_qPaas = QInd_Paas( ref.pC, ref.C, Out.pC, Out.C, Indice_EnerSect, :);
C_En_qFish = QInd_Fish( ref.pC, ref.C, Out.pC, Out.C, Indice_EnerSect, :);

// Price indices (Laspeyres, Paasche and Fisher) - Households consumption - Primary goods
C_PrimEn_pLasp = PInd_Lasp( ref.pC, ref.C, Out.pC, Out.C, Indice_PrimEnerSect, :);
C_PrimEn_pPaas = PInd_Paas( ref.pC, ref.C, Out.pC, Out.C, Indice_PrimEnerSect, :);
C_PrimEn_pFish = PInd_Fish( ref.pC, ref.C, Out.pC, Out.C, Indice_PrimEnerSect, :);

// Quantity indices (Laspeyres, Paasche and Fisher) - Households consumption - Primary goods
C_PrimEn_qLasp = QInd_Lasp( ref.pC, ref.C, Out.pC, Out.C, Indice_PrimEnerSect, :);
C_PrimEn_qPaas = QInd_Paas( ref.pC, ref.C, Out.pC, Out.C, Indice_PrimEnerSect, :);
C_PrimEn_qFish = QInd_Fish( ref.pC, ref.C, Out.pC, Out.C, Indice_PrimEnerSect, :);

// Price indices (Laspeyres, Paasche and Fisher) - Households consumption - Final goods
C_FinEn_pLasp = PInd_Lasp( ref.pC, ref.C, Out.pC, Out.C, Indice_FinEnerSect, :);
C_FinEn_pPaas = PInd_Paas( ref.pC, ref.C, Out.pC, Out.C, Indice_FinEnerSect, :);
C_FinEn_pFish = PInd_Fish( ref.pC, ref.C, Out.pC, Out.C, Indice_FinEnerSect, :);

// Quantity indices (Laspeyres, Paasche and Fisher) - Households consumption - Final goods
C_FinEn_qLasp = QInd_Lasp( ref.pC, ref.C, Out.pC, Out.C, Indice_FinEnerSect, :);
C_FinEn_qPaas = QInd_Paas( ref.pC, ref.C, Out.pC, Out.C, Indice_FinEnerSect, :);
C_FinEn_qFish = QInd_Fish( ref.pC, ref.C, Out.pC, Out.C, Indice_FinEnerSect, :);

// Approximation real Households consumption (Nominal Households consumption / Fisher Price Index for Households consumption)
C_qFish = QInd_Fish( ref.pC,ref.C, Out.pC, Out.C, :, :) ;

// Approximation real Households consumption - non energy goods
C_NonEn_qFish_app = QInd_Fish_app( ref.pC,ref.C, Out.pC, Out.C, Indice_NonEnerSect, :) ;


////////////////////////
////////////Public Consumption
////////////////////////

// Price indices (Laspeyres, Paasche and Fisher) - Public consumption
G_pLasp = PInd_Lasp( ref.pG, ref.G, Out.pG, Out.G, :, :);
G_pPaas = PInd_Paas( ref.pG, ref.G, Out.pG, Out.G, :, :);
G_pFish = PInd_Fish( ref.pG, ref.G, Out.pG, Out.G, :, :);

// Quantity indices (Laspeyres, Paasche and Fisher) - Public consumption
G_qLasp = QInd_Lasp( ref.pG, ref.G, Out.pG, Out.G, :, :);
G_qPaas = QInd_Paas( ref.pG, ref.G, Out.pG, Out.G, :, :);
G_qFish = QInd_Fish( ref.pG, ref.G, Out.pG, Out.G, :, :);

// Price indices (Laspeyres, Paasche and Fisher) - Public consumption - non energy goods
G_NonEn_pLasp = PInd_Lasp( ref.pG, ref.G, Out.pG, Out.G, Indice_NonEnerSect, :);
G_NonEn_pPaas = PInd_Paas( ref.pG, ref.G, Out.pG, Out.G, Indice_NonEnerSect, :);
G_NonEn_pFish = PInd_Fish( ref.pG, ref.G, Out.pG, Out.G, Indice_NonEnerSect, :);

// Quantity indices (Laspeyres, Paasche and Fisher) - Public consumption - non energy goods
G_NonEn_qLasp = QInd_Lasp( ref.pG, ref.G, Out.pG, Out.G, Indice_NonEnerSect, :);
G_NonEn_qPaas = QInd_Paas( ref.pG, ref.G, Out.pG, Out.G, Indice_NonEnerSect, :);
G_NonEn_qFish = QInd_Fish( ref.pG, ref.G, Out.pG, Out.G, Indice_NonEnerSect, :);

// Price indices (Laspeyres, Paasche and Fisher) - Public  consumption - Energy goods
G_En_pLasp = PInd_Lasp( ref.pG, ref.G, Out.pG, Out.G, Indice_EnerSect, :);
G_En_pPaas = PInd_Paas( ref.pG, ref.G, Out.pG, Out.G, Indice_EnerSect, :);
G_En_pFish = PInd_Fish( ref.pG, ref.G, Out.pG, Out.G, Indice_EnerSect, :);

// Quantity indices (Laspeyres, Paasche and Fisher) - Public consumption - Energy goods
G_En_qLasp = QInd_Lasp( ref.pG, ref.G, Out.pG, Out.G, Indice_EnerSect, :);
G_En_qPaas = QInd_Paas( ref.pG, ref.G, Out.pG, Out.G, Indice_EnerSect, :);
G_En_qFish = QInd_Fish( ref.pG, ref.G, Out.pG, Out.G, Indice_EnerSect, :);

// Price indices (Laspeyres, Paasche and Fisher) - Public consumption - Primary goods
G_PrimEn_pLasp = PInd_Lasp( ref.pG, ref.G, Out.pG, Out.G, Indice_PrimEnerSect, :);
G_PrimEn_pPaas = PInd_Paas( ref.pG, ref.G, Out.pG, Out.G, Indice_PrimEnerSect, :);
G_PrimEn_pFish = PInd_Fish( ref.pG, ref.G, Out.pG, Out.G, Indice_PrimEnerSect, :);

// Quantity indices (Laspeyres, Paasche and Fisher) - Public consumption - Primary goods
G_PrimEn_qLasp = QInd_Lasp( ref.pG, ref.G, Out.pG, Out.G, Indice_PrimEnerSect, :);
G_PrimEn_qPaas = QInd_Paas( ref.pG, ref.G, Out.pG, Out.G, Indice_PrimEnerSect, :);
G_PrimEn_qFish = QInd_Fish( ref.pG, ref.G, Out.pG, Out.G, Indice_PrimEnerSect, :);

// Price indices (Laspeyres, Paasche and Fisher) - Public consumption - Final goods
G_FinEn_pLasp = PInd_Lasp( ref.pG, ref.G, Out.pG, Out.G, Indice_FinEnerSect, :);
G_FinEn_pPaas = PInd_Paas( ref.pG, ref.G, Out.pG, Out.G, Indice_FinEnerSect, :);
G_FinEn_pFish = PInd_Fish( ref.pG, ref.G, Out.pG, Out.G, Indice_FinEnerSect, :);

// Quantity indices (Laspeyres, Paasche and Fisher) - Public consumption - Final goods
G_FinEn_qLasp = QInd_Lasp( ref.pG, ref.G, Out.pG, Out.G, Indice_FinEnerSect, :);
G_FinEn_qPaas = QInd_Paas( ref.pG, ref.G, Out.pG, Out.G, Indice_FinEnerSect, :);
G_FinEn_qFish = QInd_Fish( ref.pG, ref.G, Out.pG, Out.G, Indice_FinEnerSect, :);

////////////////////////	
////////////Investment
////////////////////////

I = (abs(I) > %eps).*I;
ind_Inv = find(sum(I,"c")<>0)';
for ind = 1:size(ind_Inv,"r")
indI = ind_Inv(ind);
I_pLasp_temp(ind) = PInd_Lasp( ref.pI, ref.I, Out.pI, Out.I, indI, :);
I_pPaas_temp(ind) = PInd_Paas( ref.pI, ref.I, Out.pI, Out.I, indI, :);
I_pFish_temp(ind) = PInd_Fish( ref.pI, ref.I, Out.pI, Out.I, indI, :);
end

execstr ( "I_"+Index_Sectors(ind_Inv)+"_pLasp = "+I_pLasp_temp);
execstr ( "I_"+Index_Sectors(ind_Inv)+"_pPaas = "+I_pPaas_temp);
execstr ( "I_"+Index_Sectors(ind_Inv)+"_pFish = "+I_pFish_temp);
clear I_pFish_temp I_pLasp_temp I_pPaas_temp

// Price indices (Laspeyres, Paasche and Fisher) - Investment
I_pLasp = PInd_Lasp( ref.pI, ref.I, Out.pI, Out.I, :, :);
I_pPaas = PInd_Paas( ref.pI, ref.I, Out.pI, Out.I, :, :);
I_pFish = PInd_Fish( ref.pI, ref.I, Out.pI, Out.I, :, :);

// Quantity indices (Laspeyres, Paasche and Fisher) - Investment
I_qLasp = QInd_Lasp( ref.pI, ref.I, Out.pI, Out.I, :, :);
I_qPaas = QInd_Paas( ref.pI, ref.I, Out.pI, Out.I, :, :);
I_qFish = QInd_Fish( ref.pI, ref.I, Out.pI, Out.I, :, :);

// Price indices (Laspeyres, Paasche and Fisher) - Investment - non energy goods
I_NonEn_pLasp = PInd_Lasp( ref.pI, ref.I, Out.pI, Out.I, Indice_NonEnerSect, :);
I_NonEn_pPaas = PInd_Paas( ref.pI, ref.I, Out.pI, Out.I, Indice_NonEnerSect, :);
I_NonEn_pFish = PInd_Fish( ref.pI, ref.I, Out.pI, Out.I, Indice_NonEnerSect, :);

// Quantity indices (Laspeyres, Paasche and Fisher) - Investment - non energy goods
I_NonEn_qLasp = QInd_Lasp( ref.pI, ref.I, Out.pI, Out.I, Indice_NonEnerSect, :);
I_NonEn_qPaas = QInd_Paas( ref.pI, ref.I, Out.pI, Out.I, Indice_NonEnerSect, :);
I_NonEn_qFish = QInd_Fish( ref.pI, ref.I, Out.pI, Out.I, Indice_NonEnerSect, :);

// Price indices (Laspeyres, Paasche and Fisher) - Investment - Energy goods
I_En_pLasp = PInd_Lasp( ref.pI, ref.I, Out.pI, Out.I, Indice_EnerSect, :);
I_En_pPaas = PInd_Paas( ref.pI, ref.I, Out.pI, Out.I, Indice_EnerSect, :);
I_En_pFish = PInd_Fish( ref.pI, ref.I, Out.pI, Out.I, Indice_EnerSect, :);

// Quantity indices (Laspeyres, Paasche and Fisher) - Investment - Energy goods
I_En_qLasp = QInd_Lasp( ref.pI, ref.I, Out.pI, Out.I, Indice_EnerSect, :);
I_En_qPaas = QInd_Paas( ref.pI, ref.I, Out.pI, Out.I, Indice_EnerSect, :);
I_En_qFish = QInd_Fish( ref.pI, ref.I, Out.pI, Out.I, Indice_EnerSect, :);

////////////////////////
//////////// Exports
////////////////////////

// Price indices (Laspeyres, Paasche and Fisher) - Exports
X_pLasp = PInd_Lasp( ref.pX, ref.X, Out.pX, Out.X, :, :);
X_pPaas = PInd_Paas( ref.pX, ref.X, Out.pX, Out.X, :, :);
X_pFish = PInd_Fish( ref.pX, ref.X, Out.pX, Out.X, :, :);

// Price indices (Laspeyres, Paasche and Fisher) - Energy - Exports
X_En_pLasp = PInd_Lasp( ref.pX, ref.X, Out.pX, Out.X, Indice_EnerSect, :);
X_En_pPaas = PInd_Paas( ref.pX, ref.X, Out.pX, Out.X, Indice_EnerSect, :);
X_En_pFish = PInd_Fish( ref.pX, ref.X, Out.pX, Out.X, Indice_EnerSect, :);

// Price indices (Laspeyres, Paasche and Fisher) - non Energy Products - Exports
X_NonEn_pLasp = PInd_Lasp( ref.pX, ref.X, Out.pX, Out.X, Indice_NonEnerSect, :);
X_NonEn_pPaas = PInd_Paas( ref.pX, ref.X, Out.pX, Out.X, Indice_NonEnerSect, :);
X_NonEn_pFish = PInd_Fish( ref.pX, ref.X, Out.pX, Out.X, Indice_NonEnerSect, :);

// Price indices (Laspeyres, Paasche and Fisher) - Primary Energy - Exports
X_PrimEn_pLasp = PInd_Lasp( ref.pX, ref.X, Out.pX, Out.X, Indice_PrimEnerSect, :);
X_PrimEn_pPaas = PInd_Paas( ref.pX, ref.X, Out.pX, Out.X, Indice_PrimEnerSect, :);
X_PrimEn_pFish = PInd_Fish( ref.pX, ref.X, Out.pX, Out.X, Indice_PrimEnerSect, :);

// Price indices (Laspeyres, Paasche and Fisher) - Final Energy - Exports
X_FinEn_pLasp = PInd_Lasp( ref.pX, ref.X, Out.pX, Out.X, Indice_FinEnerSect, :);
X_FinEn_pPaas = PInd_Paas( ref.pX, ref.X, Out.pX, Out.X, Indice_FinEnerSect, :);
X_FinEn_pFish = PInd_Fish( ref.pX, ref.X, Out.pX, Out.X, Indice_FinEnerSect, :);

// Quantity indices (Laspeyres, Paasche and Fisher) - Exports
X_qLasp = QInd_Lasp( ref.pX, ref.X, Out.pX, Out.X, :, :);
X_qPaas = QInd_Paas( ref.pX, ref.X, Out.pX, Out.X, :, :);
X_qFish = QInd_Fish( ref.pX, ref.X, Out.pX, Out.X, :, :);

// Quantity indices (Laspeyres, Paasche and Fisher) - Energy - Exports
X_En_qLasp = QInd_Lasp( ref.pX, ref.X, Out.pX, Out.X, Indice_EnerSect, :);
X_En_qPaas = QInd_Paas( ref.pX, ref.X, Out.pX, Out.X, Indice_EnerSect, :);
X_En_qFish = QInd_Fish( ref.pX, ref.X, Out.pX, Out.X, Indice_EnerSect, :);

// Quantity indices (Laspeyres, Paasche and Fisher) - non Energy Products - Exports
X_NonEn_qLasp = QInd_Lasp( ref.pX, ref.X, Out.pX, Out.X, Indice_NonEnerSect, :);
X_NonEn_qPaas = QInd_Paas( ref.pX, ref.X, Out.pX, Out.X, Indice_NonEnerSect, :);
X_NonEn_qFish = QInd_Fish( ref.pX, ref.X, Out.pX, Out.X, Indice_NonEnerSect, :);

// Quantity indices (Laspeyres, Paasche and Fisher) - Primary Energy - Exports
X_PrimEn_qLasp = QInd_Lasp( ref.pX, ref.X, Out.pX, Out.X, Indice_PrimEnerSect, :);
X_PrimEn_qPaas = QInd_Paas( ref.pX, ref.X, Out.pX, Out.X, Indice_PrimEnerSect, :);
X_PrimEn_qFish = QInd_Fish( ref.pX, ref.X, Out.pX, Out.X, Indice_PrimEnerSect, :);

// Quantity indices (Laspeyres, Paasche and Fisher) - Final Energy - Exports
X_FinEn_qLasp = QInd_Lasp( ref.pX, ref.X, Out.pX, Out.X, Indice_FinEnerSect, :);
X_FinEn_qPaas = QInd_Paas( ref.pX, ref.X, Out.pX, Out.X, Indice_FinEnerSect, :);
X_FinEn_qFish = QInd_Fish( ref.pX, ref.X, Out.pX, Out.X, Indice_FinEnerSect, :);

////////////////////////
//////////// Imports
////////////////////////

// Price indices (Laspeyres, Paasche and Fisher) - Imports
M_pLasp = PInd_Lasp( ref.pM, ref.M, Out.pM, Out.M, :, :);
M_pPaas = PInd_Paas( ref.pM, ref.M, Out.pM, Out.M, :, :);
M_pFish = PInd_Fish( ref.pM, ref.M, Out.pM, Out.M, :, :);

// Price indices (Laspeyres, Paasche and Fisher) - Energy - Imports
M_En_pLasp = PInd_Lasp( ref.pM, ref.M, Out.pM, Out.M, Indice_EnerSect, :);
M_En_pPaas = PInd_Paas( ref.pM, ref.M, Out.pM, Out.M, Indice_EnerSect, :);
M_En_pFish = PInd_Fish( ref.pM, ref.M, Out.pM, Out.M, Indice_EnerSect, :);

// Price indices (Laspeyres, Paasche and Fisher) - Primary Energy - Imports
M_PrimEn_pLasp = PInd_Lasp( ref.pM, ref.M, Out.pM, Out.M, Indice_PrimEnerSect, :);
M_PrimEn_pPaas = PInd_Paas( ref.pM, ref.M, Out.pM, Out.M, Indice_PrimEnerSect, :);
M_PrimEn_pFish = PInd_Fish( ref.pM, ref.M, Out.pM, Out.M, Indice_PrimEnerSect, :);

// Price indices (Laspeyres, Paasche and Fisher) - Final Energy - Imports
M_FinEn_pLasp = PInd_Lasp( ref.pM, ref.M, Out.pM, Out.M, Indice_FinEnerSect, :);
M_FinEn_pPaas = PInd_Paas( ref.pM, ref.M, Out.pM, Out.M, Indice_FinEnerSect, :);
M_FinEn_pFish = PInd_Fish( ref.pM, ref.M, Out.pM, Out.M, Indice_FinEnerSect, :);

// Price indices (Laspeyres, Paasche and Fisher) - Non Energy Products - Imports
M_NonEn_pLasp = PInd_Lasp( ref.pM, ref.M, Out.pM, Out.M, Indice_NonEnerSect, :);
M_NonEn_pPaas = PInd_Paas( ref.pM, ref.M, Out.pM, Out.M, Indice_NonEnerSect, :);
M_NonEn_pFish = PInd_Fish( ref.pM, ref.M, Out.pM, Out.M, Indice_NonEnerSect, :);

// Quantity indices (Laspeyres, Paasche and Fisher) - Imports
M_qLasp = QInd_Lasp( ref.pM, ref.M, Out.pM, Out.M, :, :);
M_qPaas = QInd_Paas( ref.pM, ref.M, Out.pM, Out.M, :, :);
M_qFish = QInd_Fish( ref.pM, ref.M, Out.pM, Out.M, :, :);

// Quantity indices (Laspeyres, Paasche and Fisher) - Energy - Imports
M_En_qLasp = QInd_Lasp( ref.pM, ref.M, Out.pM, Out.M, Indice_EnerSect, :);
M_En_qPaas = QInd_Paas( ref.pM, ref.M, Out.pM, Out.M, Indice_EnerSect, :);
M_En_qFish = QInd_Fish( ref.pM, ref.M, Out.pM, Out.M, Indice_EnerSect, :);

// Quantity indices (Laspeyres, Paasche and Fisher) - non Energy Products - Imports
M_NonEn_qLasp = QInd_Lasp( ref.pM, ref.M, Out.pM, Out.M, Indice_NonEnerSect, :);
M_NonEn_qPaas = QInd_Paas( ref.pM, ref.M, Out.pM, Out.M, Indice_NonEnerSect, :);
M_NonEn_qFish = QInd_Fish( ref.pM, ref.M, Out.pM, Out.M, Indice_NonEnerSect, :);

// Quantity indices (Laspeyres, Paasche and Fisher) - Primary Energy - Imports
M_PrimEn_qLasp = QInd_Lasp( ref.pM, ref.M, Out.pM, Out.M, Indice_PrimEnerSect, :);
M_PrimEn_qPaas = QInd_Paas( ref.pM, ref.M, Out.pM, Out.M, Indice_PrimEnerSect, :);
M_PrimEn_qFish = QInd_Fish( ref.pM, ref.M, Out.pM, Out.M, Indice_PrimEnerSect, :);

// Quantity indices (Laspeyres, Paasche and Fisher) - Final Energy - Imports
M_FinEn_qLasp = QInd_Lasp( ref.pM, ref.M, Out.pM, Out.M, Indice_FinEnerSect, :);
M_FinEn_qPaas = QInd_Paas( ref.pM, ref.M, Out.pM, Out.M, Indice_FinEnerSect, :);
M_FinEn_qFish = QInd_Fish( ref.pM, ref.M, Out.pM, Out.M, Indice_FinEnerSect, :);

////////////////////////
//////////// Trade balance
////////////////////////

// Price indices (Laspeyres, Paasche and Fisher) - Trade Balance
Trade_pLasp = (sum(Out.pX.*ref.X)-sum(Out.pM.*ref.M))/(sum(ref.pX.*ref.X)-sum(ref.pM.*ref.M)) ;
Trade_pPaas = (sum(Out.pX.*Out.X)-sum(Out.pM.*Out.M))/(sum(ref.pX.*Out.X)-sum(ref.pM.*Out.M)) ;
Trade_pFish = sqrt(abs(Trade_pLasp*Trade_pPaas));

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
ref.IC_output_ValueShare 	= sum(ref.IC_value)/ sum(ref.Output_value);
ref.GDP_output_ValueShare 	= sum(ref.GDP)/ sum(ref.Output_value);

Out.IC_output_ValueShare 	= sum(Out.IC_value)/ sum(Out.Output_value);
Out.GDP_output_ValueShare 	= sum(Out.GDP)/ sum(Out.Output_value);

// Decomposition of variations for the first level macroeconomic identity
IC_Output_qLasp 	= ref.IC_output_ValueShare * IC_qLasp ;
GDP_Output_qLasp 	= ref.GDP_output_ValueShare * GDP_qLasp ;

////////////////////////
//////////// Second level macroeconomic identity: GDP = Households Consumption + Public Consumption + Investment + Exports - Imports
////////////////////////

// Initial value shares (in output) for each components of GDP
ref.C_Output_ValueShare	= sum(ref.C_value)/ sum(ref.Output_value); 
ref.G_Output_ValueShare	= sum(ref.G_value)/ sum(ref.Output_value); 
ref.I_Output_ValueShare	= sum(ref.I_value)/ sum(ref.Output_value); 
ref.X_Output_ValueShare	= sum(ref.X_value)/ sum(ref.Output_value); 
ref.M_Output_ValueShare	= -sum(ref.M_value)/ sum(ref.Output_value);

// Final value shares (in output) for each components of GDP
	// added to have the same number of variables in output in input data list
Out.C_Output_ValueShare	= sum(Out.C_value)/ sum(Out.Output_value); 
Out.G_Output_ValueShare	= sum(Out.G_value)/ sum(Out.Output_value); 
Out.I_Output_ValueShare	= sum(Out.I_value)/ sum(Out.Output_value); 
Out.X_Output_ValueShare	= sum(Out.X_value)/ sum(Out.Output_value); 
Out.M_Output_ValueShare	= -sum(Out.M_value)/ sum(Out.Output_value);

// Decomposition of variations for the second level macroeconomic identity
C_GDP_qLasp = ref.C_Output_ValueShare * C_qLasp ;
G_GDP_qLasp = ref.G_Output_ValueShare * G_qLasp ;
I_GDP_qLasp = ref.I_Output_ValueShare * I_qLasp ;
X_GDP_qLasp = ref.X_Output_ValueShare * X_qLasp ;
M_GDP_qLasp = ref.M_Output_ValueShare * M_qLasp ;

////////////////////////
//////////// Households Consumption = Households Non Energy consumption + Households Energy Consumption	
////////////////////////

// Initial value shares for each components of Households Consumption
ref.Ener_C_ValueShare		= sum(ref.C_value(Indice_EnerSect, :))/sum(ref.C_value) ;
ref.NonEner_C_ValueShare	= sum(ref.C_value(Indice_NonEnerSect, :))/sum(ref.C_value) ;

Out.Ener_C_ValueShare		= sum(Out.C_value(Indice_EnerSect, :))/sum(Out.C_value) ;
Out.NonEner_C_ValueShare	= sum(Out.C_value(Indice_NonEnerSect, :))/sum(Out.C_value) ;

ref.Ener_C_ValueShareFish		= ref.Ener_C_ValueShare; 
ref.NonEner_C_ValueShareFish	= ref.NonEner_C_ValueShare; 

Out.Ener_C_ValueShareFish		= (sum(Out.C_value(Indice_EnerSect, :)) / C_En_pFish ) /(sum(Out.C_value)/C_pFish) ;
Out.NonEner_C_ValueShareFish	= (sum(Out.C_value(Indice_NonEnerSect, :))/C_NonEn_pFish)/(sum(Out.C_value)/C_pFish);

// Decomposition of variations - Households consumption
CEner_C_qLasp 	= ref.Ener_C_ValueShare * C_En_qLasp ;
CNonEner_C_qLasp 	= ref.NonEner_C_ValueShare * C_NonEn_qLasp ;


////////////////////////////////////////////////////////////
//////	Technical coefficients - Indices
////////////////////////////////////////////////////////////

////////////////////////
//////////// Capital intensity
////////////////////////

//Laspeyres, Paasche and Fisher indices for capital intensity (kappa treated as price)
kappa_pLasp = PInd_Lasp( ref.kappa, ref.Y', Out.kappa, Out.Y', :, :);
kappa_pPaas = PInd_Paas( ref.kappa, ref.Y', Out.kappa, Out.Y', :, :);
kappa_pFish = PInd_Fish( ref.kappa, ref.Y', Out.kappa, Out.Y', :, :);


////////////////////////
//////////// Labour intensity
////////////////////////

//Laspeyres, Paasche and Fisher indices for labour intensity (lambda treated as price)
lambda_pLasp = PInd_Lasp( ref.lambda, ref.Y', Out.lambda, Out.Y', :, :);
lambda_pPaas = PInd_Paas( ref.lambda, ref.Y', Out.lambda, Out.Y', :, :);
lambda_pFish = PInd_Fish( ref.lambda, ref.Y', Out.lambda, Out.Y', :, :);

//Laspeyres, Paasche and Fisher indices for labour intensity of non energy goods (lambda treated as price)
lambda_NonEn_pLasp = PInd_Lasp( ref.lambda, ref.Y', Out.lambda, Out.Y', :, Indice_NonEnerSect);
lambda_NonEn_pPaas = PInd_Paas( ref.lambda, ref.Y', Out.lambda, Out.Y', :, Indice_NonEnerSect);
lambda_NonEn_pFish = PInd_Fish( ref.lambda, ref.Y', Out.lambda, Out.Y', :, Indice_NonEnerSect);


////////////////////////
//////////// Energy intensity
////////////////////////


//Laspeyres, Paasche and Fisher indices for energy intensity (alpha treated as price)
alpha_Ener_qLasp = QInd_Lasp( ref.alpha, ones(nb_Commodities, 1).*.ref.Y', Out.alpha, ones(nb_Commodities, 1).*.Out.Y', Indice_EnerSect, :);
alpha_Ener_qPaas = QInd_Paas( ref.alpha, ones(nb_Commodities, 1).*.ref.Y', Out.alpha, ones(nb_Commodities, 1).*.Out.Y', Indice_EnerSect, :);
alpha_Ener_qFish = QInd_Fish( ref.alpha, ones(nb_Commodities, 1).*.ref.Y', Out.alpha, ones(nb_Commodities, 1).*.Out.Y', Indice_EnerSect, :);

////////////////////////////////////////////////////////////
////// Trade Indicators
////////////////////////////////////////////////////////////

////////////////////////
//////////// Trade intensity
////////////////////////

//////// By sectors
ref.TradeInt = TradeIntens(ref.M_value, ref.X_value', ref.Y_value);
Out.TradeInt = TradeIntens(Out.M_value, Out.X_value', Out.Y_value);
evol_ref.TradeInt =  (divide(Out.TradeInt , ref.TradeInt , %nan ) );

//////// Global
ref.TradeInt_tot = TradeIntens(sum(ref.M_value), sum(ref.X_value), sum(ref.Y_value));
Out.TradeInt_tot = TradeIntens(sum(Out.M_value), sum(Out.X_value), sum(Out.Y_value));
evol_ref.TradeInt_tot =  (divide(Out.TradeInt_tot , ref.TradeInt_tot , %nan ));

////////////////////////
//////Import penetration ratios :  ratio between the value of imports as a percentage of total domestic demanOut. The import penetration rate shows to what degree domestic demand D is satisfied by imports M
////////////////////////

//////// By sectors
ref.M_penetRat = M_penetRat(ref.M_value, ref.Y_value, ref.X_value');
Out.M_penetRat = M_penetRat(Out.M_value, Out.Y_value, Out.X_value');
evol_ref.M_penetRat =  (divide(Out.M_penetRat , ref.M_penetRat , %nan )); 

//////// Global
ref.M_penetRat_tot = M_penetRat(sum(ref.M_value), sum(ref.Y_value), sum(ref.X_value));
Out.M_penetRat_tot = M_penetRat(sum(Out.M_value), sum(Out.Y_value), sum(Out.X_value));
evol_ref.M_penetRat_tot =  (divide(Out.M_penetRat_tot , ref.M_penetRat_tot , %nan )); 

////// Price and Quantity Indices for the imports/domestic production ratio in quantities (M/Y)
M_Y_Ratio_pLasp = PInd_Lasp( ref.pM./ref.pY, ref.M./ref.Y, Out.pM./Out.pY, Out.M./Out.Y, :, :);
M_Y_Ratio_pPaas = PInd_Paas( ref.pM./ref.pY, ref.M./ref.Y, Out.pM./Out.pY, Out.M./Out.Y, :, :);
M_Y_Ratio_pFish = PInd_Fish( ref.pM./ref.pY, ref.M./ref.Y, Out.pM./Out.pY, Out.M./Out.Y, :, :);

M_Y_Ratio_qLasp = QInd_Lasp( ref.pM./ref.pY, ref.M./ref.Y, Out.pM./Out.pY, Out.M./Out.Y, :, :);
M_Y_Ratio_qPaas = QInd_Paas( ref.pM./ref.pY, ref.M./ref.Y, Out.pM./Out.pY, Out.M./Out.Y, :, :);
M_Y_Ratio_qFish = QInd_Fish( ref.pM./ref.pY, ref.M./ref.Y, Out.pM./Out.pY, Out.M./Out.Y, :, :);


////////////////////////////////////////////////////////////
////// 	Total Labour (Full-time equivalent)
////////////////////////////////////////////////////////////

ref.Labour_tot = sum(ref.Labour);
Out.Labour_tot = sum(Out.Labour);
evol_ref.Labour_tot = divide(Out.Labour_tot, ref.Labour_tot, %nan);

ref.Unit_Labcost = ref.pL.*ref.lambda;
Out.Unit_Labcost = Out.pL.*Out.lambda;
evol_ref.Unit_Labcost = (divide(Out.Unit_Labcost,ref.Unit_Labcost,%nan))  ;

// Quantity indices (Laspeyres, Paasche and Fisher) - Production in Labour
// For decomposition: Labour Variation = Index lambda (Paashes) * Index Y_Labour (Laspeyres)
Y_Labour_qLasp = QInd_Lasp( ref.lambda, ref.Y', Out.lambda, Out.Y', :, :);


////////////////////////////////////////////////////////////
////// Cost Share
////////////////////////////////////////////////////////////

////////////////////////
//////////// Energy Cost Share
////////////////////////

// Energy Cost Share - By sectors
ref.ENshare = Cost_Share( ref.IC_value(Indice_EnerSect,:)  , ref.Y_value(:)') ;
Out.ENshare = Cost_Share( Out.IC_value(Indice_EnerSect,:)  , Out.Y_value(:)') ;
evol_ref.ENshare =  ( divide(Out.ENshare , ref.ENshare , %nan ) ) ;

//  Energy Cost Share - For non energetic sectors
ref.ENshareNONEner = Cost_Share( sum(ref.IC_value(Indice_EnerSect,Indice_NonEnerSect))  ,sum( ref.Y_value(Indice_NonEnerSect))) ;
Out.ENshareNONEner = Cost_Share( sum(Out.IC_value(Indice_EnerSect,Indice_NonEnerSect))  , sum(Out.Y_value(Indice_NonEnerSect))) ;
evol_ref.ENshareNONEner =  ( divide(Out.ENshareNONEner , ref.ENshareNONEner , %nan ) ) ;


//	Energy Cost Share - All sectors (Macro level)
ref.ENshareMacro = sum(ref.IC_value(Indice_EnerSect,:)) / sum(ref.Y_value(:));
Out.ENshareMacro =  sum(Out.IC_value(Indice_EnerSect,:)) / sum(Out.Y_value(:));
evol_ref.ENshareMacro = divide(Out.ENshareMacro , ref.ENshareMacro , %nan ) ; 

/////////////////////////
//////////// Labour Cost share - All sectors (Macro level)	
/////////////////////////
// Plutôt que recalculer voir comment utiliser Labour_income déjà calculé dans iot pour le niveau d'agrégation donné

ref.LabourShareMacro = sum(ref.Labour .* ref.pL) / sum(ref.Y_value(:));
Out.LabourShareMacro   = sum(Out.Labour .* Out.pL) / sum(Out.Y_value(:));
evol_ref.LabourShareMacro = divide(Out.LabourShareMacro , ref.LabourShareMacro , %nan ) ; 	

////////////////////////
//////////// Energy cost/ Labour cost RATIO
////////////////////////

ref.ShareEN_Lab = divide(( sum(ref.pIC(Indice_EnerSect,:).*ref.alpha(Indice_EnerSect,:),"r") ), ref.Unit_Labcost,%nan) ; 
Out.ShareEN_Lab = ( sum(Out.pIC(Indice_EnerSect,:).*Out.alpha(Indice_EnerSect,:),"r") ) ./ Out.Unit_Labcost  ;
evol_ref.ShareEN_Lab = (divide(Out.ShareEN_Lab, ref.ShareEN_Lab, %nan)) ;

////////////////////////////////////////////////////////////
////// Input Prices
////////////////////////////////////////////////////////////

////////////////////////
//////////// Mean wage
////////////////////////

ref.omega 	= sum (ref.w .* ref.Labour) / sum(ref.Labour) ;
Out.omega 	= sum (Out.w .* Out.Labour) / sum(Out.Labour) ;
evol_ref.omega	= divide(Out.omega , ref.omega , %nan ) ;

// Labour price index
L_pFish = PInd_Fish( ref.pL', ref.Y, Out.pL', Out.Y, :, :);
// Capital price index 
K_pFish = PInd_Fish( ref.pK', ref.Y, Out.pK', Out.Y, :, :);

////////////////////////
//////////// Energy input price - All sectors (Macro) - Price indices (Laspeyres, Paasche and Fisher)
////////////////////////

// Price indices (Laspeyres, Paasche and Fisher) - Energy - Intermediate Consumption
IC_Ener_pLasp = PInd_Lasp( ref.pIC, ref.IC, Out.pIC, Out.IC, Indice_EnerSect, :);
IC_Ener_pPaas = PInd_Paas( ref.pIC, ref.IC, Out.pIC, Out.IC, Indice_EnerSect, :);
IC_Ener_pFish = PInd_Fish( ref.pIC, ref.IC, Out.pIC, Out.IC, Indice_EnerSect, :);

// Price indices (Laspeyres, Paasche and Fisher) - Primary Energy - Intermediate Consumption
IC_PrimEn_pLasp = PInd_Lasp( ref.pIC, ref.IC, Out.pIC, Out.IC, Indice_PrimEnerSect, :);
IC_PrimEn_pPaas = PInd_Paas( ref.pIC, ref.IC, Out.pIC, Out.IC, Indice_PrimEnerSect, :);
IC_PrimEn_pFish = PInd_Fish( ref.pIC, ref.IC, Out.pIC, Out.IC, Indice_PrimEnerSect, :);

// Price indices (Laspeyres, Paasche and Fisher) - Final Energy - Intermediate Consumption
IC_FinEn_pLasp = PInd_Lasp( ref.pIC, ref.IC, Out.pIC, Out.IC, Indice_FinEnerSect, :);
IC_FinEn_pPaas = PInd_Paas( ref.pIC, ref.IC, Out.pIC, Out.IC, Indice_FinEnerSect, :);
IC_FinEn_pFish = PInd_Fish( ref.pIC, ref.IC, Out.pIC, Out.IC, Indice_FinEnerSect, :);

// Price indices (Laspeyres, Paasche and Fisher) - Non Energy Products - Intermediate Consumption
IC_NonEn_pLasp = PInd_Lasp( ref.pIC, ref.IC, Out.pIC, Out.IC, Indice_NonEnerSect, :);
IC_NonEn_pPaas = PInd_Paas( ref.pIC, ref.IC, Out.pIC, Out.IC, Indice_NonEnerSect, :);
IC_NonEn_pFish = PInd_Fish( ref.pIC, ref.IC, Out.pIC, Out.IC, Indice_NonEnerSect, :);

// Price indices (Laspeyres, Paasche and Fisher) - All - Intermediate Consumption
IC_pLasp = PInd_Lasp( ref.pIC, ref.IC, Out.pIC, Out.IC, :, :);
IC_pPaas = PInd_Paas( ref.pIC, ref.IC, Out.pIC, Out.IC, :, :);
IC_pFish = PInd_Fish( ref.pIC, ref.IC, Out.pIC, Out.IC, :, :);


////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////  COMPARAISON TABLE FOR OUTPUT
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

// TableTrade.ref = [["TableTrade_"+ref_name, "pY", "Y vol","Y val", "pM", "M vol","M val","pX",Index_FC' + " vol",Index_FC' + " val", "Unit Labour cost", "Ener Cost Share","Ener/Labour cost", "Trade Intens", "Import Penet Rate"];[Index_Sectors, ref.pY,  ref.Y, ref.Y_value', ref.pM,  ref.M ,ref.M_value',ref.pX, ref.FC, ref.FC_value,ref.Unit_Labcost', ref.ENshare'.*100,ref.ShareEN_Lab',ref.TradeInt',ref.M_penetRat' ]];
// TableTrade.run = [["TableTrade_run", "pY", "Y vol","Y val","pM", "M vol","M val","pX", Index_FC' + " vol", Index_FC' + " val","Unit Labour cost","Ener Cost Share","Ener/Labour cost", "Trade Intens", "Import Penet Rate"];[Index_Sectors, Out.pY,  Out.Y,Out.Y_value',Out.pM,  Out.M ,Out.M_value',Out.pX, Out.FC,Out.FC_value, Out.Unit_Labcost', Out.ENshare'.*100,Out.ShareEN_Lab',Out.TradeInt',Out.M_penetRat']];
// TableTrade.evol_ref = [["TableTrade%", "pY", "Y vol","Y val","pM", "M vol","M val", "pX",Index_FC' + " vol" ,Index_FC' + " val","Unit Labour cost", "Ener Cost Share","Ener/Labour cost", "Trade Intens", "Import Penet Rate"];[Index_Sectors,(divide(Out.pY , ref.pY , %nan )-1).*100,  (divide(Out.Y , ref.Y , %nan )-1).*100, (divide(Out.Y_value' , ref.Y_value' , %nan )-1).*100,(divide(Out.pM , ref.pM , %nan )-1).*100,  (divide(Out.M , ref.M , %nan )-1).*100,(divide(Out.M_value' , ref.M_value' , %nan )-1).*100,(divide(Out.pX , ref.pX , %nan )-1).*100, (divide(Out.FC , ref.FC , %nan )-1).*100,(divide(Out.FC_value , ref.FC_value , %nan )),(evol_ref.Unit_Labcost'-1).*100, Out.ENshare'.*100-ref.ENshare'.*100, (evol_ref.TradeInt' - 1).*100,(evol_ref.M_penetRat'-1).*100]];

TableTrade(ref_name) = [["TableTrade_"+ref_name, "pY", "Y vol", "pM", "M vol",Index_FC' + " vol", "Ener Cost Share","Trade Intens", "Import Penet Rate"];[Index_Sectors, ref.pY,  ref.Y,ref.pM,  ref.M , ref.FC,  ref.ENshare'.*100,ref.TradeInt',ref.M_penetRat' ]];
TableTrade.run = [["TableTrade_run",  "pY", "Y vol", "pM", "M vol",Index_FC' + " vol", "Ener Cost Share","Trade Intens", "Import Penet Rate"];[Index_Sectors, Out.pY,  Out.Y,Out.pM,  Out.M , Out.FC, Out.ENshare'.*100,Out.TradeInt',Out.M_penetRat']];
TableTrade.evol_ref = [["TableTrade%",  "pY", "Y vol","pM", "M vol",Index_FC' + " vol", "Ener Cost Share","Trade Intens", "Import Penet Rate"];[Index_Sectors,(divide(Out.pY , ref.pY , %nan )-1).*100,  (divide(Out.Y , ref.Y , %nan )-1).*100,(divide(Out.pM , ref.pM , %nan )-1).*100,  (divide(Out.M , ref.M , %nan )-1).*100, (divide((abs(Out.FC) > %eps).*Out.FC, (abs(ref.FC) > %eps).*ref.FC , %nan )-1).*100, Out.ENshare'.*100-ref.ENshare'.*100,(evol_ref.TradeInt' - 1).*100,(evol_ref.M_penetRat'-1).*100]];


if Output_files
if OutputfilesBY
csvWrite(TableTrade(ref_name),SAVEDIR+"TableTrade"+ref_name+"_"+Name_time+"_"+simu_name+".csv", ';');
csvWrite(TableTrade.run,SAVEDIR+"TableTrade-run_"+Name_time+"_"+simu_name+".csv", ';');
csvWrite(TableTrade(ref_name),SAVEDIR+"TableTrade-evol_"+ref_name+"_"+Name_time+"_"+simu_name+".csv", ';');
end
end


// Tables for Aggregate Macroeconomic Indicators

// Variations of Macroeconomic Quantity Index Numbers
Indice_NetLending = find(Index_DataAccount=="NetLending");

evol_ref.MacroT1 = [["Variable", "Indice 0", "Indice 1", "% variation"]; ["Nominal Output", "1", sum(Out.Output_value)./ sum(ref.Output_value), (sum(Out.Output_value)./ sum(ref.Output_value)-1)*100]; ["Real Output", "1", Output_qLasp, "nan"]; ["Output price index", "1", Output_pPaas, "nan"]; ["Contribution of Nominal Intermediate consumptions to Nominal Output variation", sum(ref.IC_value) / sum(ref.Output_value), (sum(ref.IC_value)/ sum(ref.Output_value))*sum(Out.IC_value)./ sum(ref.IC_value), (sum(ref.IC_value)/sum(ref.Output_value))*( sum(Out.IC_value)./ sum(ref.IC_value)-1)*100]; ["Contribution of Nominal GDP to Nominal Output variation", ref.GDP/ sum(ref.Output_value), ( ref.GDP/ sum(ref.Output_value))*(Out.GDP / sum(ref.GDP)), (ref.GDP/sum(ref.Output_value))*( Out.GDP / ref.GDP -1 )*100]; ["Contribution of Labour income to Nominal Output variation", sum(ref.Labour_income)/sum(ref.Output_value), (sum(ref.Labour_income)/sum(ref.Output_value))*sum(Out.Labour_income)./ sum(ref.Labour_income), (sum(ref.Labour_income)/sum(ref.Output_value))*( sum(Out.Labour_income)./ sum(ref.Labour_income)-1)*100]; ["Contribution of Labour tax to Nominal Output variation", sum(ref.Labour_Tax)/sum(ref.Output_value), (sum(ref.Labour_Tax)/sum(ref.Output_value))*sum(Out.Labour_Tax)./ sum(ref.Labour_Tax), (sum(ref.Labour_Tax)/sum(ref.Output_value))*( sum(Out.Labour_Tax)./ sum(ref.Labour_Tax)-1)*100]; ["Contribution of Production taxes to Nominal Output variation", divide(sum(ref.Production_Tax),sum(ref.Output_value),%nan), (sum(ref.Production_Tax)/sum(ref.Output_value))*(divide(sum(Out.Production_Tax),sum(ref.Production_Tax),%nan)), (sum(ref.Production_Tax)/sum(ref.Output_value))*( divide(sum(Out.Production_Tax), sum(ref.Production_Tax),%nan)-1)*100]; ["Contribution of Consumption Taxes to Nominal Output variation", (sum(ref.Taxes)+sum(ref.Carbon_Tax)) / sum(ref.Output_value), ( (sum(ref.Taxes)+sum(ref.Carbon_Tax))/sum(ref.Output_value))*(sum(Out.Taxes)+sum(Out.Carbon_Tax))./ (sum(ref.Taxes)+sum(ref.Carbon_Tax)), ( (sum(ref.Taxes)+sum(ref.Carbon_Tax))/sum(ref.Output_value))*((sum(Out.Taxes)+sum(Out.Carbon_Tax))./ (sum(ref.Taxes)+sum(ref.Carbon_Tax))-1)*100]; ["Contribution of Capital income to Nominal Output variation", sum(ref.Capital_income) / sum(ref.Output_value), (sum(ref.Capital_income)/sum(ref.Output_value))*sum(Out.Capital_income)./ sum(ref.Capital_income), (sum(ref.Capital_income)/sum(ref.Output_value))*( sum(Out.Capital_income)./ sum(ref.Capital_income)-1)*100]; ["Contribution of Margins to Nominal Output variation", sum(ref.TotMargins)/sum(ref.Output_value), (sum(ref.TotMargins)/sum(ref.Output_value))*sum(Out.TotMargins)./ sum(ref.TotMargins), (sum(ref.TotMargins)/sum(ref.Output_value))*( sum(Out.TotMargins)./ sum(ref.TotMargins)-1)*100]];

evol_ref.MacroT2 = [["Variable", "Indice 0", "Indice 1", "% variation"]; ["Contribution of Corporations disposable income to Nominal Output variation", sum(ref.Disposable_Income(Indice_Corporations))/  sum(ref.Output_value), (sum(ref.Disposable_Income(Indice_Corporations))/sum(ref.Output_value))*sum(Out.Disposable_Income(Indice_Corporations))./ sum(ref.Disposable_Income(Indice_Corporations)), (sum(ref.Disposable_Income(Indice_Corporations))/sum(ref.Output_value))*( sum(Out.Disposable_Income(Indice_Corporations))./ sum(ref.Disposable_Income(Indice_Corporations))-1)*100]; ["Contribution of Households disposable income to Nominal Output variation", sum(ref.Disposable_Income(Indice_Households))/sum(ref.Output_value), (sum(ref.Disposable_Income(Indice_Households))/sum(ref.Output_value))*sum(Out.Disposable_Income(Indice_Households))./ sum(ref.Disposable_Income(Indice_Households)), (sum(ref.Disposable_Income(Indice_Households))/sum(ref.Output_value))*( sum(Out.Disposable_Income(Indice_Households))./ sum(ref.Disposable_Income(Indice_Households))-1)*100]; ["Contribution of Government disposable income to Nominal Output variation", sum(ref.Disposable_Income(Indice_Government))/sum(ref.Output_value), (sum(ref.Disposable_Income(Indice_Government))/sum(ref.Output_value))*sum(Out.Disposable_Income(Indice_Government))./ sum(ref.Disposable_Income(Indice_Government)), (sum(ref.Disposable_Income(Indice_Government))/sum(ref.Output_value))*( sum(Out.Disposable_Income(Indice_Government))./ sum(ref.Disposable_Income(Indice_Government))-1)*100]; ["Contribution of Income transfers to the Rest-of-the-world to Nominal Output variation", (ref.Property_income(Indice_RestOfWorld) + ref.Other_Transfers(Indice_RestOfWorld))/sum(ref.Output_value), ((ref.Property_income(Indice_RestOfWorld) + ref.Other_Transfers(Indice_RestOfWorld))/sum(ref.Output_value))*(Out.Property_income(Indice_RestOfWorld) + Out.Other_Transfers(Indice_RestOfWorld))./ (ref.Property_income(Indice_RestOfWorld) + ref.Other_Transfers(Indice_RestOfWorld)), ((ref.Property_income(Indice_RestOfWorld) + ref.Other_Transfers(Indice_RestOfWorld))/sum(ref.Output_value))*( (Out.Property_income(Indice_RestOfWorld) + Out.Other_Transfers(Indice_RestOfWorld))./ (ref.Property_income(Indice_RestOfWorld) + ref.Other_Transfers(Indice_RestOfWorld)) -1 )*100]; ["Contribution of Domestic demand to Nominal Output variation", (sum(ref.pC.*ref.C)+sum(ref.pG.*ref.G)+sum(ref.pI.*ref.I)) / sum(ref.Output_value), ((sum(ref.pC.*ref.C)+sum(ref.pG.*ref.G)+sum(ref.pI.*ref.I)) / sum(ref.Output_value))*(sum(Out.pC.*Out.C)+sum(Out.pG.*Out.G)+sum(Out.pI.*Out.I))./(sum(ref.pC.*ref.C)+sum(ref.pG.*ref.G)+sum(ref.pI.*ref.I)), ((sum(ref.pC.*ref.C)+sum(ref.pG.*ref.G)+sum(ref.pI.*ref.I)) / sum(ref.Output_value))*((sum(Out.pC.*Out.C)+sum(Out.pG.*Out.G)+sum(Out.pI.*Out.I))./(sum(ref.pC.*ref.C)+sum(ref.pG.*ref.G)+sum(ref.pI.*ref.I))-1)*100]; ["Contribution of capital flows to Nominal Output variation", -ref.Ecotable(Indice_NetLending, Indice_RestOfWorld)/ sum(ref.Output_value), (-ref.Ecotable(Indice_NetLending, Indice_RestOfWorld)/ sum(ref.Output_value))*(Out.Ecotable(Indice_NetLending, Indice_RestOfWorld)./ref.Ecotable(Indice_NetLending, Indice_RestOfWorld)), (-ref.Ecotable(Indice_NetLending, Indice_RestOfWorld)/ sum(ref.Output_value))*(Out.Ecotable(Indice_NetLending, Indice_RestOfWorld)./ref.Ecotable(Indice_NetLending, Indice_RestOfWorld)-1)*100]];

evol_ref.MacroT3 = [["Variable", "Indice 0", "Indice 1", "% variation"]; ["Contribution of Households consumption to Nominal Output variation", sum(ref.C_value)/sum(ref.Output_value), (sum(ref.C_value)/sum(ref.Output_value))*sum(Out.C_value)./ sum(ref.C_value), (sum(ref.C_value)/sum(ref.Output_value))*( sum(Out.C_value)./ sum(ref.C_value)-1)*100]; ["Contribution of Public consumption to Nominal Output variation", sum(ref.G_value) / sum(ref.Output_value), (sum(ref.G_value) / sum(ref.Output_value))*sum(Out.G_value)./ sum(ref.G_value), (sum(ref.G_value)/sum(ref.Output_value))*( sum(Out.G_value)./ sum(ref.G_value)-1)*100]; ["Contribution of Investment to Nominal Output variation", sum(ref.I_value) / sum(ref.Output_value), (sum(ref.I_value) / sum(ref.Output_value))*sum(Out.I_value)./ sum(ref.I_value), (sum(ref.I_value)/sum(ref.Output_value))*( sum(Out.I_value)./ sum(ref.I_value)-1)*100]; ["Contribution of Exports to Nominal Output variation", sum(ref.X_value)/ sum(ref.Output_value), (sum(ref.X_value)/sum(ref.Output_value))*sum(Out.X_value)./ sum(ref.X_value), (sum(ref.X_value)/sum(ref.Output_value))*( sum(Out.X_value)./ sum(ref.X_value)-1)*100]; ["Contribution of Imports to Nominal Output variation", sum(-ref.M_value)/sum(ref.Output_value), (sum(-ref.M_value)/sum(ref.Output_value))*sum(-Out.M_value)./ sum(-ref.M_value), (sum(-ref.M_value)/sum(ref.Output_value))*( sum(-Out.M_value)./ sum(-ref.M_value)-1)*100]];

evol_ref.MacroT4 = [["Variable", "Indice 0", "Indice 1", "% variation"]; ["Contribution of Intermediate consumption to Real Output variation", ref.IC_output_ValueShare, ref.IC_output_ValueShare*IC_qLasp, "nan"]; ["Contribution of GDP to Real Output variation", ref.GDP_output_ValueShare, ref.GDP_output_ValueShare*GDP_qLasp, "nan"]; ["Contribution of Households consumption to real Output variation", ref.C_Output_ValueShare, ref.C_Output_ValueShare*C_qLasp, "nan"]; ["Contribution of Public consumption to real Output variation", ref.G_Output_ValueShare, ref.G_Output_ValueShare*G_qLasp, "nan"]; ["Contribution of Investment to real Output variation", ref.I_Output_ValueShare, ref.I_Output_ValueShare*I_qLasp, "nan"]; ["Contribution of Exports to real Output variation", ref.X_Output_ValueShare, ref.X_Output_ValueShare*X_qLasp, "nan"]; ["Contribution of Imports to real Output variation", ref.M_Output_ValueShare, ref.M_Output_ValueShare*M_qLasp, "nan"]];

evol_ref.MacroT5 = [["Variable", "Indice 0", "Indice 1", "% variation"]; ["Contribution of Labour income to Real Output variation", sum(ref.Labour_income) / sum(ref.Output_value), (sum(ref.Labour_income)/ sum(ref.Output_value))*(sum(Out.Labour_income)./ sum(ref.Labour_income))/GDP_pPaas, "nan"]; ["Contribution of Labour tax to Real Output variation", sum(ref.Labour_Tax) / sum(ref.Output_value), (sum(ref.Labour_Tax) / sum(ref.Output_value))*(sum(Out.Labour_Tax)./ sum(ref.Labour_Tax))/GDP_pPaas, "nan"]; ["Contribution of Production taxes to Real Output variation", sum(ref.Production_Tax) / sum(ref.Output_value), (sum(ref.Production_Tax) / sum(ref.Output_value))*(divide(sum(Out.Production_Tax),sum(ref.Production_Tax),%nan))/GDP_pPaas, "nan"]; ["Contribution of Consumption Taxes to Real Output variation", (sum(ref.Taxes)+sum(ref.Carbon_Tax))/ sum(ref.Output_value), ((sum(ref.Taxes)+sum(ref.Carbon_Tax)) / sum(ref.Output_value))*((sum(Out.Taxes)+sum(Out.Carbon_Tax))./ (sum(ref.Taxes)+sum(ref.Carbon_Tax)))/GDP_pPaas, "nan"]; ["Contribution of Capital income to Real Output variation", sum(ref.Capital_income) / sum(ref.Output_value), (sum(ref.Capital_income) / sum(ref.Output_value))*(sum(Out.Capital_income)./ sum(ref.Capital_income))/GDP_pPaas, "nan"]; ["Contribution of Margins to Real Output variation", sum(ref.TotMargins) / sum(ref.Output_value), (sum(ref.TotMargins) / sum(ref.Output_value))*(sum(Out.TotMargins)./ sum(ref.TotMargins))/GDP_pPaas, "nan"]; ["GDP price index", "1", GDP_pPaas, (GDP_pPaas-1)*100]];

evol_ref.MacroT6 = [["Variable", "Indice 0", "Indice 1", "% variation"]; ["Production Price (Paashes)", "1", Y_pPaas, (Y_pPaas-1)*100]; ["Intermediate Consumption Price (Paashes)", "1", IC_pPaas, (IC_pPaas-1)*100]; ["Households Consumption Price (Paashes)", "1", C_pPaas, (C_pPaas-1)*100]; ["Public Consumption Price (Paashes)", "1", G_pPaas, (G_pPaas-1)*100]; ["Investment Price (Paashes)", "1", I_pPaas, (I_pPaas-1)*100]; ["Exports Price (Paashes)", "1", X_pPaas, (X_pPaas-1)*100]; ["Imports Price (Paashes)", "1", M_pPaas, (M_pPaas-1)*100]];

//	Sector Disaggregation (Primary Energy, Final Energy, Non Energy Products)

evol_ref.MacroT7 = [["Variable", "Indice 0", "Indice 1", "% variation"]; ["Nominal Output Primary Energy", sum(ref.Output_value(Indice_PrimEnerSect))./ sum(ref.Output_value), sum(Out.Output_value(Indice_PrimEnerSect))./ sum(ref.Output_value), 100*(sum(Out.Output_value(Indice_PrimEnerSect))- sum(ref.Output_value(Indice_PrimEnerSect)))./ sum(ref.Output_value)] ; ["Nominal Output Final Energy ", sum(ref.Output_value(Indice_FinEnerSect))./ sum(ref.Output_value), sum(Out.Output_value(Indice_FinEnerSect))./ sum(ref.Output_value), 100*(sum(Out.Output_value(Indice_FinEnerSect))- sum(ref.Output_value(Indice_FinEnerSect)))./ sum(ref.Output_value)] ; ["Nominal Output Non Energy Products", sum(ref.Output_value(Indice_NonEnerSect))./ sum(ref.Output_value), sum(Out.Output_value(Indice_NonEnerSect))./ sum(ref.Output_value), 100*(sum(Out.Output_value(Indice_NonEnerSect))- sum(ref.Output_value(Indice_NonEnerSect)))./ sum(ref.Output_value)] ; ["Output Real Index - Primary Energy", sum(ref.Output_value(Indice_PrimEnerSect))/sum(ref.Output_value), Output_PrimEn_qLasp*sum(ref.Output_value(Indice_PrimEnerSect))/sum(ref.Output_value), "nan"] ; ["Output Real Index - Energy Products", sum(ref.Output_value(Indice_FinEnerSect))/sum(ref.Output_value), Output_FinEn_qLasp*sum(ref.Output_value(Indice_FinEnerSect))/sum(ref.Output_value), "nan"] ; ["Output Real Index - Non Energy Products", sum(ref.Output_value(Indice_NonEnerSect))/sum(ref.Output_value), Output_NonEn_qLasp*sum(ref.Output_value(Indice_NonEnerSect))/sum(ref.Output_value), "nan"] ; ["Output Price Index - Primary Energy", "1", Output_PrimEn_pPaas, (Output_PrimEn_pPaas-1)*100] ; ["Output Price Index - Energy Products", "1", Output_FinEn_pPaas, (Output_FinEn_pPaas-1)*100] ; ["Output Price Index - Non Energy Products", "1", Output_NonEn_pPaas, (Output_NonEn_pPaas-1)*100]]; 

evol_ref.MacroT8 = [["Contribution of Nominal Intermediate consumptions (inputs) of Primary Energy to Nominal Output variation", sum(ref.IC_value(:,Indice_PrimEnerSect)) / sum(ref.Output_value), sum(Out.IC_value(:,Indice_PrimEnerSect))/sum(ref.Output_value), 100*(sum(Out.IC_value(:,Indice_PrimEnerSect))-sum(ref.IC_value(:,Indice_PrimEnerSect)))/sum(ref.Output_value)] ; ["Contribution of Nominal Intermediate consumptions (inputs) of Final Energy to Nominal Output variation", sum(ref.IC_value(:,Indice_FinEnerSect)) / sum(ref.Output_value), sum(Out.IC_value(:,Indice_FinEnerSect))/sum(ref.Output_value), 100*(sum(Out.IC_value(:,Indice_FinEnerSect))-sum(ref.IC_value(:,Indice_FinEnerSect)))/sum(ref.Output_value)]; ["Contribution of Nominal Intermediate consumptions (inputs) of Non Energy Products to Nominal Output variation", sum(ref.IC_value(:,Indice_NonEnerSect)) / sum(ref.Output_value), sum(Out.IC_value(:,Indice_NonEnerSect))/sum(ref.Output_value), 100*(sum(Out.IC_value(:,Indice_NonEnerSect))-sum(ref.IC_value(:,Indice_NonEnerSect)))/sum(ref.Output_value)] ; ["Contribution of the Value Added of Primary Energy to Nominal Output variation", (sum(ref.Output_value(Indice_PrimEnerSect))- sum(ref.IC_value(:,Indice_PrimEnerSect))) / sum(ref.Output_value), (sum(Out.Output_value(Indice_PrimEnerSect))- sum(Out.IC_value(:,Indice_PrimEnerSect)))/ sum(ref.Output_value), 100*((sum(Out.Output_value(Indice_PrimEnerSect))- sum(Out.IC_value(:,Indice_PrimEnerSect)))-(sum(ref.Output_value(Indice_PrimEnerSect))- sum(ref.IC_value(:,Indice_PrimEnerSect))))/ sum(ref.Output_value)] ; ["Contribution of the Value Added of Final Energy to Nominal Output variation", (sum(ref.Output_value(Indice_FinEnerSect))- sum(ref.IC_value(:,Indice_FinEnerSect))) / sum(ref.Output_value), (sum(Out.Output_value(Indice_FinEnerSect))- sum(Out.IC_value(:,Indice_FinEnerSect)))/ sum(ref.Output_value), 100*((sum(Out.Output_value(Indice_FinEnerSect))- sum(Out.IC_value(:,Indice_FinEnerSect)))-(sum(ref.Output_value(Indice_FinEnerSect))- sum(ref.IC_value(:,Indice_FinEnerSect))))/ sum(ref.Output_value)] ; ["Contribution of the Value Added of Non Energy Products to Nominal Output variation", (sum(ref.Output_value(Indice_NonEnerSect))- sum(ref.IC_value(:,Indice_NonEnerSect))) / sum(ref.Output_value), (sum(Out.Output_value(Indice_NonEnerSect))- sum(Out.IC_value(:,Indice_NonEnerSect)))/ sum(ref.Output_value), 100*((sum(Out.Output_value(Indice_NonEnerSect))- sum(Out.IC_value(:,Indice_NonEnerSect)))-(sum(ref.Output_value(Indice_NonEnerSect))- sum(ref.IC_value(:,Indice_NonEnerSect))))/ sum(ref.Output_value)]];

evol_ref.MacroT9 = [["Variable", "Indice 0", "Indice 1", "% variation"]; ["Contribution of Households consumption of Primary Energy to Nominal Output variation", sum(ref.C_value(Indice_PrimEnerSect,:))/sum(ref.Output_value), sum(Out.C_value(Indice_PrimEnerSect,:))/ sum(ref.Output_value), 100*(sum(Out.C_value(Indice_PrimEnerSect,:))-sum(ref.C_value(Indice_PrimEnerSect,:)))/sum(ref.Output_value)] ; ["Contribution of Households consumption of Final Energy to Nominal Output variation", sum(ref.C_value(Indice_FinEnerSect,:))/sum(ref.Output_value), sum(Out.C_value(Indice_FinEnerSect,:))/ sum(ref.Output_value), 100*(sum(Out.C_value(Indice_FinEnerSect,:))-sum(ref.C_value(Indice_FinEnerSect,:)))/sum(ref.Output_value)] ; ["Contribution of Households consumption of Non Energy Products to Nominal Output variation", sum(ref.C_value(Indice_NonEnerSect,:))/sum(ref.Output_value), sum(Out.C_value(Indice_NonEnerSect,:))/ sum(ref.Output_value), 100*(sum(Out.C_value(Indice_NonEnerSect,:))-sum(ref.C_value(Indice_NonEnerSect,:)))/sum(ref.Output_value)] ; ["Contribution of Public consumption of Primary Energy to Nominal Output variation", sum(ref.G_value(Indice_PrimEnerSect))/sum(ref.Output_value), sum(Out.G_value(Indice_PrimEnerSect))/ sum(ref.Output_value), 100*(sum(Out.G_value(Indice_PrimEnerSect))-sum(ref.G_value(Indice_PrimEnerSect)))/sum(ref.Output_value)] ; ["Contribution of Public Consumption of Final Energy to Nominal Output variation", sum(ref.G_value(Indice_FinEnerSect))/sum(ref.Output_value), sum(Out.G_value(Indice_FinEnerSect))/ sum(ref.Output_value), 100*(sum(Out.G_value(Indice_FinEnerSect))-sum(ref.G_value(Indice_FinEnerSect)))/sum(ref.Output_value)] ; ["Contribution of Public Consumption of Non Energy Products to Nominal Output variation", sum(ref.G_value(Indice_NonEnerSect))/sum(ref.Output_value), sum(Out.G_value(Indice_NonEnerSect))/ sum(ref.Output_value), 100*(sum(Out.G_value(Indice_NonEnerSect))-sum(ref.G_value(Indice_NonEnerSect)))/sum(ref.Output_value)] ; ["Contribution of Investment of Primary Energy to Nominal Output variation", sum(ref.I_value(Indice_PrimEnerSect))/sum(ref.Output_value), sum(Out.I_value(Indice_PrimEnerSect))/ sum(ref.Output_value), 100*(sum(Out.I_value(Indice_PrimEnerSect))-sum(ref.I_value(Indice_PrimEnerSect)))/sum(ref.Output_value)] ; ["Contribution of Investment of Final Energy to Nominal Output variation", sum(ref.I_value(Indice_FinEnerSect))/sum(ref.Output_value), sum(Out.I_value(Indice_FinEnerSect))/ sum(ref.Output_value), 100*(sum(Out.I_value(Indice_FinEnerSect))-sum(ref.I_value(Indice_FinEnerSect)))/sum(ref.Output_value)] ; ["Contribution of Investment of Non Energy Products to Nominal Output variation", sum(ref.I_value(Indice_NonEnerSect))/sum(ref.Output_value), sum(Out.I_value(Indice_NonEnerSect))/ sum(ref.Output_value), 100*(sum(Out.I_value(Indice_NonEnerSect))- sum(ref.I_value(Indice_NonEnerSect)))/sum(ref.Output_value)]];

evol_ref.MacroT10 = [["Contribution of Exports of Primary Energy to Nominal Output variation", sum(ref.X_value(Indice_PrimEnerSect))/sum(ref.Output_value), sum(Out.X_value(Indice_PrimEnerSect))/ sum(ref.Output_value), 100*(sum(Out.X_value(Indice_PrimEnerSect))-sum(ref.X_value(Indice_PrimEnerSect)))/sum(ref.Output_value)] ; ["Contribution of Exports of Final Energy to Nominal Output variation", sum(ref.X_value(Indice_FinEnerSect))/sum(ref.Output_value), sum(Out.X_value(Indice_FinEnerSect))/ sum(ref.Output_value), 100*(sum(Out.X_value(Indice_FinEnerSect))-sum(ref.X_value(Indice_FinEnerSect)))/sum(ref.Output_value)] ; ["Contribution of Exports of Non Energy Products to Nominal Output variation", sum(ref.X_value(Indice_NonEnerSect))/sum(ref.Output_value), sum(Out.X_value(Indice_NonEnerSect))/ sum(ref.Output_value), 100*(sum(Out.X_value(Indice_NonEnerSect))-sum(ref.X_value(Indice_NonEnerSect)))/sum(ref.Output_value)] ; ["Contribution of Imports of Primary Energy to Nominal Output variation", sum(-ref.M_value(Indice_PrimEnerSect))/sum(ref.Output_value), sum(-Out.M_value(Indice_PrimEnerSect))/ sum(ref.Output_value), 100*(sum(ref.M_value(Indice_PrimEnerSect))-sum(Out.M_value(Indice_PrimEnerSect)))/sum(ref.Output_value)] ; ["Contribution of Imports of Final Energy to Nominal Output variation", sum(-ref.M_value(Indice_FinEnerSect))/sum(ref.Output_value), sum(-Out.M_value(Indice_FinEnerSect))/ sum(ref.Output_value), 100*(sum(ref.M_value(Indice_FinEnerSect))-sum(Out.M_value(Indice_FinEnerSect)))/sum(ref.Output_value)] ; ["Contribution of Imports of Non Energy Products to Nominal Output variation", sum(-ref.M_value(Indice_NonEnerSect))/sum(ref.Output_value), sum(-Out.M_value(Indice_NonEnerSect))/ sum(ref.Output_value), 100*(sum(ref.M_value(Indice_NonEnerSect))-sum(Out.M_value(Indice_NonEnerSect)))/sum(ref.Output_value)]] ;

evol_ref.MacroT11 = [["Variable", "Indice 0", "Indice 1", "% variation"] ; ["Contribution of Intermediate consumption (inputs) of Primary Energy to Real Output variation", sum(ref.IC_value(:,Indice_PrimEnerSect))/ sum(ref.Output_value), IC_input_PrimEn_qLasp*sum(ref.IC_value(:,Indice_PrimEnerSect))/ sum(ref.Output_value), "nan"]; ["Contribution of Intermediate consumption (inputs) of Final Energy to Real Output variation", sum(ref.IC_value(:,Indice_FinEnerSect))/ sum(ref.Output_value), IC_input_FinEn_qLasp*sum(ref.IC_value(:,Indice_FinEnerSect))/ sum(ref.Output_value), "nan"] ; ["Contribution of Intermediate consumption (inputs) of Non Energy Products to Real Output variation", sum(ref.IC_value(:,Indice_NonEnerSect))/ sum(ref.Output_value), IC_input_NonEn_qLasp*sum(ref.IC_value(:,Indice_NonEnerSect))/ sum(ref.Output_value), "nan"] ; ["Contribution of Intermediate consumption (uses) of Primary Energy to Real Output variation", sum(ref.IC_value(Indice_PrimEnerSect,:))/ sum(ref.Output_value), IC_uses_PrimEn_qLasp*sum(ref.IC_value(Indice_PrimEnerSect,:))/ sum(ref.Output_value), "nan"]; ["Contribution of Intermediate consumption (uses) of Final Energy to Real Output variation", sum(ref.IC_value(Indice_FinEnerSect,:))/ sum(ref.Output_value), IC_uses_FinEn_qLasp*sum(ref.IC_value(Indice_FinEnerSect,:))/ sum(ref.Output_value), "nan"] ; ["Contribution of Intermediate consumption (uses) of Non Energy Products to Real Output variation", sum(ref.IC_value(Indice_NonEnerSect,:))/ sum(ref.Output_value), IC_uses_NonEn_qLasp*sum(ref.IC_value(Indice_NonEnerSect,:))/ sum(ref.Output_value), "nan"]];

evol_ref.MacroT12 = [["Contribution of Households consumption of Primary Energy to real Output variation", sum(ref.C_value(Indice_PrimEnerSect,:))/ sum(ref.Output_value), C_PrimEn_qLasp*sum(ref.C_value(Indice_PrimEnerSect,:))/ sum(ref.Output_value), "nan"]; ["Contribution of Households consumption of Final Energy to real Output variation", sum(ref.C_value(Indice_FinEnerSect,:))/ sum(ref.Output_value), C_FinEn_qLasp*sum(ref.C_value(Indice_FinEnerSect,:))/ sum(ref.Output_value), "nan"] ; ["Contribution of Households consumption of Non Energy Products to real Output variation", sum(ref.C_value(Indice_NonEnerSect,:))/ sum(ref.Output_value), C_NonEn_qLasp*sum(ref.C_value(Indice_NonEnerSect,:))/ sum(ref.Output_value), "nan"] ; ["Contribution of Public consumption of Primary Energy to real Output variation", sum(ref.G_value(Indice_PrimEnerSect))/ sum(ref.Output_value), G_PrimEn_qLasp*sum(ref.G_value(Indice_PrimEnerSect))/ sum(ref.Output_value), "nan"]; ["Contribution of Public Consumption of Final Energy to real Output variation", sum(ref.G_value(Indice_FinEnerSect))/ sum(ref.Output_value), G_FinEn_qLasp*sum(ref.G_value(Indice_FinEnerSect))/ sum(ref.Output_value), "nan"] ; ["Contribution of Public Consumption of Non Energy Products to real Output variation", sum(ref.G_value(Indice_NonEnerSect))/ sum(ref.Output_value), G_NonEn_qLasp*sum(ref.G_value(Indice_NonEnerSect))/ sum(ref.Output_value), "nan"] ; ["Contribution of Investment of Non Energy Products to real Output variation", sum(ref.I_value(Indice_NonEnerSect))/ sum(ref.Output_value), I_NonEn_qLasp*sum(ref.I_value(Indice_NonEnerSect))/ sum(ref.Output_value), "nan"] ; ["Contribution of Exports of Primary Energy to real Output variation", sum(ref.X_value(Indice_PrimEnerSect))/ sum(ref.Output_value), X_PrimEn_qLasp*sum(ref.X_value(Indice_PrimEnerSect))/ sum(ref.Output_value), "nan"]; ["Contribution of Exports of Final Energy to real Output variation", sum(ref.X_value(Indice_FinEnerSect))/ sum(ref.Output_value), X_FinEn_qLasp*sum(ref.X_value(Indice_FinEnerSect))/ sum(ref.Output_value), "nan"] ; ["Contribution of Exports of Non Energy Products to real Output variation", sum(ref.X_value(Indice_NonEnerSect))/ sum(ref.Output_value), X_NonEn_qLasp*sum(ref.X_value(Indice_NonEnerSect))/ sum(ref.Output_value), "nan"] ; ["Contribution of Imports of Primary Energy to real Output variation", sum(-ref.M_value(Indice_PrimEnerSect))/ sum(ref.Output_value), M_PrimEn_qLasp*sum(-ref.M_value(Indice_PrimEnerSect))/ sum(ref.Output_value), "nan"]; ["Contribution of Imports of Final Energy to real Output variation", sum(-ref.M_value(Indice_FinEnerSect))/ sum(ref.Output_value), M_FinEn_qLasp*sum(-ref.M_value(Indice_FinEnerSect))/ sum(ref.Output_value), "nan"] ; ["Contribution of Imports of Non Energy Products to real Output variation", sum(-ref.M_value(Indice_NonEnerSect))/ sum(ref.Output_value), M_NonEn_qLasp*sum(-ref.M_value(Indice_NonEnerSect))/ sum(ref.Output_value), "nan"]];

evol_ref.MacroT13 = [["Variable", "Indice 0", "Indice 1", "% variation"]; ["Total Energy", (sum(ref.Y(Indice_EnerSect))+sum(ref.M(Indice_EnerSect)))/(sum(ref.Y(Indice_EnerSect))+sum(ref.M(Indice_EnerSect))), (sum(Out.Y(Indice_EnerSect))+sum(Out.M(Indice_EnerSect)))/(sum(ref.Y(Indice_EnerSect))+sum(ref.M(Indice_EnerSect))), ((sum(Out.Y(Indice_EnerSect))+sum(Out.M(Indice_EnerSect)))/(sum(ref.Y(Indice_EnerSect))+sum(ref.M(Indice_EnerSect)))-1)*100]; ["Domestic production Primary Energy (Crude Oil, Gas, Coal)", sum(ref.Y(Indice_PrimEnerSect)) / (sum(ref.Y(Indice_EnerSect))+sum(ref.M(Indice_EnerSect))), sum(Out.Y(Indice_PrimEnerSect)) / (sum(ref.Y(Indice_EnerSect))+sum(ref.M(Indice_EnerSect))), (sum(Out.Y(Indice_PrimEnerSect)) - sum(ref.Y(Indice_PrimEnerSect)))/ (sum(ref.Y(Indice_EnerSect))+sum(ref.M(Indice_EnerSect)))*100]; ["Imports Primary Energy (Crude Oil, Gas, Coal)", sum(ref.M(Indice_PrimEnerSect)) / (sum(ref.Y(Indice_EnerSect))+sum(ref.M(Indice_EnerSect))), sum(Out.M(Indice_PrimEnerSect)) / (sum(ref.Y(Indice_EnerSect))+sum(ref.M(Indice_EnerSect))), (sum(Out.M(Indice_PrimEnerSect))- sum(ref.M(Indice_PrimEnerSect)))/ (sum(ref.Y(Indice_EnerSect))+sum(ref.M(Indice_EnerSect)))*100]; ["Exports Primary Energy (Crude Oil, Gas, Coal)", sum(ref.X(Indice_PrimEnerSect)) / (sum(ref.Y(Indice_EnerSect))+sum(ref.M(Indice_EnerSect))), sum(Out.X(Indice_PrimEnerSect)) / (sum(ref.Y(Indice_EnerSect))+sum(ref.M(Indice_EnerSect))), (sum(Out.X(Indice_PrimEnerSect))- sum(ref.X(Indice_PrimEnerSect)))/ (sum(ref.Y(Indice_EnerSect))+sum(ref.M(Indice_EnerSect)))*100]; ["Domestic production Final Energy", sum(ref.Y(Indice_FinEnerSect)) / (sum(ref.Y(Indice_EnerSect))+sum(ref.M(Indice_EnerSect))), sum(Out.Y(Indice_FinEnerSect)) / (sum(ref.Y(Indice_EnerSect))+sum(ref.M(Indice_EnerSect))), (sum(Out.Y(Indice_FinEnerSect))- sum(ref.Y(Indice_FinEnerSect)))/ (sum(ref.Y(Indice_EnerSect))+sum(ref.M(Indice_EnerSect)))*100]; ["Imports Final Energy", sum(ref.M(Indice_FinEnerSect)) / (sum(ref.Y(Indice_EnerSect))+sum(ref.M(Indice_EnerSect))), sum(Out.M(Indice_FinEnerSect)) / (sum(ref.Y(Indice_EnerSect))+sum(ref.M(Indice_EnerSect))), (sum(Out.M(Indice_FinEnerSect))- sum(ref.M(Indice_FinEnerSect)))/ (sum(ref.Y(Indice_EnerSect))+sum(ref.M(Indice_EnerSect)))*100]; ["Exports Final Energy", sum(ref.X(Indice_FinEnerSect)) / (sum(ref.Y(Indice_EnerSect))+sum(ref.M(Indice_EnerSect))), sum(Out.X(Indice_FinEnerSect)) / (sum(ref.Y(Indice_EnerSect))+sum(ref.M(Indice_EnerSect))), (sum(Out.X(Indice_FinEnerSect))- sum(ref.X(Indice_FinEnerSect)))/ (sum(ref.Y(Indice_EnerSect))+sum(ref.M(Indice_EnerSect)))*100]; ["Intermediate Energy Consumptions", sum(ref.IC(Indice_EnerSect,:)) / (sum(ref.Y(Indice_EnerSect))+sum(ref.M(Indice_EnerSect))), sum(Out.IC(Indice_EnerSect,:)) / (sum(ref.Y(Indice_EnerSect))+sum(ref.M(Indice_EnerSect))), (sum(Out.IC(Indice_EnerSect,:))- sum(ref.IC(Indice_EnerSect,:)))/ (sum(ref.Y(Indice_EnerSect))+sum(ref.M(Indice_EnerSect)))*100]; ["Final Energy Consumptions", sum(ref.C(Indice_EnerSect,:)) / (sum(ref.Y(Indice_EnerSect))+sum(ref.M(Indice_EnerSect))), sum(Out.C(Indice_EnerSect,:)) / (sum(ref.Y(Indice_EnerSect))+sum(ref.M(Indice_EnerSect))), (sum(Out.C(Indice_EnerSect,:))- sum(ref.C(Indice_EnerSect,:)))/ (sum(ref.Y(Indice_EnerSect))+sum(ref.M(Indice_EnerSect)))*100]] ;

evol_ref.MacroT14 = [["Production Price Primary Energy (Crude Oil, Gas, Coal)", "1", Y_PrimEn_pPaas, (Y_PrimEn_pPaas-1)*100]; ["Production Price Final Energy", "1", Y_FinEn_pPaas, (Y_FinEn_pPaas-1)*100]; ["Production Price Non Energy Products", "1", Y_NonEn_pPaas, (Y_NonEn_pPaas-1)*100] ; ["Imports Price for Primary Energy (Crude Oil, Gas, Coal)", "1", M_PrimEn_pPaas, (M_PrimEn_pPaas-1)*100]; ["Exports Price for Primary Energy (Crude Oil, Gas, Coal)", "1", X_PrimEn_pPaas, (X_PrimEn_pPaas-1)*100]; ["Imports Price for Final Energy", "1", M_FinEn_pPaas, (M_FinEn_pPaas-1)*100]; ["Exports Price for Final Energy", "1", X_FinEn_pPaas, (X_FinEn_pPaas-1)*100]; ["Imports Price for Non Energy Products", "1", M_NonEn_pPaas, (M_NonEn_pPaas-1)*100]; ["Exports Price for Non Energy Products", "1", X_NonEn_pPaas, (X_NonEn_pPaas-1)*100] ; ["Primary Energy Consumption Price (Paashes)", "1", C_PrimEn_pPaas, (C_PrimEn_pPaas-1)*100]; ["Final Energy Consumption Price (Paashes)", "1", C_FinEn_pPaas, (C_FinEn_pPaas-1)*100] ; ["Non Energy Products Consumption Price (Paashes)", "1", C_NonEn_pPaas, (C_NonEn_pPaas-1)*100] ; ["Primary Energy Public Consumption Price (Paashes)", "1", G_PrimEn_pPaas, (G_PrimEn_pPaas-1)*100]; ["Final Energy Public Consumption Price (Paashes)", "1", G_FinEn_pPaas, (G_FinEn_pPaas-1)*100] ; ["Non Energy Products Public Consumption Price (Paashes)", "1", G_NonEn_pPaas, (G_NonEn_pPaas-1)*100] ; ["Non Energy Products Investment Price (Paashes)", "1", I_NonEn_pPaas, (I_NonEn_pPaas-1)*100] ; ["Intermediate Primary Energy Consumption Price (Paashes)", "1", IC_PrimEn_pPaas, (IC_PrimEn_pPaas-1)*100]; ["Intermediate Final Energy Consumption Price (Paashes)", "1", IC_FinEn_pPaas, (IC_FinEn_pPaas-1)*100] ; ["Intermediate Non Energy Products Consumption Price (Paashes)", "1", IC_NonEn_pPaas, (IC_NonEn_pPaas-1)*100] ; ["Nominal Investment in the Energy Sector", "1", sum(Out.Betta * sum(Out.kappa(Indice_EnerSect).*Out.Y(Indice_EnerSect)').*Out.pI)/sum(ref.Betta * sum(ref.kappa(Indice_EnerSect).*ref.Y(Indice_EnerSect)').*ref.pI), (sum(Out.Betta * sum(Out.kappa(Indice_EnerSect).*Out.Y(Indice_EnerSect)').*Out.pI)/sum(ref.Betta * sum(ref.kappa(Indice_EnerSect).*ref.Y(Indice_EnerSect)').*ref.pI)-1)*100]; ["Investment share in the Energy Sector", "1", (sum(Out.Betta * sum(Out.kappa(Indice_EnerSect).*Out.Y(Indice_EnerSect)').*Out.pI) / sum(Out.Betta * sum(Out.kappa.*Out.Y').*Out.pI))/(sum(ref.Betta * sum(ref.kappa(Indice_EnerSect).*ref.Y(Indice_EnerSect)').*ref.pI) / sum(ref.Betta * sum(ref.kappa.*ref.Y').*ref.pI)), ((sum(Out.Betta * sum(Out.kappa(Indice_EnerSect).*Out.Y(Indice_EnerSect)').*Out.pI) / sum(Out.Betta * sum(Out.kappa.*Out.Y').*Out.pI))/(sum(ref.Betta * sum(ref.kappa(Indice_EnerSect).*ref.Y(Indice_EnerSect)').*ref.pI) / sum(ref.Betta * sum(ref.kappa.*ref.Y').*ref.pI))-1)*100]];

// Simulated Values

// Aggregated 
evol_ref.MacroT15 = [["Variable", "Value 0", "Value 1", "Unit"]; ["Total Output", sum(ref.Output_value)/10^6, sum(Out.Output_value)/10^6, "billion"+money]; ["Total Intermediate Consumptions", sum(ref.IC_value)/10^6, sum(Out.IC_value)/10^6, "billion"+money]; ["Total Value-Added (GDP)", sum(ref.GDP)/10^6, sum(Out.GDP)/10^6, "billion"+money]; ["Total Labour Income", sum(ref.Labour_income)/10^6, sum(Out.Labour_income)/10^6, "billion"+money]; ["Total Labour Tax", sum(ref.Labour_Tax)/10^6, sum(Out.Labour_Tax)/10^6, "billion"+money]; ["Total Production Tax", sum(ref.Production_Tax)/10^6, sum(Out.Production_Tax)/10^6, "billion"+money]; ["Total Consumption Tax", (sum(ref.Taxes)+sum(ref.Carbon_Tax))/10^6, (sum(Out.Taxes)+sum(Out.Carbon_Tax))/10^6, "billion"+money]; ["Total Capital income", sum(ref.Capital_income)/10^6, sum(Out.Capital_income)/10^6, "billion"+money]; ["Total Margins", sum(ref.TotMargins)/10^6, sum(Out.TotMargins)/10^6, "billion"+money]; ["Total Private Consumption", sum(ref.C_value)/10^6, sum(Out.C_value)/10^6, "billion"+money]; ["Total Public Consumption", sum(ref.G_value)/10^6, sum(Out.G_value)/10^6, "billion"+money]; ["Total Gross fixed Capital Formation", sum(ref.I_value)/10^6, sum(Out.I_value)/10^6, "billion"+money]; ["Total Exports", sum(ref.X_value)/10^6, sum(Out.X_value)/10^6, "billion"+money]; ["Total Imports", -sum(ref.M_value)/10^6, -sum(Out.M_value)/10^6, "billion"+money]; ["Net Income Transfers to the rest-of-the-world", ref.Property_income(Indice_RestOfWorld)/10^6 + ref.Other_Transfers(Indice_RestOfWorld)/10^6, Out.Property_income(Indice_RestOfWorld)/10^6 + Out.Other_Transfers(Indice_RestOfWorld)/10^6, "billion"+money]; ["Corporations Disposable Income", sum(ref.Disposable_Income(Indice_Corporations))/10^6, sum(Out.Disposable_Income(Indice_Corporations))/10^6, "billion"+money]; ["Private Disposable Income", sum(ref.Disposable_Income(Indice_Households))/10^6, sum(Out.Disposable_Income(Indice_Households))/10^6, "billion"+money]; ["Public Disposable Income", sum(ref.Disposable_Income(Indice_Government))/10^6, sum(Out.Disposable_Income(Indice_Government))/10^6, "billion"+money]; ["Domestic Demand",  (sum(ref.C_value)+sum(ref.G_value)+sum(ref.I_value))/10^6, (sum(Out.C_value)+sum(Out.G_value)+sum(Out.I_value))/10^6, "billion"+money]; ["Capital Flows",  -ref.Ecotable(Indice_NetLending, Indice_RestOfWorld)/10^6, -Out.Ecotable(Indice_NetLending, Indice_RestOfWorld)/10^6, "billion"+money] ];

// Primary Energies
evol_ref.MacroT16 = [["Variable", "Value 0", "Value 1", "Unit"]; ["Primary Energies - Output", sum(ref.Output_value(Indice_PrimEnerSect))/10^6, sum(Out.Output_value(Indice_PrimEnerSect))/10^6, "billion"+money]; ["Primary Energies - Intermediate Consumptions (Inputs)", sum(ref.IC_value(:, Indice_PrimEnerSect))/10^6, sum(Out.IC_value(:, Indice_PrimEnerSect))/10^6, "billion"+money]; ["Primary Energies - Intermediate Consumptions (Outputs)", sum(ref.IC_value(Indice_PrimEnerSect,:))/10^6, sum(Out.IC_value(Indice_PrimEnerSect,:))/10^6, "billion"+money]; ["Primary Energies - Value-Added", sum(ref.Output_value(Indice_PrimEnerSect))/10^6- sum(ref.IC_value(:,Indice_PrimEnerSect))/10^6, sum(Out.Output_value(Indice_PrimEnerSect))/10^6- sum(Out.IC_value(:,Indice_PrimEnerSect))/10^6, "billion"+money]; ["Primary Energies - Labour Income", sum(ref.Labour_income(Indice_PrimEnerSect))/10^6, sum(Out.Labour_income(Indice_PrimEnerSect))/10^6, "billion"+money]; ["Primary Energies - Labour Tax", sum(ref.Labour_Tax(Indice_PrimEnerSect))/10^6, sum(Out.Labour_Tax(Indice_PrimEnerSect))/10^6, "billion"+money]; ["Primary Energies - Production Tax", sum(ref.Production_Tax(Indice_PrimEnerSect))/10^6, sum(Out.Production_Tax(Indice_PrimEnerSect))/10^6, "billion"+money]; ["Primary Energies - Consumption Tax", sum(ref.Taxes(:,Indice_PrimEnerSect))/10^6+sum(ref.Carbon_Tax(:,Indice_PrimEnerSect))/10^6, sum(Out.Taxes(:,Indice_PrimEnerSect))/10^6+sum(Out.Carbon_Tax(:,Indice_PrimEnerSect))/10^6, "billion"+money]; ["Primary Energies - Capital income", sum(ref.Capital_income(Indice_PrimEnerSect))/10^6, sum(Out.Capital_income(Indice_PrimEnerSect))/10^6, "billion"+money]; ["Primary Energies - Margins", sum(ref.TotMargins(Indice_PrimEnerSect))/10^6, sum(Out.TotMargins(Indice_PrimEnerSect))/10^6, "billion"+money]; ["Primary Energies - Private Consumption", sum(ref.C_value(Indice_PrimEnerSect))/10^6, sum(Out.C_value(Indice_PrimEnerSect))/10^6, "billion"+money]; ["Primary Energies - Public Consumption", sum(ref.G_value(Indice_PrimEnerSect))/10^6, sum(Out.G_value(Indice_PrimEnerSect))/10^6, "billion"+money]; ["Primary Energies - Gross fixed Capital Formation", sum(ref.I_value(Indice_PrimEnerSect))/10^6, sum(Out.I_value(Indice_PrimEnerSect))/10^6, "billion"+money]; ["Primary Energies - Exports", sum(ref.X_value(Indice_PrimEnerSect))/10^6, sum(Out.X_value(Indice_PrimEnerSect))/10^6, "billion"+money]; ["Primary Energies - Imports", -sum(ref.M_value(Indice_PrimEnerSect))/10^6, -sum(Out.M_value(Indice_PrimEnerSect))/10^6, "billion"+money] ];

// Final Energies
evol_ref.MacroT17 = [["Variable", "Value 0", "Value 1", "Unit"]; ["Final Energies - Output", sum(ref.Output_value(Indice_FinEnerSect))/10^6, sum(Out.Output_value(Indice_FinEnerSect))/10^6, "billion"+money]; ["Final Energies - Intermediate Consumptions (Inputs)", sum(ref.IC_value(:, Indice_FinEnerSect))/10^6, sum(Out.IC_value(:, Indice_FinEnerSect))/10^6, "billion"+money]; ["Final Energies - Intermediate Consumptions (Outputs)", sum(ref.IC_value(Indice_FinEnerSect,:))/10^6, sum(Out.IC_value(Indice_FinEnerSect,:))/10^6, "billion"+money]; ["Final Energies - Value-Added", sum(ref.Output_value(Indice_FinEnerSect))/10^6 - sum(ref.IC_value(:,Indice_FinEnerSect))/10^6, sum(Out.Output_value(Indice_FinEnerSect))/10^6 - sum(Out.IC_value(:,Indice_FinEnerSect))/10^6, "billion"+money]; ["Final Energies - Labour Income", sum(ref.Labour_income(Indice_FinEnerSect))/10^6, sum(Out.Labour_income(Indice_FinEnerSect))/10^6, "billion"+money]; ["Final Energies - Labour Tax", sum(ref.Labour_Tax(Indice_FinEnerSect))/10^6, sum(Out.Labour_Tax(Indice_FinEnerSect))/10^6, "billion"+money]; ["Final Energies - Production Tax", sum(ref.Production_Tax(Indice_FinEnerSect)/10^6), sum(Out.Production_Tax(Indice_FinEnerSect))/10^6, "billion"+money]; ["Final Energies - Consumption Tax", sum(ref.Taxes(:,Indice_FinEnerSect))/10^6 + sum(ref.Carbon_Tax(:,Indice_FinEnerSect))/10^6, sum(Out.Taxes(:,Indice_FinEnerSect))/10^6 + sum(Out.Carbon_Tax(:,Indice_FinEnerSect))/10^6, "billion"+money]; ["Final Energies - Capital income", sum(ref.Capital_income(Indice_FinEnerSect))/10^6, sum(Out.Capital_income(Indice_FinEnerSect))/10^6, "billion"+money]; ["Final Energies - Margins", sum(ref.TotMargins(Indice_FinEnerSect))/10^6, sum(Out.TotMargins(Indice_FinEnerSect))/10^6, "billion"+money]; ["Final Energies - Private Consumption", sum(ref.C_value(Indice_FinEnerSect))/10^6, sum(Out.C_value(Indice_FinEnerSect))/10^6, "billion"+money]; ["Final Energies - Public Consumption", sum(ref.G_value(Indice_FinEnerSect))/10^6, sum(Out.G_value(Indice_FinEnerSect))/10^6, "billion"+money]; ["Final Energies - Gross fixed Capital Formation", sum(ref.I_value(Indice_FinEnerSect))/10^6, sum(Out.I_value(Indice_FinEnerSect))/10^6, "billion"+money]; ["Final Energies - Exports", sum(ref.X_value(Indice_FinEnerSect))/10^6, sum(Out.X_value(Indice_FinEnerSect))/10^6, "billion"+money]; ["Final Energies - Imports", -sum(ref.M_value(Indice_FinEnerSect))/10^6, -sum(Out.M_value(Indice_FinEnerSect))/10^6, "billion"+money] ];

// Non Energy Products
evol_ref.MacroT18 = [["Variable", "Value 0", "Value 1", "Unit"]; ["Non Energy Products - Output", sum(ref.Output_value(Indice_NonEnerSect))/10^6, sum(Out.Output_value(Indice_NonEnerSect))/10^6, "billion"+money]; ["Non Energy Products - Intermediate Consumptions (Inputs)", sum(ref.IC_value(:, Indice_NonEnerSect))/10^6, sum(Out.IC_value(:, Indice_NonEnerSect))/10^6, "billion"+money]; ["Non Energy Products - Intermediate Consumptions (Outputs)", sum(ref.IC_value(Indice_NonEnerSect,:))/10^6, sum(Out.IC_value(Indice_NonEnerSect,:))/10^6, "billion"+money]; ["Non Energy Products - Value-Added", sum(ref.Output_value(Indice_NonEnerSect))/10^6 - sum(ref.IC_value(:,Indice_NonEnerSect))/10^6, sum(Out.Output_value(Indice_NonEnerSect))/10^6 - sum(Out.IC_value(:,Indice_NonEnerSect))/10^6, "billion"+money]; ["Non Energy Products - Labour Income", sum(ref.Labour_income(Indice_NonEnerSect))/10^6, sum(Out.Labour_income(Indice_NonEnerSect))/10^6, "billion"+money]; ["Non Energy Products - Labour Tax", sum(ref.Labour_Tax(Indice_NonEnerSect))/10^6, sum(Out.Labour_Tax(Indice_NonEnerSect))/10^6, "billion"+money]; ["Non Energy Products - Production Tax", sum(ref.Production_Tax(Indice_NonEnerSect))/10^6, sum(Out.Production_Tax(Indice_NonEnerSect))/10^6, "billion"+money]; ["Non Energy Products - Consumption Tax", sum(ref.Taxes(:,Indice_NonEnerSect))/10^6 + sum(ref.Carbon_Tax(:,Indice_NonEnerSect))/10^6, sum(Out.Taxes(:,Indice_NonEnerSect))/10^6 + sum(Out.Carbon_Tax(:,Indice_NonEnerSect))/10^6, "billion"+money]; ["Non Energy Products - Capital income", sum(ref.Capital_income(Indice_NonEnerSect))/10^6, sum(Out.Capital_income(Indice_NonEnerSect))/10^6, "billion"+money]; ["Non Energy Products - Margins", sum(ref.TotMargins(Indice_NonEnerSect))/10^6, sum(Out.TotMargins(Indice_NonEnerSect))/10^6, "billion"+money]; ["Non Energy Products - Private Consumption", sum(ref.C_value(Indice_NonEnerSect))/10^6, sum(Out.C_value(Indice_NonEnerSect))/10^6, "billion"+money]; ["Non Energy Products - Public Consumption", sum(ref.G_value(Indice_NonEnerSect))/10^6, sum(Out.G_value(Indice_NonEnerSect))/10^6, "billion"+money]; ["Non Energy Products - Gross fixed Capital Formation", sum(ref.I_value(Indice_NonEnerSect))/10^6, sum(Out.I_value(Indice_NonEnerSect))/10^6, "billion"+money]; ["Non Energy Products - Exports", sum(ref.X_value(Indice_NonEnerSect))/10^6, sum(Out.X_value(Indice_NonEnerSect))/10^6, "billion"+money]; ["Non Energy Products - Imports", -sum(ref.M_value(Indice_NonEnerSect))/10^6, -sum(Out.M_value(Indice_NonEnerSect))/10^6, "billion"+money] ];

//	Demography
evol_ref.MacroT19 = [ ["Variable", "Value 0", "Value 1", "Unit"]; ["Total population ", sum(ref.Population), sum(Out.Population), "Thousands of people"]; ["Active Population", sum(ref.Labour_force), sum(Out.Labour_force), "Thousands of people"]; ["Inactive Population", sum(ref.Population) - sum(ref.Labour_force), sum(Out.Population) - sum(Out.Labour_force), "Thousands of people"]; ["Working Population", (1-ref.u_tot)*sum(ref.Labour_force), (1-Out.u_tot)*sum(Out.Labour_force), "Thousands of people"]; ["Unemployed", ref.u_tot*sum(ref.Labour_force), Out.u_tot*sum(Out.Labour_force), "Thousands of people"]; ["Formal Labour", sum(ref.Labour), sum(Out.Labour), "Full Time equivalents"];  ["Formal Labour - Primary Energies", sum(ref.Labour(Indice_PrimEnerSect) ), sum(Out.Labour(Indice_PrimEnerSect)), "Full Time equivalents"]; ["Formal Labour", sum(ref.Labour(Indice_FinEnerSect)), sum(Out.Labour(Indice_FinEnerSect)), "Full Time equivalents"]; ["Formal Labour", sum(ref.Labour(Indice_NonEnerSect)), sum(Out.Labour(Indice_NonEnerSect)), "Full Time equivalents"]] ;

//	Energy - Physical Quantities

// Total Energy
evol_ref.MacroT20 = [["Variable", "Value 0", "Value 1", "Unit"] ; ["Total Energy", sum(ref.Y(Indice_EnerSect)) + sum(ref.M(Indice_EnerSect)), sum(Out.Y(Indice_EnerSect)) + sum(Out.M(Indice_EnerSect)), "kTons Oil Equivalent"] ; ["Total Energy Output", sum(ref.Y(Indice_EnerSect)), sum(Out.Y(Indice_EnerSect)), "kTons Oil Equivalent"] ; ["Total Intermediate Energy Consumption (Inputs)", sum(ref.IC(:,Indice_EnerSect)), sum(Out.IC(:,Indice_EnerSect)), "kTons Oil Equivalent"] ; ["Total Energy Imports", sum(ref.M(Indice_EnerSect)), sum(Out.M(Indice_EnerSect)), "kTons Oil Equivalent"] ; ["Total Intermediate Energy Consumption (Demand)", sum(ref.IC(Indice_EnerSect,:)), sum(Out.IC(Indice_EnerSect,:)), "kTons Oil Equivalent"] ; ["Total Final Energy Demand", sum(ref.C(Indice_EnerSect,:)) + sum(ref.X(Indice_EnerSect)), sum(Out.X(Indice_EnerSect)) + sum(Out.C(Indice_EnerSect,:)), "kTons Oil Equivalent"] ; ["Total Private Energy Consumption", sum(ref.C(Indice_EnerSect,:)), sum(Out.C(Indice_EnerSect,:)), "kTons Oil Equivalent"] ; ["Total Energy Exports", sum(ref.X(Indice_EnerSect)), sum(Out.X(Indice_EnerSect)), "kTons Oil Equivalent"]];

// Primary Energy
evol_ref.MacroT21 = [["Variable", "Value 0", "Value 1", "Unit"] ; ["Total Primary Energy", sum(ref.Y(Indice_PrimEnerSect)) + sum(ref.M(Indice_PrimEnerSect)), sum(Out.Y(Indice_PrimEnerSect)) + sum(Out.M(Indice_PrimEnerSect)), "kTons Oil Equivalent"] ; ["Total Primary Energy Output", sum(ref.Y(Indice_PrimEnerSect)), sum(Out.Y(Indice_PrimEnerSect)), "kTons Oil Equivalent"] ; ["Total Intermediate Energy Consumption - Primary Energy (Inputs)", sum(ref.IC(:,Indice_PrimEnerSect)), sum(Out.IC(:,Indice_PrimEnerSect)), "kTons Oil Equivalent"] ; ["Total Primary Energy Imports", sum(ref.M(Indice_PrimEnerSect)), sum(Out.M(Indice_PrimEnerSect)), "kTons Oil Equivalent"] ; ["Total Intermediate Energy Consumption - Primary Energy (Demand)", sum(ref.IC(Indice_PrimEnerSect,:)), sum(Out.IC(Indice_PrimEnerSect,:)), "kTons Oil Equivalent"] ; ["Total Final Energy Demand - Primary Energy", sum(ref.C(Indice_PrimEnerSect,:)) + sum(ref.X(Indice_PrimEnerSect)), sum(Out.X(Indice_PrimEnerSect)) + sum(Out.C(Indice_PrimEnerSect,:)), "kTons Oil Equivalent"] ; ["Total Private Primary Energy Consumption", sum(ref.C(Indice_PrimEnerSect,:)), sum(Out.C(Indice_PrimEnerSect,:)), "kTons Oil Equivalent"] ; ["Total Primary Energy Exports", sum(ref.X(Indice_PrimEnerSect)), sum(Out.X(Indice_PrimEnerSect)), "kTons Oil Equivalent"]];

// Final Energy
evol_ref.MacroT22 = [["Variable", "Value 0", "Value 1", "Unit"] ; ["Total Final Energy", sum(ref.Y(Indice_FinEnerSect)) + sum(ref.M(Indice_FinEnerSect)), sum(Out.Y(Indice_FinEnerSect)) + sum(Out.M(Indice_FinEnerSect)), "kTons Oil Equivalent"] ; ["Total Final Energy Output", sum(ref.Y(Indice_FinEnerSect)), sum(Out.Y(Indice_FinEnerSect)), "kTons Oil Equivalent"] ; ["Total Intermediate Energy Consumption - Final Energies (Inputs)", sum(ref.IC(:,Indice_FinEnerSect)), sum(Out.IC(:,Indice_FinEnerSect)), "kTons Oil Equivalent"] ; ["Total Final Energy Imports", sum(ref.M(Indice_FinEnerSect)), sum(Out.M(Indice_FinEnerSect)), "kTons Oil Equivalent"] ; ["Total Intermediate Energy Consumption - Final Energies (Demand)", sum(ref.IC(Indice_FinEnerSect,:)), sum(Out.IC(Indice_FinEnerSect,:)), "kTons Oil Equivalent"] ; ["Total Final Energy Demand - Final Energies ", sum(ref.C(Indice_FinEnerSect,:)) + sum(ref.X(Indice_FinEnerSect)), sum(Out.X(Indice_FinEnerSect)) + sum(Out.C(Indice_FinEnerSect,:)), "kTons Oil Equivalent"] ; ["Total Private Final Energy Consumption", sum(ref.C(Indice_FinEnerSect,:)), sum(Out.C(Indice_FinEnerSect,:)), "kTons Oil Equivalent"] ; ["Total Final Energy Exports", sum(ref.X(Indice_FinEnerSect)), sum(Out.X(Indice_FinEnerSect)), "kTons Oil Equivalent"]];

//	Energy - Physical Prices

// Total Energy 
evol_ref.MacroT23 = [["Variable", "Value 0", "Value 1", "Unit"] ; ["Total Energy (Pre-tax price)", (sum(ref.Y_value(Indice_EnerSect))+sum(ref.M_value(Indice_EnerSect)))/(sum(ref.Y(Indice_EnerSect)) + sum(ref.M(Indice_EnerSect))), (sum(Out.Y_value(Indice_EnerSect))+sum(Out.M_value(Indice_EnerSect)))/(sum(Out.Y(Indice_EnerSect)) + sum(Out.M(Indice_EnerSect))), money+" per Ton Oil Equivalent"] ;["Total Energy (After-tax Price)", (sum(ref.Output_value(Indice_EnerSect))+sum(ref.M_value(Indice_EnerSect)))/(sum(ref.Y(Indice_EnerSect)) + sum(ref.M(Indice_EnerSect))), (sum(Out.Output_value(Indice_EnerSect))+sum(Out.M_value(Indice_EnerSect)))/(sum(Out.Y(Indice_EnerSect)) + sum(Out.M(Indice_EnerSect))), money+" per Ton Oil Equivalent"] ; ["Total Energy Output", sum(ref.Y_value(Indice_EnerSect)) / sum(ref.Y(Indice_EnerSect)), sum(Out.Y_value(Indice_EnerSect)) / sum(Out.Y(Indice_EnerSect)), money+" per Ton Oil Equivalent"] ; ["Total Intermediate Energy Consumption (Inputs)", sum(ref.IC_value(Indice_EnerSect,Indice_EnerSect)) / sum(ref.IC(Indice_EnerSect,Indice_EnerSect)), sum(Out.IC_value(Indice_EnerSect,Indice_EnerSect)) / sum(Out.IC(Indice_EnerSect,Indice_EnerSect)), money+" per Ton Oil Equivalent"] ; ["Total Energy Imports", sum(ref.M_value(Indice_EnerSect)) / sum(ref.M(Indice_EnerSect)), sum(Out.M_value(Indice_EnerSect)) / sum(Out.M(Indice_EnerSect)), money+" per Ton Oil Equivalent"] ; ["Total Intermediate Energy Consumption (Demand)", sum(ref.IC_value(Indice_EnerSect,:)) / sum(ref.IC(Indice_EnerSect,:)), sum(Out.IC_value(Indice_EnerSect,:)) / sum(Out.IC(Indice_EnerSect,:)), money+" per Ton Oil Equivalent"] ; ["Total Final Energy Demand", (sum(ref.C_value(Indice_EnerSect,:)) + sum(ref.X_value(Indice_EnerSect))) / (sum(ref.C(Indice_EnerSect,:)) + sum(ref.X(Indice_EnerSect))), (sum(Out.C_value(Indice_EnerSect,:)) + sum(Out.X_value(Indice_EnerSect))) / (sum(Out.C(Indice_EnerSect,:)) + sum(Out.X(Indice_EnerSect))), money+" per Ton Oil Equivalent"] ; ["Total Private Energy Consumption", sum(ref.C_value(Indice_EnerSect,:)) / sum(ref.C(Indice_EnerSect,:)), sum(Out.C_value(Indice_EnerSect,:)) / sum(Out.C(Indice_EnerSect,:)), "kTons Oil Equivalent"] ; ["Total Energy Exports", sum(ref.X_value(Indice_EnerSect)) / sum(ref.X(Indice_EnerSect)), sum(Out.X_value(Indice_EnerSect)) / sum(Out.X(Indice_EnerSect)), money+" per Ton Oil Equivalent"]];

// Primary Energy
evol_ref.MacroT24 = [["Variable", "Value 0", "Value 1", "Unit"] ; ..
 ["Total Primary Energy (Pre-tax price)", ..
 (sum(ref.Y_value(Indice_PrimEnerSect))+sum(ref.M_value(Indice_PrimEnerSect)))/(sum(ref.Y(Indice_PrimEnerSect)) + sum(ref.M(Indice_PrimEnerSect))), ..
 (sum(Out.Y_value(Indice_PrimEnerSect))+sum(Out.M_value(Indice_PrimEnerSect)))/(sum(Out.Y(Indice_PrimEnerSect)) + sum(Out.M(Indice_PrimEnerSect))), ..
 money+" per Ton Oil Equivalent"] ; ..
 ["Total primary Energy (After-tax Price)", ..
 (sum(ref.Output_value(Indice_PrimEnerSect))+sum(ref.M_value(Indice_PrimEnerSect)))/(sum(ref.Y(Indice_PrimEnerSect)) + sum(ref.M(Indice_PrimEnerSect))), ..
 (sum(Out.Output_value(Indice_PrimEnerSect))+sum(Out.M_value(Indice_PrimEnerSect)))/(sum(Out.Y(Indice_PrimEnerSect)) + sum(Out.M(Indice_PrimEnerSect))), ..
 money+" per Ton Oil Equivalent"] ; ..
 ["Total Primary Energy Output", ..
 sum(ref.Y_value(Indice_PrimEnerSect)) / sum(ref.Y(Indice_PrimEnerSect)), ..
 sum(Out.Y_value(Indice_PrimEnerSect)) / sum(Out.Y(Indice_PrimEnerSect)), ..
 money+" per Ton Oil Equivalent"] ; ..
 ["Total Intermediate Energy Consumption - Primary Energy (Inputs)", ..
 sum(ref.IC_value(Indice_EnerSect,Indice_PrimEnerSect)) / sum(ref.IC(Indice_EnerSect,Indice_PrimEnerSect)), ..
 sum(Out.IC_value(Indice_EnerSect,Indice_PrimEnerSect)) / sum(Out.IC(Indice_EnerSect,Indice_PrimEnerSect)), ..
 money+" per Ton Oil Equivalent"] ; ..
 ["Total Primary Energy Imports", ..
 sum(ref.M_value(Indice_PrimEnerSect)) / sum(ref.M(Indice_PrimEnerSect)), ..
 sum(Out.M_value(Indice_PrimEnerSect)) / sum(Out.M(Indice_PrimEnerSect)), ..
 money+" per Ton Oil Equivalent"] ; ..
 ["Total Intermediate Energy Consumption - Primary Energy (Demand)", ..
 sum(ref.IC_value(Indice_PrimEnerSect,:)) / sum(ref.IC(Indice_PrimEnerSect,:)), ..
 sum(Out.IC_value(Indice_PrimEnerSect,:)) / sum(Out.IC(Indice_PrimEnerSect,:)), ..
 money+" per Ton Oil Equivalent"] ; ..
 ["Total Final Primary Energy Demand", ..
 divide(sum(ref.C_value(Indice_PrimEnerSect,:)) + sum(ref.X_value(Indice_PrimEnerSect)), sum(ref.C(Indice_PrimEnerSect,:)) + sum(ref.X(Indice_PrimEnerSect)), %nan), ..
 divide(sum(Out.C_value(Indice_PrimEnerSect,:)) + sum(Out.X_value(Indice_PrimEnerSect)), sum(Out.C(Indice_PrimEnerSect,:)) + sum(Out.X(Indice_PrimEnerSect)), %nan), ..
 money+" per Ton Oil Equivalent"] ; ..
 ["Total Private Primary Energy Consumption", ..
 divide(sum(ref.C_value(Indice_PrimEnerSect,:)), sum(ref.C(Indice_PrimEnerSect,:)), %nan), ..
 divide(sum(Out.C_value(Indice_PrimEnerSect,:)), sum(Out.C(Indice_PrimEnerSect,:)), %nan), ..
 "kTons Oil Equivalent"] ; ..
 ["Total Primary Energy Exports", ..
 divide(sum(ref.X_value(Indice_PrimEnerSect)),sum(ref.X(Indice_PrimEnerSect)),%nan), ..
 divide(sum(Out.X_value(Indice_PrimEnerSect)), sum(Out.X(Indice_PrimEnerSect)),%nan), ..
 money+" per Ton Oil Equivalent"]];

// Final Energy Products
evol_ref.MacroT25 = [["Variable", "Value 0", "Value 1", "Unit"] ; ["Total Final Energy (Pre-tax price)", (sum(ref.Y_value(Indice_FinEnerSect))+sum(ref.M_value(Indice_FinEnerSect)))/(sum(ref.Y(Indice_FinEnerSect)) + sum(ref.M(Indice_FinEnerSect))), (sum(Out.Y_value(Indice_FinEnerSect))+sum(Out.M_value(Indice_FinEnerSect)))/(sum(Out.Y(Indice_FinEnerSect)) + sum(Out.M(Indice_FinEnerSect))), money+" per Ton Oil Equivalent"] ;["Total Final Energy (After-tax Price)", (sum(ref.Output_value(Indice_FinEnerSect))+sum(ref.M_value(Indice_FinEnerSect)))/(sum(ref.Y(Indice_FinEnerSect)) + sum(ref.M(Indice_FinEnerSect))), (sum(Out.Output_value(Indice_FinEnerSect))+sum(Out.M_value(Indice_FinEnerSect)))/(sum(Out.Y(Indice_FinEnerSect)) + sum(Out.M(Indice_FinEnerSect))), money+" per Ton Oil Equivalent"] ; ["Total Energy Output", sum(ref.Y_value(Indice_FinEnerSect)) / sum(ref.Y(Indice_FinEnerSect)), sum(Out.Y_value(Indice_FinEnerSect)) / sum(Out.Y(Indice_FinEnerSect)), money+" per Ton Oil Equivalent"] ; ["Total Intermediate Energy Consumption - Final Energies (Inputs)", sum(ref.IC_value(Indice_EnerSect,Indice_FinEnerSect)) / sum(ref.IC(Indice_EnerSect,Indice_FinEnerSect)), sum(Out.IC_value(Indice_EnerSect,Indice_FinEnerSect)) / sum(Out.IC(Indice_EnerSect,Indice_FinEnerSect)), money+" per Ton Oil Equivalent"] ; ["Total Final Energy Imports", sum(ref.M_value(Indice_FinEnerSect)) / sum(ref.M(Indice_FinEnerSect)), sum(Out.M_value(Indice_FinEnerSect)) / sum(Out.M(Indice_FinEnerSect)), money+" per Ton Oil Equivalent"] ; ["Total Intermediate Energy Consumption - Final Energies (Demand)", sum(ref.IC_value(Indice_FinEnerSect,:)) / sum(ref.IC(Indice_FinEnerSect,:)), sum(Out.IC_value(Indice_FinEnerSect,:)) / sum(Out.IC(Indice_FinEnerSect,:)), money+" per Ton Oil Equivalent"] ; ["Total Final Energy Demand - Final Energies ", (sum(ref.C_value(Indice_FinEnerSect,:)) + sum(ref.X_value(Indice_FinEnerSect))) / (sum(ref.C(Indice_FinEnerSect,:)) + sum(ref.X(Indice_FinEnerSect))), (sum(Out.C_value(Indice_FinEnerSect,:)) + sum(Out.X_value(Indice_FinEnerSect))) / (sum(Out.C(Indice_FinEnerSect,:)) + sum(Out.X(Indice_FinEnerSect))), money+" per Ton Oil Equivalent"] ; ["Total Private Final Energy Consumption", sum(ref.C_value(Indice_FinEnerSect,:)) / sum(ref.C(Indice_FinEnerSect,:)), sum(Out.C_value(Indice_FinEnerSect,:)) / sum(Out.C(Indice_FinEnerSect,:)), "kTons Oil Equivalent"] ; ["Total Final Energy Exports", sum(ref.X_value(Indice_FinEnerSect)) / sum(ref.X(Indice_FinEnerSect)), sum(Out.X_value(Indice_FinEnerSect)) / sum(Out.X(Indice_FinEnerSect)), money+" per Ton Oil Equivalent"]];

//	CO2 Emissions

evol_ref.MacroT27 = [["Variable", "Value 0", "Value 1", "Unit"] ; ["Total Emissions", ref.DOM_CO2, Out.DOM_CO2, "Mega Ton CO2"] ; ["Emissions from intermediate Consumptions", sum(ref.CO2Emis_IC), sum(Out.CO2Emis_IC), "Mega Ton CO2"] ; ["Emissions from Private Consumption", sum(ref.CO2Emis_C), sum(Out.CO2Emis_C), "Mega Ton CO2"] ; ["Total Emissions - Primary Energies", sum(ref.CO2Emis_IC(Indice_PrimEnerSect,:)) + sum(ref.CO2Emis_C(Indice_PrimEnerSect,:)), sum(Out.CO2Emis_IC(Indice_PrimEnerSect,:)) + sum(Out.CO2Emis_C(Indice_PrimEnerSect,:)), "Mega Ton CO2"] ; ["Emissions from intermediate Consumptions - Primary energies", sum(ref.CO2Emis_IC(Indice_PrimEnerSect,:)), sum(Out.CO2Emis_IC(Indice_PrimEnerSect,:)), "Mega Ton CO2"] ; ["Emissions from Private Consumption - Primary energies", sum(ref.CO2Emis_C(Indice_PrimEnerSect,:)), sum(Out.CO2Emis_C(Indice_PrimEnerSect,:)), "Mega Ton CO2"] ; ["Total Emissions - Final Energies", sum(ref.CO2Emis_IC(Indice_FinEnerSect,:)) + sum(ref.CO2Emis_C(Indice_FinEnerSect,:)), sum(Out.CO2Emis_IC(Indice_FinEnerSect,:)) + sum(Out.CO2Emis_C(Indice_FinEnerSect,:)), "Mega Ton CO2"] ; ["Emissions from intermediate Consumptions - Final energies", sum(ref.CO2Emis_IC(Indice_FinEnerSect,:)), sum(Out.CO2Emis_IC(Indice_FinEnerSect,:)), "Mega Ton CO2"] ; ["Emissions from Private Consumption - Final energies", sum(ref.CO2Emis_C(Indice_FinEnerSect,:)), sum(Out.CO2Emis_C(Indice_FinEnerSect,:)), "Mega Ton CO2"]];

// Other 

evol_ref.MacroT28 = [["Variable", "Indice 0", "Indice 1", "% variation"]; ["Real Households consumption", "1", C_qLasp, (C_qLasp-1)*100]; ["Energy in real Households consumption", ref.Ener_C_ValueShare, ref.Ener_C_ValueShare*C_En_qLasp, ref.Ener_C_ValueShare*(C_En_qLasp-1)*100]; ["Non energy goods in real Households consumption", ref.NonEner_C_ValueShare, ref.NonEner_C_ValueShare*C_NonEn_qLasp, ref.NonEner_C_ValueShare*(C_NonEn_qLasp-1)*100]; ["Real Imports/Domestic production ratio","1", M_Y_Ratio_qLasp, (M_Y_Ratio_qLasp-1)*100];["Unemployment rate (indice, % points)", "1", Out.u_tot/ref.u_tot, Out.u_tot - ref.u_tot]; ["Total Employment", "1", Out.Labour_tot/ref.Labour_tot, (evol_ref.Labour_tot-1)*100]; ["Production contribution to labour variation (Laspeyres)", "1", Y_Labour_qLasp, (Y_Labour_qLasp-1)*100]; ["Labour Intensity (Paashes)","1", lambda_pPaas, (lambda_pPaas-1)*100]; ["Production Price (Laspeyres)", "1", Y_pLasp, (Y_pLasp-1)*100]; ["Production Price (Paashes)", "1", Y_pPaas, (Y_pPaas-1)*100]; ["Energy Intensity (Paashes)", "1", alpha_Ener_qPaas, (alpha_Ener_qPaas-1)*100]; ["Energy cost share", "1", Out.ENshareMacro/ref.ENshareMacro, (evol_ref.ENshareMacro - 1)*100]; ["Labour cost share", "1", Out.LabourShareMacro/ref.LabourShareMacro, (evol_ref.LabourShareMacro - 1)*100]; ["Energy Input Price (Laspeyres)", "1", IC_Ener_pLasp, (IC_Ener_pLasp-1)*100]; ["Energy Input Price (Paashes)", "1", IC_Ener_pPaas, (IC_Ener_pPaas-1)*100]; ["Mean Labour Cost", "1", Out.omega/ref.omega, (evol_ref.omega - 1)*100]; ["Net-of-tax wages", "1", Out.NetWage_variation, (Out.NetWage_variation-1)*100]; ["Labour tax rate (% points)", "0", "nan",- Out.Labour_Tax_Cut]; ["Total Emissions", "1", Out.DOM_CO2/ref.DOM_CO2, (evol_ref.DOM_CO2-1)*100]; ["Households Consumption Price (Laspeyres)", "1", C_pLasp, (C_pLasp-1)*100]; ["Households Consumption Price (Paashes)", "1", C_pPaas, (C_pPaas-1)*100]; ["Households energy Consumption Price (Laspeyres)", "1", C_En_pLasp, (C_En_pLasp-1)*100]; ["Households Energy Consumption Price (Paashes)", "1", C_En_pPaas, (C_En_pPaas-1)*100]; ["Households energy Consumption Price (Laspeyres)", "1", C_NonEn_pLasp, (C_NonEn_pLasp-1)*100]; ["Households Non Energy Consumption Price (Paashes)", "1", C_NonEn_pPaas, (C_NonEn_pPaas-1)*100]; ["Public Deficits", "1", Out.Ecotable(Indice_NetLending, Indice_Government)/ref.Ecotable(Indice_NetLending, Indice_Government), (evol_ref.Ecotable(Indice_NetLending, Indice_Government)-1)*100]];

// Put pI back to normal (cf change at the beginning of the file)
Out.pI = Out.pI(:,1);
ref.pI = ref.pI(:,1);

//// GLT TABLE - JANUARY 2017
if abs(Out.Labour_Tax_Cut)> %eps
    DispLabTabl = "Labour tax reduction";
else
    DispLabTabl = "No recycling revenues";
    Out.Labour_Tax_Cut = (abs(Out.Labour_Tax_Cut) > %eps).*Out.Labour_Tax_Cut;
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


OutputTable.GDP_decomBIS = [["Variable", "Nominal 0 (G"+money+")", "Nominal 1 (G€)", "Price Index (Paasche)", "Real 1 (G€)", "Real term ratio"]; ["GDP", round(ref.GDP/10^5)/10, round(Out.GDP/10^5)/10, GDP_pPaas, round((Out.GDP/GDP_pPaas)/10^5)/10, GDP_qLasp];["Households consumption", round(sum(Out.C_value)/10^5)/10, round(sum(Out.C_value)/10^5)/10, C_pPaas, round((sum(Out.C_value)/C_pPaas)/10^5)/10, C_qLasp]; ["Households consumption - Non-energy goods", round(sum(Out.C_value(Indice_NonEnerSect,:))/10^5)/10, round(sum(Out.C_value(Indice_NonEnerSect,:))/10^5)/10, C_NonEn_pPaas, round((sum(Out.C_value(Indice_NonEnerSect,:))/C_NonEn_pPaas)/10^5)/10, C_NonEn_qLasp];["Households consumption - Energy goods", round(sum(Out.C_value(Indice_EnerSect,:))/10^5)/10, round(sum(Out.C_value(Indice_EnerSect,:))/10^5)/10, C_En_pPaas, round((sum(Out.C_value(Indice_EnerSect,:))/C_En_pPaas)/10^5)/10, C_En_qLasp]; ["Government consumption", round(sum(Out.G_value)/10^5)/10, round(sum(Out.G_value)/10^5)/10, G_pPaas, round((sum(Out.G_value)/G_pPaas)/10^5)/10, G_qLasp];["Government consumption - Non-energy goods", round(sum(Out.G_value(Indice_NonEnerSect))/10^5)/10, round(sum(Out.G_value(Indice_NonEnerSect))/10^5)/10, G_NonEn_pPaas, round((sum(Out.G_value(Indice_NonEnerSect,:))/G_NonEn_pPaas)/10^5)/10, G_NonEn_qLasp]; ["Government consumption - Energy goods", round(sum(Out.G_value(Indice_EnerSect))/10^5)/10, round(sum(Out.G_value(Indice_EnerSect))/10^5)/10, G_En_pPaas, round((sum(Out.G_value(Indice_EnerSect))/G_En_pPaas)/10^5)/10, G_En_qLasp];["Investment", round(sum(Out.I_value)/10^5)/10, round(sum(Out.I_value)/10^5)/10, I_pPaas, round((sum(Out.I_value)/I_pPaas)/10^5)/10, I_qLasp];["Investment - Non-energy goods", round(sum(Out.I_value(Indice_NonEnerSect))/10^5)/10, round(sum(Out.I_value(Indice_NonEnerSect))/10^5)/10, I_NonEn_pPaas, round((sum(Out.I_value(Indice_NonEnerSect,:))/I_NonEn_pPaas)/10^5)/10, I_NonEn_qLasp]; ["Investment - Energy goods", round(sum(Out.I_value(Indice_EnerSect))/10^5)/10, round(sum(Out.I_value(Indice_EnerSect))/10^5)/10, I_En_pPaas, round((sum(Out.I_value(Indice_EnerSect))/I_En_pPaas)/10^5)/10, I_En_qLasp];["Exports", round(sum(Out.X_value)/10^5)/10, round(sum(Out.X_value)/10^5)/10, X_pPaas, round((sum(Out.X_value)/X_pPaas)/10^5)/10, X_qLasp];["Exports - Non-energy goods", round(sum(Out.X_value(Indice_NonEnerSect))/10^5)/10, round(sum(Out.X_value(Indice_NonEnerSect))/10^5)/10, X_NonEn_pPaas, round((sum(Out.X_value(Indice_NonEnerSect,:))/X_NonEn_pPaas)/10^5)/10, X_NonEn_qLasp]; ["Exports - Energy goods", round(sum(Out.X_value(Indice_EnerSect))/10^5)/10, round(sum(Out.X_value(Indice_EnerSect))/10^5)/10, X_En_pPaas, round((sum(Out.X_value(Indice_EnerSect))/X_En_pPaas)/10^5)/10, X_En_qLasp];["Imports", round(sum(Out.M_value)/10^5)/10, round(sum(Out.M_value)/10^5)/10, M_pPaas, round((sum(Out.M_value)/M_pPaas)/10^5)/10, M_qLasp];["Imports - Non-energy goods", round(sum(Out.M_value(Indice_NonEnerSect))/10^5)/10, round(sum(Out.M_value(Indice_NonEnerSect))/10^5)/10, M_NonEn_pPaas, round((sum(Out.M_value(Indice_NonEnerSect))/M_NonEn_pPaas)/10^5)/10, M_NonEn_qLasp];["Imports - Energy goods", round(sum(Out.M_value(Indice_EnerSect))/10^5)/10, round(sum(Out.M_value(Indice_EnerSect))/10^5)/10, M_En_pPaas, round((sum(Out.M_value(Indice_EnerSect))/M_En_pPaas)/10^5)/10, M_En_qLasp]; ["Net-of-tax wages", "-" , "-" ,"-" , "for nominal ratio:" ,Out.NetWage_variation] ;["Total Employment", "-" , "-" ,"-" , "Abs ratio:" ,evol_ref.Labour_tot]];

// OutputTable.GDP_decom = [[ ["Real Macro results", "in Ratio"];["Real GDP (Laspeyres)", (GDP_qLasp)];["Households consumption in GDP",(sum(ref.C_value)/ref.GDP) *(C_qLasp)]; ["Public consumption in GDP", (sum(ref.G_value)/ref.GDP)*(G_qLasp)]; ["Investment in GDP",(sum(ref.I_value)/ref.GDP)*(I_qLasp)]; ["Exports in GDP", (sum(ref.X_value)/ref.GDP)*(X_qLasp)]; ["Imports in GDP", (sum(ref.M_value)/ref.GDP)*(M_qLasp)]],[ ["Nominal Macro results", "in Ratio"];["Nominal GDP", (Out.GDP/ref.GDP)];["Households consumption in GDP",(sum(Out.C_value)/ref.GDP) ]; ["Public consumption in GDP", (sum(Out.G_value)/ref.GDP)]; ["Investment in GDP",(sum(Out.I_value)/ref.GDP)]; ["Exports in GDP", (sum(Out.X_value)/ref.GDP)]; ["Imports in GDP", (sum(Out.M_value)/ref.GDP)]]];


// Test_quantity= [["variable", " ratio quantity"];["GDP", (Out.GDP/GDP_pPaas)/ref.GDP];["Households consumption", (sum(Out.C_value)/C_pPaas)/sum(ref.C_value)];["Households consumption - Non-energy goods", (sum(Out.C_value(Indice_NonEnerSect,:))/C_NonEn_pPaas)/sum(ref.C_value(Indice_NonEnerSect,:))];["Households consumption - Energy goods", (sum(Out.C_value(Indice_EnerSect,:))/C_En_pPaas)/sum(ref.C_value(Indice_EnerSect,:))];["Government consumption", (sum(Out.G_value)/G_pPaas)/sum(ref.G_value)];["Government consumption - Non-energy goods", (sum(Out.G_value(Indice_NonEnerSect))/G_NonEn_pPaas)/sum(ref.G_value(Indice_NonEnerSect))];["Government consumption - Energy goods", divide(sum(Out.G_value(Indice_EnerSect,:))/G_En_pPaas,sum(ref.G_value(Indice_EnerSect,:)),%nan)];["Investment", (sum(Out.I_value)/I_pPaas)/sum(ref.I_value)];["Investment - Non-energy goods", (sum(Out.I_value(Indice_NonEnerSect))/C_NonEn_pPaas)/sum(ref.I_value(Indice_NonEnerSect))];["Investment - Energy goods", divide(sum(Out.I_value(Indice_EnerSect,:))/I_En_pPaas,sum(ref.I_value(Indice_EnerSect,:)),%nan)]; ["Exports", (sum(Out.X_value)/X_pPaas)/sum(ref.X_value)];["Exports - Non-energy goods", (sum(Out.X_value(Indice_NonEnerSect))/X_NonEn_pPaas)/sum(ref.X_value(Indice_NonEnerSect))];["Exports - Energy goods", divide(sum(Out.X_value(Indice_EnerSect,:))/X_En_pPaas,sum(ref.X_value(Indice_EnerSect,:)),%nan)]; ["Imports", (sum(Out.M_value)/M_pPaas)/sum(ref.M_value)];["Imports - Non-energy goods", (sum(Out.M_value(Indice_NonEnerSect))/M_NonEn_pPaas)/sum(ref.M_value(Indice_NonEnerSect))];["Imports - Energy goods", divide(sum(Out.M_value(Indice_EnerSect))/M_En_pPaas,sum(ref.M_value(Indice_EnerSect)),%nan)]];

// OutputTable.MacroT = [ ["Macro results", "in %"];["Carbon Tax rate", parameters.Carbon_Tax_rate / 10^3 + money+"/tCO2"];["Labour Tax cut", DispLabTabl];["Real GDP (Laspeyres)", (GDP_qLasp-1)*100];["Households consumption in GDP",(sum(ref.C_value)/ref.GDP) *(C_qLasp-1)*100]; ["Public consumption in GDP", (sum(ref.G_value)/ref.GDP)*(G_qLasp-1)*100]; ["Investment in GDP",(sum(ref.I_value)/ref.GDP)*(I_qLasp-1)*100]; ["Exports in GDP", (sum(ref.X_value)/ref.GDP)*(X_qLasp-1)*100]; ["Imports in GDP", (sum(ref.M_value)/ref.GDP)*(M_qLasp-1)*100]; ["Imports/Domestic production ratio",(M_Y_Ratio_qLasp-1)*100]; ["Trade balance", (((sum(Out.X_value) - sum(Out.M_value))/(sum(ref.X_value) - sum(ref.M_value)))-1)*100];["Imports of Non Energy goods in volume", (divide(sum(Out.M(Indice_NonEnerSect,:)), sum(ref.M(Indice_NonEnerSect,:)),%nan ) -1)*100 ];["Exports of Non Energy goods in volume", (divide(sum(Out.X(Indice_NonEnerSect,:)), sum(ref.X(Indice_NonEnerSect,:)),%nan ) -1)*100 ];["Total Employment", (evol_ref.Labour_tot-1)*100];["Unemployment rate (% points)", Out.u_tot - ref.u_tot];["Labour Intensity (Laspeyres)",(lambda_pLasp-1)*100];["Labour cost share", (evol_ref.LabourShareMacro-1)*100];["Labour tax rate (% points)", - Labour_Tax_Cut];  ["Net-of-tax wages", (NetWage_variation-1)*100]; ["Production Price (Laspeyres)", (Y_pLasp-1)*100]; ["Production Price Non Energy goods (Laspeyres)", (Y_NonEn_pLasp-1)*100];  ["Energy Input Price (Laspeyres)", (IC_Ener_pLasp-1)*100];  ["Energy Intensity (Laspeyres)", (alpha_Ener_qLasp-1)*100]; ["Real Households consumption (Laspeyres)", (C_qLasp-1)*100]; ["	Energy in Households consumption", ref.Ener_C_ValueShare*(C_En_qLasp-1)*100]; ["	Non Energy goods in Households consumption", ref.NonEner_C_ValueShare*(C_NonEn_qLasp-1)*100];["Households Consumption Price (Laspeyres)", (C_pLasp-1)*100];["	Energy Consumption Price for HH(Laspeyres", (C_En_pLasp-1)*100];["	Non Energy Consumption Price for HH(Laspeyres)", (C_NonEn_pLasp-1)*100]; ["Public Deficits", (evol_ref.Ecotable(Indice_NetLending, Indice_Government)-&)*100]; ["Total Emissions", (evol_ref.DOM_CO2-1)*100];["",""];["Import Elasticity for Non Energy goods",unique(sigma_M(Indice_NonEnerSect))];[" Most sensitif export Elasticity ",max(sigma_X(Indice_NonEnerSect))];[" Global mean wage/Unemployment Elasticity",sigma_omegaU]];

OutputTable("MacroT_"+ref_name) = [ ["Macro results", "in %/"+ref_name];["Carbon Tax rate", parameters.Carbon_Tax_rate / 10^3 + money+"/tCO2"];["Labour Tax cut", DispLabTabl];["Real GDP (Laspeyres)", (GDP_qLasp-1)*100];["Households consumption in GDP",(sum(ref.C_value)/ref.GDP) *(C_qLasp-1)*100]; ["Public consumption in GDP", (sum(ref.G_value)/ref.GDP)*(G_qLasp-1)*100]; ["Investment in GDP",(sum(ref.I_value)/ref.GDP)*(I_qLasp-1)*100]; ["Exports in GDP", (sum(ref.X_value)/ref.GDP)*(X_qLasp-1)*100]; ["Imports in GDP", (sum(ref.M_value)/ref.GDP)*(M_qLasp-1)*100]; ["Imports/Domestic production ratio",(M_Y_Ratio_qLasp-1)*100]; ["Imports of Non Energy goods in volume", (divide(sum(Out.M(Indice_NonEnerSect,:)), sum(ref.M(Indice_NonEnerSect,:)),%nan ) -1)*100 ];["Exports of Non Energy goods in volume", (divide(sum(Out.X(Indice_NonEnerSect,:)), sum(ref.X(Indice_NonEnerSect,:)),%nan ) -1)*100 ];["Total Employment", (evol_ref.Labour_tot-1)*100];["Unemployment rate (% points)", Out.u_tot - ref.u_tot];["Net-of-tax wages", (Out.NetWage_variation-1)*100];["Labour Intensity (Laspeyres)",(lambda_pLasp-1)*100];["Labour tax rate (% points)", - Out.Labour_Tax_Cut];  ["Energy Input Price (Laspeyres)", (IC_Ener_pLasp-1)*100]; ["Energy Intensity (Laspeyres)", (alpha_Ener_qLasp-1)*100]; ["Energy cost share for non-energetic sector", (evol_ref.ENshareNONEner-1)*100 ]; ["Production Price (Laspeyres)", (Y_pLasp-1)*100]; ["Production Price Energy goods (Laspeyres)", (Y_En_pLasp-1)*100]; ["Production Price Non Energy goods (Laspeyres)", (Y_NonEn_pLasp-1)*100]; ["Real Households consumption (Laspeyres)", (C_qLasp-1)*100]; ["	Energy in Households consumption", ref.Ener_C_ValueShare*(C_En_qLasp-1)*100]; ["	Non Energy goods in Households consumption", ref.NonEner_C_ValueShare*(C_NonEn_qLasp-1)*100];["Public Deficits", (evol_ref.Ecotable(Indice_NetLending, Indice_Government)-1)*100]; ["Total Emissions", (evol_ref.DOM_CO2-1)*100];["",""];["Most sensitif import Elasticity for NonEner",max(sigma_M(Indice_NonEnerSect))];[" Most sensitif export Elasticity for NonEner ",max(sigma_X(Indice_NonEnerSect))];[" Global mean wage/Unemployment Elasticity",sigma_omegaU]];


OutputTable("MacroTExtend_evol_"+ref_name) = [ 
["Macro results", "in %/"+ref_name];.. 
["Carbon Tax rate", (Out.Carbon_Tax_rate*eval(money_unit_data))/10^6+ money+"/tCO2"];.. 
["Recycling revenues options", Recycling_Option ];..
["Labour Tax cut", DispLabTabl];.. 
["Real GDP (Laspeyres)", (GDP_qLasp-1)*100];.. 
["Households consumption in GDP",(sum(ref.C_value)/ref.GDP) *(C_qLasp-1)*100];.. 
["Public consumption in GDP", (sum(ref.G_value)/ref.GDP)*(G_qLasp-1)*100];.. 
["Investment in GDP",(sum(ref.I_value)/ref.GDP)*(I_qLasp-1)*100];.. 
["Exports in GDP", (sum(ref.X_value)/ref.GDP)*(X_qLasp-1)*100];.. 
["Imports in GDP", (sum(ref.M_value)/ref.GDP)*(M_qLasp-1)*100];.. 
["Imports/Domestic production ratio",(M_Y_Ratio_qLasp-1)*100];.. 
["Imports of Non Energy goods in volume", (divide(sum(Out.M(Indice_NonEnerSect,:)), sum(ref.M(Indice_NonEnerSect,:)),%nan ) -1)*100 ];.. 
["Exports of Non Energy goods in volume", (divide(sum(Out.X(Indice_NonEnerSect,:)), sum(ref.X(Indice_NonEnerSect,:)),%nan ) -1)*100 ];.. 
["Total Employment", (evol_ref.Labour_tot-1)*100];.. 
["Unemployment rate (% points)", Out.u_tot - ref.u_tot];.. 
["Net-of-tax wages", (Out.NetWage_variation-1)*100];.. 
["Labour Intensity (Laspeyres)",(lambda_pLasp-1)*100];.. 
["Labour tax rate (% points)", - Labour_Tax_Cut];.. 
["Kappa Intensity (Laspeyres)",(kappa_pLasp-1)*100];..  
["Energy Input Price (Laspeyres)", (IC_Ener_pLasp-1)*100];.. 
["Energy Intensity (Laspeyres)", (alpha_Ener_qLasp-1)*100];.. 
["Energy cost share for non-energetic sector", (evol_ref.ENshareNONEner-1)*100 ];.. 
["Production Price (Laspeyres)", (Y_pLasp-1)*100];.. 
["Production Price Energy goods (Laspeyres)", (Y_En_pLasp-1)*100];.. 
["Production Price Non Energy goods (Laspeyres)", (Y_NonEn_pLasp-1)*100];.. 
["Consumption Price for HH of Non Energy goods (Laspeyres)", (C_NonEn_pLasp-1)*100];.. 
["Real Households consumption (Laspeyres)", (C_qLasp-1)*100];.. 
["	Energy in Households consumption", ref.Ener_C_ValueShare*(C_En_qLasp-1)*100];.. 
["	Non Energy goods in Households consumption", ref.NonEner_C_ValueShare*(C_NonEn_qLasp-1)*100];.. 
["Public Deficits", (evol_ref.NetLendingGov-1)*100];.. 
["Country Deficits /GDP", (evol_ref.NetLendingRoW_GDP-1)*100];.. 
["Total Emissions", (evol_ref.DOM_CO2-1)*100];.. 
["Total Taxes", (evol_ref.Total_taxes-1)*100];.. 
["Households Energy Bills", (evol_ref.HH_EnBill-1)*100];.. 
["Firms Energy Bills", (evol_ref.Corp_EnBill-1)*100];.. 
["Households Energy Conso", (evol_ref.HH_EnConso-1)*100];.. 
["Firms Energy Conso", (evol_ref.Corp_EnConso-1)*100];.. 
["",""];.. 
["Most sensitif import Elasticity for NonEner",max(sigma_M(Indice_NonEnerSect))];.. 
[" Most sensitif export Elasticity for NonEner ",max(sigma_X(Indice_NonEnerSect))];.. 
[" Global mean wage/Unemployment Elasticity",sigma_omegaU]
]; 

OutputTable("MacroTExtended_Ratio_"+ref_name) = [
["Macro results", "Ratio/"+ref_name];..
["GDP (Laspeyres)", GDP_qLasp];.. 
["Households consumption in GDP",(sum(ref.C_value)/ref.GDP) * C_qLasp];.. 
["Investment in GDP",(sum(ref.I_value)/ref.GDP) * I_qLasp];.. 
["Public consumption in GDP", (sum(ref.G_value)/ref.GDP) * G_qLasp];.. 
["Exports in GDP", (sum(ref.X_value)/ref.GDP) * X_qLasp];.. 
["Imports in GDP", (sum(ref.M_value)/ref.GDP) * M_qLasp];.. 
["Imports/Domestic production ratio",M_Y_Ratio_qLasp];.. 
["Imports of Non Energy goods in volume", divide(sum(Out.M(Indice_NonEnerSect,:)), sum(ref.M(Indice_NonEnerSect,:)),%nan )];.. 
["Exports of Non Energy goods in volume", divide(sum(Out.X(Indice_NonEnerSect,:)), sum(ref.X(Indice_NonEnerSect,:)),%nan )];.. 
["Total Employment", divide(Out.Labour_tot, ref.Labour_tot, %nan)];.. 
["Unemployment rate", Out.u_tot/ref.u_tot ];.. 
["Labour Intensity (Laspeyres)",lambda_pLasp];.. 
["Kappa Intensity (Laspeyres)",kappa_pLasp];..  
["Energy Input Price (Laspeyres)", IC_Ener_pLasp];.. 
["Energy Intensity (Laspeyres)", alpha_Ener_qLasp];.. 
["Energy cost share for non-energetic sector", evol_ref.ENshareNONEner];.. 
["Production Price (Laspeyres)", Y_pLasp];.. 
["Production Price Energy goods (Laspeyres)", Y_En_pLasp];.. 
["Production Price Non Energy goods (Laspeyres)", Y_NonEn_pLasp];.. 
["Consumption Price for HH of Non Energy goods (Laspeyres)", C_NonEn_pLasp];.. 
["Real Households consumption (Laspeyres)", C_qLasp];.. 
[" Energy in Households consumption", C_En_qLasp];.. 
[" Non Energy goods in Households consumption", C_NonEn_qLasp];.. 
["Public Deficits", evol_ref.NetLendingGov];.. 
["Country Deficits /GDP", evol_ref.NetLendingRoW_GDP];.. 
["Total Emissions", evol_ref.DOM_CO2];.. 
["Total Taxes", evol_ref.Total_taxes];.. 
["Households Energy Bills", evol_ref.HH_EnBill];.. 
["Firms Energy Bills", evol_ref.Corp_EnBill];.. 
["Households Energy Conso", evol_ref.HH_EnConso];.. 
["Firms Energy Conso", evol_ref.Corp_EnConso];.. 
];

OutputTable("MacroT_Abs_"+Name_time) = [
["Macro results", Name_time];..
["Nominal", money_disp_unit + money];..
["GDP Nominal", Out.GDP];.. 
["Households consumption",sum(Out.C_value)];.. 
["Investment",sum(Out.I_value)];.. 
["Public consumption", sum(Out.G_value)];.. 
["Exports", sum(Out.X_value)];.. 
["Imports", sum(Out.M_value)];.. 
["Imports/Domestic production ratio",sum(Out.M)./sum(Out.Y)];.. 
["Imports of Non Energy goods in volume",sum(Out.M(Indice_NonEnerSect,:))];.. 
["Exports of Non Energy goods in volume", sum(Out.X(Indice_NonEnerSect,:))];.. 
["Total Employment", Out.Labour_tot];.. 
["Unemployment rate", Out.u_tot];.. 
["Energy cost share for non-energetic sector", Out.ENshareNONEner];.. 
["Public Deficits", Out.NetLendingGov];.. 
["Country Deficits /GDP", Out.NetLendingRoW_GDP];.. 
["Total Emissions", Out.DOM_CO2];.. 
["Total Taxes", Out.Total_taxes];.. 
["Households Energy Bills", Out.HH_EnBill];.. 
["Firms Energy Bills", Out.Corp_EnBill];.. 
["Households Energy Conso", Out.HH_EnConso];.. 
["Firms Energy Conso", Out.Corp_EnConso];.. 
];

//// Equity table at macro level
OutputTable("Equity_"+Name_time) = [
["Variables", 														"values_"+Name_time												];..
["Recycling revenues options", Recycling_Option 																					];..
["Carbon Tax rate", (Out.Carbon_Tax_rate*eval(money_unit_data))/10^6+ money+"/tCO2" 											];..
[ "Carbon Tax proceeds to lump-sum transfers in %", 100*divide(sum(Out.ClimPolicyCompens(Indice_Households)),sum(Out.Carbon_Tax),%nan)	];..
["Total CO2 emissions %/"+ref_name, 							(evol_ref.DOM_CO2-1)*100											];..
["GDP Decomposition Laspeyres Quantities", 					""																	];..
["Real GDP LaspQ ratio/"+ref_name,								GDP_qLasp															];..
["GDP Decomp - C",												(sum(ref.C_value)/ref.GDP) * C_qLasp							];..
["GDP Decomp - G",												(sum(ref.G_value)/ref.GDP) * G_qLasp							];..
["GDP Decomp - I",												(sum(ref.I_value)/ref.GDP) * I_qLasp							];..
["GDP Decomp - X",												(sum(ref.X_value)/ref.GDP) * X_qLasp							];..
["GDP Decomp - M",												(sum(ref.M_value)/ref.GDP) * M_qLasp							];..
["---Real terms at "+money_disp_unit+money+" "+ref_name+"---", ""																];..
["Real C pFish",													money_disp_adj.*sum(Out.C_value)/C_pFish						];..
["Real G pFish",													money_disp_adj.*sum(Out.G_value)/G_pFish						];..
["Real I pFish",													money_disp_adj.*sum(Out.I_value)/I_pFish							];..
["---Nominal values at "+money_disp_unit+money+"---",		 	""																];..
["Nominal GDP",		  											money_disp_adj.*sum(Out.GDP)										];..
["Nominal C",			  											money_disp_adj.*sum(Out.C_value)									];..
["Nominal G",														money_disp_adj.*sum(Out.G_value)									];..
["Labour "+Labour_unit+" ratio/"+ref_name,						evol_ref.Labour_tot												];..
["Labour "+Labour_unit,											Out.Labour_tot														];..
["Labour intensity of non-energy goods ratio/"+ref_name,			(lambda_NonEn_pLasp)                                       ];..
["Production price of non-energy goods ratio/"+ref_name,			(Y_NonEn_pLasp)                                             ];..
["---Households Quantities Fisher Index ---",					""																	];..
["Total Consumption ratio/"+ref_name,							(C_qFish)                                                    ];..
   ];

if nb_Households == 10
OutputTable("Equity_"+Name_time) = [OutputTable("Equity_"+Name_time);
["Poor (F0-10)",												(QInd_Fish( ref.pC, ref.C, Out.pC, Out.C, :, 1))];..
["Lower class (F10-30)",										(QInd_Fish( ref.pC, ref.C, Out.pC, Out.C, :, 2:3))];..
["Middle class (F30-70)",									(QInd_Fish( ref.pC, ref.C, Out.pC, Out.C, :, 4:7))];..
["Upper class (F70-90)",										(QInd_Fish( ref.pC, ref.C, Out.pC, Out.C, :, 8:9))];..
["Rich (F90-100)",											(QInd_Fish( ref.pC, ref.C, Out.pC, Out.C, :, 10))];..
];
end

if nb_Households <> 1
OutputTable("Equity_"+Name_time) = [OutputTable("Equity_"+Name_time);
["Gini index HH consumption pFish in %",			(1 - sum(Gini_indicator(sum(Out.C_value,"r")./HH_pFish,Out.Population)))*100];..
];
end

if nb_Households == 10
OutputTable("Equity_"+Name_time) = [OutputTable("Equity_"+Name_time);
["Share of HH Disposable Income in %pts/"+ref_name,														" "];..
["Poor (F0-10)",							100*(Out.H_disposable_income(1)/sum(Out.H_disposable_income)-ref.H_disposable_income(1)/sum(ref.H_disposable_income))];..
["Lower class (F10-30)",				    100*(sum(Out.H_disposable_income(2:3))/sum(Out.H_disposable_income)-sum(ref.H_disposable_income(2:3))/sum(ref.H_disposable_income))];..
["Middle class (F30-70)",				100*(sum(Out.H_disposable_income(4:7))/sum(Out.H_disposable_income)-sum(ref.H_disposable_income(4:7))/sum(ref.H_disposable_income))];..
["Upper class (F70-90)",					100*(sum(Out.H_disposable_income(8:9))/sum(Out.H_disposable_income)-sum(ref.H_disposable_income(8:9))/sum(ref.H_disposable_income))];..
["Rich (F90-100)",				100*(Out.H_disposable_income(10)/sum(Out.H_disposable_income)-ref.H_disposable_income(10)/sum(ref.H_disposable_income))];..
 ];
end

 if and(nb_Households <> [10,1]) 
OutputTable("Equity_"+Name_time) = [OutputTable("Equity_"+Name_time);
["Share of HH Disposable Income in %pts/"+ref_name,														" "];..
["Disposable Income"+"Class HH"+(1:nb_Households)',		(100*(Out.H_disposable_income./sum(Out.H_disposable_income)-ref.H_disposable_income./sum(ref.H_disposable_income)))'];..
["C_pFish "+"Class HH"+(1:nb_Households)',HH_pFish'];..
 ];
end

if nb_Households <> 1
OutputTable("Equity_"+Name_time) = [OutputTable("Equity_"+Name_time);
["Gini index on HH Disposable Income",	(1 - sum(Gini_indicator(Out.H_disposable_income,Out.Population)))*100];..
];
 end
 
/////////////Sectoral tables

OutputTable("CompSectTable_"+ref_name) = [["Variation (%)", Index_Sectors']; ["Production Price", ((divide(Out.pY , ref.pY , %nan )-1)*100)']; ["Real Households consumption_"+Index_Households , ((divide(Out.C , ref.C , %nan )-1)*100)']; ["Exports in volume", ((divide(Out.X , ref.X , %nan )-1)*100)'];["Imports in volume", ((divide(Out.M , ref.M, %nan )-1)*100)'];["Trade balance ",((divide((Out.X_value' - Out.M_value),(ref.X_value' - ref.M_value),%nan))-1)*100]; ["Energy Cost share variation", (evol_ref.ENshare-1)*100 ]; [ " Energy/Labour cost variation" , (evol_ref.ShareEN_Lab-1)*100]; ["Labour", (divide(Out.Labour , ref.Labour, %nan )-1)*100]; ["Unitary Labour Cost variation", (evol_ref.Unit_Labcost-1)*100]; ["Net nominal wages", (divide(Out.w , ref.w, %nan )-1)*100]; ["Net real wages (Consumer Price Index)", (((Out.w./CPI)./(ref.w./ref.CPI))-1)*100];["Purchasing power of wages_"+Index_Households, divide((ones(nb_Households,1).*.Out.w)./Out.pC' , (ones(nb_Households,1).*.ref.w)./ref.pC', %nan )]];

OutputTable.CompSectTable($+1,1)=  "Carbon Taxe rate";
OutputTable.CompSectTable($,2)=  [(parameters.Carbon_Tax_rate*eval(money_unit_data))/10^6+ money+"/tCO2"];
OutputTable.CompSectTable($+1,1)=  "Revenue-reclycling option";
OutputTable.CompSectTable($,2)=  [DispLabTabl] ;


//// Comparaison intersectorielle des echanges 
// OutputTable("Trade_Sect_"+ref_name) =  [["Variable/Sectoral value", Index_Sectors']; ["Households consumption Nominal 0", round(sum(ref.C_value,"c")'/10^5)/10 ]; ["Households consumption Nominal 1", round(sum(Out.C_value,"c")'/10^5)/10 ]; ["HPrice Index (Paasche)", (sum(Out.C_value,"c")'./(ref.pC'.*Out.C'))]; [ "Households consumption Real 1 (G€)",round((ref.pC'.*Out.C')/10^5)./10];["Households consumption Nominal 0 %share", (round(sum(ref.C_value,"c")'/sum(ref.C_value')*10000)/100) ];["Households consumption Nominal 1 share(%)", (round(sum(Out.C_value,"c")'/sum(Out.C_value')*10000)/100) ];["Real Households consumption 1 share(%)", round(((ref.pC'.*Out.C')./sum((ref.pC'.*Out.C')))*10000)./100];
// ["Government consumption Nominal 0", round(ref.G_value'/10^5)/10 ]; ["Government consumption Nominal 1", round(Out.G_value'/10^5)/10 ];  ["G Price Index (Paasche)", (Out.G_value'./(ref.pG'.*Out.G'))]; [ "Government consumption Real 1 (G€)",round((ref.pG'.*Out.G')/10^5)./10];["Government consumption Nominal 0 %share", (round(ref.G_value'/sum(ref.G_value')*10000)/100) ];["Government consumption Nominal 1 share(%)", (round(Out.G_value'/sum(Out.G_value')*10000)/100) ];["Real Government consumption 1 share(%)", round(((ref.pG'.*Out.G')./sum((ref.pG'.*Out.G')))*10000)./100];
// ["Investment Nominal 0", round(ref.I_value'/10^5)/10 ]; ["Investment Nominal 1", round(Out.I_value'/10^5)/10 ];  ["I Price Index (Paasche)", (Out.I_value'./(ref.pI'.*Out.I'))]; [ "Investment Real 1 (G€)",round((ref.pI'.*Out.I')/10^5)./10];["Investment Nominal 0 %share", (round(ref.I_value'/sum(ref.I_value')*10000)/100) ];["Investment Nominal 1 share(%)", (round(Out.I_value'/sum(Out.I_value')*10000)/100) ];["Real Investment 1 share(%)", round(((ref.pI'.*Out.I')./sum((ref.pI'.*Out.I')))*10000)./100];
// ["Exports Nominal 0", round(ref.X_value'/10^5)/10 ]; ["Exports Nominal 1", round(Out.X_value'/10^5)/10 ];  ["X Price Index (Paasche)", (Out.X_value'./(ref.pX'.*Out.X'))]; [ "Exports Real 1 (G€)",round((ref.pX'.*Out.X')/10^5)./10];["Exports Nominal 0 share(%)", (round(ref.X_value'/sum(ref.X_value')*10000)/100) ];["Exports Nominal 1 share(%)", (round(Out.X_value'/sum(Out.X_value')*10000)/100) ];["Real Exports 1 share(%)", round(((ref.pX'.*Out.X')./sum((ref.pX'.*Out.X')))*10000)./100];
// ["Imports Nominal 0", round(ref.M_value/10^5)/10 ]; ["Imports Nominal 1", round(Out.M_value/10^5)/10 ];  ["M Price Index (Paasche)", (Out.M_value./(ref.pM'.*Out.M'))]; [ "Imports Real 1 (G€)",round((ref.pM'.*Out.M')/10^5)./10]; ["Imports Nominal 0 share(%)", (round(ref.M_value/sum(ref.M_value)*10000)/100) ];["Imports Nominal 1 share(%)", (round(Out.M_value/sum(Out.M_value)*10000)/100) ]] ; 

OutputTable("Trade_Sect_"+ref_name) =  [["Variable/Sectoral value", Index_Sectors']; ["Households consumption Nominal 0", round(sum(ref.C_value,"c")'/10^5)/10 ]; ["Households consumption Nominal 1", round(sum(Out.C_value,"c")'/10^5)/10 ]; ["HPrice Index (Paasche)", divide(sum(Out.C_value,"c")',sum(ref.pC.*Out.C,"c")',%nan)]; [ "Households consumption Real 1 (G€)",round(sum(ref.pC.*Out.C,"c")'/10^5)./10];
["Government consumption Nominal 0", round(ref.G_value'/10^5)/10 ]; ["Government consumption Nominal 1", round(Out.G_value'/10^5)/10 ];  ["G Price Index (Paasche)", (divide(Out.G_value',(ref.pG'.*Out.G'),%nan))]; [ "Government consumption Real 1 (G€)",round((ref.pG'.*Out.G')/10^5)./10];
["Investment Nominal 0", round(sum(ref.I_value,"c")'/10^5)/10 ]; ["Investment Nominal 1", round(sum(Out.I_value,"c")'/10^5)/10 ];  ["I Price Index (Paasche)", divide(sum(Out.I_value,"c")',(ref.pI)'.*(sum(Out.I,"c")'),%nan)]; [ "Investment Real 1 (G€)",round((ref.pI'.*sum(Out.I,"c")')/10^5)./10];
["Exports Nominal 0", round(ref.X_value'/10^5)/10 ]; ["Exports Nominal 1", round(Out.X_value'/10^5)/10 ];  ["X Price Index (Paasche)", (Out.X_value'./(((ref.pX'.*Out.X')>%eps).*(ref.pX'.*Out.X') + ((ref.pX'.*Out.X')<%eps)))]; [ "Exports Real 1 (G€)",round((ref.pX'.*Out.X')/10^5)./10];
["Imports Nominal 0", round(ref.M_value/10^5)/10 ]; ["Imports Nominal 1", round(Out.M_value/10^5)/10 ];  ["M Price Index (Paasche)", (Out.M_value./(((ref.pM'.*Out.M')>%eps).*(ref.pM'.*Out.M') + ((ref.pM'.*Out.M')<%eps)))]; [ "Imports Real 1 (G€)",round((ref.pM'.*Out.M')/10^5)./10]] ; 



OutputTable("Trade_Sect_Share_"+ref_name)  =  [["Variable/Sectoral value", Index_Sectors']; ["Households consumption Nominal 0 %share", (round(sum(ref.C_value,"c")'/sum(ref.C_value')*10000)/100) ];["Government consumption Nominal 0 %share", (round(ref.G_value'/sum(ref.G_value')*10000)/100) ];["Investment Nominal 0 %share", (round(sum(ref.I_value,"c")'/sum(ref.I_value')*10000)/100) ];["Exports Nominal 0 share(%)", (round(ref.X_value'/sum(ref.X_value')*10000)/100) ]; ["Imports Nominal 0 share(%)", (round(ref.M_value/sum(ref.M_value)*10000)/100) ];] ; 


OutputTable("EnerNonEnTable_"+ref_name) = [["Ratio", "Primary Energy", "Final Energy", "Non-energy goods"];["Production Price (Laspeyres)", (Y_PrimEn_pLasp-1)*100, (Y_FinEn_pLasp-1)*100, (Y_NonEn_pLasp-1)*100 ]; ["Real Households consumption (Laspeyres)", (C_PrimEn_qLasp-1)*100, (C_FinEn_qLasp-1)*100, (C_NonEn_qLasp-1)*100 ]; ["Exports in volume", (divide(sum(Out.X(Indice_PrimEnerSect,:)), sum(ref.X(Indice_PrimEnerSect,:)),%nan )-1)*100, (divide(sum(Out.X(Indice_FinEnerSect,:)), sum(ref.X(Indice_FinEnerSect,:)),%nan )-1)*100 , (divide(sum(Out.X(Indice_NonEnerSect,:)), sum(ref.X(Indice_NonEnerSect,:)),%nan ) -1)*100 ];["Imports in volume", (divide(sum(Out.M(Indice_PrimEnerSect,:)), sum(ref.M(Indice_PrimEnerSect,:)),%nan)-1)*100, (divide(sum(Out.M(Indice_FinEnerSect,:)), sum(ref.M(Indice_FinEnerSect,:)),%nan )-1)*100 , (divide(sum(Out.M(Indice_NonEnerSect,:)), sum(ref.M(Indice_NonEnerSect,:)),%nan )-1)*100 ]];

OutputTable.EnerNonEnTable($+1,1)=  "Carbon Taxe rate";
OutputTable.EnerNonEnTable($,2)=  [[(parameters.Carbon_Tax_rate*eval(money_unit_data))/10^6+ money+"/tCO2"]];
OutputTable.EnerNonEnTable($+1,1)=  "Revenue-reclycling option";
OutputTable.EnerNonEnTable($,2)=  [DispLabTabl] ;

if (Out.pX ./ ref.pX ) <> 1 
    OutputTable("Elasticities"+ref_name) = [ ["Elasticities" , Index_Sectors'];["Exports Price" , ((divide(Out.X , ref.X, %nan) - 1) ./ ((Out.pX ./ ref.pX) - 1))' ]; ["Exports - pX/pM ration" , ((divide(Out.X , ref.X , %nan) - 1) ./ (((Out.pX./Out.pM) ./ (ref.pX./ref.pM) ) - 1))' ];["Import/Output ratio" ,((divide(Out.M , Out.Y , %nan) ./ divide(ref.M , ref.Y , %nan) - 1) ./ ((Out.pM./Out.pY) ./ (ref.pM./ref.pY) - 1))']];
    OutputTable.Elasticities($+1,1)=  "Carbon Taxe rate";
    OutputTable.Elasticities($,2)=  [[(parameters.Carbon_Tax_rate*eval(money_unit_data))/10^6+ money+"/tCO2"]];
    OutputTable.Elasticities($+1,1)=  "Revenue-reclycling option";
    OutputTable.Elasticities($,2)=  [DispLabTabl] ;
end


if Output_files
if OutputfilesBY
csvWrite(OutputTable("MacroT_"+ref_name),SAVEDIR+"TableMacro_"+ref_name+"_"+Name_time+"_"+simu_name+".csv", ';');
csvWrite(OutputTable("MacroTExtend_evol_"+ref_name),SAVEDIR+"TableMacroExtended_"+ref_name+"_"+Name_time+"_"+simu_name+".csv", ';');
csvWrite(OutputTable("MacroTExtended_Ratio_"+ref_name),SAVEDIR+"TableMacroRatio"+ref_name+"_"+Name_time+"_"+simu_name+".csv", ';');
csvWrite(OutputTable("MacroT_Abs_"+Name_time) ,SAVEDIR+"TableMacro_Abs_"+ref_name+"_"+simu_name+".csv", ';');
csvWrite(OutputTable("Equity_"+Name_time) ,SAVEDIR+"TableMacro_Equity_"+ref_name+"_"+Name_time+"_"+simu_name+".csv", ';');
csvWrite(OutputTable("CompSectTable_"+ref_name),SAVEDIR+"TableSectOutput_"+ref_name+"_"++Name_time+"_"+simu_name+".csv", ';');
csvWrite(OutputTable("EnerNonEnTable_"+ref_name),SAVEDIR+"TableENnonEnOutput_"+ref_name+"_"+Name_time+"_"+simu_name+".csv", ';');
// csvWrite(OutputTable("Elasticities_"+ref_name),SAVEDIR+"TableElasticities_"+Name_time+"_"+simu_name+".csv", ';');
// csvWrite(OutputTable("GDP_decom_"+ref_name),SAVEDIR+"GDP_decom_"+Name_time+"_"+simu_name+".csv", ';');
csvWrite(OutputTable.GDP_decomBIS,SAVEDIR+"GDP_decomBIS_"+ref_name+"_"+Name_time+"_"+simu_name+".csv", ';');
csvWrite(OutputTable("Trade_Sect_"+ref_name),SAVEDIR+"Trade_Sect_"+ref_name+"_"+Name_time+"_"+simu_name+".csv", ';');
csvWrite(OutputTable("Trade_Sect_Share_"+ref_name),SAVEDIR+"Trade_Sect_Share_"+ref_name+"_"+Name_time+"_"+simu_name+".csv", ';');
csvWrite([Index_Sectors,Out.Capital_consumption'],SAVEDIR+"Capital_Cons_"+ref_name+"_"+Name_time+"_"+simu_name+".csv", ';');


elseif ~OutputfilesBY
csvWrite(OutputTable("MacroT_"+ref_name),SAVEDIR_INIT+"TableMacro_"+ref_name+"_"+Name_time+"_"+simu_name+".csv", ';');
csvWrite(OutputTable("MacroTExtend_evol_"+ref_name),SAVEDIR_INIT+"TableMacroExtended_"+ref_name+"_"+Name_time+"_"+simu_name+".csv", ';');
csvWrite(OutputTable("MacroTExtended_Ratio_"+ref_name),SAVEDIR_INIT+"TableMacroRatio"+ref_name+"_"+Name_time+"_"+simu_name+".csv", ';');
csvWrite(OutputTable("MacroT_Abs_"+Name_time) ,SAVEDIR_INIT+"TableMacro_Abs_"+ref_name+"_"+Name_time+"_"+simu_name+".csv", ';');
csvWrite(OutputTable("Equity_"+Name_time) ,SAVEDIR_INIT+"TableMacro_Equity_"+ref_name+"_"+Name_time+"_"+simu_name+".csv", ';');
csvWrite([Index_Sectors,Out.Capital_consumption'],SAVEDIR_INIT+"Capital_Cons_"+ref_name+"_"+Name_time+"_"+simu_name+".csv", ';');

end
end


/////////////////////////  /////////////////////////  /////////////////////////
////// Specific calcul for distinct AGG_type 
/////////////////////////  /////////////////////////  /////////////////////////

if AGG_type == "AGG_IndEner"

    /////////////////////////	
    /// Aggregation of Metals  (Steel_Iron + NonFerrousMetals)
    /////////////////////////
    ini.Synthese_CO2_EN_Tax = [["2010","Energy sectors","Industries","Rest of the Economy","Households"]; ["Energy consumption (ktoe) without fuels",sum(ini.IC(Indice_EnerSect_WithoutF,Indice_EnerSect)),sum(ini.IC(Indice_EnerSect_WithoutF,Indice_IndustHeavy)),sum(ini.IC(Indice_EnerSect_WithoutF,Indice_RestOfEconomy)),sum(ini.C(Indice_EnerSect_WithoutF,:))];["Energy consumption (ktoe) of fuels",sum(ini.IC(Indice_FuelProd,Indice_EnerSect)),sum(ini.IC(Indice_FuelProd,Indice_IndustHeavy)),sum(ini.IC(Indice_FuelProd,Indice_RestOfEconomy)),sum(ini.C(Indice_FuelProd,:))];["CO2 Emissions (MtCO2)",sum(ini.CO2Emis_IC(Indice_EnerSect,Indice_EnerSect)),sum(ini.CO2Emis_IC(Indice_EnerSect,Indice_IndustHeavy)),sum(ini.CO2Emis_IC(Indice_EnerSect,Indice_RestOfEconomy)),sum(ini.CO2Emis_C(Indice_EnerSect,:))];["Carbon tax (k"+money+")",sum(ini.Carbon_Tax_IC(Indice_EnerSect,Indice_EnerSect)),sum(ini.Carbon_Tax_IC(Indice_EnerSect,Indice_IndustHeavy)),sum(ini.Carbon_Tax_IC(Indice_EnerSect,Indice_RestOfEconomy)),sum(ini.Carbon_Tax_C(Indice_EnerSect,:))];["Energy tax (k"+money+")", sum(ini.Energy_Tax_IC(Indice_EnerSect))+sum(ini.Energy_Tax_FC(Indice_EnerSect)),sum(ini.Energy_Tax_IC(Indice_IndustHeavy))+sum(ini.Energy_Tax_FC(Indice_IndustHeavy)),sum(ini.Energy_Tax_IC(Indice_RestOfEconomy))+sum(ini.Energy_Tax_FC(Indice_RestOfEconomy)),"-"]];
    

    Out.Synthese_CO2_EN_Tax = [["run","Energy sectors","Industries","Rest of the Economy","Households"]; ["Energy consumption (ktoe) without fuels",sum(Out.IC(Indice_EnerSect_WithoutF,Indice_EnerSect)),sum(Out.IC(Indice_EnerSect_WithoutF,Indice_IndustHeavy)),sum(Out.IC(Indice_EnerSect_WithoutF,Indice_RestOfEconomy)),sum(Out.C(Indice_EnerSect_WithoutF,:))];["Energy consumption (ktoe) of fuels",sum(Out.IC(Indice_FuelProd,Indice_EnerSect)),sum(Out.IC(Indice_FuelProd,Indice_IndustHeavy)),sum(Out.IC(Indice_FuelProd,Indice_RestOfEconomy)),sum(Out.C(Indice_FuelProd,:))];["CO2 Emissions (MtCO2)",sum(Out.CO2Emis_IC(Indice_EnerSect,Indice_EnerSect)),sum(Out.CO2Emis_IC(Indice_EnerSect,Indice_IndustHeavy)),sum(Out.CO2Emis_IC(Indice_EnerSect,Indice_RestOfEconomy)),sum(Out.CO2Emis_C(Indice_EnerSect,:))];["Carbon tax (k"+money+")",sum(Out.Carbon_Tax_IC(Indice_EnerSect,Indice_EnerSect)),sum(Out.Carbon_Tax_IC(Indice_EnerSect,Indice_IndustHeavy)),sum(Out.Carbon_Tax_IC(Indice_EnerSect,Indice_RestOfEconomy)),sum(Out.Carbon_Tax_C(Indice_EnerSect,:))];["Energy tax (k"+money+")", sum(Out.Energy_Tax_IC(Indice_EnerSect))+sum(Out.Energy_Tax_FC(Indice_EnerSect)),sum(Out.Energy_Tax_IC(Indice_IndustHeavy))+sum(Out.Energy_Tax_FC(Indice_IndustHeavy)),sum(Out.Energy_Tax_IC(Indice_RestOfEconomy))+sum(Out.Energy_Tax_FC(Indice_RestOfEconomy)),"-"]];
	
    evol.Synthese_CO2_EN_Tax = [["evol in/year before %","Energy sectors","Industries","Rest of the Economy","Households"]; ["Energy consumption (ktoe) without fuels",(divide(sum(Out.IC(Indice_EnerSect_WithoutF,Indice_EnerSect)),sum(ini.IC(Indice_EnerSect_WithoutF,Indice_EnerSect)),%nan)-1)*100,(divide(sum(Out.IC(Indice_EnerSect_WithoutF,Indice_IndustHeavy)),sum(ini.IC(Indice_EnerSect_WithoutF,Indice_IndustHeavy)),%nan)-1)*100,(divide(sum(Out.IC(Indice_EnerSect_WithoutF,Indice_RestOfEconomy)),sum(ini.IC(Indice_EnerSect_WithoutF,Indice_RestOfEconomy)),%nan)-1)*100,(divide(sum(Out.C(Indice_EnerSect_WithoutF,:)),sum(ini.C(Indice_EnerSect_WithoutF,:)),%nan)-1)*100];["Energy consumption (ktoe) of fuels",(divide(sum(Out.IC(Indice_FuelProd,Indice_EnerSect)),sum(ini.IC(Indice_FuelProd,Indice_EnerSect)),%nan)-1)*100,(divide(sum(Out.IC(Indice_FuelProd,Indice_IndustHeavy)),sum(ini.IC(Indice_FuelProd,Indice_IndustHeavy)),%nan)-1)*100,(divide(sum(Out.IC(Indice_FuelProd,Indice_RestOfEconomy)),sum(ini.IC(Indice_FuelProd,Indice_RestOfEconomy)),%nan)-1)*100,(divide(sum(Out.C(Indice_FuelProd,:)),sum(ini.C(Indice_FuelProd,:)),%nan)-1)*100];["CO2 Emissions (MtCO2)",(divide(sum(Out.CO2Emis_IC(Indice_EnerSect,Indice_EnerSect)),sum(ini.CO2Emis_IC(Indice_EnerSect,Indice_EnerSect)),%nan)-1)*100,(divide(sum(Out.CO2Emis_IC(Indice_EnerSect,Indice_IndustHeavy)),sum(ini.CO2Emis_IC(Indice_EnerSect,Indice_IndustHeavy)),%nan)-1)*100,(divide(sum(Out.CO2Emis_IC(Indice_EnerSect,Indice_RestOfEconomy)),sum(ini.CO2Emis_IC(Indice_EnerSect,Indice_RestOfEconomy)),%nan)-1)*100,(divide(sum(Out.CO2Emis_C(Indice_EnerSect,:)),sum(ini.CO2Emis_C(Indice_EnerSect,:)),%nan)-1)*100];["Carbon tax (k"+money+")",(divide(sum(Out.Carbon_Tax_IC(Indice_EnerSect,Indice_EnerSect)),sum(ini.Carbon_Tax_IC(Indice_EnerSect,Indice_EnerSect)),%nan)-1)*100,(divide(sum(Out.Carbon_Tax_IC(Indice_EnerSect,Indice_IndustHeavy)),sum(ini.Carbon_Tax_IC(Indice_EnerSect,Indice_IndustHeavy)),%nan)-1)*100,(divide(sum(Out.Carbon_Tax_IC(Indice_EnerSect,Indice_RestOfEconomy)),sum(ini.Carbon_Tax_IC(Indice_EnerSect,Indice_RestOfEconomy)),%nan)-1)*100,(divide(sum(Out.Carbon_Tax_C(Indice_EnerSect,:)),sum(ini.Carbon_Tax_C(Indice_EnerSect,:)),%nan)-1)*100];["Energy tax (k"+money+")", (divide(sum(Out.Energy_Tax_IC(Indice_EnerSect))+sum(Out.Energy_Tax_FC(Indice_EnerSect)),sum(ini.Energy_Tax_IC(Indice_EnerSect))+sum(ini.Energy_Tax_FC(Indice_EnerSect)),%nan)-1)*100,(divide(sum(Out.Energy_Tax_IC(Indice_IndustHeavy))+sum(Out.Energy_Tax_FC(Indice_IndustHeavy)),sum(ini.Energy_Tax_IC(Indice_IndustHeavy))+sum(ini.Energy_Tax_FC(Indice_IndustHeavy)),%nan)-1)*100,(divide(sum(Out.Energy_Tax_IC(Indice_RestOfEconomy))+sum(Out.Energy_Tax_FC(Indice_RestOfEconomy)),sum(ini.Energy_Tax_IC(Indice_RestOfEconomy))+sum(ini.Energy_Tax_FC(Indice_RestOfEconomy)),%nan)-1)*100,"-"]];

	if Output_files
	if OutputfilesBY
	csvWrite(ini.Synthese_CO2_EN_Tax,SAVEDIR+"Synthese_CO2_EN_Tax-ini_"+Name_time+"_"+simu_name+".csv", ';');
    csvWrite(Out.Synthese_CO2_EN_Tax,SAVEDIR+"Synthese_CO2_EN_Tax-run_"+Name_time+"_"+simu_name+".csv", ';');
    csvWrite(evol.Synthese_CO2_EN_Tax,SAVEDIR+"Synthese_CO2_EN_Tax-evol_"+Name_time+"_"+simu_name+".csv", ';');
	end
	end

    Met  = [ find( Index_Sectors== "Steel_Iron" ), find( Index_Sectors== "NonFerrousMetals" ) ];
    C_Met_qFish = QInd_Fish( ref.pC,ref.C, Out.pC, Out.C, Met, :);
    Y_Met_qFish = QInd_Fish( ref.pY,ref.Y, Out.pY, Out.Y, Met, :);
    pY_Met_pFish = PInd_Fish( ref.pY,ref.Y, Out.pY, Out.Y, Met, :);
    M_Met_qFish = QInd_Fish( ref.pM,ref.M, Out.pM, Out.M, Met, :);
    pM_Met_pFish = PInd_Fish( ref.pM,ref.M, Out.pM, Out.M, Met, :);
    X_Met_qFish = QInd_Fish( ref.pX,ref.X, Out.pX, Out.X, Met, :);
    pX_Met_pFish = PInd_Fish( ref.pX,ref.X, Out.pX, Out.X, Met, :);

    // Variations of macroeconomic identities in real terms at the aggregated level: Production = Private Consumption + Public Consumption + Investment + Exports - Imports

    // Initial value shares for each components of GDP
    ref.IC_Met_Prod_ValueShare	=  sum(ref.IC_value(Met,:))./sum(ref.Output_value(Met)) ;
    ref.C_Met_Prod_ValueShare	=  sum(ref.C_value(Met))   ./sum(ref.Output_value(Met)) ;
    ref.G_Met_Prod_ValueShare	=  sum(ref.G_value(Met))   ./sum(ref.Output_value(Met)) ;
    ref.I_Met_Prod_ValueShare	=  sum(ref.I_value(Met))   ./sum(ref.Output_value(Met)) ;
    ref.X_Met_Prod_ValueShare	=  sum(ref.X_value(Met))   ./sum(ref.Output_value(Met)) ;
    ref.M_Met_Prod_ValueShare	= -sum(ref.M_value(Met))   ./sum(ref.Output_value(Met)) ;

    // Laspeyres Quantity indices
    Y_qLasp  = QInd_Lasp( ref.pC, ref.C, Out.pC, Out.C, Met, :);	
    IC_Met_qLasp = QInd_Lasp( ref.pC, ref.C, Out.pC, Out.C, Met, :);
    G_Met_qLasp  = QInd_Lasp( ref.pG, ref.G, Out.pG, Out.G, Met, :);
    C_Met_qLasp  = QInd_Lasp( ref.pC, ref.C, Out.pC, Out.C, Met, :);
    I_Met_qLasp  = QInd_Lasp( ref.pI, ref.I, Out.pI, Out.I, Met, :);
    X_Met_qLasp  = QInd_Lasp( ref.pX, ref.X, Out.pX, Out.X, Met, :);
    M_Met_qLasp  = QInd_Lasp( ref.pM, ref.M, Out.pM, Out.M, Met, :);

    // Decomposition of variations for the second level macroeconomic identity
    IC_Met_Prod_qLasp = ref.IC_Met_Prod_ValueShare  .* IC_Met_qLasp ;
    C_Met_Prod_qLasp   = ref.C_Met_Prod_ValueShare  .*  C_Met_qLasp ;
    G_Met_Prod_qLasp   = ref.G_Met_Prod_ValueShare  .*  G_Met_qLasp ;
    I_Met_Prod_qLasp   = ref.I_Met_Prod_ValueShare  .*  I_Met_qLasp ;
    X_Met_Prod_qLasp   = ref.X_Met_Prod_ValueShare  .*  X_Met_qLasp ;
    M_Met_Prod_qLasp   = ref.M_Met_Prod_ValueShare  .*  M_Met_qLasp ;

    /////////////////////////
    /// Aggregation of Minerals  (Cement + Other Minerals)
    /////////////////////////

    Miner  = [ find( Index_Sectors== "Cement" ), find( Index_Sectors== "OthMin" ) ];
    C_Miner_qFish = QInd_Fish( ref.pC,ref.C, Out.pC, Out.C, Miner, :);
    Y_Miner_qFish = QInd_Fish( ref.pY,ref.Y, Out.pY, Out.Y, Miner, :);
    pY_Miner_pFish = PInd_Fish( ref.pY,ref.Y, Out.pY, Out.Y, Miner, :);
    M_Miner_qFish = QInd_Fish( ref.pM,ref.M, Out.pM, Out.M, Miner, :);
    pM_Miner_pFish = PInd_Fish( ref.pM,ref.M, Out.pM, Out.M, Miner, :);
    X_Miner_qFish = QInd_Fish( ref.pX,ref.X, Out.pX, Out.X, Miner, :);
    pX_Miner_pFish = PInd_Fish( ref.pX,ref.X, Out.pX, Out.X, Miner, :);

    // Variations of macroeconomic identities in real terms at the aggregated level: Production = Private Consumption + Public Consumption + Investment + Exports - Imports

    // Initial value shares for each components of GDP
    ref.IC_Miner_Prod_ValueShare	=  sum(ref.IC_value(Miner,:))./sum(ref.Output_value(Miner)) ;
    ref.C_Miner_Prod_ValueShare	 =  sum(ref.C_value(Miner))  ./sum(ref.Output_value(Miner)) ;
    ref.G_Miner_Prod_ValueShare	 =  sum(ref.G_value(Miner))  ./sum(ref.Output_value(Miner)) ;
    ref.I_Miner_Prod_ValueShare	 =  sum(ref.I_value(Miner))  ./sum(ref.Output_value(Miner)) ;
    ref.X_Miner_Prod_ValueShare	 =  sum(ref.X_value(Miner))  ./sum(ref.Output_value(Miner)) ;
    ref.M_Miner_Prod_ValueShare	 = -sum(ref.M_value(Miner))  ./sum(ref.Output_value(Miner)) ;

    // Laspeyres Quantity indices
    Y_Miner_qLasp  = QInd_Lasp( ref.pC, ref.C, Out.pC, Out.C, Miner, :);

    IC_Miner_qLasp = QInd_Lasp( ref.pC, ref.C, Out.pC, Out.C, Miner, :);
    C_Miner_qLasp  = QInd_Lasp( ref.pC, ref.C, Out.pC, Out.C, Miner, :);
    G_Miner_qLasp  = QInd_Lasp( ref.pG, ref.G, Out.pG, Out.G, Miner, :);
    I_Miner_qLasp  = QInd_Lasp( ref.pI, ref.I, Out.pI, Out.I, Miner, :);
    X_Miner_qLasp  = QInd_Lasp( ref.pX, ref.X, Out.pX, Out.X, Miner, :);
    M_Miner_qLasp  = QInd_Lasp( ref.pM, ref.M, Out.pM, Out.M, Miner, :);

    // Decomposition of variations for the second level macroeconomic identity
    IC_Met_Prod_qLasp = ref.IC_Miner_Prod_ValueShare  .* IC_Miner_qLasp ;
    C_Met_Prod_qLasp   = ref.C_Miner_Prod_ValueShare  .* C_Miner_qLasp ;
    G_Met_Prod_qLasp   = ref.G_Miner_Prod_ValueShare  .* G_Miner_qLasp ;
    I_Met_Prod_qLasp   = ref.I_Miner_Prod_ValueShare  .* I_Miner_qLasp ;
    X_Met_Prod_qLasp   = ref.X_Miner_Prod_ValueShare  .* X_Miner_qLasp ;
    M_Met_Prod_qLasp   = ref.M_Miner_Prod_ValueShare  .* M_Miner_qLasp ;

    /////////////////////////
    // Calcul des cost shares
    /////////////////////////

    ///// Energy cost share
    ref.ENshareMET = Cost_Share( sum(ref.IC_value(Indice_EnerSect,Met))  , sum(ref.Y_value(Met))) * 100;
    ref.ENshareMINER = Cost_Share( sum(ref.IC_value(Indice_EnerSect,Miner))  , sum(ref.Y_value(Miner))) * 100;
    Out.ENshareMET =  Cost_Share( sum(Out.IC_value(Indice_EnerSect,Met))  , sum(Out.Y_value(Met))) * 100;
    Out.ENshareMINER = Cost_Share( sum(Out.IC_value(Indice_EnerSect,Miner))  , sum(Out.Y_value(Miner))) * 100;
    evol_ref.ENshareMET = (divide(Out.ENshareMET , ref.ENshareMET , %nan ) -1)*100 ;
    evol_ref.ENshareMINER =(divide(Out.ENshareMINER , ref.ENshareMINER , %nan ) -1)*100 ;

    ///// Labour cost share
    // ref.Unit_LabcostMET = ref.pL_MET.*ref.lambdaMET);// pL agrégé et lambda agrégé à calculer
    // Out.Unit_LabcostMET = sum(Out.pL_MET.*Out.lambdaMET); // pL agrégé et lambda agrégé à calculer
    // evol_ref.Unit_LabcostMET = (divide(Out.Unit_LabcostMET,ref.Unit_LabcostMET,%nan) - 1) * 100 ;
    // ref.Unit_LabcostMINER = ref.pL_MINER.*ref.lambdaMINER  //pL agrégé et lambda agrégé à calculer
    // Out.Unit_LabcostMINER = Out.pL_MINER.*Out.lambdalambdaMINER; // pL agrégé et lambda agrégé à calculer
    // evol_ref.Unit_LabcostMINER = (divide(Out.Unit_LabcostMINER,ref.Unit_LabcostMINER,%nan) - 1) * 100 ;

    ///// Ratio Ener/Labour cost
    // ref.ShareEN_LabMET = ( sum(ref.pIC_MET(Indice_EnerSect).*ref.alphaMET(Indice_EnerSect),"r") ) ./ ref.Unit_LabcostMET ; // pIC agrégé et alpha agrégé à calculer
    // Out.ShareEN_LabMET = ( sum(Out.pIC_MET(Indice_EnerSect).*Out.alphaMET(Indice_EnerSect),"r") ) ./ Out.Unit_LabcostMET  ;
    // evol_ref.ShareEN_LabMET = (divide(Out.ShareEN_LabMET, ref.ShareEN_LabMET, %nan)-1) * 100 ; 
    // ref.ShareEN_LabMINER = ( sum(ref.pIC_MINER(Indice_EnerSect).*ref.alphaMINER(Indice_EnerSect),"r") ) ./ ref.Unit_LabcostMINER ; //// pIC agrégé et alpha agrégé à calculer
    // Out.ShareEN_LabMINER= ( sum(Out.pIC_MINER(Indice_EnerSect).*Out.alphaMINER(Indice_EnerSect),"r") ) ./ Out.Unit_LabcostMINER  ; //// pIC agrégé et alpha agrégé à calculer
    // evol_ref.ShareEN_LabMINER = (divide(Out.ShareEN_LabMINER, ref.ShareEN_LabMINER, %nan)-1) * 100 ;

    /////////////////////////
    // Calcul Trade intensity
    /////////////////////////

    ref.TradeIntMETMIN = TradeIntens([sum(ref.M_value(Met)),sum(ref.M_value(Miner))], [sum(ref.X_value(Met)),sum(ref.X_value(Miner))],[sum(ref.Y_value(Met)),sum(ref.Y_value(Miner))]);
    Out.TradeIntMETMIN  = TradeIntens([sum(Out.M_value(Met)),sum(Out.M_value(Miner))], [sum(Out.X_value(Met)),sum(Out.X_value(Miner))],[sum(Out.Y_value(Met)),sum(Out.Y_value(Miner))]);
    evol_ref.TradeIntMETMIN =  (divide(Out.TradeIntMETMIN , ref.TradeIntMETMIN , %nan ) -1 )*100;

    ref.M_penetRatMETMIN = M_penetRat([sum(ref.M_value(Met)),sum(ref.M_value(Miner))],[sum(ref.Y_value(Met)),sum(ref.Y_value(Miner))], [sum(ref.X_value(Met)),sum(ref.X_value(Miner))]);
    Out.M_penetRatMETMIN = M_penetRat([sum(Out.M_value(Met)),sum(Out.M_value(Miner))],[sum(Out.Y_value(Met)),sum(Out.Y_value(Miner))], [sum(Out.X_value(Met)),sum(Out.X_value(Miner))]);
    evol_ref.M_penetRatMETMIN = ( divide(Out.M_penetRatMETMIN , ref.M_penetRatMETMIN , %nan ) -1 )*100; 

    CompAGG.ref = [["TableTrade_"+ref_name,"Ener Cost Share", "Trade Intens", "Import Penet Rate"];[["Metals";"Non Metallic Minerals"], [ref.ENshareMET;ref.ENshareMINER],ref.TradeIntMETMIN',ref.M_penetRatMETMIN' ]];
    CompAGG.run = [["TableTrade_run", "Ener Cost Share", "Trade Intens", "Import Penet Rate"];[["Metals";"Non Metallic Minerals"], [Out.ENshareMET;Out.ENshareMINER] ,Out.TradeIntMETMIN',Out.M_penetRatMETMIN']];
    CompAGG.evol_ref = [["TableTrade%", "pY - p Fisher", "Y - qFisher","pM - p Fisher", "M - qFisher","pX - p Fisher","X - qFisher", "C- qFisher", "Ener Cost Share", "Trade Intens", "Import Penet Rate"];[["Metals";"Non Metallic Minerals"],[ (pY_Met_pFish-1)*100;(pY_Miner_pFish-1)*100],  [ (Y_Met_qFish-1)*100;(Y_Miner_qFish-1)*100], [ (pM_Met_pFish-1)*100;(pM_Miner_pFish-1)*100],  [(M_Met_qFish-1)*100;(M_Miner_qFish-1)*100], [ (pX_Met_pFish-1)*100;(pX_Miner_pFish-1)*100],  [(X_Met_qFish-1)*100;(X_Miner_qFish-1)*100],[(C_Met_qFish-1)*100;(C_Miner_qFish-1)*100], [evol_ref.ENshareMET;evol_ref.ENshareMINER],evol_ref.TradeIntMETMIN',evol_ref.M_penetRatMETMIN']];
	
	if Output_files
	if OutputfilesBY
    csvWrite(CompAGG.ref,SAVEDIR+"CompAGG-"+ref_name+"_"+Name_time+"_"+simu_name+".csv", ';');
    csvWrite(CompAGG.run,SAVEDIR+"CompAGG-run_"+Name_time+"_"+simu_name+".csv", ';');
    csvWrite(CompAGG.evol_ref,SAVEDIR+"CompAGG-evol_"+ref_name"_"+Name_time+"_"+simu_name+".csv", ';');
	end
	end


end

Out.GDP_sect = Out.Labour_income + Out.Labour_Tax +  Out.Production_Tax - Out.ClimPolCompensbySect + Out.GrossOpSurplus + Out.OtherIndirTax + Out.VA_Tax + Out.Energy_Tax_IC + Out.Energy_Tax_FC + Out.Carbon_Tax;

//////////////////////////
///////////// TEMPLATE
//////////////////////////

OutputTable("FullTemplate_"+ref_name)=[["Variables",			"values_"+Name_time												];..
["Labour Tax Cut",												-Out.Labour_Tax_Cut													];..
["Emissions - MtCO2",											Out.DOM_CO2															];..
["Emissions - %/"+ref_name,										(evol_ref.DOM_CO2-1)*100											];..
["Carbon Tax rate-"+money+"/tCO2", 		  						(Out.Carbon_Tax_rate*eval(money_unit_data))/10^6  				];..
["Energy Tax "+money_disp_unit+money,							(sum(Out.Energy_Tax_FC) + sum(Out.Energy_Tax_IC)).*money_disp_adj];..
["Labour productivity ",										parameters.Mu													];..
["GDP Decomposition Laspeyres Quantities", 					""																	];..
["Real GDP LaspQ ratio/"+ref_name,								GDP_qLasp															];..
["GDP Decomp - C",												(sum(ref.C_value)/ref.GDP) * C_qLasp							];..
["GDP Decomp - G",												(sum(ref.G_value)/ref.GDP) * G_qLasp							];..
["GDP Decomp - I",												(sum(ref.I_value)/ref.GDP) * I_qLasp							];..
["GDP Decomp - X",												(sum(ref.X_value)/ref.GDP) * X_qLasp							];..
["GDP Decomp - M",												(sum(ref.M_value)/ref.GDP) * M_qLasp							];..
["---Nominal values at "+money_disp_unit+money+"---",		 	""																];..
["Nominal GDP",		  											money_disp_adj.*sum(Out.GDP)										];..
["Nominal C",			  											money_disp_adj.*sum(Out.C_value)									];..
["Nominal G",														money_disp_adj.*sum(Out.G_value)									];..
["Nominal I",														money_disp_adj.*sum(Out.I_value)									];..
["Nominal X",														money_disp_adj.*sum(Out.X_value)									];..
["Nominal M",														money_disp_adj.*sum(Out.M_value)									];..
["Nominal Trade Balance",										money_disp_adj.*(sum(Out.X_value)-sum(Out.M_value))					];..
["Nominal M/Y ratio_"+Index_Sectors,							divide(Out.M, Out.Y, %nan) 						];..
["Nominal Net-of-tax wages",										Out.omega										   						];..
["Net-of-tax effective wages",									Out.omega/((1+Out.Mu)^Out.time_since_BY)								];..
["Nominal C_"+Index_Sectors,									money_disp_adj.*sum(Out.C_value,"c")										];..
["Nominal M_"+Index_Sectors,									money_disp_adj.*Out.M_value'										];..
["Nominal X_"+Index_Sectors,									money_disp_adj.*Out.X_value										];..
["Nominal Y_"+Index_Sectors,									money_disp_adj.*Out.Y_value'										];..
["Nominal VA-"+Index_Sectors,									money_disp_adj.*sum(Out.Value_Added,"r")'						];..
["Nominal GDP-"+Index_Sectors,									money_disp_adj.*sum(Out.GDP_sect,"r")'						];..
["GFCF_"+Index_DomesticAgents,									money_disp_adj.*Out.GFCF_byAgent(Indice_DomesticAgents)'		];..
["Disposable income_"+Index_InstitAgents,						money_disp_adj.*Out.Disposable_Income'							];..
["Net Lending_"+Index_InstitAgents,							money_disp_adj.*Out.NetLending'									];..
["Country Deficit/GDP-ratio/"+ref_name, 					evol_ref.NetLendingRoW_GDP 										];..
["Net Debt"+Index_InstitAgents,									money_disp_adj.*Out.NetFinancialDebt'								];..
["HH saving - % ",	    							(sum(Out.Household_savings)/sum(Out.H_disposable_income))			];..
["---Real terms at "+money_disp_unit+money+" "+ref_name+"---", ""																	];..
["Real GDP",														money_disp_adj.*Out.GDP/GDP_pFish									];..
["Real C",															money_disp_adj.*sum(Out.C_value)/Out.CPI							];..
["Real G",															money_disp_adj.*sum(Out.G_value)/G_pFish							];..
["Real I",															money_disp_adj.*sum(Out.I_value)/I_pFish							];..
["Real X",															money_disp_adj.*sum(Out.X_value)/X_pFish							];..
["Real M",															money_disp_adj.*sum(Out.M_value)/M_pFish							];..
["Real Trade Balance",											    money_disp_adj.*(sum(Out.X_value)/X_pFish-sum(Out.M_value)/M_pFish)];..
["Real Y",															money_disp_adj.*sum(Out.Y_value)/Y_pFish							];..
["Real Y_"+Index_Sectors,									        money_disp_adj.*(Out.Y_value')./eval("Y_"+Index_Sectors+"_pFish")	];..
["Real Net-of-tax wages",										Out.omega/Out.CPI														];..
["Real Net-of-tax effective wages",								(Out.omega/((1+Out.Mu)^Out.time_since_BY))/Out.CPI				];..
["Real GFCF_"+Index_DomesticAgents,							money_disp_adj.*(Out.GFCF_byAgent(Indice_DomesticAgents)/I_pFish)'	];..
["---Prices Index ratio/"+ref_name+"---",						 ""																	];..
["Price Fisher Index/"+ref_name, 								""																	];..
["GDP pFish/"+ref_name,											GDP_pFish							  								];..
["pC pFish/"+ref_name,											C_pFish															];..
["pG pFish/"+ref_name,											G_pFish															];..
["pI pFish/"+ref_name,											I_pFish															];..
["pX pFish/"+ref_name,											X_pFish															];..
["pY pFish/"+ref_name,											Y_pFish															];..
["pY Energy pLasp/"+ref_name,									Y_En_pLasp														];..
[string("pY "+Index_EnerSect +" pLasp/"+ref_name),				eval("Y_"+Index_EnerSect+"_pLasp")							];..
["pY Non-Energy pLasp/"+ref_name,								Y_NonEn_pLasp													];..
[string("pY "+Index_NonEnerSect +" pLasp/"+ref_name),				eval("Y_"+Index_NonEnerSect+"_pLasp")							];..
["pM pFish/"+ref_name,											M_pFish															];..
["Labour price/"+ref_name,										L_pFish															];..
["Capital price/"+ref_name,										K_pFish															];..
["Energy price/"+ref_name,										IC_Ener_pFish														];..
["Non-energy price/"+ref_name,									IC_NonEn_pFish													];..
["---Intensity and rate---",									 ""																	];..
["Labour intensity",												lambda_pFish													];..
["Capital intensity",												kappa_pFish													];..
["Energy intensity",												alpha_Ener_qLasp												];..
["---Quantities ---",											 ""																	];..
["Unemployment % points/"+ref_name,							(Out.u_tot - ref.u_tot)*100										];..
["Labour "+Labour_unit,					     					Out.Labour_tot														];..
["Labour "+Labour_unit+" ratio/"+ref_name,						evol_ref.Labour_tot												];..
["Labour "+Index_Sectors+" "+Labour_unit,						Out.Labour'															];..
["C - Energy - ktoe",												sum(Out.C(Indice_EnerSect,:))										];..
[string("C - "+ Index_EnerSect +" ktoe"),						sum(Out.C(Indice_EnerSect,:),"c")									];..
["IC - Energy ktoe",												sum(Out.IC(Indice_EnerSect,:))										];..
[string("IC Energy - "+Index_Sectors +" - ktoe "),					sum(Out.IC(Indice_EnerSect,:),"r")'									];..
["X - Energy - ktoe",												sum(Out.X(Indice_EnerSect,:))										];..
[string("X - "+ Index_EnerSect +" - ktoe"),						Out.X(Indice_EnerSect,:)												];..
["M - Energy - ktoe",												sum(Out.M(Indice_EnerSect,:))										];..
[string("M - "+ Index_EnerSect +" - ktoe"),								Out.M(Indice_EnerSect,:)												];..
["---Quantities Index Laspeyres ---",								 ""																	];..
["Real C qLasp",													C_qLasp										 					];..
["Real C Energy qLasp",											C_En_qLasp										 					];..
["Real C Non-Energy qLasp",										C_NonEn_qLasp										 					];..
["---Pseudo Quantities For Non-Energy ---",					 ""																	];..
["Y_"+Index_NonEnerSect,											money_disp_adj.*Out.Y(Indice_NonEnerSect)						];..
["M_"+Index_NonEnerSect,											money_disp_adj.*Out.M(Indice_NonEnerSect)						];..
["C_"+Index_NonEnerSect,											money_disp_adj.*sum(Out.C(Indice_NonEnerSect,:),"c")			];..
["X_"+Index_NonEnerSect,											money_disp_adj.*sum(Out.X(Indice_NonEnerSect,:),"c")			];..
["---Quantities Index Fisher ---",								 ""																	];..
["M qFish",														M_qFish										 					];..
["Y qFish",														Y_qFish										 					];..
["X qFish",														X_qFish								 							];..
];

if Capital_Dynamics
OutputTable("FullTemplate_"+ref_name)=[OutputTable("FullTemplate_"+ref_name);
["---Capital Stock ---",								 ""																	];..
["Capital Endowment",							money_disp_adj.*Out.Capital_endowment							];..
[string("Capital Cons - "+ Index_Sectors),		money_disp_adj.*Out.Capital_consumption'						];..
[string("Real I - "+ Index_Sectors(ind_Inv)),	money_disp_adj.*sum(Out.I_value(ind_Inv,:),"c")./eval("I_"+Index_Sectors(ind_Inv)+"_pFish")	];..
[string("Volume I - "+ Index_Sectors(ind_Inv)),	money_disp_adj.*sum(Out.I(ind_Inv,:),"c")											];..
];
end

if Capital_Dynamics
OutputTable("FullTemplate_"+ref_name)=[OutputTable("FullTemplate_"+ref_name);
["---Capital consumption if U exo (if not,should be equal)--",			 ""																						];..
["Capital Consumption",						money_disp_adj.*sum(Out.kappa.*Out.Y')														];..
["Diff K Consumption and inventory in %",	((sum(Out.kappa.*Out.Y') - Out.Capital_endowment ) / Out.Capital_endowment)*100				];..
];
end

/// for MacroIncertitudes

if Scenario=="RefBC"
OutputTable("FullTemplate_"+ref_name)=[OutputTable("FullTemplate_"+ref_name);
["---Macro Incertitudes ---",								 ""																	];..
["Labour Productivity",							parameters.Mu						];..
//["Labour Productivity_"+Index_EnerSect,							parameters.phi_L(:,Indice_EnerSect)'						];..
//["Labour Productivity_"+Index_NonEnerSect,							parameters.phi_L(:,Indice_NonEnerSect)'						];..
["Prices Oil", 			parameters.delta_pM_parameter(Indice_OilS)			];..
["Prices Gas", 			parameters.delta_pM_parameter(Indice_GasS)	      	];..
["Prices Coal", 			parameters.delta_pM_parameter(Indice_CoalS)		];..	
["World Growth Level_"+Index_NonEnerSect,		parameters.delta_X_parameter(:,Indice_NonEnerSect)'			];..
//["World Growth Level_"+Index_NonEnerSect, 			sum(parameters.delta_X_parameter(:,Indice_NonEnerSect),"r")			];..
["Productivity Variation",		VAR_MU		];..
["Prices Oil/Gas/Coal Variation",		VAR_pM			];..
["World Growth Level Variation",		VAR_Growth	];..
["Household saving rate Variation",		VAR_Immo	];..
["Sigma Variation",		VAR_sigma	];..
];
end

/// Temporary - to delete
if Country=="Brasil"&Scenario=="PMR_Ten"
OutputTable("FullTemplate_"+ref_name)=[OutputTable("FullTemplate_"+ref_name);
["---Y pseudo quantities --",			 ""																	];..
["Yten_"+Index_Sectors,									Out.Y						];..
["---Y objectif pseudo quantities --",			 ""																	];..
["Yobj_"+Index_Sectors,									Y_obj.val						];..
["---Yobj/Yten --",			 ""																	];..
["RatioYobj/Yten"+Index_Sectors,						Y_obj.val./Out.Y						];..
];
end


////////////////////////////////////////SPECIFIC CASES OUUTPUT for country studies 
//FRANCE 
if Country == "France"
exec("outputs_indic_FRA.sce");
end



///Store BY (at the end for eventually completing the FullTemplate with specific indicators according to country studies
if Output_files
	if OutputfilesBY
		csvWrite(OutputTable("FullTemplate_"+ref_name),SAVEDIR+"FullTemplate_"+ref_name+"_"+Name_time+"_"+simu_name+".csv", ';');
	elseif ~OutputfilesBY
		csvWrite(OutputTable("FullTemplate_"+ref_name),SAVEDIR_INIT+"FullTemplate_"+ref_name+"_"+Name_time+"_"+simu_name+".csv", ';');		
			// if Country=="Argentina"&time_step ==1
				// csvWrite(OutputTable("FullTemplate_"+ref_name),SAVEDIR+"FullTemplate_"+ref_name+"_"+ref_name+"_"+simu_name+".csv", ';');
			// end
	end
end


