# configsync
a collection of scripts and config I use to keep in sync between my computers


## setup

All

```
cat << EOF >> ~/.gitconfig
[include] 
    path = ~/.configsync/git/config
EOF

mkdir ~/.gnupg
chmod og-rx ~/.gnupg
```

Darwin

```
echo "source ~/.configsync/bashrc" >> ~/.bash_profile
```

Linux

```
echo "source ~/.configsync/bashrc" >> ~/.bashrc
```

