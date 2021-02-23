#include<stdio.h>
#include<json-c/json.h>

int main(int argc, char **argv) {
 FILE *fp;
 char buffer[1024];
 struct json_object *parsed_json;
 struct json_object *cleLabel;
 struct json_object *age;
 struct json_object *friends;
 struct json_object *friend;
 size_t n_friends;

 size_t i; 

 fp = fopen("e.json","r");
 fread(buffer, 1024, 1, fp);
 fclose(fp);

 parsed_json = json_tokener_parse(buffer);

 json_object_object_get_ex(parsed_json, "cle-label", &cleLabel);
 printf("cle-label: %s\n", json_object_get_string(cleLabel));
 /*json_object_object_get_ex(parsed_json, "age", &age);
 json_object_object_get_ex(parsed_json, "friends", &friends);

 printf("Age: %d\n", json_object_get_int(age));

 n_friends = json_object_array_length(friends);
 printf("Found %lu friends\n",n_friends);

 for(i=0;i<n_friends;i++) {
  friend = json_object_array_get_idx(friends, i);
  printf("%lu. %s\n",i+1,json_object_get_string(friend));
 } */
}
