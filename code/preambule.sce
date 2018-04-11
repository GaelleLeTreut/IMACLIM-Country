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


/////////////////////////////////////////////////////////////////////////////////////
////																			/////
////								PREAMBULE									/////
////																			/////
////	This file get all started to scilab to begin being an IMACLIM session   /////
////           It also defines  the *USER CHOICE*  ETUDE                        /////
/////////////////////////////////////////////////////////////////////////////////////

disp( "=====PREAMBLE========");

stacksize(1e8); // max stacksize in new scilab versions
lines(0);       // No asking (continue to display) (scilab option)

// MODEL FILE STRUCTURE

sep = filesep(); // "/" or "\" depending on OS

cd("..");
PARENT    = pwd()  + sep;
CODE      = PARENT + "code"     								 + sep;

LIB       = PARENT + "library" 							     + sep;
getd(LIB); // Charge toutes les fonctions dans LIB

OUTPUT    = PARENT + "outputs"    							 + sep;
mkdir(OUTPUT);

DATA      = PARENT + "data"         + sep; 
STUDY     = PARENT + "study_frames"							 + sep;
PARAMS    = PARENT + "params"    								 + sep;
ROBOT     = PARENT + "robot"     								 + sep;



cd(CODE);

/// READING COUNTRY SELECTION FILE (TO LOAD CORRESPONDIND DATA AND PARAMS AFTER)

listStudyfiles    = listfiles(STUDY);
Nb_Studyfiles     = size(listStudyfiles,"r");
listStudyCSVfiles = list();

// First: remove non .csv files from the list

for elt=1:Nb_Studyfiles
    if strstr(listStudyfiles(elt),".csv")<> ""
        listStudyCSVfiles($+1) = listStudyfiles(elt);
    end
end

for elt=1:size(listStudyCSVfiles)
    matStr = read_csv(STUDY+listStudyCSVfiles(elt),";");
    varname = strsubst(listStudyCSVfiles(elt),".csv","");
    if isdef(varname)
        disp(varname)
        error(" is already defined. please choose a sufix ")
    end
    execstr(varname +"=matStr;");
end


Country_available= Country_Selection(2:$,1);

for elt=1:size(Country_available,"r");
    indtemp= find(Country_Selection(:,1)==Country_available(elt));
    valtemp = Country_Selection(indtemp,2);
    execstr(Country_available(elt)+"=valtemp;")
	
	if Country_available(elt) == "Country"
	Country_ISO = Country_Selection(indtemp,3);
	end
		
end

if (size(Country,"r")<>[1]| size(Country,"r")<>[1])
error ( "various countries have been selected in Country_Selection.csv");
end



// Country specific MODEL FILE STRUCTURE
DATA_Country      = DATA +"data_"+Country_ISO        + sep;  
PARAMS_Country    = PARAMS + "params_"+Country_ISO    + sep;  
STUDY_Country    = STUDY + "study_frames_"+Country_ISO    + sep;


