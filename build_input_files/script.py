import pathlib
import os

import pandas as pd
import numpy as np

import library as lib

##########################
# set features 
##########################
# set HH names
nb_HH = 10

# set agg sector name
# agg_names = ['', 'EnComp', '4SecB']
agg_names = ['', '4SecB']

for agg_name in agg_names:

	##########################
	# set folders 
	##########################
	# data directory
	data_dir = 'data'
	if not os.path.exists(data_dir):
		os.makedirs(data_dir)

	# params directory
	if agg_name == '':
		params_dir = 'params'
	else:
		params_dir = 'params' + os.path.sep + 'AGG_' + agg_name
	if not os.path.exists(params_dir):
		os.makedirs(params_dir)

	# sector def directory 
	sect_def_dir = 'sector_definition'

	##########################
	# set iot component names
	##########################
	# set sector names and caracteristics  
	sector_carac = np.genfromtxt((sect_def_dir + os.path.sep + 'AGG_' + agg_name + '.csv'), dtype = 'U40', delimiter = ";")
	# 0 = sectors names
	# 1 = Ener/NonEner sect
	# 2 = Hybrid/NonHybrid Sect
	# 3 = Prim/Fin EnerSect
	# 4 = NonSupplierSect

	# set HH category names
	HH_category = [];
	for count in range(nb_HH):
		HH_category.append("H"+str(count+1))

	# set other IOT coponents
	FD 		= ['C', 'G', 'I', 'X']
	FD_HH   = np.array(HH_category).tolist()
	FD_HH.extend(['G', 'I', 'X'])
	VA = ['Labour_income', 'Labour_Tax', 'Capital_income', 'Production_Tax', 'Profit_margin']
	M = ['M_value']
	Margins = ['Trade_margins', 'Transp_margins'] 
	SpeMarg = ['SpeMarg']
	Taxes = ['VA_Tax', 'Energy_Tax_IC', 'Energy_Tax_FC', 'ClimPolCompensbySect', 'OtherIndirTax']
	Res = ['Tot_ressources']
	Uses = ['Tot_uses'] 

	##########################
	# build params files
	##########################
	lib.build_and_save_parameters_files(agg_name, sector_carac[:,0].tolist(), nb_HH, HH_category, params_dir)

	##########################
	# build data files
	##########################
	if agg_name == '':
		# built IOT_CO2Emis
		lib.build_and_save_IOT_CO2Emis(sector_carac, data_dir)

		# built IOT_Import_rate
		lib.build_and_save_IOT_Import_rate(sector_carac, data_dir)

		# built IOT_Prices and IOT_Qtities
		lib.build_and_save_IOT_Prices_Qtities(sector_carac, data_dir)

		# built Labour quantities
		lib.build_and_save_IOT_Labour(sector_carac, data_dir)

	# built Index_IOT
	IOT_Index = lib.build_and_save_Index_IOT(agg_name, nb_HH, sector_carac, data_dir, FD, FD_HH, VA, M, Margins, SpeMarg, Taxes, HH_desag = True)
	IOT_Index = lib.build_and_save_Index_IOT(agg_name, nb_HH, sector_carac, data_dir, FD, FD_HH, VA, M, Margins, SpeMarg, Taxes, HH_desag = False)

	if agg_name == '':
		# built IOT_val
		lib.build_and_save_IOT_Val(IOT_Index, sector_carac, VA, Margins, FD, Taxes, Res, Uses, data_dir)

		lib.build_IOT_rate_Hx(data_dir, nb_HH, sector_carac[:,0].tolist(), HH_category)