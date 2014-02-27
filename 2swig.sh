#!/bin/bash

#
# STDIN : XML blogger template
# STDOUT : SWIG template
#


SCRIPT_FILE=`readlink -f $0`
SCRIPT_NAME=`basename $SCRIPT_FILE .sh`
SCRIPT_PATH=`dirname $SCRIPT_FILE`
XSL_FILE=${SCRIPT_PATH}/${SCRIPT_NAME}.xsl

exec xsltproc $XSL_FILE - | 
xmllint --format --nsclean --noblanks - |
sed -e "s/+ &quot;/}}{{ '/g" | 
sed -e "s/&quot; +/'}}{{/g" | 
sed -e "s/&quot; }}/' }}/g" | 
sed -e "s/{{ &quot/{{ '/g" |
sed -e "s/></>\n</g"


