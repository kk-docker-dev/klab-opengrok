#!/bin/bash

source /klab/scripts/utils.sh

# SIGINT handler
trap 'echo -e "\nStopping OpenGrok engine ..."; exit 0' SIGINT

echo "Starting Tomcat server ..."
execit /opt/tomcat/bin/catalina.sh start

# Wait for Tomcat to up and run OpenGrok indexer
echo "Starting OpenGrok server ..."
sleep 1 && curl -s localhost:8080/source
execit /klab/scripts/index-xrefs.sh

# Keep alive
while true; do
	sleep 3
done

exit 0
