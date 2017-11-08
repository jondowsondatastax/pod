#!/bin/bash

# script_name:   pod_dse_setup.sh
# author:        jondowson
# about:         functions to source scripts and check files exist for 'pod_dse' 
 
# ------------------------------------------

function pod_dse_setup_checkFilesExist(){

## test specified files exist

# check /servers/<json> file exists
pod_generic_misc_fileExistsCheckAbort "${servers_json_path}"

# test DSE_SOFTWARE folder is available
if [[ "${SEND_DSE_SOFTWARE}" == "true" ]]; then
  pod_generic_misc_folderExistsCheckAbort "${DSE_SOFTWARE}"
  pod_generic_misc_fileExistsCheckAbort "${dse_tar_file}"
  pod_generic_misc_fileExistsCheckAbort "${java_tar_file}"
fi

# test java folder is available
if [[ "${JAVA_INSTALL_TYPE}" == ""tar"" ]]; then
  pod_generic_misc_fileExistsCheckAbort "${java_tar_file}"
fi  

# check jq library is available
pod_generic_misc_fileExistsCheckAbort "${jq_file_path}"
}

# ------------------------------------------

function pod_dse_setup_duplicateResourcesFolder(){

## prepare duplicate version of 'pod' project

# this requires an existing local resources folder
# note: it is this duplicate folder will be configured locally and then sent to remote server(s)

tmp_build_folder="${pod_home_path}/tmp/pod/"
tmp_build_file_folder="${tmp_build_folder}builds/pod_dse/${BUILD_FOLDER}/"
tmp_build_file_path="${tmp_build_file_folder}cluster_settings.sh"

# delete any existing duplicated 'pod' folder from '/tmp'
tmp_folder="${pod_home_path}/tmp/"
rm -rf "${tmp_folder}"

# duplicate 'pod' folder to working directory '/tmp'
tmp_working_folder="${pod_home_path}/tmp/pod/"
mkdir -p "${tmp_working_folder}"
cp -r "${pod_home_path}/builds" "${tmp_working_folder}"
cp -r "${pod_home_path}/lib" "${tmp_working_folder}"
cp -r "${pod_home_path}/misc" "${tmp_working_folder}"
cp -r "${pod_home_path}/servers" "${tmp_working_folder}"
cp ${pod_home_path}/*.md "${tmp_working_folder}"
cp ${pod_home_path}/*.sh "${tmp_working_folder}"
}
