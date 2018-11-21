#!/usr/bin/env bash

# PLEASE NOTE: This script has been automatically generated by conda-smithy. Any changes here
# will be lost next time ``conda smithy rerender`` is run. If you would like to make permanent
# changes to this script, consider a proposal to conda-smithy so that other feedstocks can also
# benefit from the improvement.

set -xeuo pipefail
export PYTHONUNBUFFERED=1
export FEEDSTOCK_ROOT=/home/conda/feedstock_root
export RECIPE_ROOT=/home/conda/recipe_root
export CI_SUPPORT=/home/conda/feedstock_root/.ci_support
export CONFIG_FILE="${CI_SUPPORT}/${CONFIG}.yaml"

cat >~/.condarc <<CONDARC

conda-build:
 root-dir: /home/conda/feedstock_root/build_artifacts

CONDARC

conda install --yes --quiet conda-forge-ci-setup=2 conda-build -c conda-forge

# set up the condarc
setup_conda_rc "${FEEDSTOCK_ROOT}" "${RECIPE_ROOT}" "${CONFIG_FILE}"

# A lock sometimes occurs with incomplete builds. The lock file is stored in build_artifacts.
conda clean --lock

# Make sure build_artifacts is a valid channel
conda index /home/conda/staged-recipes/build_artifacts

conda install --yes --quiet conda-forge-ci-setup=1.* conda-forge-pinning networkx conda-build>=3.16
source run_conda_forge_build_setup

# yum installs anything from a "yum_requirements.txt" file that isn't a blank line or comment.
find ~/conda-recipes -mindepth 2 -maxdepth 2 -type f -name "yum_requirements.txt" \
    | xargs -n1 cat | { grep -v -e "^#" -e "^$" || test $? == 1; } | \
    xargs -r /usr/bin/sudo -n yum install -y

python ~/.ci_support/build_all.py ~/conda-recipes

touch "/home/conda/feedstock_root/build_artifacts/conda-forge-build-done-${CONFIG}"