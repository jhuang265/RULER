#!/bin/bash
set -e

MODELS=(
    # "sheared_llama-chat"
    # "sheared_llama"
    # "mamba-2.8b"
    # "mamba2-2.7b"
    # "mamba2attn-2.7b"
    # "recurrentgemma_2b_it"
    # "recurrentgemma_2b"
    # "rwkv-v6"
    # "tpp-2.7b"
    "qwen2_1.5b_instruct"
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
    # 262144
    # 131072
    # 65536
    # 32768
    # 16384
    # 8192
    4096
    2048
    1024
)

echo "Deleting empty files."
find . -type f -empty -print -delete

echo "Deleting empty directories."
find . -type d -empty -print -delete

for SEED in $(seq 1); do
    for MODEL_NAME in "${MODELS[@]}"; do
        for BENCHMARK in "${BENCHMARKS[@]}"; do
            for MAX_SEQ_LENGTH in "${SEQ_LENGTHS[@]}"; do
                    
                RESULTS_DIR="results/${MODEL_NAME}/${BENCHMARK}/${MAX_SEQ_LENGTH}"
                DATA_DIR="${RESULTS_DIR}/data/${SEED}"
                PRED_DIR="${RESULTS_DIR}/pred/${SEED}"

                for TASK in ${TASKS[@]}; do

                    # if [ -f ${PRED_DIR}/${TASK}.jsonl ]; then
                    #     echo "File '${PRED_DIR}/${TASK}.jsonl' already exists."
                    # else
                    #     echo "File '${PRED_DIR}/${TASK}.jsonl' doesn't yet exist."
                    bash mila_run_scripts/bash_job_mila.sh $MODEL_NAME $TASK $MAX_SEQ_LENGTH $BENCHMARK $SEED
                    # fi
                done

                # # Activate Environment
                # source $SCRATCH/venvs/ruler/bin/activate
                # python eval/evaluate.py --data_dir ${PRED_DIR} --benchmark ${BENCHMARK}

            done
        done
    done
done