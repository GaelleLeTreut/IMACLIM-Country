////////////////////////////////////////////////////////////////////////
// load projected and desaggrated data about IOT_Qtities (soft-coupling)
////////////////////////////////////////////////////////////////////////
// Est-ce que c'est mieux de faire cela ici ou bien de le faire dans loading_data et dans aggregation
// le faire avant : c'est plus compact niveau code
// le faire après : on ne charge pas des donneés pour rien
// on ne charge les données qu'une fois

// Import file name
listDatafiles = listfiles(STUDY_Country+Scenario);
Nb_Datafiles = size(listDatafiles,"r");
listCSVfiles=list();
//remove non .csv files from the list
for elt=1:Nb_Datafiles
	if strstr(listDatafiles(elt),".csv")<> ""
	       	listCSVfiles($+1) = listDatafiles(elt);
	end
end

// Create a list with INDEX csv files and with IOT csv files
listIndex = list();
listIOTfiles = list();

for elt=1:size(listCSVfiles)
    // Read all Index csv files and gives them the name of the file itself
	if strstr(listCSVfiles(elt),"IOT_") <> "" then

        listIOTfiles($+1)= listCSVfiles(elt);

        [IndexRow,IndexCol,IOT] = read_table(STUDY_Country+Scenario+sep+listCSVfiles(elt),";");
        varname = strsubst(listCSVfiles(elt),".csv","");
        if isdef(varname)
            warning(varname+" is already defined. please choose a sufix ")
        end
        IOT=evstr(IOT);
        execstr(varname +"=IOT;");

        //Just read all other CSV file

    else
        varname = strsubst(listCSVfiles(elt),".csv","");
        matStr = read_csv(STUDY_Country+Scenario+sep+listCSVfiles(elt),";");
        if isdef(varname)
            warning(varname+" is already defined. please choose a sufix ")
        end
        // Record first line and first column of file
        execstr(varname + '_hline = matStr(1,2:$);');
        execstr(varname + '_hcol = matStr(2:$,1);');
        // Delete them from the data
        matStr(1,:) = [];
        matStr(:,1) = [];
        execstr(varname +"=strtod(matStr);");
    end
end

// Feature to fill and aggregate IOT in projected quantities (which will be delaited later)
// Antoine : à améliorer en créant une fonction générique / en intégrant cela à loading_data, etc.. 
//nb_SectorsTEMP = size(IndRow_IOT_Qtities,1)-1;
//Index_CommoditiesTEMP = IndRow_IOT_Qtities(1:nb_SectorsTEMP);
//Index_SectorsTEMP = Index_CommoditiesTEMP;
// to clear at the end

if nb_Sectors == size(IndexRow,"r")-1 & ScenAgg_IOT==%T
warning("It seems that the "+Scenario+" has the same size of the aggregation profil AGG:"+AGG_type+". The ScenAgg_IOT is turned into false, no need to aggregate scenario")
 ScenAgg_IOT=%F;
end