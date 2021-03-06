# about:    non-generic functions executed on remote server

# if at all possible make generic functions and put them in
# 'pod_/lib/lib_generic_doStuff_remotely.bash'
# otherwise pod specific functions run remotely go here.

# ---------------------------------------

function lib_doStuff_remotely_createDseFolders(){

## create required folders

# assume here that the mount has been pre-created and assigned to 'the user'

# make dse build folder
mkdir -p "${INSTALL_FOLDER_POD}${BUILD_FOLDER}"

# create log folders
mkdir -p ${cassandra_log_folder}
mkdir -p ${gremlin_log_folder}
mkdir -p ${tomcat_log_folder}
mkdir -p ${spark_master_log_folder}
mkdir -p ${spark_worker_log_folder}

# create cassandra sstable folder(s)
for i in "${data_file_directories_array[@]}"
do
  mkdir -p $i
done
mkdir -p ${commitlog_directory}
mkdir -p ${cdc_raw_directory}
mkdir -p ${saved_caches_directory}
mkdir -p ${hints_directory}

# create dsefs folders
mkdir -p ${dsefs_untar_folder}
for i in "${dsefs_data_file_directories_array[@]}"
do
  lib_generic_strings_expansionDelimiter "$i" ";" "2"
  mkdir -p $_D1_
done

# dse spark
mkdir -p ${spark_local_data}
mkdir -p ${spark_worker_data}
}

# ---------------------------------------

function lib_doStuff_remotely_cassandraTopologyProperties(){

## rename the deprecated cassandra-topology.properties to stop it interfering !!

# rename files and suppress error messages if file does not exist
topology_file_path="${INSTALL_FOLDER_POD}${BUILD_FOLDER}/${DSE_VERSION}/resources/cassandra/conf/cassandra-topology.properties"
mv "${topology_file_path}" "${topology_file_path}_old" 2>/dev/null
}

# ---------------------------------------

function lib_doStuff_remotely_agentAddressYaml(){

## configure bashrc to source bash_profile everytime a new terminal is started (on ubuntu/centos)

# file to edit
file="${agent_untar_config_folder}address.yaml"
touch ${file}

lib_generic_strings_sedStringManipulation "searchFromLineStartAndRemoveEntireLine" ${file} "stomp_interface:" "dummy"
lib_generic_strings_sedStringManipulation "searchFromLineStartAndRemoveEntireLine" ${file} "use_ssl:" "dummy"

# search for and remove any pre-canned blocks containing a label:
label="set_stomp_opscenter"
lib_generic_strings_sedStringManipulation "searchAndReplaceLabelledBlock" ${file} "${label}" "dummy"

# remove any empty blank lines at end of file
a=$(<$file); printf "%s\n" "$a" > $file

# add line sourcing .bashrc - no need on a Mac
cat << EOF >> ${file}

#>>>>> BEGIN-ADDED-BY__'${WHICH_POD}@${label}'
stomp_interface: ${STOMP_INTERFACE}
use_ssl: 0
#>>>>> END-ADDED-BY__'${WHICH_POD}@${label}'
EOF
}

# ---------------------------------------

function lib_doStuff_remotely_agentEnvironment(){

## configure JAVA_HOME for datastax-agent-env.sh

# file to edit
file="${agent_untar_config_folder}datastax-agent-env.sh"
touch ${file}

# search for and remove any pre-canned blocks containing a label:
label="set_java_agent"
lib_generic_strings_sedStringManipulation "searchAndReplaceLabelledBlock" ${file} "${label}" "dummy"

source ~/.bash_profile &>/dev/null
agent_java_home=$(echo ${JAVA_HOME})
if [[ "${agent_java_home}" == "" ]]; then
  lib_generic_display_msgColourSimple "ERROR-->" "No JAVA_HOME found on this server !!"
fi
agent_java_home=$(echo ${agent_java_home} | sed 's/bin.*//')

# remove any empty blank lines at end of file
a=$(<$file); printf "%s\n" "$a" > $file

# add line sourcing .bashrc - no need on a Mac
cat << EOF >> ${file}

#>>>>> BEGIN-ADDED-BY__'${WHICH_POD}@${label}'
export JAVA_HOME="${agent_java_home}"
#>>>>> END-ADDED-BY__'${WHICH_POD}@${label}'
EOF
}
