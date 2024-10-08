
SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )
export CONFIG_SYNC_ROOT=~/.gsync

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"


PATH=${HOME}/bin:${CONFIG_SYNC_ROOT}/bin:${HOME}/.local/bin:${HOME}/.pyenv:${HOME}/.krew/bin:/usr/local/bin:/usr/local/sbin:/bin:/sbin:/usr/bin:/usr/sbin:/snap/bin
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

if [ $(type -P pyenv) ]; then
	eval "$(pyenv init -)"
fi

. ${DIR}/bashrc.all
