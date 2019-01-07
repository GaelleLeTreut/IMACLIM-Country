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

////////////////////////-----------------------------------------------////////////////
////////////////////////          Parameters of projection     ////////////////
								
////////////////////////-----------------------------------------------////////////////

// DEFAULT VALUES OF Parameters//

// All general parameters - not depending on sector aggregation
table_params_general = csv2struct_params(PARAMS_Country+"params_general.csv",1);
nbFields = size(table_params_general);
for i = 1:nbFields(1)
    parameters(table_params_general(i,1)) = table_params_general(i,2);
end

// Defining nb sectors
if AGG_type == ""
    nb_SectorsTEMP = nb_Sectors;
end


// Defining nb of households, if disaggregation
if H_DISAGG == "HH1"
    nb_HouseholdsTEMP = nb_Households;
end
// else
		/////lecture du ficher index, mais juste la premiere colonne
		// Index_EconData_H_DISAGG = read_csv(DATA_Country+H_DISAGG+sep+"Index_EconData_"+H_DISAGG+".csv",";");
		////execstr("Index_EconData_"+H_DISAGG+"=Index_EconData_H_DISAGG"+";");
		
		// Row_Column = unique(Index_EconData_H_DISAGG(:,1));
		////Create two tables for further indexation: one with all row headers and one with all column headers
	
		// elt=find("Column" ==Row_Column);
		
		// NameTemp = Row_Column(elt);
		// TempIndicElt = find( NameTemp ==Index_EconData_H_DISAGG(:,1));
		
		// TableTemp = Index_EconData_H_DISAGG(TempIndicElt,:);
		
		// TableTemp(:,1)=[];
		// TableTemp(:,3:$)=[];
		
		// sizeC_TableTemp = size( TableTemp,"c");
		// i=0;

		// list_varname= unique(TableTemp(:,sizeC_TableTemp-i));
		// SizeR_list_varname = size(list_varname,"r");
		
				//// for each category of column, creating the corresponding index
				// for elt=1:SizeR_list_varname;
					// Ind_Temp= find(TableTemp(:,sizeC_TableTemp-i)==list_varname(elt));
					// execstr("Indice_"+list_varname(elt)+"TEMP"+"=Ind_Temp;")
					// Index_Temp = TableTemp(Ind_Temp,1);
					// execstr("Index_"+list_varname(elt)+"TEMP"+"=Index_Temp;")
					// execstr("nb_"+list_varname(elt)+"TEMP"+"=size(Index_Temp,1);")
				// end

// end


///////////////////////////////////////////////////////////////
// All parameters 1xsect dimension - depend on aggregation profil
///////////////////////////////////////////////////////////////

if AGG_type == ""
    table_params_sect = csv2struct_params(PARAMS_Country+"params_sect"+".csv",nb_SectorsTEMP);
else
    table_params_sect = csv2struct_params(PARAMS_Country+string(AGG_type)+sep+"params_sect_"+string(AGG_type)+".csv",nb_SectorsTEMP);
end

nbFields = size(table_params_sect);
for i = 1:nbFields(1)
    parameters(table_params_sect(i,1)) = table_params_sect(i,2:nb_SectorsTEMP+1);
end

///////////////////////////////////////////////////////////////
// All parameters 1x nb_Households dimension - depend on desaggregation HH profil
///////////////////////////////////////////////////////////////

table_params_HH = csv2struct_params(PARAMS_Country+"params_"+string(H_DISAGG)+".csv",nb_HouseholdsTEMP);

nbFields = size(table_params_HH);
for i = 1:nbFields(1)
    parameters(table_params_HH(i,1)) = table_params_HH(i,2:nb_HouseholdsTEMP+1);
end


///////////////////////////////////////////////////////////////
// All paramaters sect x sect dimension
///////////////////////////////////////////////////////////////

if AGG_type == ""
    parameters.ConstrainedShare_IC=read_csv(PARAMS_Country+"ConstrainedShare_IC"+string(AGG_type)+".csv",";");
    parameters.CarbonTax_Diff_IC=read_csv(PARAMS_Country+"CarbonTax_Diff_IC"+string(AGG_type)+".csv",";");
    parameters.phi_IC=read_csv(PARAMS_Country+"phi_IC"+string(AGG_type)+".csv",";");
else
    parameters.ConstrainedShare_IC=read_csv(PARAMS_Country+string(AGG_type)+sep+"ConstrainedShare_IC_"+string(AGG_type)+".csv",";");
    parameters.CarbonTax_Diff_IC=read_csv(PARAMS_Country+string(AGG_type)+sep+"CarbonTax_Diff_IC_"+string(AGG_type)+".csv",";");
    parameters.phi_IC=read_csv(PARAMS_Country+string(AGG_type)+sep+"phi_IC_"+string(AGG_type)+".csv",";");
end

parameters.ConstrainedShare_IC (1,:) = [];
parameters.ConstrainedShare_IC (:,1) = [];
parameters.ConstrainedShare_IC=evstr(parameters.ConstrainedShare_IC);

parameters.CarbonTax_Diff_IC (1,:) = [];
parameters.CarbonTax_Diff_IC (:,1) = [];
parameters.CarbonTax_Diff_IC=evstr(parameters.CarbonTax_Diff_IC);

parameters.phi_IC (1,:) = [];
parameters.phi_IC (:,1) = [];
parameters.phi_IC=evstr(parameters.phi_IC);


///////////////////////////////////////////////////////////////
// All parameters sect x HH dimension ( or HH dimension x sect )
///////////////////////////////////////////////////////////////
if AGG_type == ""
    parameters.CarbonTax_Diff_C=read_csv(PARAMS_Country+"CarbonTax_Diff_C_"+string(AGG_type)+string(H_DISAGG)+".csv",";");
    parameters.sigma_pC=read_csv(PARAMS_Country+"sigma_pC_"+string(AGG_type)+string(H_DISAGG)+".csv",";");
    parameters.ConstrainedShare_C=read_csv(PARAMS_Country+"ConstrainedShare_C_"+string(AGG_type)+string(H_DISAGG)+".csv",";");
    // if Country=="Brasil"
        // parameters.sigma_ConsoBudget=read_csv(PARAMS_Country+"sigma_ConsoBudget_"+string(H_DISAGG)+".csv",";");
    // end	
else
    parameters.CarbonTax_Diff_C=read_csv(PARAMS_Country+string(AGG_type)+sep+"CarbonTax_Diff_C_"+string(AGG_type)+"_"+string(H_DISAGG)+".csv",";");
    parameters.sigma_pC=read_csv(PARAMS_Country+string(AGG_type)+sep+"sigma_pC_"+string(AGG_type)+"_"+string(H_DISAGG)+".csv",";");
    parameters.ConstrainedShare_C=read_csv(PARAMS_Country+string(AGG_type)+sep+"ConstrainedShare_C_"+string(AGG_type)+"_"+string(H_DISAGG)+".csv",";");
	// if Country=="Brasil"
        // parameters.sigma_ConsoBudget=read_csv(PARAMS_Country+string(AGG_type)+sep+"sigma_ConsoBudget_"+string(AGG_type)+"_"+string(H_DISAGG)+".csv",";");
    // end	 
end

parameters.CarbonTax_Diff_C (1,:) = [];
parameters.CarbonTax_Diff_C (:,1) = [];
parameters.CarbonTax_Diff_C=evstr(parameters.CarbonTax_Diff_C);

parameters.sigma_pC (1,:) = [];
parameters.sigma_pC (:,1) = [];
parameters.sigma_pC=evstr(parameters.sigma_pC);

parameters.ConstrainedShare_C (1,:) = [];
parameters.ConstrainedShare_C (:,1) = [];
parameters.ConstrainedShare_C=evstr(parameters.ConstrainedShare_C);

// if Country=="Brasil" then
    // parameters.sigma_ConsoBudget (1,:) = [];
    // parameters.sigma_ConsoBudget (:,1) = [];
    // parameters.sigma_ConsoBudget=evstr(parameters.sigma_ConsoBudget);
// end						 
