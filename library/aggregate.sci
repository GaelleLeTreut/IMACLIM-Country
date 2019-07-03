function s = size_agg(agg)
    s = 0;
    for indexes = agg
        s = s + size(indexes,2);
    end
endfunction

function mat_agg = aggregate(mat, row_agg, col_agg)
    
    if size(mat,1) <> size_agg(row_agg) then
        error('Some rows of the matrix are not in the aggregation.');
    end
    
    if size(mat,2) <> size_agg(col_agg) then
        error('Some columns of the matrix are not in the aggregation.');
    end
    
    for line = 1:size(row_agg)
        for col = 1:size(col_agg)
            mat_agg(line,col) = sum(mat(row_agg(line),col_agg(col)));
        end
    end
    
endfunction
