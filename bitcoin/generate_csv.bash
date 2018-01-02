#!/bin/bash

mkdir -p csv

for Y in 2009 2010 2011 2012 2013 ; do
	echo $Y; 
	bash abe_to_csv.bash $USER $PASS $Y-01-01 $Y-03-01		| python massage_csv.py > csv/BTC-$Y-Q1.csv;
	bq load --replace --source_format NEWLINE_DELIMITED_JSON BTC_blockchain.tx${Y}Q1 csv/BTC-$Y-Q1.csv BTC_blockchain.schema.json
	bash abe_to_csv.bash $USER $PASS $Y-03-01 $Y-06-01 		| python massage_csv.py > csv/BTC-$Y-Q2.csv; 
	bq load --replace --source_format NEWLINE_DELIMITED_JSON BTC_blockchain.tx${Y}Q2 csv/BTC-$Y-Q2.csv BTC_blockchain.schema.json
	bash abe_to_csv.bash $USER $PASS $Y-06-01 $Y-09-01 		| python massage_csv.py > csv/BTC-$Y-Q3.csv; 
	bq load --replace --source_format NEWLINE_DELIMITED_JSON BTC_blockchain.tx${Y}Q3 csv/BTC-$Y-Q3.csv BTC_blockchain.schema.json
	bash abe_to_csv.bash $USER $PASS $Y-01-01 $(($Y + 1))-01-01	| python massage_csv.py > csv/BTC-$Y-Q4.csv; 
	bq load --replace --source_format NEWLINE_DELIMITED_JSON BTC_blockchain.tx${Y}Q4 csv/BTC-$Y-Q4.csv BTC_blockchain.schema.json
done

