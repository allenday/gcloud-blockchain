#!/bin/bash

mkdir -p csv

for Y in 2009 2010 2011 2012 2013; do
	echo $Y; 
	bash abe_to_csv.bash $USER $PASS $Y-01-01 $Y-03-01		| python massage_csv.py > csv/BTC-$Y-Q1.csv;
	bash abe_to_csv.bash $USER $PASS $Y-03-01 $Y-06-01 		| python massage_csv.py > csv/BTC-$Y-Q2.csv; 
	bash abe_to_csv.bash $USER $PASS $Y-06-01 $Y-09-01 		| python massage_csv.py > csv/BTC-$Y-Q3.csv; 
	bash abe_to_csv.bash $USER $PASS $Y-01-01 $(($Y + 1))-01-01	| python massage_csv.py > csv/BTC-$Y-Q4.csv; 
done

