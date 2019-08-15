///////////////////////////////////////////////////////
//////////////////// Prices

function Prices = buildPriceT( pIC , pFC, w, pL, pK, pY, pM, p, fact , decimals )

    indexCommo = part(Index_Commodities,1:5);

    pIC = round( pIC * fact * 10^decimals ) / 10^decimals;
    pFC = round( pFC * fact * 10^decimals ) / 10^decimals;
    w = round( w * fact * 10^decimals ) / 10^decimals;
    pL = round( pL * fact * 10^decimals ) / 10^decimals;
    pK = round( pK * fact * 10^decimals ) / 10^decimals;
    pY = round( pY * fact * 10^decimals ) / 10^decimals;
    pM = round( pM * fact * 10^decimals ) / 10^decimals;
    p = round( p * fact * 10^decimals ) / 10^decimals;


    nCommo = size(indexCommo,1);
    Prices = emptystr(nCommo+10,nCommo+1+nb_FC+1);
    Prices( 1:nCommo+1 , 1:nCommo+1) = [ ["IC prices CO2"; indexCommo ] , [indexCommo'; pIC ] ] ; 
    Prices( 1:nCommo+1 , nCommo+2:nCommo+1+nb_FC ) =  [Index_FC';pFC]  ;

    Prices( nCommo+3: nCommo+8,   1:nCommo+1) =  [["w";"pL";"pK";"pY";"pM";"p" ],[ w;pL;pK;pY';pM';p ]];

    Prices(nCommo+10,1:2) = [ "Units",1/fact+money+"/tep,"+money+"/tons" ];

endfunction


/////////////////////////////////////////////////
// Technical Coefficient

function TechCOef = buildTechCoefT( alpha, lambda, kappa, fact , decimals )

    indexCommo = part(Index_Commodities,1:5);

    alpha = round( alpha * fact * 10^decimals ) / 10^decimals;
    lambda = round( lambda * fact * 10^decimals ) / 10^decimals;
    kappa = round( kappa * fact * 10^decimals ) / 10^decimals;


    nCommo = size(indexCommo,1);
    TechCOef = emptystr(nCommo+4,nCommo+1);
    TechCOef( 1:nCommo+1 , 1:nCommo+1) = [ ["alpha"; indexCommo ] , [indexCommo'; alpha ] ] ; 

    TechCOef( nCommo+3: nCommo+4,   1:nCommo+1) =  [["lambda";"kappa" ],[ lambda;kappa ]];	
    TechCOef(nCommo+6,1:2) = [ "Units","nan" ];

endfunction

/////////////////////////////////////////////////
// Emissions table

function CO2Emis = buildEmisT( CO2Emis_IC , CO2Emis_C , CO2Emis_X, CO2Emis_Sec,Tot_CO2Emis_IC,Tot_CO2Emis_C,DOM_CO2, fact , decimals )

    indexCommo = part(Index_Commodities,1:5);

    CO2Emis_IC = round( CO2Emis_IC * fact * 10^decimals ) / 10^decimals;
    CO2Emis_C = round( CO2Emis_C * fact * 10^decimals ) / 10^decimals;
    CO2Emis_X = round( CO2Emis_X * fact * 10^decimals ) / 10^decimals;

    CO2Emis_Sec = round( CO2Emis_Sec * fact * 10^decimals ) / 10^decimals;
    Tot_CO2Emis_IC = round( Tot_CO2Emis_IC * fact * 10^decimals ) / 10^decimals;
    Tot_CO2Emis_C = round( Tot_CO2Emis_C * fact * 10^decimals ) / 10^decimals;
    DOM_CO2 = round( DOM_CO2 * fact * 10^decimals ) / 10^decimals;

    nCommo = size(indexCommo,1);
    CO2Emis = emptystr(nCommo+5,nCommo+1+size(CO2Emis_C,2)+1);
    CO2Emis( 1:nCommo+1 , 1:nCommo+1) = [ ["Emission CO2"; indexCommo ] , [indexCommo'; CO2Emis_IC ] ] ;
    if H_DISAGG <> "HH1"
        CO2Emis( 1:nCommo+1 , nCommo+1+1:nCommo+1+size(CO2Emis_C,2)+1 ) = [["CO2Emis_"+Index_Households';CO2Emis_C],["CO2Emis_X";CO2Emis_X]];
    else
        CO2Emis( 1:nCommo+1 , nCommo+1+1:nCommo+1+size(CO2Emis_C,2)+1 ) = [["CO2Emis_C";CO2Emis_C],["CO2Emis_X";CO2Emis_X]];
    end
    CO2Emis( nCommo+2,  1:nCommo+1) =  ["CO2Emis_Sec", CO2Emis_Sec ];

    CO2Emis( nCommo+3: nCommo+5,  1:2) =  [["Tot_CO2Emis_IC";"Tot_CO2Emis_C";"DOM_CO2" ],[ Tot_CO2Emis_IC;Tot_CO2Emis_C;DOM_CO2 ]];
    CO2Emis($+1,1:2) = [ "Units",1/fact+" MtCO2" ];

endfunction

/////////////////////////////////////////////////
// IOT in value

function iot = buildIot( IC_value , FC_value , OthPart_IOT, Carbon_Tax,Supply, Uses, fact , decimals )

    indexCommo = part(Index_Commodities,1:5);

    IC_value = round( IC_value * fact * 10^decimals ) / 10^decimals;
    FC_value = round( FC_value * fact * 10^decimals ) / 10^decimals;
    OthPart_IOT = round( OthPart_IOT * fact * 10^decimals ) / 10^decimals;
    Carbon_Tax = round( Carbon_Tax * fact * 10^decimals ) / 10^decimals;
    Supply = round( Supply * fact * 10^decimals ) / 10^decimals
    Uses = round( Uses * fact * 10^decimals ) / 10^decimals;

    nCommo = size(indexCommo,1);
    iot = emptystr(nCommo+2+size(OthPart_IOT,1)+2, nCommo+2+nb_FC+1);
    iot( 1:nCommo+1 , 1:nCommo+1) = [ ["IC_value"; indexCommo ] , [indexCommo'; IC_value ] ] ;
    iot( 1:nCommo+1 , nCommo+2:nCommo+1+nb_FC ) =  [Index_FC';FC_value]  ;
    iot( 1:nCommo+1 , nCommo+2+nb_FC ) =  ["Uses";Uses];

    iot( nCommo+2:nCommo+1+size(OthPart_IOT,1),1:nCommo+1) = [Index_OthPart_IOT,OthPart_IOT ];
    iot(nCommo+1+size(OthPart_IOT,1)+1 ,1:nCommo+1) = ["Carbon_Tax",Carbon_Tax];
    iot(nCommo+1+size(OthPart_IOT,1)+2 ,1:nCommo+1) = ["Supply",Supply];

    iot($+2,1:2) = ["Units",1/fact+"k"+money ]

endfunction


/////////////////////////////////////////////////
// IO in quantities table

function iot = buildIotQ( ic , fc , oth_io, fact , decimals )

    indexCommo = part(Index_Commodities,1:5);

    IC = round( ic * fact * 10^decimals ) / 10^decimals;
    FC = round( fc * fact * 10^decimals ) / 10^decimals;
    oth_io = round( oth_io * fact * 10^decimals ) / 10^decimals;

    nCommo = size(indexCommo,1);
    iot = emptystr(nCommo+1+size(oth_io,1)+1,nCommo+1+size(FC,2));
    iot( 1:nCommo+1 , 1:nCommo+1) = [ ["IC_Q"; indexCommo ] , [indexCommo'; IC ] ] ;
    iot( 1:nCommo+1 , nCommo+1+1:nCommo+1+1+nb_FC  ) = [ ["FC_Q"; indexCommo ] , [Index_FC';FC] ] ;
    iot( nCommo+2:nCommo+2+ size(oth_io,1), 1:nCommo+1 ) = [ ["OthQ";OthQ] , [indexCommo';oth_io ] ];

    iot($+2,1:2) = [ "Units",1/fact+" ktoe / ktons" ];

endfunction


/////////////////////////////////////////////////
// Economic account table

function EcoAccountT = buildEcoTabl( Ecotable, fact , decimals )
    Ecotable = round( Ecotable * fact * 10^decimals ) / 10^decimals;

    EcoAccountT = emptystr(nb_DataAccount+1,nb_InstitAgents + 1);
    EcoAccountT (1:nb_DataAccount+1,1:nb_InstitAgents + 1) = [["Economic Table";Index_DataAccount],[Index_InstitAgents';Ecotable]];

    EcoAccountT($+2,1:2) = [ "Units",1/fact+" k"+money ];

endfunction