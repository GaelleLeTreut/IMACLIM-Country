//////////////////////////////////////////////////////////////////
//
//  tools.sce
//  Tecnical scilab tools for general purpose
//  Meant to be called by preambule
//
//////////////////////////////////////////////////////////////////

//PART1 : Overloading operators =========================================

//retourne str0 concaténée nb fois avec elle même
function str=stringmult(nb,str0)
    str=emptystr (str0);
    if size(nb)==size(str0) then
        for i=1:size(nb,1)
            for j=1:size(nb,2)
                for k=1:nb(i,j)
                    str(i,j)=str(i,j)+str0(i,j);
                end
            end
        end
    else 
        mkalert("error");
        error ("stringmult: sizes don''t match");
    end		
endfunction
//defines 2*"hey"="heyhey"
function x=%s_m_c(a,b)
    x=stringmult(a,b)
endfunction
//defines"hey "*2="hey hey "
function x=%c_m_s(a,b)
    x=stringmult(b,a)
endfunction
//defines "string"+5 ="string5"
function x=%c_a_s(a,b)
    x=a+string(b)
endfunction
//defines 5+" string" ="5 string"
function x=%s_a_c(a,b)
    x=string(a)+b
endfunction
//defines"string"+%t ="stringT"
function x=%c_a_b(a,b)
    x=a+string(b)
endfunction
//defines %f+" string" ="F string"
function x=%b_a_c(a,b)
    x=string(a)+b
endfunction
//defines ["hi" %t] = ["hi""T"]
function x=%c_c_b(a,b)
    x=[a string(b)]
endfunction
function x=%b_c_c(a,b)
    x=[string(a) b]
endfunction
//defines ["hi" 5] = ["hi""5"]
function x=%c_c_s(a,b)
    x=[a stringE(b)]
endfunction
function x=%s_c_c(a,b)
    x=[stringE(a) b]
endfunction
function x=%c_f_s(a,b)
    x=[a; stringE(b)]
endfunction
function x=%s_f_c(a,b)
    x=[stringE(a); b]
endfunction
function x=%b_x_b(a,b)
    x=(bool2s(a) .* bool2s(b))==1
endfunction
//defines %t*"bonjour" +%f*"bye" ="bonjour"
function x=%b_m_c(a,b)
    x=%s_m_c(a+0,b)
endfunction
//defines trues(1,2) = [%t %t]
function y = trues( varargin )

    //cas special d'un argument matrice (renvoie une matrice similaire mais de booléens)
    if argn(2)==1
        y = ones (varargin(1)) == 1
        return
    end

    //debut de la chaine a executer
    strexec ="y = ones("

    for i = 1:argn(2)
        //cas special d'une matrice de dimension 0
        if varargin(i)==0
            y=[]
            return
        end
        if varargin(i)==[]
            error("mauvaise dimension pour l''agument "+i);
        end
        //ajouter l'argument suivant et une virgule
        strexec = strexec + varargin(i) +","
    end

    //supprime la derniere virgule et ajoute la comparaison à 1
    strexec = part (strexec,1:length(strexec)-1)+")==1";
    execstr(strexec) //execute la chaine

endfunction
//defines falses(1,2) = [%f %f]
function y = falses ( varargin )
    if argn(2)==1
        y = ones (varargin(1)) == 0
        return
    end

    strexec ="y = ones("

    for i = 1:argn(2)
        if varargin(i)==0
            y=[]
            return
        end
        if varargin(i)==[]
            error("mauvaise dimension pour l''agument "+i);
        end
        strexec = strexec + varargin(i) +","
    end

    strexec = part (strexec,1:length(strexec)-1)+")==0";
    execstr (strexec)
endfunction

//PART 2 : Other functions =========================================

function mkalert(optionString)
    //CPU-Beeps. You can switch"done" beeps off, but not errors. optionString=="error" or"done"
    if getos() =="Windows"  
        if ~isdef("metaBeepOn") then 
            metaBeepOn = %t; //should be modified later in imaclim.sce
        end

        if optionString =="error"
            unix ("")
            return
        end

        if metaBeepOn then //if beep annoys you, just turn that false
            if optionString =="done"  
                unix ("") ; 
                return; 
            else
                disp ("mkalert unknown argument :"+optionString+" . Please use either : ""error"",""done"" or ""alert""");
                unix ("");
            end    
        end
    end    
endfunction

function say( varargin )
    //Displays a lot of vairibles in a single line when possible
    //e.g. say(a,b,c) -> a=1 , b=1, c=1 (in just one line)

    //cas ou on fournit une liste à say
    if argn(2)==1 & type(varargin(1))==type(varargin)
        varargin = varargin(1)
    end

    thedisp="";
    for i_in_say=1:length( varargin )
        varname=varargin(i_in_say);
        varname= strsubst (varname," ","");
        varname= strsubst (varname,"	","");
        if evstr ("size("+varname+",1)")>1
            disp ( evstr (varname),varname+"=");
        else
            if thedisp ==""
                thedisp = varname+" = "+ strcat ( evstr (varname) +" ");
            else
                thedisp = thedisp+" , "+ varname+" = "+ strcat ( evstr (varname) +" ");
            end
        end
    end
    if strsubst(thedisp," ","")~="", disp (thedisp); end
endfunction

function out=titre_convul(regs,split)
    //a partir d'une liste de regions et d'une liste de variables, renvoie deux conolonnes utilisables comme titres
    //titre_convul(["usa" "can" "eur"],["GDP" "Q"])

    regs = matrix(regs,-1,1)

    n=size(regs,1)
    m=size(split,1)

    out = emptystr (n*m,1+size(split,2))

    for i=1:n
        out( (i-1)*m+1:i*m,1) = regs(i)
        out( (i-1)*m+1:i*m,2:$) =  split
    end

endfunction

function varargout =strcomb(varargin)
    //renvoie les combinaisons possible de strings
    // strcomb(["A" "B" "C"]',["a" "b" "c"]',["1" "2"]')

    //entrees
    [n_out, n_in] = argn()
    if (n_out ~=n_in) & n_out ~=1
        error ("wrong numbers of arguments")
    end

    //job    
    hop = varargin($)
    for j=n_in-1:-1:1
        hop = titre_convul(varargin(j),hop)
    end

    //sorties
    if n_out ==n_in
        for i=1:n_in
            varargout(i)=hop(:,i)
        end
    else
        varargout(1) = hop;

    end

endfunction

function str_out=stringE(mat_in)
    //strsubst(string(mat_in),"D","e")
    //which is natively read by excel

    str_out = strsubst(string(mat_in),"D","e")

endfunction

function run_date=mydate(nombre)
    //Creation of a run_date looking like 2009-01-22_10h04
    tmp8 ="";
    tmp7 ="";
    tmp2 ="";
    tmp6 ="";
    tmp9 ="";
    if argn(2)>0
        for i=1:size(nombre,"*") 
            tempdate(i,:) = getdate (nombre(i));
        end
    else
        tempdate( 1,:) = getdate ();
    end
    tmp8(tempdate(:,8)<10)="0";
    tmp7(tempdate(:,7)<10)="0";
    tmp6(tempdate(:,6)<10)="0";
    tmp2(tempdate(:,2)<10)="0";
    tmp9(tempdate(:,9)<10)="0";
    run_date = tempdate(:,1) +tmp2 +tempdate(:,2) + tmp6 + tempdate(:,6) +"_"+tmp7+ tempdate(:,7)+"h"+ tmp8 + tempdate(:,8) + "m"+ tmp9 + tempdate(:,9);
endfunction 

function are_included = my_compare(list_base,liste_to_find)
    are_included = zeros(list_base)==1;
    for i=1:size(list_base,"*")
        are_included(i)= or (list_base(i)==liste_to_find)
    end
endfunction

// function callstr = varargin2call(varargin)
// //fabrique une chaine de charactere du type "arg1, arg2, arg3"
// //utile pour encapsuler des fonctions qui utilisent varargin

// callstr = ""

// for iv2c=1:length(varargin)
// hop  = varargin(1);
// if typeof(hop)=="string"
// callstr = callstr+""""""+varargin(1)+""""","
// else
// callstr
// end
// end

// endfunction
function waitcountinit(n,step)
    global palier
    palier=0

    global taille_tot
    taille_tot=n;

    global step

endfunction

function waitcount(k)

    global palier
    global taille_tot
    global step

    c= int(k*100/taille_tot)

    if c>palier
        disp("countbar: "+c+"%")
        palier = palier+step
    end

endfunction

function stat = run_scilab(path,options)
    //runs scilab from current directory, using Wscilex of current binary, and executes file located at path
    if argn(2)<2
        options = "/low"
    end

    options = " " + options + " "

    if getos()=="Windows"
        stat = unix("start"+options+"""Starting scilab from scilab"" """+SCI+"\bin\WScilex.exe"" -f """+path+"""")
    else
        warning ("run_scilab does nothing on linux")
    end    
endfunction
