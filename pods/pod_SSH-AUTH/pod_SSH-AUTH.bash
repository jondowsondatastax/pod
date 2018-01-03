# author:        jondowson
# about:         configure dse software and distribute to all servers in cluster

# ------------------------------------------

## pod desription: pod_SSH_AUTH

# note: a pod consists of STAGE(S), which consist of TASK(S), which contain actions.

# pod_SSH_AUTH makes use of 2 user defined files and has 3 STAGES.

# --> ${SERVERS_JSON}
# --> ${BUILD_FOLDER}cluster_settings.sh
# and a Java version specific in build_settings.bash
# --> ${BUILD_FOLDER}build_settings.bash

# STAGE [1] - test cluster connections
# --> test defined paths can be written to.

# STAGE [2] - build and send pod build
# --> duplicate 'pod 'project to a temporary folder and configure for each server.
# --> copy the duplicated and configured version - the pod 'build' - to each server.

# STAGE [3] - execute pod remotely
# --> remotely run 'launch-pod.sh' on each server.

# ------------------------------------------

function pod_REMOVE-PODS(){

## create arrays for capturing errors

declare -A ifsDelimArray
declare -A pod_test_connect_error_array
declare -A pod_test_send_error_array_1
declare -A pod_build_send_error_array
declare -A pod_software_send_pid_array
declare -A pod_build_run_pid_array
declare -A pod_build_launch_pid_array
declare -A pod_remove_pod_report_array
declare -A pod_remove_pod_error_array

# ------------------------------------------

## test specified files exist

prepare_misc_checkFilesExist

# ------------------------------------------

# create configurable temp version of pod
catchError "pod_generic.sh#1" "true" "true" prepare_generic_misc_podBuildTempFolder

# ------------------------------------------

## STAGES

## STAGE [1]

lib_generic_display_banner
lib_generic_display_msgColourSimple "STAGE"      "STAGE: Test server connectivity"
lib_generic_display_msgColourSimple "STAGECOUNT" "[ ${cyan}${b}1 ${white}2 3 4 ]${reset}"
lib_generic_display_msgColourSimple "TASK==>"    "TASK: Testing server connectivity"
task_generic_testConnectivity
task_generic_testConnectivity_report
lib_generic_misc_timecount "${STAGE_PAUSE}" "Proceeding to next STAGE..."

# ------------------------------------------

## STAGE [2]

lib_generic_display_banner
lib_generic_display_msgColourSimple "STAGE"      "STAGE: Build and send bespoke pod"
lib_generic_display_msgColourSimple "STAGECOUNT" "[ ${cyan}${b}1 2 ${white}3 4 ]${reset}"
lib_generic_display_msgColourSimple "TASK==>"    "TASK: Configure locally and distribute"
task_buildSend
task_buildSend_report
lib_generic_misc_timecount "${STAGE_PAUSE}" "Proceeding to next STAGE..."

# ------------------------------------------

## STAGE [3]

lib_generic_display_banner
lib_generic_display_msgColourSimple "STAGE"      "STAGE: Launch pod remotely"
lib_generic_display_msgColourSimple "STAGECOUNT" "[ ${cyan}${b}1 2 3 ${white}4 ]${reset}"
lib_generic_display_msgColourSimple "TASK==>"    "TASK: Execute launch script on each server"
task_generic_launchPodRemotely
task_generic_launchPodRemotely_report
lib_generic_misc_timecount "${STAGE_PAUSE}" "Proceeding to next STAGE..."

# ------------------------------------------

## STAGE [4] FINISH

lib_generic_display_banner
lib_generic_display_msgColourSimple "STAGE"      "Summary"
lib_generic_display_msgColourSimple "STAGECOUNT" "[ ${cyan}${b}1 2 3 4${white} ]${reset}"
task_generic_testConnectivity_report
task_buildSend_report
task_generic_launchPodRemotely_report
task_removePod_report

}
