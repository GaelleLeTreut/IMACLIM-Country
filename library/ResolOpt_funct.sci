// --------------------------- *
// Functions to write the code *
// --------------------------- *

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