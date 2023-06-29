# configsync
a collection of scripts and config I use to keep in sync between my computers


## setup

All

```
cat << EOF >> ~/.gitconfig
[include] 
    path = ~/.configsync/git/config
EOF

```

Darwin

```
echo "source ~/.configsync/bashrc" >> ~/.bash_profile
```

Linux

```
echo "source ~/.configsync/bashrc" >> ~/.bashrc
```

