#!/bin/bash

Tabular="Lab_Tax LS_HH pY_Ener Hybrid_Ener"

code='ImaclimS.sce'

for iter in ${Tabular}
do 
	echo ${iter}
	sed "s/to_indicate/${iter}/g" Dashboard.csv > Dashboard_FRA_update.csv
	mv Dashboard_FRA_update.csv study_frames/study_frames_FRA_update
	(
		cd code
		scilab -nw -e "exec $code;exit;" -nb > ../output_${iter}.log 2>&1 &
		sleep 5s
	)
done

