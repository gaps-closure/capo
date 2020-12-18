grep GLOBAL_DEP $1 | grep " -> " | sed -e "s/ -> /,/" -e "s/^  *//" -e "s/\[.*$/]=1;/"  -e "s/^/constraint GLOBAL_DEP[/"

