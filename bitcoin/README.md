```
sudo apt-get install python-pip mysql-client
sudo pip install pycrypto
```

```
bq load --overwrite --source_format NEWLINE_DELIMITED_JSON BTC_blockchain.2009Q1 csv/BTC-2009-Q1.csv BTC_blockchain.schema.json 
```
