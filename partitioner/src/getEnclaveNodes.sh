en=`grep enclave $1 | sed -e "s/^  *//" -e "s/ .*enclave=\"/,/" -e "s/\".*$//"`
for i in $en
do
	echo "constraint ENCLAVENODES[$i]=1;"
done
