//CONTAINING :
// EltList_IntoStruct
// RemoveRefVarFromList
// ApproxPositivNulVal
// ApproxNulVal


//////////////////////////////////////
//////////////////////////////////////
// EltList_IntoStruct
// Function for checking if all elements in a list (list of string) have a corresping fieldnames in a structure 
//Application : to check if all variable, grouped into lists, are well defined


function [NotDef]=EltList_IntoStruct(listofVar,Structure)

 listSize = size(listofVar);
 StructNames = fieldnames(Structure);

 NotDef = list();
 
 for elt=1:listSize
 check = find( StructNames==listofVar(elt))
	if check==[]
	NotDef(1+$)=listofVar(elt);
	 disp( listofVar(elt)+' are not defined')
	end
end
 endfunction
 



function [Variable_approx]=ApproxPositivNulVal(Variable, Threshold_value, ApproxNulVal)

	Variable = abs(Variable);
	Variable_approx= (Variable<Threshold_value).*(ApproxNulVal) + (Variable>Threshold_value).*(Variable);
	
endfunction


function [Variable_approx]=ApproxNulVal(Variable, Threshold_value, ApproxNulVal)

	Variable_approx= (abs(Variable)<=Threshold_value).*(ApproxNulVal) + (abs(Variable)>Threshold_value).*(Variable);
	
endfunction

