#!/bin/bash

usage_exit() {
  [[ -n "$1" ]] && echo $1
  echo "Usage: $0 [ -hwx ] "
  echo "  -l  <log level>                  0=TRACE, 1=DEBUG, 2=INFO, 3=WARN, 4=ERROR, 5=FATAL (default 1)"
  echo "  -w  <hal home directory>         (default ~/gaps/hal)"
  echo "  -x  <partitioned xdcc directory> (default /tmp/xdcc)"
  echo "  -h  Help"
  exit 1
}

handle_opts() {
  local OPTIND
  while getopts "hl:x:w:" options; do
    case "${options}" in
      l) LOG_LEVEL=${OPTARG}   ;;
      w) HAL_DIR=${OPTARG}     ;;
      x) XDCC=${OPTARG}        ;;
      h) usage_exit            ;;
      :) usage_exit "Error: -${OPTARG} requires an argument." ;;
      *) usage_exit "" ;;
    esac
  done

  shift $((OPTIND -1))
}

rm -rf /tmp/xdcc
ln -s /home/closure/gaps/xdcc /tmp

XDCC=/tmp/xdcc
HAL_DIR=/home/closure/gaps/hal
LOG_LEVEL=1

args=("$@")
handle_opts "$@"

LOG_DIR=${XDCC}/logs
mkdir -p ${LOG_DIR}

SCRIPT=$(readlink -f "$0")
THIS_DIR=$(dirname "$SCRIPT")

HAL=${HAL_DIR}/daemon/hal

PURPLE=purple_E
ORANGE=orange_E
GREEN=green_E

PURPLE_CFG=${XDCC}/hal_${PURPLE}.cfg
ORANGE_CFG=${XDCC}/hal_${ORANGE}.cfg
GREEN_CFG=${XDCC}/hal_${GREEN}.cfg

export PURPLE_HAL_CMD="${HAL} -l ${LOG_LEVEL} ${PURPLE_CFG} 2>&1 | tee ${LOG_DIR}/${PURPLE}_hal.log"
export ORANGE_HAL_CMD="${HAL} -l ${LOG_LEVEL} ${ORANGE_CFG} 2>&1 | tee ${LOG_DIR}/${ORANGE}_hal.log"
export GREEN_HAL_CMD="${HAL} -l ${LOG_LEVEL} ${GREEN_CFG} 2>&1 | tee ${LOG_DIR}/${GREEN}_hal.log"

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
