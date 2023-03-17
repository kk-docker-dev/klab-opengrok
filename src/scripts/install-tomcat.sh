#!/bin/bash

set -eu

DIRTOMCAT=/opt/tomcat
SRCTOMCAT=/klab/pkg/apache-tomcat-10.0.27.tar.gz

install_tomcat() {
	# Create tomcat user
	useradd -m -d $DIRTOMCAT -U -s /bin/false tomcat

	if [ ! -d $DIRTOMCAT ]; then
		mkdir -p $DIRTOMCAT
	fi

	# Extract tomcat files
	echo "Installing Tomcat binaries ..."
	tar -xf $SRCTOMCAT -C $DIRTOMCAT --strip=1
	chown -R tomcat:tomcat $DIRTOMCAT

	# Start Tomcat service (handled in startup.sh)
	# Run '/opt/tomcat/bin/catalina.sh run' (or)
	# systemctl start tomcat

	return $?
}

#--------------------------------
# Main procedure starts here
#--------------------------------

install_tomcat

rm -f $SRCTOMCAT

exit $?
