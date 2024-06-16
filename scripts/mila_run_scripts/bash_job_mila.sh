#!/bin/bash

set -e

# Define CLUSTER variable: mila | cedar | narval
export CLUSTER=$(cat /etc/slurm/slurm.conf | grep ClusterName | sed 's/.*=//g')

export ARR=0
if [[ -z $EXPID ]]; then
    export EXPID=$(uuidgen)
    export ARR=2
fi

export PROJECT=length_extrapolation

bash mila_run_scripts/run_$CLUSTER.sh "$@"
