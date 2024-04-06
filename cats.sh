#!/bin/bash

rm -rf ./cats
mkdir cats
mkdir cats/cats-report

echo "### Kill all java"
pkill -9 java

echo "### Check Java version"
#sdk env install
java -version

echo "### Run Petclinic"
./mvnw clean 
./mvnw package -DskipTests
java -jar -Dspring.profiles.active=default,jdbc ./target/spring-petclinic-rest-3.2.1.jar &
sleep 60

#echo "### Download OpenAPI from the application"
#wget http://localhost:9966/petclinic/v3/api-docs -O ./cats/openapi.json

#https://github.com/Endava/cats/releases
wget https://github.com/Endava/cats/releases/download/cats-11.4.0/cats_uberjar_11.4.0.tar.gz -O ./cats/cats_uberjar_11.4.0.tar.gz
tar -xf ./cats/cats_uberjar_11.4.0.tar.gz -C ./cats

java -jar ./cats/cats.jar --contract=./src/main/resources/openapi.json --server=http://localhost:9966 --blackbox -o ./cats/cats-report/

#sdk install java
#sdk use java 20-tem
jwebserver -p 9000 -d "$(pwd)/cats/cats-report/" & 

sleep 120

rm -rf ./cats

exit 0

```