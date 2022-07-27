ssh liono rm -rf /tmp/xdcc
scp -r /tmp/xdcc liono:/tmp
ssh liono cp ~/ipc.txt /tmp/xdcc/purple_E/testprog/aspect
cp ~/ipc.txt /tmp/xdcc/orange_E/testprog/aspect
