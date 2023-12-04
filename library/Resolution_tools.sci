
////////////// CONTENTS
///// Function called for resolution script(calibration or derivation)

//// List of the functions in the file

// varTyp2list
// OnesValue4variables
// ZerosValue4variables
// variables2X
// variables2indiv_x
// X2variables
// indiv_x2variable
// struct2Variables(s)
// Variables2struct
// Const4VarRef(structure1, structure2)
// Calib_VarRef_Const(matrix of strings, list, matrix of strings)
// SubVar2Var (matrix of strings, list, (strings1_1, strings2_1), [(strings1_2, strings2_2),....] )
// AddOnesValue2struct
/// AddZerosValue2struct
// RemoveRefVarFromList
//CordVarX


// La plupart de ces fonctions demandent en entrée "Imaclim_variables' au format spécifique
// 1st row : headers of column
// 1st column : variable name
// 2nd column : row size of variable
// 3rd column : column size  of variable
// 4th column : type of variable for the resolution
//===> si on change l'organisation de ce tableau, il faut changer la fonction


////	varTyp2list

// list_varTyp : liste

function [list_varTyp] = varTyp2list (Imaclim_variables, varTyp)

    list_varTyp = list();
    size_VarTable = size(Imaclim_variables,"r")


    for elt = 1:size_VarTable
        if Imaclim_variables(elt,4) == varTyp
            list_varTyp($+1) = Imaclim_variables(elt,1);
        end
    end

endfunction


////	OnesValue4variables

function [variables_OnesValue] = OnesValue4variables (Imaclim_variables, list_varTyp, Structure)

    nb_variables = size(list_varTyp);

    for ind_list = 1:nb_variables

        ind_row_Imaclim = find(Imaclim_variables==list_varTyp(ind_list));
        nb_RowCurrVariable = evstr(Imaclim_variables(ind_row_Imaclim,2));
        nb_ColCurrVariable = evstr(Imaclim_variables(ind_row_Imaclim,3));
        current_variables = ones(nb_RowCurrVariable,nb_ColCurrVariable);

        execstr("variables_OnesValue" + "." + list_varTyp(ind_list)+"=current_variables"+";")

    end

endfunction

////	ZerosValue4variables

function [variables_OnesValue] = ZerosValue4variables (Imaclim_variables, list_varTyp, Structure)

    nb_variables = size(list_varTyp);

    for ind_list = 1:nb_variables

        ind_row_Imaclim = find(Imaclim_variables==list_varTyp(ind_list));
        nb_RowCurrVariable = evstr(Imaclim_variables(ind_row_Imaclim,2));
        nb_ColCurrVariable = evstr(Imaclim_variables(ind_row_Imaclim,3));
        current_variables = zeros(nb_RowCurrVariable,nb_ColCurrVariable);

        execstr("variables_OnesValue" + "." + list_varTyp(ind_list)+"=current_variables"+";")

    end

endfunction


////	ThousandValue4variables

function [variables_ThousandValue] = ThousandValue4variables (Imaclim_variables, list_varTyp, Structure)

    nb_variables = size(list_varTyp);

    for ind_list = 1:nb_variables

        ind_row_Imaclim = find(Imaclim_variables==list_varTyp(ind_list));
        nb_RowCurrVariable = evstr(Imaclim_variables(ind_row_Imaclim,2));
        nb_ColCurrVariable = evstr(Imaclim_variables(ind_row_Imaclim,3));
        current_variables = ones(nb_RowCurrVariable,nb_ColCurrVariable);
        current_variables = 10^3*current_variables;

        execstr("variables_ThousandValue" + "." + list_varTyp(ind_list)+"=current_variables"+";")

    end

endfunction




////	variables2X

// list_variables4X : list des variables pour le solveur (contenu dans Imaclim_variables), ), liste
// variables_value : valeurs initiale de x stockée sous forme de structure => variables_value = struct
// La sortie de la fonction est un vecteur colonne

function x = variables2X (Imaclim_variables, list_variables4X, variables_value)

    nb_variables4X = size(list_variables4X);
    prev_RowIndex = 1;

    for ind_list = 1:nb_variables4X

        ind_row_Imaclim = find(Imaclim_variables==list_variables4X(ind_list));
        nb_XRow4CurrVariable = evstr(Imaclim_variables(ind_row_Imaclim,2))*evstr(Imaclim_variables(ind_row_Imaclim,3));
        execstr("current_variables"+"="+"variables_value" + "." + list_variables4X(ind_list)+";");
        x(prev_RowIndex:prev_RowIndex+nb_XRow4CurrVariable-1)= matrix(current_variables, nb_XRow4CurrVariable,1);

        prev_RowIndex = prev_RowIndex+nb_XRow4CurrVariable ;
    end

endfunction


////	variables2indiv_x

// list_variables4each_x : list des variables pour les solveurs intermédiaires (contenu dans Imaclim_variables), ), liste
// variables_value : valeurs initiale de x stockée sous forme de structure => variables_value = struct
// La sortie de la fonction est plusieurs vecteurs colonnes

function [Table_Str_x2Exec] = variables2indiv_x (Imaclim_variables, list_variables4each_x, strSTRUCT)

    nb_variables4each_x = size(list_variables4each_x);
    Table_Str_x2Exec =[];

    for ind_list = 1:nb_variables4each_x

        ind_row_Imaclim = find(Imaclim_variables==list_variables4each_x(ind_list));
        nb_xRow4CurrVariable = evstr(Imaclim_variables(ind_row_Imaclim,2))*evstr(Imaclim_variables(ind_row_Imaclim,3));

        Table_Str_x2Exec(ind_list) = "x_"+list_variables4each_x(ind_list)+"="+"matrix("+strSTRUCT+"."+list_variables4each_x(ind_list)+", "+nb_xRow4CurrVariable+",1)"+";"

    end
endfunction


//// X2variables
// La sortie "variables_value" de la fonction est une structure

// function [variables_value] = X2variables (Imaclim_variables, list_variables4X, x)

    // nb_variables4X = size(list_variables4X);
    // prev_RowIndex = 1;

    // for ind_list = 1:nb_variables4X
        // ind_row_Imaclim = find(Index_Imaclim_VarResol==list_variables4X(ind_list));
        // nb_RowCurrVariable = Imaclim_variables(ind_row_Imaclim-1,1);
        // nb_ColCurrVariable = Imaclim_variables(ind_row_Imaclim-1,2);

        // Curr_Xpart = x(prev_RowIndex:prev_RowIndex+nb_RowCurrVariable*nb_ColCurrVariable-1);
        // current_variables =  matrix(Curr_Xpart,nb_RowCurrVariable,nb_ColCurrVariable);
        // execstr("variables_value" + "." + list_variables4X(ind_list)+"=current_variables"+";")

        // prev_RowIndex = prev_RowIndex+nb_RowCurrVariable*nb_ColCurrVariable ;
    // end
// endfunction

function [variables_value] = X2variables (Imaclim_variables, list_variables4X, x)

    nb_variables4X = size(list_variables4X);
    prev_RowIndex = 1;

    for ind_list = 1:nb_variables4X

        ind_row_Imaclim = find(Imaclim_variables==list_variables4X(ind_list));
        nb_RowCurrVariable = evstr(Imaclim_variables(ind_row_Imaclim,2));
        nb_ColCurrVariable = evstr(Imaclim_variables(ind_row_Imaclim,3));

        Curr_Xpart = x(prev_RowIndex:prev_RowIndex+nb_RowCurrVariable*nb_ColCurrVariable-1);
        current_variables =  matrix(Curr_Xpart,nb_RowCurrVariable,nb_ColCurrVariable);
        execstr("variables_value" + "." + list_variables4X(ind_list)+"=current_variables"+";")

        prev_RowIndex = prev_RowIndex+nb_RowCurrVariable*nb_ColCurrVariable ;
    end
endfunction

// TOCLEAN
function [variables_value] = X2variablesRuben (RowNumCsVDerivVarList, structNumDerivVar , variables_value  , VarDimMat, list_variables4X, x)

    nb_variables4X = size(list_variables4X);
    prev_RowIndex = 1;

    for ind_list = 1:nb_variables4X
        ind_row_Imaclim = RowNumCsVDerivVarList(ind_list)
        nb_RowCurrVariable = VarDimMat(ind_row_Imaclim-1,1);
        nb_ColCurrVariable = VarDimMat(ind_row_Imaclim-1,2);
        
        // Version scilab 5.5.2 - on semble modifier le structNumDerivVar(ind_list)-ième élément
        //variables_value = setfield(structNumDerivVar(ind_list) , matrix( x(prev_RowIndex:prev_RowIndex+nb_RowCurrVariable*nb_ColCurrVariable-1) , nb_RowCurrVariable,nb_ColCurrVariable ) , variables_value );

        // Version scilab 6 où on modifie le structNumDerivVar(ind_list)-ième élément
        //indice = fieldnames(variables_value)(structNumDerivVar(ind_list))
        //new_value = matrix( x(prev_RowIndex:prev_RowIndex+nb_RowCurrVariable*nb_ColCurrVariable-1) , nb_RowCurrVariable,nb_ColCurrVariable )
        //variables_value(indice) = new_value
        
        // Version scilab 6 où on modifie le ind_list-ième élément
        indice = fieldnames(variables_value)(ind_list)
        new_value = matrix( x(prev_RowIndex:prev_RowIndex+nb_RowCurrVariable*nb_ColCurrVariable-1) , nb_RowCurrVariable,nb_ColCurrVariable )
        variables_value(indice) = new_value
        //variables_value(fieldnames(variables_value)(ind_list)) = matrix( x(prev_RowIndex:prev_RowIndex+nb_RowCurrVariable*nb_ColCurrVariable-1) , nb_RowCurrVariable,nb_ColCurrVariable )

        prev_RowIndex = prev_RowIndex+nb_RowCurrVariable*nb_ColCurrVariable ;
    end

endfunction


//// indiv_x2varstruct
// La sortie "variables_value" de la fonction est une structure

function [variables_value] = indiv_x2varstruct (Imaclim_variables, list_variables4each_x, x_name)

    nb_variables4X = size(list_variables4each_x);

    for ind_list = 1:nb_variables4X

        ind_row_Imaclim = find(Imaclim_variables==list_variables4each_x(ind_list));
        nb_RowCurrVariable = evstr(Imaclim_variables(ind_row_Imaclim,2));
        nb_ColCurrVariable = evstr(Imaclim_variables(ind_row_Imaclim,3));

        Curr_x = evstr(x_name+list_variables4each_x(ind_list)+";");

        current_variables =  matrix(Curr_x,nb_RowCurrVariable,nb_ColCurrVariable);
        execstr("variables_value" + "." + list_variables4each_x(ind_list)+"=current_variables"+";")


    end
endfunction

//// indiv_x2variable
// La sortie "variables_value" de la fonction est une structure

function [variables_value] = indiv_x2variable (Imaclim_variables, x_name)

    variable = strsubst( x_name, "/^x_/","","r");
    ind_row_Imaclim = find(Imaclim_variables==variable);
    nb_RowCurrVariable = evstr(Imaclim_variables(ind_row_Imaclim,2));
    nb_ColCurrVariable = evstr(Imaclim_variables(ind_row_Imaclim,3));

    variables_value =  matrix(evstr(x_name),nb_RowCurrVariable,nb_ColCurrVariable);

endfunction

// struct2Variables(structure)

function [Table_Str2Exec] = struct2Variables(structure,STRINGstructure, varargin)

    VarNames_str = fieldnames(structure);
    Table_Str2Exec = [];

    for elt=1:size(VarNames_str,"r")

        //	Additional argument varargin 1 : prefix added before the names of all variables of the structure
        if size(varargin)==1
            Suffix = varargin(1);
            Table_Str2Exec(elt) = VarNames_str(elt)+Suffix+"="+string(STRINGstructure)+"."+VarNames_str(elt)+";"
        elseif	size(varargin)==0
            Table_Str2Exec(elt) = VarNames_str(elt)+"="+string(STRINGstructure)+"."+VarNames_str(elt)+";"
        end

    end
endfunction


// Variables2struct(structure)

function [Structure] = Variables2struct(list_Var)
    Table_Str2Exec = [];

    for elt=1:size(list_Var)
        current_variables = evstr (list_Var(elt));
        execstr("Structure" + "." +list_Var(elt)+"=current_variables"+";")
    end
endfunction



//	Const4VarRef(structure1, structure2)

//	Computation of a table Const2Exec which includes the instructions: "Grandeur_ref - Grandeur" in strings
//	For all Grandeur_ref included in structure1 (VarRefNames list)
//	For all Grandeur included in structure1 OR structure2

function [Const2Exec, VarRefNames] = Const4VarRef(structure1, varargin)

    VarNames_structure = list();
    VarNames_structure(1) = fieldnames(structure1);

    for i = 1:length(varargin)
        VarNames_structure($+1) = fieldnames( varargin(i) ) ;
    end

    Table = [];
    VarRefNames = list();

    // TOCLEAN
    //	Rq: Peut être qu'on peut éviter une boucle avec la fonction intersect ou du type
    //	Search where are Grandeurs and compute Table
    for elt = 1:size(VarNames_structure(1),"r")

        //disp("elt="+elt)
        //disp("variable="+VarNames_structure1(elt))

        Location = list();
        Structure = list();
        for i = 1:(1+length(varargin))
            Location_i = find( VarNames_structure (i)+"_ref" == VarNames_structure(1)(elt) );
            if ~isempty(Location_i)
                Location ($+1) = Location_i;
                Structure($+1) = VarNames_structure (i) ;
            end
        end

        if isempty(Location) then
            Table(elt) = "0";
        elseif length(Location) <> 1 then
            // TOCLEAN
            //	Rq: ici il faudra une procédure d'erreur, pour sortir de la fonction ou bien autre chose
            //	pour l'instant on renvoie juste '0'
            disp("error:"+Structure(1)(Location(1))+" is both defined as initial value and calibrated parameter") ;
            Table(elt) = "0";
        elseif length(Location) == 1 then
            Table(elt) = VarNames_structure(1)(elt)+" = "+Structure(1)( Location(1) )+" ;"
            VarRefNames($+1) = VarNames_structure(1)(elt) ;
        end
    end

    //	Extract useful instructions to execute
    Const2Exec = Table(find(~Table=="0")) ;
endfunction

//	Calib_VarRef_Const(matrix of strings, list, matrix of strings)
//	Compute the constraints for the calibration of Grandeur_ref

function [Constraints_VarRef] = Calib_VarRef_Const(Const2Exec, VarRefNames, Index_Imaclim_VarCalib)

    //	Execute instructions "Grandeur_ref - Grandeur" which are included in Const2Exec, and create a structure of constraints
    for i = 1:size(Const2Exec,"r")
        execstr( "Constraints."+VarRefNames(i)+"="+Const2Exec(i) ) ;
    end

    // Create a vector column for solver from all parameters_ref to calibrate
    Constraints_VarRef = variables2X (Index_Imaclim_VarCalib, VarRefNames, Constraints);
endfunction



//	SubVar2Var (matrix of strings, list, (strings1_1, strings2_1), [(strings1_2, strings2_2),....] )
//	Compute a table Table_MixVar with instructions in strings: " Variable( (SubVariable_Indices or :), (SubVariable_Indices or :) ) = SubVariable "
//	For all Variable included in list_Var
//	For all SubVariable_i = Variable+"strings2_i", strings2_i gives the Suffix that defines the SubVariable
//	SubVariable_i is a Sub-matrix included in Variable (at indices strings1_i)
//	At least one SubVariable must be specified

function [Table_MixVar] = SubVar2Var(Imaclim_variables, list_Var, varargin);

    //	the list varargin gives 1) the indices for the location of sub-variables into variables (for varargin = odd numbers)
    //		and 2) the suffix that gives the sets name of sub_variables (for varargin = even numbers)

    j=1;
    for i = 1:length(varargin)
        if modulo(i,2)<>0
            execstr( "SubVar"+string(j)+"_Indices = varargin("+string(i)+")" )
        else
            execstr( "SubVar"+string(j)+"_Suffix = varargin("+string(i)+")" )
            j=j+1;
        end
    end

    Table_MixVar = [];

    for elt = 1:length(list_Var)
        for i = 1:(j-1)
            SubVarSuffix 	= evstr("SubVar"+string(i)+"_Suffix");
            SubVarName 	= list_Var(elt)+SubVarSuffix ;
            SubVarIndices	= evstr("SubVar"+string(i)+"_Indices");

            ind_row_Imaclim_Var = find( Imaclim_variables == list_Var(elt) );
            nb_Row_Var = evstr( Imaclim_variables(ind_row_Imaclim_Var,2) );
            nb_Col_Var = evstr( Imaclim_variables(ind_row_Imaclim_Var,3) );

            ind_row_Imaclim_SubVar = find( Imaclim_variables == SubVarName );
            nb_Row_SubVar = evstr( Imaclim_variables(ind_row_Imaclim_SubVar,2) );
            nb_Col_SubVar = evstr( Imaclim_variables(ind_row_Imaclim_SubVar,3) );

            if (nb_Row_Var == nb_Row_SubVar) & (nb_Col_Var == nb_Col_SubVar) then
                disp("error: dimensions of "+list_Var(elt)+" and "+SubVarName+" are identical");

            elseif (nb_Row_Var <> nb_Row_SubVar) & (nb_Col_Var == nb_Col_SubVar) then
                Table_MixVar(elt,i) = list_Var(elt)+"("+SubVarIndices+",:) = "+SubVarName ;

            elseif (nb_Row_Var == nb_Row_SubVar) & (nb_Col_Var <> nb_Col_SubVar) then
                Table_MixVar(elt,i) = list_Var(elt)+"(:, "+SubVarIndices+") = "+SubVarName ;

            elseif (nb_Row_Var <> nb_Row_SubVar) & (nb_Col_Var <> nb_Col_SubVar) then
                //	In this case the matrix is Commodity X Commodity, the SubVar indices are the same in row and column
                Table_MixVar(elt,i) = list_Var(elt)+"("+SubVarIndices+", "+SubVarIndices+") = "+SubVarName ;
            end
        end
    end
endfunction







////	AddOnesValue2struct

function Structure=AddOnesValue2struct (Imaclim_variables, list_varTyp, Structure)

    nb_variables = size(list_varTyp);

    for ind_list = 1:nb_variables

        ind_row_Imaclim = find(Imaclim_variables==list_varTyp(ind_list));
        nb_RowCurrVariable = evstr(Imaclim_variables(ind_row_Imaclim,2));
        nb_ColCurrVariable = evstr(Imaclim_variables(ind_row_Imaclim,3));
        current_variables = ones(nb_RowCurrVariable,nb_ColCurrVariable);
        execstr("Structure" + "." +list_varTyp(ind_list)+"=current_variables"+";")

    end

endfunction



////	AddZerosValue2struct

function Structure=AddZerosValue2struct (Imaclim_variables, list_varTyp, Structure)

    nb_variables = size(list_varTyp);

    for ind_list = 1:nb_variables

        ind_row_Imaclim = find(Imaclim_variables==list_varTyp(ind_list));
        nb_RowCurrVariable = evstr(Imaclim_variables(ind_row_Imaclim,2));
        nb_ColCurrVariable = evstr(Imaclim_variables(ind_row_Imaclim,3));
        current_variables = zeros(nb_RowCurrVariable,nb_ColCurrVariable);
        execstr("Structure" + "." +list_varTyp(ind_list)+"=current_variables"+";")

    end

endfunction


// RemoveRefVarFromList

function [ReduceList] = RemoveRefVarFromList (listofVar)
    ReduceList = list();

    for elt = 1: size(listofVar)
        if strstr(listofVar(elt) ,"_ref") ==""
            ReduceList($+1) = listofVar(elt)

        end
    end

endfunction

//CordVarX
// pour trouver la position de chaque variable dans X

 
 function [DefMatX] = CordVarX(VarDimMat, Index_Imaclim_VarResol, listDeriv_Var)
 
 nb_Deriv_Var = size(listDeriv_Var);
   elt = 1;
    for ind = 1:nb_Deriv_Var
        ind_row_Imaclim = find(Index_Imaclim_VarResol(2:$,1)==listDeriv_Var(ind))
		
		if ind_row_Imaclim <>""
		Indice_Deriv_Var(elt) = ind_row_Imaclim 
		elt = elt + 1
		end 
	end

	DimMatX = VarDimMat(Indice_Deriv_Var,1).*VarDimMat(Indice_Deriv_Var,2);
	PosX = cumsum(DimMatX);
	for ind = 1:nb_Deriv_Var
	DefMatX(ind,:) = [ listDeriv_Var(ind),DimMatX(ind)]
	end	
	DefMatX = [DefMatX, PosX];
	
endfunction
