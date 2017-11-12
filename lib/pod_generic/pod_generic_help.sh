#!/bin/bash

# author:        jondowson
# about:         help on pod usage and flags

# ------------------------------------------

function pod_generic_help_pod(){

printf "%s%s%s\n" "${b}" "description                              | flag                 | required? | values[default]" "${reset}"
printf "%s\n"            "--------------------------------------------------------------------------------------------"
printf "%s\n\n"          "${b}${cyan}==> pod flags:${reset}"
printf "%s\n"            ".. help:                                 | -h  --help           |    no     |     n/a"
printf "%s\n"            ".. specify pod to run:                   | -p  --pod            |   always  |  <pod_name>"
printf "%s\n"            "--------------------------------------------------------------------------------------------"
printf "%s\n"            "${b}${cyan}==> pod_dse flags:${reset}"
printf "%s\n"
printf "%s\n"            ".. specify server json defintions:       | -s  --servers        |    yes    |  <server_json>"
printf "%s\n"            ".. specify build folder:                 | -b  --build          |    yes    |  <build_folder>"
printf "%s\n"            ".. scp DSE_SOFTWARE folder to servers:   | -ss --sendsoft       |    no     |  false [true]"
printf "%s\n"            ".. re-generate build resources folder:   | -rr --regenresources |    no     |  true  [false]"
printf "%s\n"
printf "%s\n"            "example: $ ./launch-pod -p pod_dse -s myServers.json -b dse-5.0.5_pre-prod -ss false --rr true"
printf "%s\n"            "--------------------------------------------------------------------------------------------"
printf "%s\n"            "${b}${cyan}==> pod_dse_rollingStartStop flags:${reset}"
printf "%s\n"
printf "%s\n"            ".. specify server json defintions:       | -s  --servers        |    yes    |  <server_json>"
printf "%s\n"            ".. rolling stop/start of cluster:        | -cs --clusterstate   |    yes    |  start stop"
printf "%s\n"
printf "%s\n"            "example: $ ./launch-pod -p pod_dse_rollingStartStop -s myServers.json -cs start"
printf "%s\n"            "--------------------------------------------------------------------------------------------"
pod_generic_display_msgColourSimple "alert" "Available pods:"
ls ${pod_home_path}/pods
pod_generic_display_msgColourSimple "alert" "Available server definitions:"
ls ${pod_home_path}/servers
pod_generic_display_msgColourSimple "alert" "Available builds:"
ls ${pod_home_path}/builds/pod_dse
printf "%s\n"
}