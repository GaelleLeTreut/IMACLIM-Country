# -*- coding: utf-8 -*-

import os
import csv

# String data

outputs_fold = 'To_Display/'
time_prefix = 'Time_'

def read_output_file(file_to_read):
    """Load the data of files to read from every *time* subfolder of 
    each output foldectory.
    
    file_to_read : *prefix* of a file to load."""

    def fold_name(out_fold):
        """Record the name of the output directory."""
        name = ''
        if 'name.txt' in os.listdir(out_fold):
            fichier = open(out_fold + 'name.txt', 'r')
            name = fichier.read()
            name = name.strip()
            fichier.close() 
        else:
            raise Exception('No field name.txt found')
        return name
    
    def is_time_out_folder(time):
        """Check if time begins with time_prefix."""
        return time[:len(time_prefix)] == time_prefix

    def load_data(file_to_read, time_path):
        """Return a dict of data contained in files of file_to_read."""
        
        def file_path(file_name, folder_path):
            """Path of the file beginning with file_name."""
            folder_files = os.listdir(folder_path)
            len_fname = len(file_name)
            for f in folder_files:
                if f[:len_fname] == file_name:
                   return folder_path + f
            raise Exception(file_name + ' is not a prefix of a file of ' \
                            + folder_path)

        def is_csv(file):
            """Check if file is a csv file."""
            csv_suffix = '.csv'
            return file[-len(csv_suffix):] == csv_suffix

        def remove_empty_line(csv_file):
            """Remove the empty line of csv_files."""
            non_empty = []
            for r in csv_file:
                # Check if r is empty
                is_empty = True
                for elt in r:
                    if len(elt) != 0:
                        is_empty = False
                        break

                if not is_empty:
                    non_empty.append(r)

            return non_empty
            
        # Record the content
        csv_path = file_path(file_to_read, time_path)
        if not is_csv(csv_path):
            raise Exception('For now, only csv files can be read.')

        # Read the file
        file = []
        with open(csv_path, 'r') as csvFile:
            file = csv.reader(csvFile, delimiter = ';', \
                                skipinitialspace=True)
            file = remove_empty_line(file)            
        csvFile.close()
        return file

    # paths of outputs folds
    list_outputs = os.listdir(outputs_fold)
    list_outputs = [outputs_fold + out_fold + '/' for out_fold in list_outputs]

    # Fill the data structure

    outputs = dict()
    name_of = dict()
    dir_id = 0

    for out_fold in list_outputs:

        if not os.path.isdir(out_fold):
            print('Warning : ' + out_fold + ' is not a directory')   

        else:
            # Name of the directory
            name = fold_name(out_fold)

            # ID of directory
            dir_id += 1
            id = 'ID_' + str(dir_id)
            
            # Data structure
            outputs[id] = dict()
            name_of[id] = name
                
            # Read time sub-out_folders
            for time in os.listdir(out_fold):
                if is_time_out_folder(time):

                    # Path of time sub out_folder
                    time_path = out_fold + time + '/'

                    # Load the data
                    outputs[id][time] = load_data(file_to_read, 
                                                    time_path)        
            
    return outputs, name_of


def record_first_col(outputs, file_name):
    """Return the first column of file_name.
       Return an error if the first columns are not consistent."""
    
    # First column of one file
    fold0 = list(outputs.keys())[0]
    time0 = list(outputs[fold0].keys())[0]

    file0 = outputs[fold0][time0]
    first_col = [row[0] for row in file0]
        
    # Check that the first column is the same for every file
    for fold in outputs.keys():
        for time in outputs[fold].keys():

            file = outputs[fold][time]
            file_first_col = [row[0] for row in file]

            if file_first_col != first_col:
                raise Exception('Different first column in outputs of : ' \
                                 + file_name)

    return first_col

def record_time_steps(outputs):
    """Return the list of time step used.
       Return an error if some output folders have different time steps."""

    fold0 = list(outputs.keys())[0]
    time_steps = list(outputs[fold0].keys())
    err = Exception('The time steps of the outputs are not consistent.')

    for fold in outputs.keys():
        
        time = list(outputs[fold].keys())

        if len(time) != len(time_steps):
            raise err

        for t in time:
            if not t in time_steps:
                raise err

    return time_steps

def get_line(file, line_name):
    """Return the line of the file whose header is line_name."""
    
    for line in file:
        if line[0] == line_name:
            return line
    
    raise Exception(line_name + ' has not been found in the file.')
    