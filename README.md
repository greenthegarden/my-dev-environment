# My Dev Environment Configuration

An [Ansible](http://www.ansible.com) project to configure a host with the tools I currently use to get work done!

Ansible provides a very powerful and fliexible way of automating the configuration of systems and is currently my prefered way of managing configuration for the following reasons:

* Can be used to configure both local and remote systems.
* Does not require the installation of any software on remote systems. Uses only ssh and therefore does require ssh access generally via ssh keys.
* Allows configuration to be undertaken on multiple systems in parallel.
* A disadvantage is that is does not play well on Windows based systems.

## Dependencies

The following dependencies are required to be installed on the host machine.

### Git

[Git](https://git-scm.com/) is required in order to clone this project and external roles. Install using (or other method depending on host OS and package manager):

```sh
sudo apt install git
git clone https://github.com/greenthegarden/my-dev-environment.git
```

### Ansible

[Ansible](https://www.ansible.com/) is used to automate the installation and configuration of the host system. Install via [Pip](https://pypi.org/pip), using (or other method depending on host OS and package manager):

```bash
sudo apt install python-pip
sudo pip install ansible --upgrade
```

## What is installed

The following packages are installed and configured:

* [Zsh](https://www.zsh.org/) with the [oh-my-zsh](https://ohmyz.sh/) libraries is installed using the [gantsign.antigen](https://github.com/gantsign/ansible_role_antigen.git) role. Configuration for the installation, including which antigen bundles are installed, is managed in the file [antigen.yml](antigen.yml).
* [Visual Studio Code](https://code.visualstudio.com/) is currently my prefered IDE and is installed using the [gantsign.visual-studio-code](https://github.com/gantsign/ansible-role-visual-studio-code.git) role. Configuration for the installation, including which extensions are installed, is managed in the file [vscode.yml](vscode.yml).
* [VirtualBox](https://www.virtualbox.org/)
* [Chromium](https://www.chromium.org/)
* [Docker](https://www.docker.com)

## Installing

The configuration for which system the installation is to occur is managed by the file [hosts.yml](hosts.yml). The file is preconfigured to the the installation on the current host machine, that is `localhost`. See information at http://www.ansible.com/inveontory to make changes to the file to run the installation on non-local systems.

To install everything at once, use

```sh
./run_ansible_play.sh
```

and select the default command line arguments.

To run the installation of only a single package, enter the following in place of the `site` command line option when running `./run_ansible_play.sh`:

| Package            | Option     |
| -------            | ---------- |
| Docker             | docker     |
| Chromium           | chromium   |
| VirtualBox         | virtualbox |
| Visual Studio Code | vscode     |
| Zsh                | antigen    |
