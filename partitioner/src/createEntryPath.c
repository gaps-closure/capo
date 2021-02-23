#include <stdio.h>
#include <time.h>
#include <ctype.h>
#include <stdlib.h>
#include <errno.h>
#include <string.h>
#define MAXNODE 10000
char PATH[MAXNODE][512];
int MAXDEPTH=0;
int DEPTH[MAXNODE];
char nodeList[MAXNODE][32];
char entryNodeList[MAXNODE][32];
unsigned short int edge[MAXNODE][MAXNODE];
unsigned short int mark[MAXNODE];
int pathX=0;
int nodeX=0;
int entryNodeX=0;
int edgeX=0;
void initEdge(){
	for (int i=0;i<MAXNODE;++i)
		for (int j=0;j<MAXNODE;++j)
			edge[i][j]=0;
}
char *getEntryNodeName(int i){
	return(entryNodeList[i]);
}
char *getNodeName(int i){
	return(nodeList[i]);
}
void addEntryNode(char *n){
	int i;
	for (i=0;i<entryNodeX;++i){
		if (strcmp(entryNodeList[i],n)==0){
			fprintf(stderr,"%s.%d duplicate entry node %s\n",
				__FUNCTION__,__LINE__,n);
		       	return;
		}
	}
	strcpy(entryNodeList[i],n);
	++entryNodeX;
}
void addNode(char *n){
	int i;
	for (i=0;i<nodeX;++i){
		if (strcmp(nodeList[i],n)==0){
			fprintf(stderr,"%s.%d duplicate node %s\n",
				__FUNCTION__,__LINE__,n);
		       	return;
		}
	}
	strcpy(nodeList[i],n);
	++nodeX;
}
int getEntryNodeIndex(char *n){
	int i;
	for (i=0;i<entryNodeX;++i){
		if (strcmp(entryNodeList[i],n)==0) return(i);
	}
	fprintf(stderr,"%s.%d cannot find entry node %s\n",
			__FUNCTION__,__LINE__,n);
	return(-1);
}
int getNodeIndex(char *n){
	int i;
	for (i=0;i<nodeX;++i){
		if (strcmp(nodeList[i],n)==0) return(i);
	}
	fprintf(stderr,"%s.%d cannot find %s\n",
			__FUNCTION__,__LINE__,n);
	return(-1);
}
void addEdge(char *p, char *c){
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
	edge[ip][ic]=1;
}
void DFS(int n,char *path,int depth){
	int i,children=0;
	char *myPath;
	char *myNode=getNodeName(n);
	++depth;
	if ((myPath=malloc(strlen(path)+strlen(myNode)+10))==0){
		fprintf(stderr,"%s.%d MALLOC FAILED\n",__FUNCTION__,__LINE__);
		exit(-1);
	}
	if (path[0]!='\0'){
	       	strcpy(myPath,path);
		strcat(myPath,",");
	}
	strcat(myPath,myNode);
	for(i=0;i<nodeX;++i){
		/*if ((edge[n][i]==1) && (mark[i] == 0)){*/
		if (edge[n][i]==1){
			++children;
		}
	}
	if (children == 0) {
		DEPTH[pathX]=depth;
		if (depth > MAXDEPTH) MAXDEPTH=depth;
		sprintf(PATH[pathX],"|%s,",myPath);
		/*for(i=0;i<nodeX-depth;++i) printf("NodeNULL,");
		printf("\n");*/
		++pathX;
		return;
	}
	for(i=0;i<nodeX;++i){
		/*if ((edge[n][i]==1) && (mark[i] == 0)){
			mark[i]=1;*/
		if (edge[n][i]==1){
			DFS(i,myPath,depth);
		}
	}
}

int main(int argc,char *argv[]){
	char l[512],tmpFile[128];
	int rc;
	FILE *f;
	initEdge();
	sprintf(tmpFile,"/tmp/t.%s.%ld",getenv("USER"),time(0));
	sprintf(l,"rm -rf %s",tmpFile);
	system(l);
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
	addNode("NodeNULL");
	while(fgets(l,512,f)){
		char n[32];
		if (sscanf(l,"%s\n",n)!=1){
			fprintf(stderr,"%s.%d cannot parse: %s\n",
					__FUNCTION__,__LINE__,l);
			exit(-1);
		}
		addNode(n);
	}
	if (nodeX==0) {
		fprintf(stderr,"%s.%d NO NODES\n",__FUNCTION__,__LINE__);
		exit(-1);
	}
	fclose(f);
	sprintf(l,"rm -rf %s",tmpFile);
	system(l);
	sprintf(l,"grep Node %s | grep ENTRY | grep -v \" -> \" | sed -e \"s/^  *//\" -e \"s/ .*//\" > %s",argv[2],tmpFile);
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
		addEntryNode(n);
	}
	if (entryNodeX==0) {
		fprintf(stderr,"%s.%d NO ENTRY NODES\n",__FUNCTION__,__LINE__);
		exit(-1);
	}
	fclose(f);
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
		if (getNodeIndex(p) != -1){
			addEdge(p,c);
		} else fprintf(stderr,"%s.%d skipping edge from %s to %s\n",
				__FUNCTION__,__LINE__,p,c);
	}
	for(int i=0;i<entryNodeX;++i){
		int x;
		char *entryName=0;
		if ((entryName=getEntryNodeName(i))==0){
			fprintf(stderr,"%s.%d ERROR\n",__FUNCTION__,__LINE__);
			exit(-1);
		}
		if ((x=getNodeIndex(entryName))==-1){
			fprintf(stderr,"%s.%d ERROR\n",__FUNCTION__,__LINE__);
			exit(-1);
		}
		DFS(x,"",0);
	}
	printf("%sEntryPath=%d;\n",argv[1],pathX);
	printf("%sEntryPathDepthMax=%d;\n",argv[1],MAXDEPTH);
	printf("entry%sDFS = [",argv[1]);
	for(int i=0;i<pathX;++i){
		printf("%s",PATH[i]);
		for (int k=0;k<MAXDEPTH-DEPTH[i];++k){
			printf("NodeNULL,");
		}
		printf("\n");
	}
	printf("|];\n");
	printf("%sEntryPathDepth =[",argv[1]);
	for(int i=0;i<pathX;++i){
		printf("%d,",DEPTH[i]);
	}
	printf("];\n");
}
