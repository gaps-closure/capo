#!/bin/bash

session="run"

HAL_DIR=~/gaps/hal
HAL=${HAL_DIR}/daemon/hal

PURPLE_CFG=purple.cfg
ORANGE_CFG=orange.cfg
GREEN_CFG=green.cfg

SCRIPTS=/tmp/xdcc/Purple_E/resources/scripts

#ssh liono pkill hal

export PURPLE_HAL_CMD="${HAL} -l 1 $HAL_DIR/test/${PURPLE_CFG}"
export ORANGE_HAL_CMD="${HAL} -l 1 $HAL_DIR/test/${ORANGE_CFG}"
export GREEN_HAL_CMD="${HAL} -l 1 $HAL_DIR/test/${GREEN_CFG}"

export PURPLE_JAVA_CMD="${SCRIPTS}/runClosure.sh Purple_E"
export ORANGE_JAVA_CMD="${SCRIPTS}/runClosure.sh Orange_E"
export GREEN_JAVA_CMD="${SCRIPTS}/runClosure.sh Green_E"

tmux start-server
tmux new-session -d -s $session -n run

tmux send-keys "$PURPLE_HAL_CMD" C-m

tmux splitw -h -p 50
tmux send-keys "$ORANGE_HAL_CMD" C-m 

tmux splitw -h -p 50
tmux send-keys "$GREEN_HAL_CMD" C-m 

tmux selectp -t 0
tmux splitw -v -p 50
tmux send-keys "$PURPLE_JAVA_CMD" C-m 

tmux selectp -t 2
tmux splitw -v -p 50
tmux send-keys "$ORANGE_JAVA_CMD" C-m

tmux selectp -t 4
tmux splitw -v -p 50
tmux send-keys "$GREEN_JAVA_CMD" C-m

tmux select-window -t $session:0
tmux attach-session -t $session
