# -*- coding: utf-8 -*-
"""
Created on Thu Aug 22 18:30:42 2019

@author: Alexis
"""

import matplotlib.pyplot as plt
import numpy as np

fig = plt.figure()

x = [1,2,3,4,5,6,7,8,9,10]
height = [8,12,8,5,4,3,2,1,0,0]
width = 1.0

plt.bar(x, height, width, color='b' )

plt.savefig('SimpleBar.png')
plt.show()