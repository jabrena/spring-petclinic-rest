#!/bin/bash

rm -rf ./cats
mkdir cats
mkdir cats/cats-report

echo "### Kill all java"
pkill -9 java

echo "### Check Java version"
#sdk env install
java -version

echo "### Create fat jar Petclinic" 
./mvnw clean package -DskipTests

echo "### Run Petclinic" 
java -jar -Dspring.profiles.active=hsqldb,jdbc ./target/spring-petclinic-rest-3.2.1.jar &
sleep 60

#https://endava.github.io/cats/docs/commands-and-arguments/arguments
#https://github.com/Endava/cats/releases
wget https://github.com/Endava/cats/releases/download/cats-11.4.0/cats_uberjar_11.4.0.tar.gz -O ./cats/cats_uberjar_11.4.0.tar.gz
tar -xf ./cats/cats_uberjar_11.4.0.tar.gz -C ./cats

java -jar ./cats/cats.jar \
--contract=./src/main/resources/openapi.yml \
--server=http://localhost:9966 \
--basicauth=admin:admin \
--reportFormat=HTML_JS \
--output=./cats/cats-report/
#--mc 500 \
#--printExecutionStatistics \
#--blackbox


jwebserver -p 9000 -d "$(pwd)/cats/cats-report/" & 

sleep 120

rm -rf ./cats

exit 0