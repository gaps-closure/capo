grep DEF_USE $1 | grep " -> " | sed -e "s/ -> /,/" -e "s/^  *//" -e "s/\[.*$/]=1;/"  -e "s/^/constraint DEF_USE[/"

