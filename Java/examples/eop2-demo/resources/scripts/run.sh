#!/bin/bash

usage_exit() {
  [[ -n "$1" ]] && echo $1
  echo "Usage: $0 [ -hwx ] "
  echo "  -w  <hal home directory>"
  echo "  -x  <partitioned xdcc directory>"
  echo "  -h  Help"
  exit 1
}

handle_opts() {
  local OPTIND
  while getopts "hx:w:" options; do
    case "${options}" in
      w) HAL_DIR=${OPTARG}     ;;
      x) XDCC=${OPTARG}        ;;
      h) usage_exit            ;;
      :) usage_exit "Error: -${OPTARG} requires an argument." ;;
      *) usage_exit "" ;;
    esac
  done

  shift $((OPTIND -1))
}

args=("$@")
handle_opts "$@"

if [ -z "$XDCC" ]; then
    XDCC=/tmp/xdcc
fi

if [ -z "$HAL_DIR" ]; then
    HAL_DIR=~/gaps/hal
fi

SCRIPT=$(readlink -f "$0")
THIS_DIR=$(dirname "$SCRIPT")

HAL=${HAL_DIR}/daemon/hal

PURPLE=purple_E
ORANGE=orange_E
GREEN=green_E

PURPLE_CFG=${XDCC}/hal_${PURPLE}.cfg
ORANGE_CFG=${XDCC}/hal_${ORANGE}.cfg
GREEN_CFG=${XDCC}/hal_${GREEN}.cfg

export PURPLE_HAL_CMD="${HAL} -l 0 ${PURPLE_CFG} 2>&1 | tee ${XDCC}/${PURPLE}_hal.log"
export ORANGE_HAL_CMD="${HAL} -l 0 ${ORANGE_CFG} 2>&1 | tee ${XDCC}/${ORANGE}_hal.log"
export GREEN_HAL_CMD="${HAL} -l 0 ${GREEN_CFG} 2>&1 | tee ${XDCC}/${GREEN}_hal.log"

export PURPLE_JAVA_CMD="${THIS_DIR}/runClosure.sh ${XDCC} ${PURPLE}"
export ORANGE_JAVA_CMD="${THIS_DIR}/runClosure.sh ${XDCC} ${ORANGE}"
export GREEN_JAVA_CMD="${THIS_DIR}/runClosure.sh ${XDCC} ${GREEN}"

session="run"

tmux start-server
tmux new-session -d -s $session -n run

tmux send-keys "$PURPLE_HAL_CMD" C-m

tmux splitw -h -p 50
tmux send-keys "$ORANGE_HAL_CMD" C-m 

tmux splitw -h -p 50
tmux send-keys "$GREEN_HAL_CMD" C-m 

tmux selectp -t 0
tmux splitw -v -p 50
tmux send-keys "sleep 3; $PURPLE_JAVA_CMD" C-m 

tmux selectp -t 2
tmux splitw -v -p 50
tmux send-keys "$ORANGE_JAVA_CMD" C-m

tmux selectp -t 4
tmux splitw -v -p 50
tmux send-keys "$GREEN_JAVA_CMD" C-m

tmux select-window -t $session:0
tmux attach-session -t $session
