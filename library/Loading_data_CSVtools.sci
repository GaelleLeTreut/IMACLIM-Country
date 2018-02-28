//CONTAINING :
//	read_table
//	fill table
//	csv2struct_params
//////////////////////////////////////



// read_table
// Read csv in table format
function [header_row,header_col,IOT] = read_table(mat_path,sep)

if argn(2)<2
	sep=ascii(9)
end

// if argn(2)<3
	// dec=[]
// end

    mat_path = stripblanks(mat_path)

    //lis les données brutes
    [values] = read_csv(mat_path,sep)//,dec,"string",["""",""]);
    //lis le nom des fields    
    header_col = values(1,2:$)
	header_row= values(2:$,1)
    //valeur de l'IOT
    values(1,:)=[]
	values(:,1)=[]
    IOT=evstr(values);
	
	
  //  disp("read_db found ["+strcat(titles_ligne,",")+"] in "+mat_path)
  //  disp("read_db found ["+strcat(titles_colonne,",")+"] in "+mat_path)

endfunction


//////////////////////////////////////
// fill_table
// Function for filling a new table according to headers of an original table and vector of the wanted correspondance
function [new_table] = fill_table( original_table,header_row,header_col,list_row,list_col)

//index_list_row,index_list_col,

index_list_col =[];
index_list_row =[];
new_table = zeros(size(list_row,'r'),size(list_col,'r'));

for j=1:size(list_col,'r')
index_list_col=[index_list_col,find(header_col==list_col(j))];
end
	
for i=1:size(list_row,'r')
index_list_row=[index_list_row,find(header_row==list_row(i))];
// if find(header_row==list_row(i)) == []
// disp(list_row(i))
// end

end

for j=1:size(list_col,'r')
	for i=1:size(list_row,'r')
	new_table(i,j) = original_table( index_list_row(i),index_list_col(j))
	end
end

endfunction


//csv2struct_params
function [res] = csv2struct_params(fileName,extension)

    text = mgetl(fileName);

    processedText = text(strspn(text,'//')==0);
    processedText = strsubst(processedText,';',' ');
	a='%s';
	for i = 1:extension
		a=a+' %f'; 
	end
	res = msscanf(-1,processedText,a);
	

endfunction

