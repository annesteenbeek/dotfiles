#!/bin/bash

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"

# Install ansible 2.9
sudo add-apt-repository ppa:ansible/ansible-2.9 -y
sudo apt-get update
sudo apt-get install ansible -y

ansible-playbook -i $DIR/hosts $DIR/main_playbook.yaml --ask-become
