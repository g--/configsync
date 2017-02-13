
CONFIG_SYNC_ROOT=~/.configsync

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"


PATH=${CONFIG_SYNC_ROOT}/bin:/usr/local/bin:/usr/local/sbin:/bin:/sbin:/usr/bin:/usr/sbin
export PATH

SSH_AUTH_SOCK=~/.gnupg/S.gpg-agent.ssh; export SSH_AUTH_SOCK

if [[ "$OSTYPE" == "linux-gnu" ]]; then
	OS_FAMILY='Linux'
elif [[ "$OSTYPE" == "darwin"* ]]; then
	OS_FAMILY='Darwin'
else
	OS_FAMILY='Other'
fi

if [ -d ${CONFIG_SYNC_ROOT}/bin.${OS_FAMILY} ]; then
PATH=${CONFIG_SYNC_ROOT}/bin.${OS_FAMILY}:${PATH}
export PATH
fi

if [ -d ${CONFIG_SYNC_ROOT}/bin.${OSTYPE} ]; then
PATH=${CONFIG_SYNC_ROOT}/bin.${OSTYPE}:${PATH}
export PATH
fi

if [ -e ${DIR}/bashrc.${OS_FAMILY} ]; then
  . ${DIR}/bashrc.${OS_FAMILY}
fi
if [ -e ${DIR}/bashrc.${OSTYPE} ]; then

  . ${DIR}/bashrc.${OSTYPE}
fi

# ~/bin takes priority.
if [ -d ~/bin ]; then
PATH=~/bin:${PATH}
export PATH
fi

