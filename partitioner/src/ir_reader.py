import subprocess
import sys
import re

class DbgInfo():
    def __init__(self, node_, name_, line_, column_, file_ = None):
        self.node = node_
        self.name = name_
        self.line = str(line_)
        self.column = str(column_)
        self.file = file_

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
        
        
    def __str__(self):
        fstr = "" if self.file is None else " in file " + self.file
        return "Name: %s on line %s column %s%s" % (self.name, self.line, self.column, fstr)

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
        ret = None
        label = node.get_label().replace('\\\n', "")
        #print("label:", label)
        if label is None: return None
        #for some reason the dgb label at the end of the line gets mangled
        if var is None and label.startswith("\"{GLOBAL_VALUE"):
            m = re.match(r".+GLOBAL_VALUE:@(\w+) .+!dbg !(\d+)", label)
            if m:
                var = m.group(1)
                l, c = self.get_line_col(m.group(2))
                ret = DbgInfo(node, var, l, c)
                return ret
        m = re.match(r'.+DBGLOC file (\S+) line (\d+) col (\d+) ENDDBGLOC', label)
        if m is not None:
            #print("l", m.group(1), "c", m.group(2))
            ret = DbgInfo(node, var,  m.group(2), m.group(3), m.group(1))
        
        return ret


    def get_line_col(self, num):
        dbg_line = self.get_prefix('!' + num)
        if len(dbg_line) < 1:
            return None, None
        m = re.match(r".+DIGlobalVariableExpression\(var: !(\d+), expr: .+", dbg_line[0])
        if m:
            return self.get_line_col(m.group(1))
        else:
            m2 = re.match(r".+DIGlobalVariable.+ line: (\d+)", dbg_line[0])
            if m2:
                return m2.group(1), 0
        return None, None
            
                
        
        
    def get_variable_DbgInfo(self, pname):
        return None
    '''
        rr = re.compile(r'call void @llvm.dbg.declare\(metadata .+ %' + pname + ', metadata !(\d+),')
        ret = []
        for l in self.ir_lines:
            m = rr.match(l)
            if m is not None:
                dbg_line = self.get_prefix('!' + m.group(1))
                dbg_m = re.match(r'.+name: "(\w+)", .+line: (\d+)', dbg_line[0])
                if dbg_m is not None:
                    d = DbgInfo(dbg_m.group(1), dbg_m.group(2), 0)
                    ret.append(d)
        return ret
    '''
    
    def get_variable_name(self, desc):
        '''
        desc is of form 
        "{  %i = alloca i8*, align 8}"
        '''
        m = re.match(r'.+ %(\w+) = ', desc)
        if m is not None:
            return m.group(1)
        else:
            #print("Programming error!")
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
