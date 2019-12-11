#!/bin/bash

git clone https://github.com/PacktPublishing/Apache-Hive-Essentials.git
cd Apache-Hive-Essentials

hdfs dfs -mkdir -p /tmp/hivedemo
hdfs dfs -put data /tmp/hivedemo/