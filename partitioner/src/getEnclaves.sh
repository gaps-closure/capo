echo "Enclaves = {"
e=`grep enclave $1 | sed -e "s/^.*enclave=\"//" -e "s/\".*$//" | sort -u`
for i in $e
do
	echo "$i,"
done
echo "};"
