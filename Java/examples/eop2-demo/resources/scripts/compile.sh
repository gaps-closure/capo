#!/bin/bash

session="compile"

tmux start-server
tmux new-session -d -s $session -n compile

tmux selectp -t 1 
tmux send-keys "cd /tmp/xdcc/Purple_E; ant; ant -f build-closure.xml" C-m 

tmux splitw -p 50
tmux send-keys "cd /tmp/xdcc/Orange_E; ant; ant -f build-closure.xml" C-m 

tmux splitw -h -p 50
tmux send-keys "cd /tmp/xdcc/Green_E; ant; ant -f build-closure.xml" C-m 

tmux select-window -t $session:0
tmux attach-session -t $session
