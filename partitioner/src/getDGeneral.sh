grep D_general $1 | grep " -> " | sed -e "s/ -> /,/" -e "s/^  *//" -e "s/\[.*$/]=1;/"  -e "s/^/constraint D_general[/"

