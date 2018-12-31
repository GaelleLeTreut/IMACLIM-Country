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



// A t' on besoin de calculer les marges IMP DOM etc dans la décomposition pour les réagrégé apres?
// On peut le calculer directement ICI
// La décomposition sert alors uniquement à retrouver les taux agregé 

// Probleme les taux a l'instant initial ne vont pas permettre de garder un equilibre sur les import...
// voir comment gérer cela

// IL faut calculer les output les IC DOM et IMP, et les FC DOM et IMP
// Calculation of IC_valueIMP et FC_valueIMP (tables of imports) : multiplication of IC_value and FC_value by respectively IC_Import_rate and FC_Import_rate
//IC_valueDOM et FC_valueDOM are then deduced 



function [ioa ] = IOA(  CO2Emis_IC, CO2Emis_C,IC_value, IC_valueIMP,IC_valueDOM,FC_valueDOM,FC_valueIMP,FC_value, Output, CoefCO2_reg)

 // Différentes coomposantes de la demande finale 
	for elt=1:nb_FC
	varname = Index_FC(elt);
	execstr (varname+'_valueDOM'+'=FC_valueDOM(:,elt);');
	execstr (varname+'_valueIMP'+'=FC_valueIMP(:,elt);');
	indicEltFC = 1 + indicEltFC;
	end

// Emissions directes des ménages et des secteurs productifs 
ioa.Emis_Sect = sum(CO2Emis_IC,"r");
ioa.Emis_HH = sum(CO2Emis_C',"r");

// Emissions intensity: Emis_fact_DOM :calculation of emissions intensity vector for domestic production
ioa.Emis_fact_DOM = divide( ioa.Emis_Sect, Output, 0);
// Hypothèse A REVOIR : intensité des importations == à celle de la France
ioa.Emis_fact_IMP = ioa.Emis_fact_DOM ;


// Calculation of Intermediate coeff matrix A_DOM et A_IMP 
ioa.A = divide( IC_value, ones(nb_Sectors,1).*.Output, 0);
ioa.A_DOM = divide( IC_valueDOM, ones(nb_Sectors,1).*.Output, 0);
A_IMP  = divide( IC_valueIMP, ones(nb_Sectors,1).*.Output, 0);

//Identity Matrix and Leontief matrix
I = eye (nb_Sectors,nb_Sectors);
ioa.Leon = inv(I-ioa.A);
ioa.Leon_DOM = inv(I-ioa.A_DOM);
Leon_IMP = inv(I-A_IMP ); // identique que la France pour l'instant

[maxA1, lieu1] = max(ioa.A_DOM);

ioa.A2 =ioa.A_DOM^2;
[maxA2, lieu2] = max(ioa.A2);

ioa.A3 =ioa.A2*ioa.A_DOM;
[maxA3, lieu3] = max(ioa.A3);

ioa.A4 =ioa.A3*ioa.A_DOM;
[maxA4, lieu4] = max(ioa.A4);

ioa.A5 =ioa.A4*ioa.A_DOM;
[maxA5, lieu5] = max(ioa.A5);


ioa.A_anal = [ "A max"," A ind i","A ind j","A2  max","A2 ind i","A2 ind j","A3 max","A3 ind i","A3 ind j","A4 max","A4 ind i","A4 ind j","A5 max","A5 ind i","A5 ind j"; maxA1, Index_Sectors(lieu1(1)),Index_Sectors(lieu1(2)),maxA2, Index_Sectors(lieu2(1)),Index_Sectors(lieu2(2)),maxA3, Index_Sectors(lieu3(1)),Index_Sectors(lieu3(2)),maxA4, Index_Sectors(lieu4(1)),Index_Sectors(lieu4(2)),maxA5,Index_Sectors(lieu5(1)),Index_Sectors(lieu5(2))];

/////////////////////////////////////////////////////////////////////////////
// IO analysis
/////////////////////////////////////////////////////////////////////////////
// ressources net of importations(& taxes of imports)
// Dom_Output = ioa.Leon_DOM *sum(FC_valueDOM,"c");
// TEST = Output' - Dom_Output
// Cal_Ouput = ioa.Leon*(sum(FC_value,"c")-tot_ress_valIMP');
// Emiss_IOA_bis = ioa.Emis_fact_DOM*Cal_Ouput;

// Emissions de l'ensemble de la demande finale ( nettes des importations) 
ioa.Emiss_IOA = ioa.Emis_fact_DOM*ioa.Leon*diag(sum(FC_value,"c"));
ioa.Emiss_IOA_tot = sum(ioa.Emiss_IOA);

// Emissions associées à la demande finale domestique
ioa.Prod_Emis_IOA = ioa.Emis_fact_DOM*ioa.Leon_DOM *diag(sum(FC_valueDOM,"c"));
ioa.Prod_Emis_IOA_tot = sum(ioa.Prod_Emis_IOA);

ioa.Prod_Emis_IOA_DIR = ioa.Emis_fact_DOM*diag(sum(FC_valueDOM,"c"));
ioa.Prod_Emis_IOA_INDIR = ioa.Prod_Emis_IOA - ioa.Prod_Emis_IOA_DIR;

// Emissions associées à la consommation finale - nette d'export : émissions de la conso intérieure
ioa.Dom_Emis_IOA = ioa.Emis_fact_DOM*ioa.Leon_DOM *diag(sum(C_valueDOM,"c") + I_valueDOM + G_valueDOM);	
	
//Decomposition by vector of final demand
ioa.Dom_Emis_IOA_X = ioa.Emis_fact_DOM*ioa.Leon_DOM *diag(X_valueDOM );
ioa.Dom_Emis_IOA_C = ioa.Emis_fact_DOM*ioa.Leon_DOM *diag(sum(C_valueDOM,"c"));

	if	H_DISAGG <> "HH1"
	for elt =1:nb_Households	
	ioa.Dom_Emis_IOA_HH(elt,:)= ioa.Emis_fact_DOM*ioa.Leon_DOM *diag(C_valueDOM(:,elt));
	end
	end

ioa.Dom_Emis_IOA_G = ioa.Emis_fact_DOM*ioa.Leon_DOM *diag(G_valueDOM);
ioa.Dom_Emis_IOA_I = ioa.Emis_fact_DOM*ioa.Leon_DOM *diag(I_valueDOM);

// Ratio between component of domestic final demand
ioa.C_DOM_Emission_Ratio = sum(ioa.Dom_Emis_IOA_C) /ioa.Prod_Emis_IOA_tot;
ioa.G_DOM_Emission_Ratio = sum(ioa.Dom_Emis_IOA_G) /ioa.Prod_Emis_IOA_tot;
ioa.I_DOM_Emission_Ratio = sum(ioa.Dom_Emis_IOA_I) /ioa.Prod_Emis_IOA_tot;
ioa.X_DOM_Emission_Ratio = sum(ioa.Dom_Emis_IOA_X) /ioa.Prod_Emis_IOA_tot;


// //Emissions associées aux importations
//  // Decomposition IO des importations M= A_IMP .X + Y_IMP et X = [I-ioa.A_DOM]^-1 * Y_DOM 

// // Hypothèse que le systeme productif des importations est le même quand France
ioa.Imp_Emis_IOA_APROX = ioa.Emiss_IOA - ioa.Prod_Emis_IOA ; 
ioa.Imp_Emis_IOA_APROX_tot = sum( ioa.Imp_Emis_IOA_APROX);



// //Egalité avec Imp_Emis_IOA_APROX si tout est équilibré
 ioa.Imp_Emis_IOA_bis = ioa.Emis_fact_IMP* ioa.Leon *(A_IMP *ioa.Leon_DOM*diag(sum(FC_valueDOM,"c"))+ diag(sum(FC_valueIMP,"c")));
ioa.Imp_Emis_IOA_bis_tot = sum( ioa.Imp_Emis_IOA_bis)



CoefCO2_RoW = sum(CoefCO2_reg,"r");

ioa.Imp_Emis_IOA = CoefCO2_RoW *(A_IMP *ioa.Leon_DOM*diag(sum(FC_valueDOM,"c"))+ diag(sum(FC_valueIMP,"c")));
ioa.Imp_Emis_IOA_tot = sum(ioa.Imp_Emis_IOA);


ioa.Imp_Emis_IOA_int =CoefCO2_RoW *(A_IMP *ioa.Leon_DOM*diag(sum(FC_valueDOM,"c")));
ioa.Imp_Emis_IOA_fin = ioa.Imp_Emis_IOA - ioa.Imp_Emis_IOA_int;

	ioa.Imp_Emis_IOA_int_C =CoefCO2_RoW *(A_IMP *ioa.Leon_DOM*diag(sum(C_valueDOM,"c")));
	if	H_DISAGG <> "HH1"
	for elt =1:nb_Households	
	ioa.Imp_Emis_IOA_int_HH(elt,:)= CoefCO2_RoW *(A_IMP *ioa.Leon_DOM *diag(C_valueDOM(:,elt)));
	end
	end			
	
	ioa.Imp_Emis_IOA_int_G =CoefCO2_RoW *(A_IMP *ioa.Leon_DOM*diag(sum(G_valueDOM,"c")));
	ioa.Imp_Emis_IOA_int_I =CoefCO2_RoW *(A_IMP *ioa.Leon_DOM*diag(sum(I_valueDOM,"c")));
	ioa.Imp_Emis_IOA_int_X =CoefCO2_RoW *(A_IMP *ioa.Leon_DOM*diag(sum(X_valueDOM,"c")));
//Decomposition of imports for final demand
// emissions importées réexportées
ioa.Imp_Emis_IOA_X = CoefCO2_RoW *diag(X_valueIMP);
ioa.Imp_Emis_IOA_C = CoefCO2_RoW *diag(sum(C_valueIMP,"c"));

	if	H_DISAGG <> "HH1"
	for elt =1:nb_Households	
	ioa.Imp_Emis_IOA_HH(elt,:)=CoefCO2_RoW *diag(C_valueIMP(:,elt)) ; 
	end
	end

ioa.Imp_Emis_IOA_G = CoefCO2_RoW *diag(G_valueIMP); 
ioa.Imp_Emis_IOA_I =  CoefCO2_RoW *diag(I_valueIMP);

ioa.ImpNet_Emis_IOA =  ioa.Imp_Emis_IOA - ioa.Imp_Emis_IOA_X;
ioa.ImpNet_Emis_IOA_tot = sum(ioa.ImpNet_Emis_IOA );

// ioa.Imp_Emis_IOA_fin_test  = ioa.Imp_Emis_IOA_X + ioa.Imp_Emis_IOA_C + ioa.Imp_Emis_IOA_G + ioa.Imp_Emis_IOA_I - ioa.Imp_Emis_IOA_fin ; 



/// Emissions du point de vue de consommateurs
ioa.Cons_Emis_IOA = ioa.Dom_Emis_IOA + ioa.Imp_Emis_IOA;
ioa.Cons_Emis_IOA_tot = sum(ioa.Cons_Emis_IOA);

endfunction



/////////////////////////////////////////////////////////
/// Input- Output ANALYSIS at BASE YEAR for embodied emissions
ioa_ini = IOA(  initial_value.CO2Emis_IC,  initial_value.CO2Emis_C, initial_value.IC_value,  initial_value.IC_valueIMP, initial_value.IC_valueDOM, initial_value.FC_valueDOM, initial_value.FC_valueIMP, initial_value.FC_value,  initial_value.Output, CoefCO2_reg);


/////////////////////////////////////////////////////////
/// Saving Outputs of IOA in Output_IOA files 

if AGG_type == ""
AGGprofil = "DISAGG";
else
AGGprofil = AGG_type;
end

ioa_ini.IOA_DECOMP = [AGGprofil,Index_Sectors';"Emis_Sect",ioa_ini.Emis_Sect;"Emis_HH",ioa_ini.Emis_HH;"Emiss_IOA",ioa_ini.Emiss_IOA;"Prod_Emis_IOA_DIR",ioa_ini.Prod_Emis_IOA_DIR;"Prod_Emis_IOA_INDIR",ioa_ini.Prod_Emis_IOA_INDIR;"Dom_Emis_IOA_C",ioa_ini.Dom_Emis_IOA_C;"Dom_Emis_IOA_G",ioa_ini.Dom_Emis_IOA_G;"Dom_Emis_IOA_I",ioa_ini.Dom_Emis_IOA_I;"Dom_Emis_IOA_X",ioa_ini.Dom_Emis_IOA_X;"Imp_Emis_IOA_C",ioa_ini.Imp_Emis_IOA_C;"Imp_Emis_IOA_G",ioa_ini.Imp_Emis_IOA_G;"Imp_Emis_IOA_I",ioa_ini.Imp_Emis_IOA_I;"Imp_Emis_IOA_X",ioa_ini.Imp_Emis_IOA_X;"Imp_Emis_IOA_int",ioa_ini.Imp_Emis_IOA_int;"Imp_Emis_IOA_int_C",ioa_ini.Imp_Emis_IOA_int_C;"Imp_Emis_IOA_int_G",ioa_ini.Imp_Emis_IOA_int_G;"Imp_Emis_IOA_int_I",ioa_ini.Imp_Emis_IOA_int_I;"Imp_Emis_IOA_int_X",ioa_ini.Imp_Emis_IOA_int_X];


if	H_DISAGG <> "HH1"
ioa_ini.IOA_DECOMP_HH = [AGGprofil,Index_Sectors';"Emis_Sect",ioa_ini.Emis_Sect;"Emis_"+Index_Households,CO2Emis_C';"Emiss_IOA",ioa_ini.Emiss_IOA;"Prod_Emis_IOA_DIR",ioa_ini.Prod_Emis_IOA_DIR;"Prod_Emis_IOA_INDIR",ioa_ini.Prod_Emis_IOA_INDIR;"Dom_Emis_IOA_"+Index_Households,ioa_ini.Dom_Emis_IOA_HH;"Dom_Emis_IOA_G",ioa_ini.Dom_Emis_IOA_G;"Dom_Emis_IOA_I",ioa_ini.Dom_Emis_IOA_I;"Dom_Emis_IOA_X",ioa_ini.Dom_Emis_IOA_X;"Imp_Emis_IOA_"+Index_Households,ioa_ini.Imp_Emis_IOA_HH;"Imp_Emis_IOA_G",ioa_ini.Imp_Emis_IOA_G;"Imp_Emis_IOA_I",ioa_ini.Imp_Emis_IOA_I;"Imp_Emis_IOA_X",ioa_ini.Imp_Emis_IOA_X;"Imp_Emis_IOA_int_"+Index_Households,ioa_ini.Imp_Emis_IOA_int_HH;"Imp_Emis_IOA_int_G",ioa_ini.Imp_Emis_IOA_int_G;"Imp_Emis_IOA_int_I",ioa_ini.Imp_Emis_IOA_int_I;"Imp_Emis_IOA_int_X",ioa_ini.Imp_Emis_IOA_int_X];


end

ioa_ini.IOA_OUTPUT_APP = [AGGprofil,Index_Sectors';"Fact Emiss",ioa_ini.Emis_fact_DOM;"Output",initial_value.Output;"M_tot", initial_value.tot_ress_valIMP];

// Recap emissions 
ioa_ini.Recap_Emiss = ["Profil AGG", "Emiss_IOA","Prod_Emis_IOA","Emiss_avoided","Emiss_NetImp","Emiss_Imp","Consist check","Imp_Emis_IOA_APROX", "Emiss_Imp_Emis_IOA_bis","Consist check 2","Emis_Sec","Consist check 3";AGGprofil,ioa_ini.Emiss_IOA_tot,ioa_ini.Prod_Emis_IOA_tot,ioa_ini.Imp_Emis_IOA_APROX_tot,ioa_ini.ImpNet_Emis_IOA_tot,ioa_ini.Imp_Emis_IOA_tot, ioa_ini.Imp_Emis_IOA_APROX_tot - ( ioa_ini.Emiss_IOA_tot-ioa_ini.Prod_Emis_IOA_tot),ioa_ini.Imp_Emis_IOA_APROX_tot, ioa_ini.Imp_Emis_IOA_bis_tot,ioa_ini.Imp_Emis_IOA_APROX_tot- ioa_ini.Imp_Emis_IOA_bis_tot,sum(ioa_ini.Emis_Sect), sum(ioa_ini.Emis_Sect)-ioa_ini.Prod_Emis_IOA_tot];

// Print external files IOA_DECOMP
if Output_files=='True'
csvWrite(ioa_ini.IOA_DECOMP, SAVEDIR_IOA + 'IOA_DECOMP_ini_'+"_"+AGGprofil+'.csv', ';');

if	H_DISAGG <> "HH1"
csvWrite(ioa_ini.IOA_DECOMP_HH, SAVEDIR_IOA + 'IOA_DECOMP_HH_ini'+"_"+AGGprofil+'.csv', ';');
end

csvWrite([AGGprofil,Index_Sectors';[Index_FC'+"_value";FC_value]'], SAVEDIR_IOA + 'FC_value'+"_"+AGGprofil+'.csv', ';');

csvWrite(sum(FC_value,"c")', SAVEDIR_IOA + 'FC_value'+"_TEST"+AGGprofil+'.csv', ';');

csvWrite([["AGG profil";AGGprofil],ioa_ini.A_anal], SAVEDIR_IOA + 'A_anal'+"_"+AGGprofil+'.csv', ';');

csvWrite(ioa_ini.IOA_OUTPUT_APP, SAVEDIR_IOA + 'IOA_OUTPUT_APP'+"_"+AGGprofil+'.csv', ';');

csvWrite(ioa_ini.Recap_Emiss, SAVEDIR_IOA + 'Recap_Emis_BY'+"_"+AGGprofil+'.csv', ';');

// csvWrite(["A",Index_Sectors';[Index_Sectors,ioa_ini.A_DOM]], SAVEDIR_IOA + 'Matrix_A'+"_"+AGGprofil+'.csv', ';');
// csvWrite(["A2",Index_Sectors';[Index_Sectors,ioa_ini.A2]], SAVEDIR_IOA + 'Matrix_A2'+"_"+AGGprofil+'.csv', ';');
// csvWrite(["A3",Index_Sectors';[Index_Sectors,ioa_ini.A3]], SAVEDIR_IOA + 'Matrix_A3'+"_"+AGGprofil+'.csv', ';');
// csvWrite(["A4",Index_Sectors';[Index_Sectors,ioa_ini.A4]], SAVEDIR_IOA + 'Matrix_A4'+"_"+AGGprofil+'.csv', ';');
// csvWrite(["A5",Index_Sectors';[Index_Sectors,ioa_ini.A5]], SAVEDIR_IOA + 'Matrix_A5'+"_"+AGGprofil+'.csv', ';');

// csvWrite([["Emis_fact by Sect",Index_Sectors'];["Emis fact",ioa_ini.Emis_fact_DOM]], SAVEDIR_IOA + 'Emis_fact_DOM'+"_"+AGGprofil+'.csv', ';');
 
// csvWrite(["diag FC value",Index_Sectors';[Index_Sectors,diag(sum(FC_valueDOM,"c"))]], SAVEDIR_IOA + 'Diag_FC'+"_"+AGGprofil+'.csv', ';');
 
 // csvWrite([["Trade decomp",Index_Sectors'];["X_DOM value",initial_value.X_valueDOM'];["X_IMP value",initial_value.X_valueIMP'];["X_value ",initial_value.X_value'];["M_value",initial_value.M_value];["M_value hors reX",initial_value.M_value - initial_value.X_valueIMP' ]], SAVEDIR_IOA + 'TRADE'+"_"+AGGprofil+'.csv', ';');

  // csvWrite(initial_value.X_valueDOM', SAVEDIR_IOA + 'X_DOM'+"_"+AGGprofil+'.csv', ';')
end
 

