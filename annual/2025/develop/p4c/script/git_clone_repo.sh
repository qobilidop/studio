#!/usr/bin/env bash
set -ex

# https://stackoverflow.com/a/246128
SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )
WORKSPACE_DIR=$( cd "${SCRIPT_DIR}"/.. && pwd )

cd "$WORKSPACE_DIR"
mkdir -p repo
cd repo

if [ ! -d "p4c" ]; then
    git clone --recurse-submodules git@github.com:qobilidop/fork__p4lang__p4c.git p4c
fi
