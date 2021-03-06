# about:    non-generic functions executed on remote server

# if at all possible make generic functions and put them in
# 'pod_/lib/lib_generic_doStuff_remotely.bash'
# otherwise pod specific functions run remotely go here.

# ---------------------------------------

function lib_doStuff_remotely_installJavaSecurity(){

## install from local tar to the designated java folder

unzip ${java_security_zip_file} &>/dev/null
mv UnlimitedJCEPolicyJDK8/*.jar  ${UNTAR_FOLDER}${SOFTWARE_VERSION}/lib/security/
chmod 0644 ${UNTAR_FOLDER}${SOFTWARE_VERSION}/lib/security/*.jar
rm -rf UnlimitedJCEPolicyJDK8/
}

# ---------------------------------------

function lib_doStuff_remotely_updateJavaPathBashProfile(){

## configure bash_profile to set paths in an idempotent 'manner'

program_home="${1}"
folder_path="${2}"

# file to edit
file="${HOME}/.bash_profile"
touch "${file}"

# search for and remove any lines starting with:
lib_generic_strings_sedStringManipulation "searchFromLineStartAndRemoveEntireLine" "${file}" "export ${program_home}=" "dummy"
lib_generic_strings_sedStringManipulation "searchFromLineStartAndRemoveEntireLine" "${file}" "export PATH=\$${program_home}:\$PATH" "dummy"
lib_generic_strings_sedStringManipulation "searchFromLineStartAndRemoveEntireLine" "${file}" "export PATH=\$PATH:\$${program_home}" "dummy"

# search for and remove any pre-canned blocks containing a label:
label="${program_home}_bash_profile"
lib_generic_strings_sedStringManipulation "searchAndReplaceLabelledBlock" ${file} "${label}" "dummy"

# remove any empty blank lines at end of file
a=$(<$file); printf "%s\n" "$a" > $file

# append to end of files
cat << EOF >> ${file}

#>>>>> BEGIN-ADDED-BY__'${WHICH_POD}@${label}'
export ${program_home}="${folder_path}"
export PATH=\$${program_home}/bin:\$PATH
export JVM_OPTS=“-Djava.io.tmpdir=${TEMP_FOLDER}”
#>>>>> END-ADDED-BY__'${WHICH_POD}@${label}'
EOF
}
