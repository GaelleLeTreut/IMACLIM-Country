import pandas as pd
import yaml
import math

def load_config():

    with open('/Users/rdo2/Dropbox/PC/Documents/GitHub/IMACLIM-Country/outputs_display/config.yml') as f:
        config = yaml.load(f, Loader=yaml.FullLoader)

    return config 

def deviation(sample):

    difference_squared = []

    for i, value in enumerate(sample):

        ecart =  (value - 1) ** 2

        difference_squared.append(ecart)

    deviation = math.sqrt(sum(difference_squared) / ((len(sample)) - 1))

    return deviation