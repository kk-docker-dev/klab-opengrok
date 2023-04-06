#!/bin/bash

source /klab/scripts/utils.sh

DIRPROJECTS=/opengrok/src

echo_warn "Indexing projects at '$DIRPROJECTS' ..."

execit opengrok-indexer -a /opengrok/dist/lib/opengrok.jar -- -c /usr/bin/ctags -s $DIRPROJECTS -d /opengrok/data -H -P -S -G -W /opengrok/etc/configuration.xml -U http://localhost:8080/source -i '*.out' -i '*.swo' -i '*.swp' -i '*.a' -i '*.d' -i '*.o' -i '*.so' -i '*.so.*' -i d:obj -i d:dist -i d:sandbox -i d:__codereview -i d:__html -i d:__ktags
