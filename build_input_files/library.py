import os

import pandas as pd
import numpy as np

# build param files filled with 1.0
def build_and_save_parameters_files(agg_name, sectors, nb_HH, HH_category, params_dir):
	
	# set file list
	if agg_name != '':
		HH_params_file_list = [
			'CarbonTax_Diff_C_AGG_' + agg_name + '_' + 'H',	
			'ConstrainedShare_C_AGG_' + agg_name + '_' + 'H',
			'sigma_pC_AGG_' + agg_name + '_' + 'H'
			]
		sect_params_file_list = [
			'CarbonTax_Diff_IC_AGG_' + agg_name,
			'ConstrainedShare_IC_AGG_' + agg_name,	
			'phi_IC_AGG_' + agg_name
			]
	else:
		HH_params_file_list = [
			'CarbonTax_Diff_C' + '_' + 'H',
			'ConstrainedShare_C' + '_' + 'H', 
			'sigma_pC' + '_' + 'H'
			]
		sect_params_file_list = [
			'CarbonTax_Diff_IC' + agg_name,
			'params_sect' + agg_name,
			'phi_IC' + agg_name
			]

	# Set HH param files
	for count, HH_params_element in enumerate(HH_params_file_list):
		pd.DataFrame(1.0, index = sectors, columns = HH_category).to_csv(
			(params_dir + os.path.sep + HH_params_element + str(nb_HH) + '.csv'),';')
		pd.DataFrame(1.0, index = sectors, columns = ['HH1']).to_csv(
			(params_dir + os.path.sep + HH_params_element + 'H1' + '.csv'),';')

	# Set sect param files
	for count, sect_params_element in enumerate(sect_params_file_list):
		pd.DataFrame(1.0, index = sectors, columns = sectors).to_csv(
			(params_dir + os.path.sep + sect_params_element + '.csv'),';')

	return True

# built IOT_CO2Emis
def build_and_save_IOT_CO2Emis(sector_carac, data_dir):
	index = sector_carac[:,0].tolist()
	index.append('MtCO2')
	columns = sector_carac[:,0].tolist()
	columns.extend(['C', 'X'])
	pd.DataFrame(0, index = index, columns = columns).to_csv(
				(data_dir + os.path.sep + 'IOT_CO2Emis' + '.csv'),';')

	return True

# built IOT_Import_rate
def build_and_save_IOT_Import_rate(sector_carac, data_dir):

	index = sector_carac[:,0].tolist()
	columns = sector_carac[:,0].tolist()	
	columns.extend(['C', 'G', 'I', 'X'])
	pd.DataFrame(0.1, index = index, columns = columns).to_csv(
				(data_dir + os.path.sep + 'IOT_Import_rate' + '.csv'),';')

	return True

# built IOT_Prices and IOT_Qtities
def build_and_save_IOT_Prices_Qtities(sector_carac, data_dir):
	index_p = sector_carac[:,0].tolist()
	index_q = np.array(index_p).tolist()
	index_p.append('euro_per_toe')
	index_q.append('ktoe')
	columns = sector_carac[:,0].tolist()
	columns.extend(['C', 'G', 'I', 'X', 'Tot_uses', 'Y', 'M'])

	pd.DataFrame(0, index = index_p, columns = columns).to_csv(
				(data_dir + os.path.sep + 'IOT_Prices' + '.csv'),';')
	pd.DataFrame(0, index = index_q, columns = columns).to_csv(
				(data_dir + os.path.sep + 'IOT_Qtities' + '.csv'),';')

	return True

# built Labour
def build_and_save_IOT_Labour(sector_carac, data_dir):
	index = ['Labour', 'Thousand of Full-time equivalent']
	columns = sector_carac[:,0].tolist()
	pd.DataFrame(0, index = index, columns = columns).to_csv(
				(data_dir + os.path.sep + 'Labour' + '.csv'),';')

	return True

# build Index_IOT
def build_and_save_Index_IOT(agg_name, nb_HH, sector_carac, data_dir, FD, FD_HH, VA, M, Margins, SpeMarg, Taxes, HH_desag = False):

	# set HH data directory 
	data_HH_dir = data_dir + os.path.sep + 'H' + str(nb_HH)
	if not os.path.exists(data_HH_dir):
		os.makedirs(data_HH_dir)

	# set output file name
	if agg_name == '':
		if HH_desag == False:
			output_file_name = data_dir  + os.path.sep  + 'Index_IOTvalue.csv'
		else:
			output_file_name = data_HH_dir + os.path.sep  + 'Index_IOT_H' + str(nb_HH) + '.csv'
	else:
		if HH_desag == False:
			output_file_name = data_dir  + os.path.sep  + 'Index_IOT_AGG_' + agg_name + '.csv'
		else:
			output_file_name = data_HH_dir + os.path.sep  + 'Index_IOT_AGG_' + agg_name + '_' + 'H' + str(nb_HH) + '.csv'	

	# fill commodities
	IOT_index = np.insert(sector_carac, 1, "Commodities", axis = 1)

	# set OthPart_IOT name
	if agg_name == '':
		OthPart_IOT_name = 'OthPart_IOT'
	else:
		OthPart_IOT_name = 'OthPart_IOT_AGG'

	# fill VA
	for count, VA_comp in enumerate(VA):
		to_add = np.empty((1,6), dtype='U40')
		to_add[0][:] = np.array([VA_comp, OthPart_IOT_name, 'Value_Added', '-', '-', '-'], dtype='U40')
		IOT_index = np.append(IOT_index, to_add, axis=0)

	# fill M_value
	to_add[0][:] = np.array([M[0], OthPart_IOT_name, '-', '-', '-', '-'], dtype='U40')
	IOT_index = np.append(IOT_index, to_add, axis=0)

	# fill margins
	for count, marg_comp in enumerate(Margins):
		to_add[0][:] = np.array([marg_comp, OthPart_IOT_name, 'Margins', '-', '-', '-'], dtype='U40')
		IOT_index = np.append(IOT_index, to_add, axis=0)

	# fill spe margin for sectors
	for count, sector in enumerate(sector_carac[:,0].tolist()):
		to_add[0][:] = np.array([SpeMarg[0] + '_' + sector, OthPart_IOT_name, 'SpeMarg', 'SpeMarg_IC', '-', '-'], dtype='U40')
		IOT_index = np.append(IOT_index, to_add, axis=0)

	# fill spe margin for FD
	if HH_desag == False:
		for count, FD_elt in enumerate(FD): 
			to_add[0][:] = np.array([SpeMarg[0] + '_' + FD_elt, OthPart_IOT_name, 'SpeMarg', 'SpeMarg_FC', '-', '-'], dtype='U40')
			IOT_index = np.append(IOT_index, to_add, axis=0)
	else:
		for count, FD_elt in enumerate(FD_HH): 
			if count<nb_HH:
				to_add[0][:] = np.array([SpeMarg[0] + '_' + FD_elt, OthPart_IOT_name, 'SpeMarg', 'SpeMarg_FC', 'SpeMarg_C', '-'], dtype='U40')
			else:
				to_add[0][:] = np.array([SpeMarg[0] + '_' + FD_elt, OthPart_IOT_name, 'SpeMarg', 'SpeMarg_FC', '-', '-'], dtype='U40')
			IOT_index = np.append(IOT_index, to_add, axis=0)

	# fill spe margin for sectors
	for count, tax_comp in enumerate(Taxes):
		to_add[0][:] = np.array([tax_comp, OthPart_IOT_name, 'Taxes', '-', '-', '-'], dtype='U40')
		IOT_index = np.append(IOT_index, to_add, axis=0)

	# inset "Row" first columns
	IOT_index = np.insert(IOT_index, 0, "Row", axis = 1)

	# fill sectors
	to_add = np.empty((1,7), dtype='U40')
	for count, sector in enumerate(sector_carac[:,0].tolist()):
		to_add[0][:] = np.array(['Column', sector, 'Sectors', IOT_index[count][IOT_index.shape[1]-1], '-', '-', '-'], dtype='U40')
		IOT_index = np.append(IOT_index, to_add, axis=0)

	# fill FD
	if HH_desag == False:
		for count, FD_elt in enumerate(FD):
			to_add[0][:] = np.array(['Column', FD_elt, 'FC', '-', '-', '-', '-'], dtype='U40')
			IOT_index = np.append(IOT_index, to_add, axis=0)
	else:
		for count, FD_elt in enumerate(FD_HH): 
			if count<nb_HH:
				to_add[0][:] = np.array(['Column', FD_elt, 'FC', 'C', '-', '-', '-'], dtype='U40')
			else:
				to_add[0][:] = np.array(['Column', FD_elt, 'FC', '-', '-', '-', '-'], dtype='U40')
			IOT_index = np.append(IOT_index, to_add, axis=0)		

	# drop last column
	IOT_index = np.delete(IOT_index, IOT_index.shape[1]-1 ,axis=1)

	# insert first line for aggregation type
	if agg_name == '':
		IOT_index = np.insert(IOT_index, 0, ['Aggregation_type', '-', '-', '-', '-', '-'] , axis = 0)

	np.savetxt(output_file_name, IOT_index, fmt="%s", delimiter = ";")

	return IOT_index

# built IOT_val
def build_and_save_IOT_Val(IOT_Index, sector_carac, VA, Margins, FD, Taxes, Res, Uses, data_dir):

	index = IOT_Index
	index_size = 2*len(sector_carac[:,0].tolist()) + len(VA) + len(Margins) + 2*len(FD) + len(Taxes) - 2
	while (index.shape[0])!=index_size:
		index = np.delete(index, index_size, axis=0)

	index = np.delete(index,0,axis=1)
	index = np.delete(index,0,axis=0)

	while (index.shape[1])!=1:
		index = np.delete(index,1,axis=1)

	index = (np.transpose(index)).tolist()[0]
	index.extend(Res)
	index.append('thousand_of_euros')


	columns = sector_carac[:,0].tolist()
	columns.extend(FD)
	columns.extend(Uses)

	pd.DataFrame(0, index = index, columns = columns).to_csv(
				(data_dir + os.path.sep + 'IOT_Val' + '.csv'),';')


	return True

# built IOT_rate_Hx
def build_IOT_rate_Hx(data_dir, nb_HH, sectors, HH_category):

	# set HH data directory 
	data_HH_dir = data_dir + os.path.sep + 'H' + str(nb_HH)
	if not os.path.exists(data_HH_dir):
		os.makedirs(data_HH_dir)

	output_file = data_HH_dir + os.path.sep + 'IOT_rate_H' + str(nb_HH) + '.csv'

	pd.DataFrame(0.1, index = sectors, columns = HH_category).to_csv(
		output_file, ";")

	return True