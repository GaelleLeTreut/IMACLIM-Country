//////  Copyright or © or Copr. Ecole des Ponts ParisTech / CNRS 2018
//////  Main Contributor (2017) : Gaëlle Le Treut / letreut[at]centre-cired.fr
//////  Contributors : Emmanuel Combet, Ruben Bibas, Julien Lefèvre
//////  
//////  
//////  This software is a computer program whose purpose is to centralise all  
//////  the IMACLIM national versions, a general equilibrium model for energy transition analysis
//////
//////  This software is governed by the CeCILL license under French law and
//////  abiding by the rules of distribution of free software.  You can  use,
//////  modify and/ or redistribute the software under the terms of the CeCILL
//////  license as circulated by CEA, CNRS and INRIA at the following URL
//////  "http://www.cecill.info".
//////  
//////  As a counterpart to the access to the source code and  rights to copy,
//////  modify and redistribute granted by the license, users are provided only
//////  with a limited warranty  and the software's author,  the holder of the
//////  economic rights,  and the successive licensors  have only  limited
//////  liability.
//////  
//////  In this respect, the user's attention is drawn to the risks associated
//////  with loading,  using,  modifying and/or developing or reproducing the
//////  software by the user in light of its specific status of free software,
//////  that may mean  that it is complicated to manipulate,  and  that  also
//////  therefore means  that it is reserved for developers  and  experienced
//////  professionals having in-depth computer knowledge. Users are therefore
//////  encouraged to load and test the software's suitability as regards their
//////  requirements in conditions enabling the security of their systems and/or 
//////  data to be ensured and,  more generally, to use and operate it in the
//////  same conditions as regards security.
//////  
//////  The fact that you are presently reading this means that you have had
//////  knowledge of the CeCILL license and that you accept its terms.
//////////////////////////////////////////////////////////////////////////////////

if  Country=="Brasil" then
    money ="reais";
    moneyTex="R\dollar";
	money_unit_data = "10^3";
	money_disp_unit ="Millions of ";
	money_disp_adj = 10^-3;
	Labour_unit = "ThousandFTE";
	
elseif Country=="France" then
    money="euro";
    moneyTex="\euro";
	money_unit_data ="10^3";
	money_disp_unit ="Millions of ";
	money_disp_adj = 10^-3;
	Labour_unit = "ThousandFTE";
	
elseif Country=="Argentina" then
    money="pesos";
    moneyTex="pesos";
	money_unit_data ="10^6";
	money_disp_unit ="Milliard of ";
	money_disp_adj = 10^-3;
	Labour_unit = "ThousandFTE";
else
    money="current money";
    moneyTex="Current money ";
	money_unit_data ="1";
	money_disp_adj = 1;
	Labour_unit = "ThousandFTE";
end

/// Deleting random values resulting from 0 
d.Carbon_Tax_rate_C=(CO2Emis_C <> 0) .* (d.Carbon_Tax_rate_C) +(CO2Emis_C == 0).* (d.Carbon_Tax_rate.*ones(nb_Sectors,nb_Households));
d.Carbon_Tax_rate_IC=(CO2Emis_IC <> 0) .* (d.Carbon_Tax_rate_IC) +(CO2Emis_IC == 0).* (d.Carbon_Tax_rate.*ones(nb_Sectors,nb_Sectors));
d.CarbonTax_Diff_C = (CO2Emis_C <> 0) .* d.CarbonTax_Diff_C +(CO2Emis_C == 0).*BY.CarbonTax_Diff_C;
d.CarbonTax_Diff_IC = (CO2Emis_IC <> 0) .* d.CarbonTax_Diff_IC +(CO2Emis_IC == 0).*BY.CarbonTax_Diff_IC;


param_table_sec= [ "setting", "", "", Index_Sectors'];
param_table_sec($+1:$+1+ nb_Sectors-1,1) = ["$t_{CARB_{IC}}$"];
param_table_sec(2:2+nb_Sectors-1,2) = ["$"+moneyTex+"/tCO_2$"];
param_table_sec(2:2+nb_Sectors-1,3) = Index_Sectors;
param_table_sec(2:2+nb_Sectors-1,4:4+nb_Sectors-1) = string(Carbon_Tax_rate_IC*eval(money_unit_data)/10^6);
param_table_sec($+1:$+1+ nb_Households-1,1) = ["$t_{CARB_{C}}$"];
param_table_sec($-(nb_Households-1):$,2) = ["$"+moneyTex+"/tCO_2$ "];
param_table_sec($-(nb_Households-1):$,3) = [Index_Households];
param_table_sec($-(nb_Households-1):$,4:4+nb_Sectors-1) = string(Carbon_Tax_rate_C'*eval(money_unit_data)/10^6);

param_table_sec($+1:$+1+ nb_Sectors-1,1) = ["$EF_{CARB_{IC}}$"];
param_table_sec($-nb_Sectors+1:$,2) = ["$tCO_2/toe$"];///////////////////////////////////
param_table_sec($-nb_Sectors+1:$,3) = Index_Sectors;
param_table_sec($-nb_Sectors+1:$,4:4+nb_Sectors-1) = string(Emission_Coef_IC * 10^3);//////////////////////////////////////
param_table_sec($+1:$+1+ nb_Households-1,1) = ["$EF_{CARB_{C}}$"];
param_table_sec($-(nb_Households-1):$,2) = ["$tCO_2/toe$"];//////////////////////////////////////
param_table_sec($-(nb_Households-1):$,3) = [Index_Households];
param_table_sec($-(nb_Households-1):$,4:4+nb_Sectors-1) = string(Emission_Coef_C' * 10^3);//////////////////////////////////////

// Not parameters
// param_table_sec($+1,1) = ["$delta_{LS_{H}}$"];
// param_table_sec($:$,2:3) = [" "];
// param_table_sec($,4:4+nb_Households-1) = string(delta_LS_H);


// param_table_sec($+1,1) = ["$delta_{LS_{S}}$"];
// param_table_sec($:$,2:3) = [" "];
// param_table_sec($,4:4+nb_Sectors-1) = string(delta_LS_S);

// if Country == 'France' then
    // param_table_sec($+1,1) = ["$delta_{LS_{I}}$"];
    // param_table_sec($:$,2:3) = [" "];
    // param_table_sec($,4:4) = string(delta_LS_I);

    // param_table_sec($+1,1) = ["$delta_{LS_{LT}}$"];
    // param_table_sec($:$,2:3) = [" "];
    // param_table_sec($,4:4) = string(delta_LS_LT);
// end

param_table_sec($+1:$+1+ nb_Sectors-1,1) = ["$\beta_{IC_{ji}}$"];
param_table_sec($-nb_Sectors+1:$,2) = [" "];
param_table_sec($-nb_Sectors+1:$,3) = Index_Sectors;
param_table_sec($-nb_Sectors+1:$,4:4+nb_Sectors-1) = string(ConstrainedShare_IC);

param_table_sec($+1:$+1+ nb_Sectors-1,1) = ["$\phi{IC_{ji}}$"];
param_table_sec($-nb_Sectors+1:$,2) = [" "];
param_table_sec($-nb_Sectors+1:$,3) = Index_Sectors;
param_table_sec($-nb_Sectors+1:$,4:4+nb_Sectors-1) = string(phi_IC);

param_table_sec($+1,1) = ["$\beta_{K_{i}}$"];
param_table_sec($,2:3) = [" "];
param_table_sec($,4:4+nb_Sectors-1) = string(round(ConstrainedShare_Capital*10)/10);

param_table_sec($+1,1) = ["$\phi_{K_{i}}$"];
param_table_sec($,2:3) = [" "];
param_table_sec($,4:4+nb_Sectors-1) = string(phi_K);

param_table_sec($+1,1) = ["$\beta_{L_{i}}$"];
param_table_sec($:$,2:3) = [" "];
param_table_sec($,4:4+nb_Sectors-1) = string(round(ConstrainedShare_Labour*10)/10);

param_table_sec($+1,1) = ["$\phi_{L_{i}}$"];
param_table_sec($,2:3) = [" "];
param_table_sec($,4:4+nb_Sectors-1) = string(phi_L);

param_table_sec($+1:$+1+ nb_Households-1,1) = ["$\beta_{i_h}$"];
param_table_sec($-(nb_Households-1):$,2) = [""];
param_table_sec($-(nb_Households-1):$,3) = [Index_Households];
param_table_sec($-(nb_Households-1):$,4:4+nb_Sectors-1)= string(ConstrainedShare_C');

param_table_sec($+1,1) = ["$\delta_{C_{i_h}}$"];
param_table_sec($:$,2:3) = [" "];
param_table_sec($,4:4+nb_Sectors-1) = string(delta_C_parameter);

param_table_sec($+1,1) = ["$\sigma$"];
param_table_sec($:$,2:3) = [" "];
param_table_sec($,4:4+nb_Sectors-1) = string(sigma);
param_table_sec($+1,1) = ["$\sigma_{M_{p_{i}}}$"];
param_table_sec($:$,2:3) = [" "];
param_table_sec($,4:4+nb_Sectors-1) = string(sigma_M);

param_table_sec($+1,1) = ["$\delta_{M_{i}}$"];
param_table_sec($:$,2:3) = [" "];
param_table_sec($,4:4+nb_Sectors-1) = string(delta_M_parameter);

param_table_sec($+1,1) = ["$\delta_{p_{M_{i}}}$"];
param_table_sec($:$,2:3) = [" "];
param_table_sec($,4:4+nb_Sectors-1) = string(delta_pM_parameter);

param_table_sec($+1,1) = ["$\sigma_{X_{p_{i}}}$"];
param_table_sec($:$,2:3) = [" "];
param_table_sec($,4:4+nb_Sectors-1) = string(sigma_X);

param_table_sec($+1,1) = ["$\delta_{X_{i}}$"];
param_table_sec($:$,2:3) = [" "];
param_table_sec($,4:4+nb_Sectors-1) = string(delta_X_parameter);

if size(sigma_ConsoBudget,"r")<>1
param_table_sec($+1:$+1+ nb_Households-1,1) = ["$\sigma_{CR_i}$"];
param_table_sec($-(nb_Households-1):$,2) = [""];
param_table_sec($-(nb_Households-1):$,3) = [Index_Households];
param_table_sec($-(nb_Households-1):$,4:4+nb_Sectors-1)= string(sigma_ConsoBudget');
end

param_table_sec($+1:$+1+ nb_Households-1,1) = ["$\sigma_{CP_i}$"];
param_table_sec($-(nb_Households-1):$,2) = [""];
param_table_sec($-(nb_Households-1):$,3) = [Index_Households];
param_table_sec($-(nb_Households-1):$,4:4+nb_Sectors-1)= string(sigma_pC');

param_table_sec($+1,1) = ["-----"];
param_table_sec($+1,1) = ["Not applied to sectoral decomposition"];

if size(sigma_ConsoBudget,"r")==1
param_table_sec($+1:$+1+ nb_Households-1,1) = ["$\sigma_{CR_i}$"];
param_table_sec($-(nb_Households-1):$,2) = [""];
param_table_sec($-(nb_Households-1):$,3) = [Index_Households];
param_table_sec($-(nb_Households-1):$,4)= string(round(sigma_ConsoBudget*10)'/10);
end

param_table_sec($+1,1) = ["$Mu$"];
param_table_sec($:$,2:3) = [" "];
param_table_sec($,4) = string(Mu);

param_table_sec($+1,1) = ["$\sigma_{w_u}$"];
param_table_sec($:$,2:3) = [" "];
if size(Coef_real_wage,2)==1
    param_table_sec($,4) = string(sigma_omegaU);
    param_table_sec($+1,1) = ["$\beta_{w_{CPI}}$"];
    param_table_sec($:$,2:3) = [" "];
    param_table_sec($,4) = string(Coef_real_wage);
    param_table_sec($+1,1) = ["$\u_{param}$"];
    param_table_sec($:$,2:3) = [" "];
    param_table_sec($,4) = string(u_param);
else
    param_table_sec($,4:4+nb_Sectors-1) = string(sigma_omegaU_sect);
    param_table_sec($+1,1) = ["$\beta_{w_{CPI}}$"];
    param_table_sec($:$,2:3) = [" "];
    param_table_sec($,4:4+nb_Sectors-1) = string(Coef_real_wage);
end
param_table_sec($+1,1) = ["$t_{BY}$"];
param_table_sec($:$,2:3) = [" "];
param_table_sec($,4) = string(time_since_BY);
param_table_sec($+1,1) = ["$t_{ini}$"];
param_table_sec($:$,2:3) = [" "];
param_table_sec($,4) = string(time_since_ini);

// param_table_sec($+1,1) = ["$Population$"];
// param_table_sec($:$,2:3) = ["Thousands of people"];
// param_table_sec($,4) = string(sum(Population));
// param_table_sec($+1,1) = ["$Labour_force$"];
// param_table_sec($:$,2:3) = ["Thousands of people"];
// param_table_sec($,4) = string(sum(Labour_force));
// param_table_sec($+1,1) = ["$Retired$"];
// param_table_sec($:$,2:3) = ["Thousands of people"];
// param_table_sec($,4) = string(sum(Retired));

if Output_files
csvWrite(param_table_sec,SAVEDIR+"param_table_sec_"+Name_time+"_"+simu_name+".csv", ';');
end

if Output_prints

print(out,"===============================================\n");
print(out,"===== OUTPUTS =================================\n");
print(out,"===============================================\n");


//// Printing decomposition
print(out,"== Households consumption variation ===========");
print(out,[ "Sector" "Initial Value" "Run" "Growth";[Index_Sectors sum(ini.C,"c") sum(C,"c") sum(round(100*(divide(C,ini.C,%nan)-1)),"c")]]);

if  Country<>"Brasil" then
    print(out,"===== Households ==============================");
    print(out,[
    "Items"                "Initial Value"                 "Run";
    "H_disposable_income"   sum(ini.H_disposable_income,"c")       sum(d.H_disposable_income,"c");
    "Other_Direct_Tax"      sum(ini.Other_Direct_Tax,"c")  sum(d.Other_Direct_Tax,"c")
    ]);
else
    print(out,"===== Households ==============================");
    print(out,[
    "Items"                "Initial Value"                 "Run";
    "H_disposable_income"   sum(ini.H_disposable_income,"c")       sum(d.H_disposable_income,"c");
    ]);
end


print(out,"===== Firms ===================================");
print(out,[
"Items"                     "Initial Value"                 "Run";
"Corp_disposable_income"    ini.Corp_disposable_income    d.Corp_disposable_income;
"Corporate_Tax"             ini.Corporate_Tax     d.Corporate_Tax;
]);

print(out,"===== pY    ===================================");
print(out,[ "Sector" "Initial Value" "Run" "Growth";[Index_Sectors round(ini.pY) round(d.pY) round((d.pY./ini.pY-1)*100)]]);

print(out,"===== Trade margins ===========================");
print(out,[["Sectors" "Initial value" "Run" "Rate Initial Value" "Rate Run" "Rate ratio" ]; [Index_Sectors';  ini.Trade_margins ; d.Trade_margins ; ini.Trade_margins_rates; d.Trade_margins_rates ; divide(ini.Trade_margins_rates,d.Trade_margins_rates,%nan)]'])


print(out,"===== Transp margins ==========================");
print(out,[["Sectors" "Initial value" "Run" "Rate Initial Value" "Rate Run" "Rate ratio" ];
[Index_Sectors';  ini.Transp_margins ; d.Transp_margins ; ini.Transp_margins_rates; d.Transp_margins_rates ; divide(ini.Transp_margins_rates,d.Transp_margins_rates,%nan)]'])

print(out,"===== Decomposition pY - Initial Value ========================");
print(out,[ ["Sector" "pY" "IC" "L" "K" "Prod tax" "Markup"] ;
[Index_Sectors';  round([ ini.pY' ; sum(ini.pIC .* ini.alpha,"r") ; sum(ini.pL .* ini.lambda,"r") ; sum(ini.pK .* ini.kappa, "r") ; ini.Production_Tax_rate .* ini.pY' ; ini.markup_rate .* ini.pY' ])]']);

print(out,"===== Decomposition pY Run ========================");
print(out,[ ["Sector" "pY" "IC" "L" "K" "Prod tax" "Markup"] ;
[Index_Sectors';  round([ d.pY' ; sum(d.pIC .* d.alpha,"r") ; sum(d.pL .* d.lambda,"r") ; sum(d.pK .* d.kappa, "r") ;d.Production_Tax_rate .* d.pY' ; d.markup_rate .* d.pY' ])]']);

print(out,"===== Decomposition pY Ratio/ initial value ========================");
print(out,[ ["Sector" "pY" "IC" "L" "K" "Prod tax" "Markup"] ;
[Index_Sectors';  [ d.pY'./ini.pY' ; sum(d.pIC .* d.alpha,"r")./sum(ini.pIC .* ini.alpha,"r") ; sum(d.pL .* d.lambda,"r")./sum(ini.pL .* ini.lambda,"r") ; divide(sum(d.pK .* d.kappa, "r"),sum(ini.pK .* ini.kappa, "r"),%nan) ;divide((d.Production_Tax_rate .* d.pY'),(ini.Production_Tax_rate .* ini.pY'),%nan) ; divide((d.markup_rate .* d.pY'),(ini.markup_rate .* ini.pY'),%nan) ]]']);
end


///////////////////////
/// Calcul keuros/kreais/etc.
///////////////////////
d.IC_value = value(d.pIC,d.IC);
d.C_value =value( d.pC, d.C);
d.G_value = value(d.pG,d.G);
d.I_value = value(d.pI*ones(1,nb_size_I),d.I);
d.X_value = value(d.pX,d.X);
d.M_value = value(d.pM',d.M');
d.Y_value = value(d.pY,d.Y)';


///////////////////////
//Calcul Emissions
///////////////////////

//Initial value
CO2_IC_Initval =  [["CO2_IC_Initval"; Index_Commodities ],[Index_Sectors';ini.CO2Emis_IC]];
CO2_FC_Initval = [["CO2_C_Initval"; Index_Commodities ] ,["C"  ;sum(ini.CO2Emis_C,"c") ]];
ini.CO2Emis_Sec = sum(ini.CO2Emis_IC,"r");
ini.Tot_CO2Emis_IC =  sum(ini.CO2Emis_IC);
ini.Tot_CO2Emis_C = sum(ini.CO2Emis_C);
ini.DOM_CO2 = ini.Tot_CO2Emis_IC + ini.Tot_CO2Emis_C; 
ini.CO2Emis_X = ini.CO2Emis_X ; 
ini.Tot_CO2Emis =ini.Tot_CO2Emis_IC + ini.Tot_CO2Emis_C;
// Run
d.CO2Emis_C = d.Emission_Coef_C .*d.C;
d.CO2Emis_C_tot = sum(d.CO2Emis_C);
d.CO2Emis_IC = d.Emission_Coef_IC .*d.IC;
d.CO2Emis_IC_tot = sum(d.CO2Emis_IC);
CO2_IC_Run=  [["CO2_IC_Run"; Index_Commodities ],[Index_Sectors';d.CO2Emis_IC]];
CO2_C_Run = [["CO2_C_Run"; Index_Commodities ] ,["C" ;sum(d.CO2Emis_C,"c") ]];
d.CO2Emis_Sec = sum(d.CO2Emis_IC,"r");
d.Tot_CO2Emis_IC =  sum(d.CO2Emis_IC);
d.Tot_CO2Emis_C = sum(d.CO2Emis_C);
d.DOM_CO2 = d.Tot_CO2Emis_IC + d.Tot_CO2Emis_C; 
d.CO2Emis_X = ini.CO2Emis_X ; 
d.Tot_CO2Emis =d.Tot_CO2Emis_IC + d.Tot_CO2Emis_C;


///////////////////////
// Matrix IOT - Values
///////////////////////
// Households
if	H_DISAGG <> "HH1"
    for elt=1:nb_Households
        varname = Index_C(elt);
        execstr ("d."+varname+"_value"+"="+"d.C_value(:,elt)"+";");
        execstr ("d."+varname+"="+"d.C(:,elt)"+";");
        execstr ("d.p"+varname+"="+"d.pC(:,elt)"+";");
        execstr ("ini.p"+varname+"="+"ini.pC(:,elt)"+";");
        execstr ("d.SpeMarg_"+varname+"="+"d.SpeMarg_C(elt,:)"+";");
    end
end

// FC  matrix
for elt=1:nb_FC
    varname = Index_FC(elt);
    if varname <> "I" then
        execstr ("d.FC_value(:,elt)"+"="+"d."+varname+"_value"+";");
        execstr ("d.FC(:,elt)"+"="+"d."+varname+";");
    else
        execstr ("d.FC_value(:,elt)"+"="+"sum(d.I_value, ''c'')"+";");
        execstr ("d.FC(:,elt)"+"="+"sum(d.I, ''c'')"+";");
    end
    execstr ("d.pFC(:,elt)"+"="+"d.p"+varname+";");
    execstr ("ini.pFC(:,elt)"+"="+"ini.p"+varname+";");
end
// OthPart_IOT
// Value_Added
for elt=1:nb_Value_Added
    varname = Index_Value_Added(elt);
    execstr ("d.Value_Added(elt,:)"+"="+"d."+varname+";");
end
//Margins
for elt=1:nb_Margins
    varname = Index_Margins(elt);
    execstr ("d.Margins(elt,:)"+"="+"d."+varname+";");
end
for elt=1:nb_SpeMarg_FC
    varname = Index_SpeMarg_FC(elt);
    execstr ("d.SpeMarg_FC(elt,:)"+"="+"d."+varname+";");
end
//Taxes
for elt=1:nb_Taxes
    varname = Index_Taxes(elt);
    if varname == "ClimPolCompensbySect"
        execstr ("d.Taxes(elt,:)"+"="+"-d."+varname+";");
    else
        execstr ("d.Taxes(elt,:)"+"="+"d."+varname+";");
    end
end


ini.OthPart_IOT = [ini.Value_Added;ini.M_value;ini.Margins;ini.SpeMarg_IC;ini.SpeMarg_FC;ini.Taxes];

// Initial value
IC_value_Initval =  [ ["IC_value_Initval"; Index_Commodities ] , [Index_Sectors';ini.IC_value] ] ;
FC_value_Initval =  [ ["FC_value_Initval"; Index_Commodities ] , [Index_FC';ini.FC_value] ] ;
OthPart_IOT_Initval = [ ["OthPart_IOT_Initval";Index_OthPart_IOT] , [Index_Sectors';ini.OthPart_IOT] ];
ini.Carbon_Tax = sum(ini.Carbon_Tax_IC',"r") + sum(ini.Carbon_Tax_C',"r");
ini.Supply = (sum(ini.IC_value,"r")+sum(ini.OthPart_IOT,"r")+ini.Carbon_Tax);
ini.Uses = sum(ini.IC_value,"c")+sum(ini.FC_value,"c");

ini.Total_taxes = sum(ini.Taxes)+sum(ini.Carbon_Tax_C)+sum(ini.Carbon_Tax_IC)+sum(ini.Carbon_Tax_M);
ini.HH_EnBill = sum(ini.C_value(Indice_EnerSect));
ini.Corp_EnBill = sum(ini.IC_value(Indice_EnerSect,:));
ini.HH_EnConso = sum(ini.C(Indice_EnerSect));
ini.Corp_EnConso = sum(ini.IC(Indice_EnerSect,:));


// Run
IC_value_Run =  [ ["IC_value_Run"; Index_Commodities ] , [Index_Sectors';d.IC_value] ] ;
FC_value_Run =  [ ["FC_value_Run"; Index_Commodities ] , [Index_FC';d.FC_value] ] ;
OthPart_IOT_Run = [ ["OthPart_IOT_Run";Index_OthPart_IOT] , [Index_Sectors';d.OthPart_IOT] ];

d.tot_IC_col_val = sum(d.IC_value , "c");
d.tot_IC_row_val = sum(d.IC_value , "r");
d.tot_FC_value =sum(d.FC_value,"c");

d.tot_FC = sum(d.FC,"c");
d.tot_IC_col = sum(d.IC , "c");
d.tot_supply = sum (d.M+d.Y, "c");

d.OthPart_IOT = [d.Value_Added;d.M_value;d.Margins;d.SpeMarg_IC;d.SpeMarg_FC;d.Taxes];
d.Carbon_Tax = sum(d.Carbon_Tax_IC',"r") + sum(d.Carbon_Tax_C',"r");
d.Supply = (sum(d.IC_value,"r")+sum(d.OthPart_IOT,"r")+d.Carbon_Tax);
d.Uses = sum(d.IC_value,"c")+sum(d.FC_value,"c");



d.ERE_balance_val = d.Supply- d.Uses';

d.Total_taxes = sum(d.Taxes)+sum(d.Carbon_Tax_C)+sum(d.Carbon_Tax_IC)+sum(d.Carbon_Tax_M);
d.HH_EnBill = sum(d.C_value(Indice_EnerSect));
d.Corp_EnBill = sum(d.IC_value(Indice_EnerSect,:));
d.HH_EnConso = sum(d.C(Indice_EnerSect));
d.Corp_EnConso = sum(d.IC(Indice_EnerSect,:));





///////////////////////
// Matrix IOT - Quantities
///////////////////////

//Initial value
Q_IC_Initval =  [["Q_IC_Initval"; Index_Commodities ],[Index_Sectors';ini.IC]];
Q_FC_Initval = [["Q_FC_Initval"; Index_Commodities ] ,[Index_FC';ini.FC]];
Q_Y_Initval = [["Q_Y_Initval"; Index_Commodities ] ,["Y";ini.Y]];
Q_M_Initval = [["Q_M_Initval"; Index_Commodities ] ,["M";ini.M]];
OthQ = ["Y";"M";"Labour";"Capital_consumption"];
ini.OthQ = [ini.Y';ini.M';ini.Labour;ini.Capital_consumption];
OthQ_Initval = [["OthQ_Initval";OthQ],[Index_Commodities';ini.OthQ]];

// Run
Q_IC_Run=  [["Q_IC_Run"; Index_Commodities ],[Index_Sectors';d.IC]];
Q_FC_Run = [["Q_FC_Run"; Index_Commodities ] ,[Index_FC';d.FC]];
Q_Y_Run = [["Q_Y_Run"; Index_Commodities ] ,["Y";d.Y]];
Q_M_Run = [["Q_M_Run"; Index_Commodities ] ,["M";d.M]];
d.OthQ = [d.Y';d.M';d.Labour;d.Capital_consumption];
OthQ_Run = [["OthQ_Run";OthQ],[Index_Commodities';d.OthQ ]];

///////////////////////
// Economic table
///////////////////////

//Initial value
ini.Income_Tax(Indice_Households)= - ini.Income_Tax;
ini.Income_Tax([Indice_Corporations,Indice_Government,Indice_RestOfWorld]) = 0;
ini.Income_Tax(Indice_Government) = -sum(ini.Income_Tax(Indice_Households));
ini.Income_Tax= matrix(ini.Income_Tax,1,-1);


ini.Corporate_Tax(Indice_Corporations) = -ini.Corporate_Tax;
ini.Corporate_Tax(1,[Indice_Households,Indice_RestOfWorld]) = 0;
ini.Corporate_Tax(1,Indice_Government) = -ini.Corporate_Tax(Indice_Corporations);
ini.GFCF_byAgent (Indice_RestOfWorld) = 0;

if  Country<>"Brasil" then
    ini.Pensions(Indice_Households)= ini.Pensions;
    ini.Pensions([Indice_Corporations,Indice_Government,Indice_RestOfWorld]) = 0;
    ini.Pensions(Indice_Government) = -sum(ini.Pensions(Indice_Households));
    ini.Pensions= matrix(ini.Pensions,1,-1);

    ini.Unemployment_transfers(Indice_Households)= ini.Unemployment_transfers;
    ini.Unemployment_transfers([Indice_Corporations,Indice_Government,Indice_RestOfWorld]) = 0;
    ini.Unemployment_transfers(Indice_Government) = -sum(ini.Unemployment_transfers(Indice_Households));
    ini.Unemployment_transfers= matrix(ini.Unemployment_transfers,1,-1);

    ini.Other_social_transfers(Indice_Households)= ini.Other_social_transfers;
    ini.Other_social_transfers([Indice_Corporations,Indice_Government,Indice_RestOfWorld]) = 0;
    ini.Other_social_transfers(Indice_Government) = -sum(ini.Other_social_transfers(Indice_Households));
    ini.Other_social_transfers= matrix(ini.Other_social_transfers,1,-1);


    ini.Other_Direct_Tax(Indice_Households)= -ini.Other_Direct_Tax;
    ini.Other_Direct_Tax([Indice_Corporations,Indice_Government,Indice_RestOfWorld]) = 0;
    ini.Other_Direct_Tax(Indice_Government) = -sum(ini.Other_Direct_Tax(Indice_Households));
    ini.Other_Direct_Tax= matrix(ini.Other_Direct_Tax,1,-1);
else

    ini.Gov_social_transfers(Indice_Households) = ini.Gov_social_transfers;
    ini.Gov_social_transfers([Indice_Corporations,Indice_Government,Indice_RestOfWorld]) = 0;
    ini.Gov_social_transfers(Indice_Government) = -sum(ini.Gov_social_transfers(Indice_Households));
    ini.Gov_social_transfers= matrix(ini.Gov_social_transfers,1,-1);

    ini.Corp_social_transfers(Indice_Households) = ini.Corp_social_transfers;
    ini.Corp_social_transfers([Indice_Corporations,Indice_Government,Indice_RestOfWorld]) = 0;
    ini.Corp_social_transfers(Indice_Corporations) = -sum(ini.Corp_social_transfers(Indice_Households));
    ini.Corp_social_transfers= matrix(ini.Corp_social_transfers,1,-1);

    ini.Gov_Direct_Tax(Indice_Households)= -ini.Gov_Direct_Tax;
    ini.Gov_Direct_Tax([Indice_Corporations,Indice_Government,Indice_RestOfWorld]) = 0;
    ini.Gov_Direct_Tax(Indice_Government) = -sum(ini.Gov_Direct_Tax(Indice_Households));
    ini.Gov_Direct_Tax= matrix(ini.Gov_Direct_Tax,1,-1);

    ini.Corp_Direct_Tax(Indice_Households)= -ini.Corp_Direct_Tax;
    ini.Corp_Direct_Tax([Indice_Corporations,Indice_Government,Indice_RestOfWorld]) = 0;
    ini.Corp_Direct_Tax(Indice_Corporations) = -sum(ini.Corp_Direct_Tax(Indice_Households));
    ini.Corp_Direct_Tax= matrix(ini.Corp_Direct_Tax,1,-1);

end


for elt=1:nb_DataAccount
    varname = Index_DataAccount(elt);
    execstr ("ini.Ecotable(elt,:)"+"="+"ini."+varname+";");
end

ini.NetLendingGov = ini.NetLending(Indice_Government);
ini.NetLendingRoW_GDP = (ini.NetLending(Indice_RestOfWorld)./ini.GDP);

// Run
d.Trade_Balance =(sum(d.M_value) - sum(d.X_value))*(Index_InstitAgents' == "RestOfWorld");
d.Production_Tax_byAgent = sum(d.Production_Tax) *(Index_InstitAgents' == "Government");
d.Energ_Tax_byAgent = (sum(d.Energy_Tax_IC) + sum(d.Energy_Tax_FC))*(Index_InstitAgents' == "Government");
d.OtherIndirTax_byAgent = (sum(d.OtherIndirTax))*(Index_InstitAgents' == "Government");
d.VA_Tax_byAgent = (sum(d.VA_Tax))*(Index_InstitAgents' == "Government");

d.Disposable_Income(1,Indice_Corporations) = d.Corp_disposable_income;
d.Disposable_Income(1,Indice_Government) = d.G_disposable_income;
d.Disposable_Income(1,Indice_Households) = d.H_disposable_income;
d.Disposable_Income(1,Indice_RestOfWorld) = d.Trade_Balance(Indice_RestOfWorld) + d.Property_income(Indice_RestOfWorld)+d.Other_Transfers(Indice_RestOfWorld);

d.FC_byAgent (1,Indice_Government) = sum(d.G_value);
d.FC_byAgent (1,Indice_Households) = sum(d.C_value, "r");
d.FC_byAgent (1,Indice_RestOfWorld) = 0;
d.FC_byAgent (1,Indice_Corporations) = 0;

if  Country<>"Brasil" then

    d.InsuranceContrib_byAgent = sum(d.Labour_Tax) *(Index_InstitAgents' == "Government");

    d.Pensions(Indice_Households)= d.Pensions;
    d.Pensions([Indice_Corporations,Indice_Government,Indice_RestOfWorld]) = 0;
    d.Pensions(Indice_Government) = -sum(d.Pensions(Indice_Households));
    d.Pensions= matrix(d.Pensions,1,-1);

    d.Unemployment_transfers(Indice_Households)= d.Unemployment_transfers;
    d.Unemployment_transfers([Indice_Corporations,Indice_Government,Indice_RestOfWorld]) = 0;
    d.Unemployment_transfers(Indice_Government) = -sum(d.Unemployment_transfers(Indice_Households));
    d.Unemployment_transfers= matrix(d.Unemployment_transfers,1,-1);

    d.Other_social_transfers(Indice_Households)= d.Other_social_transfers;
    d.Other_social_transfers([Indice_Corporations,Indice_Government,Indice_RestOfWorld]) = 0;
    d.Other_social_transfers(Indice_Government) = -sum(d.Other_social_transfers(Indice_Households));
    d.Other_social_transfers= matrix(d.Other_social_transfers,1,-1);


    d.Other_Direct_Tax(Indice_Households)= -d.Other_Direct_Tax;
    d.Other_Direct_Tax([Indice_Corporations,Indice_Government,Indice_RestOfWorld]) = 0;
    d.Other_Direct_Tax(Indice_Government) = -sum(d.Other_Direct_Tax(Indice_Households));
    d.Other_Direct_Tax= matrix(d.Other_Direct_Tax,1,-1);
else

	d.Cons_Tax_byAgent = (sum(d.Cons_Tax))*(Index_InstitAgents' == "Government");
		
    d.InsuranceContrib_byAgent = zeros(1,nb_InstitAgents);
    d.InsuranceContrib_byAgent(Indice_Government) = sum(d.Labour_Tax) ;
    d.InsuranceContrib_byAgent(Indice_Corporations) = sum(d.Labour_Corp_Tax);

    d.Gov_social_transfers(Indice_Households) = d.Gov_social_transfers;
    d.Gov_social_transfers([Indice_Corporations,Indice_Government,Indice_RestOfWorld]) = 0;
    d.Gov_social_transfers(Indice_Government) = -sum(d.Gov_social_transfers(Indice_Households));
    d.Gov_social_transfers= matrix(d.Gov_social_transfers,1,-1);

    d.Corp_social_transfers(Indice_Households) = d.Corp_social_transfers;
    d.Corp_social_transfers([Indice_Corporations,Indice_Government,Indice_RestOfWorld]) = 0;
    d.Corp_social_transfers(Indice_Corporations) = -sum(d.Corp_social_transfers(Indice_Households));
    d.Corp_social_transfers= matrix(d.Corp_social_transfers,1,-1);

    d.Gov_Direct_Tax(Indice_Households)= -d.Gov_Direct_Tax;
    d.Gov_Direct_Tax([Indice_Corporations,Indice_Government,Indice_RestOfWorld]) = 0;
    d.Gov_Direct_Tax(Indice_Government) = -sum(d.Gov_Direct_Tax(Indice_Households));
    d.Gov_Direct_Tax= matrix(d.Gov_Direct_Tax,1,-1);

    d.Corp_Direct_Tax(Indice_Households)= -d.Corp_Direct_Tax;
    d.Corp_Direct_Tax([Indice_Corporations,Indice_Government,Indice_RestOfWorld]) = 0;
    d.Corp_Direct_Tax(Indice_Corporations) = -sum(d.Corp_Direct_Tax(Indice_Households));
    d.Corp_Direct_Tax= matrix(d.Corp_Direct_Tax,1,-1);

end


d.Carbon_Tax_byAgent(Indice_Government)= sum(d.Carbon_Tax);
if Carbon_BTA
d.Carbon_Tax_byAgent(Indice_Government)= d.Carbon_Tax_byAgent(Indice_Government)+sum(d.Carbon_Tax_M);
end 

d.Carbon_Tax_byAgent([Indice_Corporations,Indice_Households,Indice_RestOfWorld]) = 0;
d.Carbon_Tax_byAgent= matrix(d.Carbon_Tax_byAgent,1,-1);

d.Income_Tax(Indice_Households)= - d.Income_Tax;
d.Income_Tax([Indice_Corporations,Indice_Government,Indice_RestOfWorld]) = 0;
d.Income_Tax(Indice_Government) = -sum(d.Income_Tax(Indice_Households));
d.Income_Tax= matrix(d.Income_Tax,1,-1);

d.Corporate_Tax(Indice_Corporations) = -d.Corporate_Tax;
d.Corporate_Tax(1,[Indice_Households,Indice_RestOfWorld]) = 0;
d.Corporate_Tax(1,Indice_Government) = -d.Corporate_Tax(Indice_Corporations);
d.GFCF_byAgent (Indice_RestOfWorld) = 0;


d.Tot_FC_byAgent = d.GFCF_byAgent + d.FC_byAgent ;

for elt=1:nb_DataAccount
    varname = Index_DataAccount(elt);
    execstr ("d.Ecotable(elt,:)"+"="+"d."+varname+";");
end

d.NetLendingGov= d.NetLending(Indice_Government);
d.NetLendingRoW_GDP = (d.NetLending(Indice_RestOfWorld)./d.GDP);

/////////////////
// Price table
///////////////////
//Initial value
price_IC_Initval =  [["price_IC_Initval"; Index_Commodities ],[Index_Sectors';ini.pIC]];
price_FC_Initval = [["price_FC_Initval"; Index_Commodities ] ,["p"+Index_FC';ini.pFC]];
// Run
price_IC_Run =  [["price_IC_Run"; Index_Commodities ],[Index_Sectors';d.pIC]];
price_FC_Run = [["price_FC_Run"; Index_Commodities ],["p"+Index_FC';d.pFC]];



///////////////////////
// Evolution : run / ini ( step before current year) or BY /  in ratio 
///////////////////////

// Stock all calculation of extra calculation of ini within BY at first step
if time_step ==1
execstr("BY." + fieldnames(ini) +" = ini." + fieldnames(ini) + ";");
end

evol_list = list('pIC','pFC','w','pL','pL', 'pK','pY', 'pM', 'p','alpha','lambda','kappa','CO2Emis_IC','CO2Emis_C','CO2Emis_X','CO2Emis_Sec'	,'Tot_CO2Emis_IC' ,'Tot_CO2Emis_C','DOM_CO2','IC_value','FC_value','OthPart_IOT','Carbon_Tax','Supply','Uses','IC','FC','Y','OthQ','Ecotable','Total_taxes','HH_EnBill','Corp_EnBill','HH_EnConso','Corp_EnConso','NetLendingRoW_GDP','NetLendingGov','I');

for ind=1:size(evol_list)
	varname = evol_list(ind);
	execstr("evol_BY."+varname+"=divide(d."+varname+",BY."+varname+",%nan)");
	
	if time_step == 1
		execstr("evol_init."+varname+"=divide(ini."+varname+",ini."+varname+",%nan)")
	end
	
	if time_step>1
		execstr("evol."+varname+"=divide(d."+varname+",ini."+varname+",%nan)");
		/// Specific case for argentina to compare with 2015 : step 1 of the resolution
		execstr("evol_2015."+varname+"=divide(d."+varname+",data_1."+varname+",%nan)")
	end
	
	if Country=="Argentina"& time_step==1
	/// Specific case for argentina to compare with 2015 : step 1 of the resolution
	execstr("evol_2015."+varname+"=divide(d."+varname+",d."+varname+",%nan)")
	end

end


//////////////////////
/////////////////////////////////// BUILDING TABLES FOR outputs////////////////////////////////////////
/////////////////////////////////////////////////
//// Prices
Prices.ini = buildPriceT( ini.pIC , ini.pFC, ini.w, ini.pL, ini.pK, ini.pY, ini.pM, ini.p, 1 , 1);
Prices.run = buildPriceT(  d.pIC , d.pFC, d.w, d.pL, d.pK, d.pY, d.pM, d.p, 1 , 1);
Prices.evoBY = buildPriceT( evol_BY.pIC-1 , evol_BY.pFC-1, evol_BY.w-1, evol_BY.pL-1, evol_BY.pK-1, evol_BY.pY-1, evol_BY.pM-1, evol_BY.p-1, 100 , 1);

if time_step ==1
	Prices.evo = Prices.evoBY ;

elseif time_step >1 

	Prices.evo = buildPriceT( evol.pIC-1 , evol.pFC-1, evol.w-1, evol.pL-1, evol.pK-1, evol.pY-1, evol.pM-1, evol.p-1, 100 , 1);
	if  Country== 'Argentina'
		Prices.evo15 = buildPriceT( evol_2015.pIC-1 , evol_2015.pFC-1, evol_2015.w-1, evol_2015.pL-1, evol_2015.pK-1, evol_2015.pY-1, evol_2015.pM-1, 	evol_2015.p-1, 100 , 1);
	end
end


/////////////////////////////////////////////////
// Technical Coefficient

TechCOef.ini = buildTechCoefT( ini.alpha, ini.lambda, ini.kappa, 1 , 1);
TechCOef.run = buildTechCoefT(  d.alpha, d.lambda, d.kappa, 1 , 1);
TechCOef.evoBY = buildTechCoefT( evol_BY.alpha-1, evol_BY.lambda-1, evol_BY.kappa-1, 100 , 1);

if time_step ==1
	TechCOef.evo = TechCOef.evoBY ;

elseif time_step >1 

	TechCOef.evo = buildTechCoefT( evol.alpha-1, evol.lambda-1, evol.kappa-1, 100 , 1);
	if Country== 'Argentina'
		TechCOef.evo15 = buildTechCoefT( evol_2015.alpha-1, evol_2015.lambda-1, evol_2015.kappa-1, 100 , 1);
	end
end



/////////////////////////////////////////////////
// Emissions table

CO2Emis.ini = buildEmisT( ini.CO2Emis_IC , ini.CO2Emis_C , ini.CO2Emis_X ,ini.CO2Emis_Sec,ini.Tot_CO2Emis_IC,ini.Tot_CO2Emis_C,ini.DOM_CO2,1 ,1);
CO2Emis.run = buildEmisT(   d.CO2Emis_IC ,  d.CO2Emis_C ,   d.CO2Emis_X ,d.CO2Emis_Sec,d.Tot_CO2Emis_IC,d.Tot_CO2Emis_C,d.DOM_CO2, 1 , 1);
CO2Emis.evoBY = buildEmisT( evol_BY.CO2Emis_IC-1 , evol_BY.CO2Emis_C-1, evol_BY.CO2Emis_X-1 , evol_BY.CO2Emis_Sec-1 ,evol_BY.Tot_CO2Emis_IC - 1,evol_BY.Tot_CO2Emis_C-1,evol_BY.DOM_CO2-1,100 , 1);

if time_step ==1
	CO2Emis.evo = CO2Emis.evoBY ;

elseif time_step >1 

	CO2Emis.evo = buildEmisT( evol.CO2Emis_IC-1 , evol.CO2Emis_C-1, evol.CO2Emis_X-1 , evol.CO2Emis_Sec-1 ,evol.Tot_CO2Emis_IC - 1,evol.Tot_CO2Emis_C-1,evol.DOM_CO2-1,100 , 1);
	if Country== 'Argentina'
		CO2Emis.evo15 = buildEmisT( evol_2015.CO2Emis_IC-1 , evol_2015.CO2Emis_C-1, evol_2015.CO2Emis_X-1 , evol_2015.CO2Emis_Sec-1 ,evol_2015.Tot_CO2Emis_IC - 1,evol_2015.Tot_CO2Emis_C-1,evol_2015.DOM_CO2-1,100 , 1);
	end
end


/////////////////////////////////////////////////
// IOT in value

io.ini = buildIot( ini.IC_value , ini.FC_value , ini.OthPart_IOT ,ini.Carbon_Tax, ini.Supply, ini.Uses,money_disp_adj , 1);
io.run = buildIot( d.IC_value ,   d.FC_value ,   d.OthPart_IOT ,d.Carbon_Tax ,d.Supply, d.Uses, money_disp_adj , 1);
io.evoBY = buildIot(evol_BY.IC_value-1 ,  evol_BY.FC_value-1 , evol_BY.OthPart_IOT-1 ,evol_BY.Carbon_Tax -1, evol_BY.Supply-1, evol_BY.Uses-1, 100 , 1);

if time_step ==1
	io.evo = io.evoBY ;

elseif time_step >1 

	io.evo = buildIot(evol.IC_value-1 ,  evol.FC_value-1 , evol.OthPart_IOT-1 ,evol.Carbon_Tax -1, evol.Supply-1, evol.Uses-1, 100 , 1);
	if Country== 'Argentina'
		io.evo15 = buildIot(evol_2015.IC_value-1 ,  evol_2015.FC_value-1 , evol_2015.OthPart_IOT-1 ,evol_2015.Carbon_Tax -1, evol_2015.Supply-1, evol_2015.Uses-1, 100 , 1);
	end
end


/////////////////////////////////////////////////
// IO in quantities table

ioQ.ini = buildIotQ( ini.IC , ini.FC , ini.OthQ , 1 , 1);
ioQ.run = buildIotQ(   d.IC ,   d.FC ,   d.OthQ , 1 , 1);
ioQ.evoBY = buildIotQ(   evol_BY.IC-1 ,   evol_BY.FC-1 ,   evol_BY.OthQ-1 , 100 , 1);

if time_step ==1
	ioQ.evo = ioQ.evoBY ;

elseif time_step >1 

	ioQ.evo = buildIotQ(   evol.IC-1 ,   evol.FC-1 ,   evol.OthQ-1 , 100 , 1);

		if Country== 'Argentina'
			ioQ.evo15 = buildIotQ(   evol_2015.IC-1 ,   evol_2015.FC-1 ,   evol_2015.OthQ-1 , 100 , 1);
		end
end


/////////////////////////////////////////////////
// Economic account table

ecoT.ini = buildEcoTabl(ini.Ecotable , money_disp_adj , 1);
ecoT.run = buildEcoTabl(d.Ecotable , money_disp_adj , 1);
ecoT.evoBY = buildEcoTabl(evol_BY.Ecotable-1 ,100 , 1);

if time_step ==1
	ecoT.evo = ecoT.evoBY ;

elseif time_step >1 
ecoT.evo = buildEcoTabl(evol.Ecotable-1 ,100 , 1);

	if Country== 'Argentina'
		ecoT.evo15 = buildEcoTabl(evol_2015.Ecotable-1 ,100 , 1);
	end
end

/////////////////////////////////////////////////
//Invesment Matrix
if Invest_matrix

InvestMat.ini = [["Invest Matrix in Vol",Index_Sectors'];[Index_Sectors,ini.I]];
InvestMat.run = [["Invest Matrix in Vol",Index_Sectors'];[Index_Sectors,d.I]];
InvestMat.evoBY = [["Invest Matrix in Vol",Index_Sectors'];[Index_Sectors,evol_BY.I]];

if time_step ==1
	InvestMat.evo = InvestMat.evoBY ;

elseif time_step >1 
InvestMat.evo = [["Invest Matrix in Vol",Index_Sectors'];[Index_Sectors,evol.I]];

	if Country== 'Argentina'
		InvestMat.evo15 = [["Invest Matrix in Vol",Index_Sectors'];[Index_Sectors,evol_2015.I]];
	end
end


end


///// SAVING IN CSV FILES ALL TABLES

if Output_files

	// Synthesis file of Emission to use as an input in CAP studies
	if time_step == 1
	SAVEDIR_Emis = OUTPUT +runName + filesep() + "EmisObj_" +Scenario + filesep();
    mkdir(SAVEDIR_Emis);
	end
	IOT_CO2Emis_Obj = [[["CO2_Emis in MtCO2",Index_Sectors'];[Index_Sectors,d.CO2Emis_IC]],["C";sum(d.CO2Emis_C,"c")];["MtCO2",zeros(1,nb_Sectors+1)]];
	csvWrite(IOT_CO2Emis_Obj,SAVEDIR_Emis+"IOT_CO2_EmisObj_"+ Scenario+"_"+time_step+".csv", ';');
	
	csvWrite(Prices.ini,SAVEDIR+"Prices-ini_"+Name_time+"_"+simu_name+".csv", ';');
	csvWrite(Prices.run,SAVEDIR+"Prices-run_"+Name_time+"_"+simu_name+".csv", ';');
	csvWrite(Prices.evoBY,SAVEDIR+"Prices-evo_BY_"+Name_time+"_"+simu_name+".csv", ';');
	
	csvWrite(TechCOef.ini,SAVEDIR+"TechCOef-ini_"+Name_time+"_"+simu_name+".csv", ';');
	csvWrite(TechCOef.run,SAVEDIR+"TechCOef-run_"+Name_time+"_"+simu_name+".csv", ';');
	csvWrite(TechCOef.evoBY,SAVEDIR+"TechCOef-evo_BY_"+Name_time+"_"+simu_name+".csv", ';');
	
	csvWrite(CO2Emis.ini,SAVEDIR+"CO2Emis-ini_"+Name_time+"_"+simu_name+".csv", ';');
	csvWrite(CO2Emis.run,SAVEDIR+"CO2Emis-run_"+Name_time+"_"+simu_name+".csv", ';');
	csvWrite(CO2Emis.evoBY,SAVEDIR+"CO2Emis-evo_BY_"+Name_time+"_"+simu_name+".csv", ';');
	
	csvWrite(io.ini,SAVEDIR+"ioV-ini_"+Name_time+"_"+simu_name+".csv", ';');
	csvWrite(io.run,SAVEDIR+"ioV-run_"+Name_time+"_"+simu_name+".csv", ';');
	csvWrite(io.evoBY,SAVEDIR+"ioV-evo_BY_"+Name_time+"_"+simu_name+".csv", ';');
	
	csvWrite(ioQ.ini,SAVEDIR+"ioQ-ini_"+Name_time+"_"+simu_name+".csv", ';');
	csvWrite(ioQ.run,SAVEDIR+"ioQ-run_"+Name_time+"_"+simu_name+".csv", ';');
	csvWrite(ioQ.evoBY,SAVEDIR+"ioQ-evo_BY_"+Name_time+"_"+simu_name+".csv", ';');
	
	csvWrite(ecoT.ini,SAVEDIR+"ecoT-ini_"+Name_time+"_"+simu_name+".csv", ';');
	csvWrite(ecoT.run,SAVEDIR+"ecoT-run_"+Name_time+"_"+simu_name+".csv", ';');
	csvWrite(ecoT.evoBY,SAVEDIR+"ecoT-evo_BY_"+Name_time+"_"+simu_name+".csv", ';');
	
	if Invest_matrix
		csvWrite(InvestMat.ini,SAVEDIR+"InvestMat-ini_"+Name_time+"_"+simu_name+".csv", ';');
		csvWrite(InvestMat.run,SAVEDIR+"InvestMat-run_"+Name_time+"_"+simu_name+".csv", ';');
		csvWrite(InvestMat.evoBY,SAVEDIR+"InvestMat-evo_BY_"+Name_time+"_"+simu_name+".csv", ';');
	end
	
	
			/// Comparison with the current year with the step before
			if time_step >1
				csvWrite(Prices.evo,SAVEDIR+"Prices-evo_"+YearBef+"_"+Name_time+"_"+simu_name+".csv", ';');
				csvWrite(TechCOef.evo,SAVEDIR+"TechCOef-evo_"+YearBef+"_"+Name_time+"_"+simu_name+".csv", ';');
				csvWrite(CO2Emis.evo,SAVEDIR+"CO2Emis-evo_"+YearBef+"_"+Name_time+"_"+simu_name+".csv", ';');
				csvWrite(io.evo,SAVEDIR+"ioV-evo_"+YearBef+"_"+Name_time+"_"+simu_name+".csv", ';');
				csvWrite(ioQ.evo,SAVEDIR+"ioQ-evo_"+YearBef+"_"+Name_time+"_"+simu_name+".csv", ';');
				csvWrite(ecoT.evo,SAVEDIR+"ecoT-evo_"+YearBef+"_"+Name_time+"_"+simu_name+".csv", ';');
				
						if Invest_matrix
							csvWrite(InvestMat.evo,SAVEDIR+"InvestMat-evo_"+YearBef+"_"+Name_time+"_"+simu_name+".csv", ';');
						end
				
					/// Comparison with 2015 for Argentina
					if Country== 'Argentina'
						csvWrite(Prices.evo15,SAVEDIR+"Prices-evo15_"+Name_time+"_"+simu_name+".csv", ';');
						csvWrite(TechCOef.evo15,SAVEDIR+"TechCOef-evo15_"+Name_time+"_"+simu_name+".csv", ';');
						csvWrite(CO2Emis.evo15,SAVEDIR+"CO2Emis-evo15_"+Name_time+"_"+simu_name+".csv", ';');
						csvWrite(io.evo15,SAVEDIR+"ioV-evo15_"+Name_time+"_"+simu_name+".csv", ';');
						csvWrite(ioQ.evo15,SAVEDIR+"ioQ-evo15_"+Name_time+"_"+simu_name+".csv", ';');
						csvWrite(ecoT.evo15,SAVEDIR+"ecoT-evo15_"+Name_time+"_"+simu_name+".csv", ';');
								if Invest_matrix
									csvWrite(InvestMat.evo15,SAVEDIR+"InvestMat-evo15_"+Name_time+"_"+simu_name+".csv", ';');
								end		
					end
			end
end

// to be used in outputs_indic
// if time_step== 1
// evol_BY = evol;
// end


// Affectation de toutes les valeurs finales aux noms de variables contenu dans la structure d. ( eviter des confusions entre une variable hors structure ; ini ou final)
execstr(fieldnames(d)+"= d." + fieldnames(d));

Err_balance_tol_temp = 10^-1;
IC_temp = (abs(IC) > 10^-5).*IC;
// Check after loading outputs
for line  = 1:nb_Commodities
    if abs(d.ERE_balance_val(line))>=Err_balance_tol_temp then
       error("The IOT output is not well balanced , something did not go well for the sector n°"+line+";Supply-Uses not balanced")
    end
	
	if d.pC(line) < 0
		error("The consumption price pC for the sector n°"+line+" is negative, the resolution went wrong")
	end
	
	if d.pY(line) < 0
		error("The consumption price pY for the sector n°"+line+" is negative, the resolution went wrong")
	end
	
	if d.pM(line) < 0
		error("The consumption price pM for the sector n°"+line+" is negative, the resolution went wrong")
	end
	
	for col= 1:nb_Commodities
		if pIC(line,col)<0
		error("The consumption price pIC of"+line+", "+col+" is negative, the resolution went wrong")
		end
	end
	
	for col= 1:nb_Commodities
		if IC_temp(line,col)<0
		error("The quantity IC of"+line+", "+col+" is negative, the resolution went wrong")
		end
	end
		
end

if u_tot<0 
error("The unemployment is negative, the resolution went wrong")
end
