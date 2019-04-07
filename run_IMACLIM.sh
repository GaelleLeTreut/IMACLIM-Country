#!/bin/bash

#code='ImaclimS.sce'
code='main_recalib.sce'

(
	cd code
	echo "exec main_recalib.sce;exit;"|../../scilab-5.5.2/bin/scilab-cli > ../output_recalib.log 2>&1 & 
#	scilab -nw -e "exec $code;exit;" -nb > ../output_recalib.log 2>&1 &
)