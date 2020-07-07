import json
import sys

if len(sys.argv) < 3:
    print("Missing command line arguments. Usage of IDLGenerator is \"python IDLGenerator.py </path/to/gedl/file> </path/for/idl/file>\"")
    exit()

#Open the generated GEDL JSON file for parsing and IDL file for generation
with open(sys.argv[1]) as edl_file:
    with open(sys.argv[2],"w") as idl_file:

        #Load in the json data to "gedl" variable
        gedl = json.load(edl_file)

        #Create NextRPC and Okay structs necessary for singlethreaded style
        idl_file.write("struct NextRPC_1 {\n\tint mux;\n\tint sec;\n\tint typ;\n};");
        idl_file.write("\n\nstruct Okay_2 {\n\tint x;\n};")

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