# Copyright (c) 2024, NVIDIA CORPORATION.  All rights reserved.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

TEMPERATURE="0.0" # greedy
TOP_P="1.0"
TOP_K="32"
SEQ_LENGTHS=(
    131072
    65536
    32768
    16384
    8192
    4096
)

MODEL_SELECT() {
    MODEL_NAME=$1
    MODEL_DIR=$2
    ENGINE_DIR=$3
    
    case $MODEL_NAME in
        llama2-7b-chat)
            MODEL_PATH="${MODEL_DIR}/llama2-7b-chat-hf"
            MODEL_TEMPLATE_TYPE="meta-chat"
            MODEL_FRAMEWORK="vllm"
            ;;
        gpt-3.5-turbo)
            MODEL_PATH="gpt-3.5-turbo-0125"
            MODEL_TEMPLATE_TYPE="base"
            MODEL_FRAMEWORK="openai"
            TOKENIZER_PATH="cl100k_base"
            TOKENIZER_TYPE="openai"
            OPENAI_API_KEY=""
            AZURE_ID=""
            AZURE_SECRET=""
            AZURE_ENDPOINT=""
            ;;
        gpt-4-turbo)
            MODEL_PATH="gpt-4"
            MODEL_TEMPLATE_TYPE="base"
            MODEL_FRAMEWORK="openai"
            TOKENIZER_PATH="cl100k_base"
            TOKENIZER_TYPE="openai"
            OPENAI_API_KEY=""
            AZURE_ID=""
            AZURE_SECRET=""
            AZURE_ENDPOINT=""
            ;;
        gemini_1.0_pro)
            MODEL_PATH="gemini-1.0-pro-latest"
            MODEL_TEMPLATE_TYPE="base"
            MODEL_FRAMEWORK="gemini"
            TOKENIZER_PATH=$MODEL_PATH
            TOKENIZER_TYPE="gemini"
            GEMINI_API_KEY=""
            ;;
        gemini_1.5_pro)
            MODEL_PATH="gemini-1.5-pro-latest"
            MODEL_TEMPLATE_TYPE="base"
            MODEL_FRAMEWORK="gemini"
            TOKENIZER_PATH=$MODEL_PATH
            TOKENIZER_TYPE="gemini"
            GEMINI_API_KEY=""
            ;;

        sheared_llama-chat)
            MODEL_PATH="${MODEL_DIR}/Sheared-LLaMA-2.7B-ShareGPT"
            MODEL_TEMPLATE_TYPE="sheared_llama-chat"
            TOKENIZER_PATH=${MODEL_PATH}
            TOKENIZER_TYPE="hf"
            MODEL_FRAMEWORK="hf"
            ;;

        sheared_llama)
            MODEL_PATH="${MODEL_DIR}/Sheared-LLaMA-2.7B"
            MODEL_TEMPLATE_TYPE="sheared_llama-chat"
            TOKENIZER_PATH=${MODEL_PATH}
            TOKENIZER_TYPE="hf"
            MODEL_FRAMEWORK="hf"
            ;;

        qwen2_1.5b_instruct)
            MODEL_PATH="${MODEL_DIR}/Qwen2-1.5B-Instruct"
            MODEL_TEMPLATE_TYPE="qwen2_instruct"
            TOKENIZER_PATH=${MODEL_PATH}
            TOKENIZER_TYPE="hf"
            MODEL_FRAMEWORK="hf"
            ;;

        recurrentgemma_2b_it)
            MODEL_PATH="${MODEL_DIR}/recurrentgemma-2b-it"
            MODEL_TEMPLATE_TYPE="base"
            TOKENIZER_PATH=${MODEL_PATH}
            TOKENIZER_TYPE="hf"
            MODEL_FRAMEWORK="hf"
            ;;
        
        recurrentgemma_2b)
            MODEL_PATH="${MODEL_DIR}/recurrentgemma-2b"
            MODEL_TEMPLATE_TYPE="base"
            TOKENIZER_PATH=${MODEL_PATH}
            TOKENIZER_TYPE="hf"
            MODEL_FRAMEWORK="hf"
            ;;

        rwkv-v6)
            MODEL_PATH="${MODEL_DIR}/rwkv-6-world-3b"
            MODEL_TEMPLATE_TYPE="RWKV"
            TOKENIZER_PATH=${MODEL_PATH}
            TOKENIZER_TYPE="hf"
            MODEL_FRAMEWORK="hf"
            ;;
 
        mamba-2.8b)
            MODEL_PATH="${MODEL_DIR}/mamba-2.8b"
            MODEL_TEMPLATE_TYPE="base"
            TOKENIZER_PATH="${MODEL_DIR}/gpt-neox-20b"
            TOKENIZER_TYPE="hf"
            MODEL_FRAMEWORK="mamba"
            ;;
        
        mamba2-2.7b)
            MODEL_PATH="${MODEL_DIR}/mamba2-2.7b"
            MODEL_TEMPLATE_TYPE="base"
            TOKENIZER_PATH="${MODEL_DIR}/gpt-neox-20b"
            TOKENIZER_TYPE="hf"
            MODEL_FRAMEWORK="mamba"
            ;;
        
        mamba2attn-2.7b)
            MODEL_PATH="${MODEL_DIR}/mamba2attn-2.7b"
            MODEL_TEMPLATE_TYPE="base"
            TOKENIZER_PATH="${MODEL_DIR}/gpt-neox-20b"
            TOKENIZER_TYPE="hf"
            MODEL_FRAMEWORK="mamba"
            ;;
        
        tpp-2.7b)
            MODEL_PATH="${MODEL_DIR}/transformerpp-2.7b"
            MODEL_TEMPLATE_TYPE="base"
            TOKENIZER_PATH="${MODEL_DIR}/gpt-neox-20b"
            TOKENIZER_TYPE="hf"
            MODEL_FRAMEWORK="mamba"
            ;;

    esac


    if [ -z "${TOKENIZER_PATH}" ]; then
        if [ -f ${MODEL_PATH}/tokenizer.model ]; then
            TOKENIZER_PATH=${MODEL_PATH}/tokenizer.model
            TOKENIZER_TYPE="nemo"
        else
            TOKENIZER_PATH=${MODEL_PATH}
            TOKENIZER_TYPE="hf"
        fi
    fi


    echo "$MODEL_PATH:$MODEL_TEMPLATE_TYPE:$MODEL_FRAMEWORK:$TOKENIZER_PATH:$TOKENIZER_TYPE:$OPENAI_API_KEY:$GEMINI_API_KEY:$AZURE_ID:$AZURE_SECRET:$AZURE_ENDPOINT"
}
