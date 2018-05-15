
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
/////////// Agregation file : aggregation of sectors (only)
//////////////////////////////////////////////////////////////////////

disp("Substep 2: AGGREGATION of DATA...")
//disp("IMACLIM-S is running at aggregated level: "+AGG_type)

/// A REPRENDRE SI AGREGATION DIFFERENTES ENTRE SECTEUR ET COMMODITIES.... AGGREGATION SYMETRIQUE EN LIGNE ET COLONNE

if AGG_type == ""
    nb_SectorsTEMP = nb_Sectors;
else
    nb_SectorsTEMP = size(Index_SectorsAGG,"r");
end


// Reorganizing Index_SectorAGG in right order
//+ SOUCIS d'ordre d'aggregation
// SOUCIS  : l'ordre des secteurs AGG doit etre le meme que celui du fichier index ( par premier ordre d'apparition faudrait changer cela...)

//Ind_AGG: indice de la premiere occurence dans le fichier Index, de chaque element de l'agrégation par ordre alphabetique
// gsort les reclasses dans l'ordre croissance
[noneed, idx] = gsort(Ind_AGG,"r","i");

// Reclasse les secteurs AGG dans le premier ordre d'apparatiob
Index_SectorsAGG = Index_SectorsAGG(idx); // Give all new sectors by order of first apparition in Index_IOTValue.csv files
nb_SectorsAGG = size(Index_SectorsAGG,"r");


///////////////////////////////////////////////////////////////////////////////////
///// "ANALYZING" Index_IOT_AGG_type.CSV file for NEW extraction of each category of index  and indices
////////////////////////////////////////////////////////////////////////////////////
// Index_IOT_AGG_type = evstr ( "Index_IOT"+"_"+AGG_type);

if	H_DISAGG == "HH1"
Index_IOT_AGG_type = evstr ( "Index_IOT"+"_"+AGG_type);
else
Index_IOT_AGG_type = evstr ( "Index_IOT"+"_"+AGG_type+"_"+H_DISAGG);
end

Row_Column = unique(Index_IOT_AGG_type(:,1));
// Create two tables for further indexation: one with all row headers and one with all column headers

for elt=1:size(Row_Column,"r")

    NameTemp = Row_Column(elt);
    TempIndicElt = find( NameTemp ==Index_IOT_AGG_type(:,1));

    TableTemp = Index_IOT_AGG_type(TempIndicElt,:);
    TableTemp(:,1)=[];

    //Deleting empty columns (usefull for TableColumn_Index)
    sizeC_TableTemp = size( TableTemp,"c");
    for i=0:sizeC_TableTemp-1
        if TableTemp(:,sizeC_TableTemp-i)==["-"]
            TableTemp(:,sizeC_TableTemp-i)=[];
        end
    end

    sizeC_TableTemp = size( TableTemp,"c"); //New size of TableTemp after deleting empty columns

    //Covering all column for creating list of index for each category
    for i=0:sizeC_TableTemp-2
        [list_varnameTemp,Index] = unique(TableTemp(:,sizeC_TableTemp-i));
        list_varname = [];

        //Deleting "-" in list_varname
        SizeR_list_varnameTemp = size(list_varnameTemp,"r");
        for j=1:SizeR_list_varnameTemp

            if list_varnameTemp(j) <> ["-"]
                list_varname(1+$) = list_varnameTemp(j);
            elseif list_varnameTemp(j) == ["-"]
                Index(j) = [];
            end
        end

        SizeR_list_varname = size(list_varname,"r");

        //for each category of column, creating the corresponding index
        for elt=1:SizeR_list_varname;
            Ind_Temp= find(TableTemp(:,sizeC_TableTemp-i)==list_varname(elt));
            execstr("Indice_"+list_varname(elt)+"=Ind_Temp;")
            Index_Temp = TableTemp(Ind_Temp,1);
            execstr("Index_"+list_varname(elt)+"=Index_Temp;")
            execstr("nb_"+list_varname(elt)+"=size(Index_Temp,1);")
        end

    end
end

///////////////////////////////////////////////////////////////////////////////////
///// COMPARING ORDER IN NEW SECTORS ORGANIZATION BETWEEN IOT_VALUE FILES (by apparition order) AND IOT_AGG in order to respect the one choosen in IOT_AGG
////////////////////////////////////////////////////////////////////////////////////


// SI index sectors == index sectors AGG on fait comme ca si non il faut changer l'orde de all IND
// Repère les lignes / colonne dans le format initial à agréger ensemble

if Index_SectorsAGG == Index_Sectors
    all_IND =list();
    for elt=1:size(Index_SectorsAGG,"r")
        IND = eval("Indice_"+Index_SectorsAGG(elt));
        all_IND(1+$) = IND;
    end
else all_IND =list();
    for elt=1:size(Index_SectorsAGG,"r")
        IndTempAGG=find(Index_SectorsAGG == Index_Sectors(elt));
        IND = eval("Indice_"+Index_SectorsAGG(IndTempAGG));
        all_IND(1+$) = IND;
        NEW_IND(elt) = IndTempAGG;
    end
    Index_SectorsAGG = Index_SectorsAGG(NEW_IND);
end


////////////////////////////////////////////////////////////////////////////////////
// AGGREGATION OF SOME "BLOC" VARIABLES BEFORE LOADING NEW INDEXATION
////////////////////////////////////////////////////////////////////////////////////

IC_AGG_value = zeros( nb_SectorsAGG,nb_SectorsAGG );
IC_AGG= zeros( nb_SectorsAGG,nb_SectorsAGG );
initial_valueAGG.SpeMarg_IC = zeros( nb_SectorsAGG,nb_SectorsAGG );
if Country=="France"
CO2Emis_IC_2030_AGG = zeros( nb_SectorsAGG,nb_SectorsAGG );
end

// Element with nb_SectorsAGG on line
for line  = 1:nb_SectorsAGG

    //for sector*sector aggregation
    for column = 1:nb_SectorsAGG
        initial_valueAGG.IC_value(line,column) = sum(initial_value.IC_value(all_IND(line),all_IND(column)));
		initial_valueAGG.IC_valueDOM(line,column) = sum(initial_value.IC_valueDOM(all_IND(line),all_IND(column)));
        initial_valueAGG.IC_valueIMP(line,column) = sum(initial_value.IC_valueIMP(all_IND(line),all_IND(column)));
        initial_valueAGG.IC(line,column) = sum(initial_value.IC(all_IND(line),all_IND(column)));
        initial_valueAGG.SpeMarg_IC(line,column)=sum(initial_value.SpeMarg_IC(all_IND(line),all_IND(column)));
        // initial_valueAGG.SpeMarg_IC_DOM(line,column)=sum(initial_value.SpeMarg_IC_DOM(all_IND(line),all_IND(column)));
        // initial_valueAGG.SpeMarg_IC_IMP(line,column)=sum(initial_value.SpeMarg_IC_IMP(all_IND(line),all_IND(column)));
        initial_valueAGG.Carbon_Tax_IC(line,column)=sum(initial_value.Carbon_Tax_IC(all_IND(line),all_IND(column)));
        initial_valueAGG.CO2Emis_IC(line,column)=sum(initial_value.CO2Emis_IC(all_IND(line),all_IND(column)));
		if Country=="France"
		CO2Emis_IC_2030_AGG(line,column)=sum(CO2Emis_IC_2030(all_IND(line),all_IND(column)));
		end
        // Aggregation des matrices IC du RoW
        // IC_RoW  = sum(IC_RoW(all_IND(line),all_IND(column),:));

    end

    //for sector*nb_FC matrix aggregation
    for column=1:nb_FC
        initial_valueAGG.FC_value(line,column)= sum(initial_value.FC_value(all_IND(line),column));
		initial_valueAGG.FC_valueDOM(line,column)= sum(initial_value.FC_valueDOM(all_IND(line),column));
        initial_valueAGG.FC_valueIMP(line,column)= sum(initial_value.FC_valueIMP(all_IND(line),column));
        initial_valueAGG.FC(line,column)= sum(initial_value.FC(all_IND(line),column));
    end

    //for sector*nb_Households matrix aggregation
    for column=1:nb_Households
        initial_valueAGG.Carbon_Tax_C(line,column)= sum(initial_value.Carbon_Tax_C(all_IND(line),column));
		if H_DISAGG <> "HH1"
		initial_valueAGG.C(line,column)= sum(initial_value.C(all_IND(line),column));
		initial_valueAGG.C_value(line,column)= sum(initial_value.C_value(all_IND(line),column));
		initial_valueAGG.C_valueDOM(line,column)= sum(initial_value.C_valueDOM(all_IND(line),column));
		initial_valueAGG.C_valueIMP(line,column)= sum(initial_value.C_valueIMP(all_IND(line),column));
		end
    end


end

// Element for aggregation in one direction only

for column = 1:nb_SectorsAGG

    initial_valueAGG.M_value(:,column) = sum(initial_value.M_value(:,all_IND(column)));
    initial_valueAGG.Y_value(:,column) = sum(initial_value.Y_value(:,all_IND(column)));
initial_valueAGG.Output(:,column) = sum(initial_value.Output(:,all_IND(column)));
    initial_valueAGG.Labour(:,column) = sum(initial_value.Labour(:,all_IND(column)));

    initial_valueAGG.Value_Added(:,column) = sum(initial_value.Value_Added(:,all_IND(column)),"c");
    initial_valueAGG.Margins(:,column) = sum(initial_value.Margins(:,all_IND(column)),"c");
initial_valueAGG.MarginsDOM(:,column) = sum(initial_value.MarginsDOM(:,all_IND(column)),"c");
initial_valueAGG.MarginsIMP(:,column) = sum(initial_value.MarginsIMP(:,all_IND(column)),"c");
    initial_valueAGG.SpeMarg_FC(:,column) = sum(initial_value.SpeMarg_FC(:,all_IND(column)),"c");
    // initial_valueAGG.SpeMarg_FC_IMP(:,column) = sum(initial_value.SpeMarg_FC_IMP(:,all_IND(column)),"c");
    // initial_valueAGG.SpeMarg_FC_DOM(:,column) = sum(initial_value.SpeMarg_FC_DOM(:,all_IND(column)),"c");
    initial_valueAGG.Taxes(:,column) = sum(initial_value.Taxes(:,all_IND(column)),"c");
initial_valueAGG.TaxesDOM(:,column) = sum(initial_value.TaxesDOM(:,all_IND(column)),"c");
initial_valueAGG.TaxesIMP(:,column) = sum(initial_value.TaxesIMP(:,all_IND(column)),"c");

    // Ouput_RoW = sum(Ouput_RoW(:,all_IND(column)),"c");
    // Emis_Row = sum(Emis_Row(:,all_IND(column)),"c");


    //aggregation here by line..
    initial_valueAGG.Y(column,:) = sum(initial_value.Y(all_IND(column)),:);
    initial_valueAGG.M(column,:) = sum(initial_value.M(all_IND(column)),:);
    initial_valueAGG.CO2Emis_C(column,:) = sum(initial_value.CO2Emis_C(all_IND(column),:),:);
	if Country=="France"
	CO2Emis_C_2030_AGG(column,:) = sum(CO2Emis_C_2030(all_IND(column),:),:);
	end
	initial_valueAGG.CO2Emis_X(column,:) = sum(initial_value.CO2Emis_X(all_IND(column)),:);

    // M_RoW_bySectReg = sum(M_RoW_bySectReg(all_IND(column)),:);

    //ERE_balance_AGG(:,column) = sum(initial_value.ERE_balance(:,all_IND(column)));
end

if Country=="France"
CO2Emis_IC_2030 = CO2Emis_IC_2030_AGG;
CO2Emis_C_2030 = CO2Emis_C_2030_AGG;
end

// Pas les specific margins car il faut les recalculer
initial_valueAGG.OthPart_IOT = zeros( nb_OthPart_IOT_AGG , nb_SectorsAGG ) ;
initial_valueAGG.OthPart_IOT = [initial_valueAGG.Value_Added;initial_valueAGG.M_value;initial_valueAGG.Margins;initial_valueAGG.SpeMarg_IC;initial_valueAGG.SpeMarg_FC;initial_valueAGG.Taxes];


///////////////////////////////////////////////////////////////////////////////////
//1. IOT AGG IN VALUE
//Extraction of the third part of the IOT in value
// Definition of the different parts of this third part matrix (value added, specific margins, etc.) in value
///////////////////////////////////////////////////////////////////////////////////

initial_valueAGG.tot_IC_col_val = sum(initial_valueAGG.IC_value , "c");
initial_valueAGG.tot_IC_row_val = sum(initial_valueAGG.IC_value , "r");
initial_valueAGG.tot_FC_value = sum(initial_valueAGG.FC_value,"c");
tot_OthPart_IOT = sum (initial_valueAGG.OthPart_IOT, "r");


indicEltFC = 1;
indicEltVA = 1;
indicEltSpeMarg=1;

for elt=1:nb_FC
    varname = Index_FC(elt);
    execstr ("initial_valueAGG."+varname+"_value"+"=initial_valueAGG.FC_value(:,elt);");
	execstr ('initial_valueAGG.'+varname+'_valueDOM'+'=initial_valueAGG.FC_valueDOM(:,elt);');
	execstr ('initial_valueAGG.'+varname+'_valueIMP'+'=initial_valueAGG.FC_valueIMP(:,elt);');
    indicEltFC = 1 + indicEltFC;
end


for elt=1:nb_OthPart_IOT_AGG

    if find(Index_OthPart_IOT_AGG(elt)==Index_Value_Added) <> []
        varname = Index_OthPart_IOT_AGG(elt);
        initial_valueAGG.Value_Added(indicEltVA,:)=initial_valueAGG.OthPart_IOT(elt,:);
        execstr ("initial_valueAGG."+varname+"=initial_valueAGG.OthPart_IOT(elt,:);");
        indicEltVA = 1 + indicEltVA;

    else if find(Index_OthPart_IOT_AGG(elt)==Index_SpeMarg) <> []
            varname = Index_OthPart_IOT_AGG(elt);
            initial_valueAGG.SpeMarg(indicEltSpeMarg,:)=initial_valueAGG.OthPart_IOT(elt,:);
            execstr ("initial_valueAGG."+varname+"=initial_valueAGG.OthPart_IOT(elt,:);");
            indicEltSpeMarg = 1 + indicEltSpeMarg;

        else
            varname = Index_OthPart_IOT_AGG(elt);
            execstr ("initial_valueAGG."+varname+"=initial_valueAGG.OthPart_IOT(elt,:);");

        end
    end
end

nb_OthPart_IOT = nb_OthPart_IOT_AGG;
Indice_OthPart_IOT = Indice_OthPart_IOT_AGG;
Index_OthPart_IOT = Index_OthPart_IOT_AGG;

// Extraction de la "matrice bloc" des taxes importées et domestiques
initial_valueAGG.VA_Tax_IMP = initial_valueAGG.TaxesIMP(1,:);
initial_valueAGG.Energy_Tax_IC_IMP = initial_valueAGG.TaxesIMP(2,:);
initial_valueAGG.Energy_Tax_FC_IMP = initial_valueAGG.TaxesIMP(3,:);
initial_valueAGG.OtherIndirTax_IMP = initial_valueAGG.TaxesIMP(5,:);

initial_valueAGG.VA_Tax_DOM = initial_valueAGG.TaxesDOM(1,:);
initial_valueAGG.Energy_Tax_IC_DOM = initial_valueAGG.TaxesDOM(2,:);
initial_valueAGG.Energy_Tax_FC_DOM = initial_valueAGG.TaxesDOM(3,:);
initial_valueAGG.OtherIndirTax_DOM = initial_valueAGG.TaxesDOM(5,:);


//Uses in value
initial_valueAGG.tot_uses_val = initial_valueAGG.tot_IC_col_val + initial_valueAGG.tot_FC_value ;
//Ressources in value
initial_valueAGG.tot_ressources_val = initial_valueAGG.tot_IC_row_val + tot_OthPart_IOT ;

// Ressources and uses balance
initial_valueAGG.ERE_balance_val = initial_valueAGG.tot_ressources_val - initial_valueAGG.tot_uses_val' ;
if abs(initial_valueAGG.ERE_balance_val)>= Err_balance_tol then
    disp("Warning : unbalanced IOT AGG")
end

// CHECKING BALANCE OF IMPORTS
// initial_valueAGG.tot_ress_valIMP  = initial_valueAGG.M_value + sum(initial_valueAGG.MarginsIMP,"r")  + sum(initial_valueAGG.SpeMarg_IC_IMP,"r")+ sum(initial_valueAGG.SpeMarg_FC_IMP,"r")  + sum(initial_valueAGG.TaxesIMP,"r");
	// initial_valueAGG.tot_uses_valIMP = sum(initial_valueAGG.IC_valueIMP,"c")+sum(initial_valueAGG.FC_valueIMP,"c");

	initial_valueAGG.tot_ress_valIMP = initial_valueAGG.M_value + sum(initial_valueAGG.MarginsIMP,"r") + sum(initial_valueAGG.TaxesIMP,"r");
	initial_valueAGG.tot_uses_valIMP = sum(initial_valueAGG.IC_valueIMP,"c")+sum(initial_valueAGG.FC_valueIMP,"c");


	initial_valueAGG.ERE_balance_valIMP =initial_valueAGG.tot_ress_valIMP  - initial_valueAGG.tot_uses_valIMP' ;
    if abs(initial_valueAGG.ERE_balance_valIMP)>= Err_balance_tol then
        disp('Warning : unbalanced IOT of IMPORTS AGG')
    end	

	
///////////////////////////////////////////////////////////////////////////////////
// 2. IOT AGG IN QUANTITIES (Ktep)
// Extraction of other variable in quantities
///////////////////////////////////////////////////////////////////////////////////

// initial_valueAGG.IC_Hybrid = initial_valueAGG.IC(Indice_HybridCommod,:);
// initial_valueAGG.FC_Hybrid = initial_valueAGG.FC(Indice_HybridCommod,:);
// initial_valueAGG.M_Hybrid = initial_valueAGG.M(Indice_HybridCommod,:);
// initial_valueAGG.Y_Hybrid = initial_valueAGG.Y(Indice_HybridCommod,:);

initial_valueAGG.tot_IC_col = sum(initial_valueAGG.IC , "c");
initial_valueAGG.tot_FC = sum(initial_valueAGG.FC,"c");
initial_valueAGG.tot_supply = sum (initial_valueAGG.M+initial_valueAGG.Y, "c");

indicEltFC = 1;
for elt=1:nb_FC
    varname = Index_FC(elt);
    execstr ("initial_valueAGG."+varname+"=initial_valueAGG.FC(:,elt);");
    indicEltFC = 1 + indicEltFC;
end


// Checking balance in quantities
initial_valueAGG.ERE_balance = initial_valueAGG.tot_IC_col + initial_valueAGG.tot_FC - initial_valueAGG.tot_supply ;
if abs(initial_valueAGG.ERE_balance)>= Err_balance_tol then
    disp("Warning : unbalanced quantities table")
end

/////////////////
////3. IOT AGG IN  EMISSIONS (MtCO2)
// Extraction of other variable in quantities
/////////////////

// Definition of intermediary consumption matrix in quantities
//initial_valueAGG.CO2Emis_IC = CO2Emis_IC_AGG(Indice_EnerSect,:);
initial_valueAGG.CO2Emis_IC_tot = sum(initial_valueAGG.CO2Emis_IC);

// Definition of households emissions
//initial_valueAGG.CO2Emis_C = CO2Emis_C_AGG(Indice_EnerSect,:);
initial_valueAGG.CO2Emis_C_tot = sum(initial_valueAGG.CO2Emis_C);

initial_valueAGG.tot_CO2Emis =initial_valueAGG.CO2Emis_IC_tot + initial_valueAGG.CO2Emis_C_tot;


/////////////////
////4. CALCULATION AGGREGATED MEANING UNITARY PRICES and IMPORT RATE
/////////////////

// initial_valueAGG.pIC = zeros( nb_Commodities,nb_Sectors );
// initial_valueAGG.pFC = zeros( nb_Commodities,nb_FC );

initial_valueAGG.IC_Import_rate = zeros( nb_Commodities,nb_Sectors );
initial_valueAGG.FC_Import_rate = zeros( nb_Commodities,nb_FC );

// IC_value_HybridAGG = initial_valueAGG.IC_value(nb_Commodities,:);
// FC_value_HybridAGG = initial_valueAGG.IC_value(nb_Commodities,:);
// M_value_HybridAGG=initial_valueAGG.M_value(:,nb_Commodities);


// Que pour les hybrid commodities

for line  = 1:nb_Commodities

    for column = 1:nb_Sectors
        if initial_valueAGG.IC_value(line,column) == 0
            // initial_valueAGG.pIC(line,column) = 10^-15;
            initial_valueAGG.IC_Import_rate(line,column) = 0;
        else
            // initial_valueAGG.pIC(line,column)= initial_valueAGG.IC_value(line,column)/initial_valueAGG.IC(line,column);
            initial_valueAGG.IC_Import_rate(line,column)= initial_valueAGG.IC_valueIMP(line,column)/initial_valueAGG.IC_value(line,column);
        end
    end

    for column=1:nb_FC
        if initial_valueAGG.FC_value(line,column) == 0
            // initial_valueAGG.pFC(line,column) = 10^-15;
            initial_valueAGG.FC_Import_rate(line,column) = 0;
        else
            // initial_valueAGG.pFC(line,column) = initial_valueAGG.FC_value(line,column)/initial_valueAGG.FC(line,column);
            initial_valueAGG.FC_Import_rate(line,column) = initial_valueAGG.FC_valueIMP(line,column)/initial_valueAGG.FC_value(line,column);
        end
    end

end

indicEltFC = 1;
for elt=1:nb_FC
varname = Index_FC(elt);
// execstr ('initial_valueAGG.'+'p'+varname+'=initial_valueAGG.pFC(:,elt);');
execstr ('initial_valueAGG.'+varname+'_Import_rate'+'=initial_valueAGG.FC_Import_rate(:,elt);');
indicEltFC = 1 + indicEltFC;
end

// for line= 1:nb_Commodities
// if initial_valueAGG.M(line) ==0
// initial_valueAGG.pM(line) = 10^-15;
// else
// initial_valueAGG.pM(line) = initial_valueAGG.M_value(line)/initial_valueAGG.M(line);
// end
// end

// for line= 1:nb_Commodities
// if initial_valueAGG.Y(line) ==0
// initial_valueAGG.pY(line) = 10^-15;
// else
// initial_valueAGG.pY(line) = initial_valueAGG.Y_value(1,line)/initial_valueAGG.Y(line);
// end
// end



/////////////////
////5. REPLACE INITIAL.VALUE structure by info into INITIAL_VALUEAGG
/////////////////

// just for checking if all values are aggregated of if someone is missing
listOKAGG = list();
listNOAGG = list();
listInitVal = fieldnames(initial_value);

for i = 1:size(listInitVal,"r")
    if isfield ( initial_valueAGG,listInitVal(i))
        listOKAGG(1+$) = listInitVal(i);
    else listNOAGG(1+$) = listInitVal(i);
    end
end

// Deleting field with SpeMarg names in initial_value structure

for elt=1:size(listInitVal,"r")
    if  strstr(listInitVal(elt),"SpeMarg_") <> ""
        execstr("initial_value."+listInitVal(elt)+"=null();")
    end
end

// Replacing in initial_value; all values contained in initial_valueAGG
listInitValAGG = fieldnames (initial_valueAGG);


for i = 1:size(listInitValAGG,"r")
    execstr("initial_value."+listInitValAGG(i)+"=initial_valueAGG."+listInitValAGG(i)+";")
end

// Deleting initial_valueAGG structure
// initial_valueAGG = null();
// clear initial_valueAGG

//+ Test de cohérence si aggregation OK





