#!/bin/bash
set -e

MODELS=(
    "sheared_llama-chat"
    "sheared_llama"
    # "mamba-2.8b"
    "mamba2-2.7b"
    "mamba2attn-2.7b"
    "recurrentgemma_2b_it"
    "recurrentgemma_2b"
    # "rwkv-v6"
    "tpp-2.7b"
)

TASKS=(
    "niah_single_1"
    "niah_single_2"
    "niah_single_3"
    "niah_multikey_1"
    "niah_multikey_2"
    "niah_multikey_3"
    "niah_multivalue"
    "niah_multiquery"
    "vt"
    "cwe"
    "fwe"
    "qa_1"
    "qa_2"
)
BENCHMARKS=(
    "synthetic"
)
SEQ_LENGTHS=(
    #262144
    #131072
    #65536
    #32768
    16384
    8192
    4096
    2048
    1024
)

find . -type f -empty -print -delete

for SEED in $(seq 1); do
    for BENCHMARK in "${BENCHMARKS[@]}"; do
        for MAX_SEQ_LENGTH in "${SEQ_LENGTHS[@]}"; do
            for MODEL_NAME in ${MODELS[@]}; do
                for TASK in ${TASKS[@]}; do
                    
                    RESULTS_DIR="results/${MODEL_NAME}/${BENCHMARK}/${MAX_SEQ_LENGTH}"
                    DATA_DIR="${RESULTS_DIR}/data/${SEED}"
                    PRED_DIR="${RESULTS_DIR}/pred/${SEED}"

                    if [ -f ${PRED_DIR}/${TASK}.jsonl ]; then
                        echo "File '${PRED_DIR}/${TASK}.jsonl' already exists."
                    else
                        echo "File '${PRED_DIR}/${TASK}.jsonl' doesn't yet exist."
                        bash mila_run_scripts/bash_job_mila.sh $MODEL_NAME $TASK $MAX_SEQ_LENGTH $BENCHMARK $SEED
                    fi
                done
            done
        done
    done
done

