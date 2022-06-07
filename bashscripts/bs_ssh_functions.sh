#
#
#
#

SSH_ENV="$HOME/.ssh/.agent_env"

function start_agent {
    echo "Initialising new SSH agent..."

    eval `/usr/bin/ssh-agent`
    echo 'export SSH_AUTH_SOCK'=$SSH_AUTH_SOCK >> ${SSH_ENV}
    echo 'export SSH_AGENT_PID'=$SSH_AGENT_PID >> ${SSH_ENV}

    echo succeeded
    chmod 600 "${SSH_ENV}"
    . "${SSH_ENV}" > /dev/null
    /usr/bin/ssh-add;
}

# Source SSH settings, if applicable
if [ -f "${SSH_ENV}" ]; then
    . "${SSH_ENV}" > /dev/null
    #ps ${SSH_AGENT_PID} doesn't work under cywgin
    ps -ef | grep ${SSH_AGENT_PID} | grep ssh-agent$ > /dev/null || {
        start_agent;
    }
else
    start_agent;
fi

# create our own hardlink to the socket (with random name)
MYSOCK=/tmp/ssh_agent.${RANDOM}.sock
ln -T $SSH_AUTH_SOCK $MYSOCK
export SSH_AUTH_SOCK=$MYSOCK

end_agent()
{
    # if we are the last holder of a hardlink, then kill the agent
    nhard=`ls -l $SSH_AUTH_SOCK | awk '{print $2}'`
    if [[ "$nhard" -eq 2 ]]; then
        rm ${SSH_ENV}
        /usr/bin/ssh-agent -k
    fi
    rm $SSH_AUTH_SOCK
}
trap end_agent EXIT
set +x
