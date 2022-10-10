#!/bin/sh -e

TUNNEL_PORT=
REMOTE_HOST=
SHOULD_RUN=true

function cleanup {
  SHOULD_RUN=false
  SSH_TUNNEL_PROCESS=$(ps aux | grep '[s]sh -f -D' | grep -v grep | awk '{print $2}')
  networksetup -setsocksfirewallproxystate Wi-Fi off
  kill $SSH_TUNNEL_PROCESS
}

trap cleanup EXIT

networksetup -setsocksfirewallproxystate Wi-Fi on

while $SHOULD_RUN; do
  SSH_TUNNEL_PROCESS_EXISTS=$(ps aux | grep '[s]sh -f -D' | grep -v grep | awk '{print $2}')

  
  if [[ "$SSH_TUNNEL_PROCESS_EXISTS" == '' ]]; then
    echo "Try to start tunnel..."
    ssh -f -D $TUNNEL_PORT -N $REMOTE_HOST -v
  fi

  sleep 3
done