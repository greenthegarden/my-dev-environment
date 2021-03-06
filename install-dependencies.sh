#!/usr/bin/env bash

# install pip
sudo apt-get install -y git shellcheck
# python3-pip

# install base python modules
python3 -m pip install -r requirements.txt --upgrade
python3 -m pipx ensurepath

# now use pipx to install the rest
pipx install ansible # IT automation
pipx install molecule # Testing
pipx install pre-commit
# pipx install yamllint # YAML lint tool
# pipx install ansible-lint # Ansible lint tool

# pipx install black  # uncompromising Python code formatter
# pipx install flake8  # tool for style guide enforcement
# pipx install gdbgui  # browser-based gdb debugger
# pipx install poetry  # python dependency/environment/packaging management
# pipx install pylint  # source code analyzer
# pipx install pyxtermjs  # fully functional terminal in the browser
# pipx install cookiecutter  # creates projects from project templates

# install git hook scripts
pre-commit install

extension="yml"
requirements="requirements"
requirements_file="${requirements}"."${extension}"
if [ -f "${requirements_file}" ] ; then
    echo "Getting dependent roles defined in ${requirements_file} ..."
    ansible-galaxy install -r "${requirements_file}"
else
    echo "Why!"
fi
