echo "Vertices = {"
n=`grep -v " -> " $1 | grep Node | sed -e "s/^  *//" -e "s/ .*//"`
for i in $n
do
	echo "$i,"
done
echo "};"
