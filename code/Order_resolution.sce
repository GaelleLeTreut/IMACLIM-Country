// --------------- *
// Data structures *
// --------------- *

// list of val function
fun_val_list = list();

// functions not yet sorted
fun_val_not_sorted = list();

// functions sorted
fun_resol_out = list();
fun_resol_interm = list();
fun_resolution_val = list();
fun_resolution_eq = list();

// variables associated
var_resol_out = [];
var_resol_interm = [];
var_resolution = [];

// ------------------------ *
// Load the equations' file *
// ------------------------ *

// path
file_eq_path = SYST_RESOL + SystemOpt_Resol + '.csv';
// read
file_eq = read_csv(file_eq_path, ';');
// remove blanks
file_eq = stripblanks(file_eq);

// Remove commented and empty lines
lines_kept = list();
for i = 1:size(file_eq,1)
    // Empty line <-> the first 3 columns are empty
    if part(file_eq(i,1),1:2) <> '//' ..
        & (file_eq(i,1) <> '' | file_eq(i,2) <> '' | file_eq(i,3) <> '') ..
        then
        lines_kept($+1) = file_eq(i,:);
    end
end
file_eq = lines_kept;


// --------------------- *
// Define Index_VarResol *
// --------------------- *

var_resol_head = 'Var_Resol';

if file_eq(1)(1,1) == var_resol_head then
    // Load Var_Resol
    Index_VarResol = eval(file_eq(1)(1,2));
else
    // Var_Resol is not defined
    error('You need to define ' + """" + var_resol_head + """" + ' at the beginning of SystemOpt_Resol csv file.');
end

var_resolution = Index_VarResol(2:$,1);

// Remove the line which defines Var_Resol
file_eq(1) = null();


// ------------------------------------------ *
// Read and record the functions Val / Eq     *
//      - Val : recorded in fun_val_list      *
//      - Eq  : recorded in fun_resolution_eq *
// ------------------------------------------ *

id = 0;

for fun = file_eq

    // Def the structure of the function
    fun_struct = struct();

    // Attribute a distinct ID to each function
    id = id + 1;
    fun_struct.id = id;

    // Record outputs
    fun_struct.output = stripblanks(strsplit(fun(1),','));
    if fun_struct.output == '' then
        fun_struct.output = [];
    end

    // Record arguments
    fun_struct.args = stripblanks(strsplit(fun(3),','));
    if fun_struct.args == '' then
        fun_struct.args = [];
    end

    // Record the name
    fun_struct.name = fun(2);

    // Save the function : Val or Eq
    if fun_struct.output == [] then
        fun_struct.output = null();
        fun_resolution_eq($+1) = fun_struct;
    else
        fun_val_list($+1) = fun_struct;
    end

end



// ------- *
// Library *
// ------- *

function fun_list_red = remove_outside_args(fun_list, arg_list)
    // fun_list_red : list of the functions of *fun_list* after keeping
    //                   only arguments which are in *arg_list*.

    fun_list_red = list();

    for fun = fun_list
        args_kept = [];
        for arg = fun.args'
            // if arg is in arg_list, keep arg
            if find(arg_list == arg) <> [] then
                args_kept($+1) = arg;
            end
        end
        fun.args = args_kept;
        fun_list_red($+1) = fun;
    end

endfunction

function [fun_list_out, args_list_out, fun_list_red, args_list_red] = take_fun_out(fun_list, args_list)
    // - Take out the functions without arguments
    // - Remove the outputs of extracted functions from the list of arguments
    // - Take out the functions without arguments
    // ...
    // => Extract the functions which can be extracted from resolution

    fun_taken = %T;
    fun_list_red = fun_list;
    fun_list_out = list();
    args_list_red = args_list;
    args_list_out = [];

    while fun_taken
        fun_taken = %F;

        fun_kept = list();

        for fun = fun_list_red
            // Take out the functions without arguments
            if fun.args == [] then
                fun_list_out($+1) = fun;
                for var = fun.output'
                    args_list_out($+1) = var;
                    // Remove the outputs from the list of arguments
                    ind = find(args_list_red == var);
                    args_list_red(ind) = [];
                end
                fun_taken = %T;
            else
                fun_kept($+1) = fun;
            end
        end

        fun_list_red = fun_kept;
        // Remove the arguments not anymore in the list of arguments
        fun_list_red = remove_outside_args(fun_list_red, args_list_red);

    end

endfunction

function fun_cycle = find_fun_cycle(fun_list, path, var_root)
    // *fun_list* : list of functions with a cycle
    // *path* : path of variables seen since the beginning of the research
    // *var_root* : starting point of research
    
    for fun = fun_list
        // Find the function which computes var_root
        
        if find(fun.output == var_root) <> []
            
            // Find the arguments needed to compute var_root
            for arg = fun.args'
                
                // If the argument is already in the path, it closes a cycle
                ind = find(path == arg)
                if ind <> [] then
                    
                    // return the cycle found
                    fun_cycle = path(ind(1):$);
                    break;
                    
                else
                    
                    // continue the research until finding a cycle
                    path($+1) = arg;
                    fun_cycle = find_fun_cycle(fun_list, path, arg);
                    path($) = [];
                    
                end
            end
            
            break;
            
        end
    end

endfunction

function fun_list = restore_args(fun_list, fun_val_list)
    // Put the real arguments of functions of *fun_list*.

    for i = 1:size(fun_list)
        for fun_val = fun_val_list
            if fun_val.id == fun_list(i).id then
                fun_list(i).args = fun_val.args;
                break;
            end
        end
    end

endfunction


// --------------------------- *
// Begin to sort the functions *
// --------------------------- *

fun_val_not_sorted = fun_val_list;


// --------------------------------------------------------- *
// Extract functions whose output is not a variable to solve *
// --------------------------------------------------------- *

fun_val_kept = fun_val_not_sorted;

for i = 1:size(fun_val_not_sorted)
    fun = fun_val_not_sorted(i);
    for var = fun.output'
        if find(var_resolution == var) == [] then
            disp("""" + var + """" + ' is not in Var Resol file :' ..
            + """" + fun.name + """" + ' is moved to resolution.');
            fun_resolution_val($+1) = fun;
            fun_val_kept(i) = null();
            break;
        end
    end
end

fun_val_not_sorted = fun_val_kept;

// --------------------------------------------------------------------- *
// Extract functions Val with an output computed by another function Val *
// --------------------------------------------------------------------- *

fun_val_kept = fun_val_not_sorted;

computed_output = [];
for i = 1:size(fun_val_not_sorted)
    fun = fun_val_not_sorted(i);
    is_kept = %T;
    for var = fun.output'
        if find(computed_output == var) <> [] then
            fun_resolution_val($+1) = fun;
            fun_val_kept(i) = null();
            is_kept = %F;
            break;
        end
    end
    if is_kept then
        computed_output = [computed_output ; fun.output];
    end
end

fun_val_not_sorted = fun_val_kept;

// ---------------------------------------------*
// Extract functions which does not need solver *
// -------------------------------------------- *

// Remove the arguments not in Var_Resol
fun_val_not_sorted = remove_outside_args(fun_val_not_sorted, var_resolution);

// Fill fun_resol_out / var_resol_out => take the functions which does not need solver
[fun_resol_out, var_resol_out, fun_val_not_sorted, var_resolution] = take_fun_out(fun_val_not_sorted, var_resolution);


// ---------------------- *
// Sort the functions Val *
// ---------------------- *

// while there exists function to sort
while (fun_val_not_sorted <> list())

    // ------------------------------------------------- *
    // Put the most functions possible into resol_interm *
    // ------------------------------------------------- *

    cont = %T;

    while(cont)

        t = size(fun_val_not_sorted);

        // List of output variables of not sorted functions
        output_list = [];
        for fun = fun_val_not_sorted
            for var = fun.output'
                output_list($+1) = var;
            end
        end

        // Remove arguments which are not outputs (because not computed in resol_interm)
        fun_val_not_sorted = remove_outside_args(fun_val_not_sorted, output_list);

        // Extract functions which can be extracted
        [fun_list_out, args_list_out, fun_val_not_sorted, var_resolution] = take_fun_out(fun_val_not_sorted, var_resolution);
        fun_resol_interm = lstcat(fun_resol_interm, fun_list_out);
        var_resol_interm = [var_resol_interm ; args_list_out];

        // If functions had been extracted, do the loop again
        cont = (t <> size(fun_val_not_sorted));

    end


    // -------------- *
    // Remove a cycle *
    // -------------- *

    if fun_val_not_sorted <> list() then
        // If not all variables are yet sorted, there exists a cycle
        // -> find a remove a cycle (randomly)

        // Find a cycle
        var_root = fun_val_not_sorted(1).output(1);
        path = [var_root];
        var_cycle = find_fun_cycle(fun_val_not_sorted, path, var_root);

        // Record the functions which compute the variables of the cycle
        fun_cycle = list();
        for arg = var_cycle'
            for fun = fun_val_not_sorted
                if find(fun.output == arg) <> [] then
                    fun_cycle($+1) = fun;
                    break;
                end
            end
        end

        // Record the size of the outputs of each function of the cycle
        size_outputs = list();
        for fun = fun_cycle
            current_size = 0;
            for var = fun.output'
                ind = find(Index_VarResol(:,1) == var);
                current_size = current_size + eval(Index_VarResol(ind,2) + '*' + Index_VarResol(ind,3));
            end
            size_outputs($+1) = current_size;
        end

        // Choose the function which has the smallest output
        ind_min = 1;
        size_min = size_outputs(1);
        for i = 2:size(size_outputs)
            if size_outputs(i) < size_min then
                ind_min = i;
                size_min = size_outputs(i);
            end
        end

        fun_extract = fun_cycle(ind_min);
        
        // Extract this function to the resolution
        fun_resolution_val($+1) = fun_extract;
        
        // Remove it from functions not sorted
        for i = 1:size(fun_val_not_sorted)
            if fun_val_not_sorted(i).id == fun_extract.id then
                fun_val_not_sorted(i) = null();
                break;
            end
        end

    end
end


// -------------------------------------- *
// Restore the arguments of the functions *
// -------------------------------------- *

fun_resol_out = restore_args(fun_resol_out, fun_val_list);
fun_resol_interm = restore_args(fun_resol_interm, fun_val_list);
fun_resolution_val = restore_args(fun_resolution_val, fun_val_list);
