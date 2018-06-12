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

/////////////////////////////////////////////////////////////////////////////////////////////
//	STEP 2: HYBRIDISATION
/////////////////////////////////////////////////////////////////////////////////////////////

/////////////////////////////////////////////////////////////////////



//////////////////////////////////////////////////////////////
/// Hypothesis : unique arbitrary price for non hybrid sectors 
//////////////////////////////////////////////////////////////


p(1,Indice_NonHybridCommod) = 1000;

p(Indice_HybridCommod) = (sum(initial_value.IC_value(:,Indice_HybridCommod),"r") + sum(initial_value.Value_Added(:,Indice_HybridCommod), "r") + initial_value.M_value(Indice_HybridCommod))  ./ (sum(initial_value.IC(Indice_HybridCommod,:),"c")+sum(initial_value.FC(Indice_HybridCommod,:),"c"))';
 
 initial_value.p = p;

 //Import price and production price ( for hybrid sectors - see below)
 

// Hypothesis for non hybrid commodities
initial_value.pM= zeros( nb_Sectors,1);
initial_value.pM(Indice_NonHybridCommod,1) = 1000;

initial_value.pY= zeros( nb_Sectors,1);
initial_value.pY(Indice_NonHybridCommod,1) = 1000;
 
 
 initial_value.Y(Indice_NonHybridCommod,1) = initial_value.Y_value(1,Indice_NonHybridCommod)'./initial_value.pY(Indice_NonHybridCommod,1);
 
  initial_value.M(Indice_NonHybridCommod,1) = initial_value.M_value(1,Indice_NonHybridCommod)'./initial_value.pM(Indice_NonHybridCommod,1);
 
 // Transport and trade margin rates 
 Transp_margins_rates = initial_value.Transp_margins ./ (initial_value.Y_value + initial_value.M_value); 
 Trade_margins_rates = initial_value. Trade_margins ./ (initial_value.Y_value + initial_value.M_value);
 
// Price before all taxes 
 p_BeforeTaxes = initial_value.p .* ( ones(1, nb_Sectors) +  Transp_margins_rates + Trade_margins_rates ) ;
 
 //Energy tax rate intermediate consumption
 Energy_Tax_rate_IC(1,Indice_EnerSect) = initial_value.Energy_Tax_IC(Indice_EnerSect) ./ sum(initial_value.IC(Indice_EnerSect,:),"c")';  
 Energy_Tax_rate_IC(1,Indice_NonEnerSect) = 0;
 
 //Energy tax rate finale consumption
 FC_netX = (sum(initial_value.C,"c")+sum(initial_value.G,"c")+sum(initial_value.I,"c"))'; 
 
Energy_Tax_rate_FC(1,Indice_EnerSect) = (initial_value.Energy_Tax_FC(Indice_EnerSect) ./ (FC_netX(Indice_EnerSect).*(FC_netX(Indice_EnerSect)<>0)+1.*(FC_netX(Indice_EnerSect)==0))) - (initial_value.Energy_Tax_FC(Indice_EnerSect).*(FC_netX(Indice_EnerSect)==0)); 

 Energy_Tax_rate_FC(1,Indice_NonEnerSect) = 0;
 
//Other tax product
 OtherIndirTax_rate (1,Indice_HybridCommod) = initial_value.OtherIndirTax(Indice_HybridCommod) ./ (sum(initial_value.IC(Indice_HybridCommod,:),"c")+sum(initial_value.C(Indice_HybridCommod,:),"c")+sum(initial_value.G(Indice_HybridCommod,:),"c")+sum(initial_value.I(Indice_HybridCommod,:),"c"))';  
 
 OtherIndirTax_rate(1,Indice_NonHybridCommod) = initial_value.OtherIndirTax(Indice_NonHybridCommod). / (initial_value.Y(Indice_NonHybridCommod)'+initial_value.M(Indice_NonHybridCommod)' - (initial_value.X_value(Indice_NonHybridCommod)'./p_BeforeTaxes(Indice_NonHybridCommod)) ) ;
 
 
 // REVOIR COMMENT GERER CARBON TAX RATE
 // Carbon_Tax_rate_IC = 
 

 // Price before Value_Added and Specific margins on intermediate consumption
  p_BeforeVAT_SpeMarg_IC = p_BeforeTaxes + Energy_Tax_rate_IC + OtherIndirTax_rate ;
  //  p_BeforeVAT_SpeMarg_IC = p_BeforeTaxes + Energy_Tax_rate_IC + OtherIndirTax_rate + Carbon_Tax_rate_IC
  
// Price before Value_Added and Specific margins on finale consumption
  p_BeforeVAT_SpeMarg_FC = p_BeforeTaxes + Energy_Tax_rate_FC + OtherIndirTax_rate ;
  
  
  // Price all taxes included without specific margin
FC_netX_value = (sum(initial_value.C_value,"c")+sum(initial_value.G_value,"c")+sum(initial_value.I_value,"c"))'; 
FC_netX_VAT_value = FC_netX_value - initial_value.VA_Tax;
VA_Tax_rate = (initial_value.VA_Tax ./ (FC_netX_VAT_value.*(FC_netX_VAT_value<>0)+1.*(FC_netX_VAT_value==0))) - (initial_value.VA_Tax.*(FC_netX_VAT_value==0));

p_AllTax_WithoutSpeMarg =  p_BeforeVAT_SpeMarg_FC .* ( 1 + VA_Tax_rate);   

///////////////////////////////////////////////////////////
// Calculation of unitary price 
///////////////////////////////////////////////////////////

 // pIC = Value/ Quantites, if quantities=0 then pIC = p_BeforeVAT_SpeMarg_IC for hybrid commodities
initial_value.pIC= zeros( nb_Sectors,nb_Sectors);
 
initial_value.pIC(Indice_HybridCommod,1:nb_Sectors) = ((initial_value.IC_value(Indice_HybridCommod,:).*(initial_value.IC(Indice_HybridCommod,:)<>0)) ./ ( initial_value.IC(Indice_HybridCommod,:).*(initial_value.IC(Indice_HybridCommod,:)<>0) + (initial_value.IC(Indice_HybridCommod,:)==0))) + repmat(p_BeforeVAT_SpeMarg_IC(1,Indice_HybridCommod)',1,nb_Sectors).*(initial_value.IC(Indice_HybridCommod,:)==0) ;
 
//pIC = p_BeforeVAT_SpeMarg_IC for non hybrid commodities
initial_value.pIC(Indice_NonHybridCommod,1:nb_Sectors) = repmat(p_BeforeVAT_SpeMarg_IC(1,Indice_NonHybridCommod)',1,nb_Sectors);
 
// pC/pI/pG = Value/ Quantites, if quantities=0 then pC/G/I = p_AllTax_WithoutSpeMarg for hybrid commodities
initial_value.pC= zeros( nb_Sectors,nb_Households);

initial_value.pC(Indice_HybridCommod,1:nb_Households) = ((initial_value.C_value(Indice_HybridCommod,:).*(initial_value.C(Indice_HybridCommod,:)<>0)) ./ ( initial_value.C(Indice_HybridCommod,:).*(initial_value.C(Indice_HybridCommod,:)<>0) + (initial_value.C(Indice_HybridCommod,:)==0))) + repmat(p_AllTax_WithoutSpeMarg(1,Indice_HybridCommod)',1,nb_Households).*(initial_value.C(Indice_HybridCommod,:)==0) ;

initial_value.pI= zeros( nb_Sectors,1);
initial_value.pI(Indice_HybridCommod,1) = ((initial_value.I_value(Indice_HybridCommod,:).*(initial_value.I(Indice_HybridCommod,:)<>0)) ./ ( initial_value.I(Indice_HybridCommod,:).*(initial_value.I(Indice_HybridCommod,:)<>0) + (initial_value.I(Indice_HybridCommod,:)==0))) + p_AllTax_WithoutSpeMarg(1,Indice_HybridCommod)'.*(initial_value.I(Indice_HybridCommod,:)==0) ;

initial_value.pG= zeros( nb_Sectors,1);
initial_value.pG(Indice_HybridCommod,1) = ((initial_value.G_value(Indice_HybridCommod,:).*(initial_value.G(Indice_HybridCommod,:)<>0)) ./ ( initial_value.G(Indice_HybridCommod,:).*(initial_value.G(Indice_HybridCommod,:)<>0) + (initial_value.G(Indice_HybridCommod,:)==0))) + p_AllTax_WithoutSpeMarg(1,Indice_HybridCommod)'.*(initial_value.G(Indice_HybridCommod,:)==0) ;
 
//pC/pI/pG = p_AllTax_WithoutSpeMarg for non hybrid commodities
initial_value.pC(Indice_NonHybridCommod,1:nb_Households) = repmat(p_AllTax_WithoutSpeMarg(1,Indice_NonHybridCommod)',1,nb_Households);

initial_value.pI(Indice_NonHybridCommod,1) = p_AllTax_WithoutSpeMarg(1,Indice_NonHybridCommod)';

initial_value.pG(Indice_NonHybridCommod,1) = p_AllTax_WithoutSpeMarg(1,Indice_NonHybridCommod)';

//Export price
initial_value.pX= zeros( nb_Sectors,1);
// pX = Value/ Quantites, if quantities=0 then pX = p_BeforeTaxes for hybrid commodities
initial_value.pX(Indice_HybridCommod,1) = ((initial_value.X_value(Indice_HybridCommod,:).*(initial_value.X(Indice_HybridCommod,:)<>0)) ./ ( initial_value.X(Indice_HybridCommod,:).*(initial_value.X(Indice_HybridCommod,:)<>0) + (initial_value.X(Indice_HybridCommod,:)==0))) + p_BeforeTaxes(1,Indice_HybridCommod)'.*(initial_value.X(Indice_HybridCommod,:)==0) ;

//pX =  for non hybrid commodities
initial_value.pX(Indice_NonHybridCommod,1) = p_BeforeTaxes(1,Indice_NonHybridCommod)';



//pM/pY= Value/Quantites, if quantities=O then price= p
initial_value.pM(Indice_HybridCommod,1) = ((initial_value.M_value(:,Indice_HybridCommod)'.*(initial_value.M(Indice_HybridCommod,:)<>0)) ./ ( initial_value.M(Indice_HybridCommod,:).*(initial_value.M(Indice_HybridCommod,:)<>0) + (initial_value.M(Indice_HybridCommod,:)==0))) + p(1,Indice_HybridCommod)'.*(initial_value.M(Indice_HybridCommod,:)==0) ;

initial_value.pY(Indice_HybridCommod,1) = ((initial_value.Y_value(:,Indice_HybridCommod)'.*(initial_value.Y(Indice_HybridCommod,:)<>0)) ./ ( initial_value.Y(Indice_HybridCommod,:).*(initial_value.Y(Indice_HybridCommod,:)<>0) + (initial_value.Y(Indice_HybridCommod,:)==0))) + 10^-10.*(initial_value.Y(Indice_HybridCommod,:)==0) ;

initial_value.pFC =[initial_value.pC,initial_value.pG,initial_value.pI,initial_value.pX];
 /////////////////////////////////////////////////////////// 
//Calculation of specific margis rate 
///////////////////////////////////////////////////////////
  // SpeMarg_IC euro/toe en intermediate consumption
 SpeMarg_IC_p(1:nb_Sectors,Indice_HybridCommod) = initial_value.pIC(Indice_HybridCommod,:)' - repmat(p_BeforeVAT_SpeMarg_IC(Indice_HybridCommod),nb_Sectors,1);
 SpeMarg_IC_p(1:nb_Sectors,Indice_NonHybridCommod) =0;
 
  initial_value.SpeMarg_IC = SpeMarg_IC_p .* initial_value.IC';

// SpeMarg_FC euro/toe en final consumption 
// SpeMarg_FC_p (1:nb_Households, Indice_HybridCommod)= (initial_value.pC(Indice_HybridCommod,:)' - ones(nb_Households,1) .*.p_AllTax_WithoutSpeMarg(Indice_HybridCommod))./(ones(nb_Households,1) .*.(1+ VA_Tax_rate(Indice_HybridCommod))); 
// SpeMarg_FC_p(1:nb_Households,Indice_NonHybridCommod) =0; 

 // SpeMarg_C euro/toe en final consumption
 SpeMarg_C_p (1:nb_Households, Indice_HybridCommod)= (initial_value.pC(Indice_HybridCommod,:)' - ones(nb_Households,1) .*.p_AllTax_WithoutSpeMarg(Indice_HybridCommod))./(ones(nb_Households,1) .*.(1+VA_Tax_rate(Indice_HybridCommod)));
 SpeMarg_C_p(1:nb_Households,Indice_NonHybridCommod) =0;
 
 initial_value.SpeMarg_C =  SpeMarg_C_p.* initial_value.C';

 // SpeMarg_I euro/toe en final consumption
 SpeMarg_I_p (1 , Indice_HybridCommod)= (initial_value.pI(Indice_HybridCommod,:)' - p_AllTax_WithoutSpeMarg(Indice_HybridCommod))./(1+VA_Tax_rate(Indice_HybridCommod));
 SpeMarg_I_p(1 ,Indice_NonHybridCommod) =0;
 
 initial_value.SpeMarg_I =  SpeMarg_I_p.* initial_value.I';
  
//if	H_DISAGG <> "HH1"
// warning("GLT : initial_value.SpeMarg_I n est pas calcule : probleme sur le calcul de sa marge spe I, mise a zero pour l instant")
// initial_value.SpeMarg_I =  zeros(1,nb_Sectors).* initial_value.I';
//else
// initial_value.SpeMarg_I =  SpeMarg_FC_p.* initial_value.I';
//end

 // SpeMarg_X euro/toe en final consumption
 SpeMarg_X_p(1, Indice_HybridCommod) = initial_value.pX(Indice_HybridCommod,:)' - p_BeforeTaxes(Indice_HybridCommod); 
 SpeMarg_X_p(1,Indice_NonHybridCommod) =0;
 initial_value.SpeMarg_X =SpeMarg_X_p .* initial_value.X';
   
 Total_SpeMarg =   sum(initial_value.SpeMarg_IC,"r")  + sum(initial_value.SpeMarg_C,"r") + initial_value.SpeMarg_I + initial_value.SpeMarg_X ;
 
 //No specific margins for government
initial_value.SpeMarg_G= zeros(1, nb_Sectors);

 initial_value.SpeMarg = [initial_value.SpeMarg_IC; initial_value.SpeMarg_C; initial_value.SpeMarg_G; initial_value.SpeMarg_I; initial_value.SpeMarg_X];
 
  initial_value.SpeMarg_FC = [initial_value.SpeMarg_C; initial_value.SpeMarg_G; initial_value.SpeMarg_I; initial_value.SpeMarg_X];
 
   initial_value.OthPart_IOT = [initial_value.Value_Added;initial_value.M_value;initial_value.Margins;initial_value.SpeMarg;initial_value.Taxes];
   tot_OthPart_IOT = sum (initial_value.OthPart_IOT, "r");

 ////////////////////////////////////////////////////////////
 //// Calculation of pseudo quantities of non hybrid sectors - DONE IN CALIBRATION FILE
 ///////////////////////////////////////////////////////////
 
 // initial_value.Y = initial_value.Y;
// initial_value.Y(Indice_NonHybridCommod,1) = (sum(initial_value.IC_value(:,Indice_NonHybridCommod),"r") + sum(initial_value.Value_Added(:,Indice_NonHybridCommod), "r") )'./ p(1,Indice_NonHybridCommod)';


// initial_value.M =initial_value.M;
// initial_value.M(Indice_NonHybridCommod,1) = initial_value.M_value(Indice_NonHybridCommod)'./ p(1,Indice_NonHybridCommod)';

// initial_value.IC = initial_value.IC;

 // initial_value.IC(Indice_NonHybridCommod,1:nb_Sectors) = initial_value.IC_value(Indice_NonHybridCommod,:)./ repmat(p_BeforeVAT_SpeMarg_IC(1,Indice_NonHybridCommod)',1,nb_Sectors);
 
 
  // initial_value.C = initial_value.C;
 // initial_value.C(Indice_NonHybridCommod) = initial_value.C_value(Indice_NonHybridCommod)./ p_AllTax_WithoutSpeMarg(1,Indice_NonHybridCommod)';
 
 
  // initial_value.I = initial_value.I;
 // initial_value.I(Indice_NonHybridCommod) = initial_value.I_value(Indice_NonHybridCommod)./ p_AllTax_WithoutSpeMarg(1,Indice_NonHybridCommod)';
  
    // initial_value.G = initial_value.G;
    // initial_value.G(Indice_NonHybridCommod) = initial_value.G_value(Indice_NonHybridCommod)./ p_AllTax_WithoutSpeMarg(1,Indice_NonHybridCommod)';
	
    // initial_value.X = initial_value.X;
    // initial_value.X(Indice_NonHybridCommod) = initial_value.X_value(Indice_NonHybridCommod)./ p_BeforeTaxes(1,Indice_NonHybridCommod)';
	
// TEST_equilibre = 	initial_value.Y - ( sum( initial_value.IC,"c") + sum(initial_value.C, "c") + initial_value.G + initial_value.I + initial_value.X - initial_value.M );


	
