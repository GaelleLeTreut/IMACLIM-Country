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

/////////////////////////////////////////////////////////////////////////////////////////////
//	STEP 4: CALIBRATION
/////////////////////////////////////////////////////////////////////////////////////////////


/////////////////////////////////////////////////////////////////////////////////////////
// Types of Imaclim objets (initial values, exogenous parameters, calibrated parameters)
//	defined in "loading data" : Index_Imaclim_VarCalib
/////////////////////////////////////////////////////////////////////////////////////////


////////////
// Initial values
///////////
//	list
[list_InitVal] = varTyp2list (Index_Imaclim_VarCalib, "InitVal");

NotDef_InitVal=EltList_IntoStruct(list_InitVal,initial_value);
// values (default value = 0)  for values which are not yet defined
if NotDef_InitVal <> ""
    initial_value = AddZerosValue2struct( Index_Imaclim_VarCalib, NotDef_InitVal, initial_value);
end



// ///////////
// // Parameters
// ///////////
// //	list
// [list_parameters] = varTyp2list (Index_Imaclim_VarCalib, "Param");
//
// NotDef_Params=EltList_IntoStruct(list_parameters,parameters);
// // values (default value = 0)  for values which are not yet defined
// if NotDef_Params <> ""
//     parameters = AddZerosValue2struct( Index_Imaclim_VarCalib, NotDef_Params, parameters);
// end


///////////
//	Calibrated parameters (set of variables for the system below - fsolve)
///////////
// list
[list_calib] = varTyp2list (Index_Imaclim_VarCalib, "calib");
// Initial values for variables
// Default value = 1)
[calib] = OnesValue4variables ( Index_Imaclim_VarCalib, list_calib);
// If some values are known in loaded intial_value, change 1 by the value and delete variable from initial_value structure
[initial_value,common_list]=CompStructDelete(initial_value,calib);
// Create X vector column for solver from all parameters to calibrate
//x_calib= variables2X (Index_Imaclim_VarCalib, list_calib, calib);

//List of calibrated parameters without "reference" paramaters
//[list_calib_WithRef] = RemoveRefVarFromList (list_calib);
///////////////////////////
// Comment Antoine : suppression des REF

// créaction des vecteurs x_ pour tous les paramètres à calibrer sauf les ref
//[Table_indiv_x2Exec] = variables2indiv_x (Index_Imaclim_VarCalib, list_calib_WithRef, "calib" );
[Table_indiv_x2Exec] = variables2indiv_x (Index_Imaclim_VarCalib, list_calib, "calib" );
for i= Table_indiv_x2Exec
    execstr(Table_indiv_x2Exec);
end

//////// Structure to simple variables in order to excecute intermediate calibration
// Initial Values
[Table_initial_value] = struct2Variables(initial_value,"initial_value");
for i= Table_initial_value
    execstr(Table_initial_value);
end
// Parameters
[Table_parameters] = struct2Variables(parameters,"parameters");
for i= Table_parameters
    execstr(Table_parameters);
end

// Calibrated parameters
[Table_calib] = struct2Variables(calib,"calib");
for i= Table_calib
    execstr(Table_calib);
end


//	Etape 1 du calibrage
//	Calcule des paramètres calibrés à partir de certaines équations de la librairy Imaclim
//	Rq : pour l'instant choix des équations à la main.
//	On pourrait envisager d'affecter une équation à un paramètre calibré dans le fichier .csv


//////////////////////////////////////////////
//////// "Intermediary" Calibration : calibration of simple variables
//////////////////////////////////////////////

sensib = 1D-4 ;
count = 0;
countMax = 5;
vBest = 10000000;
Null_Val = 10^-10;


function [const_Unemploy] =fcalib_Unemploy_Const_1(x_u_tot, Unemployed, Labour_force, Imaclim_VarCalib)
    u_tot= indiv_x2variable(Imaclim_VarCalib, "x_u_tot");
    const_Unemploy = Unemployment_Const_1(u_tot, Unemployed, Labour_force);
endfunction

[x_u_tot, const_Unemploy, info_calib_u_tot] = fsolve(x_u_tot, list(fcalib_Unemploy_Const_1, Unemployed, Labour_force, Index_Imaclim_VarCalib));

if norm(const_Unemploy) > sensib
    error( "review calib_u_tot")
else
    u_tot = indiv_x2variable (Index_Imaclim_VarCalib, "x_u_tot");
end

function [const_C] =fcalib_CExpend_Const_1(x_C, C_value, pC, Imaclim_VarCalib)
    C= indiv_x2variable(Imaclim_VarCalib, "x_C");
    const_C = ConsumExpend_Const_1(C_value, C, pC);
endfunction

[x_C, const_C, info_calib_C] = fsolve(x_C, list(fcalib_CExpend_Const_1, C_value, pC, Index_Imaclim_VarCalib));

if norm(const_C) > sensib
    error( "review calib_C")
else
    C = indiv_x2variable (Index_Imaclim_VarCalib, "x_C");
    C = (abs(C) > %eps).*C;
end

function [const_IC] =fcalib_IC_value_Const_1(x_IC, IC_value, pIC, Imaclim_VarCalib)
    IC= indiv_x2variable(Imaclim_VarCalib, "x_IC");
    const_IC = IC_value_Const_1(IC_value, IC,  pIC) ;
endfunction

[x_IC, const_IC, info_calib_IC] = fsolve(x_IC, list(fcalib_IC_value_Const_1, IC_value, pIC, Index_Imaclim_VarCalib));

if norm(const_IC) > sensib
    error( "review calib_IC")
else
    IC = indiv_x2variable (Index_Imaclim_VarCalib, "x_IC");
    IC = (abs(IC) > %eps).*IC;
end


function [const_Y] =fcalib_Y_value_Const_1(x_Y, Y_value, pY, Imaclim_VarCalib)
    Y= indiv_x2variable(Imaclim_VarCalib, "x_Y");
    const_Y = Y_value_Const_1(Y_value, Y, pY);
endfunction
[x_Y, const_Y, info_calib_Y] = fsolve(x_Y, list(fcalib_Y_value_Const_1, Y_value, pY, Index_Imaclim_VarCalib));

if norm(const_Y) > sensib
    error( "review calib_Y")
else
    Y = indiv_x2variable (Index_Imaclim_VarCalib, "x_Y");
    // Y = (Y_value'<>0&pY<>0).*Y;
end


function [const_M] =fcalib_M_value_Const_1(x_M, M_value, pM, Imaclim_VarCalib)
    M= indiv_x2variable(Imaclim_VarCalib, "x_M");
    const_M = M_value_Const_1(M_value, M, pM);
endfunction
[x_M, const_M, info_calib_M] = fsolve(x_M, list(fcalib_M_value_Const_1, M_value, pM, Index_Imaclim_VarCalib));

if norm(const_M) > sensib
    error( "review calib_M")
else
    M = indiv_x2variable (Index_Imaclim_VarCalib, "x_M");
    M(abs(M) < %eps) = %eps;
end


function [const_X] =fcalib_X_value_Const_1(x_X, X_value, pX, Imaclim_VarCalib)
    X= indiv_x2variable(Imaclim_VarCalib, "x_X");
    const_X = X_value_Const_1(X_value, X, pX);
endfunction
[x_X, const_X, info_calib_X] = fsolve(x_X, list(fcalib_X_value_Const_1, X_value, pX, Index_Imaclim_VarCalib));

if norm(const_X) > sensib
    error( "review calib_X")
else
    X = indiv_x2variable (Index_Imaclim_VarCalib, "x_X");
    X = (abs(X) > %eps).*X;
end


function [const_G] =fcalib_G_value_Const_1(x_G, G_value, pG, Imaclim_VarCalib)
    G= indiv_x2variable(Imaclim_VarCalib, "x_G");
    const_G = G_value_Const_1(G_value, G, pG);
endfunction
[x_G, const_G, info_calib_G] = fsolve(x_G, list(fcalib_G_value_Const_1, G_value, pG, Index_Imaclim_VarCalib));

if norm(const_G) > sensib
    error( "review calib_G")
else
    G = indiv_x2variable (Index_Imaclim_VarCalib, "x_G");
    G = (abs(G) > %eps).*G;
end

function [const_I] =fcalib_I_value_Const_1(x_I, I_value, pI, Imaclim_VarCalib)
    I= indiv_x2variable(Imaclim_VarCalib, "x_I");
    const_I = I_value_Const_1(I_value, I, pI);
endfunction
[x_I, const_I, info_calib_I] = fsolve(x_I, list(fcalib_I_value_Const_1, I_value, pI, Index_Imaclim_VarCalib));

if norm(const_I) > sensib
    error( "review calib_I")
else
    I = indiv_x2variable (Index_Imaclim_VarCalib, "x_I");
    I = (abs(I) > %eps).*I;
end

function [const_alpha] =fcalib_IC_Const_1(x_alpha, IC, Y, Imaclim_VarCalib)
    alpha= indiv_x2variable(Imaclim_VarCalib, "x_alpha");
    const_alpha = IC_Const_1(IC, Y, alpha);
    const_alpha =  matrix(const_alpha, nb_Commodities,nb_Sectors);

    //If IC= 0 => alpha = 0
    y1_1 = (IC==0).*(alpha) ;
    y1_2 = (IC<>0).*const_alpha;
    y1 = (IC==0).*y1_1 + (IC<>0).*y1_2;

    const_alpha = matrix(y1, nb_Commodities*nb_Sectors, 1);

endfunction

[x_alpha, const_alpha, info_calib_alpha] = fsolve(x_alpha, list(fcalib_IC_Const_1, IC, Y ,Index_Imaclim_VarCalib));

if norm(const_alpha) > sensib
    error( "review calib_alpha")
else
    // x_alpha = ApproxPositivNulVal(x_alpha, Null_Val,Null_Val);
    alpha = indiv_x2variable (Index_Imaclim_VarCalib, "x_alpha");
    alpha = (abs(alpha) > %eps).*alpha;
end

// function [const_p] =fcalib_Mprice_Const_1(x_p, pY, pM, Y, M, Imaclim_VarCalib)
    // p= indiv_x2variable(Imaclim_VarCalib, "x_p");
    // const_p = Mean_price_Const_1(pY, pM, Y, M, p);
// endfunction
// [x_p, const_p, info_calib_p] = fsolve(x_p, list(fcalib_Mprice_Const_1, pY, pM, Y, M, Index_Imaclim_VarCalib));

// if norm(const_p) > sensib
    // error( "review calib_p")
// else
    // p = indiv_x2variable (Index_Imaclim_VarCalib, "x_p");
    // p = (abs(p) > %eps).*p;
// end

 p = Mean_price_Const_1(pY, pM, Y, M, p);
 p = (abs(p) > %eps).*p;

function [const_interest_rate] =fcalib_PropTranf_Const_1(x_interest_rate, Property_income, NetFinancialDebt, Imaclim_VarCalib)
    interest_rate= indiv_x2variable(Imaclim_VarCalib, "x_interest_rate");
    const_interest_rate = [
    H_PropTranf_Const_1(Property_income, interest_rate, NetFinancialDebt)
    G_PropTranf_Const_1(Property_income, interest_rate, NetFinancialDebt)
    Corp_PropTranf_Const_1(Property_income, interest_rate, NetFinancialDebt)
    RoW_PropTranf_Const_1(Property_income, interest_rate, NetFinancialDebt)];
endfunction

[x_interest_rate, const_interest_rate, info_calib_interest_rate] = fsolve(x_interest_rate, list(fcalib_PropTranf_Const_1,Property_income, NetFinancialDebt, Index_Imaclim_VarCalib));

if norm(const_interest_rate) > sensib
    error("review calib_interest_rate")
else
    interest_rate = indiv_x2variable (Index_Imaclim_VarCalib, "x_interest_rate");
end

/////////////////////////////////////////////////////
// Start Difference between France (1) and Brasil (2)
/////////////////////////////////////////////////////
if Country=="Brasil" then
    function [const_H_DisposableIncome] =fcalib_H_Income_Const_2(x_H_disposable_income, NetCompWages_byAgent, GOS_byAgent, Gov_social_transfers, Corp_social_transfers, Other_Transfers, ClimPolicyCompens, Property_income, Income_Tax, Gov_Direct_Tax, Corp_Direct_Tax, Imaclim_VarCalib)
        H_disposable_income= indiv_x2variable(Imaclim_VarCalib, "x_H_disposable_income");
        const_H_DisposableIncome =H_Income_Const_2(H_disposable_income, NetCompWages_byAgent, GOS_byAgent, Gov_social_transfers, Corp_social_transfers, Other_Transfers, ClimPolicyCompens, Property_income, Income_Tax, Gov_Direct_Tax, Corp_Direct_Tax);
    endfunction
    const_H_DisposableIncome = 10^5;
    
    while norm(const_H_DisposableIncome) > sensib
        if  (count>=countMax)
            error("review calib_H_Disposoble_Income");
        end
        count = count + 1;
        [x_H_disposable_income, const_H_DisposableIncome, info_calib_H_DispoIncome] = fsolve(x_H_disposable_income, list(fcalib_H_Income_Const_2,NetCompWages_byAgent, GOS_byAgent, Gov_social_transfers, Corp_social_transfers, Other_Transfers, ClimPolicyCompens, Property_income, Income_Tax, Gov_Direct_Tax, Corp_Direct_Tax, Index_Imaclim_VarCalib));
        H_disposable_income = indiv_x2variable (Index_Imaclim_VarCalib, "x_H_disposable_income");
    end
    count=0;
else	
	function [const_H_DisposableIncome] =fcalib_H_Income_Const_1(x_H_disposable_income, NetCompWages_byAgent, GOS_byAgent, Pensions, Unemployment_transfers, Other_social_transfers, Other_Transfers, ClimPolicyCompens, Property_income, Income_Tax, Other_Direct_Tax, Imaclim_VarCalib)
    H_disposable_income= indiv_x2variable(Imaclim_VarCalib, "x_H_disposable_income");
    const_H_DisposableIncome =H_Income_Const_1(H_disposable_income, NetCompWages_byAgent, GOS_byAgent, Pensions, Unemployment_transfers, Other_social_transfers, Other_Transfers, ClimPolicyCompens, Property_income, Income_Tax, Other_Direct_Tax);
	endfunction
	const_H_DisposableIncome = 10^5;

	while norm(const_H_DisposableIncome) > sensib
    if  (count>=countMax)
        error("review calib_H_Disposoble_Income");
    end
    count = count + 1;
    [x_H_disposable_income, const_H_DisposableIncome, info_calib_H_DispoIncome] = fsolve(x_H_disposable_income, list(fcalib_H_Income_Const_1,NetCompWages_byAgent, GOS_byAgent, Pensions, Unemployment_transfers, Other_social_transfers, Other_Transfers, ClimPolicyCompens, Property_income, Income_Tax, Other_Direct_Tax, Index_Imaclim_VarCalib));
    H_disposable_income = indiv_x2variable (Index_Imaclim_VarCalib, "x_H_disposable_income");
	end
	count=0;
end

/////////////////////////////////////////////////////
// End Difference between France (1) and Brasil (2)
/////////////////////////////////////////////////////

function [const_u] =fcalib_HEmploym_Const_1(x_u, Unemployed, Labour_force, Imaclim_VarCalib)
    u= indiv_x2variable(Imaclim_VarCalib, "x_u");
    const_u = HH_Employment_Const_1(Unemployed, u, Labour_force);
endfunction
[x_u, const_u, info_calib_u] = fsolve(x_u, list(fcalib_HEmploym_Const_1,Unemployed, Labour_force, Index_Imaclim_VarCalib));

if norm(const_u) > sensib
    error( "review calib_u")
else
    u = indiv_x2variable (Index_Imaclim_VarCalib, "x_u");
end


///////////////////////////
// Start - Not applied for Brasil
///////////////////////////
if Country<>"Brasil" then
function [const_Pension_Benefits] =fcalib_Pensions_Const_1(x_Pension_Benefits,Pensions, Retired, Imaclim_VarCalib)
    Pension_Benefits= indiv_x2variable(Imaclim_VarCalib, "x_Pension_Benefits");
    const_Pension_Benefits = Pensions_Const_1(Pensions, Pension_Benefits, Retired);
endfunction

[x_Pension_Benefits, const_Pension_Benefits, info_calib_PensionBenef] = fsolve(x_Pension_Benefits, list(fcalib_Pensions_Const_1,Pensions, Retired, Index_Imaclim_VarCalib));

if norm(const_Pension_Benefits) > sensib
    error( "review calib_PensionBenef")
    [str,n,line,func]=lasterror(%f);
else
    Pension_Benefits = indiv_x2variable (Index_Imaclim_VarCalib, "x_Pension_Benefits");
end


function [const_UnemployBenefits] =fcalib_UnemplTr_Const_1(x_UnemployBenefits,Unemployment_transfers, Unemployed, Imaclim_VarCalib)
    UnemployBenefits= indiv_x2variable(Imaclim_VarCalib, "x_UnemployBenefits");
    const_UnemployBenefits = Unemploy_Transf_Const_1(Unemployment_transfers, UnemployBenefits, Unemployed);
endfunction
[x_UnemployBenefits, const_UnemployBenefits, info_calib_UnemployBenef] = fsolve(x_UnemployBenefits, list(fcalib_UnemplTr_Const_1,Unemployment_transfers, Unemployed, Index_Imaclim_VarCalib));

if norm(const_UnemployBenefits) > sensib
    error( "review calib_UnemployBenefits")
else
    UnemployBenefits = indiv_x2variable (Index_Imaclim_VarCalib, "x_UnemployBenefits");
end


end

///////////////////////////
// End - Not applied for Brasil
///////////////////////////

/////////////////////////////////////////////////////
// Start Difference between France (1) and Brasil (2)
/////////////////////////////////////////////////////

if Country=="Brasil" then
function [const_Gov_SocioBenef] =fcalib_GovSocioTrConst_1(x_Gov_SocioBenef, Gov_social_transfers, Population, Imaclim_VarCalib)
        Gov_SocioBenef= indiv_x2variable(Imaclim_VarCalib, "x_Gov_SocioBenef")
        const_Gov_SocioBenef= OtherSoc_Transf_Const_1(Gov_social_transfers, Gov_SocioBenef, Population)
    endfunction
    [x_Gov_SocioBenef, const_Gov_SocioBenef, info_calib_GovSocioBenef] = fsolve(x_Gov_SocioBenef, list(fcalib_GovSocioTrConst_1, Gov_social_transfers, Population, Index_Imaclim_VarCalib));

    if norm(const_Gov_SocioBenef) > sensib
        error( "review calib_Other_SocioBenef")
    else
        Gov_SocioBenef = indiv_x2variable (Index_Imaclim_VarCalib, "x_Gov_SocioBenef");
    end

    function [const_Corp_SocioBenef] =fcalib_CorSocioTrConst_1(x_Corp_SocioBenef, Corp_social_transfers, Population, Imaclim_VarCalib)
        Corp_SocioBenef= indiv_x2variable(Imaclim_VarCalib, "x_Corp_SocioBenef")
        const_Corp_SocioBenef= OtherSoc_Transf_Const_1(Corp_social_transfers, Corp_SocioBenef, Population)
    endfunction
    [x_Corp_SocioBenef, const_Corp_SocioBenef, info_calib_CorSocioBenef] = fsolve(x_Corp_SocioBenef, list(fcalib_CorSocioTrConst_1,Corp_social_transfers, Population, Index_Imaclim_VarCalib));

    if norm(const_Corp_SocioBenef) > sensib
        error( "review calib_Other_SocioBenef")
    else
        Corp_SocioBenef = indiv_x2variable (Index_Imaclim_VarCalib, "x_Corp_SocioBenef");
    end
	
else
	
function [const_Other_SocioBenef] =fcalib_OthSocioTrConst_1(x_Other_SocioBenef, Other_social_transfers, Population, Imaclim_VarCalib)
    Other_SocioBenef= indiv_x2variable(Imaclim_VarCalib, "x_Other_SocioBenef");
    const_Other_SocioBenef= OtherSoc_Transf_Const_1(Other_social_transfers, Other_SocioBenef, Population);
endfunction
[x_Other_SocioBenef, const_Other_SocioBenef, info_calib_OthSocioBenef] = fsolve(x_Other_SocioBenef, list(fcalib_OthSocioTrConst_1,Other_social_transfers, Population, Index_Imaclim_VarCalib));

if norm(const_Other_SocioBenef) > sensib
    error( "review calib_Other_SocioBenef")
else
    Other_SocioBenef = indiv_x2variable (Index_Imaclim_VarCalib, "x_Other_SocioBenef");
end
end
/////////////////////////////////////////////////////
// End Difference between France (1) and Brasil (2)
/////////////////////////////////////////////////////

function [const_Household_savings] =fcalib_HNetLend_Const_1(x_Household_savings, NetLending, GFCF_byAgent, Imaclim_VarCalib)
    Household_savings= indiv_x2variable(Imaclim_VarCalib, "x_Household_savings");
    const_Household_savings= H_NetLending_Const_1(NetLending, GFCF_byAgent, Household_savings);
endfunction

const_Household_savings = 10^5;
while norm(const_Household_savings) > sensib
    if  (count>=countMax)
        error("review calib Household_savings");
    end
    count = count + 1;
    [x_Household_savings, const_Household_savings, info_calib_HH_savings] = fsolve(x_Household_savings, list(fcalib_HNetLend_Const_1,NetLending, GFCF_byAgent, Index_Imaclim_VarCalib));
    Household_savings = indiv_x2variable (Index_Imaclim_VarCalib, "x_Household_savings");
end

count=0;

function [const_HH_saving_rate] =fcalib_H_Savings_Const_1(x_Household_saving_rate, Household_savings, H_disposable_income, Imaclim_VarCalib)
    Household_saving_rate= indiv_x2variable(Imaclim_VarCalib, "x_Household_saving_rate");
    const_HH_saving_rate= H_Savings_Const_1(Household_savings, H_disposable_income, Household_saving_rate);
endfunction
[x_Household_saving_rate, const_HH_saving_rate, info_calib_HHsaving_rate] = fsolve(x_Household_saving_rate, list(fcalib_H_Savings_Const_1,Household_savings, H_disposable_income, Index_Imaclim_VarCalib));

if norm(const_HH_saving_rate) > sensib
    error( "review calib_Household_saving_rate")
else
    Household_saving_rate = indiv_x2variable (Index_Imaclim_VarCalib, "x_Household_saving_rate");
end

function [const_HInvest_propensity] =fcalib_H_Invest_Const_1(x_H_Invest_propensity, GFCF_byAgent, H_disposable_income, Imaclim_VarCalib)
    H_Invest_propensity= indiv_x2variable(Imaclim_VarCalib, "x_H_Invest_propensity");
    const_HInvest_propensity=H_Investment_Const_1(GFCF_byAgent, H_disposable_income, H_Invest_propensity);
endfunction
[x_H_Invest_propensity, const_HInvest_propensity, info_calib_HInvestProp] = fsolve(x_H_Invest_propensity, list(fcalib_H_Invest_Const_1,GFCF_byAgent, H_disposable_income, Index_Imaclim_VarCalib));

if norm(const_HInvest_propensity) > sensib
    error( "review calib_H_Invest_propensity")
else
    H_Invest_propensity = indiv_x2variable (Index_Imaclim_VarCalib, "x_H_Invest_propensity");
end

function [const_Consumption_budget] =fc_ConsumBudget_Const_1(x_Consumption_budget,  H_disposable_income, Household_saving_rate, Imaclim_VarCalib)
    Consumption_budget= indiv_x2variable(Imaclim_VarCalib, "x_Consumption_budget");
    const_Consumption_budget=ConsumBudget_Const_1(Consumption_budget, H_disposable_income, Household_saving_rate)	;
endfunction

const_Consumption_budget = 10^5;
while norm(const_Consumption_budget) > sensib
    if  (count>=countMax)
        error("review calib_Consumption_budget")
    end
    count = count + 1;
    [x_Consumption_budget, const_Consumption_budget, info_calib_Consum_budget] = fsolve(x_Consumption_budget, list(fc_ConsumBudget_Const_1, H_disposable_income, Household_saving_rate, Index_Imaclim_VarCalib));
    Consumption_budget = indiv_x2variable (Index_Imaclim_VarCalib, "x_Consumption_budget");

end
count=0;

function [const_Budget_Shares] =fcalib_BudgShare_Const_1(x_Budget_Shares, Consumption_budget, C_value, Imaclim_VarCalib)
    Budget_Shares= indiv_x2variable(Imaclim_VarCalib, "x_Budget_Shares");
    const_Budget_Shares = BudgetShares_Const_1(Budget_Shares, Consumption_budget, C_value);
endfunction

const_Budget_Shares = 10^5;
while norm(const_Budget_Shares) > sensib
    if  (count>=countMax)
        error("review calib_Budget_Shares")
    end
    count = count + 1;
    [x_Budget_Shares, const_Budget_Shares, info_calib_Budget_Shares] = fsolve(x_Budget_Shares, list(fcalib_BudgShare_Const_1,Consumption_budget, C_value, Index_Imaclim_VarCalib));
    Budget_Shares = indiv_x2variable (Index_Imaclim_VarCalib, "x_Budget_Shares");
    Budget_Shares = (abs(Budget_Shares) > %eps).*Budget_Shares;

end
count=0;


function [const_TranspMarg_rate] =fcalib_TransMarg_Const_1(x_Transp_margins_rates, Transp_margins, p, alpha, Y, C, G, I, X, Imaclim_VarCalib)
    Transp_margins_rates= indiv_x2variable(Imaclim_VarCalib, "x_Transp_margins_rates");
    const_TranspMarg_rate=Transp_margins_Const_1(Transp_margins, Transp_margins_rates, p, alpha, Y, C, G, I, X)	;
endfunction
[x_Transp_margins_rates, const_TranspMarg_rate, info_calib_TranspMargRat] = fsolve(x_Transp_margins_rates, list(fcalib_TransMarg_Const_1,Transp_margins, p, alpha, Y, C, G, I, X, Index_Imaclim_VarCalib));

if norm(const_TranspMarg_rate) > sensib
    error( "review calib_Transp_margins_rates")
else
    Transp_margins_rates = indiv_x2variable (Index_Imaclim_VarCalib, "x_Transp_margins_rates");
    Transp_margins_rates = (abs(Transp_margins_rates) > %eps).*Transp_margins_rates;
end

function [const_TradeMarg_rate] =fcalib_TradeMarg_Const_1(x_Trade_margins_rates, Trade_margins, p, alpha, Y, C, G, I, X, Imaclim_VarCalib)
    Trade_margins_rates= indiv_x2variable(Imaclim_VarCalib, "x_Trade_margins_rates");
    const_TradeMarg_rate=Trade_margins_Const_1(Trade_margins, Trade_margins_rates, p, alpha, Y, C, G, I, X);
endfunction
[x_Trade_margins_rates, const_TradeMarg_rate, info_calib_TradeMargRat] = fsolve(x_Trade_margins_rates, list(fcalib_TradeMarg_Const_1,Trade_margins, p, alpha, Y, C, G, I, X, Index_Imaclim_VarCalib));

if norm(const_TradeMarg_rate) > sensib
    error( "review calib_Trade_margins_rates")
else
    Trade_margins_rates = indiv_x2variable (Index_Imaclim_VarCalib, "x_Trade_margins_rates");
    Trade_margins_rates = (abs(Trade_margins_rates) > %eps).*Trade_margins_rates;
end

function [const_Emission_Coef_IC] =fcalib_CO2_intensity_IC(x_Emission_Coef_IC,CO2Emis_IC, IC, Imaclim_VarCalib)
    Emission_Coef_IC= indiv_x2variable(Imaclim_VarCalib, "x_Emission_Coef_IC");

    const_Emission_Coef_IC=CO2_intensity_IC( CO2Emis_IC, Emission_Coef_IC , IC)
    const_Emission_Coef_IC=matrix(const_Emission_Coef_IC, nb_Commodities,nb_Sectors);

    // If CO2Emis_IC=0 => Emission_Coef_IC = 0
    y1_1= (CO2Emis_IC==0).*(Emission_Coef_IC);
    y1_2 = (CO2Emis_IC<>0).*const_Emission_Coef_IC;
    y1 = (CO2Emis_IC==0).*y1_1 + (CO2Emis_IC<>0).*y1_2;

    const_Emission_Coef_IC=matrix(y1, nb_Commodities*nb_Sectors,1);
endfunction

const_Emission_Coef_IC = 10^5;
while norm(const_Emission_Coef_IC) > sensib
    if  (count>=countMax)
        error("review calib_Emission_Coef_IC")
    end
    count = count + 1;
    [x_Emission_Coef_IC, const_Emission_Coef_IC, info_calib_Emiss_Coef_IC] = fsolve(x_Emission_Coef_IC, list(fcalib_CO2_intensity_IC,CO2Emis_IC, IC, Index_Imaclim_VarCalib));
    Emission_Coef_IC = indiv_x2variable (Index_Imaclim_VarCalib, "x_Emission_Coef_IC");
    Emission_Coef_IC = (abs(Emission_Coef_IC) > %eps).*Emission_Coef_IC;

end
count=0;



function [const_Emission_Coef_C] =fcalib_CO2_intensity_C(x_Emission_Coef_C,CO2Emis_C, C, Imaclim_VarCalib)
    Emission_Coef_C= indiv_x2variable(Imaclim_VarCalib, "x_Emission_Coef_C");

    const_Emission_Coef_C=CO2_intensity_C( CO2Emis_C, Emission_Coef_C , C);
    const_Emission_Coef_C=matrix(const_Emission_Coef_C, nb_Commodities,nb_Households);

    // If CO2Emis_C=0 => Emission_Coef_C = 0
    y1_1= (CO2Emis_C==0).*(Emission_Coef_C);
    y1_2 = (CO2Emis_C<>0).*(CO2Emis_C - Emission_Coef_C .* C );
    y1 = (CO2Emis_C==0).*y1_1 + (CO2Emis_C<>0).*y1_2;

    const_Emission_Coef_C=matrix(y1, nb_Commodities*nb_Households,1);

endfunction
[x_Emission_Coef_C, const_Emission_Coef_C, info_calib_Emiss_Coef_C] = fsolve(x_Emission_Coef_C, list(fcalib_CO2_intensity_C,CO2Emis_C, C, Index_Imaclim_VarCalib));

if norm(const_Emission_Coef_C) > sensib
    error( "review calib_Emission_Coef_C")
else
    Emission_Coef_C = indiv_x2variable (Index_Imaclim_VarCalib, "x_Emission_Coef_C");
    Emission_Coef_C = (abs(Emission_Coef_C) > %eps).*Emission_Coef_C;
end


// x_SpeMarg_rate = [x_SpeMarg_rates_IC;x_SpeMarg_rates_C;x_SpeMarg_rates_X;x_SpeMarg_rates_I];
 x_SpeMarg_rate = [x_SpeMarg_rates_IC;x_SpeMarg_rates_C;x_SpeMarg_rates_G; x_SpeMarg_rates_X;x_SpeMarg_rates_I];
function [const_SpeMarg_rate] =fcalib_SpeMarg_Const_1(x_SpeMarg_rate, SpeMarg_IC, SpeMarg_C, SpeMarg_G, SpeMarg_I, SpeMarg_X, p, alpha, Y, C, G, I, X, Imaclim_VarCalib)

    x_SpeMarg_rates_IC = x_SpeMarg_rate (1: nb_Sectors*nb_Commodities);
    x_SpeMarg_rates_C = x_SpeMarg_rate (nb_Sectors*nb_Commodities+1 : nb_Sectors*nb_Commodities + nb_Households*nb_Commodities);
	x_SpeMarg_rates_G = x_SpeMarg_rate (nb_Sectors*nb_Commodities + nb_Households*nb_Commodities+1 : nb_Sectors*nb_Commodities + nb_Households*nb_Commodities + nb_Commodities);
    x_SpeMarg_rates_I = x_SpeMarg_rate (nb_Sectors*nb_Commodities+ nb_Households*nb_Commodities + nb_Commodities+1 : nb_Sectors*nb_Commodities+ nb_Households*nb_Commodities+ nb_Commodities+nb_Commodities);
    x_SpeMarg_rates_X = x_SpeMarg_rate (nb_Sectors*nb_Commodities+ nb_Households*nb_Commodities+ nb_Commodities+nb_Commodities+1:nb_Sectors*nb_Commodities+ nb_Households*nb_Commodities+ nb_Commodities+nb_Commodities+nb_Commodities);

    SpeMarg_rates_IC= indiv_x2variable(Imaclim_VarCalib, "x_SpeMarg_rates_IC");
    SpeMarg_rates_C= indiv_x2variable(Imaclim_VarCalib, "x_SpeMarg_rates_C");
    SpeMarg_rates_G= indiv_x2variable(Imaclim_VarCalib, "x_SpeMarg_rates_G");
    SpeMarg_rates_I= indiv_x2variable(Imaclim_VarCalib, "x_SpeMarg_rates_I");
    SpeMarg_rates_X= indiv_x2variable(Imaclim_VarCalib, "x_SpeMarg_rates_X");


    // const_SpeMarg_rate=SpeMarg_Const_1(SpeMarg_IC, SpeMarg_rates_IC, SpeMarg_C, SpeMarg_rates_C, SpeMarg_X, SpeMarg_rates_X,SpeMarg_I, SpeMarg_rates_I, p, alpha, Y, C, X);
	
	const_SpeMarg_rate= SpeMarg_Const_2(SpeMarg_IC, SpeMarg_rates_IC, SpeMarg_C, SpeMarg_rates_C, SpeMarg_G, SpeMarg_rates_G, SpeMarg_I, SpeMarg_rates_I,SpeMarg_X, SpeMarg_rates_X, p, alpha, Y, C, G, I, X);
	
endfunction

[x_SpeMarg_rate, const_SpeMarg_rate, info_calib_SpeMarg_rate] = fsolve(x_SpeMarg_rate, list(fcalib_SpeMarg_Const_1,initial_value.SpeMarg_IC, initial_value.SpeMarg_C, initial_value.SpeMarg_G, initial_value.SpeMarg_I, initial_value.SpeMarg_X, p, alpha, Y, C, G, I, X, Index_Imaclim_VarCalib));

if norm(const_SpeMarg_rate) > sensib
    error( "review calib_SpeMarg_rate")
else
    x_SpeMarg_rates_IC = x_SpeMarg_rate (1: nb_Sectors*nb_Commodities);
    x_SpeMarg_rates_C = x_SpeMarg_rate (nb_Sectors*nb_Commodities+1 : nb_Sectors*nb_Commodities + nb_Households*nb_Commodities);
    x_SpeMarg_rates_G = x_SpeMarg_rate (nb_Sectors*nb_Commodities + nb_Households*nb_Commodities+1 : nb_Sectors*nb_Commodities + nb_Households*nb_Commodities + nb_Commodities);
    x_SpeMarg_rates_I = x_SpeMarg_rate (nb_Sectors*nb_Commodities+ nb_Households*nb_Commodities + nb_Commodities+1 : nb_Sectors*nb_Commodities+ nb_Households*nb_Commodities+ nb_Commodities+nb_Commodities);
    x_SpeMarg_rates_X = x_SpeMarg_rate (nb_Sectors*nb_Commodities+ nb_Households*nb_Commodities+ nb_Commodities+nb_Commodities+1:nb_Sectors*nb_Commodities+ nb_Households*nb_Commodities+ nb_Commodities+nb_Commodities+nb_Commodities);

    SpeMarg_rates_IC= indiv_x2variable(Index_Imaclim_VarCalib, "x_SpeMarg_rates_IC");
    SpeMarg_rates_C= indiv_x2variable(Index_Imaclim_VarCalib, "x_SpeMarg_rates_C");
    SpeMarg_rates_G= indiv_x2variable(Index_Imaclim_VarCalib, "x_SpeMarg_rates_G");
    SpeMarg_rates_I= indiv_x2variable(Index_Imaclim_VarCalib, "x_SpeMarg_rates_I");
    SpeMarg_rates_X= indiv_x2variable(Index_Imaclim_VarCalib, "x_SpeMarg_rates_X");

    SpeMarg_rates_IC = (abs(SpeMarg_rates_IC) > %eps).*SpeMarg_rates_IC;
    SpeMarg_rates_C = (abs(SpeMarg_rates_C) > %eps).*SpeMarg_rates_C;
    SpeMarg_rates_G = (abs(SpeMarg_rates_G) > %eps).*SpeMarg_rates_G;
    SpeMarg_rates_I = (abs(SpeMarg_rates_I) > %eps).*SpeMarg_rates_I;
    SpeMarg_rates_X = (abs(SpeMarg_rates_X) > %eps).*SpeMarg_rates_X;


end

function [const_Energy_Tax_rate_IC] =fcalib_EnerTaxIC_Const_1(x_Energy_Tax_rate_IC, Energy_Tax_IC, alpha, Y, Imaclim_VarCalib)
    Energy_Tax_rate_IC= indiv_x2variable(Imaclim_VarCalib, "x_Energy_Tax_rate_IC");
    const_Energy_Tax_rate_IC = Energy_Tax_IC_Const_1(Energy_Tax_IC, Energy_Tax_rate_IC, alpha, Y)
endfunction
[x_Energy_Tax_rate_IC, const_Energy_Tax_rate_IC, info_calib_EnerTaxRateIC] = fsolve(x_Energy_Tax_rate_IC, list(fcalib_EnerTaxIC_Const_1, Energy_Tax_IC, alpha, Y, Index_Imaclim_VarCalib));

if norm(const_Energy_Tax_rate_IC) > sensib
    error( "review calib_Energy_Tax_rate_IC")
else
    Energy_Tax_rate_IC = indiv_x2variable (Index_Imaclim_VarCalib, "x_Energy_Tax_rate_IC");
    Energy_Tax_rate_IC = (abs(Energy_Tax_rate_IC) > %eps).*Energy_Tax_rate_IC;

end


function [const_Energy_Tax_rate_FC] =fcalib_EnerTaxC_Const_1(x_Energy_Tax_rate_FC, Energy_Tax_FC, C, Imaclim_VarCalib)
    Energy_Tax_rate_FC= indiv_x2variable(Imaclim_VarCalib, "x_Energy_Tax_rate_FC");
    // const_Energy_Tax_rate_FC = Energy_Tax_FC_Const_1(Energy_Tax_FC, Energy_Tax_rate_FC, C);

    y_1= (sum(C,"c")==0).*(Energy_Tax_rate_FC');
    y_2 = (sum(C,"c")<>0).*Energy_Tax_FC_Const_1(Energy_Tax_FC, Energy_Tax_rate_FC, C);
    const_Energy_Tax_rate_FC = y_1 + y_2;

endfunction

[x_Energy_Tax_rate_FC, const_Energy_Tax_rate_FC, info_calib_EnerTaxRateC] = fsolve(x_Energy_Tax_rate_FC, list(fcalib_EnerTaxC_Const_1, Energy_Tax_FC, C, Index_Imaclim_VarCalib));

if norm(const_Energy_Tax_rate_FC) > sensib
    error( "review calib_Energy_Tax_rate_FC")
else
    Energy_Tax_rate_FC = indiv_x2variable (Index_Imaclim_VarCalib, "x_Energy_Tax_rate_FC");
    Energy_Tax_rate_FC = (abs(Energy_Tax_rate_FC) > %eps).*Energy_Tax_rate_FC;
end

function [const_Carbon_Tax_rate_C] =fcalibCarbonTaxC_Const_1(x_Carbon_Tax_rate_C, Carbon_Tax_C, C,Emission_Coef_C, Imaclim_VarCalib)
    Carbon_Tax_rate_C= indiv_x2variable(Imaclim_VarCalib, "x_Carbon_Tax_rate_C");

    const_Carbon_Tax_rate_C = Carbon_Tax_C_Const_1(Carbon_Tax_C, Carbon_Tax_rate_C, C, Emission_Coef_C)
    const_Carbon_Tax_rate_C =  matrix(const_Carbon_Tax_rate_C, nb_Commodities,nb_Households);


    //if  Emission_Coef_IC = 0 => Carbon_Tax_rate_IC = 0
    y1_1 = (Emission_Coef_C==0).*(Carbon_Tax_rate_C);
    y1_2 =(Emission_Coef_C<>0).*const_Carbon_Tax_rate_C;

    y1 = (Emission_Coef_C==0).*y1_1 + (Emission_Coef_C<>0).*y1_2 ;

    const_Carbon_Tax_rate_C = matrix(y1, nb_Commodities*nb_Households, 1);

endfunction

[x_Carbon_Tax_rate_C, const_Carbon_Tax_rate_C, info_calib_CarbTaxRateC] = fsolve(x_Carbon_Tax_rate_C, list(fcalibCarbonTaxC_Const_1, Carbon_Tax_C, C, Emission_Coef_C, Index_Imaclim_VarCalib));

if norm(const_Carbon_Tax_rate_C) > sensib
    error( "review calib_Carbon_Tax_rate_C")
else
    Carbon_Tax_rate_C = indiv_x2variable (Index_Imaclim_VarCalib, "x_Carbon_Tax_rate_C");
    Carbon_Tax_rate_C = (abs(Carbon_Tax_rate_C) > %eps).*Carbon_Tax_rate_C;
end

function [const_Carbon_Tax_rate_IC] =fcalibCarbTaxIC_Const_1(x_Carbon_Tax_rate_IC, Carbon_Tax_IC, alpha, Y,Emission_Coef_IC, Imaclim_VarCalib)

    Carbon_Tax_rate_IC= indiv_x2variable(Imaclim_VarCalib, "x_Carbon_Tax_rate_IC");
    const_Carbon_Tax_rate_IC = Carbon_Tax_IC_Const_1(Carbon_Tax_IC, Carbon_Tax_rate_IC , alpha, Y, Emission_Coef_IC);

    const_Carbon_Tax_rate_IC =  matrix(const_Carbon_Tax_rate_IC, nb_Commodities,nb_Sectors);

    //if  Emission_Coef_IC = 0 => Carbon_Tax_rate_IC = 0
    y1_1 = (Emission_Coef_IC==0).*(Carbon_Tax_rate_IC);
    y1_2 =(Emission_Coef_IC<>0).*const_Carbon_Tax_rate_IC;

    y1 = (Emission_Coef_IC==0).*y1_1 + (Emission_Coef_IC<>0).*y1_2 ;

    const_Carbon_Tax_rate_IC = matrix(y1, nb_Commodities*nb_Sectors, 1);

endfunction


[x_Carbon_Tax_rate_IC, const_Carbon_Tax_rate_IC, info_calib_CarbTaxRateIC] = fsolve(x_Carbon_Tax_rate_IC, list(fcalibCarbTaxIC_Const_1, Carbon_Tax_IC, alpha, Y, Emission_Coef_IC, Index_Imaclim_VarCalib));

if norm(const_Carbon_Tax_rate_IC) > sensib
else
    Carbon_Tax_rate_IC = indiv_x2variable (Index_Imaclim_VarCalib, "x_Carbon_Tax_rate_IC");
    Carbon_Tax_rate_IC = (abs(Carbon_Tax_rate_IC) > %eps).*Carbon_Tax_rate_IC;
end


function [const_OtherIndirTax_rate] =fcalib_OthIndTax_Const_1(x_OtherIndirTax_rate, OtherIndirTax,alpha, Y, C, G, I, Imaclim_VarCalib)
    OtherIndirTax_rate= indiv_x2variable(Imaclim_VarCalib, "x_OtherIndirTax_rate");
    const_OtherIndirTax_rate = OtherIndirTax_Const_1(OtherIndirTax, OtherIndirTax_rate, alpha, Y, C, G, I)
endfunction
[x_OtherIndirTax_rate, const_OtherIndirTax_rate, info_calibOthIndirTaxRat] = fsolve(x_OtherIndirTax_rate, list(fcalib_OthIndTax_Const_1,OtherIndirTax,alpha, Y, C, G, I,Index_Imaclim_VarCalib));

if norm(const_OtherIndirTax_rate) > sensib
    error( "review calib_OtherIndirTax_rate")
else
    OtherIndirTax_rate = indiv_x2variable (Index_Imaclim_VarCalib, "x_OtherIndirTax_rate");
    OtherIndirTax_rate = (abs(OtherIndirTax_rate) > %eps).*OtherIndirTax_rate;
end

// if Country=="France" & AGG_type=="AGG_SNBC2"

	// VA_Tax_rate = VA_Tax./(sum( pC .* C, "c")' + sum(pG .* G, "c")' + (pI .* I)'-VA_Tax);	warning("Antoine : le calcul de VA_Tax ne fonctionne pas avec AGG_SNBC2... Utilisation du calcul direct au lieu d''une résolution")
// else

function [const_VA_Tax_rate] =fcalib_VA_Tax_Const_1(x_VA_Tax_rate, VA_Tax, pC, C, pG, G, pI, I, Imaclim_VarCalib)
    VA_Tax_rate= indiv_x2variable(Imaclim_VarCalib, "x_VA_Tax_rate");
    // const_VA_Tax_rate = VA_Tax_Const_1(VA_Tax, VA_Tax_rate, pC, C, pG, G, pI, I)

    y_1 = (VA_Tax' ==0).*VA_Tax_rate';
    y_2 = (VA_Tax' <>0).*VA_Tax_Const_1(VA_Tax, abs(VA_Tax_rate), pC, C, pG, G, pI, I);
    const_VA_Tax_rate =(VA_Tax' ==0).*y_1 +  (VA_Tax' <>0).*y_2;

endfunction

const_VA_Tax_rate = 10^5;
while norm(const_VA_Tax_rate) > sensib
    if  (count>=countMax)
        error("review calib_VA_Tax_rate")
    end
    count = count + 1;
    [x_VA_Tax_rate, const_VA_Tax_rate, info_calib_VA_Tax_rate] = fsolve(x_VA_Tax_rate, list(fcalib_VA_Tax_Const_1,VA_Tax, pC, C, pG, G, pI,I,Index_Imaclim_VarCalib));
    VA_Tax_rate = abs(indiv_x2variable (Index_Imaclim_VarCalib, "x_VA_Tax_rate"));
    VA_Tax_rate = (abs(VA_Tax_rate) > %eps).*VA_Tax_rate;

end
count=0;
// end

///////////////////////////
// Start Specific to Brasil
///////////////////////////
if Country=="Brasil" then
    function [const_Cons_Tax_rate] =fcalib_Cons_Tax_Const_1(x_Cons_Tax_rate, Cons_Tax, pIC, IC, pC, C, pG, G, pI, I, Imaclim_VarCalib)
        Cons_Tax_rate= indiv_x2variable(Imaclim_VarCalib, "x_Cons_Tax_rate");
    
        y_1 = (Cons_Tax' ==0).*Cons_Tax_rate';
        y_2 = (Cons_Tax' <>0).*Cons_Tax_Const_1(Cons_Tax, Cons_Tax_rate, pIC, IC, pC, C, pG, G, pI, I);
        const_Cons_Tax_rate =(Cons_Tax' ==0).*y_1 +  (Cons_Tax' <>0).*y_2;
    
    endfunction
    
    const_Cons_Tax_rate = 10^5;
    while norm(const_Cons_Tax_rate) > sensib
        if  (count>=countMax)
            error("review calib_Cons_Tax_rate")
        end
        count = count + 1;
        [x_Cons_Tax_rate, const_Cons_Tax_rate, info_calib_Cons_Tax_rate] = fsolve(x_Cons_Tax_rate, list(fcalib_Cons_Tax_Const_1, Cons_Tax, pIC, IC, pC, C, pG, G, pI,I,Index_Imaclim_VarCalib));
        Cons_Tax_rate = indiv_x2variable (Index_Imaclim_VarCalib, "x_Cons_Tax_rate");
        Cons_Tax_rate = (abs(Cons_Tax_rate) > %eps).*Cons_Tax_rate;
    
    end
    count=0;
end
///////////////////////////
// End Specific to Brasil
///////////////////////////


/// Calibrage des différentes marges spécifiques à partir des équations de prix pC pX pIC , pIC pG
// Une fois calibré on peut recalibrer les marges spécifiques (et supprimer le calibrage des taux des marges spé calculé antérieureemnt en ligne 471

// function [const_SpeMarg_rates_C] =fcalib_pC_price_Const_1(x_SpeMarg_rates_C, pC, Transp_margins_rates, Trade_margins_rates, Energy_Tax_rate_FC, OtherIndirTax_rate, Carbon_Tax_rate_C, Emission_Coef_C, p, VA_Tax_rate, Imaclim_VarCalib)
// SpeMarg_rates_C= indiv_x2variable(Imaclim_VarCalib, 'x_SpeMarg_rates_C');
// const_SpeMarg_rates_C = pC_price_Const_1(pC, Transp_margins_rates, Trade_margins_rates, SpeMarg_rates_C, Energy_Tax_rate_FC, OtherIndirTax_rate, Carbon_Tax_rate_C, Emission_Coef_C, p, VA_Tax_rate)
// endfunction

// const_SpeMarg_rates_C = 10^5;
// while norm(const_SpeMarg_rates_C) > sensib
// if  (count>=countMax)
// error("review calib_SpeMarg_rates_C")
// end
// count = count + 1;
// [x_SpeMarg_rates_C, const_SpeMarg_rates_C, infoCal_SpeMarg_rates_C] = fsolve(x_SpeMarg_rates_C, list(fcalib_pC_price_Const_1,pC, Transp_margins_rates, Trade_margins_rates, Energy_Tax_rate_FC, OtherIndirTax_rate, Carbon_Tax_rate_C, Emission_Coef_C, p, VA_Tax_rate,Index_Imaclim_VarCalib));
// x_SpeMarg_rates_C = ApproxNulVal(x_SpeMarg_rates_C, Null_Val ,Null_Val);
// SpeMarg_rates_C= indiv_x2variable (Index_Imaclim_VarCalib, 'x_SpeMarg_rates_C');
// end
// count=0;


// function [const_SpeMarg_rates_IC] =fcal_pIC_price_Const_1(x_SpeMarg_rates_IC, pIC, Transp_margins_rates, Trade_margins_rates, Energy_Tax_rate_IC, OtherIndirTax_rate, Carbon_Tax_rate_IC, Emission_Coef_IC, p, Imaclim_VarCalib)
// SpeMarg_rates_IC = indiv_x2variable(Imaclim_VarCalib, 'x_SpeMarg_rates_IC');
// const_SpeMarg_rates_IC = pIC_price_Const_1(pIC, Transp_margins_rates, Trade_margins_rates, SpeMarg_rates_IC, Energy_Tax_rate_IC, OtherIndirTax_rate, Carbon_Tax_rate_IC, Emission_Coef_IC, p)
// endfunction

// const_SpeMarg_rates_IC = 10^5;
// while norm(const_SpeMarg_rates_IC) > sensib
// if  (count>=countMax)
// error("review calib_SpeMarg_rates_IC")
// end
// count = count + 1;
// [x_SpeMarg_rates_IC, const_SpeMarg_rates_IC, infoCal_SpeMarg_rate_IC] = fsolve(x_SpeMarg_rates_IC, list(fcal_pIC_price_Const_1,pIC, Transp_margins_rates, Trade_margins_rates, Energy_Tax_rate_IC, OtherIndirTax_rate, Carbon_Tax_rate_IC, Emission_Coef_IC, p,Index_Imaclim_VarCalib));
// x_SpeMarg_rates_IC = ApproxNulVal(x_SpeMarg_rates_IC, Null_Val ,Null_Val);
// SpeMarg_rates_IC = indiv_x2variable (Index_Imaclim_VarCalib, 'x_SpeMarg_rates_IC');
// end
// count=0;

// function [const_SpeMarg_rates_X] =fcal_pX_price_Const_1(x_SpeMarg_rates_X, pX, Transp_margins_rates, Trade_margins_rates, p, Imaclim_VarCalib)
// SpeMarg_rates_X = indiv_x2variable(Imaclim_VarCalib, 'x_SpeMarg_rates_X');
// const_SpeMarg_rates_X =pX_price_Const_1(pX, Transp_margins_rates, Trade_margins_rates, SpeMarg_rates_X, p)
// endfunction

// const_SpeMarg_rates_X = 10^5;
// while norm(const_SpeMarg_rates_X) > sensib
// if  (count>=countMax)
// error("review calib_SpeMarg_rates_X")
// end
// count = count + 1;
// [x_SpeMarg_rates_X, const_SpeMarg_rates_X, infoCal_SpeMarg_rate_X] = fsolve(x_SpeMarg_rates_X, list(fcal_pX_price_Const_1,pX, Transp_margins_rates, Trade_margins_rates, p,Index_Imaclim_VarCalib));
// x_SpeMarg_rates_X = ApproxNulVal(x_SpeMarg_rates_X, Null_Val ,Null_Val);
// SpeMarg_rates_X = indiv_x2variable (Index_Imaclim_VarCalib, 'x_SpeMarg_rates_X');
// end
// count=0;


// function [const_SpeMarg_rates_I] =fcal_pI_price_Const_1(x_SpeMarg_rates_I, pI, Transp_margins_rates, Trade_margins_rates,OtherIndirTax_rate,Energy_Tax_rate_FC, p, VA_Tax_rate, Imaclim_VarCalib)
// SpeMarg_rates_I = indiv_x2variable(Imaclim_VarCalib, 'x_SpeMarg_rates_I');
// const_SpeMarg_rates_I =pI_price_Const_1(pI, Transp_margins_rates, Trade_margins_rates,SpeMarg_rates_I,OtherIndirTax_rate,Energy_Tax_rate_FC,  p, VA_Tax_rate)
// endfunction

// const_SpeMarg_rates_I = 10^5;
// while norm(const_SpeMarg_rates_I) > sensib
// if  (count>=countMax)
// error("review calib_SpeMarg_rates_I")
// end
// count = count + 1;

// [x_SpeMarg_rates_I, const_SpeMarg_rates_I, infoCal_SpeMarg_rate_I] = fsolve(x_SpeMarg_rates_I, list(fcal_pI_price_Const_1, pI, Transp_margins_rates, Trade_margins_rates,OtherIndirTax_rate,Energy_Tax_rate_FC, p, VA_Tax_rate, Index_Imaclim_VarCalib));

// x_SpeMarg_rates_I = ApproxNulVal(x_SpeMarg_rates_I, Null_Val ,Null_Val);
// SpeMarg_rates_I= indiv_x2variable (Index_Imaclim_VarCalib, 'x_SpeMarg_rates_I');
// end
// count=0;


// x_SpeMarg = [x_SpeMarg_IC;x_SpeMarg_C;x_SpeMarg_X;x_SpeMarg_I];
// function [const_SpeMarg] =fcalib_SpeMarg_Const_1(x_SpeMarg, SpeMarg_rates_IC, SpeMarg_rates_C,SpeMarg_rates_X, SpeMarg_rates_I, p, alpha, Y, C, X, Imaclim_VarCalib)

// x_SpeMarg_IC = x_SpeMarg (1: nb_Sectors*nb_Commodities);
// x_SpeMarg_C = x_SpeMarg(nb_Sectors*nb_Commodities+1 : nb_Sectors*nb_Commodities + nb_Households*nb_Commodities);
// x_SpeMarg_X = x_SpeMarg(nb_Sectors*nb_Commodities + nb_Households*nb_Commodities+1 : nb_Sectors*nb_Commodities + nb_Households*nb_Commodities + nb_Commodities);
// x_SpeMarg_I = x_SpeMarg(nb_Sectors*nb_Commodities+ nb_Households*nb_Commodities + nb_Commodities+1 : nb_Sectors*nb_Commodities+ nb_Households*nb_Commodities+ nb_Commodities+nb_Commodities);

// SpeMarg_IC= indiv_x2variable(Imaclim_VarCalib, 'x_SpeMarg_IC');
// SpeMarg_C= indiv_x2variable(Imaclim_VarCalib, 'x_SpeMarg_C');
// SpeMarg_X= indiv_x2variable(Imaclim_VarCalib, 'x_SpeMarg_X');
// SpeMarg_I= indiv_x2variable(Imaclim_VarCalib, 'x_SpeMarg_I');

// const_SpeMarg=SpeMarg_Const_1(SpeMarg_IC, SpeMarg_rates_IC, SpeMarg_C, SpeMarg_rates_C, SpeMarg_X, SpeMarg_rates_X,SpeMarg_I, SpeMarg_rates_I, p, alpha, Y, C, X);
// endfunction

// const_SpeMarg = 10^5;
// while norm(const_SpeMarg) > sensib
// if  (count>=countMax)
// error("review calib_SpeMarg")
// end
// count = count + 1;
// [x_SpeMarg, const_SpeMarg, info_calib_SpeMarg] = fsolve(x_SpeMarg, list(fcalib_SpeMarg_Const_1,SpeMarg_rates_IC, SpeMarg_rates_C,SpeMarg_rates_X, SpeMarg_rates_I, p, alpha, Y, C, X, Index_Imaclim_VarCalib));

// x_SpeMarg = ApproxNulVal(x_SpeMarg, Null_Val ,Null_Val);

// x_SpeMarg_IC = x_SpeMarg (1: nb_Sectors*nb_Commodities);
// x_SpeMarg_C = x_SpeMarg(nb_Sectors*nb_Commodities+1 : nb_Sectors*nb_Commodities + nb_Households*nb_Commodities);
// x_SpeMarg_X = x_SpeMarg(nb_Sectors*nb_Commodities + nb_Households*nb_Commodities+1 : nb_Sectors*nb_Commodities + nb_Households*nb_Commodities + nb_Commodities);
// x_SpeMarg_I = x_SpeMarg(nb_Sectors*nb_Commodities+ nb_Households*nb_Commodities + nb_Commodities+1 : nb_Sectors*nb_Commodities+ nb_Households*nb_Commodities+ nb_Commodities+nb_Commodities);

// SpeMarg_IC= indiv_x2variable(Index_Imaclim_VarCalib, 'x_SpeMarg_IC');
// SpeMarg_C= indiv_x2variable(Index_Imaclim_VarCalib, 'x_SpeMarg_C');
// SpeMarg_X= indiv_x2variable(Index_Imaclim_VarCalib, 'x_SpeMarg_X');
// SpeMarg_I= indiv_x2variable(Index_Imaclim_VarCalib, 'x_SpeMarg_I');

// end
// count=0;

/////////////////////////////////////////////////////
// Start Difference between France (1) and Brasil (2)
/////////////////////////////////////////////////////

if Country=="Brasil" then
    function [const_CorpDispoIncome] =fcalib_CorpIncom_Const_2(x_Corp_disposable_income, GOS_byAgent, Labour_Corp_Tax, Corp_Direct_Tax, Corp_social_transfers, Other_Transfers, Property_income, Corporate_Tax, Imaclim_VarCalib)
        Corp_disposable_income= indiv_x2variable(Imaclim_VarCalib, "x_Corp_disposable_income");
        const_CorpDispoIncome = Corp_income_Const_2(Corp_disposable_income, GOS_byAgent, Labour_Corp_Tax, Corp_Direct_Tax, Corp_social_transfers, Other_Transfers, Property_income , Corporate_Tax)
    endfunction
    
    const_CorpDispoIncome = 10^5;
    while norm(const_CorpDispoIncome) > sensib
        if  (count>=countMax)
            error("review calib_Corporations_savings")
        end
        count = count + 1;
        [x_Corp_disposable_income, const_CorpDispoIncome, info_CorpDispoIncome] = fsolve(x_Corp_disposable_income, list(fcalib_CorpIncom_Const_2,GOS_byAgent, Labour_Corp_Tax, Corp_Direct_Tax, Corp_social_transfers, Other_Transfers,Property_income, Corporate_Tax, Index_Imaclim_VarCalib));
        Corp_disposable_income = indiv_x2variable (Index_Imaclim_VarCalib, "x_Corp_disposable_income");
    end
    count=0;
else	

function [const_CorpDispoIncome] =fcalib_CorpIncom_Const_1(x_Corp_disposable_income, GOS_byAgent, Other_Transfers, Property_income, Corporate_Tax, Imaclim_VarCalib)
    Corp_disposable_income= indiv_x2variable(Imaclim_VarCalib, "x_Corp_disposable_income");
    const_CorpDispoIncome = Corp_income_Const_1(Corp_disposable_income, GOS_byAgent, Other_Transfers, Property_income , Corporate_Tax) 
endfunction

const_CorpDispoIncome = 10^5;
while norm(const_CorpDispoIncome) > sensib
    if  (count>=countMax)
        error("review calib_Corporations_savings")
    end
    count = count + 1;
    [x_Corp_disposable_income, const_CorpDispoIncome, info_CorpDispoIncome] = fsolve(x_Corp_disposable_income, list(fcalib_CorpIncom_Const_1,GOS_byAgent, Other_Transfers,Property_income, Corporate_Tax, Index_Imaclim_VarCalib));
    Corp_disposable_income = indiv_x2variable (Index_Imaclim_VarCalib, "x_Corp_disposable_income");
end
count=0;
end
/////////////////////////////////////////////////////
// End Difference between France (1) and Brasil (2)
/////////////////////////////////////////////////////

function [const_Corp_savings] =fcalibCorpSaving_Const_1(x_Corporations_savings, Corp_disposable_income, Imaclim_VarCalib)
    Corporations_savings= indiv_x2variable(Imaclim_VarCalib, "x_Corporations_savings");
    const_Corp_savings = Corp_savings_Const_1(Corporations_savings, Corp_disposable_income)
endfunction

const_Corp_savings = 10^5;
while norm(const_Corp_savings) > sensib
    if  (count>=countMax)
        error("review calib_Corporations_savings")
    end
    [x_Corporations_savings, const_Corp_savings, info_Corp_savings] = fsolve(x_Corporations_savings, list(fcalibCorpSaving_Const_1,Corp_disposable_income,Index_Imaclim_VarCalib));
    Corporations_savings = indiv_x2variable (Index_Imaclim_VarCalib, "x_Corporations_savings");

end
count=0;


function [const_CorpInvestProp] =fcalibCorpInvest_Const_1(x_Corp_invest_propensity, GFCF_byAgent, Corp_disposable_income,Imaclim_VarCalib)
    Corp_invest_propensity= indiv_x2variable(Imaclim_VarCalib, "x_Corp_invest_propensity");
    const_CorpInvestProp =  Corp_investment_Const_1(GFCF_byAgent, Corp_disposable_income, Corp_invest_propensity)
endfunction
[x_Corp_invest_propensity, const_CorpInvestProp, info_calibOthIndirTaxRat] = fsolve(x_Corp_invest_propensity, list(fcalibCorpInvest_Const_1, GFCF_byAgent, Corp_disposable_income,Index_Imaclim_VarCalib));

if norm(const_CorpInvestProp) > sensib
    error( "review calib_Corp_invest_propensity")
else
    Corp_invest_propensity = indiv_x2variable (Index_Imaclim_VarCalib, "x_Corp_invest_propensity");
end

///////////////////////////
// Start Difference between France (1) and Brasil (2)
///////////////////////////
if Country=="Brasil" then
    function [const_Income_Tax_rate] =fcalibIncome_Tax_Const_1(x_Income_Tax_rate, Income_Tax,  H_disposable_income, Gov_Direct_Tax, Corp_Direct_Tax, Imaclim_VarCalib)
        Income_Tax_rate= indiv_x2variable(Imaclim_VarCalib, "x_Income_Tax_rate");
        const_Income_Tax_rate =  Income_Tax_Const_2(Income_Tax, Income_Tax_rate, H_disposable_income, Gov_Direct_Tax, Corp_Direct_Tax)
    endfunction
    [x_Income_Tax_rate, const_Income_Tax_rate, info_calibOthIndirTaxRat] = fsolve(x_Income_Tax_rate, list(fcalibIncome_Tax_Const_1, Income_Tax,  H_disposable_income, Gov_Direct_Tax, Corp_Direct_Tax ,Index_Imaclim_VarCalib));
    
    if norm(const_Income_Tax_rate) > sensib
        error( "review calib_Income_Tax_rate")
    else
        Income_Tax_rate = indiv_x2variable (Index_Imaclim_VarCalib, "x_Income_Tax_rate");
    end
else

function [const_Income_Tax_rate] =fcalibIncome_Tax_Const_1(x_Income_Tax_rate, Income_Tax,  H_disposable_income, Other_Direct_Tax, Imaclim_VarCalib)
    Income_Tax_rate= indiv_x2variable(Imaclim_VarCalib, "x_Income_Tax_rate");
    const_Income_Tax_rate =  Income_Tax_Const_1(Income_Tax, Income_Tax_rate, H_disposable_income, Other_Direct_Tax)
endfunction
[x_Income_Tax_rate, const_Income_Tax_rate, info_calibOthIndirTaxRat] = fsolve(x_Income_Tax_rate, list(fcalibIncome_Tax_Const_1, Income_Tax,  H_disposable_income, Other_Direct_Tax,Index_Imaclim_VarCalib));

if norm(const_Income_Tax_rate) > sensib
    error( "review calib_Income_Tax_rate")
else
    Income_Tax_rate = indiv_x2variable (Index_Imaclim_VarCalib, "x_Income_Tax_rate");
end

end

///////////////////////////
// End Difference between France (1) and Brasil (2)
///////////////////////////

function [const_Corporate_Tax_rate] =fcalib_Corp_Tax_Const_1(x_Corporate_Tax_rate, Corporate_Tax, GOS_byAgent, Imaclim_VarCalib)
    Corporate_Tax_rate= indiv_x2variable(Imaclim_VarCalib, "x_Corporate_Tax_rate");
    const_Corporate_Tax_rate =  Corporate_Tax_Const_1(Corporate_Tax, Corporate_Tax_rate, GOS_byAgent)
endfunction
[x_Corporate_Tax_rate, const_Corporate_Tax_rate, info_Corporate_Tax_rate] = fsolve(x_Corporate_Tax_rate, list(fcalib_Corp_Tax_Const_1, Corporate_Tax, GOS_byAgent,Index_Imaclim_VarCalib));

if norm(const_Corporate_Tax_rate) > sensib
    error( "review calib_Corporate_Tax_rate")
else
    Corporate_Tax_rate = indiv_x2variable (Index_Imaclim_VarCalib, "x_Corporate_Tax_rate");
    Corporate_Tax_rate = (abs(Corporate_Tax_rate) > %eps).*Corporate_Tax_rate;
end

function [const_Prod_Tax_rate] =fcalib_Prod_Tax_Const_1(x_Production_Tax_rate, Production_Tax, pY, Y, Imaclim_VarCalib)
    Production_Tax_rate= indiv_x2variable(Imaclim_VarCalib, "x_Production_Tax_rate");
    // const_Prod_Tax_rate =  Production_Tax_Const_1(Production_Tax, Production_Tax_rate, pY, Y)

    //if Y=0 Production_tax_rate =0
    y1_1 = (Y==0).*(Production_Tax_rate');
    y1_2 = (Y<>0).*Production_Tax_Const_1(Production_Tax, Production_Tax_rate, pY, Y);
    const_Prod_Tax_rate	= (Y==0).*y1_1  + (Y<>0).*y1_2;
endfunction

[x_Production_Tax_rate, const_Prod_Tax_rate, info_Production_Tax_rate] = fsolve(x_Production_Tax_rate, list(fcalib_Prod_Tax_Const_1, Production_Tax, pY, Y,Index_Imaclim_VarCalib));

if norm(const_Prod_Tax_rate) > sensib
    error( "review calib_Production_Tax_rate")
else
    Production_Tax_rate = indiv_x2variable (Index_Imaclim_VarCalib, "x_Production_Tax_rate");
    Production_Tax_rate = (abs(Production_Tax_rate) > %eps).*Production_Tax_rate;
end

function [const_w] =fcalib_LabourInc_Const_1(x_w, Labour_income, Labour, Imaclim_VarCalib)
    w= indiv_x2variable(Imaclim_VarCalib, "x_w");

    // const_w =  Labour_income_Const_1(Labour_income, Labour, w)

    y1_1 = (Labour'==0).*(w');
    y1_2 = (Labour'<>0).*Labour_income_Const_1(Labour_income, Labour, w);
    const_w	= (Labour'==0).*y1_1  + (Labour'<>0).*y1_2;

endfunction

[x_w, const_w, info_calib_w] = fsolve(x_w, list(fcalib_LabourInc_Const_1, Labour_income, Labour,Index_Imaclim_VarCalib));

if norm(const_w) > sensib
    error( "review calib_w")
else
    w = indiv_x2variable (Index_Imaclim_VarCalib, "x_w");
    w = (abs(w) > %eps).*w;
end


function [const_lambda] =fcalib_Employmt_Const_1(x_lambda, Labour, Y, Imaclim_VarCalib)
    lambda= indiv_x2variable(Imaclim_VarCalib, "x_lambda");
    // const_lambda =  Employment_Const_1(Labour, lambda, Y)

    y1_1 = (Labour'==0).*(lambda');
    y1_2 = (Labour'<>0).*Employment_Const_1(Labour, lambda, Y);
    const_lambda	= (Labour'==0).*y1_1  + (Labour'<>0).*y1_2;
endfunction

[x_lambda, const_lambda, info_calib_lambda] = fsolve(x_lambda, list(fcalib_Employmt_Const_1, Labour, Y, Index_Imaclim_VarCalib));

if norm(const_lambda) > sensib
    error( "review calib_lambda")
else
    lambda = indiv_x2variable (Index_Imaclim_VarCalib, "x_lambda");
    lambda = (abs(lambda) > %eps).*lambda;
end

function [const_G_Consum_budget] =fcal_G_BudgBal_Const_1(x_G_Consumption_budget,  G, pG, Imaclim_VarCalib)
    G_Consumption_budget= indiv_x2variable(Imaclim_VarCalib, "x_G_Consumption_budget");
    const_G_Consum_budget =  G_BudgetBalance_Const_1(G_Consumption_budget, G, pG);
endfunction

const_G_Consum_budget = 10^5;
while norm(const_G_Consum_budget) > sensib
    if  (count>=countMax)
        error("review calib_G_Consumption_budget")
    end
    count = count + 1;
    [x_G_Consumption_budget, const_G_Consum_budget, info_calib_G_ConsBudget] = fsolve(x_G_Consumption_budget, list(fcal_G_BudgBal_Const_1,  G, pG, Index_Imaclim_VarCalib));
    G_Consumption_budget = indiv_x2variable (Index_Imaclim_VarCalib, "x_G_Consumption_budget");
end
count=0;

/////////////////////////////////////////////////////
// Start Difference between France (1) and Brasil (2)
/////////////////////////////////////////////////////
if Country=="Brasil" then
        function [const_G_dispo_income] =fcal_G_income_Const_2(x_G_disposable_income, Income_Tax, Gov_Direct_Tax, Corporate_Tax, Production_Tax, Labour_Tax, Energy_Tax_IC, Energy_Tax_FC, OtherIndirTax, Cons_Tax, Carbon_Tax_IC, Carbon_Tax_C, GOS_byAgent, Gov_social_transfers, Other_Transfers, Property_income, ClimPolicyCompens, ClimPolCompensbySect, Imaclim_VarCalib)
    
        G_disposable_income= indiv_x2variable(Imaclim_VarCalib, "x_G_disposable_income");
    
        const_G_dispo_income = G_income_Const_2(G_disposable_income, Income_Tax, Gov_Direct_Tax, Corporate_Tax, Production_Tax, Labour_Tax, Energy_Tax_IC, Energy_Tax_FC, OtherIndirTax, Cons_Tax, Carbon_Tax_IC, Carbon_Tax_C, GOS_byAgent, Gov_social_transfers, Other_Transfers, Property_income, ClimPolicyCompens, ClimPolCompensbySect);
    
    endfunction
    
    const_G_dispo_income = 10^5;
    while norm(const_G_dispo_income) > sensib 
        if  (count>=countMax)
            error("review calib_G_disposable_income")
        end
        count = count + 1;
        [x_G_disposable_income, const_G_dispo_income, info_calib_G_dispoIncome] = fsolve(x_G_disposable_income, list(fcal_G_income_Const_2, Income_Tax, Gov_Direct_Tax, Corporate_Tax, Production_Tax, Labour_Tax, Energy_Tax_IC, Energy_Tax_FC, OtherIndirTax, Cons_Tax, Carbon_Tax_IC, Carbon_Tax_C, GOS_byAgent, Gov_social_transfers, Other_Transfers, Property_income, ClimPolicyCompens, ClimPolCompensbySect, Index_Imaclim_VarCalib));
        G_disposable_income= indiv_x2variable(Index_Imaclim_VarCalib, "x_G_disposable_income");
    end
    count=0;
else
function [const_G_dispo_income] =fcal_G_income_Const_1(x_G_disposable_income, Income_Tax, Other_Direct_Tax, Corporate_Tax, Production_Tax, Labour_Tax, Energy_Tax_IC, Energy_Tax_FC, OtherIndirTax, VA_Tax, Carbon_Tax_IC, Carbon_Tax_C, GOS_byAgent, Pensions, Unemployment_transfers, Other_social_transfers, Other_Transfers, Property_income, ClimPolicyCompens, ClimPolCompensbySect, Imaclim_VarCalib)

    G_disposable_income= indiv_x2variable(Imaclim_VarCalib, "x_G_disposable_income");

    const_G_dispo_income = G_income_Const_1(G_disposable_income, Income_Tax, Other_Direct_Tax, Corporate_Tax, Production_Tax, Labour_Tax, Energy_Tax_IC, Energy_Tax_FC, OtherIndirTax, VA_Tax, Carbon_Tax_IC, Carbon_Tax_C, GOS_byAgent, Pensions, Unemployment_transfers, Other_social_transfers, Other_Transfers, Property_income , ClimPolicyCompens, ClimPolCompensbySect);

endfunction

const_G_dispo_income = 10^5;
while norm(const_G_dispo_income) > sensib 
    if  (count>=countMax)
        error("review calib_G_disposable_income")
    end
    count = count + 1;
    [x_G_disposable_income, const_G_dispo_income, info_calib_G_dispoIncome] = fsolve(x_G_disposable_income, list(fcal_G_income_Const_1,  Income_Tax, Other_Direct_Tax, Corporate_Tax, Production_Tax, Labour_Tax, Energy_Tax_IC, Energy_Tax_FC, OtherIndirTax, VA_Tax, Carbon_Tax_IC, Carbon_Tax_C, GOS_byAgent, Pensions, Unemployment_transfers, Other_social_transfers, Other_Transfers, Property_income, ClimPolicyCompens, ClimPolCompensbySect, Index_Imaclim_VarCalib));
    G_disposable_income= indiv_x2variable(Index_Imaclim_VarCalib, "x_G_disposable_income");
end
count=0;
end
/////////////////////////////////////////////////////
// End Difference between France (1) and Brasil (2)
/////////////////////////////////////////////////////

function [const_Gov_savings] =fcalibGovSaving_Const_1(x_Government_savings, G_disposable_income,G_Consumption_budget , Imaclim_VarCalib)
    Government_savings= indiv_x2variable(Imaclim_VarCalib, "x_Government_savings");
    const_Gov_savings = G_savings_Const_1(Government_savings, G_disposable_income, G_Consumption_budget)
endfunction

const_Gov_savings = 10^5;
while norm(const_Gov_savings) > sensib
    if  (count>=countMax)
        error("review calib_Government_savings")
    end
    count = count + 1;
    [x_Government_savings, const_Gov_savings, info_Gov_savings] = fsolve(x_Government_savings, list(fcalibGovSaving_Const_1,G_disposable_income,G_Consumption_budget ,Index_Imaclim_VarCalib));
    Government_savings = indiv_x2variable (Index_Imaclim_VarCalib, "x_Government_savings");

end
count=0;

warning(" Manu : modification of calibration.sce when we substitute some equations - G_demand_Const_2 and calibration of BudgetShare_GConsump")

function [const_BudgShare_GConsump] =fcalib_G_demand_Const_1(x_BudgetShare_GConsump, G, pG, G_Consumption_budget, Imaclim_VarCalib)
    BudgetShare_GConsump= indiv_x2variable(Imaclim_VarCalib, "x_BudgetShare_GConsump");
    const_BudgShare_GConsump =  G_demand_Const_2(G, pG, G_Consumption_budget, BudgetShare_GConsump);
endfunction
[x_BudgetShare_GConsump, const_BudgShare_GConsump, info_cal_BudgShare_GCons] = fsolve(x_BudgetShare_GConsump, list(fcalib_G_demand_Const_1, G, pG, G_Consumption_budget, Index_Imaclim_VarCalib));

if norm(const_BudgShare_GConsump) > sensib
    error( "review calib_BudgetShare_GConsump")
else
    BudgetShare_GConsump = indiv_x2variable (Index_Imaclim_VarCalib, "x_BudgetShare_GConsump");
    BudgetShare_GConsump = (abs(BudgetShare_GConsump) > %eps).*BudgetShare_GConsump;
end


function [const_G_investPropens] =fcalib_G_invest_Const_1(x_G_invest_propensity, GFCF_byAgent, G_disposable_income,GDP, Imaclim_VarCalib)
    G_invest_propensity= indiv_x2variable(Imaclim_VarCalib, "x_G_invest_propensity");
    const_G_investPropens =  G_investment_Const_1(GFCF_byAgent, G_disposable_income, G_invest_propensity, GDP)	;
endfunction

[x_G_invest_propensity, const_G_investPropens, info_cal_G_investPropens] = fsolve(x_G_invest_propensity, list(fcalib_G_invest_Const_1, GFCF_byAgent, G_disposable_income, GDP, Index_Imaclim_VarCalib));

if norm(const_G_investPropens) > sensib
    error( "review calib_G_invest_propensity")
else
    G_invest_propensity = indiv_x2variable (Index_Imaclim_VarCalib, "x_G_invest_propensity");
end

function [const_GOS] =fcalib_GOS_Const_1(x_GrossOpSurplus, Capital_income, Profit_margin, Trade_margins, Transp_margins, SpeMarg_rates_IC, SpeMarg_rates_C, SpeMarg_rates_X, SpeMarg_rates_I, p, alpha, Y, C, X, Imaclim_VarCalib)
    GrossOpSurplus= indiv_x2variable(Imaclim_VarCalib, "x_GrossOpSurplus");
    const_GOS = GrossOpSurplus_Const_1(GrossOpSurplus, Capital_income, Profit_margin, Trade_margins, Transp_margins,  SpeMarg_rates_IC, SpeMarg_rates_C, SpeMarg_rates_X, SpeMarg_rates_I, p, alpha, Y, C, X);
endfunction

const_GOS = 10^5;
while norm(const_GOS) > sensib
    if  (count>=countMax)
        error("review calib_Gross_Operating_Surplus")
    end
    count = count + 1;
    [x_GrossOpSurplus, const_GOS, info_cal_GOS] = fsolve(x_GrossOpSurplus, list(fcalib_GOS_Const_1,  Capital_income, Profit_margin, Trade_margins, Transp_margins,SpeMarg_rates_IC, SpeMarg_rates_C, SpeMarg_rates_X, SpeMarg_rates_I, p, alpha, Y, C, X, Index_Imaclim_VarCalib));

    GrossOpSurplus = indiv_x2variable (Index_Imaclim_VarCalib, "x_GrossOpSurplus");
    GrossOpSurplus = (abs(GrossOpSurplus) > %eps).*GrossOpSurplus;
end
count=0;


function [const_Labour_Tax_rate] =fcal_Labour_Tax_Const_1(x_Labour_Tax_rate, Labour_Tax, w, lambda, Y, Imaclim_VarCalib)
    Labour_Tax_rate= indiv_x2variable(Imaclim_VarCalib, "x_Labour_Tax_rate");
    // const_Labour_Tax_rate =  Labour_Tax_Const_1(Labour_Tax, Labour_Tax_rate, w, lambda, Y)

    //if Y=0 Production_tax_rate =0
    y1_1 = (Y==0).*(Labour_Tax_rate');
    y1_2 = (Y<>0).*Labour_Tax_Const_1(Labour_Tax, Labour_Tax_rate, w, lambda, Y);
    const_Labour_Tax_rate	= (Y==0).*y1_1  + (Y<>0).*y1_2;


endfunction

[x_Labour_Tax_rate, const_Labour_Tax_rate, info_cal_Labour_TaxRate] = fsolve(x_Labour_Tax_rate, list(fcal_Labour_Tax_Const_1, Labour_Tax, w, lambda, Y, Index_Imaclim_VarCalib));

if norm(const_Labour_Tax_rate) > sensib
    error( "review calib_Labour_Tax_rate")
else
    Labour_Tax_rate = indiv_x2variable (Index_Imaclim_VarCalib, "x_Labour_Tax_rate");
    Labour_Tax_rate = (abs(Labour_Tax_rate) > %eps).*Labour_Tax_rate;
end

///////////////////////////
// Start Specific to Brasil
///////////////////////////
if Country=="Brasil" then
    function [const_Labor_Cor_Tax_rate] =fcal_Labour_Tax_Const_2(x_Labour_Corp_Tax_rate, Labour_Corp_Tax, w, lambda, Y, Imaclim_VarCalib)
        Labour_Corp_Tax_rate= indiv_x2variable(Imaclim_VarCalib, "x_Labour_Corp_Tax_rate");
    
        y1_1 = (Y==0).*(Labour_Corp_Tax_rate');
        y1_2 = (Y<>0).*Labour_Tax_Const_1(Labour_Corp_Tax, Labour_Corp_Tax_rate, w, lambda, Y);
        const_Labor_Cor_Tax_rate	= (Y==0).*y1_1  + (Y<>0).*y1_2;
    endfunction
    
    [x_Labour_Corp_Tax_rate, const_Labor_Cor_Tax_rate, info_cal_LaborCorTaxRate] = fsolve(x_Labour_Corp_Tax_rate, list(fcal_Labour_Tax_Const_2, Labour_Corp_Tax, w, lambda, Y, Index_Imaclim_VarCalib));
    
    if norm(const_Labour_Tax_rate) > sensib
        error( "review calib_Labour_Tax_rate")
    else
        Labour_Corp_Tax_rate = indiv_x2variable (Index_Imaclim_VarCalib, "x_Labour_Corp_Tax_rate");
        Labour_Corp_Tax_rate = (abs(Labour_Corp_Tax_rate) > %eps).*Labour_Corp_Tax_rate;
    end
end
///////////////////////////
// End Specific to Brasil
///////////////////////////

/////////////////////////////////////////////////////
// Start Difference between France (1) and Brasil (2)
/////////////////////////////////////////////////////
if Country=="Brasil" then
    function [const_GDP] =fcal_GDP_Const_1(x_GDP, Labour_income, GrossOpSurplus, Production_Tax, Labour_Tax, Labour_Corp_Tax, OtherIndirTax, Cons_Tax, Energy_Tax_IC, Energy_Tax_FC, Carbon_Tax_IC, Carbon_Tax_C, Imaclim_VarCalib)
        GDP= indiv_x2variable(Imaclim_VarCalib, "x_GDP");
        const_GDP =  GDP_Const_2(GDP, Labour_income, GrossOpSurplus, Production_Tax, Labour_Tax, Labour_Corp_Tax, OtherIndirTax, Cons_Tax, Energy_Tax_IC, Energy_Tax_FC, Carbon_Tax_IC, Carbon_Tax_C);
    endfunction

    const_GDP = 10^5;
    while norm(const_GDP) > sensib
        if  (count>=countMax)
            error("review calib_GDP")
        end
        count = count + 1;
        [x_GDP, const_GDP, info_cal_GDP] = fsolve(x_GDP, list(fcal_GDP_Const_1, Labour_income, GrossOpSurplus, Production_Tax, Labour_Tax, Labour_Corp_Tax, OtherIndirTax, Cons_Tax, Energy_Tax_IC, Energy_Tax_FC, Carbon_Tax_IC, Carbon_Tax_C, Index_Imaclim_VarCalib));
        GDP = indiv_x2variable (Index_Imaclim_VarCalib, "x_GDP");
    
    end
    count=0;
else

function [const_GDP] =fcal_GDP_Const_1(x_GDP, Labour_income, GrossOpSurplus, Production_Tax, Labour_Tax, OtherIndirTax, VA_Tax, Energy_Tax_IC, Energy_Tax_FC, Carbon_Tax_IC, Carbon_Tax_C, Imaclim_VarCalib)
    GDP= indiv_x2variable(Imaclim_VarCalib, "x_GDP");
    const_GDP =  GDP_Const_1(GDP, Labour_income, GrossOpSurplus, Production_Tax, Labour_Tax, OtherIndirTax, VA_Tax, Energy_Tax_IC, Energy_Tax_FC, Carbon_Tax_IC, Carbon_Tax_C);

endfunction

const_GDP = 10^5;
while norm(const_GDP) > sensib
    if  (count>=countMax)
        error("review calib_GDP")
    end
    count = count + 1;
    [x_GDP, const_GDP, info_cal_GDP] = fsolve(x_GDP, list(fcal_GDP_Const_1, Labour_income, GrossOpSurplus, Production_Tax, Labour_Tax, OtherIndirTax, VA_Tax, Energy_Tax_IC, Energy_Tax_FC, Carbon_Tax_IC, Carbon_Tax_C, Index_Imaclim_VarCalib));
    GDP = indiv_x2variable (Index_Imaclim_VarCalib, "x_GDP");

end
count=0;
end

/////////////////////////////////////////////////////
// End Difference between France (1) and Brasil (2)
/////////////////////////////////////////////////////

function [const_pK] =fcal_CapitalCost_Const_1(x_pK, pI, I, Imaclim_VarCalib)
    pK= indiv_x2variable(Imaclim_VarCalib, "x_pK");
    const_pK =  Capital_Cost_Const_1(pK, pI, I)
endfunction

[x_pK, const_pK, info_cal_pK] = fsolve(x_pK, list(fcal_CapitalCost_Const_1,  pI, I, Index_Imaclim_VarCalib));

if norm(const_pK) > sensib
    error( "review calib_pK")
else
    pK = indiv_x2variable (Index_Imaclim_VarCalib, "x_pK");
end


function [const_LabourByWorkerCoef] =fcal_LabByWorker_Const_1(x_LabourByWorker_coef, u_tot, Labour_force, lambda, Y, Imaclim_VarCalib)
    LabourByWorker_coef= indiv_x2variable(Imaclim_VarCalib, "x_LabourByWorker_coef");
    const_LabourByWorkerCoef =  LabourByWorker_Const_1(LabourByWorker_coef, u_tot, Labour_force, lambda, Y)
endfunction

[x_LabourByWorker_coef, const_LabourByWorkerCoef, info_cal_LabByWorkerCoef] = fsolve(x_LabourByWorker_coef, list(fcal_LabByWorker_Const_1,  u_tot, Labour_force, lambda, Y, Index_Imaclim_VarCalib));

if norm(const_LabourByWorkerCoef) > sensib
    error( "review calib_LabourByWorker_coef")
else
    LabourByWorker_coef = indiv_x2variable (Index_Imaclim_VarCalib, "x_LabourByWorker_coef");
end


function [const_pL] =fcal_Labour_Cost_Const_1(x_pL, w, Labour_Tax_rate, Imaclim_VarCalib)
    pL= indiv_x2variable(Imaclim_VarCalib, "x_pL");
    const_pL =  Labour_Cost_Const_1(pL, w, Labour_Tax_rate)
endfunction

/////////////////////////////////////////////////////
// Start Difference between France (1) and Brasil (2)
/////////////////////////////////////////////////////

if Country=="Brasil" then
    Labour_tax_rate_temp=Labour_Tax_rate+Labour_Corp_Tax_rate;
else
Labour_tax_rate_temp=Labour_Tax_rate;
end
/////////////////////////////////////////////////////
// End Difference between France (1) and Brasil (2)
/////////////////////////////////////////////////////

[x_pL, const_pL, info_cal_pL] = fsolve(x_pL, list(fcal_Labour_Cost_Const_1,  w, Labour_tax_rate_temp, Index_Imaclim_VarCalib));

if norm(const_pL) > sensib
    error( "review calib_pL")
else
    pL = indiv_x2variable (Index_Imaclim_VarCalib, "x_pL");
    pL = (abs(pL) > %eps).*pL;
end


function [const_markup_rate] =fcal_ProfitIncom_Const_1(x_markup_rate, Profit_margin, pY, Y, Imaclim_VarCalib)
    markup_rate= indiv_x2variable(Imaclim_VarCalib, "x_markup_rate");

    // if Profit_margin = 0 => markup_rate = 0
    y1_1 = (Profit_margin'==0).*markup_rate';
    y1_2 = (Profit_margin'<>0).* Profit_income_Const_1(Profit_margin, markup_rate, pY, Y) ;
    const_markup_rate = (Profit_margin'==0).*y1_1 + (Profit_margin'<>0).*y1_2 ;

endfunction

[x_markup_rate, const_markup_rate, info_cal_markup_rate] = fsolve(x_markup_rate, list(fcal_ProfitIncom_Const_1, Profit_margin, pY, Y, Index_Imaclim_VarCalib));

if norm(const_markup_rate) > sensib
    error( "review calib_markup_rate")
else
    markup_rate = indiv_x2variable (Index_Imaclim_VarCalib, "x_markup_rate");
    markup_rate = (abs(markup_rate) > %eps).*markup_rate;
end

///////////////////////////
// Start - Not applied to Brasil
///////////////////////////

if Country<>"Brasil"

function [const_PensBenef_param] =fcal_PensBenef_Const_1(x_Pension_Benefits_param, Pension_Benefits, NetWage_variation, Imaclim_VarCalib)
    Pension_Benefits_param= indiv_x2variable(Imaclim_VarCalib, "x_Pension_Benefits_param");
    const_PensBenef_param = Pension_Benefits_Const_1(Pension_Benefits, NetWage_variation, Pension_Benefits_param, GDP)
endfunction

x_Pension_Benefits_param = 1e6.*ones(1,nb_Households);
[x_Pension_Benefits_param, const_PensBenef_param, info_cal_PensBenef_param] = fsolve(x_Pension_Benefits_param, list(fcal_PensBenef_Const_1, Pension_Benefits, NetWage_variation, Index_Imaclim_VarCalib));
if norm(const_PensBenef_param) > sensib
    error("review calib_Pension_Benefits_param")
    [str,n,line,func]=lasterror(%f);
elseif  norm(const_PensBenef_param) <= sensib
    Pension_Benefits_param = indiv_x2variable (Index_Imaclim_VarCalib, "x_Pension_Benefits_param");
end

function [const_UnemplBenef_param] =fcal_UnemplBenef_Const_1(x_UnemployBenefits_param, UnemployBenefits, NetWage_variation, Imaclim_VarCalib)
    UnemployBenefits_param= indiv_x2variable(Imaclim_VarCalib, "x_UnemployBenefits_param");
    const_UnemplBenef_param = UnemployBenefits_Const_1(UnemployBenefits, NetWage_variation, UnemployBenefits_param)
endfunction

[x_UnemployBenefits_param, const_UnemplBenef_param, infoCal_UnemplBenefParam] = fsolve(x_UnemployBenefits_param, list(fcal_UnemplBenef_Const_1, UnemployBenefits, NetWage_variation, Index_Imaclim_VarCalib));

if norm(const_UnemplBenef_param) > sensib
    error( "review calib_UnemployBenefits_param")
else
    UnemployBenefits_param = indiv_x2variable (Index_Imaclim_VarCalib, "x_UnemployBenefits_param");
end

function [const_OthSocioBenefParam] =fcalOthSocioBene_Const_1(x_Other_SocioBenef_param, Other_SocioBenef, NetWage_variation, Imaclim_VarCalib)
    Other_SocioBenef_param= indiv_x2variable(Imaclim_VarCalib, "x_Other_SocioBenef_param");
    const_OthSocioBenefParam =  Other_SocioBenef_Const_1(Other_SocioBenef, NetWage_variation, Other_SocioBenef_param, GDP, Population )
endfunction

[x_Other_SocioBenef_param, const_OthSocioBenefParam, infCalOthSocioBene_param] = fsolve(x_Other_SocioBenef_param, list(fcalOthSocioBene_Const_1, Other_SocioBenef, NetWage_variation, Index_Imaclim_VarCalib));

if norm(const_OthSocioBenefParam) > sensib
    error( "review calib_Other_SocioBenef_param")
else
    Other_SocioBenef_param = indiv_x2variable (Index_Imaclim_VarCalib, "x_Other_SocioBenef_param");
end

end

///////////////////////////
// End - Not applied to Brasil
///////////////////////////

///////////////////////////
// Start Specific to Brasil
///////////////////////////
if Country=="Brasil" then
   
    function [const_GovSocioBenefParam] =fcalGovSocioBene_Const_1(x_Gov_SocioBenef_param, Gov_SocioBenef, Imaclim_VarCalib)
        Gov_SocioBenef_param= indiv_x2variable(Imaclim_VarCalib, "x_Gov_SocioBenef_param");
        const_GovSocioBenefParam =  Other_SocioBenef_Const_1(Gov_SocioBenef, NetWage_variation, Gov_SocioBenef_param, GDP, Population)
    endfunction
    
    [x_Gov_SocioBenef_param, const_GovSocioBenefParam, infCalGovSocioBene_param] = fsolve(x_Gov_SocioBenef_param, list(fcalGovSocioBene_Const_1, Gov_SocioBenef, Index_Imaclim_VarCalib));
    
    if norm(const_GovSocioBenefParam) > sensib
        error( "review calib_Other_SocioBenef_param")
    else
        Gov_SocioBenef_param = indiv_x2variable (Index_Imaclim_VarCalib, "x_Gov_SocioBenef_param");
    end
    
    function [const_CorSocioBenefParam] =fcalCorSocioBene_Const_1(x_Corp_SocioBenef_param, Corp_SocioBenef, Imaclim_VarCalib)
        Corp_SocioBenef_param= indiv_x2variable(Imaclim_VarCalib, "x_Corp_SocioBenef_param");
        const_CorSocioBenefParam =  Other_SocioBenef_Const_1(Corp_SocioBenef, NetWage_variation, Corp_SocioBenef_param, GDP, Population)
    endfunction
    
    [x_Corp_SocioBenef_param, const_CorSocioBenefParam, infCalCorSocioBene_param] = fsolve(x_Corp_SocioBenef_param, list(fcalCorSocioBene_Const_1, Corp_SocioBenef, Index_Imaclim_VarCalib));
    
    if norm(const_CorSocioBenefParam) > sensib
        error( "review calib_Other_SocioBenef_param")
    else
        Corp_SocioBenef_param = indiv_x2variable (Index_Imaclim_VarCalib, "x_Corp_SocioBenef_param");
    end
end
///////////////////////////
// End Specific to Brasil
///////////////////////////

function [const_kappa] =fcalCapIncome_Const_1(x_kappa, Capital_income, pK, Y, Imaclim_VarCalib)
    kappa= indiv_x2variable(Imaclim_VarCalib, "x_kappa");
    // const_kappa = Capital_income_Const_1(Capital_income, pK, kappa, Y)

    // if Y =0 => kappa=0
    y1_1 = (Y==0).*(kappa');
    y1_2 = (Y<>0).*Capital_income_Const_1(Capital_income, pK, kappa, Y);
    const_kappa	= (Y==0).*y1_1  + (Y<>0).*y1_2;

endfunction

[x_kappa, const_kappa, infCal_Capital_income] = fsolve(x_kappa, list(fcalCapIncome_Const_1, Capital_income, pK, Y, Index_Imaclim_VarCalib));

if norm(const_kappa) > sensib
    error( "review calib_kappa")
else
    kappa = indiv_x2variable (Index_Imaclim_VarCalib, "x_kappa");
    kappa = (abs(kappa) > %eps).*kappa;

end


function [const_Capital_consump] =fcalCapitalCons_Const_1(x_Capital_consumption, Y, kappa, Imaclim_VarCalib)
    Capital_consumption= indiv_x2variable(Imaclim_VarCalib, "x_Capital_consumption");
    const_Capital_consump = Capital_Consump_Const_1(Capital_consumption, Y, kappa)
endfunction

[x_Capital_consumption, const_Capital_consump, infCal_CapitalCons] = fsolve(x_Capital_consumption, list(fcalCapitalCons_Const_1, Y, kappa, Index_Imaclim_VarCalib));

if norm(const_Capital_consump) > sensib
    error( "review calib_Capital_consumption")
else
    Capital_consumption = indiv_x2variable (Index_Imaclim_VarCalib, "x_Capital_consumption");
    Capital_consumption = (abs(Capital_consumption) > %eps).*Capital_consumption;
end

function [const_Betta] =fcalInvestDemand_Const_1(x_Betta, Y, kappa, Imaclim_VarCalib)
    Betta= indiv_x2variable(Imaclim_VarCalib, "x_Betta");
    const_Betta = Invest_demand_Const_1(Betta, I, kappa, Y)
endfunction

[x_Betta, const_Betta, infCal_Betta] = fsolve(x_Betta, list(fcalInvestDemand_Const_1, Y, kappa, Index_Imaclim_VarCalib));

if norm(const_Betta) > sensib
    error( "review calib_Betta")
else
    Betta = indiv_x2variable (Index_Imaclim_VarCalib, "x_Betta");
    Betta = (abs(Betta) > %eps).*Betta;
end

///////////////////////////
// Start - Not Applied to Brasil
///////////////////////////
// if Country<>"Brasil" then
function [const_Labour_Tax_Cut] =fcalRevRecycling_Const_1(x_Labour_Tax_Cut, Labour_Tax, Labour_Tax_rate, w, lambda, Y, Carbon_Tax_IC, Carbon_Tax_C, ClimPolCompensbySect, ClimPolicyCompens, Imaclim_VarCalib)
    Labour_Tax_Cut= indiv_x2variable(Imaclim_VarCalib, "x_Labour_Tax_Cut");
    const_Labour_Tax_Cut = RevenueRecycling_Const_1(Labour_Tax, Labour_Tax_rate, Labour_Tax_Cut, w, lambda, Y, Carbon_Tax_IC, Carbon_Tax_C, ClimPolCompensbySect, ClimPolicyCompens, NetLending, GFCF_byAgent, Government_savings, GDP)
endfunction

[x_Labour_Tax_Cut, const_Labour_Tax_Cut, infCal_Labour_Tax_Cut] = fsolve(x_Labour_Tax_Cut, list(fcalRevRecycling_Const_1,  Labour_Tax, Labour_Tax_rate, w, lambda, Y, Carbon_Tax_IC, Carbon_Tax_C, ClimPolCompensbySect, ClimPolicyCompens, Index_Imaclim_VarCalib));

if norm(const_Labour_Tax_Cut) > sensib
    error( "review calib_Labour_Tax_Cut")
else
    Labour_Tax_Cut = indiv_x2variable (Index_Imaclim_VarCalib, "x_Labour_Tax_Cut");
    Labour_Tax_Cut = (abs(Labour_Tax_Cut) > %eps).*Labour_Tax_Cut;
end


function [const_LabTaxRate_BefCut] =fcal_LabTaxRate_Const_1(x_LabTaxRate_BeforeCut,Labour_Tax_rate, Labour_Tax_Cut, Imaclim_VarCalib)
    LabTaxRate_BeforeCut= indiv_x2variable(Imaclim_VarCalib, "x_LabTaxRate_BeforeCut");
    const_LabTaxRate_BefCut = Labour_Taxe_rate_Const_1(LabTaxRate_BeforeCut, Labour_Tax_rate, Labour_Tax_Cut)
endfunction

const_LabTaxRate_BefCut = 10^5;
while norm(const_LabTaxRate_BefCut) > sensib
    if  (count>=countMax)
        error("review calibLabTaxRate_BeforeCut");
    end
    count = count + 1;
    [x_LabTaxRate_BeforeCut, const_LabTaxRate_BefCut, infCalLabTaxRate_BefCut] = fsolve(x_LabTaxRate_BeforeCut, list(fcal_LabTaxRate_Const_1,Labour_Tax_rate, Labour_Tax_Cut, Index_Imaclim_VarCalib));
    LabTaxRate_BeforeCut = indiv_x2variable (Index_Imaclim_VarCalib, "x_LabTaxRate_BeforeCut");
    LabTaxRate_BeforeCut = (abs(LabTaxRate_BeforeCut) > %eps).*LabTaxRate_BeforeCut;
end
count=0;

// end
///////////////////////////
// End - Not Applied to Brasil
///////////////////////////

// 	Constraints to execute for variables_ref in calib
// Rq: vérifier que dans tous les cas, VarRefNames(i) correspond bien à la bonne contrainte dans Const2Exec(i,1)
//[Const2Exec, VarRefNames] = Const4VarRef(calib, initial_value, parameters) ;
//for i= Const2Exec
//    execstr(Const2Exec)
//end
///////////////////////////
// Comment Antoine : suppression des REF

Other_Transfers_ref = initial_value.Other_Transfers;
///////////////////////////
// Comment Antoine : du temporaire, à régler


function [const_Distrib_Shares] =fcal_IncomDistri_Const_1(x_Distribution_Shares, NetCompWages_byAgent, GOS_byAgent, Other_Transfers, GDP, Labour_income, GrossOpSurplus, Imaclim_VarCalib)
    Distribution_Shares= indiv_x2variable(Imaclim_VarCalib, "x_Distribution_Shares");
    const_Distrib_Shares =  IncomeDistrib_Const_2(NetCompWages_byAgent, GOS_byAgent, Other_Transfers, GDP, Distribution_Shares, Labour_income, GrossOpSurplus)
endfunction

const_Distrib_Shares = 10^5;
while norm(const_Distrib_Shares) > sensib
    if  (count>=countMax)
        error("review calib_Distribution_Shares")
    end
    count = count + 1;
    [x_Distribution_Shares, const_Distrib_Shares, info_cal_Distrib_Shares] = fsolve(x_Distribution_Shares, list(fcal_IncomDistri_Const_1, NetCompWages_byAgent, GOS_byAgent, Other_Transfers, GDP, Labour_income, GrossOpSurplus, Index_Imaclim_VarCalib));

    Distribution_Shares = indiv_x2variable (Index_Imaclim_VarCalib, "x_Distribution_Shares");
    Distribution_Shares = (abs(Distribution_Shares) > %eps).*Distribution_Shares;
end
count=0;

clear Other_Transfers_ref ;
///////////////////////////
// Comment Antoine : du temporaire, à régler


//[Const2Exec, VarRefNames] = Const4VarRef(calib, initial_value, parameters) ;
//for i= Const2Exec
//    execstr(Const2Exec)
//end
///////////////////////////
// Comment Antoine : suppression des REF

function [const_CPI] =fcal_CPI_Const_1(x_CPI, pC, C, Imaclim_VarCalib)
    CPI= indiv_x2variable(Imaclim_VarCalib, "x_CPI");
    const_CPI = CPI_Const_4(CPI, pC, C)
endfunction

[x_CPI, const_CPI, infCal_CPI] = fsolve(x_CPI, list(fcal_CPI_Const_1, pC, C, Index_Imaclim_VarCalib));

if norm(const_CPI) > sensib
    error( "review calib_CPIa")
else
    CPI = indiv_x2variable (Index_Imaclim_VarCalib, "x_CPI");
end

///////////////////////////
// Start Not Applied to Brasil
///////////////////////////
if Country<>"Brasil" then

function [const_OthDirectTax_param] =fcalOthDirectTax_Const_1(x_Other_Direct_Tax_param, Other_Direct_Tax, CPI, Imaclim_VarCalib)
    Other_Direct_Tax_param= indiv_x2variable(Imaclim_VarCalib, "x_Other_Direct_Tax_param");
    const_OthDirectTax_param = Other_Direct_Tax_Const_1(Other_Direct_Tax, CPI, Other_Direct_Tax_param)
endfunction

[x_Other_Direct_Tax_param, const_OthDirectTax_param, infCalOthDirectTax_param] = fsolve(x_Other_Direct_Tax_param, list(fcalOthDirectTax_Const_1, Other_Direct_Tax, CPI, Index_Imaclim_VarCalib));

if norm(const_OthDirectTax_param) > sensib
    error( "review calib_Other_Direct_Tax_param")
else
    Other_Direct_Tax_param = indiv_x2variable (Index_Imaclim_VarCalib, "x_Other_Direct_Tax_param");
end

end 
///////////////////////////
// End Not Applied to Brasil
///////////////////////////

///////////////////////////
// Start Specific to Brasil
///////////////////////////
if Country=="Brasil" then
    function [const_GovDirectTax_rate] =fcalGovDirectTax_Const_1(x_Gov_Direct_Tax_rate, Gov_Direct_Tax, Labour_income, Imaclim_VarCalib)
        Gov_Direct_Tax_rate= indiv_x2variable(Imaclim_VarCalib, "x_Gov_Direct_Tax_rate");
        const_GovDirectTax_rate = OthDirTax_rate_Const_1(Gov_Direct_Tax, Labour_income, Gov_Direct_Tax_rate)
    endfunction
    
    [x_Gov_Direct_Tax_rate, const_GovDirectTax_rate, infCalGovDirectTax_rate] = fsolve(x_Gov_Direct_Tax_rate, list(fcalGovDirectTax_Const_1, Gov_Direct_Tax, Labour_income, Index_Imaclim_VarCalib));
    
    if norm(const_GovDirectTax_rate) > sensib
        error( "review calib_Gov_Direct_Tax_rate")
    else
        Gov_Direct_Tax_rate = indiv_x2variable (Index_Imaclim_VarCalib, "x_Gov_Direct_Tax_rate");
    end
    
    function [const_CorpDirectTax_rate] =fcalCorDirectTax_Const_1(x_Corp_Direct_Tax_rate, Corp_Direct_Tax, Labour_income, Imaclim_VarCalib)
        Corp_Direct_Tax_rate= indiv_x2variable(Imaclim_VarCalib, "x_Corp_Direct_Tax_rate");
        const_CorpDirectTax_rate = OthDirTax_rate_Const_1(Corp_Direct_Tax, Labour_income, Corp_Direct_Tax_rate)
    endfunction
    
    [x_Corp_Direct_Tax_rate, const_CorpDirectTax_rate, infCalCorpDirectTax_rate] = fsolve(x_Corp_Direct_Tax_rate, list(fcalCorDirectTax_Const_1, Corp_Direct_Tax, Labour_income, Index_Imaclim_VarCalib));
    
    if norm(const_CorpDirectTax_rate) > sensib
        error( "review calib_Corp_Direct_Tax_rate")
    else
        Corp_Direct_Tax_rate = indiv_x2variable (Index_Imaclim_VarCalib, "x_Corp_Direct_Tax_rate");
    end
end

///////////////////////////
// End Specific to Brasil
///////////////////////////

// Comment Antoine : suppression de cette variable pour avoir delta_pM en paramètre et faire un forçage
//function [const_delta_pM] =fcalImport_price_Const_1(x_delta_pM, pM, pM, Imaclim_VarCalib)
//    delta_pM= indiv_x2variable(Imaclim_VarCalib, "x_delta_pM");
//    const_delta_pM = Import_price_Const_1(pM, delta_pM,pM)
//endfunction
//
//[x_delta_pM, const_delta_pM, infCaldelta_pM] = fsolve(x_delta_pM, list(fcalImport_price_Const_1, pM, pM, Index_Imaclim_VarCalib));
//
//if norm(const_delta_pM) > sensib
//    error( "review calib_Ddelta_pM")
//else
//    delta_pM = indiv_x2variable (Index_Imaclim_VarCalib, "x_delta_pM");
//end

///////////////////////////
// End Not Applied to Brasil
///////////////////////////
// if Country<>"Brasil" then
function [const_Phi] =fcalTechnicProg_Const_1(x_Phi, Capital_consumption, sigma_Phi, Imaclim_VarCalib)
    Phi= indiv_x2variable(Imaclim_VarCalib, "x_Phi");
    const_Phi = TechnicProgress_Const_1(Phi, Capital_consumption, sigma_Phi)
endfunction

[x_Phi, const_Phi, infCalPhi] = fsolve(x_Phi, list(fcalTechnicProg_Const_1, Capital_consumption, sigma_Phi, Index_Imaclim_VarCalib));

if norm(const_Phi) > sensib
    error( "review calib_Phi")
else
    Phi = indiv_x2variable (Index_Imaclim_VarCalib, "x_Phi");
    Phi = (abs(Phi) > %eps).*Phi;
end

function [const_Theta] =fcalDecreasReturnConst_1(x_Theta, Y, sigma_Theta, Imaclim_VarCalib)
    Theta= indiv_x2variable(Imaclim_VarCalib, "x_Theta");
    const_Theta = 	DecreasingReturn_Const_1(Theta, Y, sigma_Theta)
endfunction

[x_Theta, const_Theta, infCalTheta] = fsolve(x_Theta, list(fcalDecreasReturnConst_1, Y, sigma_Theta, Index_Imaclim_VarCalib));

if norm(const_Theta) > sensib
    error( "review calib_Theta")
else
    Theta = indiv_x2variable (Index_Imaclim_VarCalib, "x_Theta");
end

// end 
// Antoine : il faudra réintégrer cela au Brésil finalement pour permettre d'avoir du changement technique endogène et exogène 

///////////////////////////
// End Not Applied to Brasil
///////////////////////////

function [const_Government_closure] =fcalPubFinanc_Const_1(x_Government_closure, Imaclim_VarCalib)
    Government_closure= indiv_x2variable(Imaclim_VarCalib, "x_Government_closure");
    const_Government_closure = Public_finance_Const_1(Government_closure)
endfunction

[x_Government_closure, const_Government_closure, infCalGov_closure] = fsolve(x_Government_closure, list(fcalPubFinanc_Const_1, Index_Imaclim_VarCalib));

if norm(const_Government_closure) > sensib
    error( "review calib_Government_closure")
else
    Government_closure = indiv_x2variable (Index_Imaclim_VarCalib, "x_Government_closure");
end


//////////////////////////////////////////////////////////////////
//// Cas particulier  -Calibration CES COEFFICIENT
//////////////////////////////////////////////////////////////////

// Valeur planché temporaire, à mettre dans les paramaters ensuite
// ConstrainedShare_Capital = 0.8.* ConstrainedShare_Capital;
// ConstrainedShare_Labour  = 0.8.* ConstrainedShare_Labour;
// ConstrainedShare_IC  = 0.8.* ConstrainedShare_IC;

// CES coefficient - analytical

Coeff_forCES = (sum(pIC.* (1 - ConstrainedShare_IC) .* alpha,"r") + sum(pL .* (1-ConstrainedShare_Labour) .* lambda, "r") + pK .* (1-ConstrainedShare_Capital) .* kappa );


aIC = (ones(nb_Sectors,1)*Coeff_forCES<>0).*pIC.* ((1 - ConstrainedShare_IC) .* alpha) .^ (1 -(ones(nb_Sectors,1)*((sigma-1)./sigma))) .* (ones(nb_Sectors,1)*((Coeff_forCES<>0).*Coeff_forCES + (Coeff_forCES==0))).^(-1);

aL	=  (Coeff_forCES<>0).*pL.* ((1 - ConstrainedShare_Labour) .* lambda) .^ (1 -((sigma-1)./sigma)) .*((Coeff_forCES<>0).*Coeff_forCES + (Coeff_forCES==0)) .^(-1);

aK= (Coeff_forCES<>0) .* (pK.* ((1 - ConstrainedShare_Capital) .* kappa) .^ (1 -((sigma-1)./sigma)) .*((Coeff_forCES<>0).*Coeff_forCES + (Coeff_forCES==0)) .^(-1));

x_aIC = matrix(aIC,nb_Sectors*nb_Commodities, 1) ;
x_aL = matrix(aL,nb_Sectors, 1);
x_aK = matrix(aK,nb_Sectors, 1);

x_TechniCoef = [x_aIC;x_aL;x_aK];


/// Replace all calibrated variables by correct value into calib structure
calib = Variables2struct(list_calib);

// Create FC bloc with all final consumption in quantities and deleting it from intial_value ( it's not a initial_value because it's calibrated)
if	H_DISAGG <> "HH1"
indicEltC = 1;
for elt=1:nb_C
    varname = Index_C(elt);
    execstr ("calib."+varname+"="+"calib.C(:,elt)"+";");
    indicEltFC = 1 + indicEltFC;
end
end

indicEltFC = 1;
for elt=1:nb_FC
    varname = Index_FC(elt);
    execstr ("calib.FC(:,elt)"+"="+"calib."+varname+";");
    indicEltFC = 1 + indicEltFC;
end

initial_value.FC = null();

//Struture BY. created to reunite all BY values before introducing a choc
execstr("BY."+fieldnames(calib)+"= calib."+fieldnames(calib)+";");
execstr("BY."+fieldnames(initial_value)+"= initial_value."+fieldnames(initial_value)+";");
execstr("BY."+fieldnames(parameters)+"= parameters."+fieldnames(parameters)+";");

//Structure ini. = structure of initial value on one iteration
// iter = 1 ==> BY = ini
// iter = 2 ==> BY <> ini
ini = BY;

