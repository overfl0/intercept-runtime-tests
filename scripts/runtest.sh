#!/bin/bash

if [ "$#" -lt 1 ]
then
    echo "Usage: $0 <arma_server_binary>"
    exit 1
fi

# NOTE: For now, the linux server doesn't work because it says it requires a
# running instance of steam to work

scriptdir=`dirname "$0"`
arma_binary="$1"
use_xvfb=true

function create_args()
{
    command=()

    if [ "${use_xvfb}" = true ]
    then
        command+=("xvfb-run")
    fi

    # Use wine for windows binaries
    if [[ "${arma_binary}" == *.exe ]]
    then
        command+=("wine")
    fi

    command+=("${arma_binary}")

    echo ${command[@]}
}

function run_server()
{
    # Remove prefix for the configuration file
    # It has to be relative to Arma executable location :-/
    real_arma_binary=`realpath "${arma_binary}"`
    real_arma_path=`dirname "${real_arma_binary}"`
    real_server_cfg=`realpath "${scriptdir}/../server.cfg"`

    #foo=${string#$prefix}
    relative_server_cfg="${real_server_cfg#$real_arma_path/}"

    echo time `create_args` "${arma_binary}" -autoInit -config="${relative_server_cfg}"
    time `create_args` "${arma_binary}" -autoInit -config="${relative_server_cfg}"
}

function clear_rpt()
{
    find ~/.wine -name '*.rpt' -delete
}

function find_rpt()
{
    find ~/.wine -name '*.rpt'
}

run_server
