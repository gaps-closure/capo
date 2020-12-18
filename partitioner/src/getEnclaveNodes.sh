grep enclave $1 | sed -e "s/^  *//" -e "s/ .*enclave=\"/,/" -e "s/\".*$//"
