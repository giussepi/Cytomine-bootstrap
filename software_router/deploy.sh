#!/bin/bash

/etc/init.d/ssh start

mkdir /software_router
cd software_router/
mv /tmp/config.groovy .
mv /tmp/cytomine-java-client-1.0-SNAPSHOT-jar-with-dependencies.jar .

echo "cytomineCoreURL='http://$CORE_URL'" >> config.groovy
echo "rabbitUsername='$RABBITMQ_LOGIN'" >> config.groovy
echo "rabbitPassword='$RABBITMQ_PASSWORD'" >> config.groovy
echo "groovyPath='$GROOVY_PATH'" >> config.groovy
echo "publicKey='$RABBITMQ_PUB_KEY'" >> config.groovy
echo "privateKey='$RABBITMQ_PRIV_KEY'" >> config.groovy


wget -q $ALGO_TAR -O algo.tar.gz
tar -xvf algo.tar.gz algo

wget -q $SOFTWARE_ROUTER_JAR -O Cytomine-software-router.jar

if [ $IS_LOCAL = true ]; then
	echo "#Custom adding" >> /etc/hosts
	echo "$(route -n | awk '/UG[ \t]/{print $2}')       $CORE_URL" >> /etc/hosts
fi

touch /tmp/test.out

# horrible hack for groovy with dash
PATH="$PATH:$GROOVY_HOME/bin"

java -jar Cytomine-software-router.jar

tail -f /tmp/test.out
