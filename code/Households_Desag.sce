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


////	Households desegregation


disp("Substep 1: DISAGGREGATION of HOUSEHOLDS...")
// disp("IMACLIM-S is running with various class of households: "+H_DISAGG)

//////////////////////////////////////////////////////////////////
// READ CSV FILES
//////////////////////////////////////////////////////////////////

// Defining nb of households, if disaggregation
// if H_DISAGG == "HH1"
    // nb_HouseholdsTEMP = nb_Households;
// else
		// lecture du ficher index, mais juste la premiere colonne
		Index_EconData_H_DISAGG = read_csv(DATA_Country+H_DISAGG+sep+"Index_EconData_"+H_DISAGG+".csv",";");
		// execstr("Index_EconData_"+H_DISAGG+"=Index_EconData_H_DISAGG"+";");
		
		Row_Column = unique(Index_EconData_H_DISAGG(:,1));
		// Create two tables for further indexation: one with all row headers and one with all column headers
	
		elt=find("Column" ==Row_Column);
		
		NameTemp = Row_Column(elt);
		TempIndicElt = find( NameTemp ==Index_EconData_H_DISAGG(:,1));
		
		TableTemp = Index_EconData_H_DISAGG(TempIndicElt,:);
		
		TableTemp(:,1)=[];
		TableTemp(:,3:$)=[];
		
		sizeC_TableTemp = size( TableTemp,"c");
		i=0;

		list_varname= unique(TableTemp(:,sizeC_TableTemp-i));
		SizeR_list_varname = size(list_varname,"r");
		
				//for each category of column, creating the corresponding index
				for elt=1:SizeR_list_varname;
					Ind_Temp= find(TableTemp(:,sizeC_TableTemp-i)==list_varname(elt));
					execstr("Indice_"+list_varname(elt)+"TEMP"+"=Ind_Temp;")
					Index_Temp = TableTemp(Ind_Temp,1);
					execstr("Index_"+list_varname(elt)+"TEMP"+"=Index_Temp;")
					execstr("nb_"+list_varname(elt)+"TEMP"+"=size(Index_Temp,1);")
				end

// end

listDatafiles = listfiles(DATA_Country+H_DISAGG);
Nb_Datafiles = size(listDatafiles,"r");
listCSVfiles=list();

// First: remove non .csv files from the list
for elt=1:Nb_Datafiles
    if strstr(listDatafiles(elt),".csv")<> ""
        listCSVfiles($+1) = listDatafiles(elt);
    end
end

for elt=1:size(listCSVfiles)
  matStr = read_csv(DATA_Country+H_DISAGG+sep+listCSVfiles(elt),";");
    varname = strsubst(listCSVfiles(elt),".csv","");
    if isdef(varname)
        warning(varname+" is already defined. please choose a sufix ")
    end
    execstr(varname +"=matStr;");
 end



	//	Disaggregation type
		//	Final number of households groups
// Indice_HouseholdsTEMP = [3, 4, 5 , 6, 7, 8, 9, 10, 11, 12];
		//	Labels for the households groups
// Index_HouseholdsTEMP = ["Decile_1","Decile_2","Decile_3","Decile_4","Decile_5","Decile_6","Decile_7","Decile_8","Decile_9","Decile_10"];
		//	Number of households
// nb_HouseholdsTEMP = 10;


//////////////	DISAGGREGATION - HOUSEHOLDS ECONOMIC ACCOUNT  

//	'DataAccount_rate_H10.csv' is the file containing distribution keys for the disaggregation of the Households Economic Account 
//	(CHANGE NOM CAR PLUSIEURS FILES)

	//	Check if the file is consistent with the definition of the disaggregation 
if	Index_HouseholdsTEMP' <> DataAccount_rate_H10(1,2:$)
	error("DataAccount_rate_H10.csv does not correspond to Disaggregation type: wrong number or labels for the households groups (columns)");	
end
	//	Locate in DataAccountTable the values to Disaggregate with the distribution keys (from households' incomes and expenditures surveys)
for elt = 2:size(DataAccount_rate_H10,1)
	ValueName 	= DataAccount_rate_H10(elt, 1) ;
	Location 	= find( ValueName == Index_EconData(:, 2) ) ;
	if	isempty(Location)
		disp("DataAccount_rate_H10.csv does not correspond to Disaggregation type: "+ValueName+" does not appear in DataAccountTable");
	else
		LocationIndex(elt-1)	= Location ;
		ValueNamesDISAG(elt-1) = ValueName ; 
	end
end

	//	Disaggregate the values with the distribution keys
Distrib_keys = evstr( DataAccount_rate_H10(2:$,2:$) );
Disagg_Values = ones(1, size(Distrib_keys,2)) .*. DataAccountTable(LocationIndex,Indice_Households) .* Distrib_keys ;

	//	Eliminating rounded figures to get exact aggregation
if	sum(Distrib_keys,"c") <> 0
	Distrib_keys(:,$)  = ones( size(Distrib_keys,1), 1) - sum(Distrib_keys(:,1:$-1),"c") ;
end
Disagg_Values(:,$) = DataAccountTable(LocationIndex,Indice_Households) - sum(Disagg_Values(:,1:$-1), "c") ;

 
	//	New Economic Data Account
value_DISAG.DataAccountTable = zeros( size(DataAccountTable, 1), size(DataAccountTable, 2) + size(Indice_HouseholdsTEMP,2) -1 );

value_DISAG.DataAccountTable( : , 1:Indice_Households-1 ) = DataAccountTable( : , 1:Indice_Households-1 ) ;
value_DISAG.DataAccountTable( : , Indice_Households+size(Indice_HouseholdsTEMP,2):$ ) = DataAccountTable( : , Indice_Households+1:$ ) ;

value_DISAG.DataAccountTable( LocationIndex , Indice_Households:Indice_Households+size(Indice_HouseholdsTEMP,2)-1 ) = Disagg_Values ;

	//	Calculation of Disposable Income
Location 	= find( "Disposable_Income" == Index_EconData(:,2) );
// Location2 	= find( "H_Income" == Index_EconData(:,4) );
// Location3 	= find( "H_Tax" == Index_EconData(:,4) );

value_DISAG.DataAccountTable(Location, Indice_HouseholdsTEMP ) = sum( value_DISAG.DataAccountTable(Indice_H_Income, Indice_HouseholdsTEMP), "r" ) - sum( abs(value_DISAG.DataAccountTable(Indice_H_Tax, Indice_HouseholdsTEMP)),"r") ;

	//	Calculation of Total Expenditures 
Location 	= find( "Tot_FC_byAgent" == Index_EconData(:,2) );
Location2 	= find( "FC_byAgent" == Index_EconData(:,2) );
Location3 	= find( "GFCF_byAgent" == Index_EconData(:,2) );

value_DISAG.DataAccountTable(Location, Indice_HouseholdsTEMP) = value_DISAG.DataAccountTable(Location2, Indice_HouseholdsTEMP) + value_DISAG.DataAccountTable(Location3, Indice_HouseholdsTEMP) ;

	//	Calculation of NetLending
Location2 	= find( "Disposable_Income" == Index_EconData(:,2) );
Location3 	= find( "NetLending" == Index_EconData(:,2) );

value_DISAG.DataAccountTable(Location3, Indice_HouseholdsTEMP) = value_DISAG.DataAccountTable(Location2,Indice_HouseholdsTEMP) - value_DISAG.DataAccountTable(Location,Indice_HouseholdsTEMP) ;

//////////////	EXPORT DISAGGREGATED ECONOMIC DATA TABLE

Index_InstitAgents_DISAG = Index_InstitAgents(1 : Indice_Households-1 , 1);
Index_InstitAgents_DISAG(Indice_HouseholdsTEMP , 1) = Index_HouseholdsTEMP ;
Index_InstitAgents_DISAG( Indice_Households+size(Indice_HouseholdsTEMP,2):nb_InstitAgents-1+size(Indice_HouseholdsTEMP,2) , 1) = Index_InstitAgents( Indice_Households+1:$ , 1);

DataAccountTable_DISAG = [["", Index_InstitAgents_DISAG'];[Index_DataAccount; "Thousand of euros"], value_DISAG.DataAccountTable];

if Output_files=='True'
csvWrite(DataAccountTable_DISAG,SAVEDIR+"DataAccountTable_DISAG.csv");
end 

	//	Create a new structure (value_DISAG) with all the disaggregated variables
for elt = 1:size(Index_DataAccount,1)
	execstr( "value_DISAG."+Index_DataAccount(elt)+" = value_DISAG.DataAccountTable(elt, :)" )
end
 
// Some values are modified into positive values for a better comprehension of the economics equations
// Il faut remettre certain vecteurs du TEE dans la bonne dimension?

if	Country <> "Brasil" then

	value_DISAG.Other_Direct_Tax = abs(value_DISAG.Other_Direct_Tax);
	value_DISAG.Pensions = abs(value_DISAG.Pensions);
	value_DISAG.Pensions = value_DISAG.Pensions(Indice_HouseholdsTEMP);
	value_DISAG.Unemployment_transfers = abs(value_DISAG.Unemployment_transfers);
	value_DISAG.Unemployment_transfers = value_DISAG.Unemployment_transfers(Indice_HouseholdsTEMP);
	value_DISAG.Other_social_transfers = value_DISAG.Other_social_transfers(Indice_HouseholdsTEMP);
	value_DISAG.Other_social_transfers = abs(value_DISAG.Other_social_transfers);
	value_DISAG.Other_Direct_Tax = value_DISAG.Other_Direct_Tax(Indice_HouseholdsTEMP);

else
																		
    value_DISAG.Gov_social_transfers = abs(value_DISAG.Gov_social_transfers);
    value_DISAG.Gov_social_transfers = value_DISAG.Gov_social_transfers(Indice_HouseholdsTEMP);
    value_DISAG.Corp_social_transfers = abs(value_DISAG.Corp_social_transfers);
    value_DISAG.Corp_social_transfers = value_DISAG.Corp_social_transfers(Indice_HouseholdsTEMP);
    value_DISAG.Gov_Direct_Tax = abs(value_DISAG.Gov_Direct_Tax);
    value_DISAG.Gov_Direct_Tax = value_DISAG.Gov_Direct_Tax(Indice_HouseholdsTEMP);
    value_DISAG.Corp_Direct_Tax = abs(value_DISAG.Corp_Direct_Tax);
    value_DISAG.Corp_Direct_Tax = value_DISAG.Corp_Direct_Tax(Indice_HouseholdsTEMP);


end

value_DISAG.Income_Tax = value_DISAG.Income_Tax(Indice_HouseholdsTEMP);
value_DISAG.Income_Tax = abs(value_DISAG.Income_Tax);

Indice_CorporationsTEMP = find("Corporations" == Index_InstitAgents_DISAG);
value_DISAG.Corporate_Tax = value_DISAG.Corporate_Tax(Indice_CorporationsTEMP);
value_DISAG.Corporate_Tax = abs(value_DISAG.Corporate_Tax);
Indice_RestOfWorldTEMP = find("RestOfWorld" == Index_InstitAgents_DISAG);
value_DISAG.GFCF_byAgent(Indice_RestOfWorldTEMP) = [];


//////////////	DISAGGREGATION - INPUT-OUTPUT TABLES

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
////	Assumptions: Identical price for all household classes, the disaggregation of the value results from the disaggregation of quantities
////		Consistency between values, prices and quantities requires that: Vi = pi * qi = p * (%qi * q), with %qi the distribution keys in quantities
////		Consistency with the Households economic account also requires that: sum(FC_byAgent for each group i) = sum(Vi) = sum( p * (%qi * q) ) 
////			we modify %qi for the composite goods to get this identity
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////		


//	'IOT_rate_H10.csv' is the file containing distribution keys for the disaggregation of the Input-output Table in Quantities

	//	Check if the file is consistent with the definition of the disaggregation

if	Index_HouseholdsTEMP' <> IOT_rate_H10(1,2:$)
	error("IOT_rate_H10.csv does not correspond to Disaggregation type: wrong number or labels for the households groups (columns)"); 
end

	//	Column containing the Aggregate values of Household Consumption C in IOT
	Location2 	= find( "Column" == Index_IOTvalue(:,1) & "C" == Index_IOTvalue(:,2) ) - members("Row", Index_IOTvalue) - 1;

	//	Locate in IOT_FranceQtities the values to Disaggregate with the distribution keys (from households' incomes and expenditures surveys)
	
	LocationIndex = [];
	ValueNamesDISAG = [];
	
for elt = 2:size(IOT_rate_H10,1)
		ValueName 	= IOT_rate_H10(elt, 1);
		
		Location 	= find( "Row" == Index_IOTvalue(:,1) & ValueName == Index_IOTvalue(:,2) ) - 1 ;
		
		if	isempty(Location)
			disp("IOT_rate_H10.csv does not correspond to Disaggregation type: "+ValueName+" does not appear in IOT");
		else		
			LocationIndex(elt-1)	= Location ;
			ValueNamesDISAG(elt-1) 	= ValueName ; 
		end
end
//////////////	DISAGGREGATION - INPUT-OUTPUT TABLE in PRICES

//	Location2, LocationIndex and ValueNamesDISAG do not change if the structure of the IOT matrix in price is the same than the IOT matrix in quantities and values
// DEMANDER A GAELLE COMMENT ELLE CREER LA MATRICE EN PRIX 

	//	Build the disaggregated IOT
value_DISAG.IOT_Prices = zeros( size(IOT_Prices, 1), size(IOT_Prices, 2) + size(Indice_HouseholdsTEMP,2) - 1 );

value_DISAG.IOT_Prices( : , 1:Location2-1 ) = IOT_Prices( : , 1:Location2-1 ) ;
value_DISAG.IOT_Prices( : , Location2+nb_HouseholdsTEMP:$ ) = IOT_Prices( : , Location2+1:$ ) ;

value_DISAG.IOT_Prices( LocationIndex , Location2:Location2+nb_HouseholdsTEMP-1 ) = ones( 1, nb_HouseholdsTEMP) .*. IOT_Prices(1:$-1,Location2) ;



//////////////	DISAGGREGATION - INPUT-OUTPUT TABLE in QUANTITIES

	//	Disaggregate the values with the distribution keys
Distrib_keys = evstr( IOT_rate_H10(2:$,2:$) );
Disagg_Values = [];
Disagg_Values = ones( 1, size(Distrib_keys,2 )) .*. IOT_Qtities(LocationIndex,Location2) .* Distrib_keys ;
	//	Eliminating rounded figures to get exact aggregation
Disagg_Values(:,$) = IOT_Qtities(LocationIndex,Location2) - sum(Disagg_Values(:,1:$-1), "c") ;

	//	Build the disaggregated IOT
value_DISAG.IOT_Qtities = zeros( size(IOT_Qtities, 1), size(IOT_Qtities, 2) + nb_HouseholdsTEMP - 1 );

value_DISAG.IOT_Qtities( : , 1:Location2-1 ) = IOT_Qtities( : , 1:Location2-1 ) ;
value_DISAG.IOT_Qtities( : , Location2+nb_HouseholdsTEMP:$ ) = IOT_Qtities( : , Location2+1:$ ) ;

value_DISAG.IOT_Qtities( LocationIndex , Location2:Location2+nb_HouseholdsTEMP-1 ) = Disagg_Values ;

//////////////	DISAGGREGATION - INPUT-OUTPUT TABLE in VALUES

	//	Build the disaggregated IOT (Price times quantities)
value_DISAG.IOT_Val = zeros( size(IOT_Val, 1) + nb_HouseholdsTEMP - 1, size(IOT_Val, 2) + nb_HouseholdsTEMP - 1 ) ;

Location3 = find( "SpeMarg_C" == Index_IOTvalue(:,2) ) - 1 ;

value_DISAG.IOT_Val( 1:Location3-1 , 1:Location2-1 ) = IOT_Val( 1:Location3-1 , 1:Location2-1 ) ;
value_DISAG.IOT_Val( 1:Location3-1 , Location2+nb_HouseholdsTEMP:$ ) = IOT_Val( 1:Location3-1 , Location2+1:$ ) ;

value_DISAG.IOT_Val( LocationIndex , Location2:Location2+nb_HouseholdsTEMP-1 )  = value_DISAG.IOT_Qtities(1:$-1,Location2:Location2+nb_HouseholdsTEMP-1).*value_DISAG.IOT_Prices(1:$-1,Location2:Location2+nb_HouseholdsTEMP-1) ;

value_DISAG.IOT_Val(Location3+nb_HouseholdsTEMP:$,1:nb_Commodities) = IOT_Val(Location3+1:$,1:nb_Commodities) ;

	//	Energy specific margins (Same energy price, same rate of specific margins: same disaggregation of the specific margin as the energy quantities consumed)

		// 	Location index 2 : sectors in column
for elt = 2:size(IOT_rate_H10,1)
		ValueName 	= IOT_rate_H10(elt, 1);
		
		Location 	= find( "Column" == Index_IOTvalue(:,1) & ValueName == Index_IOTvalue(:,2) ) - members("Row", Index_IOTvalue) - 1 ;
		
		if	isempty(Location)
			disp("IOT_rate_H10.csv does not correspond to Disaggregation type: "+ValueName+" does not appear in IOT");
		else		
			LocationIndex2(elt-1)	= Location ;
			ValueNamesDISAG(elt-1) 	= ValueName ; 
		end
end

		//	Disaggregated matrix of Energy specific margins 
value_DISAG.SpeMarg_C = zeros( nb_HouseholdsTEMP, nb_Commodities ) ;

value_DISAG.SpeMarg_C ( 1:nb_HouseholdsTEMP , LocationIndex2 ) = ones( nb_HouseholdsTEMP, 1) .*. initial_value.SpeMarg_C(:, LocationIndex2) .* Distrib_keys' ; 

		//	Eliminating rounded figures to get exact aggregation
value_DISAG.SpeMarg_C($,:) = initial_value.SpeMarg_C - sum(value_DISAG.SpeMarg_C(1:$-1, :), "r") ;

		//	Insert energy specific margins in the IOT 
value_DISAG.IOT_Val( Location3:Location3+nb_HouseholdsTEMP-1 , 1:size(initial_value.SpeMarg_C,2) ) = value_DISAG.SpeMarg_C ;

//////////////	Consumption accounts Closure (the composite expenditures balance the consumption budget)

		// in value
Location3 = find( "Row" == Index_IOTvalue(:,1) & "Composite" == Index_IOTvalue(:,2) ) - 1 ;
	
value_DISAG.IOT_Val( Location3 , Location2:Location2+nb_HouseholdsTEMP-1 ) = value_DISAG.FC_byAgent(Indice_HouseholdsTEMP) - ( sum(value_DISAG.IOT_Val(:, Location2:Location2+nb_HouseholdsTEMP-1 ),"r") - value_DISAG.IOT_Val(Location3, Location2:Location2+nb_HouseholdsTEMP-1 ) ) ;
		
		// in quantities
value_DISAG.IOT_Qtities( Location3 , Location2:Location2+nb_HouseholdsTEMP-1 ) = value_DISAG.IOT_Val( Location3 , Location2:Location2+nb_HouseholdsTEMP-1 ) ./ value_DISAG.IOT_Prices( Location3 , Location2:Location2+nb_HouseholdsTEMP-1 ) ;

//////////////	DISAGGREGATION - CO2 EMISSIONS

	//	Build the disaggregated IOT
value_DISAG.IOT_CO2Emis = zeros( size(IOT_CO2Emis, 1), size(IOT_CO2Emis, 2) + nb_HouseholdsTEMP - 1 );
value_DISAG.IOT_CO2Emis( : , 1:Location2-1 ) = IOT_CO2Emis( : , 1:Location2-1 ) ;
value_DISAG.IOT_CO2Emis( : , Location2+nb_HouseholdsTEMP:$ ) = IOT_CO2Emis( : , Location2+1:$ ) ;
value_DISAG.IOT_CO2Emis( LocationIndex , Location2:Location2+nb_HouseholdsTEMP-1 ) = ones( 1, nb_HouseholdsTEMP) .*. IOT_CO2Emis(1:$-1,Location2) .* Distrib_keys ;

// CO2Emis_C_2030 = ones( 1, nb_HouseholdsTEMP) .*. CO2Emis_C_2030.* Distrib_keys ;


//////////////	DISAGGREGATION - DEMOGRAPHIC TABLES

	//	Check if the file is consistent with the definition of the disaggregation 
if	Index_HouseholdsTEMP' <> Demography_rate_H10(1,2:$)
	error("Demography_rate_H10.csv does not correspond to Disaggregation type: wrong number or labels for the households groups (columns)");
end

LocationIndex = [];
ValueNamesDISAG = [];

	//	Locate in DataAccountTable the values to Disaggregate with the distribution keys (from households' incomes and expenditures surveys)
for elt = 2:size(Demography_rate_H10,1)
	ValueName 	= Demography_rate_H10(elt, 1) ;
	Location 	= find( ValueName == Demography(:, 1) ) ;
	if	isempty(Location)
		disp("Demography_rate_H10.csv does not correspond to Disaggregation type: "+ValueName+" does not appear in DataAccountTable");
	else
		LocationIndex(elt-1)	= Location ;
		ValueNamesDISAG(elt-1) = ValueName ; 
	end
end

	//	Disaggregate the values with the distribution keys
Distrib_keys = evstr( Demography_rate_H10(2:$,2:$) );
Disagg_Values = []; 
Disagg_Values = ones( 1, size(Distrib_keys,2 )) .*. evstr(Demography(LocationIndex, 2)) .* Distrib_keys ;

	//	Replace Consumption_Units, which are the mean value by household groups(not the distribution key) 
Location3	=	find( "Consumption_Units" == ValueNamesDISAG ) ;
Disagg_Values(Location3,:) = Distrib_keys(Location3,:) ;

//////////////	DISAGGREGATION - IMPORTED PROPORTIONS

//	Assumption: Same proportion for all household classes

	//	Build the disaggregated IOT
value_DISAG.IOT_Import_rate = zeros( size(IOT_Import_rate, 1), size(IOT_Import_rate, 2) + nb_HouseholdsTEMP - 1 );

value_DISAG.IOT_Import_rate( : , 1:Location2-1 ) = IOT_Import_rate( : , 1:Location2-1 ) ;
value_DISAG.IOT_Import_rate( : , Location2+nb_HouseholdsTEMP:$ ) = IOT_Import_rate( : , Location2+1:$ ) ;

value_DISAG.IOT_Import_rate( : , Location2:Location2+nb_HouseholdsTEMP-1 ) = ones( 1, nb_HouseholdsTEMP) .*. IOT_Import_rate(:, Location2) ;


//////////////	DISAGGREGATION - PARAMETERS 

//////////////	EXPORT DISAGGREGATED IOT
	
Location3 	= find( "C" == Index_FC );

if 	Location3==1
	Index_FC_DISAG = ["C_"+Index_HouseholdsTEMP; Index_FC(Location3+1:$)];
else
	Index_FC_DISAG = [Index_FC(1:Location3-1); "C_"+Index_HouseholdsTEMP ; Index_FC(Location3+1:$)];
end
	
	///	Create the final disaggregated IOT (with headings) and export them to .csv files
	
		//	IOT in prices
IOT_Prices_DISAG = [["", Index_Sectors', Index_FC_DISAG', "Tot_uses", "Y", "M"];[Index_Sectors; "euro_per_tep_euro_per_tons"], value_DISAG.IOT_Prices] ;


if Output_files=='True'
csvWrite(IOT_Prices_DISAG,SAVEDIR+"IOT_Prices_DISAG.csv") ;
end
		//	IOT in quantities
IOT_Qtities_DISAG = [["", Index_Sectors', Index_FC_DISAG', "Tot_uses", "Y", "M"];[Index_Sectors; "ktoe_ktons"], value_DISAG.IOT_Qtities] ;

if Output_files=='True'
csvWrite(IOT_Qtities_DISAG,SAVEDIR+"IOT_Qtities_DISAG.csv") ;
end

		//	IOT in values
Location3 	= find( "SpeMarg_C" == Index_IOTvalue(:,2) ) ;

Index_Row_IOT_DISAG = [Index_IOTvalue(2:Location3-1 , 2); Index_IOTvalue(Location3, 2)+"_"++Index_HouseholdsTEMP; Index_IOTvalue(Location3+1:members("Row", Index_IOTvalue)+1 , 2) ] ;
		
IOT_Val_DISAG = [ ["", Index_Sectors', Index_FC_DISAG', "Tot_uses"]; [Index_Row_IOT_DISAG; "Tot_ressources"; "Thousand_of_euros"], value_DISAG.IOT_Val ] ;

if Output_files=='True'
csvWrite(IOT_Val_DISAG,SAVEDIR+"IOT_Val_DISAG.csv") ;
end

		//	IOT in CO2 Emissions
IOT_CO2Emis_DISAG = [ ["", Index_Sectors', "C_"+Index_HouseholdsTEMP', "X"] ; [Index_Sectors; "MtCO2"], value_DISAG.IOT_CO2Emis ] ;

if Output_files=='True'
csvWrite(IOT_CO2Emis_DISAG,SAVEDIR+"IOT_CO2Emis_DISAG.csv") ;
end

		//	IOT - Imported proportions
IOT_Import_rate_DISAG = [ ["", Index_Sectors', Index_FC_DISAG'] ; [Index_Sectors; "Proportion (Without unit)"], [value_DISAG.IOT_Import_rate; zeros(1, size(value_DISAG.IOT_Import_rate, 2)) ] ] ;

if Output_files=='True'
csvWrite(IOT_Import_rate_DISAG,SAVEDIR+"IOT_Import_rate_DISAG.csv") ;
end
		//	Demographic Table
Demography_DISAG = [ ["Socio demograhic variables", Index_HouseholdsTEMP', "units"] ; [ValueNamesDISAG, Disagg_Values, ["Thousands of people"; "Thousands of people"; "Thousands of people"; "Thousands of people"; "Consumption units per household"; "Thousands of people"] ] ] ;

if Output_files=='True'
csvWrite(Demography_DISAG,SAVEDIR+"Demography_DISAG.csv") ;
end

//////////////	NEW STRUCTURE WITH DISAGGREGATED VARIABLES

	//	Consumption prices
execstr( "value_DISAG.pC = value_DISAG.IOT_Prices(Indice_Sectors, "+Location2+":"+Location2+"+nb_HouseholdsTEMP-1);" )

	//	Consumption quantities
execstr( "value_DISAG.C = value_DISAG.IOT_Qtities(Indice_Sectors, "+Location2+":"+Location2+"+nb_HouseholdsTEMP-1);" )

	//	Consumption values
execstr( "value_DISAG.C_value = value_DISAG.IOT_Val(Indice_Sectors, "+Location2+":"+Location2+"+nb_HouseholdsTEMP-1);" )

	//	Demographic variables
for elt = 2:size(Demography,1)
	execstr( "value_DISAG."+Demography(elt,1)+" = Disagg_Values(elt-1, :)" )
end 

//////////////////////////////////////////////////////////////////
// LOADING OTHER INITIAL VALUE
//////////////////////////////////////////////////////////////////

value_DISAG.Carbon_Tax_C = zeros(nb_Commodities,nb_HouseholdsTEMP);



///////////////////////////////////////////////////////////////////////////////////
///// "ANALYZING" Index_IOT_H_DISAG.CSV file for NEW extraction of each category of index  and indices
////////////////////////////////////////////////////////////////////////////////////
Index_IOT_H_DISAG = evstr ( "Index_IOT"+"_"+H_DISAGG);

if AGG_type <> ""
		Index_AGG_type = find(AGG_type == Index_IOT_H_DISAG(1,:));
	elseif AGG_type == ""
		Index_AGG_type ="";
	end
	
	if  AGG_type <> "" & Index_AGG_type==[]
		error("Aggregation type "+AGG_type+" is not defined into Index_IOT_"+H_DISAGG+".csv")
	end

Row_Column = unique(Index_IOT_H_DISAG(:,1));
// Create two tables for further indexation: one with all row headers and one with all column headers

for elt=1:size(Row_Column,"r")

    NameTemp = Row_Column(elt);
    TempIndicElt = find( NameTemp ==Index_IOT_H_DISAG(:,1));

    TableTemp = Index_IOT_H_DISAG(TempIndicElt,:);
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
		
		if  Index_AGG_type <> "" & (sizeC_TableTemp-i) == (Index_AGG_type - 1)
            Index_SectorsAGG = list_varname;
            Ind_AGG = Index;

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
///// "ANALYZING" Index_EconData_H_DISAG.CSV file for NEW extraction of each category of index  and indices for Economic data table
////////////////////////////////////////////////////////////////////////////////////
Index_EconData_H_DISAG = evstr ( "Index_EconData"+"_"+H_DISAGG);

Row_Column = unique(Index_EconData_H_DISAG(:,1));
// Create two tables for further indexation: one with all row headers and one with all column headers

for elt=1:size(Row_Column,"r")

    NameTemp = Row_Column(elt);
    TempIndicElt = find( NameTemp ==Index_EconData_H_DISAG(:,1));

    TableTemp = Index_EconData_H_DISAG(TempIndicElt,:);
    TableTemp(:,1)=[];

    //execstr('TableIndex_'+NameTemp+'=TableTemp;')
    //execstr('SizeC_'+NameTemp +'=size(TableTemp,2);')


    //Deleting empty columns (usefull for TableColumn_Index)
    sizeC_TableTemp = size( TableTemp,"c");
    for i=0:sizeC_TableTemp-1
        if TableTemp(:,sizeC_TableTemp-i)==["-"]
            TableTemp(:,sizeC_TableTemp-i)=[];
        end
    end
    sizeC_TableTemp = size( TableTemp,"c"); //New same of TableTemp after deleting empty columns

    //Covering all column for creating list of index for each category
    for i=0:sizeC_TableTemp-2
        list_varnameTemp = unique(TableTemp(:,sizeC_TableTemp-i));
        list_varname = [];

        //Deleting "-" in list_varname
        SizeR_list_varnameTemp = size(list_varnameTemp,"r");
        for j=1:SizeR_list_varnameTemp
            if list_varnameTemp(j) <> ["-"]
                list_varname(1+$) = list_varnameTemp(j);
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
 
//////////////////////////////////////////////////////////////////
//////////////// Defining various bloc matrix 

value_DISAG.CO2Emis_C		=  value_DISAG.IOT_CO2Emis( 1:$-1 , Location2:Location2+nb_HouseholdsTEMP-1 );
value_DISAG.FC_value 		= [value_DISAG.C_value,initial_value.G_value, initial_value.I_value, initial_value.X_value ];
value_DISAG.pFC 				= [value_DISAG.pC,initial_value.pG, initial_value.pI, initial_value.pX ];
value_DISAG.FC 				= [value_DISAG.C,initial_value.G, initial_value.I, initial_value.X ];
value_DISAG.SpeMarg_FC 		= [value_DISAG.SpeMarg_C; initial_value.SpeMarg_G; initial_value.SpeMarg_I; initial_value.SpeMarg_X];
value_DISAG.SpeMarg 			= [initial_value.SpeMarg_IC; value_DISAG.SpeMarg_FC];
value_DISAG.OthPart_IOT 		= [initial_value.Value_Added; initial_value.M_value; initial_value.Margins; value_DISAG.SpeMarg; initial_value.Taxes];
value_DISAG.FC_Import_rate 	= value_DISAG.IOT_Import_rate(Indice_Sectors, Location2:$);
value_DISAG.FC_valueIMP 		= value_DISAG.FC_value .* value_DISAG.FC_Import_rate ;
value_DISAG.FC_valueDOM 		= value_DISAG.FC_value - value_DISAG.FC_valueIMP ;
value_DISAG.C_Import_rate 	= value_DISAG.IOT_Import_rate(Indice_Sectors, Location2:Location2+nb_HouseholdsTEMP-1 );
value_DISAG.C_valueIMP		= value_DISAG.C_value .* value_DISAG.C_Import_rate ;
value_DISAG.C_valueDOM 		= value_DISAG.C_value - value_DISAG.C_valueIMP ;

indicEltFC = 1;
for elt=1:nb_FC
    varname = Index_FC(elt);
    execstr ("value_DISAG."+"p"+varname+"=value_DISAG.pFC(:,elt);");
	execstr ("value_DISAG."+varname+"_value"+"=value_DISAG.FC_value(:,elt);");
	execstr ("value_DISAG."+varname+"=value_DISAG.FC(:,elt);");
    indicEltFC = 1 + indicEltFC;
end

//////////////////////////////////////////////////////////////////
//////////////	REPLACE DISAGGREGATION VALUES
//////////////////////////////////////////////////////////////////

ValueNamesDISAG = [];
ValueNamesDISAG =	fieldnames(value_DISAG);

	//	Replace disaggregated values in the initial_value structure 
for elt = 1:size( ValueNamesDISAG, 1 )
	if	~isempty ( find ( ValueNamesDISAG(elt) == fieldnames(initial_value) ) )
			execstr("initial_value."+ValueNamesDISAG(elt)+"=value_DISAG."+ValueNamesDISAG(elt)+";")
	// elseif	~isempty ( find ( ValueNamesDISAG(elt) == fieldnames(parameters) ) )
			// execstr("parameters."+ValueNamesDISAG(elt)+"=value_DISAG."+ValueNamesDISAG(elt)+";")
	end	
end

	// Supprimer les variables non nécessaires pour la suite
// value_DISAG = null();
//	clear value_DISAG
