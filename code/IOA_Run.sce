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
/////////// INPUT OUTPUT ANALYSIS
/////////// Calculation of emissions due to consumption vs production 
//////////////////////////////////////////////////////////////////////



/////////////////////////////////////////////////////////
/// Input- Output ANALYSIS AFTER RUN for embodied emissions

// A redefinir après recalcul des taux ajustés! 
d.IC_Import_rate = ini.IC_Import_rate ; 
d.FC_Import_rate = ini.FC_Import_rate ;


// A redefinir après recalcul des taux ajustés! 
// for final consumption taxes :  Hypothesis: prorata the weight of FC_valueIMP in FC_value
d.VA_Tax_IMP = ini.VA_Tax_IMP;
d.Energy_Tax_FC_IMP = ini.Energy_Tax_FC_IMP;

/// Calculer selon les mêmes hypothèses que sur la matrice désagrégées
d.MarginsIMP = d.Margins.* (ones(nb_Margins,1).*.(d.M_value ./ (d.M_value + d.Y_value))); 
d.MarginsDOM = d.Margins - d.MarginsIMP;

// Calculutation of tax from imports
d.Energy_Tax_IC_IMP = d.Energy_Tax_IC.* (d.M_value ./ (d.M_value + d.Y_value)); 
d.Energy_Tax_IC_DOM = d.Energy_Tax_IC - d.Energy_Tax_IC_IMP;

d.OtherIndirTax_IMP = d.OtherIndirTax.* (d.M_value ./ (d.M_value + d.Y_value)); 
d.OtherIndirTax_DOM = d.OtherIndirTax - d.OtherIndirTax_IMP;

//A REDEFINIR après recalcul des taux ajustés! 
d.TaxesIMP = zeros(nb_Taxes, nb_Sectors);

d.TaxesIMP(1,:) = d.VA_Tax_IMP;
d.TaxesIMP(2,:)= d.Energy_Tax_IC_IMP ;
d.TaxesIMP(3,:)= d.Energy_Tax_FC_IMP ; 
d.TaxesIMP(5,:) = d.OtherIndirTax_IMP ;


AdjutERE_M = ones (nb_Sectors,1) ; 

function ERE_M = ERE_Import ( AdjutERE_M, IC_Import_rate, FC_Import_rate, IC_value, FC_value, VA_Tax, Energy_Tax_FC,  M_value,Y_value, MarginsIMP , TaxesIMP)

IC_Import_rate = min (IC_Import_rate.*( ones (1,nb_Sectors).*. AdjutERE_M ),1);
FC_Import_rate = min (FC_Import_rate.*( ones (1,nb_FC).*. AdjutERE_M ),1);
 
IC_valueIMP = IC_value .* IC_Import_rate;
FC_valueIMP = FC_value .* FC_Import_rate;

// for final consumption taxes :  Hypothesis: prorata the weight of FC_valueIMP in FC_value
VA_Tax_IMP = VA_Tax .* (sum(FC_valueIMP,"c")./sum(FC_value,"c"))' ;
Energy_Tax_FC_IMP =Energy_Tax_FC .* (sum(FC_valueIMP,"c")./sum(FC_value,"c"))' ;

TaxesIMP(1,:) = VA_Tax_IMP;
TaxesIMP(3,:)= Energy_Tax_FC_IMP

ERE_M = (M_value + sum(MarginsIMP,"r") + sum(TaxesIMP,"r"))' -( sum(IC_valueIMP,"c")+sum(FC_valueIMP,"c"));

endfunction

/// Verif équilibre a l'année de base ( pas équilibré a cause de l'agrégation)
ini.ERE_M = ERE_Import ( AdjutERE_M, ini.IC_Import_rate, ini.FC_Import_rate, ini.IC_value, ini.FC_value, ini.VA_Tax, ini.Energy_Tax_FC,  ini.M_value,ini.Y_value, ini.MarginsIMP , ini.TaxesIMP);

/// Non équilibré sans ajustement 
d.ERE_M = ERE_Import ( AdjutERE_M, d.IC_Import_rate, d.FC_Import_rate, d.IC_value, d.FC_value, d.VA_Tax, d.Energy_Tax_FC,  d.M_value,d.Y_value, d.MarginsIMP , d.TaxesIMP);

// ajustement de l'équibre des imports 
[AdjutERE_M_best, d.ERE_M_best, info] = fsolve(AdjutERE_M, list(ERE_Import, d.IC_Import_rate, d.FC_Import_rate, d.IC_value, d.FC_value, d.VA_Tax, d.Energy_Tax_FC,  d.M_value,d.Y_value, d.MarginsIMP , d.TaxesIMP),sensibFsolve);

// Recalcul des taux après ajustement qui permet l'équibre des importations, trouvé par le solveur
d.IC_Import_rate = min (d.IC_Import_rate.*( ones (1,nb_Sectors).*. AdjutERE_M_best ),1);
d.FC_Import_rate = min (d.FC_Import_rate.*( ones (1,nb_FC).*. AdjutERE_M_best ),1);
 
d.IC_valueIMP = d.IC_value .* d.IC_Import_rate;
d.IC_valueDOM = d.IC_value - d.IC_valueIMP;
	
d.FC_valueIMP = d.FC_value .* d.FC_Import_rate;
d.FC_valueDOM = d.FC_value - d.FC_valueIMP;

// for final consumption taxes :  Hypothesis: prorata the weight of FC_valueIMP in FC_value
d.VA_Tax_IMP = d.VA_Tax .* (sum(d.FC_valueIMP,"c")./sum(d.FC_value,"c"))' ;
VA_Tax_DOM = d.VA_Tax - d.VA_Tax_IMP;

d.Energy_Tax_FC_IMP =d.Energy_Tax_FC .* (sum(d.FC_valueIMP,"c")./sum(d.FC_value,"c"))' ;
Energy_Tax_FC_DOM = d.Energy_Tax_FC - d.Energy_Tax_FC_IMP;

d.TaxesIMP(1,:) = d.VA_Tax_IMP;
d.TaxesIMP(3,:)= d.Energy_Tax_FC_IMP ;

d.TaxesDOM = d.Taxes - d.TaxesIMP;

d.tot_ress_valIMP = d.M_value + sum(d.MarginsIMP,"r") + sum(d.TaxesIMP,"r");
d.tot_uses_valIMP = sum(d.IC_valueIMP,"c")+sum(d.FC_valueIMP,"c");

d.ERE_M_value =d.tot_ress_valIMP - d.tot_uses_valIMP' ;
    if abs(d.ERE_M_value)>= Err_balance_tol then
        disp("Warning : unbalanced IOT of IMPORTS")
    end	

d.Output = sum(d.IC_value,"r") + sum(d.Value_Added,"r") + sum(d.MarginsDOM,"r")+sum(d.SpeMarg_IC,"r")+ sum(d.SpeMarg_FC,"r")+sum(d.TaxesDOM,"r") ;
	
 ioa_run  = IOA(  d.CO2Emis_IC,  d.CO2Emis_C, d.IC_value,  d.IC_valueIMP, d.IC_valueDOM, d.FC_valueDOM, d.FC_valueIMP, d.FC_value,  d.Output, CoefCO2_reg);
 

ioa_run.IOA_DECOMP = [AGGprofil,Index_Sectors';"Emis_Sect",ioa_run.Emis_Sect;"Emis_HH",ioa_run.Emis_HH;"Emiss_IOA",ioa_run.Emiss_IOA;"Prod_Emis_IOA_DIR",ioa_run.Prod_Emis_IOA_DIR;"Prod_Emis_IOA_INDIR",ioa_run.Prod_Emis_IOA_INDIR;"Dom_Emis_IOA_C",ioa_run.Dom_Emis_IOA_C;"Dom_Emis_IOA_G",ioa_run.Dom_Emis_IOA_G;"Dom_Emis_IOA_I",ioa_run.Dom_Emis_IOA_I;"Dom_Emis_IOA_X",ioa_run.Dom_Emis_IOA_X;"Imp_Emis_IOA_C",ioa_run.Imp_Emis_IOA_C;"Imp_Emis_IOA_G",ioa_run.Imp_Emis_IOA_G;"Imp_Emis_IOA_I",ioa_run.Imp_Emis_IOA_I;"Imp_Emis_IOA_X",ioa_run.Imp_Emis_IOA_X;"Imp_Emis_IOA_int",ioa_run.Imp_Emis_IOA_int;];

if	H_DISAGG <> "HH1"
ioa_run.IOA_DECOMP_HH = [AGGprofil,Index_Sectors';"Emis_Sect",ioa_run.Emis_Sect;"Emis_"+Index_Households,CO2Emis_C';"Emiss_IOA",ioa_run.Emiss_IOA;"Prod_Emis_IOA_DIR",ioa_run.Prod_Emis_IOA_DIR;"Prod_Emis_IOA_INDIR",ioa_run.Prod_Emis_IOA_INDIR;"Dom_Emis_IOA_"+Index_Households,ioa_run.Dom_Emis_IOA_HH;"Dom_Emis_IOA_G",ioa_run.Dom_Emis_IOA_G;"Dom_Emis_IOA_I",ioa_run.Dom_Emis_IOA_I;"Dom_Emis_IOA_X",ioa_run.Dom_Emis_IOA_X;"Imp_Emis_IOA_"+Index_Households,ioa_run.Imp_Emis_IOA_HH;"Imp_Emis_IOA_G",ioa_run.Imp_Emis_IOA_G;"Imp_Emis_IOA_I",ioa_run.Imp_Emis_IOA_I;"Imp_Emis_IOA_X",ioa_run.Imp_Emis_IOA_X;"Imp_Emis_IOA_int_"+Index_Households,ioa_run.Imp_Emis_IOA_int_HH;];
end

// Print external files IOA_DECOMP
if Output_files=='True'
csvWrite(ioa_run.IOA_DECOMP, SAVEDIR_IOA + 'IOA_DECOMP_run_'+"_"+AGGprofil+'.csv', ';');

if	H_DISAGG <> "HH1"
csvWrite(ioa_run.IOA_DECOMP_HH, SAVEDIR_IOA + 'IOA_DECOMP_HH_run'+"_"+AGGprofil+'.csv', ';');
end

// csvWrite(Prices.evo,SAVEDIR+"Prices-evo.csv");

// Sauvegarde des fichiers pour Input dans IMACLIM
// AJOUTER AGG_TYPE En FIN DU NOM CSV
// csvWrite(ioa.Emis_fact_DOM, SAVEDIR + 'Emis_fact'+AGG_type+'.csv', ';');
// csvWrite(Output, SAVEDIR + 'Output'+AGG_type+'.csv', ';');
// csvWrite(Output./sum(Output), SAVEDIR + 'Output_Ratio'+AGG_type+'.csv', ';');
// csvWrite(tot_ress_valIMP, SAVEDIR + 'tot_ress_valIMP'+AGG_type+'.csv', ';');
// csvWrite(tot_ress_valIMP./sum(tot_ress_valIMP), SAVEDIR + 'tot_ress_valIMP_Ratio'+AGG_type+'.csv', ';');

// Compare= [sum(FC(16:17,:),"c") Output(16:17)' sum(FC(16:17,:),"c")-Output(16:17)']


// csvWrite(ioa.Emiss_IOA, SAVEDIR + 'Emiss_IOA_'+AGG_type+'.csv', ';');
// csvWrite(ioa.Emis_Sect, SAVEDIR + 'Emis_Sect_'+AGG_type+'.csv', ';');
// csvWrite(ioa.Emis_HH, SAVEDIR + 'Emis_HH_'+AGG_type+'.csv', ';');
// csvWrite(ioa.Prod_Emis_IOA_DIR, SAVEDIR + 'Prod_Emis_IOA_DIR_'+AGG_type+'.csv', ';');
// csvWrite(ioa.Prod_Emis_IOA_INDIR, SAVEDIR + 'Prod_Emis_IOA_INDIR_'+AGG_type+'.csv', ';');
// csvWrite(ioa.Dom_Emis_IOA_C, SAVEDIR + 'Dom_Emis_IOA_C_'+AGG_type+'.csv', ';');
// csvWrite(ioa.Dom_Emis_IOA_I, SAVEDIR + 'Dom_Emis_IOA_I_'+AGG_type+'.csv', ';');
// csvWrite(ioa.Dom_Emis_IOA_G, SAVEDIR + 'Dom_Emis_IOA_G_'+AGG_type+'.csv', ';');
// csvWrite(ioa.Dom_Emis_IOA_X, SAVEDIR + 'Dom_Emis_IOA_X_'+AGG_type+'.csv', ';');
// csvWrite(ioa.Imp_Emis_IOA_fin, SAVEDIR + 'Imp_Emis_IOA_fin_'+AGG_type+'.csv', ';');
// csvWrite(ioa.Imp_Emis_IOA_int, SAVEDIR + 'Imp_Emis_IOA_int_'+AGG_type+'.csv', ';');

// csvWrite(FC_value, SAVEDIR + 'FC_value'+AGG_type+'.csv', ';');

// csvWrite(Output, SAVEDIR + 'Output'+AGG_type+'.csv', ';');
// csvWrite(Output./sum(Output), SAVEDIR + 'Output_Ratio'+AGG_type+'.csv', ';');
// csvWrite(tot_ress_valIMP, SAVEDIR + 'tot_ress_valIMP'+AGG_type+'.csv', ';');
// csvWrite(tot_ress_valIMP./sum(tot_ress_valIMP), SAVEDIR + 'tot_ress_valIMP_Ratio'+AGG_type+'.csv', ';');
end


