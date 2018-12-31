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

///////////////////////////////////////////////////////////////////////
/////////// Decomposition of IOT_value into domestic and imports IOT_value
//////////////////////////////////////////////////////////////////////

// il faut l'exécuter avant l'agrégation, et recalculer les nouvelles tables agrégés dans le fichier agrégation
	
// Calculation of IC_valueIMP et FC_valueIMP (tables of imports) : multiplication of IC_value and FC_value by respectively IC_Import_rate and FC_Import_rate
//IC_valueDOM et FC_valueDOM are then deduced 

	
	initial_value.IC_valueIMP = initial_value.IC_value .* initial_value.IC_Import_rate;
	initial_value.IC_valueDOM = initial_value.IC_value - initial_value.IC_valueIMP;
	
	
	initial_value.FC_valueIMP = initial_value.FC_value .* initial_value.FC_Import_rate;
	initial_value.FC_valueDOM = initial_value.FC_value - initial_value.FC_valueIMP;
		
	for elt=1:nb_FC
	varname = Index_FC(elt);
	execstr ('initial_value.'+varname+'_Import_rate'+'=initial_value.FC_Import_rate(:,elt);');
	execstr ('initial_value.'+varname+'_valueDOM'+'=initial_value.FC_valueDOM(:,elt);');
	execstr ('initial_value.'+varname+'_valueIMP'+'=initial_value.FC_valueIMP(:,elt);');
	indicEltFC = 1 + indicEltFC;
	end
	

	
	// Calculation of imports trade and transports margins
	// Hypothesis: prorata the weight of Imports in total output (Y) & Imports
	initial_value.MarginsIMP = initial_value.Margins.* repmat((initial_value.M_value ./ (initial_value.M_value + initial_value.Y_value)),nb_Margins,1); 
	initial_value.MarginsDOM = initial_value.Margins - initial_value.MarginsIMP;

	// Calculation of imports spécific margins
	// initial_value.SpeMarg_IC_IMP = initial_value.SpeMarg_IC.*initial_value.IC_Import_rate';
	// initial_value.SpeMarg_IC_DOM = initial_value.SpeMarg_IC - initial_value.SpeMarg_IC_IMP;
	
	// initial_value.SpeMarg_FC_IMP = initial_value.SpeMarg_FC.*initial_value.FC_Import_rate';
	// initial_value.SpeMarg_FC_DOM = initial_value.SpeMarg_FC - initial_value.SpeMarg_FC_IMP;

	// Calculutation of tax from imports
	initial_value.Energy_Tax_IC_IMP = initial_value.Energy_Tax_IC.* (initial_value.M_value ./ (initial_value.M_value + initial_value.Y_value)); 
	initial_value.Energy_Tax_IC_DOM = initial_value.Energy_Tax_IC - initial_value.Energy_Tax_IC_IMP;
	
	initial_value.OtherIndirTax_IMP = initial_value.OtherIndirTax.* (initial_value.M_value ./ (initial_value.M_value + initial_value.Y_value)); 
	initial_value.OtherIndirTax_DOM = initial_value.OtherIndirTax - initial_value.OtherIndirTax_IMP;
	
	// for final consumption taxes :  Hypothesis: prorata the weight of FC_valueIMP in FC_value
if Country =="France"
	initial_value.VA_Tax_IMP = initial_value.VA_Tax .* (sum(initial_value.FC_valueIMP,"c")./sum(initial_value.FC_value,"c"))' ;
	initial_value.VA_Tax_DOM = initial_value.VA_Tax - initial_value.VA_Tax_IMP;
	
	initial_value.Energy_Tax_FC_IMP = initial_value.Energy_Tax_FC .* (sum(initial_value.FC_valueIMP,"c")./sum(initial_value.FC_value,"c"))' ;
	initial_value.Energy_Tax_FC_DOM = initial_value.Energy_Tax_FC - initial_value.Energy_Tax_FC_IMP;
	
elseif Country == "India"
	initial_value.VA_Tax_IMP = initial_value.VA_Tax * 0 ;
	initial_value.VA_Tax_DOM = initial_value.VA_Tax - initial_value.VA_Tax_IMP;
	
	initial_value.Energy_Tax_FC_IMP = initial_value.Energy_Tax_FC * 0 ;
	initial_value.Energy_Tax_FC_DOM = initial_value.Energy_Tax_FC - initial_value.Energy_Tax_FC_IMP;
   
	
elseif Country == "Brasil"	
	
	initial_value.VA_Tax_IMP = initial_value.VA_Tax * 0 ;
	initial_value.VA_Tax_DOM = initial_value.VA_Tax - initial_value.VA_Tax_IMP;
	
	initial_value.Energy_Tax_FC_IMP = initial_value.Energy_Tax_FC * 0 ;
	initial_value.Energy_Tax_FC_DOM = initial_value.Energy_Tax_FC - initial_value.Energy_Tax_FC_IMP;
	
	initial_value.Cons_Tax_IMP = initial_value.Cons_Tax.* (initial_value.M_value ./ (initial_value.M_value + initial_value.Y_value));
	initial_value.Cons_Tax_DOM = initial_value.Cons_Tax - initial_value.Cons_Tax_IMP;
end
	
	initial_value.TaxesIMP = zeros(nb_Taxes, nb_Sectors);
	initial_value.TaxesDOM = zeros(nb_Taxes, nb_Sectors);


if Country=="Brasil"	
	initial_value.TaxesIMP(1,:) = initial_value.VA_Tax_IMP;
	initial_value.TaxesIMP(2,:) = initial_value.Cons_Tax_IMP;
	initial_value.TaxesIMP(3,:)= initial_value.Energy_Tax_IC_IMP ;
	initial_value.TaxesIMP(4,:)= initial_value.Energy_Tax_FC_IMP ; 
	initial_value.TaxesIMP(6,:) = initial_value.OtherIndirTax_IMP ;
	
	initial_value.TaxesDOM(1,:) = initial_value.VA_Tax_DOM;
	initial_value.TaxesDOM(2,:) = initial_value.Cons_Tax_DOM;
	initial_value.TaxesDOM(3,:)= initial_value.Energy_Tax_IC_DOM ;
	initial_value.TaxesDOM(4,:)= initial_value.Energy_Tax_FC_DOM ; 
	initial_value.TaxesDOM(5,:) = initial_value.OtherIndirTax_DOM ;

else
	initial_value.TaxesIMP(1,:) = initial_value.VA_Tax_IMP;
	initial_value.TaxesIMP(2,:)= initial_value.Energy_Tax_IC_IMP ;
	initial_value.TaxesIMP(3,:)= initial_value.Energy_Tax_FC_IMP ; 
	initial_value.TaxesIMP(5,:) = initial_value.OtherIndirTax_IMP ;
	
	initial_value.TaxesDOM(1,:) = initial_value.VA_Tax_DOM;
	initial_value.TaxesDOM(2,:)= initial_value.Energy_Tax_IC_DOM ;
	initial_value.TaxesDOM(3,:)= initial_value.Energy_Tax_FC_DOM ; 
	initial_value.TaxesDOM(5,:) = initial_value.OtherIndirTax_DOM ;
end
 
	// Output for IOA -  output net of imports,tax on imports, and imports margins 
	 // initial_value.Output = sum(initial_value.IC_value,"r") + sum(initial_value.Value_Added,"r") + sum(initial_value.MarginsDOM,"r")+sum(initial_value.SpeMarg_IC_DOM,"r")+ sum(initial_value.SpeMarg_FC_DOM,"r")+sum(initial_value.TaxesDOM,"r") ;
	
	initial_value.Output = sum(initial_value.IC_value,"r") + sum(initial_value.Value_Added,"r") + sum(initial_value.MarginsDOM,"r")+sum(initial_value.SpeMarg_IC,"r")+ sum(initial_value.SpeMarg_FC,"r")+sum(initial_value.TaxesDOM,"r") ;
	
	// CHECKING BALANCE OF IMPORTS
	// tot_ressources_valIMP = initial_value.M_value + sum(initial_value.MarginsIMP,"r") + sum(initial_value.SpeMarg_IC_IMP,"r")+ sum(initial_value.SpeMarg_FC_IMP,"r") + sum(initial_value.TaxesIMP,"r");
	
	initial_value.tot_ress_valIMP = initial_value.M_value + sum(initial_value.MarginsIMP,"r") + sum(initial_value.TaxesIMP,"r");
	
		initial_value.tot_uses_valIMP = sum(initial_value.IC_valueIMP,"c")+sum(initial_value.FC_valueIMP,"c");
	
	
	initial_value.ERE_balance_valIMP =initial_value.tot_ress_valIMP - initial_value.tot_uses_valIMP' ;
    if abs(initial_value.ERE_balance_valIMP)>= Err_balance_tol then
        disp('Warning : unbalanced IOT of IMPORTS')
    end
	
