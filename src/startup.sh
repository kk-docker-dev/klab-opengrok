#!/bin/bash

source /klab/scripts/utils.sh

echo "Starting Tomcat server ..."
execit /opt/tomcat/bin/catalina.sh start

# Wait for Tomcat to up and run OpenGrok indexer
echo "Starting OpenGrok server ..."
sleep 1 && curl -s localhost:8080/source
execit /klab/scripts/index-opengrok-xrefs.sh

# Trap SIGINT
trap 'echo -e "\nStopping OpenGrok ..."; exit 0' SIGINT

# Run infinitely
while true; do
	sleep 10
done

exit 0
