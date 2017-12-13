#!/bin/bash

# author:        jondowson
# about:         preperation functions for 'pod_DSE'

# ------------------------------------------

function prepare_misc_checkFilesExist(){

## test specified files exist

if [[ ${clusterstateFlag} != "true" ]]; then
  # test POD_SOFTWARE folder and dse_tar file are available
  if [[ "${SEND_POD_SOFTWARE}" == "true" ]]; then
    lib_generic_checks_folderExists "prepare_misc.sh#1" "true" "${POD_SOFTWARE}"
    lib_generic_checks_fileExists   "prepare_misc.sh#2" "true" "${dse_tar_file}"
  fi
fi
}

# ------------------------------------------

function prepare_misc_setDefaults(){

## pod_DSE default settings

SEND_POD_SOFTWARE="true"         # send POD_SOFTWARE tarball bundle on each run
REGENERATE_RESOURCES="false"     # generate new /builds/pod_dse/dse-x.x.x_name/resources' folder - this action will remove any existing one for this build folder !!
STRICT_START="false"             # exit pod_DSE if any server cannot be reached or dependencies are not available
}