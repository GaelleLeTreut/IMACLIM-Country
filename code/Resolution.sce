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
// STEP 5: DERIVATION RESOLUTION
/////////////////////////////////////////////////////////////////////////////////////////////

////////////////////////////////////////////////////////////////////////////////////////
// setting parameters for homothetic projection
/////////////////////////////////////////////////////////////////////////////////////////
if part(SystemOpt_Resol,1:length(OptHomo_Shortname))== OptHomo_Shortname
    parameters.sigma_pC = ones(parameters.sigma_pC);
    parameters.sigma_ConsoBudget = ones(parameters.sigma_ConsoBudget);
    parameters.ConstrainedShare_C = zeros(parameters.ConstrainedShare_C);
    parameters.sigma_M = ones(parameters.sigma_M);
    parameters.sigma_X = ones(parameters.sigma_X);
    parameters.CarbonTax_Diff_C = ones(CarbonTax_Diff_C);
    parameters.CarbonTax_Diff_IC = ones(CarbonTax_Diff_IC);
    parameters.Carbon_Tax_rate = 0.0;
    parameters.u_param = BY.u_tot;
end

/////////////////////////////////////////////////////////////////////////////////////////
// defined in "loading data" : Index_VarResol
/////////////////////////////////////////////////////////////////////////////////////////

//////////////// Defining matrix with dimension of each variable for Resolution file
VarDimMat_resol = eval(Index_VarResol(2:$,2:3));


/////////////////////////////////////////////////////////////////////////
// LOADING STUDY CHANGES
/////////////////////////////////////////////////////////////////////////
// exec(STUDY+study+".sce");
// Les changements de variables exogènes sont stockées dans la structure dans le fichier study: Deriv_Exogenous 
// Attribuer les changements exogenes aux variables
if exists('Deriv_Exogenous')==1
    for var = fieldnames(Deriv_Exogenous)'
        if find(fieldnames(parameters) == var) <> [] then
            parameters(var) = Deriv_Exogenous(var);
        end
    end
    [Table_Deriv_Exogenous] = struct2Variables(Deriv_Exogenous,"Deriv_Exogenous");
    execstr(Table_Deriv_Exogenous);
end

Indice_Immo = find(Index_Sectors == "Property_business") ;

//  Introduire le changement des valeurs par défaut des parametres selon les différentes simulation
[Table_parameters] = struct2Variables(parameters,"parameters");
execstr(Table_parameters);


//////////////////////////////////////////////////////////////////////////
// Endogenous variable (set of variables for the system below - fsolve)
/////////////////////////////////////////////////////////////////////////
// list
//[listDeriv_Var] = varTyp2list (Index_VarResol, "Var");

// Record the Deriv variables
listDeriv_Var = list();
for var = var_resolution'
    listDeriv_Var($+1) = var;
end

// Initial values for variables
Deriv_variables = Variables2struct(listDeriv_Var);
Deriv_variablesStart = Deriv_variables;
// Create X vector column for solver from all variables which are endogenously calculated in derivation
X_Deriv_Var_init = variables2X (Index_VarResol, listDeriv_Var, Deriv_variables);
//bounds = createBounds( Index_VarResol , listDeriv_Var );
// [(1:162)' X_Deriv_Var_init >=bounds.inf  bounds.inf X_Deriv_Var_init bounds.sup X_Deriv_Var_init<= bounds.sup]

/////////////////////////////////////////////////////////////////////////
///// Extra calculation
/////////////////////////////////////////////////////////////////////////
sigmaM = sigma(1);
if ~or(sigma==sigmaM)
    error("problem with sigma");
end

// BudgetShare for non final energy product
// Dimension (nb_NonFinalEnergy , nb_HH)
NonFinEn_BudgShare_ref = (ini.pC(Indice_NonEnerSect, :) .* ini.C(Indice_NonEnerSect, :))./( (ini.Consumption_budget - sum( ini.pC(Indice_EnerSect,:) .* ini.C(Indice_EnerSect,:),"r" ) ).*.ones(nb_NonEnerSect,1) ) ;


////////////////////////////////////////////////////////////////////
// TABLES
////////////////////////////////////////////////////////////////////


// --------------------------- *
// Functions to write the code *
// --------------------------- *

function str = string_from_table(table)
    // If table = [a1,a2,...], returns the string str = "a1,a2,..."

    str = '';

    if size(table,1) <> 0 then
        str = table(1);
    end

    for i = 2:size(table,1)
        str = str + ',' + table(i);
    end

endfunction

function fun_code = write_fun_val_code(fun_struct)
    // Returns a string containing the code which computes the result
    // variable of the function *fun_struct*.

    args = string_from_table(fun_struct.args);
    output_var = string_from_table(fun_struct.output);

    fun_code = '[' + output_var + ']' + '=' + fun_struct.name + '(' + args + ');';

endfunction

function fun_code = write_fun_eq_code(fun_struct)
    // Returns a string which evaluates the function *fun_struct*.

    args = string_from_table(fun_struct.args);

    fun_code = fun_struct.name + '(' + args + ')';

endfunction

function y = eq_from_val(output_code,code)
    // Returns the constraints form of the functions defined by the
    // string *code* which as *outpout_code* as outputs.

    suff_save = '_s';

    if isdef(var + suff_save) then
        error(var + suff_save + ' is already defined, choose another suffix name');
    end

    // save the current value of output variables
    for var = output_code
        execstr(var + suff_save + '=' + var);
    end

    // compute the new value of output variables
    execstr(code);

    // Return the constraint
    y = [];
    for var = output_code
        y = [y; matrix(eval(var + suff_save + '-' + var),-1,1)];
    end

endfunction


// -------------------------------------------------- *
// Define tables containing the code of the functions *
// -------------------------------------------------- *

// Code for functions outside the resolution
Table_resol_out = [];
// Code computing the functions of intermediate resolution
Table_resol_interm = [];
// Code which defines Constraints_Deriv for resolution
Table_resolution = ['Constraints_Deriv = [];'];

for fun = fun_resol_out
    Table_resol_out($+1) = write_fun_val_code(fun);
end

for fun = fun_resol_interm
    Table_resol_interm($+1) = write_fun_val_code(fun);
end

for fun = fun_resolution_eq
    Table_resolution($+1) = 'Constraints_Deriv = [Constraints_Deriv ;' + write_fun_eq_code(fun) + '];';
end

// Change fonctions _val into constraints
for fun = fun_resolution_val

    // code of the _val function
    code = write_fun_val_code(fun);
    output = fun.output;

    output_var = '';
    if size(fun.output) <> 0 then
        output_var = """" + fun.output(1) + """";
    end
    for i = 2:size(fun.output,1)
        output_var = output_var + ',' + """" + fun.output(i) + """";
    end

    // record the constraints
    Table_resolution($+1) = 'Constraints_Deriv = [Constraints_Deriv ; eq_from_val(' + '[' + output_var + ']' + ',' + """" + code + """" + ')];';

end


/////////////////////////////////////////////////////////////////////////
///// FUNCTIONS
/////////////////////////////////////////////////////////////////////////

// execstr(fieldnames(Deriv_Var_temp)+"= Deriv_Var_temp." + fieldnames(Deriv_Var_temp));

function [Constraints_Deriv] = f_resolution(X_Deriv_Var_init, VarDimMat, RowNumCsVDerivVarList, structNumDerivVar , Deriv_variablesStart , listDeriv_Var)

    // Création des variables à partir de x et de info_structure_x
    [Deriv_variables] = X2variablesRuben (RowNumCsVDerivVarList, structNumDerivVar , Deriv_variablesStart , VarDimMat, listDeriv_Var, X_Deriv_Var_init)

    // Affectation des valeurs aux noms de variables,  pour les variables du solveur, les valeurs calibrées, et les parametres
    execstr(fieldnames(Deriv_variables)+"= Deriv_variables." + fieldnames(Deriv_variables));

    // Calcul des variables qui ne sont pas des variables d'états

    execstr(Table_resol_interm);

    // Création du vecteur colonne Constraints
    execstr(Table_resolution);

    //7076:7087
    if ~isreal(Constraints_Deriv)
        warning("~isreal(Constraints_Deriv)");
        if or(imag(Constraints_Deriv)<>0)
            warning("nb imaginaires")
            // Constraints_Deriv = abs(Constraints_Deriv) * 1e5;
            print(out,find(imag(Constraints_Deriv)~=0))
            print(out,bounds.name(find(imag(Constraints_Deriv)~=0))')
            error('nb imaginaires');
        else
            Constraints_Deriv = real(Constraints_Deriv);
        end
    end

endfunction

//////////////////////////////////////////////////////////////////////////
//	Number of Index and Indice from Index_VarResol used by f_resolution
/////////////////////////////////////////////////////////////////////////

nVarDeriv = size(listDeriv_Var);
RowNumCsVDerivVarList = list();
structNumDerivVar = zeros(nVarDeriv,1);
EltStructDerivVar = getfield(1 , Deriv_variablesStart);
for ind = 1:nVarDeriv
    RowNumCsVDerivVarList($+1) = find(Index_VarResol==listDeriv_Var(ind)) ;
    structNumDerivVar(ind) = find(EltStructDerivVar == listDeriv_Var(ind));
end

///////////////////////////////////////////
// Test function f_resolution and consistency between size of constraint and X vector of variable for fsolve
Constraints_Init =  f_resolution(X_Deriv_Var_init, VarDimMat_resol, RowNumCsVDerivVarList, structNumDerivVar , Deriv_variables , listDeriv_Var);

[maxos,lieu]=max(abs(Constraints_Init));
SizeCst = size(Constraints_Init);
[contrainte_tri , coord] =gsort(Constraints_Init);

if %f
    exec(CODE+"testingSystem.sce");
    return
end

if length(X_Deriv_Var_init) ~= length(Constraints_Init)
    printf("X_Deriv_Var_init is "+length(X_Deriv_Var_init)+" long when Constraints_Init is "+length(Constraints_Init)+" long");
    error("The constraint and solution vectors do not have the same size, check data/Index_VarResol.csv")
end

/////////////////////////////////////////////////
//////SOLVEUR
/////////////////////////////////////////////////
count        = 0;
countMax     = 30;
vMax         = 10000000;
vBest        = 10000000;
sensib       = 1e-5;
sensibFsolve = 1e-15;
Xbest        = X_Deriv_Var_init;
a            = 0.1;

if TEST_MODE then
    countMax = testing.countMax;
end

tic();

if %f
    Xinf = ones(Xbest) * -%inf;
    Xsup = -Xinf;
    Xinf(py) = 0;
    [X_Deriv_Var, Constraints_Deriv, info] = leastsq(..
    list(f_resolution, VarDimMat_resol, RowNumCsVDerivVarList, structNumDerivVar , Deriv_variablesStart , listDeriv_Var),..
    "b", Xinf , Xsup,..
    Xbest.*(1 + a*(rand(Xbest)-1/2))..
    );
end

if Nb_Iter<>1
printf("\n\n Time Step:"+time_step+"\n\n");
end
printf("\n\n   count      vBest   info       toc\n");
while (count<countMax)&(vBest>sensib)
    count = count + 1;

    // Security : clear the variables to make sure they are really computed by the resolution
    for var = [var_resolution ; var_resol_interm ; var_resol_out]'
        execstr('clear(' + '''' + var + '''' + ');');
    end
    
    // Compute the variables which do not need the solver
    execstr(Table_resol_out);

    // Launch the solver
    [X_Deriv_Var, Constraints_Deriv, info] = fsolve(Xbest.*(1 + a*(rand(Xbest)-1/2)), list(f_resolution, VarDimMat_resol, RowNumCsVDerivVarList, structNumDerivVar , Deriv_variables , listDeriv_Var),sensibFsolve);
    vMax = norm(Constraints_Deriv);

    if vMax<vBest
        vBest    = vMax;
        infoBest = info;
        Xbest    = X_Deriv_Var;
    end

    result(count).xbest = Xbest;
    result(count).vmax  = vMax;
    result(count).vbest = vBest;
    result(count).count = count;
    result(count).info  = info;

    printf("     %3.0f   %3.2e      %1.0f   %3.1e\n",count,vBest,info,toc()/60);
end

exec(CODE+"terminateResolution.sce");


////////////////////////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////
// Reafectation des valeurs aux variables et à la structure après résolution
/////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////
Deriv_variables = X2variables (Index_VarResol, listDeriv_Var, Xbest);
execstr(fieldnames(Deriv_variables)+"= Deriv_variables." + fieldnames(Deriv_variables)+";");

if exists('Deriv_Exogenous')==1
    Table_Deriv_Exogenous = struct2Variables(Deriv_Exogenous,"Deriv_Exogenous");
    execstr(Table_Deriv_Exogenous)
end

/// Cacul des variables "temp" dans la fonction f_resolution
execstr(Table_resol_interm);

/////////////////////////////////////////////////////////////////
// test f_resolution à zéro ?? Mais pour quel jeu de valeur ?? LA CA FAIT PAS ZERO
Constraints_Deriv_test =  f_resolution (X_Deriv_Var, VarDimMat_resol, RowNumCsVDerivVarList, structNumDerivVar , Deriv_variables , listDeriv_Var);
[maxos,lieu]=max(abs(Constraints_Deriv_test));

//Struture d. created to reunite Deriv_variables and Deriv_Var_temp");
// All d. at initial value first
execstr("d."+fieldnames(calib)+"= calib."+fieldnames(calib)+";");
execstr("d."+fieldnames(initial_value)+"= initial_value."+fieldnames(initial_value)+";");
execstr("d."+fieldnames(parameters)+"= parameters."+fieldnames(parameters)+";");
// introducing changes in variable value
execstr("d."+fieldnames(Deriv_variables)+"= Deriv_variables."+fieldnames(Deriv_variables)+";");

for var = [var_resol_out; var_resol_interm]'
    d(var) = eval(var);
end

//execstr("d."+fieldnames(Deriv_Var_interm)+"= Deriv_Var_interm."+fieldnames(Deriv_Var_interm)+";");
if exists('Deriv_Exogenous')==1
    execstr("d."+fieldnames(Deriv_Exogenous)+"= Deriv_Exogenous."+fieldnames(Deriv_Exogenous)+";");
end
