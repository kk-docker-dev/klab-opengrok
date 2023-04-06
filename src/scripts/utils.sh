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

execit() {
	echo_warn "$@"

	eval "$@"

	return $?
}

#EOF
