#include <stdio.h>
#include <string.h>
#include <stdlib.h>
#include <fcntl.h>
#include <sys/stat.h>
#include <sys/types.h>
#include <unistd.h>
#include <errno.h>
char masterFile[200000][32],mergeFile[200000][32];
int masterFileN=0,mergeFileN=0;
int check(char *n){
	for(int i=0;i<mergeFileN;++i){
		if(strcmp(n,mergeFile[i])==0) return(0);
	}
	return(1);
}
char  *myfgets(char *b,int size,FILE *f){
	char *rc = fgets(b,size,f);
	if (rc) {
		b[strlen(b)-1]='\0';
	}
	return(rc);
}
int main(int argc, char *argv[]){
	FILE *f;
	if (argc != 3) {
		fprintf(stderr,"%s.%d usage %s masterFile mergeFile\n",
				__FUNCTION__,__LINE__,argv[0]);
		exit(-1);
	}
	if ((f=fopen(argv[1],"r"))==0){
		fprintf(stderr,"%s.%d fopen(%s) %s\n",
			       __FUNCTION__,__LINE__,argv[1],
			       strerror(errno));
		exit(-1);
	}
	while(myfgets(masterFile[masterFileN],32,f)) masterFileN++;
	if ((f=fopen(argv[2],"r"))==0){
		fprintf(stderr,"%s.%d fopen(%s) %s\n",
			       __FUNCTION__,__LINE__,argv[2],
			       strerror(errno));
		exit(-1);
	}
	while(myfgets(mergeFile[mergeFileN],32,f)) mergeFileN++;
	for(int i=0;i<masterFileN;++i){
		if (check(masterFile[i])==0) printf("true,\n");
		else printf("false,\n");
	}
}
	
