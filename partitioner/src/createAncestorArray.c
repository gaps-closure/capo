#include <stdio.h>
#include <time.h>
#include <ctype.h>
#include <stdlib.h>
#include <errno.h>
#include <string.h>
#define MAXNODE 10000
char nodeList[MAXNODE][32];
char llvmVarAnnotationNodeList[MAXNODE][32];
unsigned short int ancestors[MAXNODE][MAXNODE];
void initAncestors(){
	for (int i=0;i<MAXNODE;++i)
		for (int j=0;j<MAXNODE;++j)
			ancestors[i][j]=0;
}
int nln=0;
int llvmNn=0;
char *getNodeName(int i){
	return(nodeList[i]);
}
void dumpAncestorsArray(char *name){
	for (int i=0;name[i]!='\0';++i) name[i]=tolower(name[i]);
	fprintf(stdout, "%sAncestor = [",name);
	for(int i=0;i<nln;++i){
		fprintf(stdout,"|");
		for(int j=0;j<nln;++j){
			if (ancestors[i][j]==0) fprintf(stdout,"false,");
			else fprintf(stdout,"true,");
		}
		fprintf(stdout,"\n");
	}
	fprintf(stdout, "|];\n");
}
void dumpAncestors(){
	for(int i=0;i<nln;++i){
		fprintf(stderr,"%s\n",getNodeName(i));
		for (int j=0;j<nln;++j){
			if (ancestors[i][j]==1) fprintf(stderr,"   %s\n",
						getNodeName(j));
		}
		fprintf(stderr,"\n");
	}
}
void addLlvmVarAnnotationNode(char *n){
	int i;
	for (i=0;i<llvmNn;++i){
		if (strcmp(llvmVarAnnotationNodeList[i],n)==0){
			fprintf(stderr,"%s.%d duplicate node %s\n",
				__FUNCTION__,__LINE__,n);
		       	return;
		}
	}
	strcpy(llvmVarAnnotationNodeList[i],n);
	++llvmNn;
}
void addNode(char *n){
	int i;
	for (i=0;i<nln;++i){
		if (strcmp(nodeList[i],n)==0){
			fprintf(stderr,"%s.%d duplicate node %s\n",
				__FUNCTION__,__LINE__,n);
		       	return;
		}
	}
	strcpy(nodeList[i],n);
	++nln;
}
int getLlvmAnnotationNodeIndex(char *n){
	int i;
	for (i=0;i<llvmNn;++i){
		if (strcmp(nodeList[i],n)==0) return(i);
	}
	return(-1);
}
int getNodeIndex(char *n){
	int i;
	for (i=0;i<nln;++i){
		if (strcmp(nodeList[i],n)==0) return(i);
	}
	fprintf(stderr,"%s.%d cannot find %s\n",
			__FUNCTION__,__LINE__,n);
	return(-1);
}
struct node_ {
	char name[512];
	int nChildren;
	struct node_ **children;
} typedef node;
node N[MAXNODE];
int NN=0;
void fillIn(){
	int done=0,i1,i2,i3;
	while(done==0){
		done=1;
		for(i1=0;i1<nln;++i1){
			for(i2=0;i2<nln;++i2){
				if (ancestors[i1][i2]==1){
					for (i3=0;i3<nln;++i3){
						if (ancestors[i2][i3]==1){
							if (ancestors[i1][i3]==0) done=0;
							ancestors[i1][i3]=1;
						}
					}
				}
			}
		}
	}
}
void addParentChild(char *p, char *c){
	int ip,ic;
	if ((ip=getNodeIndex(p))==-1){
		fprintf(stderr,"%s.%d no index for %s\n",
				__FUNCTION__,__LINE__,p);
		exit(-1);
	}
	if ((ic=getNodeIndex(c))==-1){
		fprintf(stderr,"%s.%d no index for %s\n",
				__FUNCTION__,__LINE__,c);
		exit(-1);
	}
	ancestors[ip][ic]=1;
}
int main(int argc,char *argv[]){
	char l[512],tmpFile[128];
	int rc;
	FILE *f;
	initAncestors();
	sprintf(tmpFile,"/tmp/t.%s.%ld",getenv("USER"),time(0));
	sprintf(l,"rm -rf %s",tmpFile);
	system(l);
	//sprintf(l,"grep Node %s | grep llvm.var.annotation | sed -e \"s/^  *//\" -e \"s/ .*//\" > /tmp/t",argv[2]);
	sprintf(l,"grep Node %s | grep -v \" -> \" | sed -e \"s/^  *//\" -e \"s/ .*//\" > %s",argv[2],tmpFile);
	 if ((rc=system(l))==-1){
                fprintf(stderr,"%s.%d system(%s) failed with %s\n"
                        ,__FUNCTION__,__LINE__,l,
                        strerror(errno));
                return(-1);
        }
	if ((f=fopen(tmpFile,"r"))==0){
		fprintf(stderr,"%s.%d fopen(%s): %s\n",
				__FUNCTION__,__LINE__,strerror(errno),
				tmpFile);
		exit(-1);
	}
	while(fgets(l,512,f)){
		char n[32];
		if (sscanf(l,"%s\n",n)!=1){
			fprintf(stderr,"%s.%d cannot parse: %s\n",
					__FUNCTION__,__LINE__,l);
			exit(-1);
		}
		addLlvmVarAnnotationNode(n);
	}
	if (llvmNn==0) {
		fprintf(stderr,"%s.%d NO %s EDGES\n",__FUNCTION__,__LINE__,argv[1]);
		exit(-1);
	}
	sprintf(l,"rm -rf %s",tmpFile);
	system(l);
	sprintf(l,"grep -v \" -> \" %s | grep Node | sed -e \"s/^  *//\" -e \"s/ .*//\" > %s",argv[2],tmpFile);
	system(l);
	if ((f=fopen(tmpFile,"r"))==0){
		fprintf(stderr,"%s.%d fopen(%s): %s\n",
				__FUNCTION__,__LINE__,strerror(errno),
				tmpFile);
		exit(-1);
	}
	while(fgets(l,512,f)){
		char n[32];
		if (sscanf(l,"%s\n",n)!=1){
			fprintf(stderr,"%s.%d cannot parse: %s\n",
					__FUNCTION__,__LINE__,l);
			exit(-1);
		}
		addNode(n);
	}
	fclose(f);
	if (nln==0) {
		fprintf(stderr,"%s.%d NO %s EDGES\n",__FUNCTION__,__LINE__,argv[1]);
		exit(-1);
	}

	sprintf(l,"rm -rf %s",tmpFile);
	system(l);
	sprintf(l,"grep %s %s | grep \" -> \" |  sed -e \"s/ -> / /\" -e \"s/^  *//\" -e \"s/\\[.*$//\" > %s",argv[1],argv[2],tmpFile);
	system(l);
	if ((f=fopen(tmpFile,"r"))==0){
		fprintf(stderr,"%s.%d fopen(%s): %s\n",
				__FUNCTION__,__LINE__,strerror(errno),
				tmpFile);
		exit(-1);
	}
	while(fgets(l,512,f)){
		char p[512],c[512];
		if (sscanf(l,"%s %s",p,c) != 2) {
			fprintf(stderr,"%s.%d cannot parse: %s\n",
					__FUNCTION__,__LINE__,l);
			exit(-1);
		}
		if (getLlvmAnnotationNodeIndex(p) != -1){
			addParentChild(p,c);
		} else fprintf(stderr,"%s.%d skipping edge from %s to %s\n",
				__FUNCTION__,__LINE__,p,c);
	}
	fillIn();
	dumpAncestorsArray(argv[1]);
}
