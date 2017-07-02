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
use_xvfb=true  # use virtual framebuffer for truly headless tests

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

function check_test_results()
{
    rpt_file="`find_rpt`"
    echo "====================================================================="
    echo "Dumping the rpt file:"
    echo "====================================================================="
    cat "${rpt_file}"

    echo "====================================================================="
    echo "Checking the tests results..."
    echo "====================================================================="
    echo ""

    echo -n "Checking if the server has shut down properly... "
    # Check if the file has shut down properly
    grep "Mission file: shutdown" "${rpt_file}" >/dev/null || (echo 'Error!' && exit 1)
    echo 'OK!'

    # TODO: Add more checks here in the form of:
    # echo -n "Message... "
    # grep "Something" "${rpt_file}" >/dev/null || (echo 'Error!' && exit 1)
    # echo 'OK!'
}

function run_test()
{
    clear_rpt
    run_server
    check_test_results
}

run_test
