#!bash

# Start SSH Agent
#----------------------------

SSH_ENV="$HOME/.ssh/.agent_env"

function run_ssh_env {
  . "${SSH_ENV}" > /dev/null
}

function start_ssh_agent {
  echo "Initializing new SSH agent..."
  ssh-agent | sed 's/^echo/#echo/' > "${SSH_ENV}"
  echo "succeeded"
  chmod 600 "${SSH_ENV}"
  run_ssh_env;
}

function ssh_register_all_keys {
  echo "adding ssh keys:"
  for key in ${HOME}/.ssh/id_*; do
     if grep -q PRIVATE "$key"; then
          echo "adding ${key}"
		  ssh-add "$key"
     fi
  done
}


if [ -f "${SSH_ENV}" ]; then
  run_ssh_env;
  ps -ef | grep ${SSH_AGENT_PID} | grep ssh-agent$ > /dev/null || {
    start_ssh_agent;
  }
  else
    start_ssh_agent;
	
  ssh_register_all_keys
fi
