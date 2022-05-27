//////////////////////////////////////////////////////////////////////////////
////	Labour desegregation into a matrix with differents classes
print(out,"Substep 2: DISAGGREGATION of Labour into a a matrix with differents skills")

// load file
L_ratio_file = read_csv(DATA_Country+"Labour_Desag.csv",";");
L_ratio_str = L_ratio_file(2:$,2:$);

// record file
L_ratio = evstr(L_ratio_str);

// Index of labour categories
Index_Labour_Desag = L_ratio_file(2:$,1);
nb_Labour_classes = size(Index_Labour_Desag,"r");


// Disaggregate Labour_value
for col = 1:nb_Sectors
    for line = 1:nb_Labour_classes
        Labour_DESAG(line,col) = L_ratio(line,col)* initial_value.Labour(col);
    end
end

// Check data
sensib = 1D-4;
for col = 1:nb_Sectors
    if ( abs( sum(Labour_DESAG(:,col)) - initial_value.Labour(col) ) > sensib ) then
        error("Colunm " + (col) + " of Labour  matrix. Check if ratio sum 1 : " + DATA_Country + "Labour_Desag.csv");
    end 
end


// replace Labour by it disaggregation
Labour = Labour_DESAG;
initial_value.Labour = Labour;


// clear the intermediate variables
clear("L_ratio_str", "L_ratio", "sensib", "col");

//////////////////////////////////////////////////////////////////////////////
////	Value added desegregation for the labour part

///Désagréger le travail dans la valeur ajoutée
// -> Labour_income , Labour_Corp_Tax, Labour_Tax
// Juste pour test technique !! : utiliser les cvs de désagrégation ( a noter que si <> de brésil c'est une autre strucuture)
Labour_income_DESAG = [initial_value.Labour_income./2;initial_value.Labour_income./2];
Labour_Tax_DESAG = [initial_value.Labour_Tax;zeros(1,nb_Sectors)];
Labour_Corp_Tax_DESAG = [initial_value.Labour_Corp_Tax;zeros(1,nb_Sectors)];

Labour_income =Labour_income_DESAG;
Labour_Tax = Labour_Tax_DESAG;
Labour_Corp_Tax = Labour_Corp_Tax_DESAG;

initial_value.Labour_income = Labour_income; 
initial_value.Labour_Tax = Labour_Tax;
initial_value.Labour_Corp_Tax = Labour_Corp_Tax;


// Changer la structure initial_value.Value_Added (et les index associés?)
// new_Value_Added = [Labour_income; Labour_Tax;Labour_Corp_Tax;initial_value.Capital_income;initial_value.Production_Tax;initial_value.Profit_margin];
// initial_value.Value_Added = new_Value_Added;
//// => soucis dans l'agregation // Aggregation.sce : ligne 292

// Mettre le salaire qui est calibré par défaut en taille (1,nb_Sectors) en taille (nb_Labour_classes,nb_Sectors)
Index_Imaclim_VarCalib(find("w"==Index_Imaclim_VarCalib(:,1)),2) = string(nb_Labour_classes);
Index_Imaclim_VarCalib(find("lambda"==Index_Imaclim_VarCalib(:,1)),2) = string(nb_Labour_classes);

/// Problem cohérence calibration exemple : 
// Employment by productive sector
// function [y] = Employment_Const_1(Labour, lambda, Y) ;

    // y1 = Labour - ( lambda .* Y' );
	/// Changed y1 by to :
	// y1 = Labour - ( lambda .*(ones(1,ones(1,nb_Labour_classes)).*.Y)' );
	

    // y = y1';
// endfunction

// G_income_Val ou Const (que ce soit 1 ou 2): Labour_Tax considéré comme vecteur, doit être sommé sur les lignes car c'est une matrice => sum(Labour_Tax,"r")