#!/bin/bash


mkdir -p ~/.gsync && wget -O - https://github.com/g--/configsync/archive/refs/heads/master.tar.gz | tar -xzf - --strip-components 1 -C ~/.gsync

echo "echo '. ~/.gsync/bashrc' >> ~/.bashrc"
echo ". ~/.gsync/bashrc"
