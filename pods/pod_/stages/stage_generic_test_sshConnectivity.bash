# about:    test connectivity and write-paths for all servers in servers json definition

#-------------------------------------------

function task_generic_testConnectivity(){

## for each server test ssh connectivity + authorisation

for id in $(seq 1 ${numberOfServers});
do

  tag=$(cat ${servers_json_path}           | ${jq_folder}jq '.server_'${id}'.tag'            | tr -d '"')
  user=$(cat ${servers_json_path}          | ${jq_folder}jq '.server_'${id}'.user'           | tr -d '"')
  sshKey=$(cat ${servers_json_path}        | ${jq_folder}jq '.server_'${id}'.sshKey'         | tr -d '"')
  target_folder=$(cat ${servers_json_path} | ${jq_folder}jq '.server_'${id}'.target_folder'  | tr -d '"')
  pubIp=$(cat ${servers_json_path}         | ${jq_folder}jq '.server_'${id}'.pubIp'          | tr -d '"')
  prvIp=$(cat ${servers_json_path}         | ${jq_folder}jq '.server_'${id}'.prvIp'          | tr -d '"')

# ----------

  # add trailing '/' to path if not present
  target_folder=$(lib_generic_strings_addTrailingSlash "${target_folder}")

# ----------

  lib_generic_display_msgColourSimple "INFO" "server: ${yellow}$tag${white} at address: ${yellow}$pubIp${reset}"

# ----------

  status="999"
  if [[ "${status}" != "0" ]]; then
    retry=1
    until [[ "${retry}" == "6" ]] || [[ "${status}" == "0" ]]
    do
      lib_generic_checks_fileExists "stage_generic_test_sshConnectivity.sh#1" "true" "${sshKey}"
      ssh -q -i ${sshKey} ${user}@${pubIp} exit
      status=${?}
      if [[ "${status}" == "0" ]]; then
        lib_generic_display_msgColourSimple "INFO-->" "ssh return code: ${green}${status}"
      else
        lib_generic_display_msgColourSimple "INFO-->" "ssh return code: ${red}${status} ${white}(retry ${retry}/5)"
      fi
      pod_test_connect_error_array["${tag}"]="${status};${pubIp}"
      ((retry++))
    done
    printf "%s\n"
  fi
done
}

#-------------------------------------------

function task_generic_testConnectivity_report(){

## generate a report of all failed ssh connectivity attempts

lib_generic_display_msgColourSimple "REPORT" "STAGE SUMMARY: ${reset}Test connectivity for each server"

declare -a pod_test_connect_report_array
count=0
for k in "${!pod_test_connect_error_array[@]}"
do
  lib_generic_strings_expansionDelimiter ${pod_test_connect_error_array[$k]} ";" "1"
  if [[ "${_D1_}" != "0" ]]; then
    pod_test_connect_fail="true"
    pod_test_connect_report_array["${count}"]="${yellow}${k}${white} at address ${yellow}${_D2_}${white} with error code ${red}${_D1_}${reset}"
    (( count++ ))
  fi
done

if [[ "${pod_test_connect_fail}" == "true" ]]; then
  printf "%s\n"
  lib_generic_display_msgColourSimple "INFO-BOLD" "--> ${red}Connection errors report:"
  printf "%s\n"
  for k in "${pod_test_connect_report_array[@]}"
  do
    lib_generic_display_msgColourSimple "INFO" "${cross} ${k}"
  done
  printf "%s\n"
  lib_generic_display_msgColourSimple "ERROR" "Aborting script as not all servers are reachable"
  exit 1;
else
  lib_generic_display_msgColourSimple "SUCCESS" "All Servers: ssh connected successfully"
fi
}
