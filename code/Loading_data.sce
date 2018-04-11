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

// Accepted error for ERE balance
Err_balance_tol = 10^-2;

//////////////////////////////////////////////////////////////////
// READ CSV FILES
//////////////////////////////////////////////////////////////////

listDatafiles = listfiles(DATA_Country);
Nb_Datafiles = size(listDatafiles,"r");
listCSVfiles=list();

// First: remove non .csv files from the list
for elt=1:Nb_Datafiles
    if strstr(listDatafiles(elt),".csv")<> ""
        listCSVfiles($+1) = listDatafiles(elt);
    end
end

//////////////////////////////////////////////////////////////////
// READ INDEX LIST and IOT LIST and other CSV files
//////////////////////////////////////////////////////////////////

// Create a list with INDEX csv files and with IOT csv files
listIndex = list();
listIOTfiles = list();

for elt=1:size(listCSVfiles)

    // Read all Index csv files and gives them the name of the file itself
    if strstr(listCSVfiles(elt),"Index_") <> ""

        listIndex($+1)= listCSVfiles(elt);

        matStr = read_csv(DATA_Country+listCSVfiles(elt),";");
        varname = strsubst(listCSVfiles(elt),".csv","");
        if isdef(varname)
            warning(varname+" is already defined. please choose a sufix ")
        end
        execstr(varname +"=matStr;");

        //size of some index
        //varnametemp = strsubst(varname,"Index_","");
        //execstr('nb_'+varnametemp +'=size(matStr,2);') // Take the number of column only

        //Read all IOT csv files and gives them the name of the file itself
    else if strstr(listCSVfiles(elt),"IOT_") <> ""

            listIOTfiles($+1)= listCSVfiles(elt);

            [IndexRow,IndexCol,IOT] = read_table(DATA_Country+listCSVfiles(elt),";");
            varname = strsubst(listCSVfiles(elt),".csv","");
            if isdef(varname)
                warning(varname+" is already defined. please choose a sufix ")
            end
            IOT=evstr(IOT);
            //round value to 10^-2 decimal troncature
            // IOT =round_decimal(IOT,10^-2);
            execstr(varname +"=IOT;");
            execstr("IndRow_"+varname+"=IndexRow;");
            execstr("IndCol_"+varname +"=IndexCol;");

            //Just read all other CSV file

        else
            matStr = read_csv(DATA_Country+listCSVfiles(elt),";");
            varname = strsubst(listCSVfiles(elt),".csv","");
            if isdef(varname)
                warning(varname+" is already defined. please choose a sufix ")
            end
            execstr(varname +"=matStr;");
        end
    end
end

////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////
//////////LOADING IOT TABLE IN MONETARY VALUE / QUANTITIES / PRICES & EMISSIONS
////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////


////////////////////////////////////////////////////////////////////////////////////
///// "ANALYZING" Index_IOTvalue.CSV file for extraction of each category of index
////////////////////////////////////////////////////////////////////////////////////

// If H_DISAGG == "HH1" , on peut définir maintenant le type d'agrégation, si non il faut attendre la fin de la désagrégation des ménages
if H_DISAGG == "HH1"
	if AGG_type <> ""
		Index_AGG_type = find(AGG_type == Index_IOTvalue(1,:));
	elseif AGG_type == ""
		Index_AGG_type ="";
	end
	
	if  AGG_type <> "" & Index_AGG_type==[]
		error("Aggregation type "+AGG_type+" is not defined into Index_IOT.csv")
	end
end

Row_Column = unique(Index_IOTvalue(2:$,1));
// Create two tables for further indexation: one with all row headers and one with all column headers

for col_row=1:size(Row_Column,"r")

    NameTemp = Row_Column(col_row);
    TempIndicElt = find( NameTemp ==Index_IOTvalue(:,1));

    TableTemp = Index_IOTvalue(TempIndicElt,:);
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


        // Creation of aggregation list sector if there is no HH desagregation ( if there is HH disaggregation Index_SectorsAGG is defined after this disaggregation)	
        if H_DISAGG == "HH1" & Index_AGG_type <> "" & (sizeC_TableTemp-i) == (Index_AGG_type - 1)
            Index_SectorsAGG = list_varname;
            Ind_AGG = Index;

        end

        // Creation of aggregation list sector
        // SizeR_list_varname = size(list_varname,"r");
        // for elt = 1:SizeR_list_varname-1
        // if list_varname(elt) == ["Aggregation"]
        // list_varname(elt) = [];
        // Index(elt) =[];
        // Index_SectorsAGG = list_varname;
        // Ind_AGG = Index;
        // end
        // end

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


/////////////////
//1. FILL IOT IN VALUE
/////////////////


// Definition of intermediary consumption matrix in value
[initial_value.IC_value] = fill_table(IOT_Val,IndRow_IOT_Val,IndCol_IOT_Val,Index_Commodities,Index_Sectors);
initial_value.tot_IC_col_val = sum(initial_value.IC_value , "c");
initial_value.tot_IC_row_val = sum(initial_value.IC_value , "r");

// Definition of final consumption matrix in value
[initial_value.FC_value] = fill_table(IOT_Val,IndRow_IOT_Val,IndCol_IOT_Val,Index_Commodities, Index_FC);
initial_value.tot_FC_value = sum(initial_value.FC_value,"c");

indicEltFC = 1;

for elt=1:nb_FC
    varname = Index_FC(elt);
    execstr ("initial_value."+varname+"_value"+"=initial_value.FC_value(:,elt);");
    indicEltFC = 1 + indicEltFC;
end


// Extraction of the third part of the IOT
// Definition of the different parts of this third part matrix (value added, specific margins, etc.) in value
[initial_value.OthPart_IOT] = fill_table(IOT_Val,IndRow_IOT_Val,IndCol_IOT_Val,Index_OthPart_IOT, Index_Sectors);
tot_OthPart_IOT = sum (initial_value.OthPart_IOT, "r");

[initial_value.Value_Added] = fill_table(IOT_Val,IndRow_IOT_Val,IndCol_IOT_Val,Index_Value_Added, Index_Sectors);
[initial_value.Margins] = fill_table(IOT_Val,IndRow_IOT_Val,IndCol_IOT_Val,Index_Margins, Index_Sectors);
[initial_value.SpeMarg] = fill_table(IOT_Val,IndRow_IOT_Val,IndCol_IOT_Val,Index_SpeMarg, Index_Sectors);
[initial_value.SpeMarg_FC] = fill_table(IOT_Val,IndRow_IOT_Val,IndCol_IOT_Val,Index_SpeMarg_FC, Index_Sectors);
[initial_value.SpeMarg_IC] = fill_table(IOT_Val,IndRow_IOT_Val,IndCol_IOT_Val,Index_SpeMarg_IC, Index_Sectors);
[initial_value.Taxes] = fill_table(IOT_Val,IndRow_IOT_Val,IndCol_IOT_Val,Index_Taxes, Index_Sectors);

indicEltVA = 1;
indicEltSpeMarg = 1;

for elt=1:nb_OthPart_IOT

    if find(Index_OthPart_IOT(elt)==Index_Value_Added) <> []
        varname = Index_OthPart_IOT(elt);
        initial_value.Value_Added(indicEltVA,:)=initial_value.OthPart_IOT(elt,:);
        execstr ("initial_value."+varname+"=initial_value.OthPart_IOT(elt,:);");
        indicEltVA = 1 + indicEltVA;

    else if find(Index_OthPart_IOT(elt)==Index_SpeMarg) <> []
            varname = Index_OthPart_IOT(elt);
            initial_value.SpeMarg(indicEltSpeMarg,:)=initial_value.OthPart_IOT(elt,:);
            execstr ("initial_value."+varname+"=initial_value.OthPart_IOT(elt,:);");
            indicEltSpeMarg = 1 + indicEltSpeMarg;

        else
            varname = Index_OthPart_IOT(elt);
            execstr ("initial_value."+varname+"=initial_value.OthPart_IOT(elt,:);");

        end
    end
end

initial_value.Y_value = sum(initial_value.Value_Added,"r") + initial_value.tot_IC_row_val  ;

//Uses in value
initial_value.tot_uses_val = initial_value.tot_IC_col_val + initial_value.tot_FC_value ;
//Ressources in value
initial_value.tot_ressources_val = initial_value.tot_IC_row_val + tot_OthPart_IOT ;

// Ressources and uses balance
initial_value.ERE_balance_val = initial_value.tot_ressources_val - initial_value.tot_uses_val';
// initial_value.ERE_balance_val = round_decimal(initial_value.ERE_balance_val,10^-2) ;
if abs(initial_value.ERE_balance_val)>= Err_balance_tol then
    disp("Warning : unbalanced IOT")
end

// Error en M_value if M<>0 , if not, error in X
initial_value.M_value = (initial_value.M_value<>0).*(initial_value.M_value - initial_value.ERE_balance_val);
initial_value.OthPart_IOT(find(Index_OthPart_IOT=="M_value"),:) = initial_value.M_value;

initial_value.Profit_margin = (initial_value.M_value==0).*(initial_value.Profit_margin - initial_value.ERE_balance_val)+(initial_value.M_value<>0).*initial_value.Profit_margin;

initial_value.Value_Added(find(Index_Value_Added=="Profit_margin"),:) = initial_value.Profit_margin;

initial_value.OthPart_IOT(find(Index_OthPart_IOT=="Profit_margin"),:) = initial_value.Profit_margin;
tot_OthPart_IOT = sum (initial_value.OthPart_IOT, "r");

// New check ressources and uses balances
//Uses in value
initial_value.tot_uses_val = initial_value.tot_IC_col_val + initial_value.tot_FC_value ;

//Ressources in value
initial_value.tot_ressources_val = initial_value.tot_IC_row_val + tot_OthPart_IOT ;

// Ressources and uses balance
initial_value.ERE_balance_val = initial_value.tot_ressources_val - initial_value.tot_uses_val' ;
if abs(initial_value.ERE_balance_val)>= Err_balance_tol then
    disp("Warning : unbalanced IOT")
end


IC_value_Hybrid = initial_value.IC_value(Indice_HybridCommod,:);
FC_value_Hybrid = initial_value.IC_value(Indice_HybridCommod,:);

/////////////////
//2. FILL IOT IN QUANTITIES (Ktep)
/////////////////

// Definition of intermediary consumption matrix in quantities

[initial_value.IC] = fill_table(IOT_Qtities,IndRow_IOT_Qtities,IndCol_IOT_Qtities,Index_Commodities,Index_Sectors);

initial_value.tot_IC_col = sum(initial_value.IC , "c");

// Definition of final consumption matrix in quantities
[initial_value.FC] = fill_table( IOT_Qtities,IndRow_IOT_Qtities,IndCol_IOT_Qtities,Index_Commodities, Index_FC);
//[initial_value.FC_Hybrid] = fill_table( IOT_FranceQtities,IndRow_IOT_FranceQtities,IndCol_IOT_FranceQtities,Index_HybridCommod, Index_FC);
initial_value.tot_FC = sum(initial_value.FC,"c");

indicEltFC = 1;
for elt=1:nb_FC
    varname = Index_FC(elt);
    execstr ("initial_value."+varname+"=initial_value.FC(:,elt);");
    indicEltFC = 1 + indicEltFC;
end

// Definition of prod and imports in quantities
[initial_value.Y] = fill_table( IOT_Qtities,IndRow_IOT_Qtities,IndCol_IOT_Qtities,Index_Commodities,"Y");
[initial_value.M] = fill_table( IOT_Qtities,IndRow_IOT_Qtities,IndCol_IOT_Qtities,Index_Commodities,"M");
initial_value.tot_supply = sum (initial_value.M+initial_value.Y, "c");

// Checking balance in quantities
initial_value.ERE_balance = initial_value.tot_IC_col + initial_value.tot_FC - initial_value.tot_supply ;
if abs(initial_value.ERE_balance)>= Err_balance_tol then
    disp("Warning : unbalanced quantities table")
end


// Error en Y if Y<>0 , if not, error in X
initial_value.Y = (initial_value.Y<>0).*(initial_value.Y + initial_value.ERE_balance);

initial_value.X = (initial_value.Y==0).*(initial_value.X - initial_value.ERE_balance)+(initial_value.Y<>0).*initial_value.X;

initial_value.tot_supply = sum (initial_value.M+initial_value.Y, "c");
initial_value.FC(:,find(Index_FC=="X")) = initial_value.X;
initial_value.tot_FC = sum(initial_value.FC,"c");

// New check ressources and uses balances
initial_value.ERE_balance = initial_value.tot_IC_col + initial_value.tot_FC - initial_value.tot_supply ;
if abs(initial_value.ERE_balance)>= Err_balance_tol then
    disp("Warning : unbalanced quantities table")
end


/////////////////
//3. FILL IOT IN UNITARY PRICES
/////////////////

// Import of IOT file of prices

[initial_value.pIC] = fill_table( IOT_Prices,IndRow_IOT_Prices,IndCol_IOT_Prices,Index_Commodities,Index_Sectors);
[initial_value.pFC] = fill_table(IOT_Prices,IndRow_IOT_Prices,IndCol_IOT_Prices,Index_Commodities,Index_FC);

indicEltFC = 1;
for elt=1:nb_FC
    varname = Index_FC(elt);

    execstr ("initial_value."+"p"+varname+"=initial_value.pFC(:,elt);");
    indicEltFC = 1 + indicEltFC;
end

[initial_value.pM] = fill_table( IOT_Prices,IndRow_IOT_Prices,IndCol_IOT_Prices,Index_Commodities,"M");
[initial_value.pY] = fill_table(IOT_Prices,IndRow_IOT_Prices,IndCol_IOT_Prices,Index_Commodities,"Y");


/////////////////
//4. FILL IOT IN EMISSIONS (MtCO2)
/////////////////

// Definition of intermediary consumption matrix in quantities
[initial_value.CO2Emis_IC] = fill_table(IOT_CO2Emis,IndRow_IOT_CO2Emis,IndCol_IOT_CO2Emis,Index_Commodities,Index_Sectors);
//initial_value.CO2Emis_IC = CO2Emis_IC(Indice_EnerSect,:);
initial_value.Tot_CO2Emis_IC = sum(initial_value.CO2Emis_IC);

// Definition of households emissions
[initial_value.CO2Emis_C] = fill_table(IOT_CO2Emis,IndRow_IOT_CO2Emis,IndCol_IOT_CO2Emis,Index_Commodities,"C");
//initial_value.CO2Emis_C = CO2Emis_C(Indice_EnerSect,:);
initial_value.Tot_CO2Emis_C = sum(initial_value.CO2Emis_C);

[initial_value.CO2Emis_X] = fill_table(IOT_CO2Emis,IndRow_IOT_CO2Emis,IndCol_IOT_CO2Emis,Index_Commodities,"X");


initial_value.Tot_CO2Emis =initial_value.Tot_CO2Emis_IC + initial_value.Tot_CO2Emis_C;

if Country == "France";
// emissions in 2030 ( from snbc)
CO2Emis_IC_2030 = fill_table(IOT_CO2Emis_2030,IndRow_IOT_CO2Emis_2030,IndCol_IOT_CO2Emis_2030,Index_Commodities,Index_Sectors);
Tot_CO2Emis_IC_2030 = sum(CO2Emis_IC_2030);
CO2Emis_C_2030 = fill_table(IOT_CO2Emis_2030,IndRow_IOT_CO2Emis_2030,IndCol_IOT_CO2Emis_2030,Index_Commodities,"C");
Tot_CO2Emis_C_2030 = sum(CO2Emis_C_2030);
Tot_CO2Emis_2030 = Tot_CO2Emis_C_2030 + Tot_CO2Emis_IC_2030;
end

////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////
//////////LOADING ECONOMICS DATA (TEE)
////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////

Row_Column = unique(Index_EconData(:,1));
// Create two tables for further indexation: one with all row headers and one with all column headers

for elt=1:size(Row_Column,"r")

    NameTemp = Row_Column(elt);
    TempIndicElt = find( NameTemp ==Index_EconData(:,1));

    TableTemp = Index_EconData(TempIndicElt,:);
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

/////////////////
//FILL ECONOMICS DATA ACCOUNTS (MONETARY VALUE)
/////////////////

DataAccountTable(1,:)=[];
DataAccountTable(:,1)=[];
DataAccountTable=eval(DataAccountTable);
indicEltDataAccountFC = 1;
for elt=1:nb_DataAccount
    varname = Index_DataAccount(elt);
    valtemp=evstr(DataAccountTable(elt,:));
    execstr ("initial_value."+varname+"=valtemp;");
    indicEltDataAccountFC = 1 + indicEltDataAccountFC;
end

// Some values are modified into positive values for a better comprehension of the economics equations

if Country=="Brasil" then
 initial_value.Gov_social_transfers = initial_value.Gov_social_transfers(Indice_Households);
    initial_value.Gov_social_transfers = abs(initial_value.Gov_social_transfers);
    initial_value.Gov_Direct_Tax = initial_value.Gov_Direct_Tax(Indice_Households);
    initial_value.Gov_Direct_Tax = abs(initial_value.Gov_Direct_Tax);
    initial_value.Corp_social_transfers = initial_value.Corp_social_transfers(Indice_Households);
    initial_value.Corp_social_transfers = abs(initial_value.Corp_social_transfers);
    initial_value.Corp_Direct_Tax = initial_value.Corp_Direct_Tax(Indice_Households);
    initial_value.Corp_Direct_Tax = abs(initial_value.Corp_Direct_Tax);

else	

    initial_value.Other_social_transfers = initial_value.Other_social_transfers(Indice_Households);
    initial_value.Other_social_transfers = abs(initial_value.Other_social_transfers);
    initial_value.Other_Direct_Tax = initial_value.Other_Direct_Tax(Indice_Households);
    initial_value.Other_Direct_Tax = abs(initial_value.Other_Direct_Tax);
    initial_value.Unemployment_transfers = abs(initial_value.Unemployment_transfers);
    initial_value.Pensions = abs(initial_value.Pensions);
    initial_value.Pensions = initial_value.Pensions(Indice_Households);
    initial_value.Unemployment_transfers = initial_value.Unemployment_transfers(Indice_Households);
   
end

initial_value.Income_Tax = initial_value.Income_Tax(Indice_Households);
initial_value.Corporate_Tax = initial_value.Corporate_Tax(Indice_Corporations);
initial_value.GFCF_byAgent(Indice_RestOfWorld) = [];

initial_value.Income_Tax = abs(initial_value.Income_Tax);

initial_value.Corporate_Tax = abs(initial_value.Corporate_Tax);
//////////////////////////////////////////////////////////////////
// READ OTHER CSV FILES
//////////////////////////////////////////////////////////////////


// Labour file (Thousand Full time equivalent)
[IndexRow_Labour,IndexCol_Labour,Labour] = read_table(DATA_Country+"Labour.csv",";");
[initial_value.Labour] = fill_table( Labour,IndexRow_Labour,IndexCol_Labour,"Labour",Index_Sectors);


// Demographic data file
Demography(:, size(Demography,"c")) = [];
list_demo_variable= Demography(2:$,1);

for elt=1:size(list_demo_variable,"r");
    indtemp= find(Demography(:,1)==list_demo_variable(elt));
    valtemp = evstr(Demography(indtemp,2));
    execstr("initial_value."+list_demo_variable(elt)+"=valtemp;")
end

// Distribution share file

Index_IncomeSources = Distribution_Shares_form (2:$,1);
nb_IncomeSources = size(Distribution_Shares_form (2:$,1),"r");

for elt=1:nb_IncomeSources;
    execstr("Indice_"+Index_IncomeSources(elt)+"=elt;")
end


// IC Domestic and imports tables
[initial_value.IC_Import_rate] = fill_table( IOT_Import_rate,IndRow_IOT_Import_rate,IndCol_IOT_Import_rate,Index_Commodities,Index_Sectors);

// FC Domestic and imports tables
[initial_value.FC_Import_rate] = fill_table( IOT_Import_rate,IndRow_IOT_Import_rate,IndCol_IOT_Import_rate,Index_Commodities,Index_FC);

// USED for aggregation and aggregated rate
initial_value.IC_valueIMP = initial_value.IC_value .* initial_value.IC_Import_rate;
initial_value.FC_valueIMP = initial_value.FC_value .* initial_value.FC_Import_rate;



//////////////////////////////////////////////////////////////////
// LOADING OTHER INITIAL VALUE
//////////////////////////////////////////////////////////////////

initial_value.Carbon_Tax_IC = zeros(nb_Commodities,nb_Sectors);
initial_value.Carbon_Tax_C = zeros(nb_Commodities,nb_Households);


//////////////////////////////////////////////////////////////////
// READ CSV FILES FOR RoW approximation of Emissions embodied in imports
//////////////////////////////////////////////////////////////////
if Country=="France" then

listDataRoWfiles = listfiles(DATA_Country+'Data_RoW' );
Nb_Datafiles = size(listDataRoWfiles,"r");
listCSVfiles=list();

  // First: remove non .csv files from the list
	indicElt = 1;
for elt=1:Nb_Datafiles	
    if strstr(listDataRoWfiles(elt),'.csv')<> ''
        listCSVfiles($+1) = listDataRoWfiles(elt);
    else indicElt = indicElt + 1;
    end
end

indicElt = 1;
for elt=1:size(listCSVfiles)
	// Read all Index csv files and gives them the name of the file itself
	if strstr(listCSVfiles(elt),'Index_') <> ''
		
		listIndex($+1)= listCSVfiles(elt);
				
		matStr = read_csv(DATA_Country+'Data_RoW'+sep+listCSVfiles(elt),';');
		varname = strsubst(listCSVfiles(elt),".csv","");
		if isdef(varname)
		disp(varname)
		error(' is already define. please choose a sufix ')
		end
		execstr(varname +'=matStr;');
			
	else 
			matStr = read_csv(DATA_Country+'Data_RoW'+sep+listCSVfiles(elt),';');
			matStr =evstr(matStr);
			varname = strsubst(listCSVfiles(elt),".csv","");
			if isdef(varname)
			disp(varname)
			error(' is already define. please choose a sufix ')
			end
			execstr(varname +'=matStr;');
			indicElt = indicElt + 1;
	end
end

if AGG_type <> ""
CoefCO2_reg = eval('CoefCO2_reg_'+string(AGG_type));
end


nb_RoW = size(Index_Region,"c");

end

// //Put each IC matrix of different country into a 3D matrix ( sectors, sectors, region) 
// // IC_RoW = zeros(nb_Commodities,nb_Sectors,nb_RoW);

// // for cur_reg = 1:nb_RoW 
// // IC_RoW(:,:,cur_reg) = evstr('IC_'+Index_Region(cur_reg)+';');
// // end



// If AGGREGATION - execution of aggregation file	
//////////////////////////////////////////////////////////////////
//EXEC AGGREGATION.SCE //Execute agreagation.sce file if Index_SectorsAGG is defined
//////////////////////////////////////////////////////////////////	

// ADD IC_RoW  ,Emis_Row , Ouput_RoW, M_RoW_bySectReg
	
//////////////////////////////////////////////////////////////////
// EXEC DecompImpDom_value.SCE  Execute decomposition IOT_table value into domestics and importations elements 
//////////////////////////////////////////////////////////////////	

