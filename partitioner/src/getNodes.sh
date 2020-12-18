grep -v " -> " $1 | grep Node | sed -e "s/^  *//" -e "s/ .*//"
