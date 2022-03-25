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
        print(out,varname)
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

if (size(study,"r")<>[1]| size(study,"r")<>[1])
    error ( "various studies have been selected in Dashboard.csv");
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
    error ( "various types of scenario have been selected in Dashboard.csv. The model isn't ready yet to run several Scenarios successively.");
end

if (size(Macro_nb,"r")<>[1]| size(Macro_nb,"r")<>[1])
    error ( "various types of macroeconomic framework been selected in Dashboard.csv.");
end

if (size(Recycling_Option,"r")<>[1]| size(Recycling_Option,"r")<>[1]) 
    error ( "You have to choose only one carbon tax recycling option."); 
end 

if (size(CO2_footprint,"r")<>[1]| size(CO2_footprint,"r")<>[1])
    error ( "You have to choose whether or not you want to realise an Input-Output Analysis about carbon footprint.");
end

if  isdef("Output_files") then
Output_files = eval(Output_files);
else 	
    warning("No information about if you want to create output files : by default, output files are created")
    Output_files = %T;
end

if  isdef("Output_prints") then
Output_prints = eval(Output_prints);
else 	
    warning("No information about if you want to print outputs: by default, there are no prints")
    Output_prints = %F;
end

if isdef("Invest_matrix") then
    Invest_matrix = eval(Invest_matrix);
else
    warning("No information about investment disaggregation : by default, investment is kept aggregated")
    Invest_matrix = %F;
end

if isdef("ScenAgg_IOT") then
    ScenAgg_IOT = eval(ScenAgg_IOT);
else
    warning("No information about aggregating volumes of scenarios : by default, not aggregation")
    ScenAgg_IOT = %F;
end

if isdef("Optimization_Resol") then
    Optimization_Resol = eval(Optimization_Resol);
    if ~isdef("SystemOpt_Resol") then
        error("In Dashboard : you need to define a SystemOpt_Resol because Optimization_Resol is %T.");
    end
else
    warning('No information about optimization resolution in dashboard : by default, no optimization');
    Optimization_Resol = %F;
end

if isdef("CarbonTaxDiff") then
    CarbonTaxDiff = eval(CarbonTaxDiff);
else
    CarbonTaxDiff = %F;
end

////  Border tax adjustment
if isdef("Carbon_BTA") then
    Carbon_BTA = eval(Carbon_BTA);
else
    Carbon_BTA = %F;
end

////  Public finance 
if ~isdef("ClosCarbRev")
ClosCarbRev="CstNetLend";
end 

if (size(ClosCarbRev,"r")<>[1]| size(ClosCarbRev,"r")<>[1]) 
    error ( "You have to choose one condition for the closure of public finance by recycling carbon tax revenues"); 
end 


////  Capital Dynamics
if isdef("Capital_Dynamics") then
    Capital_Dynamics = eval(Capital_Dynamics);
else
    Capital_Dynamics = %F;
end

/// Profil of invesment share to GDP in capital dynamics
if isdef("Exo_ShareI_GDP") then
    Exo_ShareI_GDP = eval(Exo_ShareI_GDP);
else
    Exo_ShareI_GDP = %F;
end

/// Profil of unemployment to calibrate capital dynamics
if isdef("Exo_u_tot") then
    Exo_u_tot = eval(Exo_u_tot);
else
    Exo_u_tot = %F;
end

/// Adjustment in capital stock compared to the perpetual inventory
if isdef("Exo_Kstock_Adj") then
    Exo_Kstock_Adj = eval(Exo_Kstock_Adj);
else
    Exo_Kstock_Adj = %F;
end

// By default - To avoid confusion
if ~Capital_Dynamics
	Exo_u_tot = %F;
	Exo_ShareI_GDP = %F;
	Exo_Kstock_Adj = %F ; 
end

if Exo_u_tot&Exo_Kstock_Adj
	error( "You can not inform both unemployment rate and adjustment of capital stock exogenously "); 
end

// Adjustment of kappa for non energy sectors according to energy intensity
if isdef("AdjustKappaOnly") then
    AdjustKappaOnly = eval(AdjustKappaOnly);
else
    AdjustKappaOnly = %F;
end

if isdef("AdjustKappaWithSubst") then
    AdjustKappaWithSubst = eval(AdjustKappaWithSubst);
else
    AdjustKappaWithSubst = %F;
end

if AdjustKappaOnly&AdjustKappaWithSubst
	error( "You have to chose between adjusting kappa with or without keeping other substitution "); 
end
