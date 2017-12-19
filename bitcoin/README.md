```
sudo apt-get install python-pip mysql-client
sudo pip install pycrypto
```

```
bq load --source_format NEWLINE_DELIMITED_JSON BTC_blockchain.2009Q3 ./empty ./BTC_blockchain.schema.json 
```
