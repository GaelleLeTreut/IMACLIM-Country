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
//	STEP 0: DASHBOARD
/////////////////////////////////////////////////////////////////////////////////////////////

//////////////////////////////////////////////////////////////////
// READ CSV FILES
//////////////////////////////////////////////////////////////////

listStudyfiles    = listfiles(STUDY_Country);
Nb_Studyfiles     = size(listStudyfiles,"r");
listStudyCSVfiles = list();

// First: remove non .csv files from the list

for elt=1:Nb_Studyfiles
    if strstr(listStudyfiles(elt),".csv")<> ""
        listStudyCSVfiles($+1) = listStudyfiles(elt);
    end
end

for elt=1:size(listStudyCSVfiles)
    matStr = read_csv(STUDY_Country+listStudyCSVfiles(elt),";");
    varname = strsubst(listStudyCSVfiles(elt),".csv","");
    if isdef(varname)
        disp(varname)
        error(" is already defined. please choose a sufix ")
    end
    execstr(varname +"=matStr;");
end

/// DASHBOARD FILES

execstr( "Dashboard_Country = Dashboard_"+Country_ISO ); 
Dashboard_component = Dashboard_Country(2:$,1);

// execstr("Dashboard_component = Dashboard_"+Country_ISO+"(2:$,1)");

for elt=1:size(Dashboard_component,"r");
    indtemp= find(Dashboard_Country(:,1)==Dashboard_component(elt));
    valtemp = Dashboard_Country(indtemp,2);
    execstr(Dashboard_component(elt)+"=valtemp;")		
end

if (size(H_DISAGG,"r")<>[1]| size(H_DISAGG,"r")<>[1])
error ( "various types of disaggregation profiles of households have been selected in Dashboard.csv");
end

if (size(AGG_type,"r")<>[1]| size(AGG_type,"r")<>[1])
error ( "various types of aggregation profiles of sectors have been selected in Dashboard.csv");
end

// définir pour l'instant dans le dashboard le niveau d'agregation retenu
// puis écrire ici si Agg pas défini, on le met à "null" par défaut ( faire afficher : niveau d'aggregation choisi par défaut car non défini)

if (size(System_Resol,"r")<>[1]| size(System_Resol,"r")<>[1])
error ( "various types of resolution system have been selected in Dashboard.csv");
end

// Ci-dessous les ajouts suites au passage en mode itératif

if (size(Resol_Mode,"r")<>[1]| size(Resol_Mode,"r")<>[1])
error ( "various types of simulation mode have been selected in Dashboard.csv");
end

Nb_Iter = eval(Nb_Iter);

if Nb_Iter<1
	error("the number of iteration should be positive");
end

if (size(Scenario,"r")<>[1]| size(Scenario,"r")<>[1])
	error ( "various types of resolution system have been selected in Dashboard.csv. The model isn't ready yet to run several sceanrios successively.");
end

if (size(Output_files,"r")<>[1]| size(Output_files,"r")<>[1])
	error ( "You have to choose whether or not you want to print outputs in external files.");
end

