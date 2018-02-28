function bounds = createBounds (Imaclim_variables, list_variables4X )

    nb_variables4X = size(list_variables4X);
    prev_RowIndex = 1;

    for ind_list = 1:nb_variables4X

        ind_row_Imaclim = find(Imaclim_variables==list_variables4X(ind_list));
        nb_XRow4CurrVariable = eval(Imaclim_variables(ind_row_Imaclim,2))*eval(Imaclim_variables(ind_row_Imaclim,3));
        inf(prev_RowIndex:prev_RowIndex+nb_XRow4CurrVariable-1)  = eval(Imaclim_variables(ind_row_Imaclim,5));
        sup(prev_RowIndex:prev_RowIndex+nb_XRow4CurrVariable-1)  = eval(Imaclim_variables(ind_row_Imaclim,6));
        name(prev_RowIndex:prev_RowIndex+nb_XRow4CurrVariable-1) = Imaclim_variables(ind_row_Imaclim,1);

        prev_RowIndex = prev_RowIndex+nb_XRow4CurrVariable ;
    end

    bounds.inf = inf;
    bounds.sup = sup;
    bounds.name = name;

endfunction

