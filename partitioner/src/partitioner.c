#include "partitioner.h"

#include <stdio.h>
#include <string.h>
#include <stdlib.h>
#include <fcntl.h>
#include <sys/stat.h>
#include <sys/types.h>
#include <unistd.h>

#define DEV_IMPL
#define CONFIGDEV "/dev/vcom"
//#define FIFO_IMPL

char *bin2hex(const unsigned char *bin, size_t len)
{
	char   *out;
	size_t  i;

	if (bin == NULL || len == 0)
		return NULL;

	out = malloc(len*2+1);
	for (i=0; i<len; i++) {
		out[i*2]   = "0123456789ABCDEF"[bin[i] >> 4];
		out[i*2+1] = "0123456789ABCDEF"[bin[i] & 0x0F];
	}
	out[len*2] = '\0';

	return out;
}

int hexchr2bin(const char hex, char *out)
{
	if (out == NULL)
		return 0;

	if (hex >= '0' && hex <= '9') {
		*out = hex - '0';
	} else if (hex >= 'A' && hex <= 'F') {
		*out = hex - 'A' + 10;
	} else if (hex >= 'a' && hex <= 'f') {
		*out = hex - 'a' + 10;
	} else {
		return 0;
	}

	return 1;
}

size_t hexs2bin(const char *hex, unsigned char **out)
{
	size_t len;
	char   b1;
	char   b2;
	size_t i;

	if (hex == NULL || *hex == '\0' || out == NULL)
		return 0;

	len = strlen(hex);
	if (len % 2 != 0)
		return 0;
	len /= 2;

	*out = malloc(len);
	memset(*out, 'A', len);
	for (i=0; i<len; i++) {
		if (!hexchr2bin(hex[i*2], &b1) || !hexchr2bin(hex[i*2+1], &b2)) {
			return 0;
		}
		(*out)[i] = (b1 << 4) | b2;
	}
	return len;
}

#ifdef FIFO_IMPL

static char * MY_ENCLAVE;

int initialize_partitioner(char * enclave) {
  MY_ENCLAVE = strdup(enclave);
  return OK;
}

int cleanup_partitioner() {
  while (1) {
    sleep(10);
  }
}

static char * get_pipe_name(char * enclave, char * name) {
  int BUF_MAX = 10000;
  char buf[BUF_MAX];
  snprintf(buf, BUF_MAX, "%s_%s_%s", "/tmp/gaps_partitioner", enclave, name);
  return strdup(buf);
}

static int ensure_existence(char * pname) {
  //does it exist?
  struct stat stat_p;
  if (stat(pname, &stat_p) != 0) {
    //maybe does not exist, try make it and stat it again
    perror("Cannot stat fifo");    
    if (mkfifo(pname, 0666) != 0) {
      perror("Cannot create fifo");
      return NOTOK;
    } else {
      if (stat(pname, &stat_p) != 0) {
	perror("Created, but cannot stat fifo again");
	return NOTOK;
      }
    }
  }
  //fifo exists, but is it a fifo?
  if (! S_ISFIFO(stat_p.st_mode)) {
    return NOTOK;
  }
  return OK;
}


int guarded_send(char * enclave, char * name, int size, void * data_ptr) {
  char * pipe_name = get_pipe_name(enclave, name);
  if (ensure_existence(pipe_name) == NOTOK) {
    free(pipe_name);
    return NOTOK;
  }
  int fd = open(pipe_name, O_WRONLY);
  write(fd, &size, sizeof(size));
  write(fd, data_ptr, size);
  close(fd);
  free(pipe_name);
  return OK;
}


int guarded_receive(char * name, int size_max, void ** variable_ptr) {
  char * pipe_name = get_pipe_name(MY_ENCLAVE, name);
  if (ensure_existence(pipe_name) == NOTOK) {
    free(pipe_name);
    return NOTOK;
  }
  int fd = open(pipe_name, O_RDONLY);
  int size;
  read(fd, &size, sizeof(size));
  if (size != size_max) {
    printf("Size mismatch: received %d for variable sized %d\n", size, size_max);
    return NOTOK;
  }

  if (*variable_ptr == NULL) {
    *variable_ptr = malloc(size);
  }
  read(fd, *variable_ptr, size);
  close(fd);
  free(pipe_name);    
  return OK;
}
#endif


/*********************************************************************************************
 *********************************************************************************************/

#ifdef DEV_IMPL

static char * MY_ENCLAVE;
static int fd;

int cleanup_partitioner() {
  while (1) {
    sleep(10);
  }
}

int initialize_partitioner(char * enclave) {
  MY_ENCLAVE = strdup(enclave);
  fd = open(CONFIGDEV, O_RDWR);
  if (fd < 0) {
    fprintf(stderr, "Device open failed: %s", CONFIGDEV);
    exit(1);
  }
  return OK;
}

//  const char    *a = "Test 123! - jklmn";
// 	char          *hex;
// 	unsigned char *bin;
// 	size_t         binlen;

// 	hex = bin2hex((unsigned char *)a, strlen(a));
// 	printf("%sn", hex);

// 	binlen = hexs2bin(hex, &bin);
// 	printf("%.*sn", (int)binlen, (char *)bin);

// 	free(bin);
// 	free(hex);
// 	return 0;

// XXX: guarded_send/receive need to handle binary & network endianess
// XXX: use google protobuf and socat to handle binary
int guarded_send(char * enclave, char * name, int size, void * data_ptr) {
  char strnamelen[3];
  char* hex;
  hex = bin2hex((unsigned char *)data_ptr, size);

  int namelen = strlen(name);
  if (namelen > 255) {
    fprintf(stderr, "namelen too long");
    free(hex);
    return NOTOK;
  }
  sprintf(strnamelen, "%02x", namelen);
  strnamelen[2] = '\0';
  if (write(fd, &strnamelen, strlen(strnamelen)) < 0) {
    perror("write");
    free(hex);
    return NOTOK;
  }
  if (write(fd, name, namelen) < 0) {
    perror("write");
    free(hex);
    return NOTOK;
  } 
  if (size > 255) {
    fprintf(stderr, "size of payload too long");
    free(hex);
    return NOTOK;
  }
  sprintf(strnamelen, "%02x", size); //XXX: size in bytes of binary, other side should read 2 * size bytes of hex
  if (write(fd, &strnamelen, strlen(strnamelen)) < 0) {
    perror("write");
    free(hex);
    return NOTOK;
  } 
  if (write(fd, hex, strlen(hex)) < 0) {
    perror("write");
    free(hex);
    return NOTOK;
  }
  write(fd, "\n", 1);
  free(hex);
  return OK;
}


int guarded_receive(char * name, int size_max, void ** variable_ptr) {
  char hexnamelen[3];
  char recv_name[256];
  char payload[256*2];  // hex will be twice of bin size
  int binlen;
  
  read(fd, hexnamelen, 2);
  hexnamelen[2]='\0';
   
  int namelen;
  sscanf(hexnamelen, "%02x", &namelen);  
  if (read(fd, recv_name, namelen) < 0) {
    perror("read");
    return NOTOK;
  }
  recv_name[namelen] = '\0';
  if (strcmp(recv_name, name) != 0) {
    printf("Name mismatch: expected %s, received %s\n", name, recv_name);
    return NOTOK;
  }

  read(fd, hexnamelen,2);   
  sscanf(hexnamelen, "%02x", &namelen); 
  if (read(fd, payload, 2*namelen) < 0) {
    perror("read");
    return NOTOK;
  }
  payload[2*namelen]='\0';

  binlen = hexs2bin(payload, (unsigned char**)(variable_ptr));
  fprintf(stderr, "namelen=%d binlen=%d\n", namelen, binlen);
  if (binlen != size_max) {
    printf("Size mismatch: received %d for variable sized %d\n", binlen, size_max);
    free(*variable_ptr);
    variable_ptr = NULL;
    return NOTOK;
  }
  char nl[1];
  read(fd,nl,1); // throw away new line
  return OK;
}

#endif
