#!/usr/bin/env bash
set -ex

# https://stackoverflow.com/a/246128
SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )
WORKSPACE_DIR=$( cd "${SCRIPT_DIR}"/.. && pwd )

P4C_REPO_DIR=${WORKSPACE_DIR}/repo/p4c
if [ ! -d "$P4C_REPO_DIR" ]; then
    echo "P4C repo $P4C_REPO_DIR does not exist!"
    exit 1
fi
cd $P4C_REPO_DIR

mkdir -p build
cd build
# https://github.com/p4lang/p4c/blob/main/CMakeLists.txt
cmake -G Ninja .. \
    -DENABLE_DOCS=OFF \
    -DENABLE_GTESTS=ON \
    -DENABLE_BMV2=OFF \
    -DENABLE_EBPF=OFF \
    -DENABLE_UBPF=OFF \
    -DENABLE_DPDK=OFF \
    -DENABLE_TOFINO=OFF \
    -DENABLE_P4TC=OFF \
    -DENABLE_P4FMT=OFF \
    -DENABLE_P4TEST=ON \
    -DENABLE_TEST_TOOLS=OFF \
    -DENABLE_P4C_GRAPHS=OFF \
    -DCMAKE_C_COMPILER=clang -DCMAKE_CXX_COMPILER=clang++
cmake --build .

sudo cmake --install .
