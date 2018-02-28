///SUMARY///
//generation_etude
//get_nb_combis_etude

//combi2run_name
//run_name2combi
//combi2indices
//str2combi
//switch_indice_in_combi
//svdr2rid
//select_combi_to_compare

// get_dirlist
// check_wasdone
// check_tooManySubs
// classify_dirlist
// clean_savedir
// make_savedir
// adapt_classify2etude
// isfile
//==============COMBIS and ETUDE management =================
//==============OUTPUT management (make_savedir and so)==

//==============COMBIS and ETUDE management =================

function [matrice_indices]=generation_etude(ETUDE)
    //creates a matrix with the combi number and the indices
    //ETUDE is optional as level_N-1 ETUDE can be used instead
    //pour l'instant cette fonction est peu flexible car le corps de la fonction doit être modifié pour changer les indices
    //ainsi que leurs valeurs. il faudrait remplacer par des indices compris comme 'n'-ième indice et non pas només explicitement

    //PREAMBLE
    if ~isdef ( 'ETUDE')
        error ( 'generation_etude : please define ETUDE'); 
    end

    //CORPS
    select ETUDE 

    case 'IF_wpexo'

        matrice_indices = [ 1 0
        2 1  
        3 2  
        4 3  ];

    case 'encilowcarb'
        matrice_indices=[];
        combi=0;
        for ind_francePolicies = [ 0 1 7 ]
            for ind_oilPrice     = [ 0 1 ]
                for ind_polAndMeasures = [ 0 1 ]
                    for ind_franceTaxation = [ 0 1 2 ]
                        for ind_scenario = [ 0 1 2 ]
                            for ind_scenarioIndustry = [ 0 1 2 3 4]
                                for ind_nuclearOptOut = [ 0 1 ]
                                    combi=combi+1;
                                    matrice_indices=[matrice_indices;[combi,ind_francePolicies,ind_oilPrice,ind_polAndMeasures,ind_franceTaxation,ind_scenario,ind_scenarioIndustry,ind_nuclearOptOut]];
                                end
                            end
                        end
                    end
                end
            end
        end

    case 'runsForImaclimS'
        matrice_indices=[];
        combi=0;
        for ind_climat  = [0 1]
            for ind_infra = [0 1]
                combi=combi+1;
                matrice_indices=[matrice_indices;[combi,ind_climat,ind_infra]];
            end
        end

    else
        error ( 'generation_etude: unknown ETUDE: '+ETUDE);
    end

endfunction

function nb_combis=get_nb_combis_etude(index,ETUDE)
    //gets the number of possible scenarios, in order to create the adequate liste_savedir
    // [r c] = get_nb_combis_etude()
    // r = get_nb_combis_etude(1)
    // c = get_nb_combis_etude(2)

    nb_combis=[ size(generation_etude(ETUDE),1) 1];
    //hardcoded 1 : there is no more bau limo liss and so

    if argn(2)>0
        nb_combis=nb_combis(index);
    end	
endfunction

function [run_name]=combi2run_name(combi, noETUDEappend)
    //Adds the number of the combi (transforms 1 to 001 and 15 to 015) to the run name

    if argn(2)<2
        noETUDEappend = %f
    end

    if noETUDEappend
        ETUDE=''; //This is a local variable
    end

    tmp = '';

    if combi<10                  then tmp = '000'; end
    if (combi<100)&(combi>=10)   then tmp = '00' ; end
    if (combi<1000)&(combi>=100) then tmp = '0'  ; end
    if (combi>=1000) then tmp=''; end
    run_name=tmp+(combi)+'_'+ETUDE;
endfunction

function [combi]=run_name2combi(run_name)
    //gets the number of the combi from the run name
    try
        combi = evstr (part( run_name,1:4));
    catch
        disp ( 'run_name2combi was not able to get combi from run_name: '+run_name )
        combi = 0
    end
endfunction

function [varargout ] = combi2indices(combi, matrice_indices)
    //from a given combi number, this function returns the corresponding values of indices

    if argn(2)<2
        matrice_indices = generation_etude();
    end
    for i=1:size(matrice_indices,2)-1
        for j=1:size(combi,1)
            hop(j,i)=matrice_indices(matrice_indices(:,1)==combi(j),i+1);
        end
    end

    if argn(1)==1
        varargout(1)=hop
    else	
        for i=1:argn(1)
            varargout(i)=hop(:,i)
        end
    end
endfunction

function combi=str2combi(str,matrice_indices)
    //returns the scenario number from the string containing the indices
    combi = zeros(str)
    if argn(2)<2
        matrice_indices = generation_etude();
    end
    tmp=string (matrice_indices);
    tmp2=strcat (tmp(:,2:$),'','c');
    tmp=[tmp(:,1),tmp2];
    for j=1:size(str,'*')
        combi(j)=evstr (tmp(find(tmp(:,2)==str(j),1)));
    end
endfunction

function combi_out = switch_indice_in_combi(combi_in,index_rank,new_index_value,matrice_indices)
    //Returns combi_out representing same scenario than combi_in, except for one changes index
    //INPUT : 
    //  combi_in : An integer column. Combi numbers.
    //  index_rank: number. Rank of switched index in matrice_indices
    //  matrice_indices (OPTIONAL) a generation_etude like matrix (each row is a configuration of indexes)
    //              DEFAULT is generation_etude()
    //  new_index_value (OPTIONAL) : the new value for the index_rank_th indice.
    //              DEFAULT is (1-old_index_value), usefull for binary indices
    //
    //OUTPUT :  
    //  combi_out :  An integer column. Combi numbers. Can be empty.

    //EXAMPLE (works when ETUDE is defined)
    // combi2indices((12:14)')
    // switch_indice_in_combi((12:14)',2)
    // combi2indices(switch_indice_in_combi((12:14)',2))

    //PREMABULE 
    if argn(2)<4
        matrice_indices = generation_etude() //this last function manages error with ETUDE
    end
    old_indexes = combi2indices(combi_in,matrice_indices)
    if argn(2)<3
        new_index_value = 1-old_indexes(:,index_rank)
    end


    //WORK
    new_indexes = old_indexes
    new_indexes(:,index_rank) = new_index_value  //the actual switch

    combi_out = str2combi( strcat(string(new_indexes),'','c'),matrice_indices)
endfunction

function [run_id] = svdr2rid(savedir) 
    //From an absolute savedir, returns a run_id and the same savedir (with / and \ managment)

    //a la sortie, le savedir ne finit pas pas un /
    savedir = pathconvert(savedir,%f);

    if part (savedir, length(savedir))==filesep()
        savedir = part (savedir, 1:length(savedir)-1)
    end    

    //On regarde ou sont les /, on va s'interesser au dernier
    sep_positions = strindex (savedir,filesep())

    //si il n'y a pas de /, c'est qu'on a deja juste run_id
    if sep_positions($)==[]
        run_id = savedir;
        //sinon on recupere tout apres le dernier /    
    else
        run_id = part(savedir,(sep_positions($)+1):length(savedir))
    end

endfunction

function indice_eq=select_combi_to_compare(indice,set_comparisons,matrice_indices)
    //enables to make comparisons between all combi with indice=0 and the corresponding ones who were done with indice=1 or 2 
    //indice: rang de l'indice a comparer (souvent 1 pour climat par exemple)
    //set_comparisons : vecter genre [0 1] pour comparer les indice=O et indice=1

    [wasdone_etude]=adapt_classify2etude(OUTPUT,ETUDE);
    indice_eq=zeros(get_nb_combis_etude(1),size(set_comparisons,'*')-1)==1;
    for combi=matrice_indices(matrice_indices(:,indice+1)==set_comparisons(1),1)'
        colonne=1;
        for i=set_comparisons(2:$)
            if wasdone_etude(combi)&wasdone_etude(switch_indice_in_combi(combi,indice,i,matrice_indices))
                indice_eq(combi,colonne)=%t;
                indice_eq(switch_indice_in_combi(combi,indice,i,matrice_indices),colonne)=%t;
                colonne=colonne+1;
            end
        end
    end
endfunction

//=============== OUTPUT management (make_savedir and so)================

function nam=get_dirlist(absOption,OUTPUT)
    //gets a list of directories in OUTPUT. If OUTPUT is not a valid path, no error and returns []
    //
    //OUTPUT: a string, path of the directory to scan. Relative path is OK. Default value is level_N-1 OUTPUT
    //[absOption]: a boolean. Default is %t. If %t nam is absolute (eg. begining with 'e:/..' ) else there is only the dir name. 
    //nam: a string column: names of the directories (eventually absolute path) + /


    if argn(2)<1
        absOption=%t;
    end

    //error management
    if ~isdir(OUTPUT)
        disp( 'in get_listdir, '''+OUTPUT+''' was not a dir');
        nam=[]
        return
    end

    //ACTUAL WORK

    //recuparation d'une liste de dossiers
    content = dir(OUTPUT);
    nam = content.name;
    nam = nam(content.isdir);

    //Intercepting bug when nam is empty (happens when OUTPUT is empty)
    if nam~=[] 
        nam=nam(strstr(nam,'.svn')==emptystr(nam)); //keeps only the lines which do not include '.svn'.
        if absOption & size(nam,'*')>0
            nam = OUTPUT+nam ;
        end
        //proper writing of nam
        nam = pathconvert(nam,%t);
    end
endfunction

function wasdone = check_wasdone(savedir_list)
    //Checks if a run is done (if IamDoneFolks.sav exists )
    //INPUTS
    //   savedir_list :  a string matrix. savedirs.
    //OUTPUTS: 
    //   wasdone :  a boolean matrix. for ecah savedir, %t if run was done

    wasdone = isfile(savedir_list+'save'+filesep()+'IamDoneFolks.sav')  | isfile(OUTPUT+savedir_list+'save'+filesep()+'IamDoneFolks.sav')
endfunction

function wasTooManySubs = check_tooManySubs(savedir_list)
    //Checks if a run is toomanysubdivisions (if wasTooManySubs.sav exists )
    //INPUTS
    //   savedir_list :  a string matrix. savedirs.
    //OUTPUTS: 
    //   wasTooManySubs :  a boolean matrix. for ecah savedir, %t if run was too many subdivisions

    wasTooManySubs = isfile(savedir_list+'save'+filesep()+'wasTooManySubs.sav') | isfile(OUTPUT+savedir_list+'save'+filesep()+'wasTooManySubs.sav')

endfunction

function [nam, combi, wasdone , wasTooManySubs, isdoubledone]=classify_dirlist(absOption,OUTPUT)
    //Returns  as string matrix, sorted by combi the explixit paremeters
    //ignores .svn directory.
    //INPUTS : 
    // 
    //
    //head_comments get_dirlist

    //PREAMBLE: DEFAULT VALUES AND ERROR INTERCEPTION
    if argn(2)<1
        absOption=%t;
    end

    nam=get_dirlist(absOption,OUTPUT);

    //Case when nam is an empty dir
    if nam==[]
        combi= [];
        wasdone = [];
        wasTooManySubs = [];
        isdoubledone= [];
        return
    end


    //ACTUAL WORK

    //////////////////
    //Clasification 
    wasdone = check_wasdone(nam)
    wasTooManySubs = check_tooManySubs(nam)
    combi=zeros(nam);
    isdoubledone = zeros(nam)==1;

    //Getting combi
    for i=1:size(nam,'*');
        sd=nam(i);
        combi(i)=run_name2combi(svdr2rid( sd));
    end

    //Sorting everything by combi (which is probably the same than by name in get_listdir) -> it's not if combi is written in hexadecimal!!!
    [combi,k]=gsort(combi,'g','i');
    wasdone  = wasdone(k);
    nam      = nam(k);
    wasTooManySubs = wasTooManySubs(k);

    //Detecting isdoubledone
    for i=1:(size(isdoubledone,'*')-1)
        isdoubledone(i) = wasdone(i+1) & (combi(i)==combi(i+1));
    end

    //[nam, combi ,wasdone , isdoubledone]

    //Compatibility with a one-long lhs call
    if argn(1)==1
        title_ = [ 'run_id' 'combi' 'double' 'done' '2ManySub' ];
        nam = [title_; nam string(combi)  string(isdoubledone) string(wasdone ) string(wasTooManySubs)]
    end
endfunction  

function report=clean_savedir(delDoubles, delNotFinished, deltooManySubs, OUTPUT)
    //Removes from OUTPUT the 'bad' savedirs. Asks many confirmations before actually deleting.
    //INPUTS : 
    // delDoubles : boolean. Default %t. Removes the oldest of 2 or more savedir corresponding to the same combi
    // delNotFinished: boolean. Default %t. Removes not finished runs which are not toomanysubdivision.
    // deltooManySubs: boolean. Default is %f. Removes toomanysubdivisions runs. Yopu want to
    //               use this AFTER changing Dynamic or others, so the same run will not lead to toomanysubdivision again.
    // absOption : default %f. If %t, when asking for confiramtion, savedirs paths are writen from the root. Useful when used with OUTPUT.
    // OUTPUT: Sting . default is level_N-1 OUTPUT. If a valid path is providen, dir to clean, other than OUTPUT.
    //                    (e.g. an other models OUTPUT. CAUTION: older models (than 2009-2008-23) do not have toomanysubdivision detection)

    //PREAMBLE: DEFAULT VALUES AND ERROR INTERCEPTION

    if argn(2)<3
        deltooManySubs = %f;
    end
    if argn(2)<2
        delNotFinished = %t;
    end	
    if argn(2)<1
        delDoubles = %t;
    end	

    //ACTUAL WORK
    //Remembers the current directory
    lines_rmbr=lines();//remebering current lines 
    lines(0,10000);//great display

    //Getting the savedirs in sorties/ properties
    [nam combi wasdone wasTooManySubs isdoubledone]=classify_dirlist(%t,OUTPUT)

    //List of savedir to delete and motivations
    report=[]; 

    //Optional removal of the not finished runs : neither wasdonde, neither toomanysubdivisions
    if delNotFinished
        waserror = ~(wasdone | wasTooManySubs);
        //Gathering and explainine the not done runs
        if sum(waserror )>0 
            report = [ ''+nam(waserror), emptystr(nam(waserror))+'Not done (error)' ];
        end
    end

    //Optional removal of the too many subdivisions
    if deltooManySubs
        //Gathering and explainine the not done runs
        if sum(wasTooManySubs )>0 
            report = [ ''+nam(wasTooManySubs), emptystr(nam(wasTooManySubs))+'Too many subdivisions' ];
        end
    end

    //Gathering and explaining the double done runs
    if delDoubles
        for i=find (isdoubledone)
            report = [ report;
            nam(i) 'More recent : '+nam(i+1) ];
        end
    end

    //Informing and getting confirmation
    if size(report,'*')>0
        report=[ 'TO DELETE' 'MOTIVATION'; report]

        disp(report)
        userAnsw = input( 'Please double-check and then confirm you want to delete those directories by typing ''y''' ,'s')
        if userAnsw=='y'
            if input( 'If you are sure, type ''y'' again ','s')=='y'
                //Deleting the reported list
                for sd=(report(2:$,1)')
                    rmdir(sd,'s');
                end
                report(1,1)='DELETED'
            end
        else
            report ($+1,1)='nothing has been deleted'
            disp (report ($,1))
        end
    else
        disp 'Nothing to clean';
    end
    //FINAL THINGS
    //previous lines mode
    lines(lines_rmbr(2),lines_rmbr(1)) 
endfunction

function [liste_savedir, tooManySubs]= make_savedir(OUTPUT,VAR,absOption)
    //*Inputs:
    //	**OUTPUT = OPTIONAL a directory (string) where the runs are saved. Level_0 OUTPUT is used when not provided 
    //	**VAR = OPTIONAL a directory (string) where the sorted liste_savedir and tooManySubs will be saved if provided
    //  **[absOption]: OPTIONAL a boolean. Default is %t. If %t savedirs are absolute (eg. begining with 'e:/..' ) else there is only the dir name. 
    //*Outputs: liste_savedir and tooManySubs : string columns saved in VAR/liste_savedir.sav and VAR/liste_savedir
    //                                          List of succesfull runs
    //                                          List of toomanysubdivision runs

    //PREAMBLE
    //Remembers the current directory
    prev_wkdr= pwd(); 
    cd(OUTPUT);
    // DEFAULT VALUES AND ERROR INTERCEPTION
    if argn(2)<3
        absOption = %t;
    end

    //ACTUAL WORK
    tooManySubs = emptystr(get_nb_combis_etude(1),get_nb_combis_etude(2));
    liste_savedir=tooManySubs;

    //Getting the savedirs in sorties/ properties
    [nam combi wasdone wasTooManySubs isdoubledone]=classify_dirlist(%t,OUTPUT);

    //tooManySubs or liste_savedir:
    for ic=find(~isdoubledone & combi>0)
        if wasTooManySubs (ic) //too many subs are stored so they are not re-done
            tooManySubs  ( combi(ic) ) = nam(ic);
        elseif wasdone(ic) //successfull run
            liste_savedir( combi(ic) ) = nam(ic);
        end
    end

    //Filling the empty strings
    tooManySubs(tooManySubs=='')='NOTADIR';
    liste_savedir(liste_savedir=='')='NOTADIR';
    tooManySubs(tooManySubs==' ')='NOTADIR';
    liste_savedir(liste_savedir==' ')='NOTADIR';

    //save if have to
    if argn(2)>1
        if isdir(VAR)
            cd(VAR)
            save('tooManySubs.sav',tooManySubs)
            save('liste_savedir.sav',liste_savedir)
        else
            warning( 'make_savedir is not saving, cuz ' + VAR + 'was not a corect dir')
        end
    end

    //FINAL THINGS
    cd(prev_wkdr)
endfunction

function [wasdone_etude]=adapt_classify2etude(OUTPUT,ETUDE)
    wasdone_etude=zeros(get_nb_combis_etude(1,ETUDE),3)==1;
    [nam combi wasdone isdoubledone]=classify_dirlist()
    for ic=find(combi>0)
        if wasdone(ic)
            wasdone_etude( combi(ic) ) = %t;
        end
    end
    wasdone_etude=matrix (wasdone_etude,-1,1);
endfunction
