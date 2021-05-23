import json
import sys
import copy
import os
from argparse import ArgumentParser

def argparser(enclaveList, enclaveMap):
    parser = ArgumentParser(description='CLOSURE RPC File and Wrapper Generator')
    parser.add_argument('-o','--odir', required=True, type=str, help='Output Directory')
    parser.add_argument('-g','--gedl', required=True, type=str, help='Input GEDL Filepath')
    parser.add_argument('-c','--cle', required=False, type=str, help='Input CLE Filepath')
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
                            callsList.append([str(call["func"]),str(call["return"]["type"]),copy.copy(paramsList),callNumMap[str(call["func"])], str(call["clelabel"])])
                        else:
                            callsList.append([str(call["func"]),str(call["return"]["type"]),copy.copy(paramsList),callNum, str(call["clelabel"])])
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
                            callsList.append([str(call["func"]),str(call["return"]["type"]),copy.copy(paramsList),callNumMap[str(call["func"])], str(call["clelabel"])])
                        else:
                            callsList.append([str(call["func"]),str(call["return"]["type"]),copy.copy(paramsList),callNum, str(call["clelabel"])])
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
            print("replaceList:", replaceList)
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
                        ws = len(line) - len(line.lstrip())
                        line = line[:ws] + 'int error = 0;\n' + line[:ws] + 'int restarted = 0;\n'+ line
                        fn = replaceList[enclaveIndex][0][1]
                        line = line.replace(fn,"_rpc_" + fn)
                        line = line.replace("_rpc_" + fn + "(","_rpc_" + fn + "(&error, &restarted" )
                        line = line + line[:ws] + 'if(error == 1) assert(0);\n' + line[:ws] + 'if(restarted == 1) assert(0);\n' 
                    del replaceList[enclaveIndex][0]
                modc_file.write(line)
            if enclaveMap[enclave][1] != "master":
                modc_file.write("int main(int argc, char **argv) {\n\treturn _slave_rpc_loop();\n}")

def CLEParser(enclave,args, enclaveMap,callerList,calleeList):
    cle_path = enclaveMap[enclave][0].replace(".mod.c",".c.clemap.json")
    print("cleFIle:",cle_path)
    with open(cle_path) as cle_file:
        cle = json.load(cle_file)
        enclaveIndex = enclaveMap[enclave][2]
        for callerPair in callerList[enclaveIndex]:
            for call in callerPair[2]:
                print(call)
                cle_label = call[4]
                for obj in cle:
                    if obj['cle-label'] == cle_label:
                        for cdf in obj['cle-json']['cdf']:
                            call.append(cdf)

        for calleePair in calleeList[enclaveIndex]:
            for call in calleePair[2]:
                print(call)
                cle_label = call[4]
                for obj in cle:
                    if obj['cle-label'] == cle_label:
                        for cdf in obj['cle-json']['cdf']:
                            call.append(cdf)




def RPCGeneratorH(enclave,args,enclaveMap,callerList,calleeList):
    rpchFile = enclaveMap[enclave][0][enclaveMap[enclave][0].rfind('/') + 1:].replace(".mod.c","_rpc.h")
    enclaveIndex = enclaveMap[enclave][2]
    with open((args.odir + "/" + enclave + "/" + rpchFile),"w") as rpch_file:
        rpch_file.write("#ifndef _" + enclave.capitalize() + "_RPC_\n#define _" + enclave.capitalize() + "_RPC_\n#include \"xdcomms.h\"\n#include \"codec.h\"\n")
        if args.ipc != "Singlethreaded" and enclaveMap[enclave][1] != "master":
            rpch_file.write("#include <pthread.h>\n")
        rpch_file.write("#include <stdbool.h>\n")
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
                rpch_file.write("FILE* logger_" + call[0] + ";\n")
        for calleePair in calleeList[enclaveIndex]:
            for call in calleePair[2]:
                rpch_file.write("extern " + call[1] + " " + call[0] + "(")
                for param in call[2]:
                    rpch_file.write(param[0] + " " + param[1])
                    if param != call[2][-1]:
                        rpch_file.write(",")
                rpch_file.write(");\n")
                rpch_file.write("extern bool caller_restarted_" +call[0] + ";\n")
                rpch_file.write("FILE* logger_" + call[0] + ";\n")


        rpch_file.write("\n\n#endif /* _"+ enclave.upper() + "_RPC_ */")

def getFuncCallString(call):
    fnCallString = ""
    fnCallString += (call[0] + "(")
    for param in call[2]:
        fnCallString += ("req_" + call[0] + "." + param[1])
        if param != call[2][-1]:
            fnCallString += (",")
    fnCallString += (")")
    return fnCallString



def RPCGeneratorC(enclave,args,enclaveMap,callerList,calleeList):
    print("enclaveMap:", enclaveMap, "\n")
    print("enclave: ", enclave, "\n")
    print("args: ", args, "\n")
    print("callerList: ", callerList, "\n")
    print("calleeList: ", calleeList)
    rpccFile = enclaveMap[enclave][0][enclaveMap[enclave][0].rfind('/') + 1:].replace(".mod.c","_rpc.c")
    enclaveIndex = enclaveMap[enclave][2]
    with open((args.odir + "/" + enclave + "/" + rpccFile),"w") as rpcc_file:
        rpcc_file.write("#include \"" + rpccFile[:rpccFile.rfind(".")] + ".h\"\n")
        rpcc_file.write("#include <limits.h>\n")
        if enclaveMap[enclave][1] != "master":
            rpcc_file.write("#define TAG_MATCH(X, Y) (X.mux == Y.mux && X.sec == Y.sec && X.typ == Y.typ)\n#define WRAP(X) void *_wrapper_##X(void *tag) { while(1) { _handle_##X(tag); } }\n\n")
        else:
            rpcc_file.write("\n\n#define INVALID -1\n\n")
            rpcc_file.write("enum STATUS{\n\tFAILED,\n\tOK,\n\tRESTARTED\n};\n\n")

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
                rpcc_file.write("bool caller_restarted_" +call[0] + " = false;\n")
                rpcc_file.write("void _handle_request_" + call[0] + "(gaps_tag* tag) {\n")
                rpcc_file.write("\tstatic int inited = 0;\n\tstatic void *psocket;\n\tstatic void *ssocket;\n")
                rpcc_file.write("\tstatic int processed_counter = 0;\n")
                rpcc_file.write("\tstatic int restart_state = -1;\n")
                rpcc_file.write("\tstatic " + call[1] + " last_processed_result;\n")
                rpcc_file.write("\tstatic int last_processed_error = 0;\n")
                rpcc_file.write("\tstatic int callee_restarted = 0;\n")
                rpcc_file.write("\tgaps_tag t_tag;\n\tgaps_tag o_tag;\n")
                rpcc_file.write("\t#pragma cle begin TAG_REQUEST_" + call[0].upper() + "\n\trequest_" + call[0] + "_datatype req_" + call[0] + ";\n\t#pragma cle end TAG_REQUEST_" + call[0].upper() + "\n")
                rpcc_file.write("\t#pragma cle begin TAG_RESPONSE_" + call[0].upper() + "\n\tresponse_" + call[0] + "_datatype res_" + call[0] + ";\n\t#pragma cle end TAG_RESPONSE_" + call[0].upper() + "\n\n")
                rpcc_file.write("\ttag_write(&t_tag, MUX_REQUEST_" + call[0].upper() + ", SEC_REQUEST_" + call[0].upper() + ", DATA_TYP_REQUEST_" + call[0].upper() + ");\n")
                rpcc_file.write("\ttag_write(&o_tag, MUX_RESPONSE_" + call[0].upper() + ", SEC_RESPONSE_" + call[0].upper() + ", DATA_TYP_RESPONSE_" + call[0].upper() + ");\n")
                rpcc_file.write("\tif(!inited) {\n")
                rpcc_file.write("\t\tcallee_restarted = true;\n")
                rpcc_file.write("\t\tlogger_"+ call[0]+" = fopen(\"rpc_log_"+ call[0] + "\", \"w\");\n")
                rpcc_file.write("\t\tinited = 1;\n\t\tpsocket = xdc_pub_socket();\n\t\tssocket = xdc_sub_socket(t_tag);\n\t\tsleep(1); /* zmq socket join delay */\n\t}\n\n")
                rpcc_file.write("\txdc_blocking_recv(ssocket, &req_" + call[0] + ", &t_tag);\n\n")

                rpcc_file.write("\tint reqId = req_" + call[0] + ".trailer.seq;\n")
                rpcc_file.write("\tif(reqId > processed_counter){\n")
                rpcc_file.write("\t\tbool error = false;\n")
                rpcc_file.write("\t\tprocessed_counter = reqId;\n")

                rpcc_file.write("\t\tif(reqId == restart_state)caller_restarted_" +call[0] + " = true;;\n\t\t")

                if call[1] != "void":
                    rpcc_file.write("last_processed_result = ") 
                rpcc_file.write(getFuncCallString(call) + ";\n")
                rpcc_file.write("\t\tlast_processed_error = error;\n")
                rpcc_file.write("\t\trestart_state = -1;\n")
                rpcc_file.write("\t\tcaller_restarted_" +call[0] + " = false;\n")
                rpcc_file.write("\t\tres_" + call[0] + ".trailer.seq = processed_counter << 2 | last_processed_error << 1 | callee_restarted;\n")
                rpcc_file.write("\t\tres_" + call[0] + ".ret = last_processed_result;\n")
                rpcc_file.write("\t\tfprintf(logger_" + call[0] + ",\"[DEBUG:CALLE] RECEIVED REQUEST:%d  FUNCTION EXECUTED  SENT:%f\\n\",req_" + call[0] + ".trailer.seq, res_" + call[0] + ".ret);\n")
                rpcc_file.write("\t\txdc_asyn_send(psocket, &res_" + call[0] + ", &o_tag);\n")
                rpcc_file.write("\t}\n")

                rpcc_file.write("\telse if(reqId == processed_counter){\n")
                rpcc_file.write("\t\tres_" + call[0] + ".trailer.seq = processed_counter << 2 | last_processed_error << 1 | callee_restarted;\n")
                rpcc_file.write("\t\tres_" + call[0] + ".ret = last_processed_result;\n")
                rpcc_file.write("\t\tfprintf(logger_" + call[0] + ",\"[DEBUG:CALLE] RECEIVED REQUEST:%d  FUNCTION NOT EXECUTED  SENT:%f\\n\",req_" + call[0] + ".trailer.seq, res_" + call[0] + ".ret);\n")
                rpcc_file.write("\t\txdc_asyn_send(psocket, &res_" + call[0] + ", &o_tag);\n")
                rpcc_file.write("\t}\n")

                rpcc_file.write("\telse if(reqId == INT_MIN){\n")
                rpcc_file.write("\t\tres_" + call[0] + ".trailer.seq = processed_counter << 2 | last_processed_error << 1 | callee_restarted;\n")
                rpcc_file.write("\t\tres_" + call[0] + ".ret = last_processed_result;\n")
                rpcc_file.write("\t\trestart_state = processed_counter + 1;\n")
                rpcc_file.write("\t\t//fprintf(logger_" + call[0] + ",\"[DEBUG:CALLE] CALLER SYNC PROCESSED:%d    SENT:%d\\n\",req_" + call[0] + ".trailer.seq, res_" + call[0] + ".trailer.seq);\n")
                rpcc_file.write("\t\txdc_asyn_send(psocket, &res_" + call[0] + ", &o_tag);\n")
                rpcc_file.write("\t}\n")

                rpcc_file.write("\telse {\n")
                rpcc_file.write("\t\t//Ignore\n")
                rpcc_file.write("\t}\n")
                rpcc_file.write("\tcallee_restarted = false;\n")
                rpcc_file.write("\tfflush(logger_"+call[0]+");\n")

                rpcc_file.write("}\n\n")

        
        if enclaveMap[enclave][1] != "master": # and args.ipc == "Singlethreaded":
            for calleePair in calleeList[enclaveIndex]:
                for call in calleePair[2]:
                    rpcc_file.write("void _handle_nxtrpc(gaps_tag* n_tag) {\n\tstatic int inited = 0;\n\tstatic void *psocket;\n\tstatic void *ssocket;\n\tgaps_tag t_tag;\n\tgaps_tag o_tag;\n\t")
                    rpcc_file.write("#pragma cle begin TAG_NEXTRPC\n\tnextrpc_datatype nxt;\n\t#pragma cle end TAG_NEXTRPC\n")
                    rpcc_file.write("\t#pragma cle begin TAG_OKAY\n\tokay_datatype okay;\n\t#pragma cle end TAG_OKAY\n\n")
                    rpcc_file.write("\ttag_write(&t_tag, MUX_NEXTRPC, SEC_NEXTRPC, DATA_TYP_NEXTRPC);\n")
                    rpcc_file.write("\tif(!inited) {\n")
                    rpcc_file.write("\t\tinited = 1;\n\t\tpsocket = xdc_pub_socket();\n\t\tssocket = xdc_sub_socket(t_tag);\n\t\tsleep(1); /* zmq socket join delay */\n\t}\n\n")
                    rpcc_file.write("\txdc_blocking_recv(ssocket, &nxt, &t_tag);\n\n")
                    rpcc_file.write("\ttag_write(&o_tag, MUX_OKAY, SEC_OKAY, DATA_TYP_OKAY);\n\tokay.x = 0;\n")
                    rpcc_file.write("\txdc_asyn_send(psocket, &okay, &o_tag);\n\n")
                    rpcc_file.write("\tn_tag->mux = nxt.mux;\n\tn_tag->sec = nxt.sec;\n\tn_tag->typ = nxt.typ;\n}\n\n")
        
        for callerPair in callerList[enclaveIndex]:
            for call in callerPair[2]:
                num_tries = call[5].get('num_tries', 5)
                rpcc_file.write("enum STATUS _rpc_" + call[0] + "_sync_request_counter(int* request_counter, void* psocket, void* ssocket, gaps_tag* t_tag, gaps_tag* o_tag) {\n")
                rpcc_file.write("\tint tries_remaining = " + str(num_tries) + ";\n")
                rpcc_file.write("\twhile(tries_remaining!=0){\n")
                rpcc_file.write("\t\t//Initialize the request and response pkts\n")
                rpcc_file.write("\t\t#pragma cle begin TAG_REQUEST_" + call[0].upper() + "\n")
                rpcc_file.write("\t\trequest_" + call[0] + "_datatype req_" + call[0] + ";\n")
                rpcc_file.write("\t\t#pragma cle end TAG_REQUEST_" + call[0].upper() + "\n")
                rpcc_file.write("\t\t#pragma cle begin TAG_RESPONSE_" + call[0].upper() + "\n")
                rpcc_file.write("\t\tresponse_" + call[0] + "_datatype res_" + call[0] + ";\n")
                rpcc_file.write("\t\t#pragma cle end TAG_RESPONSE_" + call[0].upper() + "\n\n")
  
                rpcc_file.write("\t\t//Prepare the request packet.\n")
                rpcc_file.write("\t\treq_" + call[0] + ".dummy = 0;\n")
                rpcc_file.write("\t\treq_" + call[0] + ".trailer.seq = *request_counter; //Set the reqId to request counter\n\n") 
  
                rpcc_file.write("\t\txdc_asyn_send(psocket, &req_" + call[0] + ", t_tag);\n")
                rpcc_file.write("\t\tint status = xdc_recv(ssocket, &res_" + call[0] + ", o_tag);\n")
                rpcc_file.write("\t\tint respId = res_" + call[0] + ".trailer.seq >> 2 ;\n")
                rpcc_file.write("\t\tbool error = (res_" + call[0] + ".trailer.seq >> 1)& 0x01 ;\n")
                rpcc_file.write("\t\tbool callee_restarted = res_" + call[0] + ".trailer.seq & 0x01 ;\n")
               
                rpcc_file.write("\t\tif(status == INVALID){\n")
                rpcc_file.write("\t\t\ttries_remaining--;\n")
                rpcc_file.write("\t\t\t//fprintf(logger_" + call[0] + ",\"[DEBUG:CALLER] Sync request, tries_remaining:%d, TIMEDOUT\\n\", tries_remaining);\n")
                rpcc_file.write("\t\t}\n")

                rpcc_file.write("\t\telse{\n")
                rpcc_file.write("\t\t\t*request_counter = respId;\n")
                rpcc_file.write("\t\t\t//fprintf(logger_" + call[0] + ",\"[DEBUG:CALLER] Request Counter Synced:%d\\n\",*request_counter);\n")
                rpcc_file.write("\t\t\treturn OK;\n")
                rpcc_file.write("\t\t}\n")

                rpcc_file.write("\t}\n")
                rpcc_file.write("\treturn FAILED;\n")
                rpcc_file.write("}\n\n")

                rpcc_file.write("enum STATUS _rpc_" + call[0] + "_remote_call(int reqId, double* result, void* psocket, void* ssocket, gaps_tag* t_tag, gaps_tag* o_tag){\n")
                rpcc_file.write("\t//Send requests\n")
                rpcc_file.write("\t//Retry NUM_TRIES times\n")
                rpcc_file.write("\tint tries_remaining = " + str(num_tries) + ";\n")
                rpcc_file.write("\twhile(tries_remaining!=0){\n")
                rpcc_file.write("\t\t//Initialize the request and response pkts\n")
                rpcc_file.write("\t\t#pragma cle begin TAG_REQUEST_" + call[0].upper() + "\n")
                rpcc_file.write("\t\trequest_" + call[0] + "_datatype req_" + call[0] + ";\n")
                rpcc_file.write("\t\t#pragma cle end TAG_REQUEST_" + call[0].upper() + "\n")
                rpcc_file.write("\t\t#pragma cle begin TAG_RESPONSE_" + call[0].upper() + "\n")
                rpcc_file.write("\t\tresponse_" + call[0] + "_datatype res_" + call[0] + ";\n")
                rpcc_file.write("\t\t#pragma cle end TAG_RESPONSE_" + call[0].upper() + "\n\n")
  
                rpcc_file.write("\t\t//Prepare the request packet.\n")
                rpcc_file.write("\t\treq_" + call[0] + ".dummy = 0;\n")
                rpcc_file.write("\t\treq_" + call[0] + ".trailer.seq = reqId; //Set the reqId to request counter\n\n") 
  
                rpcc_file.write("\t\txdc_asyn_send(psocket, &req_" + call[0] + ", t_tag);\n")
                rpcc_file.write("\t\tint status = xdc_recv(ssocket, &res_" + call[0] + ", o_tag);\n")
                rpcc_file.write("\t\tint respId = res_" + call[0] + ".trailer.seq >> 2 ;\n")
                rpcc_file.write("\t\tbool error = (res_" + call[0] + ".trailer.seq >> 1)& 0x01 ;\n")
                rpcc_file.write("\t\tbool callee_restarted = res_" + call[0] + ".trailer.seq & 0x01 ;\n")

                rpcc_file.write("\t\tif(status == INVALID){\n")
                rpcc_file.write("\t\t\ttries_remaining--;\n")
                rpcc_file.write("\t\t\tfprintf(logger_" + call[0] + ",\"[DEBUG:CALLER] request_id:%d, tries_remaining:%d, TIMEDOUT\\n\",reqId, tries_remaining);\n")
                rpcc_file.write("\t\t}\n")

                rpcc_file.write("\t\telse{ // valid status\n")
                rpcc_file.write("\t\t\tif(respId < reqId){\n")
                rpcc_file.write("\t\t\t\tfprintf(logger_" + call[0] + ",\"[DEBUG:CALLER] request_id:%d, response_id:%d,  IGNORE: Old duplicate packet received\\n\",reqId, respId );\n")
                rpcc_file.write("\t\t\t\tcontinue;\n")
                rpcc_file.write("\t\t\t}\n")
                rpcc_file.write("\t\t\tif(error){\n")
                rpcc_file.write("\t\t\t\tfprintf(logger_" + call[0] + ",\"[DEBUG:CALLER] ERROR: Errored on callee\\n\");\n")
                rpcc_file.write("\t\t\t\treturn FAILED;\n")
                rpcc_file.write("\t\t\t}\n")
                rpcc_file.write("\t\t\tif(callee_restarted){\n")
                rpcc_file.write("\t\t\t\t*result = res_" + call[0] + ".ret;\n")
                rpcc_file.write("\t\t\t\tfprintf(logger_" + call[0] + ",\"[DEBUG:CALLER] Callee has restarted request_id:%d, response_id:%d, Value:%f\\n\",reqId,respId, *result);\n")
                rpcc_file.write("\t\t\t\treturn RESTARTED;\n")
                rpcc_file.write("\t\t\t}\n")
                rpcc_file.write("\t\t\t*result = res_" + call[0] + ".ret;\n")
                rpcc_file.write("\t\t\tfprintf(logger_" + call[0] + ",\"[DEBUG:CALLER] request_id:%d, response_id:%d, Value:%f\\n\",reqId,respId, *result);\n")
                rpcc_file.write("\t\t\treturn OK;\n")
                rpcc_file.write("\t\t}\n")

                rpcc_file.write("\t}\n")
                rpcc_file.write("\tfprintf(logger_" + call[0] + ",\"[DEBUG:CALLER] ERROR: Max tries reached\\n\");\n")
                rpcc_file.write("\treturn FAILED;\n")
                rpcc_file.write("}\n\n")



                rpcc_file.write(call[1] + " _rpc_" + call[0] + "(")
                rpcc_file.write("int* error, int* restarted")
                if(call[2]):
                    rpcc_file.write(", ")

                for param in call[2]:
                    rpcc_file.write(param[0] + " " + param[1])
                    if param != call[2][-1]:
                        rpcc_file.write(",")
                rpcc_file.write(") {\n")
                rpcc_file.write("\tstatic int inited = 0;\n\tstatic void *psocket;\n\tstatic void *ssocket;\n")
                rpcc_file.write("\tstatic int request_counter = INT_MIN;\n\n") 
                rpcc_file.write("\tgaps_tag t_tag;\n\tgaps_tag o_tag;\n\t")
                # if len(call[2]) == 0:
                #     rpcc_file.write("\treq_" + call[0] + ".dummy = 0;\n")
                # else:
                #     for param in call[2]:
                #         rpcc_file.write("\treq_" + call[0] + "." + param[1] + "=" + param[1] + ";\n")
                rpcc_file.write("\ttag_write(&t_tag, MUX_REQUEST_" + call[0].upper() + ", SEC_REQUEST_" + call[0].upper() + ", DATA_TYP_REQUEST_" + call[0].upper() + ");\n")
                rpcc_file.write("\ttag_write(&o_tag, MUX_RESPONSE_" + call[0].upper() + ", SEC_RESPONSE_" + call[0].upper() + ", DATA_TYP_RESPONSE_" + call[0].upper() + ");\n\n")
                rpcc_file.write("\tif(!inited) {\n")
                rpcc_file.write("\t\tlogger_"+ call[0]+" = fopen(\"rpc_log_"+ call[0] + "\", \"w\");\n")
                timeout = call[5].get('timeout', 1000)
                rpcc_file.write("\t\tinited = 1;\n\t\tpsocket = xdc_pub_socket();\n\t\tssocket = xdc_sub_socket_non_blocking(o_tag," + str(timeout) + ");\n\t\tsleep(1); /* zmq socket join delay */\n\n")

                rpcc_file.write("\t\t//Synchronize the request counter to handle system restarts\n")
                rpcc_file.write("\t\t//Send an error in case the sync failed\n")
                rpcc_file.write("\t\tint status = _rpc_" + call[0] + "_sync_request_counter(&request_counter, psocket, ssocket, &t_tag, &o_tag );\n")
                rpcc_file.write("\t\tif(status == FAILED){\n")
                rpcc_file.write("\t\t\t*error = 1;\n")
                rpcc_file.write("\t\t\tfprintf(logger_" + call[0] + ",\"[DEBUG:CALLER] ERROR: Failed to connect to callee. Max tries reached\\n\");\n")
                rpcc_file.write("\t\t\tfflush(logger_"+call[0]+");\n")
                rpcc_file.write("\t\t\treturn 0;\n")
                rpcc_file.write("\t\t}\n")

                
                rpcc_file.write("\t}\n\n")

                rpcc_file.write("\t//Increment the request counter\n")
                rpcc_file.write("\trequest_counter++;\n\n")
  
                rpcc_file.write("\t//Do a remote function call\n")
                rpcc_file.write("\tdouble result;\n")
                rpcc_file.write("\tenum STATUS status = _rpc_" + call[0] + "_remote_call(request_counter,  &result, psocket, ssocket, &t_tag, &o_tag);\n\n")
                rpcc_file.write("\tif(status == FAILED){\n")
                rpcc_file.write("\t\t//set error;\n")
                rpcc_file.write("\t\t*error = 1;\n")
                rpcc_file.write("\t\tfflush(logger_"+call[0]+");\n")    
                rpcc_file.write("\t\treturn 0;\n")
                rpcc_file.write("\t}\n")

                rpcc_file.write("\tif(status == RESTARTED){\n")
                rpcc_file.write("\t\t*restarted = 1;\n")
                rpcc_file.write("\t\tprintf(\"SERVER RESTARTED\");\n")
                rpcc_file.write("\t}\n")

                if args.ipc == "Singlethreaded":
                    rpcc_file.write("\t_notify_next_tag(&t_tag);\n")
                rpcc_file.write("\tfflush(logger_"+call[0]+");\n")    
                rpcc_file.write("\treturn (result);\n")
                rpcc_file.write("}\n\n")
        
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
print('enclaveMap', enclaveMap)
print('enclaveList', enclaveList)
GEDLParser(args, enclaveList, enclaveMap, replaceList,callerList,calleeList)
for enclave in enclaveList:
    CModFunction(enclave, args, enclaveMap, replaceList,callerList,calleeList)
for enclave in enclaveList:
    CLEParser(enclave, args, enclaveMap,callerList,calleeList)
for enclave in enclaveList:
    RPCGeneratorH(enclave, args, enclaveMap,callerList,calleeList)
    RPCGeneratorC(enclave, args, enclaveMap,callerList,calleeList)
XDCONFGenerator(args, enclaveMap,callerList,enclaveList)
