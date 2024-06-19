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

NUM_SAMPLES=100
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

# task name in `synthetic.yaml`
synthetic=(
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

niah_depth_ablation=(
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