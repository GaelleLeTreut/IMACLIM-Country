function [header_col, header_row, values] = read_csv_table(path_csv_file, sep, regexpcomments)
    
    // remove any space before and after the path
    path_csv_file = stripblanks(path_csv_file);
    
    // load the csv table
    // regexpcomments is only used for Projection_scenario.csv, in order to not consider commented lines
    table = read_csv(path_csv_file, sep, [], 'string', [], regexpcomments);
    
    // remove any space before and after the elements of the table
    table = stripblanks(table);
    
    // record headers and values - remove the top left corner element
    header_col = table(1,2:$);
    header_row = table(2:$,1);
    values = table(2:$,2:$);
            
endfunction
