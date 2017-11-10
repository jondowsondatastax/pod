#!/bin/bash

# author:        jondowson
# about:         prepare dse 'resources' folder by removing all non-configuration files

#--------------------------------------------

## uncomment to see full bash trace (debug)
# set -x

#--------------------------------------------

function pod_dse_prepareResourcesFolder(){

## assign paths to variables

destination_folder_parent_path="${pod_home_path}/builds/pod_dse/${BUILD_FOLDER}/"
destination_folder_path="${destination_folder_parent_path}resources/"
source_folder_path="${pod_home_path}/tmp/${DSE_VERSION}/resources/"

# -------------------------------------------

## check to see folder paths exist

pod_generic_misc_folderExistsCheckAbort ${destination_folder_parent_path}

# -------------------------------------------

## copy resources folder from dse package to dse-setup

if [ -d "${destination_folder_path}" ]; then

  pod_generic_display_msgColourSimple "info-indented" "Existing ${yellow}'${BUILD_FOLDER}/resources'${white} will be deleted"
  printf "%s\n"
  pod_generic_display_msgColourSimple "alert" "Are you sure ?"
  printf "%s\n"
  pod_generic_misc_timecount "${STAGE_PAUSE}" "<ctrl-c> to abort now.."
  rm -rf ${destination_folder_path}
  pod_dse_display_banner
  pod_generic_display_msgColourSimple "title" "Preparing 'resources' folder"
fi

pod_generic_display_msgColourSimple "info" "Unzip from:   ${red}${dse_tar_file}${reset}"
pod_generic_display_msgColourSimple "info" "Unzip to:     ${yellow}${source_folder_path}${reset}"
printf "%s\n"
pod_generic_display_msgColourSimple "alert" "Strip files from 'resources' folder"

mkdir -p "${pod_home_path}/tmp"
tar -xf "${dse_tar_file}" -C "${pod_home_path}/tmp/"

#-------------------------------------------

## declare file extensions to remove in an array

declare -a array_file_extensions_to_strip
array_file_extensions_to_strip[0]="zip"
array_file_extensions_to_strip[1]="gz"
array_file_extensions_to_strip[2]="jar"
array_file_extensions_to_strip[3]="jar.*"
array_file_extensions_to_strip[4]="md"
array_file_extensions_to_strip[5]="so.*"
array_file_extensions_to_strip[6]="so"
array_file_extensions_to_strip[7]="js"
array_file_extensions_to_strip[8]="a"
array_file_extensions_to_strip[9]="py"
array_file_extensions_to_strip[10]="R"
array_file_extensions_to_strip[11]="rds"
array_file_extensions_to_strip[12]="rdx"
array_file_extensions_to_strip[13]="rdb"
array_file_extensions_to_strip[14]="sl"
array_file_extensions_to_strip[15]="dylib"
array_file_extensions_to_strip[16]="dll"
array_file_extensions_to_strip[17]="txt"
array_file_extensions_to_strip[18]="data"
array_file_extensions_to_strip[19]="html"
array_file_extensions_to_strip[20]="css"
array_file_extensions_to_strip[21]="csv"
array_file_extensions_to_strip[22]="png"
array_file_extensions_to_strip[23]="gif"
array_file_extensions_to_strip[24]="svg"
array_file_extensions_to_strip[25]="jsp"
array_file_extensions_to_strip[26]="kryo"

# -------------------------------------------

## display stats on removed files

printf "%s\n"
printf "%s\t%s\t%s\t%s\t%s\n" "${b}Extension" "|" "No." "|" "Bytes${reset}"
printf "%s\n" "--------------------------------------------------"
sleep 5 # for the benefit of macs - otherwise file permission errors !!
before_size=$(du -sh "${source_folder_path}" | awk '{ print $1 }')

for i in "${array_file_extensions_to_strip[@]}"
do
  amount=$(find ${source_folder_path} -name "*.${i}" -type f -print | wc -l)
  size=$(find ${source_folder_path} -name "*.${i}" -type f -print | xargs wc -c | awk 'END { print $1 }')
  printf "%s\t\t%s\t%s\t%s\t%s\n" "${yellow}*.${i}${reset}" "|" "${amount}" "|" "${size}"
  find ${source_folder_path} -name "*.${i}" -type f -delete
done

printf "%s\n" "--------------------------------------------------"
printf "%s\t\t\t%s\n"   "${b}Folder size before:" "${before_size}"
printf "%s\t\t\t%s\n\n" "${b}Folder size after:"  "$(du -sh ${source_folder_path} | awk '{ print $1 }')${reset}"

# -------------------------------------------

## copy source folder to destination folder
pod_generic_display_msgColourSimple "alert" "Move stripped 'resources' folder to 'dse-setup'"
printf "%s\n"
pod_generic_display_msgColourSimple "info" "move from:    ${yellow}${source_folder_path}${reset}"
pod_generic_display_msgColourSimple "info" "move to:      ${green}${destination_folder_path}${reset}"
printf "%s\n"
cp -rp ${source_folder_path} ${destination_folder_path}
rm -rf "${pod_home_path}tmp/"
}
