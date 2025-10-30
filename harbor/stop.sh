#!/bin/bash


echo "stop harbor container with Docker Compose..."

docker-compose down


mysqldump --host=172.21.2.229 --port=30036 -uroot -pMysql-ha@123 --databases csp > cspm_1.sql