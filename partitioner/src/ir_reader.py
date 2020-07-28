import subprocess
import sys
import re

class DbgInfo():
    LOCAL=0
    GLOBAL=1
    PARAMETER=2
    FUNCTION=3
    def __init__(self, node_, name_, line_, column_, file_ = None, local_ = True, function_ = False):
        self.node = node_
        self.name = name_
        self.line = str(line_) if line_ else None
        self.column = str(column_) if column_ else None
        self.file = file_
        self.local = local_
        if self.name and re.match(r'\w+\.addr', self.name):
            self.kind_str = DbgInfo.PARAMETER
        elif self.local:
            self.kind_str = DbgInfo.LOCAL
        elif function_:
            self.kind_str = DbgInfo.FUNCTION
        else:
            self.kind_str = DbgInfo.GLOBAL
        
    def set_name(self, n):
        self.name = n

    def get_name(self):
        return self.name

    def get_line(self):
        return self.line

    def get_column(self):
        return self.column

    def get_node(self):
        return self.node
        
    def set_file(self, f):
        self.file = f
        
    def get_file(self):
        return self.file   
        
    def get_local(self):
        return self.local
        
    def get_kind(self):
        return self.kind_str
        
    def __str__(self):
        fstr = "" if self.file is None else " in file " + self.file
        gstr = ""
        if self.kind_str == self.PARAMETER:
            gstr = " (formal param) "
        elif self.kind_str == self.LOCAL:
            gstr = " (local)"
        elif self.kind_str == self.GLOBAL:
            gstr = " (global)"
        elif self.kind_str == self.FUNCTION:
            gstr = " (function)"
        return "Name: %s on line %s column %s%s%s" % (self.name, self.line, self.column, fstr, gstr)

    def __repr__(self):
        return self.__str__()

class IRReader():


            
    def __init__(self):
        self.ir_lines = []

    def read_ir(self, fname):
        with open(fname) as f:
            for l in f:
                self.ir_lines.append(l.strip())

    def get_prefix(self, pref):
        '''
        returns a list containing all the lines starting (except
        possible white space) with the prefix, in order as they occur
        in the IR file
        '''
        ret = [l for l in self.ir_lines if l.strip().startswith(pref)]
        return ret

    def get_label_irstring(self, ll):
        '''
        returns map {label : irstring} where label is one of the labels defined by the programmer
        and irstring is the string name defined in the IR file for that label

        e.g., if IR file contains:
        "@.str.3 = private unnamed_addr constant [9 x i8] c"ORANGE_1\00", section "llvm.metadata""
        then this function returns {'ORANGE_1':'.str.3'}
        '''
        ret = {}
        globals_1 = self.get_prefix('@')
        for l in ll:
            str1 = r'@(.+) = .+ c"(' + l + r')\\00",'
            for g in globals_1:
                m = re.match(str1, g)
                if m is not None:
                    ret[m.group(2)] = m.group(1)
        return ret

    def get_DbgInfo(self, node, var=None):
        '''
        from the node label of DOT graph find debug info about data item
        '''
        tmp_d = node.get('dbginfo')
        if tmp_d is not None: return tmp_d
        ret = None
        label = node.get_label().replace('\\\n', "")
        #print("label:", label)
        
        #for some reason the dgb label at the end of the line gets mangled
        if var is None and label.startswith("\"{GLOBAL_VALUE"):
            m = re.match(r".+GLOBAL_VALUE:@([\.\w]+) .+!dbg !(\d+)", label)
            if m:
                var = m.group(1)
                n, l, c = self.get_name_line_local(m.group(2))
                ret = DbgInfo(node, n, l, 0, local_=c)
                return ret
            
        m = re.match(r'.+ENTRY\\>\\>.+name: \\"([^\"]+)\\",.+line: (\d+)', label)
        #print("AAA", label, m)
        if m is not None:
            return DbgInfo(node, m.group(1),  m.group(2), 0, local_=False, function_=True)
        
        m = re.match(r'.+DBGLOC file (\S+) line (\d+) col (\d+) ENDDBGLOC', label)
        if m is not None:
            #print("l", m.group(1), "c", m.group(2))
            return DbgInfo(node, var,  m.group(2), m.group(3), file_=m.group(1))
                
        return ret or DbgInfo(node, var, None, None)

    def get_name_line_local(self, num):
        dbg_line = self.get_prefix('!' + num)
        if len(dbg_line) < 1:
            return None, None, None
        m = re.match(r".+DIGlobalVariableExpression\(var: !(\d+), expr: .+", dbg_line[0])
        if m:
            return self.get_name_line_local(m.group(1))
        else:
            # like this: distinct !DIGlobalVariable(name: "a", scope: !13, file: !3, line: 22, type: !6, isLocal: true, isDefinition: true)
            m2 = re.match(r".+DIGlobalVariable.+name: \"([^\"]+)\",.+line: (\d+),.+isLocal: (\w+)", dbg_line[0])
            #print("MATCHING_123", dbg_line[0])
            if m2:
                #print("MATCHED_123", m2)
                return m2.group(1), m2.group(2), m2.group(3) == "true"
        return None, None, None
            
                
        
        
    def get_decl_DbgInfo(self, n):
        rr = re.compile(r'.*call void @llvm.dbg.declare\(metadata .+, metadata !(\d+),')
        ret = None
        #print("DBG_DECL: ", n.get_label())
        m = rr.match(n.get_label())
        if m is not None:
            dbg_line = self.get_prefix('!' + m.group(1))
            #print("DBG_LINE", dbg_line)
            dbg_m = re.match(r'.+name: "(\w+)", .+line: (\d+)', dbg_line[0])
            if dbg_m is not None:
                d = DbgInfo(n, dbg_m.group(1), dbg_m.group(2), 0)
                ret = d
        return ret

    
    def get_variable_name(self, desc):
        '''
        desc is of form 
        "{  %i = alloca i8*, align 8}"
        '''
        m = re.match(r'.+ %([\.\w]+) = ', desc)
        if m is not None:
            return m.group(1)
        else:
            return None
        
    def get_function_name(self, desc):
        '''
        desc is of form 
        "{  call void @xdc_asyn_send(...."
        '''
        m = re.match(r'.+call .+ @(\w+)\(', desc)
        if m is not None:
            return m.group(1)
        else:
            #print("Programming error!")
            return None
        
    def get_type_name(self, desc):
        '''
        desc is of form 
        "{  %37 = bitcast %struct._position_datatype* %pos to i8*, !dbg !3691..."
        "{  %36 = load i8*, i8** %send_pos_socket21, align 8, !dbg !3690
        "{   %t_tag = alloca %struct._tag, align 4
        '''
        m = re.match(r'.+bitcast %(\S+) %', desc)
        if m is not None:
            return m.group(1)
        m = re.match(r'.+load (\S+),', desc)
        if m is not None:
            return m.group(1)
        m = re.match(r'.+alloca %(\S+),', desc)
        if m is not None:
            return m.group(1)
        return "?"

def demangle(n):
    args = ['c++filt', n]
    pipe = subprocess.Popen(args, stdin=subprocess.PIPE, stdout=subprocess.PIPE)
    s1,_ = pipe.communicate()
    demangled = s1.decode().split("\n")
    return demangled[0]
            
#for testing only    
if __name__ == '__main__':
    r = IRReader()
    #r.read_ir(sys.argv[1])
    #print(r.get_label_irstring(['ORANGE_1']))
    #print(r.getDbgInfo("call void @llvm.var.annotation(i8* %g1, i8* getelementptr inbounds ([9 x i8], [9 x i8]* @.str.3, i32 0, i32 0), i8* getelementptr inbounds ([10 x i8], [10 x i8]* @.str.4, i32 0, i32 0), i32 47), !dbg !34"))
    #print(r.get_variable_DbgInfo('i'))
    print(r.demangle("_ZN7Subject6attachEP8Observer"))
