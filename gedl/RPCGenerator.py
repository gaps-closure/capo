import json
import sys
import copy
import os
from argparse import ArgumentParser

def argparser(enclaveList, enclaveMap):
    parser = ArgumentParser(description='CLOSURE RPC File and Wrapper Generator')
    parser.add_argument('-o','--odir', required=True, type=str, help='Output Directory')
    parser.add_argument('-g','--gedl', required=True, type=str, help='Input GEDL Filepath')
    parser.add_argument('-i','--ipc', required=True, type=str, help='IPC Type (Singlethreaded/Multithreaded)')
    parser.add_argument('-a','--hal', required=True, type=str, help='HAL Api Directory Path')
    parser.add_argument('-n','--inuri', required=True, type=str, help='Input URI')
    parser.add_argument('-t','--outuri', required=True, type=str, help='Output URI')
    parser.add_argument('-x','--xdconf', required=True, type=str, help='Hal Config Map Filename')
    parser.add_argument('-f','--files', required=True, type=str, nargs='+', help='List of Mod Files')
    args = parser.parse_args()
    for index, enclaveFile in enumerate(args.files):
        enclaveName = enclaveFile[:enclaveFile.rfind('/')]
        enclaveName = enclaveName[(enclaveName.rfind('/')+1):]
        enclaveList.append(enclaveName)
        enclaveMap[enclaveName] = [enclaveFile,"slave", index]

    return args

def getFirstElem(list):
    return list[0]
def GEDLParser(args,enclaveList, enclaveMap,replaceList,callerList,calleeList):
    with open(args.gedl) as edl_file:
        gedl = json.load(edl_file)
        callNum = 3
        callNumMap = {}
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
                        if str(call["func"]) in callNumMap:
                            callsList.append([str(call["func"]),str(call["return"]["type"]),copy.copy(paramsList),callNumMap[str(call["func"])]])
                        else:
                            callsList.append([str(call["func"]),str(call["return"]["type"]),copy.copy(paramsList),callNum])
                            callNumMap[str(call["func"])] = callNum
                            callNum += 2
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
                        if str(call["func"]) in callNumMap:
                            callsList.append([str(call["func"]),str(call["return"]["type"]),copy.copy(paramsList),callNumMap[str(call["func"])]])
                        else:
                            callsList.append([str(call["func"]),str(call["return"]["type"]),copy.copy(paramsList),callNum])
                            callNumMap[str(call["func"])] = callNum
                            callNum += 2
                    calleeList[index].append([str(enclavePair["caller"]),enclaveMap[enclavePair["caller"]][2],copy.copy(callsList)])
            occursList.sort(key=getFirstElem)
            replaceList.append(copy.copy(occursList))
            
def CModFunction(enclave,args,enclaveMap,replaceList,callerList,calleeList):
    if not os.path.isfile(enclaveMap[enclave][0]):
        print("File" + enclaveMap[enclave][0] + "does not exist. Please update GEDL Schema with valid C file.\n")
        exit(0)
    with open(enclaveMap[enclave][0]) as old_file:
        newFile = enclaveMap[enclave][0][enclaveMap[enclave][0].rfind('/') + 1:].replace(".mod","")
        enclaveIndex = enclaveMap[enclave][2]
        with open((args.odir + "/" + enclave + "/" + newFile),"w") as modc_file:
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

def RPCGeneratorH(enclave,args,enclaveMap,callerList,calleeList):
    rpchFile = enclaveMap[enclave][0][enclaveMap[enclave][0].rfind('/') + 1:].replace(".mod.c","_rpc.h")
    enclaveIndex = enclaveMap[enclave][2]
    with open((args.odir + "/" + enclave + "/" + rpchFile),"w") as rpch_file:
        rpch_file.write("#ifndef _" + enclave.capitalize() + "_RPC_\n#define _" + enclave.capitalize() + "_RPC_\n#include \"xdcomms.h\"\n#include \"codec.h\"\n")
        if args.ipc != "Singlethreaded" and enclaveMap[enclave][1] != "master":
            rpch_file.write("#include <pthread.h>\n")
        rpch_file.write("\n# define APP_BASE 0\n")
        for callerPair in callerList[enclaveIndex]:
            if 1: #args.ipc == "Singlethreaded":
                rpch_file.write("# define MUX_NEXTRPC APP_BASE + " + str(callerPair[1] + 1) + "\n")
                rpch_file.write("# define SEC_NEXTRPC APP_BASE + " + str(callerPair[1] + 1) + "\n")
                rpch_file.write("# define MUX_OKAY APP_BASE + " + str(enclaveIndex+ 1) + "\n")
                rpch_file.write("# define SEC_OKAY APP_BASE + " + str(enclaveIndex+ 1) + "\n")
            for call in callerPair[2]:
                rpch_file.write("# define MUX_REQUEST_" + call[0].upper() + " APP_BASE + " + str(callerPair[1] + 1) + "\n")
                rpch_file.write("# define SEC_REQUEST_" + call[0].upper() + " APP_BASE + " + str(callerPair[1] + 1) + "\n")
                rpch_file.write("# define MUX_RESPONSE_" + call[0].upper() + " APP_BASE + " + str(enclaveIndex+ 1) + "\n")
                rpch_file.write("# define SEC_RESPONSE_" + call[0].upper() + " APP_BASE + " + str(enclaveIndex+ 1) + "\n")
        for calleePair in calleeList[enclaveIndex]:
            if 1: #args.ipc == "Singlethreaded":
                rpch_file.write("# define MUX_NEXTRPC APP_BASE + " + str(enclaveIndex+ 1) + "\n")
                rpch_file.write("# define SEC_NEXTRPC APP_BASE + " + str(enclaveIndex+ 1) + "\n")
                rpch_file.write("# define MUX_OKAY APP_BASE + " + str(calleePair[1] + 1) + "\n")
                rpch_file.write("# define SEC_OKAY APP_BASE + " + str(calleePair[1] + 1) + "\n")
            for call in calleePair[2]:
                rpch_file.write("# define MUX_REQUEST_" + call[0].upper() + " APP_BASE + " + str(enclaveIndex+ 1) + "\n")
                rpch_file.write("# define SEC_REQUEST_" + call[0].upper() + " APP_BASE + " + str(enclaveIndex+ 1) + "\n")
                rpch_file.write("# define MUX_RESPONSE_" + call[0].upper() + " APP_BASE + " + str(calleePair[1] + 1) + "\n")
                rpch_file.write("# define SEC_RESPONSE_" + call[0].upper() + " APP_BASE + " + str(calleePair[1] + 1) + "\n")

        rpch_file.write("\n#define INURI  \"" + args.inuri + enclave + "\"\n#define OUTURI \"" + args.outuri + enclave + "\"\n")
        for callerPair in callerList[enclaveIndex]:
            for call in callerPair[2]:
                rpch_file.write("#pragma cle def TAG_RESPONSE_" + call[0].upper() + " {\"level\":\"" + enclave + "\",\\\n\t\"cdf\": [\\\n\t\t{\"remotelevel\":\"" + enclave + "\", \\\n\t\t\t\"direction\": \"egress\", \\\n" \
                    "\t\t\t\"guarddirective\": { \"operation\": \"allow\", \\\n\t\t\t\t\t\t\"gapstag\": [" + str(enclaveIndex + 1) + "," + str(enclaveIndex + 1) + "," + str(call[3]+1) + "] }} \\\n\t] }\n")
                rpch_file.write("#pragma cle def TAG_REQUEST_" + call[0].upper() + " {\"level\":\"" + enclave + "\",\\\n\t\"cdf\": [\\\n\t\t{\"remotelevel\":\"" + callerPair[0] + "\", \\\n\t\t\t\"direction\": \"egress\", \\\n" \
                    "\t\t\t\"guarddirective\": { \"operation\": \"allow\", \\\n\t\t\t\t\t\t\"gapstag\": [" + str(callerPair[1]+ 1) + "," + str(callerPair[1]+ 1) + "," + str(call[3]) + "] }} \\\n\t] }\n")
                
        for calleePair in calleeList[enclaveIndex]:
            for call in calleePair[2]:
                rpch_file.write("#pragma cle def TAG_RESPONSE_" + call[0].upper() + " {\"level\":\"" + enclave + "\",\\\n\t\"cdf\": [\\\n\t\t{\"remotelevel\":\"" + calleePair[0] + "\", \\\n\t\t\t\"direction\": \"egress\", \\\n" \
                    "\t\t\t\"guarddirective\": { \"operation\": \"allow\", \\\n\t\t\t\t\t\t\"gapstag\": [" + str(calleePair[1]+ 1) + "," + str(calleePair[1]+ 1) + "," + str(call[3]+1) + "] }} \\\n\t] }\n")
                rpch_file.write("#pragma cle def TAG_REQUEST_" + call[0].upper() + " {\"level\":\"" + enclave + "\",\\\n\t\"cdf\": [\\\n\t\t{\"remotelevel\":\"" + enclave + "\", \\\n\t\t\t\"direction\": \"egress\", \\\n" \
                    "\t\t\t\"guarddirective\": { \"operation\": \"allow\", \\\n\t\t\t\t\t\t\"gapstag\": [" + str(enclaveIndex + 1) + "," + str(enclaveIndex + 1) + "," + str(call[3]) + "] }} \\\n\t] }\n")
                
        if 1: #args.ipc == "Singlethreaded":
            for callerPair in callerList[enclaveIndex]:
                #REMOVE HARDCODE ONCE IDL GEN FINISHED
                rpch_file.write("#pragma cle def TAG_OKAY {\"level\":\"" + enclave + "\",\\\n\t\"cdf\": [\\\n\t\t{\"remotelevel\":\"" + enclave + "\", \\\n\t\t\t\"direction\": \"egress\", \\\n" \
                    "\t\t\t\"guarddirective\": { \"operation\": \"allow\", \\\n\t\t\t\t\t\t\"gapstag\": [" + str(enclaveIndex + 1) + "," + str(enclaveIndex + 1) + ",2] }} \\\n\t] }\n")
                rpch_file.write("#pragma cle def TAG_NEXTRPC {\"level\":\"" + enclave + "\",\\\n\t\"cdf\": [\\\n\t\t{\"remotelevel\":\"" + callerPair[0] + "\", \\\n\t\t\t\"direction\": \"egress\", \\\n" \
                    "\t\t\t\"guarddirective\": { \"operation\": \"allow\", \\\n\t\t\t\t\t\t\"gapstag\": [" + str(callerPair[1]+ 1) + "," + str(callerPair[1]+ 1) + ",1] }} \\\n\t] }\n")
                
            for calleePair in calleeList[enclaveIndex]:
                rpch_file.write("#pragma cle def TAG_OKAY {\"level\":\"" + enclave + "\",\\\n\t\"cdf\": [\\\n\t\t{\"remotelevel\":\"" + calleePair[0] + "\", \\\n\t\t\t\"direction\": \"egress\", \\\n" \
                    "\t\t\t\"guarddirective\": { \"operation\": \"allow\", \\\n\t\t\t\t\t\t\"gapstag\": [" + str(calleePair[1]+ 1) + "," + str(calleePair[1]+ 1) + ",2] }} \\\n\t] }\n")
                rpch_file.write("#pragma cle def TAG_NEXTRPC {\"level\":\"" + enclave + "\",\\\n\t\"cdf\": [\\\n\t\t{\"remotelevel\":\"" + enclave + "\", \\\n\t\t\t\"direction\": \"egress\", \\\n" \
                    "\t\t\t\"guarddirective\": { \"operation\": \"allow\", \\\n\t\t\t\t\t\t\"gapstag\": [" + str(enclaveIndex + 1) + "," + str(enclaveIndex + 1) + ",1] }} \\\n\t] }\n")
            
        
                 
        if enclaveMap[enclave][1] == "master":
            rpch_file.write("extern void _master_rpc_init();\n")
        else:
            rpch_file.write("extern int _slave_rpc_loop();\n")

        for callerPair in callerList[enclaveIndex]:
            for call in callerPair[2]:
                rpch_file.write("extern " + call[1] + " _rpc_" + call[0] + "(")
                for param in call[2]:
                    rpch_file.write(param[0] + " " + param[1])
                    if param != call[2][-1]:
                        rpch_file.write(",")
                rpch_file.write(");\n")
        for calleePair in calleeList[enclaveIndex]:
            for call in calleePair[2]:
                rpch_file.write("extern " + call[1] + " " + call[0] + "(")
                for param in call[2]:
                    rpch_file.write(param[0] + " " + param[1])
                    if param != call[2][-1]:
                        rpch_file.write(",")
                rpch_file.write(");\n")

        rpch_file.write("\n\n#endif /* _"+ enclave.upper() + "_RPC_ */")

def RPCGeneratorC(enclave,args,enclaveMap,callerList,calleeList):
    rpccFile = enclaveMap[enclave][0][enclaveMap[enclave][0].rfind('/') + 1:].replace(".mod.c","_rpc.c")
    enclaveIndex = enclaveMap[enclave][2]
    with open((args.odir + "/" + enclave + "/" + rpccFile),"w") as rpcc_file:
        rpcc_file.write("#include \"" + rpccFile[:rpccFile.rfind(".")] + ".h\"\n")
        if enclaveMap[enclave][1] != "master":
            rpcc_file.write("#define TAG_MATCH(X, Y) (X.mux == Y.mux && X.sec == Y.sec && X.typ == Y.typ)\n#define WRAP(X) void *_wrapper_##X(void *tag) { while(1) { _handle_##X(tag); } }\n\n")
        if enclaveMap[enclave][1] == "master" and args.ipc == "Singlethreaded":
            rpcc_file.write("void _notify_next_tag(gaps_tag* n_tag) {\n")
            rpcc_file.write("\tstatic int inited = 0;\n\tstatic void *psocket;\n\tstatic void *ssocket;\n\tgaps_tag t_tag;\n\tgaps_tag o_tag;\n\t")
            rpcc_file.write("#pragma cle begin TAG_NEXTRPC\n\tnextrpc_datatype nxt;\n\t#pragma cle end TAG_NEXTRPC\n")
            rpcc_file.write("\t#pragma cle begin TAG_OKAY\n\tokay_datatype okay;\n\t#pragma cle end TAG_OKAY\n\n")
            rpcc_file.write("\tnxt.mux = n_tag->mux;\n\tnxt.sec = n_tag->sec;\n\tnxt.typ = n_tag->typ;\n\n")
            rpcc_file.write("\ttag_write(&t_tag, MUX_NEXTRPC, SEC_NEXTRPC, DATA_TYP_NEXTRPC);\n")
            rpcc_file.write("\ttag_write(&o_tag, MUX_OKAY, SEC_OKAY, DATA_TYP_OKAY);\n\n")
            rpcc_file.write("\tif(!inited) {\n\t\tinited = 1;\n\t\tpsocket = xdc_pub_socket();\n\t\tssocket = xdc_sub_socket(o_tag);\n\t\tsleep(1); /* zmq socket join delay */\n\t}\n\n")
            rpcc_file.write("\txdc_asyn_send(psocket, &nxt, &t_tag);\n")
            rpcc_file.write("\txdc_blocking_recv(ssocket, &okay, &o_tag);\n}\n\n")

        for calleePair in calleeList[enclaveIndex]:
            for call in calleePair[2]:
                rpcc_file.write("void _handle_request_" + call[0] + "(gaps_tag* tag) {\n\tstatic int inited = 0;\n\tstatic void *psocket;\n\tstatic void *ssocket;\n\tgaps_tag t_tag;\n\tgaps_tag o_tag;\n\t")
                rpcc_file.write("#pragma cle begin TAG_REQUEST_" + call[0].upper() + "\n\trequest_" + call[0] + "_datatype req_" + call[0] + ";\n\t#pragma cle end TAG_REQUEST_" + call[0].upper() + "\n")
                rpcc_file.write("\t#pragma cle begin TAG_RESPONSE_" + call[0].upper() + "\n\tresponse_" + call[0] + "_datatype res_" + call[0] + ";\n\t#pragma cle end TAG_RESPONSE_" + call[0].upper() + "\n\n")
                rpcc_file.write("\ttag_write(&t_tag, MUX_REQUEST_" + call[0].upper() + ", SEC_REQUEST_" + call[0].upper() + ", DATA_TYP_REQUEST_" + call[0].upper() + ");\n")
                rpcc_file.write("\tif(!inited) {\n\t\tinited = 1;\n\t\tpsocket = xdc_pub_socket();\n\t\tssocket = xdc_sub_socket(t_tag);\n\t\tsleep(1); /* zmq socket join delay */\n\t}\n\n")
                rpcc_file.write("\txdc_blocking_recv(ssocket, &req_" + call[0] + ", &t_tag);\n\t")
                if call[1] != "void":
                    rpcc_file.write("res_" + call[0] + ".ret = ") 
                rpcc_file.write(call[0] + "(")
                for param in call[2]:
                    rpcc_file.write("req_" + call[0] + "." + param[1])
                    if param != call[2][-1]:
                        rpcc_file.write(",")
                rpcc_file.write(");\n\n")

                rpcc_file.write("\ttag_write(&o_tag, MUX_RESPONSE_" + call[0].upper() + ", SEC_RESPONSE_" + call[0].upper() + ", DATA_TYP_RESPONSE_" + call[0].upper() + ");\n\txdc_asyn_send(psocket, &res_" + call[0] + ", &o_tag);\n}\n\n")
        
        if enclaveMap[enclave][1] != "master": # and args.ipc == "Singlethreaded":
            for calleePair in calleeList[enclaveIndex]:
                for call in calleePair[2]:
                    rpcc_file.write("void _handle_nxtrpc(gaps_tag* n_tag) {\n\tstatic int inited = 0;\n\tstatic void *psocket;\n\tstatic void *ssocket;\n\tgaps_tag t_tag;\n\tgaps_tag o_tag;\n\t")
                    rpcc_file.write("#pragma cle begin TAG_NEXTRPC\n\tnextrpc_datatype nxt;\n\t#pragma cle end TAG_NEXTRPC\n")
                    rpcc_file.write("\t#pragma cle begin TAG_OKAY\n\tokay_datatype okay;\n\t#pragma cle end TAG_OKAY\n\n")
                    rpcc_file.write("\ttag_write(&t_tag, MUX_NEXTRPC, SEC_NEXTRPC, DATA_TYP_NEXTRPC);\n")
                    rpcc_file.write("\tif(!inited) {\n\t\tinited = 1;\n\t\tpsocket = xdc_pub_socket();\n\t\tssocket = xdc_sub_socket(t_tag);\n\t\tsleep(1); /* zmq socket join delay */\n\t}\n\n")
                    rpcc_file.write("\txdc_blocking_recv(ssocket, &nxt, &t_tag);\n\n")
                    rpcc_file.write("\ttag_write(&o_tag, MUX_OKAY, SEC_OKAY, DATA_TYP_OKAY);\n\tokay.x = 0;\n")
                    rpcc_file.write("\txdc_asyn_send(psocket, &okay, &o_tag);\n\n")
                    rpcc_file.write("\tn_tag->mux = nxt.mux;\n\tn_tag->sec = nxt.sec;\n\tn_tag->typ = nxt.typ;\n}\n\n")
        
        for callerPair in callerList[enclaveIndex]:
            for call in callerPair[2]:
                rpcc_file.write(call[1] + " _rpc_" + call[0] + "(")
                for param in call[2]:
                    rpcc_file.write(param[0] + " " + param[1])
                    if param != call[2][-1]:
                        rpcc_file.write(",")
                rpcc_file.write(") {\n")
                rpcc_file.write("\tstatic int inited = 0;\n\tstatic void *psocket;\n\tstatic void *ssocket;\n\tgaps_tag t_tag;\n\tgaps_tag o_tag;\n\t")
                rpcc_file.write("#pragma cle begin TAG_REQUEST_" + call[0].upper() + "\n\trequest_" + call[0] + "_datatype req_" + call[0] + ";\n\t#pragma cle end TAG_REQUEST_" + call[0].upper() + "\n")
                rpcc_file.write("\t#pragma cle begin TAG_RESPONSE_" + call[0].upper() + "\n\tresponse_" + call[0] + "_datatype res_" + call[0] + ";\n\t#pragma cle end TAG_RESPONSE_" + call[0].upper() + "\n\n")
                if len(call[2]) == 0:
                    rpcc_file.write("\treq_" + call[0] + ".dummy = 0;\n")
                else:
                    for param in call[2]:
                        rpcc_file.write("\treq_" + call[0] + "." + param[1] + "=" + param[1] + ";\n")
                rpcc_file.write("\ttag_write(&t_tag, MUX_REQUEST_" + call[0].upper() + ", SEC_REQUEST_" + call[0].upper() + ", DATA_TYP_REQUEST_" + call[0].upper() + ");\n")
                rpcc_file.write("\ttag_write(&o_tag, MUX_RESPONSE_" + call[0].upper() + ", SEC_RESPONSE_" + call[0].upper() + ", DATA_TYP_RESPONSE_" + call[0].upper() + ");\n\n")
                rpcc_file.write("\tif(!inited) {\n\t\tinited = 1;\n\t\tpsocket = xdc_pub_socket();\n\t\tssocket = xdc_sub_socket(o_tag);\n\t\tsleep(1); /* zmq socket join delay */\n\t}\n\n")
                if args.ipc == "Singlethreaded":
                    rpcc_file.write("\t_notify_next_tag(&t_tag);\n")
                rpcc_file.write("\txdc_asyn_send(psocket, &req_" + call[0] + ", &t_tag);\n\txdc_blocking_recv(ssocket, &res_" + call[0] + ", &o_tag);\n")
                rpcc_file.write("\treturn (res_" + call[0] + ".ret);\n}\n\n")

        
        rpcc_file.write("void _hal_init(char *inuri, char *outuri) {\n\txdc_set_in(inuri);\n\txdc_set_out(outuri);\n") 
        if 1:#args.ipc == "Singlethreaded":
            for callerPair in callerList[enclaveIndex]:
                for call in callerPair[2]:
                    rpcc_file.write("\txdc_register(nextrpc_data_encode, nextrpc_data_decode, DATA_TYP_NEXTRPC);\n")
                    rpcc_file.write("\txdc_register(okay_data_encode, okay_data_decode, DATA_TYP_OKAY);\n")
            for calleePair in calleeList[enclaveIndex]:
                for call in calleePair[2]:
                    rpcc_file.write("\txdc_register(nextrpc_data_encode, nextrpc_data_decode, DATA_TYP_NEXTRPC);\n")
                    rpcc_file.write("\txdc_register(okay_data_encode, okay_data_decode, DATA_TYP_OKAY);\n")
        
        for callerPair in callerList[enclaveIndex]:
            for call in callerPair[2]:
                rpcc_file.write("\txdc_register(request_" + call[0] + "_data_encode, request_" + call[0] + "_data_decode, DATA_TYP_REQUEST_" + call[0].upper() + ");\n")
                rpcc_file.write("\txdc_register(response_" + call[0] + "_data_encode, response_" + call[0] + "_data_decode, DATA_TYP_RESPONSE_" + call[0].upper() + ");\n")
        for calleePair in calleeList[enclaveIndex]:
            for call in calleePair[2]:
                rpcc_file.write("\txdc_register(request_" + call[0] + "_data_encode, request_" + call[0] + "_data_decode, DATA_TYP_REQUEST_" + call[0].upper() + ");\n")
                rpcc_file.write("\txdc_register(response_" + call[0] + "_data_encode, response_" + call[0] + "_data_decode, DATA_TYP_RESPONSE_" + call[0].upper() + ");\n")
        rpcc_file.write("}\n\n")

        if enclaveMap[enclave][1] == "master":
            rpcc_file.write("void _master_rpc_init() {\n\t_hal_init((char*)INURI, (char *)OUTURI);\n}\n\n")
        else:
            if args.ipc == "Multithreaded":
                crossDomains = 0
                for calleePair in calleeList[enclaveIndex]:
                    crossDomains += 1 + len(calleePair[2])
                rpcc_file.write("#define NXDRPC " + str(crossDomains) + "\n")
                for calleePair in calleeList[enclaveIndex]:
                    rpcc_file.write("WRAP(nxtrpc)\n")
                for calleePair in calleeList[enclaveIndex]:
                    for call in calleePair[2]:
                        rpcc_file.write("WRAP(request_" + call[0] + ")\n")
                rpcc_file.write("\nint _slave_rpc_loop() {\n\tgaps_tag n_tag;\n")
                if args.ipc == "Multithreaded":
                    rpcc_file.write("\tpthread_t tid[NXDRPC];\n\t_hal_init((char *)INURI, (char *)OUTURI);\n")
                    tidIndex = 0
                    for calleePair in calleeList[enclaveIndex]:
                        rpcc_file.write("\tpthread_create(&tid[" + str(tidIndex) + "], NULL, _wrapper_nxtrpc, &n_tag);\n")
                        tidIndex += 1
                    for calleePair in calleeList[enclaveIndex]:
                        for call in calleePair[2]:
                            rpcc_file.write("\tpthread_create(&tid[" + str(tidIndex) + "], NULL, _wrapper_request_" + call[0] + ", &n_tag);\n")
                            tidIndex += 1
                    rpcc_file.write("\tfor (int i = 0; i < NXDRPC; i++) pthread_join(tid[i], NULL);\n\treturn 0;\n}\n\n")
            else:
                #FIX HARDCODING FOR NEXTRPC AND REQUEST
                rpcc_file.write("int _slave_rpc_loop() {\n\tgaps_tag n_tag;\n\tgaps_tag t_tag;\n\n\t_hal_init((char *)INURI, (char *)OUTURI);\n\n")
                rpcc_file.write("\twhile (1) {\n\t\t_handle_nxtrpc(&n_tag);\n\t\ttag_write(&t_tag, MUX_NEXTRPC, SEC_NEXTRPC, DATA_TYP_NEXTRPC);\n")
                rpcc_file.write("\t\tif(TAG_MATCH(n_tag, t_tag)) {\n\t\t\tcontinue;\n\t\t}\n")
                for calleePair in calleeList[enclaveIndex]:
                    for call in calleePair[2]:
                        rpcc_file.write("\t\ttag_write(&t_tag, MUX_REQUEST_" + call[0].upper() + ", SEC_REQUEST_" + call[0].upper() + ", DATA_TYP_REQUEST_" + call[0].upper() + ");\n")
                        rpcc_file.write("\t\tif (TAG_MATCH(n_tag, t_tag)) {\n\t\t\t_handle_request_"+ call[0] + "(NULL);\n\t\t\tcontinue;\n\t\t}\n\t\tcontinue;\n\t}\n}\n\n")

def writeHALEntry(file, fromName , toName, mux, sec, typ, funcName):
    file.write("{\"from\":\"" + fromName + "\",\"to\":\"" + toName + "\",\"mux\":" + str(mux) + ",\"sec\":" + str(sec) + ",\"typ\":" + str(typ) + ",\"name\":\"" + funcName +"\"}")

def XDCONFGenerator(args,enclaveMap,callerList,enclaveList):
    with open((args.odir + "/" + args.xdconf),"a") as map_file:
        map_file.write("{\"enclaves\": [")
        first = 1
        for enclave in enclaveList:
            if first == 1:
                first = 0
            else:
                map_file.write(",")
            map_file.write("\n\t{\n\t\t\"enclave\":\"" + enclave + "\",\n\t\t\"inuri\":\"" + args.inuri + enclave + "\",\n\t\t\"outuri\":\"" + args.outuri + enclave + "\",\n\t\t\"halmaps\":[")
            enclaveIndex = enclaveMap[enclave][2]
            if enclaveMap[enclave][1] == "master":
                for callerPair in callerList[enclaveIndex]:
                    writeHALEntry(map_file, enclave , callerPair[0], (callerPair[1] + 1), (callerPair[1] + 1), 1, "NEXTRPC")
                    map_file.write(",")
                    writeHALEntry(map_file, callerPair[0] , enclave, (enclaveIndex + 1), (enclaveIndex + 1), 2, "OKAY")
            else:
                for calleePair in calleeList[enclaveIndex]:
                    writeHALEntry(map_file, calleePair[0] , enclave, (enclaveIndex + 1), (enclaveIndex + 1), 1, "NEXTRPC")
                    map_file.write(",")
                    writeHALEntry(map_file, enclave , calleePair[0], (calleePair[1] + 1), (calleePair[1] + 1), 2, "OKAY")
            for callerPair in callerList[enclaveIndex]:
                for call in callerPair[2]:
                    map_file.write(",")
                    writeHALEntry(map_file, enclave , callerPair[0], (callerPair[1] + 1), (callerPair[1] + 1), call[3], ("REQUEST_" + call[0].upper()))
                    map_file.write(",")
                    writeHALEntry(map_file, callerPair[0] , enclave, (enclaveIndex + 1), (enclaveIndex + 1), (call[3]+1), ("RESPONSE_" + call[0].upper()))
            for calleePair in calleeList[enclaveIndex]:
                for call in calleePair[2]:
                    map_file.write(",")
                    writeHALEntry(map_file, calleePair[0] , enclave, (enclaveIndex + 1), (enclaveIndex + 1), call[3], ("REQUEST_" + call[0].upper()))
                    map_file.write(",")
                    writeHALEntry(map_file, enclave , calleePair[0], (calleePair[1] + 1), (calleePair[1] + 1), (call[3]+1), ("RESPONSE_" + call[0].upper()))
            map_file.write("]\n\t}")
        map_file.write("\n]}")

#Main Script
enclaveMap = {}
enclaveList = []
replaceList = []
callerList = []
calleeList = []
args = argparser(enclaveList, enclaveMap)
GEDLParser(args, enclaveList, enclaveMap, replaceList,callerList,calleeList)
for enclave in enclaveList:
    CModFunction(enclave, args, enclaveMap, replaceList,callerList,calleeList)
for enclave in enclaveList:
    RPCGeneratorH(enclave, args, enclaveMap,callerList,calleeList)
    RPCGeneratorC(enclave, args, enclaveMap,callerList,calleeList)
XDCONFGenerator(args, enclaveMap,callerList,enclaveList)
