#!/bin/bash

FMTNC='\033[0m'
FMTBRED='\033[1;31m'
FMTBYLW='\033[1;33m'
FMTBBLUE='\033[1;34m'

echo_info() {
	echo -e "${FMTBBLUE}$@${FMTNC}"
}

echo_warn() {
	echo -e "${FMTBYLW}$@${FMTNC}"
}

echo_error() {
	echo -e "${FMTBRED}$@${FMTNC}"
}

execv() {
	set -v

	eval $@
	EVAL=$?

	set +v

	return $EVAL
}

execit() {
	echo_warn "$@"

	eval $@
	EVAL=$?

	return $EVAL
}

# Set apt platform and sudo variables
if [ -e $HOME/.termux ]; then
	APT="apt"
	SUDO=""
	PLATFORM="TERMUX"
else
	PLATFORM="HOST"
	if [[ $(id -u) -eq 0 ]]; then
		APT="apt"
		SUDO=""
	else
		APT="sudo apt"
		SUDO="sudo"
	fi
fi

# Set distname
if [ -f /etc/os-release ]; then
	DISTID=$(grep ID= /etc/os-release 2>/dev/null | grep -v _ID | cut -d '=' -f 2)
	if [ "$DISTID" == "ubuntu" ]; then
		DISTCODE=$(grep UBUNTU_CODENAME /etc/os-release 2>/dev/null | cut -d '=' -f 2)
	else
		DISTCODE=$(grep VERSION_CODENAME /etc/os-release 2>/dev/null | cut -d '=' -f 2)
	fi
	DISTNAME=$(echo ${DISTCODE^})
elif [ -e $HOME/.termux ] && [ "$PLATFORM" == "TERMUX" ]; then
	DISTCODE=termux
	DISTNAME=$(echo ${DISTCODE^})
elif [[ $(which sw_vers 2>/dev/null) ]]; then
	DISTID=macos
	DISTNAME=MacOS
	DISTCODE=$(sw_vers -productName)
else
	echo_error "Unknown Linux distro !!!"
fi

# Set architecture
if [[ $(which dpkg 2>/dev/null) ]]; then
	DPKGARCH=$(dpkg --print-architecture)
	if [ "$DISTARCH" == "darwin-arm64" ] || [ "$DISTARCH" == "arm64" ]; then
		DISTARCH=arm64
	else
		DISTARCH=$DPKGARCH
	fi
fi

# Set IP address
if [ $PLATFORM == "TERMUX" ]; then
	WLAN=$(netstat -i 2>/dev/null | awk '{ print $1 }' | grep wlan)
	HOSTIP="$(ip addr show $WLAN | grep -w inet | awk '{ print $2 }' | cut -f 1 -d '/')"
elif [ "$DISTID" == "macos" ]; then
	HOSTIP=$(ifconfig | grep "inet " | grep -v 127.0.0.1 | awk '{ print $2 }')
else
	HOSTIP=$(hostname -I | cut -d ' ' -f 1)
fi

export APT SUDO DISTARCH DISTCODE DISTNAME DISTID HOSTIP PLATFORM
#echo "APT:$APT, SUDO:$SUDO, DISTARCH:$DISTARCH, DISTCODE:$DISTCODE, DISTNAME:$DISTNAME, DISTID:$DISTID, HOSTIP:$HOSTIP, PLATFORM:$PLATFORM"

#EOF
