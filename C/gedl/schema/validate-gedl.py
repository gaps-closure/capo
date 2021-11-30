#!/usr/bin/env python3
"""
Test the gedl schema, and a test GEDL json is valid using
json schema Draft 7

This requires MIT licensed jsonschema library 3.2.0 or newer (via pip)
For more information on jsonschema see:

github.com/Julian/jsonschema/

Author: Terrence Ezrol tezrol@perspectalabs.com
"""

import jsonschema
import json
import sys
import os.path

#the schema to json-schema draft 7
metaschema_file = "json-schema-draft7.json"
#the gedl schema
gedl_schema_file = "gedl-schema.json"

def validated_schema():
    """validates the gedl schema against the meta schema
       thus is to split the exception in editing the gedl schema, as the schema is validated
       in standard validation (thus this step)
    """
    if(jsonschema.__version__ < "3.2.0"):
        print("Please upgrade jsonschema, version 3.2.0 or newer is required")
        raise(ModuleNotFoundError("Newer jsonschema version required"))

    try:
        meta = json.loads(
            open(metaschema_file,"r",encoding="UTF-8").read()
        )
    except Exception as e:
        print("Error reading meta schema %s"%(metaschema_file))
        raise(e)
    
    try:
        gedl = json.loads(
            open(gedl_schema_file,"r",encoding="UTF-8").read()
        )
    except Exception as e:
        print("Error reading gedl schema %s"%(gedl_schema_file))
        raise(e)

    #schema loaded, validate and return schema
    jsonschema.validate(gedl,meta)
    return(gedl)

def validate_gedl(gedlfile,schema):
    """ given in the gedl json, and the schema json validate the json with the json """
    try:
        test = json.loads(
            open(gedlfile,"r",encoding="UTF-8").read()
        )
    except Exception as e:
        print("Error provided gedl json %s"%(gedlfile))
        raise(e)
    
    jsonschema.validate(test,schema)

def main():
    """Run a test on the provided file sys.argv[1]"""
    argc = len(sys.argv)

    if(argc != 2 or sys.argv[1] == "--help"):
        print("Usage: %s <gedl.json>"%(sys.argv[0]))
        return(-1)

    testfile = sys.argv[1]
    
    if(not os.path.isfile(testfile)):
        print("===== Test json (%s) not found/is not a file ====="%(testfile))
        return(-4)

    try:
        schema = validated_schema()
    except Exception as e:
        print("===== Invalid GEDL Schema =====")
        print(str(e))
        return(-2)

    try:
        validate_gedl(testfile,schema)
    except Exception as e:
        print("==== Invalid GEDL ====")
        print(str(e))
        return(-3)

    print("GEDL successfully validated")
    return(0)


if(__name__ == "__main__"):
    sys.exit(main())
