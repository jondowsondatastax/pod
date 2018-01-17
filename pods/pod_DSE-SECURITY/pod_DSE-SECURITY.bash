# about:         configure dse software audit + security settings

# ------------------------------------------

## pod desription: pod_DSE-SECURITY

# note: a pod consists of STAGE(S), which consist of TASK(S), which contain actions.

# pod_DSE-SECURITY makes use of 2 user defined files and has 4 STAGES.

# --> ${SERVERS_JSON}
# --> ${BUILD_FOLDER}build_settings.sh
# and a DSE version specific prepared 'resources' folder.
# --> ${BUILD_FOLDER}resources

# STAGE [1] - test cluster connections
# --> test defined paths can be written to.

# STAGE [2] - build and send pod build
# --> duplicate 'pod 'project to a temporary folder and configure for each server.
# --> copy the duplicated and configured version - the pod 'build' - to each server.

# STAGE [3] - execute pod remotely
# --> remotely run 'launch-pod.sh' on each server.

# STAGE [4] - summary

# ------------------------------------------

function pod_DSE-SECURITY(){

## create pod specific arrays used by its stages

declare -A build_send_error_array     # test send pod build
declare -A build_launch_pid_array     # test launch pod scripts remotely

# ------------------------------------------

## STAGES

## STAGE [1]

lib_generic_display_banner
lib_generic_display_msgColourSimple "STAGE"      "STAGE: Test cluster connections"
lib_generic_display_msgColourSimple "STAGECOUNT" "[ ${cyan}${b}1${white} 2 3 4 ]${reset}"
lib_generic_display_msgColourSimple "TASK==>"    "TASK: Testing server connectivity"
task_generic_testConnectivity
task_generic_testConnectivity_report
lib_generic_misc_timecount "${STAGE_PAUSE}" "Proceeding to next STAGE..."

# ------------------------------------------

## STAGE [2]

lib_generic_display_banner
lib_generic_display_msgColourSimple "STAGE"      "STAGE: Build and send bespoke pod"
lib_generic_display_msgColourSimple "STAGECOUNT" "[ ${cyan}${b}1 2${white} 3 4 ]${reset}"
lib_generic_display_msgColourSimple "TASK==>"    "TASK: Configure locally and distribute"
task_buildSend
task_buildSend_report
lib_generic_misc_timecount "${STAGE_PAUSE}" "Proceeding to next STAGE..."

# ------------------------------------------

## STAGE [3]

lib_generic_display_banner
lib_generic_display_msgColourSimple "STAGE"      "STAGE: Launch pod remotely"
lib_generic_display_msgColourSimple "STAGECOUNT" "[ ${cyan}${b}1 2 3${white} 4 ]${reset}"
lib_generic_display_msgColourSimple "TASK==>"    "TASK: Execute launch script on each server"
task_generic_launchPodRemotely
task_generic_launchPodRemotely_report
lib_generic_misc_timecount "${STAGE_PAUSE}" "Proceeding to next STAGE..."

# ------------------------------------------

## [4] Summary

lib_generic_display_banner
lib_generic_display_msgColourSimple "STAGE"      "Summary"
lib_generic_display_msgColourSimple "STAGECOUNT" "[ ${cyan}${b}1 2 3 4 ${white} ]${reset}"
task_buildSend_report
task_generic_launchPodRemotely_report
}
