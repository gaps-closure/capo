nt=`grep taint $1 | sed -e "s/^  *//" -e "s/ .*taint=\"/,/" -e "s/\".*$//"`
for l in $nt
do
	n=`echo $l | sed -e "s/,.*$//"`
	t=`echo $l | sed -e "s/^.*,//"`
	echo "$n,$t"
done
