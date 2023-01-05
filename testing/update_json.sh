#!/bin/bash

MD5=$(md5sum update_i2c2oled.sh | awk '{print $1}')
SIZE=$(ls -o update_i2c2oled.sh | awk '{print $4}')
DATE=$(date +%s -r update_i2c2oled.sh)

cp i2c2oleddb.json-empty i2c2oleddb.json
sed -i 's/"hash": "XXX"/"hash": "'${MD5}'"/' i2c2oleddb.json
sed -i 's/"size": XXX/"size": '${SIZE}'/' i2c2oleddb.json
sed -i 's/"timestamp": XXX/"timestamp": '${DATE}'/' i2c2oleddb.json
