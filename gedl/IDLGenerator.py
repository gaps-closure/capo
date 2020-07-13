import json
import sys
from argparse import ArgumentParser



def argparser():
    parser = ArgumentParser(description='CLOSURE IDL File Generator')
    parser.add_argument('-g','--gedl', required=True, type=str, help='Input GEDL Filepath')
    parser.add_argument('-o','--ofile', required=True, type=str, help='Output Filepath')
    parser.add_argument('-i','--ipc', required=True, type=str, help='IPC Type (Singlethreaded/Multithreaded)')
    return parser.parse_args()

#Open the generated GEDL JSON file for parsing and IDL file for generation
args = argparser()
with open(args.gedl) as edl_file:
    with open(args.ofile,"w") as idl_file:
        
        #Load in the json data to "gedl" variable
        gedl = json.load(edl_file)

        #Create NextRPC and Okay structs necessary for singlethreaded style
        idl_file.write("struct NextRPC {\n\tint mux;\n\tint sec;\n\tint typ;\n};");
        idl_file.write("\n\nstruct Okay {\n\tint x;\n};")

        #For loop that iterates through each enclave pair in gedl
        for enclavePair in gedl['gedl']:
            #For loop that iterates through each cross-enclave call "caller" makes to "callee" and 
            #creates corresponding request/response structs
            for call in enclavePair['calls']:
                #Generate a request struct for this function
                idl_file.write("\n\nstruct Request_%s {" % (call['func']))

                #If there are no parameters, create a dummy variable to meet marshalling requirements
                if len(call['params']) == 0:
                    idl_file.write("\n\tint dummy;")
                else:
                    #For loop that iterates through each call parameter and creates a struct variable
                    for arg in call['params']:
                        idl_file.write("\n\t %s %s" % (arg['type'],arg['name']))
                        if "sz" in arg:
                            idl_file.write("%s" % (arg['sz']))
                        idl_file.write(";")
                idl_file.write("\n};")
                
                #Generate a response struct for this function
                idl_file.write("\n\nstruct Response_%s {" % (call['func']))
                #If return type is void, generate dummy variable to meet marshalling requirements
                if call['return'] == "void":
                    idl_file.write("\n\tint ret;")
                else:
                    idl_file.write("\n\t%s ret;" % (call['return']['type']))
                idl_file.write("\n};")