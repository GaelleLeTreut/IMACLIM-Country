
////////////// CONTENTS
///// Function called for checking consistency into model

//// List of the functions in the file

// CheckSystem
// CompStructDelete
// CompStructAdd


function	[errors] = CheckSystem (Imaclim_variables) ; 
		
	errors = list();
	
	//	Check if some variables are defined twice in the Imaclim_variables.sce file
	x = tabul(Imaclim_variables(:,1), "i");
	a = x(1);
	b = x(2);
	
	RepeatedVariables = [];
	
	j=1;
	for i=1:size(a,1)
		if b(i)<>1
			RepeatedVariables(j) = a(i);
			j=j+1;
		end
	end
		
	if ~isempty(RepeatedVariables)
		errors($+1) = "The following Variables in the Imaclim_variables.sce file are defined twice: "+strcat(RepeatedVariables, ", ");
	end
	
	if ~isempty(errors)
		disp("The system is not well defined");
		disp(errors);
		exit
	else
		disp("The system is well defined");
	end
	
endfunction



///	Comparing two struct a delete some fieldnames from one struct if there are contain on the ohter struct
// Structure 2 is the structure wich fieldnames must be kept

function  [structure1,common_list]=CompStructDelete(structure1, structure2)

list_fieldnames = fieldnames(structure1);
common_list = list();

for elt=1:size(list_fieldnames,"r")

	if isfield(structure2, list_fieldnames(elt))
	common_list(1+$) = list_fieldnames(elt);
	execstr('structure1' + '.' +list_fieldnames(elt)+'=null()'+';');
	// disp(list_fieldnames(elt)+" have been removed from first structure");
	end
end
endfunction


///	Comparing two struct a delete some fieldnames from one struct if there are contain on the ohter struct
// Structure 2 is the structure wich fieldnames must be kept

function  [structure1,common_list]=CompStructDeleteWithDisp(structure1, structure2)

list_fieldnames = fieldnames(structure1);
common_list = list();

for elt=1:size(list_fieldnames,"r")

	if isfield(structure2, list_fieldnames(elt))
	common_list(1+$) = list_fieldnames(elt);
	execstr('structure1' + '.' +list_fieldnames(elt)+'=null()'+';');
	disp(list_fieldnames(elt)+" have been removed from first structure");
	end
end
endfunction


///	Comparing two struct a replace a value of some fieldnames from one struct into the otherone if the field is defined
// Structure 2 is the structure wich fieldnames must be kept

function  [structure1,structure2,common_list]=CompStructAdd(structure1,STRINGstructure1, structure2, STRINGstructure2)

list_fieldnames = fieldnames(structure1);
common_list = list();

for elt=1:size(list_fieldnames,"r")

	if isfield(structure2, list_fieldnames(elt))
	common_list(1+$) = list_fieldnames(elt);
	execstr('structure2' + '.' +list_fieldnames(elt)+'=structure1' + '.'+list_fieldnames(elt)+';');
	execstr('structure1' + '.' +list_fieldnames(elt)+'=null()'+';');
	disp("value of " +list_fieldnames(elt)+" have been removed from "+ string(STRINGstructure1)+ " and added to the "+string(STRINGstructure2));
	end
end
endfunction

