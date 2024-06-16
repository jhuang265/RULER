#!/bin/bash
#SBATCH --partition=unkillable
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=1
#SBATCH --gpus-per-task=1
#SBATCH --hint=nomultithread
#SBATCH --cpus-per-task=1
#SBATCH --mem=32GB
#SBATCH --exclude="cn-g[001-012],cn-k[001-002]"
#SBATCH --time=2-0:00:00
#SBATCH --requeue
#SBATCH --signal=B:TERM@120
#SBATCH --mail-type=FAIL
#SBATCH --mail-user=jerry.huang@mila.quebec

module load singularity/3.7.1
module load cuda/12.2.2

if [ $# -ne 5 ]; then
    echo "Usage: $0 <model_name> $1 <task_name> $2 <sequence_length> $3 <benchmark_name> $4 <seed>"
    exit 1
fi

# Root Directories
GPUS=$SLURM_GPUS_PER_TASK        # GPU size for tensor_parallel.
ROOT_DIR=.                  # the path that stores generated task samples and model predictions. 
MODEL_DIR=models          # the path that contains individual model folders from HUggingface.
ENGINE_DIR=engines        # the path that contains individual engine folders from TensorRT-LLM.

# Model and Tokenizer
source config_models.sh
MODEL_NAME=${1}
MODEL_CONFIG=$(MODEL_SELECT ${MODEL_NAME} ${MODEL_DIR} ${ENGINE_DIR})
IFS=":" read MODEL_PATH MODEL_TEMPLATE_TYPE MODEL_FRAMEWORK TOKENIZER_PATH TOKENIZER_TYPE OPENAI_API_KEY GEMINI_API_KEY AZURE_ID AZURE_SECRET AZURE_ENDPOINT <<< "$MODEL_CONFIG"
if [ -z "${MODEL_PATH}" ]; then
    echo "Model: ${MODEL_NAME} is not supported"
    exit 1
fi

export IMAGE_PATH=$(dirname $0)/../../docker/ruler.sif

TASK=${2}
MAX_SEQ_LENGTH=${3}
BENCHMARK=${4}
RANDOM_SEED=${5}

NUM_SAMPLES=250
REMOVE_NEWLINE_TAB=false
STOP_WORDS=""

if [ -z "${STOP_WORDS}" ]; then
    STOP_WORDS=""
else
    STOP_WORDS="--stop_words \"${STOP_WORDS}\""
fi

if [ "${REMOVE_NEWLINE_TAB}" = false ]; then
    REMOVE_NEWLINE_TAB=""
else
    REMOVE_NEWLINE_TAB="--remove_newline_tab"
fi
                
RESULTS_DIR="${ROOT_DIR}/results/${MODEL_NAME}/${BENCHMARK}/${MAX_SEQ_LENGTH}"
DATA_DIR="${RESULTS_DIR}/data/${RANDOM_SEED}"
PRED_DIR="${RESULTS_DIR}/pred/${RANDOM_SEED}"
mkdir -p ${RESULTS_DIR}/data/${RANDOM_SEED}
mkdir -p ${RESULTS_DIR}/pred/${RANDOM_SEED}

#set -e

echo "Preparing Data"

singularity exec --nv --cleanenv \
    -H $ROOT_DIR:/home \
    $IMAGE_PATH \
    bash -c "python3 data/prepare.py --save_dir ${DATA_DIR} --benchmark ${BENCHMARK} --task ${TASK} --tokenizer_path ${TOKENIZER_PATH} --tokenizer_type ${TOKENIZER_TYPE} --max_seq_length ${MAX_SEQ_LENGTH} --model_template_type ${MODEL_TEMPLATE_TYPE} --num_samples ${NUM_SAMPLES} ${REMOVE_NEWLINE_TAB}" \
    
singularity exec --nv --cleanenv \
    -H $ROOT_DIR:/home \
    $IMAGE_PATH \
    bash -c "python3 pred/call_api_patched.py --random_seed ${RANDOM_SEED} --data_dir ${DATA_DIR} --save_dir ${PRED_DIR} --benchmark ${BENCHMARK} --task ${TASK} --server_type ${MODEL_FRAMEWORK} --model_name_or_path ${MODEL_PATH} --temperature ${TEMPERATURE} --top_k ${TOP_K} --top_p ${TOP_P} ${STOP_WORDS}"

singularity exec --nv --cleanenv \
    -H $ROOT_DIR:/home \
    $IMAGE_PATH \
    bash -c "python3 eval/evaluate.py --data_dir ${PRED_DIR} --benchmark ${BENCHMARK}"