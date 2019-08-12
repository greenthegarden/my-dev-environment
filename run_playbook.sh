#!/usr/bin/env bash

# uncomment following line to use sudo password
ask_pass_flag=true

# uncomment the following lines to use an ssh key file
#key_file_flag=false
#key_file="${HOME}/.ssh/id_rsa_pcnp"

# set verbose level to "" for none, or "v", "vv", or "vvv" for increasing levels 
verbose_level_arg="v"

ask_pass_arg=""
if [ ! -z ${ask_pass_flag+x} ] ; then
  ask_pass_arg="--ask-become-pass"
fi

key_file_arg=""
if [ ! -z ${key_file_flag+x} ] ; then
  if [ -f ${key_file} ] ; then
    key_file_arg="--private-key=${key_file}"
  else
    echo "key file ${key_file} not found"
    exit
  fi
fi

inventory_file="hosts.yml"

playbook_file="self-hosted-registry-repository.yml"

options="-${verbose_level_arg} ${ask_pass_arg} ${key_file_arg}"

# Execute play
if [ -f ${inventory_file} ] ; then
  ansible-playbook -i ${inventory_file} ${options} ${playbook_file} --skip-tags "images, projects"
else
  echo "Inventory file ${inventory_file} not found"
  exit
fi
