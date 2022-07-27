#!/bin/bash

session="run"

HAL_DIR=~/gaps/hal
#JAGA_HAL_CFG=sample_zmq_bw_direct_jaga_green.cfg
#LIONO_HAL_CFG=sample_zmq_bw_direct_liono_orange.cfg
JAGA_HAL_CFG=sample_zmq_bw_direct_jaga_green_3enc.cfg
LIONO_HAL_CFG=sample_zmq_bw_direct_liono_orange_3enc.cfg

SCRIPTS=/tmp/xdcc/Purple_E/resources/scripts

ssh liono pkill hal

export JAGA_HAL_CMD="${HAL_DIR}/daemon/hal -l 1 $HAL_DIR/test/$JAGA_HAL_CFG"
export LIONO_HAL_CMD="ssh liono ${HAL_DIR}/daemon/hal -l 1 $HAL_DIR/test/$LIONO_HAL_CFG"

export JAGA_JAVA_CMD="${SCRIPTS}/runClosure.sh Purple_E"
export LIONO_JAVA_CMD="ssh liono ${SCRIPTS}/runClosure.sh Green_E"

tmux start-server
tmux new-session -d -s $session -n run

tmux send-keys "${JAGA_HAL_CMD}" C-m

tmux splitw -h -p 50
tmux send-keys "$LIONO_HAL_CMD" C-m 

if [ -z "${NO_JAVA}" ]; then
    tmux splitw -v -p 50
    
    tmux send-keys "$LIONO_JAVA_CMD" C-m 

    tmux selectp -t 0
    tmux splitw -v -p 50
    tmux send-keys "sleep 3; $JAGA_JAVA_CMD" C-m
fi

tmux select-window -t $session:0
tmux attach-session -t $session
