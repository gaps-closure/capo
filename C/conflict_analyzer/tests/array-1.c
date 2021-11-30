#include <stdio.h>

#define ARRAY_SIZE 5

#pragma cle def PURPLE {"level":"purple"}
#pragma cle def PURPLE_SHAREABLE { "level": "purple", \
  "cdf": [ \
    {"remotelevel": "orange", \
     "direction": "bidirectional", \
     "guarddirective": { "operation": "allow"} } \
    ]}
#pragma cle def XDLINKAGE_VALID_ARRAY {"level":"purple",	\
  "cdf": [\
    {"remotelevel":"orange", \
     "direction": "bidirectional", \
     "guarddirective": { "operation": "allow"}, \
     "argtaints": [["TAG_REQUEST_ARRAY_COMPUTATION"]], \
     "codtaints": ["PURPLE", "PURPLE_SHAREABLE"], \
     "rettaints": ["TAG_RESPONSE_ARRAY_COMPUTATION"] },\
    {"remotelevel":"purple", \
     "direction": "bidirectional", \
     "guarddirective": { "operation": "allow"}, \
     "argtaints": [["TAG_REQUEST_ARRAY_COMPUTATION"]], \
     "codtaints": ["PURPLE", "PURPLE_SHAREABLE"], \
     "rettaints": ["TAG_RESPONSE_ARRAY_COMPUTATION"] }\
  ] }
#pragma cle def ORANGE {"level":"orange",\
  "cdf": [\
    {"remotelevel":"purple", \
     "direction": "egress", \
     "guarddirective": { "operation": "allow"}}\
  ] }

#pragma cle begin XDLINKAGE_VALID_ARRAY
int *array_computation(int arr[ARRAY_SIZE]) {
#pragma cle end XDLINKAGE_VALID_ARRAY
#pragma cle begin PURPLE
    static int result[ARRAY_SIZE]; 
#pragma cle end PURPLE
    int sum = 0;
    for (int i = 0; i < ARRAY_SIZE; i++) {
        sum += arr[i]; 
        result[i] = sum;
    }
   return result;
}

int *get_array() {
#pragma cle begin ORANGE
    int arr[ARRAY_SIZE] = { 0, 1, 2, 3, 4 };
#pragma cle end ORANGE
    return array_computation(arr); 
}

int main() {
    int *arr = get_array();
    for(int i = 0; i < ARRAY_SIZE; i++)
        printf("%d", arr[i]);
    printf("\n");
    return 0;
}