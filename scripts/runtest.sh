#!/bin/bash

if [ "$#" -lt 1 ]
then
    echo "Usage: $0 <arma_server_binary>"
    exit 1
fi

scriptdir=`dirname "$0"`
arma_binary="$1"

# Remove prefix for the configuration file
# It has to be relative to Arma executable location :-/
real_arma_binary=`realpath "${arma_binary}"`
real_arma_path=`dirname "${real_arma_binary}"`
real_server_cfg=`realpath "${scriptdir}/../server.cfg"`

#foo=${string#$prefix}
relative_server_cfg="${real_server_cfg#$real_arma_path/}"

# Use wine for windows binaries
if [[ "${arma_binary}" == *.exe ]]
then
    wine="wine"
else
    wine=""
fi

echo time "${wine}" "${arma_binary}" -autoInit -config="${relative_server_cfg}"
time "${wine}" "${arma_binary}" -autoInit -config="${relative_server_cfg}"
