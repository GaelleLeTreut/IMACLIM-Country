disp("check GFCF(gov) constant in real term")
data_3.GFCF_byAgent(Indice_Government) - data_3.I_pFish*data_2.GFCF_byAgent(Indice_Government)

disp("check HH conso. constant in real term")
data_3.Consumption_budget - data_3.CPI*data_2.Consumption_budget

disp("check Gov conso. constant in real term")
data_3.G_Consumption_budget - data_3.G_pFish*data_2.G_Consumption_budget

disp("check Total invest. demand constant in real term")
sum(data_3.I.*data_3.pI) - data_3.I_pFish*sum(data_2.I.*data_2.pI)

// autres tests à faire avec la taxe carbone
// différentes options de taxes carbones à mettre en place
// test de chacun d'entre elle 
// run 
// envoi en précisant que c'est une version préliminaire

// pour les recyclages de la taxe : informer un taux de répartition exogène 
TEST_STR = "30Hybrid"
strsplit(TEST_STR)
strcat(strsplit(TEST_STR))




