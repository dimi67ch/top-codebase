# Microk8s Ansible Playbook

This playbook installs and configures a Kubernetes cluster with [microk8s](https://microk8s.io/) on a debian based system. Furthermore, it installs and configures [Helm](https://helm.sh/) which is a package manager for Kubernetes. It can be used to deploy applications and services to a Kubernetes cluster.

## Installation

### Windows

1. Install [WSL2](https://docs.microsoft.com/en-us/windows/wsl/install-win10)
    1. `wsl --install`
    2. `wsl --set-default-version 2`
2. Install [Ubuntu on WSL2](https://apps.microsoft.com/detail/9pdxgncfsczv?hl=en-us&gl=US)
    1. `wsl --install -d Ubuntu`
    2. Open Ubuntu from the start menu and set up a user
    3. `sudo apt update`
    4. `sudo apt upgrade`
3. Install [Ansible](https://docs.ansible.com/ansible/latest/installation_guide/intro_installation.html#installing-ansible-on-ubuntu)
    1. `sudo apt install ansible`

### Ubuntu

1. `sudo apt update`
2. `sudo apt install ansible`

### MacOS

1. Install [Homebrew](https://brew.sh/)
    1. `/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"`
2. Install [Ansible](https://docs.ansible.com/ansible/latest/installation_guide/intro_installation.html#installing-ansible-on-macos)
    1. `brew install ansible`

## Usage

1. Clone this repository `git clone https://gitlab.rlp.net/top/24s/secplay/codebase.git`
2. Change into the directory `cd codebase/ansible/quick_deploy`
3. Edit the inventory file `inventory.ini` with your preferences (e.g. the IP address of the target machine)
4. Edit `group_vars/all.yml` to specify:
    1. which repo should be added
    2. which application should be deployed
    3. on what processor architecture the system is running on
    4. the credentials to your private container registry
5. Run the playbook `ansible-playbook -i inventory.ini playbook.yml -Kk`

> **Note:** The `-K` flag is used to prompt for the sudo password. If you want to run the playbook without the prompt, you must edit the sudoers file on the target machine to allow passwordless sudo for your user.

> **Note:** The `-k` flag is used to prompt for the ssh password. If you want to run the playbook without the prompt, you must set up ssh keys for the target machine.

## Running without promting for password

### SSH keys

1. Generate a new ssh key `ssh-keygen -t ed25519`
> **Note:** If you are using a legacy system that doesn't support the Ed25519 algorithm, use: `ssh-keygen -t rsa -b 4096`

2. Copy the public key to the target machine `ssh-copy-id <username>@<target-ip>`. Replace `<username>` with your username and `<target-ip>` with the IP address of the target machine.
3. Enter the password for the target machine when prompted.

### Passwordless sudo

1. Edit the sudoers file on the target machine `sudo visudo`
2. Add the following line to the file `<username> ALL=(ALL) NOPASSWD: ALL`. Replace `<username>` with your username.
3. Save the file and exit the editor.

## License

This project is licensed under the European Union Public License v. 1.2.

See [LICENSE/EUPL v1_2 EN.txt](https://gitlab.rlp.net/top/24s/secplay/codebase/-/blob/43c8be19f6db45cee733edb694ba311fff694993/LICENSE/EUPL%20v1_2%20EN.txt)