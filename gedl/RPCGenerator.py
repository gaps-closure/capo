import json
import sys
import copy
import argparse

#python RPCGenerator.py ./build build/Closure.gedl Singlethreaded /home/mnorris/gaps/build/src/hal/api inuri outuri example/orange/test1_orange.mod.c example/purple/test1_purple.mod.c
if len(sys.argv) < 9:
    print("Missing command line arguments. Usage of RPCGenerator is \"python RPCGenerator.py <outputDirectory> </path/to/gedl/file> <IPCStyle> </path/to/hal/api> <inuri> <outuri> <enclavefilepaths>...\"")
    exit()

def argparse(enclaveList, enclaveMap):
    enclaveArgument = 7
    while enclaveArgument < len(sys.argv):
        enclaveName = sys.argv[enclaveArgument][:sys.argv[enclaveArgument].rfind('/')]
        enclaveName = enclaveName[(enclaveName.rfind('/')+1):]
        enclaveList.append(enclaveName)
        enclaveMap[enclaveName] = [sys.argv[enclaveArgument],"slave", enclaveArgument-7]
        enclaveArgument += 1

def getFirstElem(list):
    return list[0]
def GEDLParser(GEDLFilepath,enclaveList, enclaveMap,replaceList,callerList,calleeList):
    with open(GEDLFilepath) as edl_file:
        gedl = json.load(edl_file)
        for index, enclave in enumerate(enclaveList):
            occursList = []
            callerList.append([])
            calleeList.append([])
            for enclavePair in gedl['gedl']:
                if enclavePair["caller"] == enclave:
                    callsList = []
                    for call in enclavePair["calls"]:
                        paramsList = []
                        for param in call["params"]:
                                paramsList.append([str(param["type"]),str(param["name"]),str(param["dir"])])
                        callsList.append([str(call["func"]),str(call["return"]["type"]),copy.copy(paramsList)])
                        for occurance in call["occurs"]:
                            for line in occurance["lines"]:
                                occursList.append([line,str(call["func"])])
                
                    callerList[index].append([str(enclavePair["callee"]),enclaveMap[enclavePair["callee"]][2],copy.copy(callsList)])
                if enclavePair["callee"] == enclave:
                    callsList = []
                    for call in enclavePair["calls"]:
                        paramsList = []
                        for param in call["params"]:
                                paramsList.append([str(param["type"]),str(param["name"]),str(param["dir"])])
                        callsList.append([str(call["func"]),str(call["return"]["type"]),copy.copy(paramsList)])
                    calleeList[index].append([str(enclavePair["caller"]),enclaveMap[enclavePair["caller"]][2],copy.copy(callsList)])
            occursList.sort(key=getFirstElem)
            replaceList.append(copy.copy(occursList))
            
def CModFunction(enclave,outputDirectory,enclaveMap,replaceList,callerList,calleeList):
    with open(enclaveMap[enclave][0]) as old_file:
        newFile = enclaveMap[enclave][0][enclaveMap[enclave][0].rfind('/') + 1:].replace(".mod","")
        enclaveIndex = enclaveMap[enclave][2]
        with open((outputDirectory + "/" + enclave + "/" + newFile),"w") as modc_file:
            modc_file.write("#include \"" + newFile[:newFile.rfind(".")] + "_rpc.h\"\n")
            oldFileLines = list(old_file)
            for index, line in enumerate(oldFileLines):
                if "int main(" in line:
                    modc_file.write(line)
                    modc_file.write("\t_master_rpc_init();\n")
                    enclaveMap[enclave][1] = "master"
                    continue
                while len(replaceList[enclaveIndex]) > 0 and (index+1) == replaceList[enclaveIndex][0][0]:
                    callIndex = line.find(replaceList[enclaveIndex][0][1])
                    if callIndex == -1:
                        print("Error: GEDL Cross-Enclave callsite in file %s for function %d at line %s could not be found" % (enclaveMap[enclave][0],index,replaceList[enclaveIndex][0][1]))
                    else:
                        line = line.replace(replaceList[enclaveIndex][0][1],"_rpc_" + replaceList[enclaveIndex][0][1])
                    del replaceList[enclaveIndex][0]
                modc_file.write(line)
            if enclaveMap[enclave][1] != "master":
                modc_file.write("int main(int argc, char **argv) {\n\treturn _slave_rpc_loop();\n}")

def RPCGeneratorH(enclave,outputDirectory,halApiPath,IPCStyle,inuri,outuri,enclaveMap,callerList,calleeList):
    rpchFile = enclaveMap[enclave][0][enclaveMap[enclave][0].rfind('/') + 1:].replace(".mod.c","_rpc.h")
    enclaveIndex = enclaveMap[enclave][2]
    with open((outputDirectory + "/" + enclave + "/" + rpchFile),"w") as rpch_file:
        rpch_file.write("#ifndef _" + enclave.capitalize() + "_RPC_\n#define _" + enclave.capitalize() + "_RPC_\n#include \"" + halApiPath + "/xdcomms.h\"\n#include \""+ outputDirectory + "/codec.h\"\n#include \"<pthread.h>\"\n\n")
        rpch_file.write("#define APP_BASE 0\n")
        for callerPair in callerList[enclaveIndex]:
            if IPCStyle == "Singlethreaded":
                rpch_file.write("# define MUX_NEXTRPC_" + str(enclaveIndex) + " APP_BASE + " + str(enclaveIndex) + "\n")
                rpch_file.write("# define SEC_NEXTRPC_" + str(enclaveIndex) + " APP_BASE + " + str(enclaveIndex) + "\n")
                rpch_file.write("# define MUX_OKAY_" + str(callerPair[1]) + " APP_BASE + " + str(callerPair[1]) + "\n")
                rpch_file.write("# define SEC_OKAY_" + str(callerPair[1]) + " APP_BASE + " + str(callerPair[1]) + "\n")
            for call in callerPair[2]:
                rpch_file.write("# define MUX_REQUEST_" + call[0].upper() + " APP_BASE + " + str(enclaveIndex) + "\n")
                rpch_file.write("# define SEC_REQUEST_" + call[0].upper() + " APP_BASE + " + str(enclaveIndex) + "\n")
                rpch_file.write("# define MUX_RESPONSE_" + call[0].upper() + " APP_BASE + " + str(callerPair[1]) + "\n")
                rpch_file.write("# define SEC_RESPONSE_" + call[0].upper() + " APP_BASE + " + str(callerPair[1]) + "\n")
        for calleePair in calleeList[enclaveIndex]:
            if IPCStyle == "Singlethreaded":
                rpch_file.write("# define MUX_NEXTRPC_" + str(calleePair[1]) + " APP_BASE + " + str(calleePair[1]) + "\n")
                rpch_file.write("# define SEC_NEXTRPC_" + str(calleePair[1]) + " APP_BASE + " + str(calleePair[1]) + "\n")
                rpch_file.write("# define MUX_OKAY_" + str(enclaveIndex) + " APP_BASE + " + str(enclaveIndex) + "\n")
                rpch_file.write("# define SEC_OKAY_" + str(enclaveIndex) + " APP_BASE + " + str(enclaveIndex) + "\n")
            for call in calleePair[2]:
                rpch_file.write("# define MUX_REQUEST_" + call[0].upper() + " APP_BASE + " + str(calleePair[1]) + "\n")
                rpch_file.write("# define SEC_REQUEST_" + call[0].upper() + " APP_BASE + " + str(calleePair[1]) + "\n")
                rpch_file.write("# define MUX_RESPONSE_" + call[0].upper() + " APP_BASE + " + str(enclaveIndex) + "\n")
                rpch_file.write("# define SEC_RESPONSE_" + call[0].upper() + " APP_BASE + " + str(enclaveIndex) + "\n")
        rpch_file.write("\n#define INURI  " + inuri + "\n#define OUTURI " + outuri + "\n")
        if IPCStyle == "Singlethreaded":
            for callerPair in callerList[enclaveIndex]:
                rpch_file.write("#pragma cle def TAG_NEXTRPC_" + str(enclaveIndex) + " {\"level\":\"" + enclave + "\",\\\n\t\"cdf\": [\\\n\t\t{\"remotelevel\":\"" + callerPair[0] + "\", \\\n\t\t\t\"direction\": \"egress\", \\\n" \
                    "\t\t\t\"guardhint\": { \"operation\": \"allow\", \\\n\t\t\t\t\t\t\"gapstag\": [" + str(callerPair[1]) + "," + str(callerPair[1]) + ",UNKNOWN] }} \\\n\t] }\n")

            for calleePair in calleeList[enclaveIndex]:
                rpch_file.write("#pragma cle def TAG_NEXTRPC_" + str(calleePair[1]) + " {\"level\":\"" + enclave + "\",\\\n\t\"cdf\": [\\\n\t\t{\"remotelevel\":\"" + enclave + "\", \\\n\t\t\t\"direction\": \"egress\", \\\n" \
                    "\t\t\t\"guardhint\": { \"operation\": \"allow\", \\\n\t\t\t\t\t\t\"gapstag\": [" + str(enclaveIndex) + "," + str(enclaveIndex) + ",UNKNOWN] }} \\\n\t] }\n")
        
        for callerPair in callerList[enclaveIndex]:
            for call in callerPair[2]:
                rpch_file.write("#pragma cle def TAG__REQUEST_" + call[0].upper() + " {\"level\":\"" + enclave + "\",\\\n\t\"cdf\": [\\\n\t\t{\"remotelevel\":\"" + callerPair[0] + "\", \\\n\t\t\t\"direction\": \"egress\", \\\n" \
                    "\t\t\t\"guardhint\": { \"operation\": \"allow\", \\\n\t\t\t\t\t\t\"gapstag\": [" + str(callerPair[1]) + "," + str(callerPair[1]) + ",UNKNOWN] }} \\\n\t] }\n")
                rpch_file.write("#pragma cle def TAG__RESPONSE_" + call[0].upper() + " {\"level\":\"" + enclave + "\",\\\n\t\"cdf\": [\\\n\t\t{\"remotelevel\":\"" + enclave + "\", \\\n\t\t\t\"direction\": \"egress\", \\\n" \
                    "\t\t\t\"guardhint\": { \"operation\": \"allow\", \\\n\t\t\t\t\t\t\"gapstag\": [" + str(enclaveIndex) + "," + str(enclaveIndex) + ",UNKNOWN] }} \\\n\t] }\n")

        for calleePair in calleeList[enclaveIndex]:
            for call in calleePair[2]:
                rpch_file.write("#pragma cle def TAG__REQUEST_" + call[0].upper() + " {\"level\":\"" + enclave + "\",\\\n\t\"cdf\": [\\\n\t\t{\"remotelevel\":\"" + enclave + "\", \\\n\t\t\t\"direction\": \"egress\", \\\n" \
                    "\t\t\t\"guardhint\": { \"operation\": \"allow\", \\\n\t\t\t\t\t\t\"gapstag\": [" + str(enclaveIndex) + "," + str(enclaveIndex) + ",UNKNOWN] }} \\\n\t] }\n")
                rpch_file.write("#pragma cle def TAG__RESPONSE_" + call[0].upper() + " {\"level\":\"" + enclave + "\",\\\n\t\"cdf\": [\\\n\t\t{\"remotelevel\":\"" + calleePair[0] + "\", \\\n\t\t\t\"direction\": \"egress\", \\\n" \
                    "\t\t\t\"guardhint\": { \"operation\": \"allow\", \\\n\t\t\t\t\t\t\"gapstag\": [" + str(calleePair[1]) + "," + str(calleePair[1]) + ",UNKNOWN] }} \\\n\t] }\n")
        
        if enclaveMap[enclave][1] == "master":
            rpch_file.write("extern void _master_rpc_init();\n\n")
        else:
            rpch_file.write("extern int _slave_rpc_loop();\n\n")

        for callerPair in callerList[enclaveIndex]:
            for call in callerPair[2]:
                rpch_file.write("extern " + call[1] + " _rpc_" + call[0] + "(")
                for param in call[2]:
                    rpch_file.write(param[0] + " " + param[1])
                    if param != call[-1]:
                        rpch_file.write(",")
                rpch_file.write(");")
        for calleePair in calleeList[enclaveIndex]:
            for call in calleePair[2]:
                rpch_file.write("extern " + call[1] + " " + call[0] + "(")
                for param in call[2]:
                    rpch_file.write(param[0] + " " + param[1])
                    if param != call[-1]:
                        rpch_file.write(",")
                rpch_file.write(");\n")

        rpch_file.write("#endif /* "+ enclave + "*/")

def RPCGeneratorC(enclave,outputDirectory,halApiPath,IPCStyle,inuri,outuri,enclaveMap,callerList,calleeList):
    rpccFile = enclaveMap[enclave][0][enclaveMap[enclave][0].rfind('/') + 1:].replace(".mod.c","_rpc.c")
    enclaveIndex = enclaveMap[enclave][2]
    with open((outputDirectory + "/" + enclave + "/" + rpccFile),"w") as rpcc_file:
        rpcc_file.write("#include \"" + enclave + "_rpc.h\"\n#define TAG_MATCH(X, Y) (X.mux == Y.mux && X.sec == Y.sec && X.typ == Y.typ)\n#define WRAP(X) void *_wrapper_##X(void *tag) { while(1) { _handle_##X(tag); } }\n\n")
        if enclaveMap[enclave][1] != "master" and IPCStyle == "Singlethreaded":
            for calleePair in calleeList[enclaveIndex]:
                for call in calleePair[2]:
                    rpcc_file.write("void _handle_request_" + call[0] + "(gaps_tag* tag) {\n\tstatic int inited = 0;\n\tstatic void *psocket;\n\tstatic void *ssocket;\n\tgaps_tag t_tag;\n\tgaps_tag o_tag;\n\t")
                    rpcc_file.write("#pragma cle begin TAG_REQUEST_" + call[0].upper() + "\n\trequest_" + call[0] + "_datatype req_" + call[0] + "\n\t#pragma cle begin TAG_REQUEST_" + call[0].upper() + "\n")
                    rpcc_file.write("\t#pragma cle begin TAG_RESPONSE_" + call[0].upper() + "\n\tresponse_" + call[0] + "_datatype res_" + call[0] + "\n\t#pragma cle begin TAG_RESPONSE_" + call[0].upper() + "\n\n")
                    rpcc_file.write("\ttag_write(&t_tag, MUX_REQUEST_" + call[0].upper() + ", SEC_REQUEST_" + call[0].upper() + ", DATA_TYP_REQUEST_" + call[0].upper() + ");\n")
                    rpcc_file.write("\tif(!inited) {\n\t\tinited = 1;\n\t\tpsocket = xdc_pub_socket();\n\t\tssocket = xdc_sub_socket(t_tag);\n\t\tsleep(1); /* zmq socket join delay */\n\t}")
                    rpcc_file.write("xdc_blocking_recv(ssocket, &req_" + call[0] + ", &t_tag);\n\t")
                    if call[1] != "void":
                        #Name of return may need to be changed to dynamic
                        rpcc_file.write("req_" + call[0] + ".y = ") 
                    rpcc_file.write(call[0] + "(")
                    for param in call[2]:
                        rpcc_file.write(param[0] + " " + param[1])
                        if param != call[-1]:
                            rpcc_file.write(",")
                    rpcc_file.write(");\n\n")

                    rpcc_file.write("\ttag_write(&o_tag, MUX_RESPONSE_" + call[0].upper() + ", SEC_RESPONSE_" + call[0].upper() + ", DATA_TYP_RESPONSE_" + call[0].upper() + ");\n\txdc_asyn_send(psocket, &res_" + call[0] + ", &o_tag);\n}")
        for callerPair in callerList[enclaveIndex]:
            for call in callerPair[2]:
                rpcc_file.write("void _rpc_" + call[0] + "(")
                for param in call[2]:
                    rpcc_file.write(param[0] + " " + param[1])
                    if param != call[-1]:
                        rpcc_file.write(",")
                rpcc_file.write(") {\n")
                rpcc_file.write("\tstatic int inited = 0;\n\tstatic void *psocket;\n\tstatic void *ssocket;\n\tgaps_tag t_tag;\n\tgaps_tag o_tag;\n\t")
                rpcc_file.write("#pragma cle begin TAG_REQUEST_" + call[0].upper() + "\n\trequest_" + call[0] + "_datatype req_" + call[0] + "\n\t#pragma cle begin TAG_REQUEST_" + call[0].upper() + "\n")
                rpcc_file.write("\t#pragma cle begin TAG_RESPONSE_" + call[0].upper() + "\n\tresponse_" + call[0] + "_datatype res_" + call[0] + "\n\t#pragma cle begin TAG_RESPONSE_" + call[0].upper() + "\n\n")


#Main Script
outputDirectory = sys.argv[1]
GEDLFilepath = sys.argv[2]
IPCStyle = sys.argv[3]
halApiPath = sys.argv[4]
inuri = sys.argv[5]
outuri = sys.argv[6]
enclaveMap = {}
enclaveList = []
replaceList = []
callerList = []
calleeList = []
argparse(enclaveList, enclaveMap)
GEDLParser(GEDLFilepath, enclaveList, enclaveMap, replaceList,callerList,calleeList)
for enclave in enclaveList:
    CModFunction(enclave,outputDirectory, enclaveMap, replaceList,callerList,calleeList)
for enclave in enclaveList:
    RPCGeneratorH(enclave,outputDirectory, halApiPath,IPCStyle,inuri,outuri, enclaveMap,callerList,calleeList)
    RPCGeneratorC(enclave,outputDirectory, halApiPath,IPCStyle,inuri,outuri, enclaveMap,callerList,calleeList)