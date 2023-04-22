#!/bin/bash


mkdir -p ~/.configsync && wget -O - https://github.com/g--/configsync/archive/refs/heads/master.tar.gz | tar -xzf - --strip-components 1 -C ~/.configsync

echo "echo '. ~/.configsync/bashrc' >> ~/.bashrc"
echo ". ~/.configsync/bashrc"
