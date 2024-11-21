#!/bin/bash
# SPDX-FileCopyrightText: Copyright (c) 2021-2024, NVIDIA CORPORATION & AFFILIATES. All rights reserved.
# SPDX-License-Identifier: Apache-2.0
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
# http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )"

# Change to the script file to ensure we are in the correct repo (in case were in a submodule)
pushd ${SCRIPT_DIR} &> /dev/null

MORPHEUS_SUPPORT_DOCA=${MORPHEUS_SUPPORT_DOCA:-OFF}

export DOCKER_IMAGE_NAME=${DOCKER_IMAGE_NAME:-"nvcr.io/nvidia/morpheus/morpheus"}
export DOCKER_IMAGE_TAG=${DOCKER_IMAGE_TAG:-"$(git describe --tags --abbrev=0)-runtime"}

popd &> /dev/null

# DPDK (and thus DOCA) requires hugepage and privileged container
export DOCKER_ARGS=""
if [[ ${MORPHEUS_SUPPORT_DOCA} == @(TRUE|ON) ]]; then
   echo -e "Enabling DOCA Support. Mounting /dev/hugepages and running in privileged mode"

   DOCKER_ARGS="${DOCKER_ARGS} -v /dev/hugepages:/dev/hugepages --privileged"
fi

# Call the general run script
${SCRIPT_DIR}/run_container.sh "${@:-bash}"
