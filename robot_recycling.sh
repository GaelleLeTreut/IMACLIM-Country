#!/bin/bash

Tabular="PublicDeficit GreenInvest LumpSumHH LabTax ExactRestitution LabTax_PublicDeficit LabTax_GreenInvest LabTax_LumpSumHH"

#code='ImaclimS.sce'
code='main_recalib.sce'
country='FRA'

for iter in ${Tabular}
do 
	echo ${iter}
	sed "s/to_fill/${iter}/g" Dashboard.csv > Dashboard_${country}.csv
	mv Dashboard_${country}.csv study_frames/study_frames_${country}
	(
		cd code
		#scilab -nw -e "exec $code;exit;" -nb > ../outputs/output_${iter}.log 2>&1 &
		echo "exec $code;exit;"|../../scilab-5.5.2/bin/scilab-cli > ../outputs/output_${iter}.log 2>&1 & 
		sleep 5s
	)
done

