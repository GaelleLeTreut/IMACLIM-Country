Var_Resol = Index_Imaclim_VarResol;

// TODO : Read the equations to solve

file_eq_path = SYST_RESOL + SystemOpt_Resol + '.csv';
file_eq = read_csv(file_eq_path, ';');
file_eq = stripblanks(file_eq);
remove_comments = list();
for i = 1:size(file_eq,1)
    // remove the comments and the empty lines
    if part(file_eq(i,1),1:2) <> '//' ..
        & (file_eq(i,1) <> '' | file_eq(i,2) <> '' | file_eq(i,3) <> '') ..
        then
        remove_comments($+1) = file_eq(i,:);
    end
end
file_eq = remove_comments;


// TODO : split the functions : val & eq

fun_eq_list = list();
fun_val_list = list();
id = 0;
for eq = file_eq
    eq_struct = struct();
    id = id + 1;
    eq_struct.id = id;
    eq_struct.output = stripblanks(strsplit(eq(1),','));
    if eq_struct.output == '' then
        eq_struct.output = [];
    end
    eq_struct.args = stripblanks(strsplit(eq(3),','));
    if eq_struct.args == '' then
        eq_struct.args = [];
    end
    eq_struct.name = eq(2);
    if eq_struct.output == [] then
        eq_struct.output = null();
        fun_eq_list($+1) = eq_struct;
    else
        fun_val_list($+1) = eq_struct;
    end
end

// TODO : Sort the val functions

// Read the variable resol
Var_Resol(1,:) = [];

var_resolution = [];
var_resol_out = [];
var_resol_interm = [];
var_resol_treatment = [];
for i = 1:size(Var_Resol,1)
    var_resol_treatment($+1) = stripblanks(Var_Resol(i,1));
end

fun_val_list_copy = fun_val_list;

fun_val_out = list();
fun_val_interm = list();

fun_val_in_eq = list();

// Remove the arguments not in Var_Resol
function fun_list_red = remove_arg(fun_list, arg_list)
    for i = 1:size(fun_list)
        args = [];
        for j = 1:size(fun_list(i).args,1)
            if find(arg_list == fun_list(i).args(j)) <> []
                args($+1) = fun_list(i).args(j);
            end
        end
        fun_list(i).args = args;
    end
    fun_list_red = fun_list;
endfunction

fun_val_list = remove_arg(fun_val_list,var_resol_treatment);

// Take the functions which does not need solver

// Retirer les fonctions sans argument
function [fun_list_red, var_treatment, fun_out, var_out] = take_fun(fun_list, fun_list_out, arg_list_out, arg_list_treatment)
    cpt = 1;
    while cpt <> 0
        cpt = 0;
        fun_val_treatment = list();
        for i = 1:size(fun_list)
            if fun_list(i).args == [] then
                fun_list_out($+1) = fun_list(i).id;
                // remove the compute var from var resolution
                for var = fun_list(i).output'
                    arg_list_out($+1) = var;
                    ind = find(arg_list_treatment == var);
                    arg_list_treatment(ind) = [];
                    cpt = cpt + 1;
                end
            else
                fun_val_treatment($+1) = fun_list(i);
            end
        end
        fun_list = fun_val_treatment;
        // TODO : remove the arguments not in Var Resol anymore
        fun_list = remove_arg(fun_list,arg_list_treatment);
    end
    fun_list_red = fun_list;
    var_treatment = arg_list_treatment;
    fun_out = fun_list_out;
    var_out = arg_list_out;
endfunction

[fun_val_list, var_resol_treatment, fun_val_out, var_resol_out] = take_fun(fun_val_list, fun_val_out, var_resol_out, var_resol_treatment);

// TODO : remove the arguments not computed by a function val <-> variables computed in fsolve

while (fun_val_list <> list())

    cont = %T;

    while(cont)

        t = size(fun_val_list);

        // liste des outputs des fonctions val
        output_list = [];
        for fun = fun_val_list
            for var = fun.output'
                output_list($+1) = var;
            end
        end

        // supprimer les arguments qui sont pas des outputs
        fun_val_list = remove_arg(fun_val_list, output_list);

        // Extraire les fonctions sans argument
        [fun_val_list, var_resol_treatment, fun_val_interm, var_resol_interm] = take_fun(fun_val_list, fun_val_interm, var_resol_interm, var_resol_treatment);

        cont = ~(t == size(fun_val_list));

    end

    if fun_val_list <> list() then

        // TODO : fonction en dehors du while
        // Tant qu'il reste des variables dans fun_list_val, il y a une relation circulaire : la trouver et la briser
        // -> pour l'instant, le cycle est choisi au hasard (le premier que le parcours trouve)
        function fun_cycle = find_fun_cycle(fun_list, root, path)
            // fun_list -> graphe avec pour sommet les arguments et pour arrêtes les fonctions qui calculent ces arguments
            for fun = fun_list
                // fonction qui calcule root
                if find(fun.output == root) <> []
                    // arguments nécessaires pour calculer root
                    for arg = fun.args'
                        // si l'argument est déjà vu -> boucle
                        ind = find(path == arg)
                        if ind <> [] then
                            fun_cycle = path(ind(1):$);
                            break;
                        else
                            path($+1) = arg;
                            fun_cycle = find_fun_cycle(fun_list, arg, path);
                            path($) = [];
                        end
                    end
                    break;
                end
            end

        endfunction

        root = fun_val_list(1).output(1);
        path = [root];
        fun_cycle = find_fun_cycle(fun_val_list, path, root);
        
        // trouver les fonctions qui correspondent au cycle
        fun_struct_cycle = list();
        for arg = fun_cycle'
            for fun = fun_val_list
                if find(fun.output == arg) <> [] then
                    fun_struct_cycle($+1) = fun;
                    break;
                end
            end
        end
        
        // Comparer la taille des output
        size_outputs = list();
        for fun = fun_struct_cycle
            current_size = 0;
            for var = fun.output'
                ind = find(Var_Resol(:,1) == var);
                current_size = current_size + eval(Var_Resol(ind,2) + '*' + Var_Resol(ind,3));
            end
            size_outputs($+1) = current_size;
        end
        
        // Choisir la fonction avec l'output de plus petite taille pour envoyer dans fsolve
        ind_min = 1;
        size_min = size_outputs(1);
        for i = 2:size(size_outputs)
            if size_outputs(i) < size_min then
                ind_min = i;
                size_min = size_outputs(i);
            end
        end
        
        fun_circ = fun_struct_cycle(ind_min);
        
        // Envoyer cette fonction dans fun_eq_list et tout recommencer jusqu'à ce que fun_val_list soit vide
//        function y = eq_from_fun_val(fun_name, args_in_string, output_in_string)
//            // TODO : ordonner avec eval_fun !
//            execstr('[' + output_in_string + ']' + '=' + fun_name + '(' + args_in_string + ');');
//
////            var_output = eval(fun_struct_val.args(1) + );
//
//            y = []
//
//            // TODO : faire ça ailleurs
//            output = stripblanks(strsplit(output_in_string,','));
//
//            for var = output'
//                y = [y; matrix(eval(var),-1,1)];
//            end
//
//        endfunction

        // remove fun_circ
        for i = 1:size(fun_val_list)
            fun = fun_val_list(i);
            if fun.id == fun_circ.id then
                // remets les vrais arguments
                for fun_copy = fun_val_list_copy
                    if fun_copy.id == fun.id then
                        fun.args = fun_copy.args;
                    end
                end
//                args_in_string = '';
//                if fun.args <> [] then
//                    args_in_string = fun.args(1);
//                end
//                for i = 2:size(fun.args,1)
//                    args_in_string = args_in_string + ',' + fun.args(i);
//                end
//
//                output_in_string = '';
//                if fun.output <> [] then
//                    output_in_string = fun.output(1);
//                end
//                for i = 2:size(fun.output,1)
//                    output_in_string = output_in_string + ',' + fun.output(i);
//                end
//

//                name = fun.name;
//                fun.name = 'eq_from_fun_val';
//                fun.args = [name, args_in_string, output_in_string]';
                fun_val_in_eq($+1) = fun;

                fun_val_list(i) = null();

                for var = fun.output'
                    ind = find(var_resol_treatment == var);
                    var_resol_treatment(ind) = []; // /!\ var_resol_treatment et var_resolution : même chose -> pas besoin de transvaser !
                    var_resolution($+1) = var;
                end

                break;
            end
        end
    end
end


var_resolution = [var_resolution ; var_resol_treatment];
// var_resolution : variables résolues par le fsolve
// var_resol_interm : variables résolues dans f_resol_interm
// var_resol_out : variables résolues avant le fsolve

// fun_eq_list : liste des équations à résoudre dans le fsolve
// fun_val_out : liste des équations à résoudre avant le fsolve
// fun_val_interm : liste des équations à résoudre dans f_resol_interm
// fun_val_in_eq

function fun_list = restore_functions(fun_id_list, fun_val_list_copy)
    fun_list = list();
    for i = 1:size(fun_id_list)
        for fun_val = fun_val_list_copy
            if fun_val.id == fun_id_list(i)
                fun_list($+1) = fun_val;
                break;
            end
        end
    end
endfunction

fun_val_out = restore_functions(fun_val_out, fun_val_list_copy);
fun_val_interm = restore_functions(fun_val_interm, fun_val_list_copy);


// TODO : Solve functions which can be directly solved




// TODO : f_resol_interm

// TODO : f_resolution

// TODO : f_solve

// TODO : Load the data from the resolution
