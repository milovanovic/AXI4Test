#!/usr/bin/env bash

# exit script if any command fails
set -e
set -o pipefail

# chipyard main
DSPTOOLS_COMMIT=5b1e733
ROCKET_COMMIT=f5ebf26
FIRESIM_COMMIT=69e428f
API_CONFIG_COMMIT=fd8df11
# the newest one
ROCKET_DSP_COMMIT=16e26e7

git config --local submodule.sims/firesim.update none
git submodule update --init --recursive
git config --local --unset-all submodule.sims/firesim.update
git submodule update --init sims/firesim
cd ../..

