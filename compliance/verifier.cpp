#include <iostream>
#include <fstream>
#include <vector>
#include <string>
#include <exception>
#include <unordered_map>
#include <unistd.h>
#include <dirent.h>
#include <getopt.h>

using namespace std;

#include "Partition.h"
#include "Report.h"
#include "util.h"

int inconsistencies = 0;
int missings = 0;
int duplications = 0;
int badtags = 0;

int verbose = 0;
std::fstream tagMap;

void verify(vector<Partition>& partitions)
{
   Partition &originalPart = partitions[0];
   unordered_map<string, Annotation> &ann_map = originalPart.getAnnotationMap();
   unordered_map<string, Cle> &cle_map = originalPart.getCleMap();

   for (std::pair<std::string, Annotation> element : ann_map) {
      string label = element.first;
      Annotation ann = element.second;
      string annotation = ann.getLabel();
      Cle &cle = cle_map[annotation];
      string enclave = cle.getLevel();

      vector<Partition> foundInParts;
      for (int i = 1; i < partitions.size(); i++) {
          Partition &partition = partitions[i];

          unordered_map<string, Annotation> &part_map = partition.getAnnotationMap();

          std::unordered_map<std::string, Annotation>::const_iterator ann1 = part_map.find(label);
          if (ann1 == part_map.end())
              continue;

          foundInParts.push_back(partition);
      }

      Entry entry;
      string reason;
      entry.setPass(false);
      if (foundInParts.empty()) {
          missings++;
          reason = label + " is annotated " + enclave + ", but not found in any partitions";
      }
      else if (foundInParts.size() == 1) {
          Partition partition = foundInParts[0];
          unordered_map<string, Annotation> &part_map = partition.getAnnotationMap();

          Annotation part_ann = part_map[label];

          if (annotation.compare(part_ann.getLabel()) != 0) {
             inconsistencies++;
             reason = label + " is expected to be in " + enclave + ", but found in" +
                     part_ann.getLabel() + " in Partition " + partition.getName();
          }
          else {
              entry.setPass(true);
              reason = label + " is in " + enclave;

              entry.setModule(part_ann.getModule());
              entry.setInstruction(part_ann.getInstruction());
          }
      }
      else {
          duplications++;
          reason = label + "is found in multiple partitions: ";
          for (Partition partition: foundInParts) {
              reason += partition.getName() + ", ";
          }
      }
      entry.setReason(reason);
      originalPart.getReport().addEntry(entry);

      foundInParts.clear();
   }
}

static void read_files(char *in_dir, Partition& partition, const char *extension)
{
    DIR* FD;
    if ((FD = opendir(in_dir)) == NULL) {
       printf("Failed to open directory: %s, %s\n", in_dir, strerror(errno));
       return;
    }

    int i = 0;
    char path[300];
    struct dirent* in_file;

    // make sure CLE json are read first because the ll processing depends on it.
    while ((in_file = readdir(FD))) {     
        if (!strcmp(in_file->d_name, "."))
            continue;

        if (!strcmp(in_file->d_name, ".."))    
            continue;
        
        sprintf(path, "%s/%s", in_dir, in_file->d_name);
        if (endsWith(in_file->d_name, extension)) {
           if (!strcmp(extension, ".json"))
              partition.readCleJson(path);
           else if (!strcmp(extension, ".ll"))
              partition.readIRFile(path);
        }
    }
    closedir(FD);
}

static void read_dir(char *in_dir, Partition& partition)
{
    partition.setName(string(in_dir));

    string fname(in_dir);
    tagMap.open(fname + "/ann_map.txt", std::ofstream::out);
    tagMap << "{\n";
    
    // make sure .json are read first because .ll processing depends on it
    read_files(in_dir, partition, ".json");
    read_files(in_dir, partition, ".ll");

    if (verbose)
       partition.print();

    tagMap << "}\n";
    tagMap.close();
}

static void print_usage(char *cmd)
{
    printf("%s\n", cmd);
    printf("  -v \t verbose output\n");
    printf("  -h \t print this message and exit\n");

    exit(0);
}

static int parse_cmdline(int argc, char *argv[])
{
    int c;

    struct option long_options[] = {
        {"verbose", no_argument,    0, 'v'},
        {"help",    no_argument,    0, 'h'},
        {0, 0, 0, 0}
    };

    vector<char *> dirs;
    int option_index = 0;
    while ((c = getopt_long(argc, argv, "hv", long_options, &option_index)) != -1) {
       switch (c) {
          case 'v':
             verbose = 1;
             break;
          case 'h':
             print_usage(argv[0]);
             break;
          default:
             exit(1);
       }
    }
    
    if (argv[optind] == NULL || argv[optind + 1] == NULL) {
       print_usage(argv[0]);
    }

    return optind;
}

int main(int argc, char **argv)
{
   int index = parse_cmdline(argc, argv);

   vector<Partition> all_partitions;
   for (int i = index; i < argc; i++) {
      Partition partition;
      
      read_dir(argv[i], partition);
      all_partitions.push_back(partition);
   }

   verify(all_partitions);

   for (int i = 1; i < all_partitions.size(); i++) {
       badtags += all_partitions[i].getNumErrors();
   }

   int total = inconsistencies + missings + duplications + badtags;

   cout << "\nCompliance Report: " << ((total == 0) ? "all complied" : ( to_string(total) + " noncompliances"))
        << endl;
   if (total > 0) {
       cout
               << "# inconsistent annotations: " << inconsistencies << endl
               << "# missing annotations     : " << missings << endl
               << "# duplicated annotations  : " << duplications << endl
               << "# incorrect tags          : " << badtags << endl;
   }
   cout << endl;

   for (Partition partition: all_partitions) {
       partition.getReport().print();
   }

}
