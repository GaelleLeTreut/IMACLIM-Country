
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