#!/bin/bash

set -e

# Define CLUSTER variable: mila | cedar | narval
export CLUSTER=$(cat /etc/slurm/slurm.conf | grep ClusterName | sed 's/.*=//g')

export ARR=0
if [[ -z $EXPID ]]; then
    export EXPID=$(uuidgen)
    export ARR=2
fi

if [[ -z $CONSTRAINT ]]; then
    export CONSTRAINT="ampere&80gb"
fi

export PROJECT=length_extrapolation
export RUN_DIR=$(pwd)

sbatch --job-name=${1}_${2}_${3}_${4}_${5} \
    --constraint=$CONSTRAINT \
    --output "$RUN_DIR/logs/%j-%x.out" \
    --error "$RUN_DIR/logs/%j-%x.err" \
    mila_run_scripts/run_$CLUSTER.sh "$@"
