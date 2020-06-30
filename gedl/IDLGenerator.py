import json

with open("/home/mnorris/gaps/build/src/capo/gedl/build/Closure.gedl") as edl_file:
    with open("/home/mnorris/gaps/build/src/capo/gedl/build/Closure.idl","w") as idl_file:

        gedl = json.load(edl_file)
        idl_file.write("Struct NextRPC {\n\tint mux;\n\tint sec;\n\tint typ;\n};");
        idl_file.write("\n\nStruct Okay {\n\tint x;\n};")
        for enclavePair in gedl['gedl']:
            for call in enclavePair['calls']:
                idl_file.write("\n\nStruct Request%s {" % (call['func']))
                if len(call['params']) == 0:
                    idl_file.write("\n\tint x;")
                else:
                    for arg in call['params']:
                        idl_file.write("\n\t %s %s" % (arg['type'],arg['name']))
                        if "sz" in arg:
                            idl_file.write("%s" % (arg['sz']))
                        idl_file.write(";")
                idl_file.write("\n};")
                idl_file.write("\n\nStruct Response%s {" % (call['func']))
                if call['return'] == "void":
                    idl_file.write("\n\tint x;")
                else:
                    idl_file.write("\n\t%s y;" % (call['return']['type']))
                idl_file.write("\n};")