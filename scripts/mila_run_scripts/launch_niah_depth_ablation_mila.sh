#!/bin/bash
set -e

MODELS=(
    "sheared_llama-chat"
    "sheared_llama"
    "mamba-2.8b"
    "mamba2-2.7b"
    "mamba2attn-2.7b"
    "recurrentgemma_2b_it"
    "recurrentgemma_2b"
    "rwkv-v6"
    "tpp-2.7b"
)

TASKS=(
    # "niah_repeat_numbers_random"
    # "niah_essay_numbers_random"
    # "niah_essay_uuids_random"
    "niah_repeat_numbers_100"
    "niah_essay_numbers_100"
    "niah_essay_uuids_100"
    # "niah_repeat_numbers_90"
    # "niah_essay_numbers_90"
    # "niah_essay_uuids_90"
    "niah_repeat_numbers_80"
    # "niah_essay_numbers_80"
    # "niah_essay_uuids_80"
    # "niah_repeat_numbers_70"
    # "niah_essay_numbers_70"
    # "niah_essay_uuids_70"
    "niah_repeat_numbers_60"
    # "niah_essay_numbers_60"
    # "niah_essay_uuids_60"
    "niah_repeat_numbers_50"
    "niah_essay_numbers_50"
    "niah_essay_uuids_50"
    "niah_repeat_numbers_40"
    # "niah_essay_numbers_40"
    # "niah_essay_uuids_40"
    # "niah_repeat_numbers_30"
    # "niah_essay_numbers_30"
    # "niah_essay_uuids_30"
    "niah_repeat_numbers_20"
    # "niah_essay_numbers_20"
    # "niah_essay_uuids_20"
    # "niah_repeat_numbers_10"
    # "niah_essay_numbers_10"
    # "niah_essay_uuids_10"
    "niah_repeat_numbers_0"
    "niah_essay_numbers_0"
    "niah_essay_uuids_0"
)

BENCHMARKS=(
    "niah_depth_ablation_mila"
)

SEQ_LENGTHS=(
    # 262144
    # 131072
    65536
    32768
    16384
    8192
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

                    if [ -f ${PRED_DIR}/${TASK}.jsonl ]; then
                        echo "File '${PRED_DIR}/${TASK}.jsonl' already exists."
                    else
                        echo "File '${PRED_DIR}/${TASK}.jsonl' doesn't yet exist."
                        bash mila_run_scripts/job_mila.sh $MODEL_NAME $TASK $MAX_SEQ_LENGTH $BENCHMARK $SEED
                    fi
                done

                # Activate Environment
                source $SCRATCH/venvs/ruler/bin/activate
                python eval/evaluate.py --data_dir ${PRED_DIR} --benchmark ${BENCHMARK}

            done
        done
    done
done