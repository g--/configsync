gpg-connect-agent --quiet /bye
set -gx SSH_AUTH_SOCK (gpgconf --list-dirs agent-ssh-socket)

