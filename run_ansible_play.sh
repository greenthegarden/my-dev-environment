#!/usr/bin/env bash

# default values
extension="yml"
inventory="hosts"
playbook="site"
requirements="requirements"
use_retry=false
use_sudo=false
force_option=false
verbose_level="v"

# get command line arguments
while getopts "bfhl:rv:" opt ;
do
  case $opt in
    b) use_sudo=true;;
    f) force_option=true;;
    l) limit_arg=$OPTARG;;
    r) use_retry=true;;
    v) verbose_level=$OPTARG;;
    h) usage
    exit 0;;
    *) usage
    exit 1;;
  esac
done

# prompt for variables
read -p "Enter inventory file name [${inventory}]: " inventory_input
inventory="${inventory_input:-${inventory}}"
inventory_file="${inventory}.${extension}"
if [ ! -f "${inventory_file}" ] ;
then
  echo "Inventory file ${inventory_file} not found"
  exit
fi

read -p "Enter playbook file name [${playbook}]: " playbook_input
playbook="${playbook_input:-${playbook}}"
playbook_file="${playbook}.${extension}"
if [ ! -f "${playbook_file}" ] ;
then
  echo "Playbook file ${playbook_file} not found"
  exit
fi

if [ ${use_retry} = true ] || [ ! -z ${limit_arg+x} ] ;
then
  playbook_limits="--limit "
fi

if [ ! -z ${limit_arg+x} ] ;
then
  playbook_limits="${limit_arg} "
  echo "Playbook limit set to ${playbook_limits}"
fi

if [ ${use_retry} = true ] ;
then
  retry_file="${playbook}.retry"
  if [ -f ${retry_file} ] ;
  then
    echo "Will retry with file ${retry_file}"
    playbook_limits="@${retry_file}"
  else
    echo "Retry file ${retry_file} not found"
    exit
  fi
fi

playbook_options=""
if [ ${use_sudo} = true ] ;
then
  playbook_options="${playbook_options} --ask-become-pass"
fi

verbose_arg=""
if [ ! -z ${verbose_level+x} ] ;
then
  verbose_arg="-${verbose_level}"
  echo "Verbose level set to ${verbose_level}"
fi

galaxy_options=""
if [ ${force_option} = true ] ;
then
  galaxy_options="${galaxy_options} --force"
fi

requirements_file="${requirements}.${extension}"
if [ -f "${requirements_file}" ] ;
then
  echo "Getting dependent roles defined in ${requirements_file} ..."
  ansible-galaxy install -r ${requirements_file} ${galaxy_options}
fi

echo "Running playbook ${playbook_file} with inventory ${inventory_file} and options ${playbook_options} ..."
ansible-playbook -i ${inventory_file} ${playbook_options} ${verbose_arg} ${playbook_file} ${playbook_limits}
