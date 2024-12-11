#!/bin/bash

# Exit on any error. If something fails, there's no use
# proceeding further because Jenkins might not be able 
# to run in that case
set -e

# Prepare ssh keys
# Create it in the user workspace so we can store it
cd ~/webpage_ws
if [ ! -f id_rsa_2nd ]; then
    ssh-keygen -q -N '' -C '' -f id_rsa_2nd
fi

# Copy the ssh key to the ~/.ssh directory
mkdir -p ~/.ssh
chmod 700 ~/.ssh 
cd ~/.ssh
if [ ! -f id_rsa_2nd ]; then
    cp ~/webpage_ws/id_rsa_2nd .
    cp ~/webpage_ws/id_rsa_2nd.pub .
    chmod 600 id_rsa_2nd
    cat id_rsa_2nd.pub >> authorized_keys
    chmod 600 authorized_keys
fi

# Start the ssh agent
eval "$(ssh-agent -s)"
ssh-add ~/.ssh/id_rsa_2nd

# config git
git config --global user.name 'Jenkins Course'
git config --global user.email 'jenkins@theconstruct.ai'
