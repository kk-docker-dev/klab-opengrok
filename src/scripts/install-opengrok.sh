#!/bin/bash

set -eu

DIRGROK=/opengrok
DIRWEBAPP=/opt/tomcat/webapps
GROKBIN=/klab/pkg/opengrok-1.8.1.tar.gz

install_opengrok() {
	# Create required directories
	mkdir -p $DIRWEBAPP
	mkdir -p $DIRGROK/{src,data,dist,etc,log}

	# Extract opengrok files
	echo "Extracting OpenGrok binaries ..."
	tar -xf $GROKBIN -C $DIRGROK/dist --strip=1

	# Install opengrok tools
	echo "Installing OpenGrok tools ..."
	pip3 install $DIRGROK/dist/tools/opengrok-tools.tar.gz

	# Deploy opengrok webapp
	echo "Deploying OpenGrok ..."
	opengrok-deploy -c $DIRGROK/etc/configuration.xml $DIRGROK/dist/lib/source.war $DIRWEBAPP

	return $?
}

#--------------------------------
# Main procedure starts here
#--------------------------------

install_opengrok

rm -f $GROKBIN

exit $?
