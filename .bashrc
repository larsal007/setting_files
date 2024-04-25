#!/bin/bash
# added by salim on 20220109
export C_RED='\033[0;31m'
export C_GRN='\033[0;32m'
export C_ORG='\033[0;33m'
export C_YLW='\033[1;33m'
export C_NC='\033[0m' # No Color1~


echo -e "${C_GRN}*** Add local ./bin to PATH env var${C_NC}"
export PATH=/applis/19525-ansbx-00/bin:$PATH

echo -e "${C_GRN}*** Set bash history${C_NC}"
export HISTSIZE=1000
export HISTFILESIZE=2000
export HISTCONTROL=ignoreboth
export HISTIGNORE='ls:bg:fg:cat:vi:history'
export HISTTIMEFORMAT='%F %T '
export PROMPT_COMMAND='history -a'

echo -e "${C_GRN}*** Set aliases${C_NC}"
alias ll='ls -alh --color=auto'
alias tas='tmux attach-session'
alias grep='grep --color=always'
alias glog='git log --oneline|grep '
alias ansible-playbook='ansible-playbook --check'

echo -e "${C_GRN}*** Set jfrog env vars${C_NC}"
export JFROG_CLI_REPORT_USAGE=false
export JFROG_CLI_OFFER_CONFIG=false
export JFROG_CLI_LOG_LEVEL=DEBUG
export CI=true

echo -e "${C_GRN}*** Set HOME + GIT_CONFIG${C_NC}"
export GIT_CONFIG=/applis/19525-ansbx-00/.gitconfig
export GIT_TERMINAL_PROMPT=1
export ANSB_PROJECT=/applis/19525-ansbx-00/ansb
export ANSIBLE_CONFIG=$ANSB_PROJECT/ansible.local.cfg
export HOME=/applis/19525-ansbx-00

if [[ -z "${GIT_USERNAME}" ]]; then
  echo -e "${C_RED}*** Set GIT credentials${C_NC}"
  read -p 'git username: ' user
  echo -n 'git password: '
  read -s password
  export GIT_USERNAME=$user
  export GIT_PASSWORD=$password
else
  echo -e "${C_GRN}*** GIT credentials already set${C_NC}"
fi
git_creds() { echo "username=${GIT_USERNAME}"; echo "password=${GIT_PASSWORD}"; }

if [[ -z "${ANSIBLE_VAULT_PASSWORD}" ]]; then
  echo
  echo -e "${C_RED}*** Set Ansible vault password${C_NC}"
  echo -n 'ansible vault password: '
  read -s password
  export ANSIBLE_VAULT_PASSWORD=$password
else
  echo -e "${C_GRN}*** ANSIBLE_VAULT_PASSWORD already set${C_NC}"
fi

echo
cd $ANSB_PROJECT

#read -r -p "Do you want to sync repos? [y/N] " response
#if [[ "$response" =~ ^([yY][eE][sS]|[yY])$ ]]
#then
#    echo -e "${C_GRN}*** Sync ansb & collections${C_NC}"
#    source $HOME/git_pull_all.sh
#fi

function git_branch {
  git branch --no-color 2> /dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/\1/'
}
# http://unix.stackexchange.com/questions/88307/escape-sequences-with-echo-e-in-different-shells
function markup_git_branch {
  if [[ "x$1" = "x" ]]; then
    echo -e "[$1]"
  else
    if [[ $(git status 2> /dev/null | tail -n1) = "nothing to commit, working directory clean" ]]; then
      echo -e '\033[1;32m['"$1"']\033[0;0m'
    else
      echo -e '\033[1;31m['"$1"'*]\033[0;0m'
    fi
  fi
}
export PS1='\033[1;33m\u@\h \[\033[0;34m\]\w\[\033[0m\] $(markup_git_branch $(git_branch))\n$ '
