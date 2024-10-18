////// Copyright or © or Copr. Ecole des Ponts ParisTech / CNRS 2018
////// Main Contributor (2017) : Gaëlle Le Treut / letreut[at]centre-cireOut.fr
////// Contributors : Emmanuel Combet,    Ruben Bibas,    Julien Lefèvre
////// 
////// 
////// This software is a computer program whose purpose is to centralise all 
////// the IMACLIM national versions,    a general equilibrium model for energy transition analysis
//////
////// This software is governed by the CeCILL license under French law and
////// abiding by the rules of distribution of free software. You can use,
////// modify and/ or redistribute the software under the terms of the CeCILL
////// license as circulated by CEA,    CNRS and INRIA at the following URL
////// "http://www.cecill.info".
////// 
////// As a counterpart to the access to the source code and rights to copy,
////// modify and redistribute granted by the license,    users are provided only
////// with a limited warranty and the software's author,    the holder of the
////// economic rights,    and the successive licensors have only limited
////// liability.
////// 
////// In this respect,    the user's attention is drawn to the risks associated
////// with loading,    using,    modifying and/or developing or reproducing the
////// software by the user in light of its specific status of free software,
////// that may mean that it is complicated to manipulate,    and that also
////// therefore means that it is reserved for developers and experienced
////// professionals having in-depth computer knowledge. Users are therefore
////// encouraged to load and test the software's suitability as regards their
////// requirements in conditions enabling the security of their systems and/or 
////// data to be ensured and,    more generally,    to use and operate it in the
////// same conditions as regards security.
////// 
////// The fact that you are presently reading this means that you have had
////// knowledge of the CeCILL license and that you accept its terms.
//////////////////////////////////////////////////////////////////////////////////



OutputTable("FullTemplate_"+ref_name)=[["Variables",    "values_"+Name_time];..
["Labour Tax Cut",    -Out.Labour_Tax_Cut];..
["Emissions - MtCO2",    Out.DOM_CO2];..
["Emissions - %/"+ref_name,    (evol_ref.DOM_CO2-1)*100];..
["Carbon Tax rate-"+money+"/tCO2",    (Out.Carbon_Tax_rate*evstr(money_unit_data))/10^6];..
["Energy Tax "+money_disp_unit+money,    (sum(Out.Energy_Tax_FC) + sum(Out.Energy_Tax_IC)).*money_disp_adj];..
["Labour productivity ",    parameters.Mu];..
["GDP Decomposition Laspeyres Quantities",    ""];..
["Real GDP LaspQ ratio/"+ref_name,    GDP_qLasp];..
["GDP Decomp - C",    (sum(ref.C_value)/ref.GDP) * C_qLasp];..
["GDP Decomp - G",    (sum(ref.G_value)/ref.GDP) * G_qLasp];..
["GDP Decomp - I",    (sum(ref.I_value)/ref.GDP) * I_qLasp];..
["GDP Decomp - X",    (sum(ref.X_value)/ref.GDP) * X_qLasp];..
["GDP Decomp - M",    (sum(ref.M_value)/ref.GDP) * M_qLasp];..
["---Nominal values at "+money_disp_unit+money+"---",    ""];..
["Nominal GDP",    money_disp_adj.*sum(Out.GDP)];..
["Nominal C",    money_disp_adj.*sum(Out.C_value)];..
["Nominal G",    money_disp_adj.*sum(Out.G_value)];..
["Nominal I",    money_disp_adj.*sum(Out.I_value)];..
["Nominal X",    money_disp_adj.*sum(Out.X_value)];..
["Nominal M",    money_disp_adj.*sum(Out.M_value)];..
["Nominal Trade Balance",    money_disp_adj.*(sum(Out.X_value)-sum(Out.M_value))];..
["Nominal M/Y ratio_"+Index_Sectors,    divide(Out.M,    Out.Y,    %nan)];..
["Nominal Net-of-tax wages",    Out.omega];..
["Net-of-tax effective wages",    Out.omega/((1+Out.Mu)^Out.time_since_BY)];..
["Nominal C_"+Index_Sectors,    money_disp_adj.*sum(Out.C_value,"c")];..
["Nominal M_"+Index_Sectors,    money_disp_adj.*Out.M_value'];..
["Nominal X_"+Index_Sectors,    money_disp_adj.*Out.X_value];..
["Nominal Y_"+Index_Sectors,    money_disp_adj.*Out.Y_value'];..
["Nominal VA-"+Index_Sectors,    money_disp_adj.*sum(Out.Value_Added,"r")'];..
["Nominal GDP-"+Index_Sectors,    money_disp_adj.*sum(Out.GDP_sect,"r")'];..
["GFCF_"+Index_DomesticAgents,    money_disp_adj.*Out.GFCF_byAgent(Indice_DomesticAgents)'];..
["Disposable income_"+Index_InstitAgents,    money_disp_adj.*Out.Disposable_Income'];..
["Net Lending_"+Index_InstitAgents,    money_disp_adj.*Out.NetLending'];..
["Country Deficit/GDP-ratio/"+ref_name,    evol_ref.NetLendingRoW_GDP];..
["Net Debt"+Index_InstitAgents,    money_disp_adj.*Out.NetFinancialDebt'];..
["HH saving - % ",	 (sum(Out.Household_savings)/sum(Out.H_disposable_income))];..
["---Real terms at "+money_disp_unit+money+" "+ref_name+"---",    ""];..
["Real GDP",    money_disp_adj.*Out.GDP/GDP_pFish];..
["Real C",    money_disp_adj.*sum(Out.C_value)/Out.CPI];..
["Real G",    money_disp_adj.*sum(Out.G_value)/G_pFish];..
["Real I",    money_disp_adj.*sum(Out.I_value)/I_pFish];..
["Real X",    money_disp_adj.*sum(Out.X_value)/X_pFish];..
["Real M",    money_disp_adj.*sum(Out.M_value)/M_pFish];..
["Real_Trade_Balance",    money_disp_adj.*(sum(Out.X_value)/X_pFish-sum(Out.M_value)/M_pFish)];..
["Real Y",    money_disp_adj.*sum(Out.Y_value)/Y_pFish];..
["Real Y_"+Index_Sectors,    money_disp_adj.*(Out.Y_value')./evstr("Y_"+Index_Sectors+"_pFish")	];..
["Real Net-of-tax wages",    Out.omega/Out.CPI];..
["Real Net-of-tax effective wages",    (Out.omega/((1+Out.Mu)^Out.time_since_BY))/Out.CPI];..
["Real GFCF_"+Index_DomesticAgents,    money_disp_adj.*(Out.GFCF_byAgent(Indice_DomesticAgents)/I_pFish)'	];..
["---Prices Index ratio/"+ref_name+"---",    ""];..
["Price Fisher Index/"+ref_name,    ""];..
["GDP pFish/"+ref_name,    GDP_pFish];..
["pC pFish/"+ref_name,    C_pFish];..
["pG pFish/"+ref_name,    G_pFish];..
["pI pFish/"+ref_name,    I_pFish];..
["pX pFish/"+ref_name,    X_pFish];..
["pY pFish/"+ref_name,    Y_pFish];..
["pY Energy pLasp/"+ref_name,    Y_En_pLasp];..
[string("pY "+Index_EnerSect +" pLasp/"+ref_name),    evstr("Y_"+Index_EnerSect+"_pLasp")];..
["pY Non-Energy pLasp/"+ref_name,    Y_NonEn_pLasp];..
[string("pY "+Index_NonEnerSect +" pLasp/"+ref_name),    evstr("Y_"+Index_NonEnerSect+"_pLasp")];..
["pM pFish/"+ref_name,    M_pFish];..
["Labour price/"+ref_name,    L_pFish];..
["Capital price/"+ref_name,    K_pFish];..
["Energy price/"+ref_name,    IC_Ener_pFish];..
["Non-energy price/"+ref_name,    IC_NonEn_pFish];..
["---Intensity and rate---",    ""];..
["Labour intensity",    lambda_pFish];..
["Capital intensity",    kappa_pFish];..
["Energy intensity",    alpha_Ener_qLasp];..
["---Quantities ---",    ""];..
["Unemployment % points/"+ref_name,    (Out.u_tot - ref.u_tot)*100];..
["Labour "+Labour_unit,    Out.Labour_tot];..
["Labour "+Labour_unit+" ratio/"+ref_name,    evol_ref.Labour_tot];..
["Labour "+Index_Sectors+" "+Labour_unit,    Out.Labour'];..
["C - Energy - ktoe",    sum(Out.C(Indice_EnerSect,:))];..
[string("C - "+ Index_EnerSect +" ktoe"),    sum(Out.C(Indice_EnerSect,:),"c")];..
["IC - Energy ktoe",    sum(Out.IC(Indice_EnerSect,:))];..
[string("IC Energy - "+Index_Sectors +" - ktoe "),    sum(Out.IC(Indice_EnerSect,:),"r")'];..
["X - Energy - ktoe",    sum(Out.X(Indice_EnerSect,:))];..
[string("X - "+ Index_EnerSect +" - ktoe"),    Out.X(Indice_EnerSect,:)];..
["M - Energy - ktoe",    sum(Out.M(Indice_EnerSect,:))];..
[string("M - "+ Index_EnerSect +" - ktoe"),    Out.M(Indice_EnerSect,:)];..
["---Quantities Index Laspeyres ---",    ""];..
["Real C qLasp",    C_qLasp];..
["Real C Energy qLasp",    C_En_qLasp];..
["Real C Non-Energy qLasp",    C_NonEn_qLasp];..
["---Pseudo Quantities For Non-Energy ---",    ""];..
["Y_"+Index_NonEnerSect,    money_disp_adj.*Out.Y(Indice_NonEnerSect)];..
["M_"+Index_NonEnerSect,    money_disp_adj.*Out.M(Indice_NonEnerSect)];..
["C_"+Index_NonEnerSect,    money_disp_adj.*sum(Out.C(Indice_NonEnerSect,:),"c")];..
["X_"+Index_NonEnerSect,    money_disp_adj.*sum(Out.X(Indice_NonEnerSect,:),"c")];..
["---Quantities Index Fisher ---",    ""];..
["M qFish",    M_qFish];..
["Y qFish",    Y_qFish];..
["X qFish",    X_qFish];..
["---Energy and non energy trade balance ---",    ""];..
["Nominal X Energy",    money_disp_adj.*sum(Out.X_value(1:nb_EnerSect))];..
["Nominal X Non Energy",    money_disp_adj.*sum(Out.X_value(nb_EnerSect+1:nb_Sectors))];..
["Nominal M Energy",    money_disp_adj.*sum(Out.M_value(1:nb_EnerSect))];..
["Nominal M Non Energy",    money_disp_adj.*sum(Out.M_value(nb_EnerSect+1:nb_Sectors))];..
["Nominal Trade Balance Energy",    money_disp_adj.*(sum(-Out.X_value(1:nb_EnerSect)) - sum(Out.M_value(1:nb_EnerSect)))];..
["Nominal Trade Balance Non Energy",    money_disp_adj.*(sum(Out.X_value(nb_EnerSect+1:nb_Sectors)) - sum(Out.M_value(nb_EnerSect+1:nb_Sectors)))];..
["--- Household Energy Bill ---",    ""];..
["Real C Energy",    money_disp_adj.*sum(Out.C_value(Indice_EnerSect,    :)) / C_En_pFish];..
["Real C Non Energy",    money_disp_adj.*sum(Out.C_value(Indice_NonEnerSect,    :))/C_NonEn_pFish];..
["Share C Energy",    (sum(Out.C_value(Indice_EnerSect,    :)) / C_En_pFish ) /(sum(Out.C_value)/C_pFish)];..
["--- Total bill Of Each Energy ---",    ""];..
["Nominal total bill "+Index_EnerSect,    money_disp_adj.* (Out.Y_value(Indice_EnerSect)' + Out.M_value(Indice_EnerSect)' - Out.X_value(Indice_EnerSect))];..
["--- International and domestic energy prices values ---",    ""];..
[string("pY "+ Index_EnerSect +" - milliers euros / ktoe"),    Out.pY(Indice_EnerSect,:)];..
[string("pM "+ Index_EnerSect +" - milliers euros / ktoe"),    Out.pM(Indice_EnerSect,:)];..
[string("Prix de vente pondere "+ Index_EnerSect +" - milliers euros / ktoe"),    (sum(Out.pIC(Indice_EnerSect,1:nb_Sectors).*Out.IC(Indice_EnerSect,1:nb_Sectors),'c')+Out.pC(Indice_EnerSect).*Out.C(Indice_EnerSect))./(sum(Out.IC(Indice_EnerSect,1:nb_Sectors),    'c')+Out.C(Indice_EnerSect))];..
[string("Prix de vente pondere sans C "+ Index_EnerSect +" - milliers euros / ktoe"),    sum(Out.pIC(Indice_EnerSect,1:nb_Sectors).*Out.IC(Indice_EnerSect,1:nb_Sectors),'c')./sum(Out.IC(Indice_EnerSect,1:nb_Sectors),    'c')];..
["--- Quantities : energy production ---",    ""];..
[string("Y "+ Index_EnerSect +" - ktoe"),    Out.Y(Indice_EnerSect,:)];..
["--- Mesures sous-jacentes : transferts - millions euros courants ---",    ""];..
["Bonus ecologique vehicules particuliers",    money_disp_adj.*Bonus_vehicules_share * C_value(Indice_AutoS)];..
["Ma Prime Renov",    money_disp_adj.*MPR_share * C_value(Indice_ConstruS)];..
["--- Carbon Tax value - millions euros courants ---",    ""];..
["Total carbon tax (C)",    money_disp_adj.*sum(Out.Carbon_Tax_C)];..
["Total carbon tax (IC)",    money_disp_adj.*sum(Out.Carbon_Tax_IC)];..
[string("Carbon tax (C + IC) "+ Index_EnerSect),    money_disp_adj.*Out.Carbon_Tax(Indice_EnerSect)'];..
[string("Border adjustment tax "+ Index_Sectors),    money_disp_adj.*Out.Carbon_Tax_M(Indice_Sectors)'];..
["Real_GDP_Laspeyres",    money_disp_adj.*Out.GDP/GDP_pLasp];..
["Real_GDP_Paasche",    money_disp_adj.*Out.GDP/GDP_pPaas];..
["Real GDP_chained",    money_disp_adj.*Out.GDP/GDP_pFish_chained];..
["Real_GDP_Laspeyres_chained",    money_disp_adj.*Out.GDP/GDP_pLasp_chained];..
["Real_GDP_Paasche_chained",    money_disp_adj.*Out.GDP/GDP_pPaas_chained];..
["Real_Trade_Balance_BY",    (money_disp_adj.*(sum(Out.X_value)/X_pFish-sum(Out.M_value)/M_pFish)) / (money_disp_adj.*(sum(BY.X_value)-sum(BY.M_value)))];..
["GDP pPaas/"+ref_name,    GDP_pPaas];..
["GDP pLasp/"+ref_name,    GDP_pLasp];..
["real_effective_exchange_rate"+ref_name,    C_pFish / M_pFish];..
["--- Decomposition budget public ---",    ""];..
["G_Tax_revenue",    money_disp_adj.*Out.G_Tax_revenue];..
["G_Non_Labour_Income",    money_disp_adj.*Out.G_Non_Labour_Income];..
["G_Other_Income",    money_disp_adj.*Out.G_Other_Income];..
["G_Property_income",    money_disp_adj.*Out.G_Property_income];..
["G_Social_Transfers",    money_disp_adj.*Out.G_Social_Transfers];..
["G_Compensations",    money_disp_adj.*Out.G_Compensations];..
["G_T_MPR",    money_disp_adj.*T_MPR];..
["G_Bonus_vehicules",    money_disp_adj.*Bonus_vehicules];..
["Population",	Out.Population];..
////////////// 1 ////////////////////////////////////////////////////////////////////////////
["--- Decomposition pY - Crude_oil ---",    ""];..
["IC_Energy_price - Crude_oil",	sum(Out.pIC(1:5,:) .* Out.alpha(1:5,:),"r")(1)];..
["IC_Other_price - Crude_oil",	sum(Out.pIC(6:23,:) .* Out.alpha(6:23,:),"r")(1)];..
["Labour price - Crude_oil",	sum(Out.pL .* Out.lambda,"r")(1)];..
["Capital price - Crude_oil",	sum(Out.pK .* Out.kappa, "r")(1)];..
["Production tax - Crude_oil",	(Out.Production_Tax_rate .* Out.pY')(1)];..
["Markup rate - Crude_oil",	(Out.markup_rate .* Out.pY')(1)];..
["--- Decomposition pY a prix constants - Crude_oil ---",    ""];..
["IC_Energy_price - Crude_oil",	sum(BY.pIC(1:5,:) .* Out.alpha(1:5,:),"r")(1)];..
["IC_Other_price - Crude_oil",	sum(BY.pIC(6:23,:) .* Out.alpha(6:23,:),"r")(1)];..
["Labour price - Crude_oil",	sum(BY.pL .* Out.lambda,"r")(1)];..
["Capital price - Crude_oil",	sum(BY.pK .* Out.kappa, "r")(1)];..
["Production tax - Crude_oil",	(Out.Production_Tax_rate .* Out.pY')(1)];..
["Markup rate - Crude_oil",	(Out.markup_rate .* Out.pY')(1)];..
////////////// 2 ////////////////////////////////////////////////////////////////////////////
["--- Decomposition pY - Liquid_fuels ---",    ""];..
["IC_Energy_price - Liquid_fuels",	sum(Out.pIC(1:5,:) .* Out.alpha(1:5,:),"r")(2)];..
["IC_Other_price - Liquid_fuels",	sum(Out.pIC(6:23,:) .* Out.alpha(6:23,:),"r")(2)];..
["Labour price - Liquid_fuels",	sum(Out.pL .* Out.lambda,"r")(2)];..
["Capital price - Liquid_fuels",	sum(Out.pK .* Out.kappa, "r")(2)];..
["Production tax - Liquid_fuels",	(Out.Production_Tax_rate .* Out.pY')(2)];..
["Markup rate - Liquid_fuels",	(Out.markup_rate .* Out.pY')(2)];..
["--- Decomposition pY a prix constants - Liquid_fuels ---",    ""];..
["IC_Energy_price - Liquid_fuels",	sum(BY.pIC(1:5,:) .* Out.alpha(1:5,:),"r")(2)];..
["IC_Other_price - Liquid_fuels",	sum(BY.pIC(6:23,:) .* Out.alpha(6:23,:),"r")(2)];..
["Labour price - Liquid_fuels",	sum(BY.pL .* Out.lambda,"r")(2)];..
["Capital price - Liquid_fuels",	sum(BY.pK .* Out.kappa, "r")(2)];..
["Production tax - Liquid_fuels",	(Out.Production_Tax_rate .* Out.pY')(2)];..
["Markup rate - Liquid_fuels",	(Out.markup_rate .* Out.pY')(2)];..
////////////// 3 ////////////////////////////////////////////////////////////////////////////
["--- Decomposition pY - Gas_fuels ---",    ""];..
["IC_Energy_price - Gas_fuels",	sum(Out.pIC(1:5,:) .* Out.alpha(1:5,:),"r")(3)];
["IC_Other_price - Gas_fuels",	sum(Out.pIC(6:23,:) .* Out.alpha(6:23,:),"r")(3)];
["Labour price - Gas_fuels",	sum(Out.pL .* Out.lambda,"r")(3)];
["Capital price - Gas_fuels",	sum(Out.pK .* Out.kappa, "r")(3)];
["Production tax - Gas_fuels",	(Out.Production_Tax_rate .* Out.pY')(3)];
["Markup rate - Gas_fuels",	(Out.markup_rate .* Out.pY')(3)];
["--- Decomposition pY a prix constants - Gas_fuels ---",    ""];..
["IC_Energy_price - Gas_fuels",	sum(BY.pIC(1:5,:) .* Out.alpha(1:5,:),"r")(3)];
["IC_Other_price - Gas_fuels",	sum(BY.pIC(6:23,:) .* Out.alpha(6:23,:),"r")(3)];
["Labour price - Gas_fuels",	sum(BY.pL .* Out.lambda,"r")(3)];
["Capital price - Gas_fuels",	sum(BY.pK .* Out.kappa, "r")(3)];
["Production tax - Gas_fuels",	(Out.Production_Tax_rate .* Out.pY')(3)];
["Markup rate - Gas_fuels",	(Out.markup_rate .* Out.pY')(3)];
////////////// 4 ////////////////////////////////////////////////////////////////////////////
["--- Decomposition pY - Solid_fuels ---",    ""];..
["IC_Energy_price - Solid_fuels",	sum(Out.pIC(1:5,:) .* Out.alpha(1:5,:),"r")(4)];
["IC_Other_price - Solid_fuels",	sum(Out.pIC(6:23,:) .* Out.alpha(6:23,:),"r")(4)];
["Labour price - Solid_fuels",	sum(Out.pL .* Out.lambda,"r")(4)];
["Capital price - Solid_fuels",	sum(Out.pK .* Out.kappa, "r")(4)];
["Production tax - Solid_fuels",	(Out.Production_Tax_rate .* Out.pY')(4)];
["Markup rate - Solid_fuels",	(Out.markup_rate .* Out.pY')(4)];
["--- Decomposition pY a prix constants - Solid_fuels ---",    ""];..
["IC_Energy_price - Solid_fuels",	sum(BY.pIC(1:5,:) .* Out.alpha(1:5,:),"r")(4)];
["IC_Other_price - Solid_fuels",	sum(BY.pIC(6:23,:) .* Out.alpha(6:23,:),"r")(4)];
["Labour price - Solid_fuels",	sum(BY.pL .* Out.lambda,"r")(4)];
["Capital price - Solid_fuels",	sum(BY.pK .* Out.kappa, "r")(4)];
["Production tax - Solid_fuels",	(Out.Production_Tax_rate .* Out.pY')(4)];
["Markup rate - Solid_fuels",	(Out.markup_rate .* Out.pY')(4)];
////////////// 5 ////////////////////////////////////////////////////////////////////////////
["--- Decomposition pY - Elec_heating ---",    ""];..
["IC_Energy_price - Elec_heating",	sum(Out.pIC(1:5,:) .* Out.alpha(1:5,:),"r")(5)];
["IC_Other_price - Elec_heating",	sum(Out.pIC(6:6,:) .* Out.alpha(6:6,:),"r")(5)];
["Labour price - Elec_heating",	sum(Out.pL .* Out.lambda,"r")(5)];
["Capital price - Elec_heating",	sum(Out.pK .* Out.kappa, "r")(5)];
["Production tax - Elec_heating",	(Out.Production_Tax_rate .* Out.pY')(5)];
["Markup rate - Elec_heating",	(Out.markup_rate .* Out.pY')(5)]
["--- Decomposition pY a prix constants - Elec_heating ---",    ""];..
["IC_Energy_price - Elec_heating",	sum(BY.pIC(1:5,:) .* Out.alpha(1:5,:),"r")(5)];
["IC_Other_price - Elec_heating",	sum(BY.pIC(6:6,:) .* Out.alpha(6:6,:),"r")(5)];
["Labour price - Elec_heating",	sum(BY.pL .* Out.lambda,"r")(5)];
["Capital price - Elec_heating",	sum(BY.pK .* Out.kappa, "r")(5)];
["Production tax - Elec_heating",	(Out.Production_Tax_rate .* Out.pY')(5)];
["Markup rate - Elec_heating",	(Out.markup_rate .* Out.pY')(5)]
////////////// 6 ////////////////////////////////////////////////////////////////////////////
["--- Decomposition pY - Steel_Iron ---",    ""];..
["IC_Energy_price - Steel_Iron",	sum(Out.pIC(1:5,:) .* Out.alpha(1:5,:),"r")(6)];
["IC_Other_price - Steel_Iron",	sum(Out.pIC(6:6,:) .* Out.alpha(6:6,:),"r")(6)];
["Labour price - Steel_Iron",	sum(Out.pL .* Out.lambda,"r")(6)];
["Capital price - Steel_Iron",	sum(Out.pK .* Out.kappa, "r")(6)];
["Production tax - Steel_Iron",	(Out.Production_Tax_rate .* Out.pY')(6)];
["Markup rate - Steel_Iron",	(Out.markup_rate .* Out.pY')(6)]
["--- Decomposition pY a prix constants - Steel_Iron ---",    ""];..
["IC_Energy_price - Steel_Iron",	sum(BY.pIC(1:5,:) .* Out.alpha(1:5,:),"r")(6)];
["IC_Other_price - Steel_Iron",	sum(BY.pIC(6:6,:) .* Out.alpha(6:6,:),"r")(6)];
["Labour price - Steel_Iron",	sum(BY.pL .* Out.lambda,"r")(6)];
["Capital price - Steel_Iron",	sum(BY.pK .* Out.kappa, "r")(6)];
["Production tax - Steel_Iron",	(Out.Production_Tax_rate .* Out.pY')(6)];
["Markup rate - Steel_Iron",	(Out.markup_rate .* Out.pY')(6)]
////////////// 7 ////////////////////////////////////////////////////////////////////////////
["--- Decomposition pY - NonFerrousMetals ---",    ""];..
["IC_Energy_price - NonFerrousMetals",	sum(Out.pIC(1:5,:) .* Out.alpha(1:5,:),"r")(7)];
["IC_Other_price - NonFerrousMetals",	sum(Out.pIC(6:7,:) .* Out.alpha(6:7,:),"r")(7)];
["Labour price - NonFerrousMetals",	sum(Out.pL .* Out.lambda,"r")(7)];
["Capital price - NonFerrousMetals",	sum(Out.pK .* Out.kappa, "r")(7)];
["Production tax - NonFerrousMetals",	(Out.Production_Tax_rate .* Out.pY')(7)];
["Markup rate - NonFerrousMetals",	(Out.markup_rate .* Out.pY')(7)]
["--- Decomposition pY a prix constants - NonFerrousMetals ---",    ""];..
["IC_Energy_price - NonFerrousMetals",	sum(BY.pIC(1:5,:) .* Out.alpha(1:5,:),"r")(7)];
["IC_Other_price - NonFerrousMetals",	sum(BY.pIC(6:7,:) .* Out.alpha(6:7,:),"r")(7)];
["Labour price - NonFerrousMetals",	sum(BY.pL .* Out.lambda,"r")(7)];
["Capital price - NonFerrousMetals",	sum(BY.pK .* Out.kappa, "r")(7)];
["Production tax - NonFerrousMetals",	(Out.Production_Tax_rate .* Out.pY')(7)];
["Markup rate - NonFerrousMetals",	(Out.markup_rate .* Out.pY')(7)]
////////////// 8 ////////////////////////////////////////////////////////////////////////////
["--- Decomposition pY - Cement ---",    ""];..
["IC_Energy_price - Cement",	sum(Out.pIC(1:5,:) .* Out.alpha(1:5,:),"r")(8)];
["IC_Other_price - Cement",	sum(Out.pIC(6:8,:) .* Out.alpha(6:8,:),"r")(8)];
["Labour price - Cement",	sum(Out.pL .* Out.lambda,"r")(8)];
["Capital price - Cement",	sum(Out.pK .* Out.kappa, "r")(8)];
["Production tax - Cement",	(Out.Production_Tax_rate .* Out.pY')(8)];
["Markup rate - Cement",	(Out.markup_rate .* Out.pY')(8)]
["--- Decomposition pY a prix constants - Cement ---",    ""];..
["IC_Energy_price - Cement",	sum(BY.pIC(1:5,:) .* Out.alpha(1:5,:),"r")(8)];
["IC_Other_price - Cement",	sum(BY.pIC(6:8,:) .* Out.alpha(6:8,:),"r")(8)];
["Labour price - Cement",	sum(BY.pL .* Out.lambda,"r")(8)];
["Capital price - Cement",	sum(BY.pK .* Out.kappa, "r")(8)];
["Production tax - Cement",	(Out.Production_Tax_rate .* Out.pY')(8)];
["Markup rate - Cement",	(Out.markup_rate .* Out.pY')(8)]
////////////// 9 ////////////////////////////////////////////////////////////////////////////
["--- Decomposition pY - OthMin ---",    ""];..
["IC_Energy_price - OthMin",	sum(Out.pIC(1:5,:) .* Out.alpha(1:5,:),"r")(9)];
["IC_Other_price - OthMin",	sum(Out.pIC(6:9,:) .* Out.alpha(6:9,:),"r")(9)];
["Labour price - OthMin",	sum(Out.pL .* Out.lambda,"r")(9)];
["Capital price - OthMin",	sum(Out.pK .* Out.kappa, "r")(9)];
["Production tax - OthMin",	(Out.Production_Tax_rate .* Out.pY')(9)];
["Markup rate - OthMin",	(Out.markup_rate .* Out.pY')(9)]
["--- Decomposition pY a prix constants - OthMin ---",    ""];..
["IC_Energy_price - OthMin",	sum(BY.pIC(1:5,:) .* Out.alpha(1:5,:),"r")(9)];
["IC_Other_price - OthMin",	sum(BY.pIC(6:9,:) .* Out.alpha(6:9,:),"r")(9)];
["Labour price - OthMin",	sum(BY.pL .* Out.lambda,"r")(9)];
["Capital price - OthMin",	sum(BY.pK .* Out.kappa, "r")(9)];
["Production tax - OthMin",	(Out.Production_Tax_rate .* Out.pY')(9)];
["Markup rate - OthMin",	(Out.markup_rate .* Out.pY')(9)]
////////////// 10 ////////////////////////////////////////////////////////////////////////////
["--- Decomposition pY - ChemicalPharma ---",    ""];..
["IC_Energy_price - ChemicalPharma",	sum(Out.pIC(1:5,:) .* Out.alpha(1:5,:),"r")(10)];
["IC_Other_price - ChemicalPharma",	sum(Out.pIC(6:10,:) .* Out.alpha(6:10,:),"r")(10)];
["Labour price - ChemicalPharma",	sum(Out.pL .* Out.lambda,"r")(10)];
["Capital price - ChemicalPharma",	sum(Out.pK .* Out.kappa, "r")(10)];
["Production tax - ChemicalPharma",	(Out.Production_Tax_rate .* Out.pY')(10)];
["Markup rate - ChemicalPharma",	(Out.markup_rate .* Out.pY')(10)]
["--- Decomposition pY a prix constants - ChemicalPharma ---",    ""];..
["IC_Energy_price - ChemicalPharma",	sum(BY.pIC(1:5,:) .* Out.alpha(1:5,:),"r")(10)];..
["IC_Other_price - ChemicalPharma",	sum(BY.pIC(6:10,:) .* Out.alpha(6:10,:),"r")(10)];..
["Labour price - ChemicalPharma",	sum(BY.pL .* Out.lambda,"r")(10)];..
["Capital price - ChemicalPharma",	sum(BY.pK .* Out.kappa, "r")(10)];..
["Production tax - ChemicalPharma",	(Out.Production_Tax_rate .* Out.pY')(10)];..
["Markup rate - ChemicalPharma",	(Out.markup_rate .* Out.pY')(10)];..
////////////// 11 ////////////////////////////////////////////////////////////////////////////
["--- Decomposition pY - Paper ---",    ""];..
["IC_Energy_price - Paper",	sum(Out.pIC(1:5,:) .* Out.alpha(1:5,:),"r")(11)];
["IC_Other_price - Paper",	sum(Out.pIC(6:11,:) .* Out.alpha(6:11,:),"r")(11)];
["Labour price - Paper",	sum(Out.pL .* Out.lambda,"r")(11)];
["Capital price - Paper",	sum(Out.pK .* Out.kappa, "r")(11)];
["Production tax - Paper",	(Out.Production_Tax_rate .* Out.pY')(11)];
["Markup rate - Paper",	(Out.markup_rate .* Out.pY')(11)]
["--- Decomposition pY a prix constants - Paper ---",    ""];..
["IC_Energy_price - Paper",	sum(BY.pIC(1:5,:) .* Out.alpha(1:5,:),"r")(11)];
["IC_Other_price - Paper",	sum(BY.pIC(6:11,:) .* Out.alpha(6:11,:),"r")(11)];
["Labour price - Paper",	sum(BY.pL .* Out.lambda,"r")(11)];
["Capital price - Paper",	sum(BY.pK .* Out.kappa, "r")(11)];
["Production tax - Paper",	(Out.Production_Tax_rate .* Out.pY')(11)];
["Markup rate - Paper",	(Out.markup_rate .* Out.pY')(11)]
////////////// 12 ////////////////////////////////////////////////////////////////////////////
["--- Decomposition pY - Auto_indus ---",    ""];..
["IC_Energy_price - Auto_indus",	sum(Out.pIC(1:5,:) .* Out.alpha(1:5,:),"r")(12)];
["IC_Other_price - Auto_indus",	sum(Out.pIC(6:12,:) .* Out.alpha(6:12,:),"r")(12)];
["Labour price - Auto_indus",	sum(Out.pL .* Out.lambda,"r")(12)];
["Capital price - Auto_indus",	sum(Out.pK .* Out.kappa, "r")(12)];
["Production tax - Auto_indus",	(Out.Production_Tax_rate .* Out.pY')(12)];
["Markup rate - Auto_indus",	(Out.markup_rate .* Out.pY')(12)]
["--- Decomposition pY a prix constants - Auto_indus ---",    ""];..
["IC_Energy_price - Auto_indus",	sum(BY.pIC(1:5,:) .* Out.alpha(1:5,:),"r")(12)];
["IC_Other_price - Auto_indus",	sum(BY.pIC(6:12,:) .* Out.alpha(6:12,:),"r")(12)];
["Labour price - Auto_indus",	sum(BY.pL .* Out.lambda,"r")(12)];
["Capital price - Auto_indus",	sum(BY.pK .* Out.kappa, "r")(12)];
["Production tax - Auto_indus",	(Out.Production_Tax_rate .* Out.pY')(12)];
["Markup rate - Auto_indus",	(Out.markup_rate .* Out.pY')(12)]
////////////// 13 ////////////////////////////////////////////////////////////////////////////
["--- Decomposition pY - OthEquip ---",    ""];..
["IC_Energy_price - OthEquip",	sum(Out.pIC(1:5,:) .* Out.alpha(1:5,:),"r")(13)];
["IC_Other_price - OthEquip",	sum(Out.pIC(6:13,:) .* Out.alpha(6:13,:),"r")(13)];
["Labour price - OthEquip",	sum(Out.pL .* Out.lambda,"r")(13)];
["Capital price - OthEquip",	sum(Out.pK .* Out.kappa, "r")(13)];
["Production tax - OthEquip",	(Out.Production_Tax_rate .* Out.pY')(13)];
["Markup rate - OthEquip",	(Out.markup_rate .* Out.pY')(13)]
["--- Decomposition pY a prix constants - OthEquip ---",    ""];..
["IC_Energy_price - OthEquip",	sum(BY.pIC(1:5,:) .* Out.alpha(1:5,:),"r")(13)];
["IC_Other_price - OthEquip",	sum(BY.pIC(6:13,:) .* Out.alpha(6:13,:),"r")(13)];
["Labour price - OthEquip",	sum(BY.pL .* Out.lambda,"r")(13)];
["Capital price - OthEquip",	sum(BY.pK .* Out.kappa, "r")(13)];
["Production tax - OthEquip",	(Out.Production_Tax_rate .* Out.pY')(13)];
["Markup rate - OthEquip",	(Out.markup_rate .* Out.pY')(13)]
////////////// 14 ////////////////////////////////////////////////////////////////////////////
["--- Decomposition pY - Electronics ---",    ""];..
["IC_Energy_price - Electronics",	sum(Out.pIC(1:5,:) .* Out.alpha(1:5,:),"r")(14)];
["IC_Other_price - Electronics",	sum(Out.pIC(6:14,:) .* Out.alpha(6:14,:),"r")(14)];
["Labour price - Electronics",	sum(Out.pL .* Out.lambda,"r")(14)];
["Capital price - Electronics",	sum(Out.pK .* Out.kappa, "r")(14)];
["Production tax - Electronics",	(Out.Production_Tax_rate .* Out.pY')(14)];
["Markup rate - Electronics",	(Out.markup_rate .* Out.pY')(14)]
["--- Decomposition pY a prix constants - Electronics ---",    ""];..
["IC_Energy_price - Electronics",	sum(BY.pIC(1:5,:) .* Out.alpha(1:5,:),"r")(14)];
["IC_Other_price - Electronics",	sum(BY.pIC(6:14,:) .* Out.alpha(6:14,:),"r")(14)];
["Labour price - Electronics",	sum(BY.pL .* Out.lambda,"r")(14)];
["Capital price - Electronics",	sum(BY.pK .* Out.kappa, "r")(14)];
["Production tax - Electronics",	(Out.Production_Tax_rate .* Out.pY')(14)];
["Markup rate - Electronics",	(Out.markup_rate .* Out.pY')(14)]
////////////// 15 ////////////////////////////////////////////////////////////////////////////
["--- Decomposition pY - Food_industry ---",    ""];..
["IC_Energy_price - Food_industry",	sum(Out.pIC(1:5,:) .* Out.alpha(1:5,:),"r")(15)];
["IC_Other_price - Food_industry",	sum(Out.pIC(6:15,:) .* Out.alpha(6:15,:),"r")(15)];
["Labour price - Food_industry",	sum(Out.pL .* Out.lambda,"r")(15)];
["Capital price - Food_industry",	sum(Out.pK .* Out.kappa, "r")(15)];
["Production tax - Food_industry",	(Out.Production_Tax_rate .* Out.pY')(15)];
["Markup rate - Food_industry",	(Out.markup_rate .* Out.pY')(15)]
["--- Decomposition pY a prix constants - Food_industry ---",    ""];..
["IC_Energy_price - Food_industry",	sum(BY.pIC(1:5,:) .* Out.alpha(1:5,:),"r")(15)];
["IC_Other_price - Food_industry",	sum(BY.pIC(6:15,:) .* Out.alpha(6:15,:),"r")(15)];
["Labour price - Food_industry",	sum(BY.pL .* Out.lambda,"r")(15)];
["Capital price - Food_industry",	sum(BY.pK .* Out.kappa, "r")(15)];
["Production tax - Food_industry",	(Out.Production_Tax_rate .* Out.pY')(15)];
["Markup rate - Food_industry",	(Out.markup_rate .* Out.pY')(15)]
////////////// 16 ////////////////////////////////////////////////////////////////////////////
["--- Decomposition pY - OthManuf ---",    ""];..
["IC_Energy_price - OthManuf",	sum(Out.pIC(1:5,:) .* Out.alpha(1:5,:),"r")(16)];
["IC_Other_price - OthManuf",	sum(Out.pIC(6:16,:) .* Out.alpha(6:16,:),"r")(16)];
["Labour price - OthManuf",	sum(Out.pL .* Out.lambda,"r")(16)];
["Capital price - OthManuf",	sum(Out.pK .* Out.kappa, "r")(16)];
["Production tax - OthManuf",	(Out.Production_Tax_rate .* Out.pY')(16)];
["Markup rate - OthManuf",	(Out.markup_rate .* Out.pY')(16)]
["--- Decomposition pY a prix constants - OthManuf ---",    ""];..
["IC_Energy_price - OthManuf",	sum(BY.pIC(1:5,:) .* Out.alpha(1:5,:),"r")(16)];
["IC_Other_price - OthManuf",	sum(BY.pIC(6:16,:) .* Out.alpha(6:16,:),"r")(16)];
["Labour price - OthManuf",	sum(BY.pL .* Out.lambda,"r")(16)];
["Capital price - OthManuf",	sum(BY.pK .* Out.kappa, "r")(16)];
["Production tax - OthManuf",	(Out.Production_Tax_rate .* Out.pY')(16)];
["Markup rate - OthManuf",	(Out.markup_rate .* Out.pY')(16)]
////////////// 17 ////////////////////////////////////////////////////////////////////////////
["--- Decomposition pY - LandTransp ---",    ""];..
["IC_Energy_price - LandTransp",	sum(Out.pIC(1:5,:) .* Out.alpha(1:5,:),"r")(17)];
["IC_Other_price - LandTransp",	sum(Out.pIC(6:17,:) .* Out.alpha(6:17,:),"r")(17)];
["Labour price - LandTransp",	sum(Out.pL .* Out.lambda,"r")(17)];
["Capital price - LandTransp",	sum(Out.pK .* Out.kappa, "r")(17)];
["Production tax - LandTransp",	(Out.Production_Tax_rate .* Out.pY')(17)];
["Markup rate - LandTransp",	(Out.markup_rate .* Out.pY')(17)]
["--- Decomposition pY a prix constants - LandTransp ---",    ""];..
["IC_Energy_price - LandTransp",	sum(BY.pIC(1:5,:) .* Out.alpha(1:5,:),"r")(17)];
["IC_Other_price - LandTransp",	sum(BY.pIC(6:17,:) .* Out.alpha(6:17,:),"r")(17)];
["Labour price - LandTransp",	sum(BY.pL .* Out.lambda,"r")(17)];
["Capital price - LandTransp",	sum(BY.pK .* Out.kappa, "r")(17)];
["Production tax - LandTransp",	(Out.Production_Tax_rate .* Out.pY')(17)];
["Markup rate - LandTransp",	(Out.markup_rate .* Out.pY')(17)]
////////////// 18 ////////////////////////////////////////////////////////////////////////////
["--- Decomposition pY - NavalTransp ---",    ""];..
["IC_Energy_price - NavalTransp",	sum(Out.pIC(1:5,:) .* Out.alpha(1:5,:),"r")(18)];
["IC_Other_price - NavalTransp",	sum(Out.pIC(6:18,:) .* Out.alpha(6:18,:),"r")(18)];
["Labour price - NavalTransp",	sum(Out.pL .* Out.lambda,"r")(18)];
["Capital price - NavalTransp",	sum(Out.pK .* Out.kappa, "r")(18)];
["Production tax - NavalTransp",	(Out.Production_Tax_rate .* Out.pY')(18)];
["Markup rate - NavalTransp",	(Out.markup_rate .* Out.pY')(18)]
["--- Decomposition pY a prix constants - NavalTransp ---",    ""];..
["IC_Energy_price - NavalTransp",	sum(BY.pIC(1:5,:) .* Out.alpha(1:5,:),"r")(18)];
["IC_Other_price - NavalTransp",	sum(BY.pIC(6:18,:) .* Out.alpha(6:18,:),"r")(18)];
["Labour price - NavalTransp",	sum(BY.pL .* Out.lambda,"r")(18)];
["Capital price - NavalTransp",	sum(BY.pK .* Out.kappa, "r")(18)];
["Production tax - NavalTransp",	(Out.Production_Tax_rate .* Out.pY')(18)];
["Markup rate - NavalTransp",	(Out.markup_rate .* Out.pY')(18)]
////////////// 19 ////////////////////////////////////////////////////////////////////////////
["--- Decomposition pY - AirTransp ---",    ""];..
["IC_Energy_price - AirTransp",	sum(Out.pIC(1:5,:) .* Out.alpha(1:5,:),"r")(19)];
["IC_Other_price - AirTransp",	sum(Out.pIC(6:19,:) .* Out.alpha(6:19,:),"r")(19)];
["Labour price - AirTransp",	sum(Out.pL .* Out.lambda,"r")(19)];
["Capital price - AirTransp",	sum(Out.pK .* Out.kappa, "r")(19)];
["Production tax - AirTransp",	(Out.Production_Tax_rate .* Out.pY')(19)];
["Markup rate - AirTransp",	(Out.markup_rate .* Out.pY')(19)]
["--- Decomposition pY a prix constants - AirTransp ---",    ""];..
["IC_Energy_price - AirTransp",	sum(BY.pIC(1:5,:) .* Out.alpha(1:5,:),"r")(19)];
["IC_Other_price - AirTransp",	sum(BY.pIC(6:19,:) .* Out.alpha(6:19,:),"r")(19)];
["Labour price - AirTransp",	sum(BY.pL .* Out.lambda,"r")(19)];
["Capital price - AirTransp",	sum(BY.pK .* Out.kappa, "r")(19)];
["Production tax - AirTransp",	(Out.Production_Tax_rate .* Out.pY')(19)];
["Markup rate - AirTransp",	(Out.markup_rate .* Out.pY')(19)]
////////////// 20 ////////////////////////////////////////////////////////////////////////////
["--- Decomposition pY - AgriForest_Fish ---",    ""];..
["IC_Energy_price - AgriForest_Fish",	sum(Out.pIC(1:5,:) .* Out.alpha(1:5,:),"r")(20)];
["IC_Other_price - AgriForest_Fish",	sum(Out.pIC(6:20,:) .* Out.alpha(6:20,:),"r")(20)];
["Labour price - AgriForest_Fish",	sum(Out.pL .* Out.lambda,"r")(20)];
["Capital price - AgriForest_Fish",	sum(Out.pK .* Out.kappa, "r")(20)];
["Production tax - AgriForest_Fish",	(Out.Production_Tax_rate .* Out.pY')(20)];
["Markup rate - AgriForest_Fish",	(Out.markup_rate .* Out.pY')(20)]
["--- Decomposition pY a prix constants - AgriForest_Fish ---",    ""];..
["IC_Energy_price - AgriForest_Fish",	sum(BY.pIC(1:5,:) .* Out.alpha(1:5,:),"r")(20)];
["IC_Other_price - AgriForest_Fish",	sum(BY.pIC(6:20,:) .* Out.alpha(6:20,:),"r")(20)];
["Labour price - AgriForest_Fish",	sum(BY.pL .* Out.lambda,"r")(20)];
["Capital price - AgriForest_Fish",	sum(BY.pK .* Out.kappa, "r")(20)];
["Production tax - AgriForest_Fish",	(Out.Production_Tax_rate .* Out.pY')(20)];
["Markup rate - AgriForest_Fish",	(Out.markup_rate .* Out.pY')(20)]
////////////// 21 ////////////////////////////////////////////////////////////////////////////
["--- Decomposition pY - Construction ---",    ""];..
["IC_Energy_price - Construction",	sum(Out.pIC(1:5,:) .* Out.alpha(1:5,:),"r")(21)];
["IC_Other_price - Construction",	sum(Out.pIC(6:21,:) .* Out.alpha(6:21,:),"r")(21)];
["Labour price - Construction",	sum(Out.pL .* Out.lambda,"r")(21)];
["Capital price - Construction",	sum(Out.pK .* Out.kappa, "r")(21)];
["Production tax - Construction",	(Out.Production_Tax_rate .* Out.pY')(21)];
["Markup rate - Construction",	(Out.markup_rate .* Out.pY')(21)]
["--- Decomposition pY a prix constants - Construction ---",    ""];..
["IC_Energy_price - Construction",	sum(BY.pIC(1:5,:) .* Out.alpha(1:5,:),"r")(21)];
["IC_Other_price - Construction",	sum(BY.pIC(6:21,:) .* Out.alpha(6:21,:),"r")(21)];
["Labour price - Construction",	sum(BY.pL .* Out.lambda,"r")(21)];
["Capital price - Construction",	sum(BY.pK .* Out.kappa, "r")(21)];
["Production tax - Construction",	(Out.Production_Tax_rate .* Out.pY')(21)];
["Markup rate - Construction",	(Out.markup_rate .* Out.pY')(21)]
////////////// 22 ////////////////////////////////////////////////////////////////////////////
["--- Decomposition pY - Property_business ---",    ""];..
["IC_Energy_price - Property_business",	sum(Out.pIC(1:5,:) .* Out.alpha(1:5,:),"r")(22)];
["IC_Other_price - Property_business",	sum(Out.pIC(6:22,:) .* Out.alpha(6:22,:),"r")(22)];
["Labour price - Property_business",	sum(Out.pL .* Out.lambda,"r")(22)];
["Capital price - Property_business",	sum(Out.pK .* Out.kappa, "r")(22)];
["Production tax - Property_business",	(Out.Production_Tax_rate .* Out.pY')(22)];
["Markup rate - Property_business",	(Out.markup_rate .* Out.pY')(22)]
["--- Decomposition pY a prix constants - Property_business ---",    ""];..
["IC_Energy_price - Property_business",	sum(BY.pIC(1:5,:) .* Out.alpha(1:5,:),"r")(22)];
["IC_Other_price - Property_business",	sum(BY.pIC(6:22,:) .* Out.alpha(6:22,:),"r")(22)];
["Labour price - Property_business",	sum(BY.pL .* Out.lambda,"r")(22)];
["Capital price - Property_business",	sum(BY.pK .* Out.kappa, "r")(22)];
["Production tax - Property_business",	(Out.Production_Tax_rate .* Out.pY')(22)];
["Markup rate - Property_business",	(Out.markup_rate .* Out.pY')(22)]
////////////// 23 ////////////////////////////////////////////////////////////////////////////
["--- Decomposition pY - Compo ---",    ""];..
["IC_Energy_price - Compo",	sum(Out.pIC(1:5,:) .* Out.alpha(1:5,:),"r")(23)];
["IC_Other_price - Compo",	sum(Out.pIC(6:23,:) .* Out.alpha(6:23,:),"r")(23)];
["Labour price - Compo",	sum(Out.pL .* Out.lambda,"r")(23)];
["Capital price - Compo",	sum(Out.pK .* Out.kappa, "r")(23)];
["Production tax - Compo",	(Out.Production_Tax_rate .* Out.pY')(23)];
["Markup rate - Compo",	(Out.markup_rate .* Out.pY')(23)]
["--- Decomposition pY a prix constants - Compo ---",    ""];..
["IC_Energy_price - Compo",	sum(BY.pIC(1:5,:) .* Out.alpha(1:5,:),"r")(23)];
["IC_Other_price - Compo",	sum(BY.pIC(6:23,:) .* Out.alpha(6:23,:),"r")(23)];
["Labour price - Compo",	sum(BY.pL .* Out.lambda,"r")(23)];
["Capital price - Compo",	sum(BY.pK .* Out.kappa, "r")(23)];
["Production tax - Compo",	(Out.Production_Tax_rate .* Out.pY')(23)];
["Markup rate - Compo",	(Out.markup_rate .* Out.pY')(23)]
////////////// 23 ////////////////////////////////////////////////////////////////////////////
["CPI",	(Out.CPI )];
["MPI",	(Out.MPI )];
["REER", (Out.CPI / Out.MPI)];
["Real I without constraint",    money_disp_adj.*(sum(Out.I_value) - sum(Out.I_value(:,5)) - Out.I_value(12,17) - Out.I_value(12,23) - Out.I_value(21,17) - Out.I_value(21,22) - Out.I_value(21,23))  / I_pFish];..
];



OutputTable("Summary_"+ref_name)=[["Variables",    "values_"+Name_time];..
["--- Real terms at "+money_disp_unit+money+" "+ref_name+") ---",    ""];..
["Population",	Out.Population];..
["Natural growth",    Out.GDP_index];..
["Labour productivity (1 + Mu)^time_since_BY",    (1+Out.Mu)^Out.time_since_BY];..
["Real GDP",    money_disp_adj.*Out.GDP/GDP_pFish];..
["Non-energy output",    sum(Out.Y(Indice_NonEnerSect))];..
["Energy output",    sum(Out.Y(Indice_EnerSect))];..
["Non-energy consumption (C+G)",    sum(Out.C(Indice_NonEnerSect,:)) + sum(Out.G(Indice_NonEnerSect,:))];..
["Energy consumption (C + IC except energy) (ktoe)",    sum(Out.C(Indice_EnerSect,:)) + sum(Out.IC(Indice_EnerSect,Indice_NonEnerSect))];..
["Households Energy consumption (ktoe)",    sum(Out.C(Indice_EnerSect,:))];..
["Households Energy consumption (Millions of euro)",    money_disp_adj*sum(Out.C_value(Indice_EnerSect,:))];..
["Households Non-energy consumption (pseudoquantities)",    sum(Out.C(Indice_NonEnerSect,:))];..
["Unemployment rate",    Out.u_tot*100];..
["Unemployment transfers",    money_disp_adj*Out.Unemployment_transfers(Indice_Households)];..
["Real Net-of-tax wages",    Out.omega/Out.CPI];..
["H_Labour_Income",    money_disp_adj*Out.NetCompWages_byAgent(3)];..
["H_Non_Labour_Income",    money_disp_adj*Out.GOS_byAgent(3)];.. 
["Pensions",    money_disp_adj*Out.Pensions(3)];..
["Volume of investment",    sum(Out.I)];..
["CPI (pC pFish)",    Out.CPI];..
["Emissions - MtCO2",    Out.DOM_CO2];..
["Ratio real I / real PIB",    sum(Out.I_value)/I_pFish / (Out.GDP/GDP_pFish)];..
["Ratio real G / real PIB",    sum(Out.G_value)/G_pFish / (Out.GDP/GDP_pFish)];..
["Ratio real C / real PIB",    sum(Out.C_value)/Out.CPI / (Out.GDP/GDP_pFish)];..
["Ratio I / PIB (nominal)",    sum(Out.I_value) / Out.GDP ];..
["Ratio G / PIB (nominal)",    sum(Out.G_value) / Out.GDP ];..
["Ratio C / PIB (nominal)",    sum(Out.C_value) / Out.GDP ];..
["Ratio X-M / PIB (nominal)",    (sum(Out.X_value) - sum(Out.M_value)) / Out.GDP ];..
["Real C",    money_disp_adj.*sum(Out.C_value)/Out.CPI];..
["Real G",    money_disp_adj.*sum(Out.G_value)/G_pFish];..
["Real I",    money_disp_adj.*sum(Out.I_value)/I_pFish];..
["Real X",    money_disp_adj.*sum(Out.X_value)/X_pFish];..
["Real M",    money_disp_adj.*sum(Out.M_value)/M_pFish];..
["--- Divers ---",    ""];..
["Emissions - MtCO2",    Out.DOM_CO2];..
["Emissions - %/"+ref_name,    (evol_ref.DOM_CO2-1)*100];..
["C - Energy - ktoe",    sum(Out.C(Indice_EnerSect,:))];..
["IC except for energy production - Energy ktoe",    sum(Out.IC(Indice_EnerSect,Indice_NonEnerSect))];..
["IC for energy production - Energy ktoe",    sum(Out.IC(Indice_EnerSect,Indice_EnerSect))];..
["Nominal carbon tax on C ("+money_disp_unit+money+")",    money_disp_adj.*sum(Out.Carbon_Tax_C)];..
["Nominal carbon tax on IC ("+money_disp_unit+money+")",    money_disp_adj.*sum(Out.Carbon_Tax_IC)];..
["Real Y",    money_disp_adj.*sum(Out.Y_value)/Y_pFish];..
["Labour Tax Cut",    -Out.Labour_Tax_Cut];..
["Carbon Tax rate-"+money+"/tCO2",    (Out.Carbon_Tax_rate*evstr(money_unit_data))/10^6];..
["Energy Tax "+money_disp_unit+money,    (sum(Out.Energy_Tax_FC) + sum(Out.Energy_Tax_IC)).*money_disp_adj];..
["Labour productivity ",    parameters.Mu];..
["GDP Decomposition Laspeyres Quantities",    ""];..
["Real GDP LaspQ ratio/"+ref_name,    GDP_qLasp];..
["GDP Decomp - C",    (sum(ref.C_value)/ref.GDP) * C_qLasp];..
["GDP Decomp - G",    (sum(ref.G_value)/ref.GDP) * G_qLasp];..
["GDP Decomp - I",    (sum(ref.I_value)/ref.GDP) * I_qLasp];..
["GDP Decomp - X",    (sum(ref.X_value)/ref.GDP) * X_qLasp];..
["GDP Decomp - M",    (sum(ref.M_value)/ref.GDP) * M_qLasp];
];


if Capital_Dynamics
OutputTable("FullTemplate_"+ref_name)=[OutputTable("FullTemplate_"+ref_name);
["---Capital Stock ---",    ""];..
["Capital Endowment",    money_disp_adj.*Out.Capital_endowment];..
[string("Capital Cons - "+ Index_Sectors),    money_disp_adj.*Out.Capital_consumption'];..
[string("Real I - "+ Index_Sectors(ind_Inv)),	money_disp_adj.*sum(Out.I_value(ind_Inv,:),"c")./evstr("I_"+Index_Sectors(ind_Inv)+"_pFish")	];..
[string("Volume I - "+ Index_Sectors(ind_Inv)),	money_disp_adj.*sum(Out.I(ind_Inv,:),"c")];..
];
end

if Capital_Dynamics
OutputTable("FullTemplate_"+ref_name)=[OutputTable("FullTemplate_"+ref_name);
["---Capital consumption if U exo (if not,should be equal)--",    ""];..
["Capital Consumption",    money_disp_adj.*sum(Out.kappa.*Out.Y')];..
["Diff K Consumption and inventory in %",	((sum(Out.kappa.*Out.Y') - Out.Capital_endowment ) / Out.Capital_endowment)*100];..
];
end

/// for MacroIncertitudes

if Scenario=="TEND" | Scenario=="S2" | Scenario=="S3" | Scenario=="S2test" | Scenario=="S3test"
 OutputTable("FullTemplate_"+ref_name)=[OutputTable("FullTemplate_"+ref_name);
 ["---Macro Incertitudes ---",    ""];..
 ["VAR_sigma_MX",    VAR_sigma_MX	];..
// ["sigma_M",    max(Deriv_Exogenous.sigma_M)	];..
 ["sigma_X",	max(sigma_X)];..
 ["VAR_saving",    VAR_saving	];..
 ["Household_saving_rate",    Out.Household_saving_rate	];.. 
 ["VAR_Mu",    VAR_Mu];..
 ["Labour_productivity ",    parameters.Mu];..
 ["VAR_coef_real_wage",    VAR_coef_real_wage];..
 ["Real_wage_coeffient",    parameters.Coef_real_wage];..
 ["VAR_sigma_omegaU",    VAR_sigma_omegaU];..
 ["Sigma_wage_curve",    parameters.sigma_omegaU];..
 ["VAR_C_basic_need",    VAR_C_basic_need];..
 ["C_basic_need",    mean(parameters.ConstrainedShare_C)];..
 ["trade_drive",    trade_drive];..
 ["eq_G_ConsumpBudget",	eq_G_ConsumpBudget];..
 ["VAR_sigma_pC",	"NC"];..
 ["sigma_pC",	max(parameters.sigma_pC)];..
 ["VAR_sigma",	"NC"];..
 ["sigma",	max(sigma)];..
 ["VAR_import_enersect",	VAR_import_enersect];..
 ["VAR_population",	VAR_population];..
 ["Population",	Out.Population];..
 ["Labour_force",	Out.Labour_force];..
 ["VAR_emis",	"NC"];..
 ["	Energy in Households consumption",    ref.Ener_C_ValueShare*(C_En_qLasp-1)*100];.. 
 ["CPI",    Out.CPI];..
 ["Rexp",    Out.Consumption_budget];.. 
 ["H_disposable_income",    Out.H_disposable_income];..
 ["H_Labour_Income",    Out.NetCompWages_byAgent(3)];..
 ["H_Non_Labour_Income",    Out.GOS_byAgent(3)];.. 
 ["Pensions",    Out.Pensions(3)];..
 ["Unemployment_transfers",    Out.Unemployment_transfers(3)];.. 
 ["Other_social_transfers",    Out.Other_social_transfers(3)];..
 ["Other_Transfers",    Out.Other_Transfers(3)];.. 
 ["ClimPolicyCompens",    Out.ClimPolicyCompens(3)];..
 ["Property_income",    Out.Property_income(3)];..
 ["Income_Tax",    Out.Income_Tax(3)];.. 
 ["Other_Direct_Tax",    Out.Other_Direct_Tax(3)];..
 ["GDP_pLasp",    GDP_pLasp];.. 
 ["GDP_pPaas",    GDP_pPaas];..
 ["pc*C",    sum(Out.pC.*ref.C)];..
 ["pG*G",    sum(Out.pG.*ref.G)];..
 ["pI*I",    sum(Out.pI.*ref.I)];..
 ["pX*X",    sum(Out.pX.*ref.X)];..
 ["pM*M",    sum(Out.pM.*ref.M)];..
 ["proj_alpha",    proj_alpha];.. 
 ["proj_c",    proj_c];.. 
 ["proj_kappa",    proj_kappa];.. 
// ["H_Other_Income",    Out.H_Other_Income];.. 
// ["H_Property_income",    Out.H_Property_income];..
// ["H_Tax_Payments",Income_Tax + Other_Direct_Tax];.. 
 // ["Labour Productivity",    parameters.Mu];..
 // //["Labour Productivity_"+Index_EnerSect,    parameters.phi_L(:,Indice_EnerSect)'];..
 // //["Labour Productivity_"+Index_NonEnerSect,    parameters.phi_L(:,Indice_NonEnerSect)'];..
 // ["Prices Oil",    parameters.delta_pM_parameter(Indice_OilS)];..
 // ["Prices Gas",    parameters.delta_pM_parameter(Indice_GasS)	];..
 // ["Prices Coal",    parameters.delta_pM_parameter(Indice_CoalS)];..	
 // ["World Growth Level_"+Index_NonEnerSect,    parameters.delta_X_parameter(:,Indice_NonEnerSect)'];..
 // //["World Growth Level_"+Index_NonEnerSect,    sum(parameters.delta_X_parameter(:,Indice_NonEnerSect),"r")];..
 // ["Prices Oil/Gas/Coal Variation",    VAR_pM];..
 // ["World Growth Level Variation",    VAR_Growth	];..

];
end

// TOCLEAN
/// Temporary - to delete
if Country=="Brasil"&Scenario=="PMR_Ten"
OutputTable("FullTemplate_"+ref_name)=[OutputTable("FullTemplate_"+ref_name);
["---Y pseudo quantities --",    ""];..
["Yten_"+Index_Sectors,    Out.Y];..
["---Y objectif pseudo quantities --",    ""];..
["Yobj_"+Index_Sectors,    Y_obj.val];..
["---Yobj/Yten --",    ""];..
["RatioYobj/Yten"+Index_Sectors,    Y_obj.val./Out.Y];..
];
end


////////////////////////////////////////SPECIFIC CASES OUTPUT for country studies 
//FRANCE 
if Country == "France"
exec("outputs_indic_FRA.sce");
end



///Store BY (at the end for eventually completing the FullTemplate with specific indicators according to country studies
if Output_files
	if OutputfilesBY
 csvWrite(OutputTable("FullTemplate_"+ref_name),SAVEDIR+"FullTemplate_"+ref_name+"_"+Name_time+"_"+simu_name+".csv",    ';');
	elseif ~OutputfilesBY
 csvWrite(OutputTable("FullTemplate_"+ref_name),SAVEDIR_INIT+"FullTemplate_"+ref_name+"_"+Name_time+"_"+simu_name+".csv",    ';'); 
 // if Country=="Argentina"&time_step ==1
 // csvWrite(OutputTable("FullTemplate_"+ref_name),SAVEDIR+"FullTemplate_"+ref_name+"_"+ref_name+"_"+simu_name+".csv",    ';');
 // end
	end
end


// Creation of a fulltemplate with every time_step
// We store fulltemplate of each year in variables named fulltemplate_BY,    fulltemplate_1,    fulltemplate_2 etc.
// We then concatenate these variables in concatenation
if ~OutputfilesBY
 // Case of base year
 summary_BY = OutputTable("Summary_"+ref_name);
 fulltemplate_BY = OutputTable("FullTemplate_"+ref_name);
 G_budget_BY = OutputTable("G_budget_decomp_"+ref_name);

else
 for time_step_tmp = 1:Nb_Iter
 if time_step == time_step_tmp

 // Creation of fulltemplate_i
 fulltemplate = OutputTable('FullTemplate_'+ref_name);
 execstr ( "fulltemplate_" + time_step + " = fulltemplate");

 Summary = OutputTable('Summary_'+ref_name);
 execstr ( "Summary_" + time_step + " = Summary");

 G_budget = OutputTable('G_budget_decomp_'+ref_name);
 execstr ( "G_budget_" + time_step + " = G_budget");

 // If we are in the last time_step,    we concatenate the fulltemplates
 if time_step == Nb_Iter
 concatenation = fulltemplate_BY;
 concatenation_summary = summary_BY;
 concatenation_G_budget = G_budget_BY;
 i = 1;
 for j = 1:Nb_Iter
 
 // In order to skip 2035 in the case of SNBC 3
 if j == Time_step_non_etudie
 continue
 end
 execstr("concatenation(:,2+i) = fulltemplate_" + j + "(:,2)");
 execstr("concatenation_summary(:,2+i) = Summary_" + j + "(:,2)");
 execstr("concatenation_G_budget(:,2+i) = G_budget_" + j + "(:,2)");
 i = i+1;
 end
 
 // Save the concatenated fulltemplate
 // SAVEDIR_CONCAT = OUTPUT + runName + '\';
 csvWrite(concatenation,SAVEDIR_CONCAT+"\FullTemplate_"+simu_name+".csv", ';', ',');
 csvWrite(concatenation_summary,SAVEDIR_CONCAT+"\Summary_"+simu_name+".csv", ';', ',');
 csvWrite(concatenation_G_budget,SAVEDIR_CONCAT+"\G_budget_"+simu_name+".csv", ';', ',');
 end
 end
 end
end
