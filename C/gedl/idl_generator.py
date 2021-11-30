#!/usr/bin/env python3

import json
import sys
import os
import os.path
import jsonschema
from argparse import ArgumentParser

def argparser():
    """ Command Line Argument Parsing"""
    parser = ArgumentParser(description='CLOSURE IDL File Generator')
    parser.add_argument('-g','--gedl', required=True, type=str, help='Input GEDL Filepath')
    parser.add_argument('-o','--ofile', required=True, type=str, help='Output Filepath')
    parser.add_argument('-i','--ipc', required=True, type=str, 
                 choices=("Singlethreaded", "Multithreaded"), help='IPC Type')
    parser.add_argument('-s', '--schema', required=False, type=str,
                 default='./GEDLSchema.json',
                 help='override the location of the of the schema if required')
    parser.add_argument('-L', '--liberal',help="Liberal mode: disable gedl schema check",
                 default=False, action='store_true') 
    return parser.parse_args()

def get_gedl_schema(schema_location):
    """Load the schema json to verify against"""
    basepath = ""
    #get the module paths to help find the schema in a relitive to ourself
    if(len(sys.path) > 1):
        basepath = sys.path[0]
    path = os.path.join(basepath,schema_location)
    
    if(not os.path.exists(path)):
        #schema not found relitive to the python enviroment, check a local path
        path = schema_location
        if(not os.path.exists(path)):
            #Unable to get python schema
            raise(IOError("Unable to fild cle schema (expected at): " + path))
    
    #we found the schema load it into ram
    print("Using GEDL schema: " + path)
    with open(path,"r",encoding="UTF-8") as schemafile:
        return(json.loads(schemafile.read()))

def check_jsonschema_version():
    """validate the json schema version is new enogh to process
        Draft 7 schemas
    """
    if(jsonschema.__version__ < "3.2.0"):
        raise(ModuleNotFoundError("Newer version of jsonschema module required"
        " (>= 3.2.0)"))

def validate_gedl(gedl_json, schema_json):
    """validate the GEDL entry is valid against the shcema"""
    try:
        jsonschema.validate(gedl_json,schema)
    except Exception as e:
        print("")
        print("Error parsing GEDL")
        raise
    print("")
    print("GEDL is valid")

def generate_idl(gedl, args):
    """Generate the output IDL file"""
    with open(args.ofile,"w") as idl_file:
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

                #Initialize variable to check for input values
                dummy = 1
                #For loop that iterates through each call parameter and creates a struct variable
                for arg in call['params']:
                    if "in" in arg['dir']:
                        dummy = 0
                        idl_file.write("\n\t%s %s" % (arg['type'],arg['name']))
                        if "sz" in arg:
                            idl_file.write("[%s]" % (arg['sz']))
                        idl_file.write(";")

                #If there are no in parameters, create a dummy variable to meet marshalling requirements
                if dummy == 1:
                    idl_file.write("\n\tint dummy;")
                idl_file.write("\n};")
                
                #Generate a response struct for this function
                idl_file.write("\n\nstruct Response_%s {" % (call['func']))

                #Initialize variable to check for return or output values
                ret = 1
                if call['return'] != "void":
                    ret = 0
                    idl_file.write("\n\t%s ret;" % (call['return']['type']))  
                #For loop that iterates through each call parameter and creates a struct variable
                for arg in call['params']:
                    if "out" in arg['dir']:
                        ret = 0
                        idl_file.write("\n\t%s %s" % (arg['type'],arg['name']))
                        if "sz" in arg:
                            idl_file.write("[%s]" % (arg['sz']))
                        idl_file.write(";")
                #If return type is void and no out parameters, generate dummy variable to meet marshalling requirements
                if ret == 1:
                    idl_file.write("\n\tint ret;")
                idl_file.write("\n};")

def main():
    """IDL Generator entry point"""

    #Open the generated GEDL JSON file for parsing and IDL file for generation
    args = argparser()
    with open(args.gedl) as edl_file:
        #Load in the json data to "gedl" variable
        gedl = json.load(edl_file)

        if(not args.liberal):
            #validate the schema
            check_jsonschema_version()
            schema = get_gedl_schema(args.schema)
            try:
                jsonschema.validate(gedl,schema)
            except jsonschema.exceptions.ValidationError as schemaerr:
                print("")
                print("Unable to validate GEDL json:\n%s"%(str(schemaerr),))
                sys.exit(-1)
        #generate the idl
        generate_idl(gedl,args)

if(__name__=="__main__"):
    main()