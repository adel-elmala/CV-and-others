class CodeWriter():
    """
    Translate VM command to Hack-assembly commands 
    """
    def __init__(self):

        self.arithmeticTypes = ["add","sub","neg","eq","gt","lt","and","or","not"]
        self.memoryTypes     = ["push","pop"]
        self.flowTypes       = ["label","goto", "if-goto"]
        self.functionTypes   = ["function","call", "return"]
        self.segmentTypes    = ["constant","this","that","pointer","temp","static","local","argument"]

    def commandType(self,command):
        command = command.split(' ')[0]
        
        if command in self.arithmeticTypes:
            return "C_ARITHMETIC"
        else:
           return "C_" + command.split("-")[0].upper()

    def arg1(self,command):
        ctype = self.commandType(command)
        if ctype == "C_ARITHMETIC":
            arg1 = command
        elif ctype == "C_RETURN":
            raise "SHOULDN't BE CALLED WITH 'C_RETURN' command"
        else: 
            arg1 = command.split(' ')[1]
        return arg1


    def arg2(self,command): 
        ctype = self.commandType(command)
        if  ctype in ["C_PUSH" ,"C_POP",  "C_FUNCTION",  "C_CALL"]:

            return int(command.split(' ')[-1])
        else:
            raise "SHOULDN't BE CALLED" 


    def writeArithmetic(self,command,commandNo):
        
        if command in ["not","neg"]:
            # get the top 1 stack
            code1 =["@SP","M=M-1","A=M","D=M"]
            # operate on it  
            op = ['D=!D'] if command == "not" else  ['D=-D']                    
            # push result onto stack 
            code2 =["@SP","A=M" ,"M=D" ,"@SP","M=M+1"]

            return code1 + op +code2

        else:            
            # get the top 2 stacks
            code1 = ["@SP","M=M-1","A=M","D=M","@SP","M=M-1","A=M"]
            # operate on them and push onto the stack
            if command == "add":
                code2 = ['D=D+M',"@SP","A=M","M=D","@SP","M=M+1"]
            elif command == "sub":
                code2 = ['D=M-D',"@SP","A=M","M=D","@SP","M=M+1"]
            elif command == "and":
                code2 = ['D=M&D',"@SP","A=M","M=D","@SP","M=M+1"]
            elif command == "or":
                code2 = ['D=M|D',"@SP","A=M","M=D","@SP","M=M+1"]
            elif command == "eq":
                code2 = ['D=M-D',f'@EQUAL_{commandNo}','D;JEQ','@SP','A=M','M=0',"@SP","M=M+1",f"@SKIP_{commandNo}","0;JMP",f'(EQUAL_{commandNo})','@SP','A=M','M=-1',"@SP","M=M+1",f"(SKIP_{commandNo})"]

            elif command == "gt":
                code2 = ['D=M-D',f'@GREATER_{commandNo}','D;JGT','@SP','A=M','M=0',"@SP","M=M+1",f"@SKIP_{commandNo}","0;JMP",f'(GREATER_{commandNo})','@SP','A=M','M=-1',"@SP","M=M+1",f"(SKIP_{commandNo})"]
            elif command == "lt":
                code2 = ['D=M-D',f'@LESS_{commandNo}','D;JLT','@SP','A=M','M=0',"@SP","M=M+1",f"@SKIP_{commandNo}","0;JMP",f'(LESS_{commandNo})','@SP','A=M','M=-1',"@SP","M=M+1",f"(SKIP_{commandNo})"]           
            # code3 = ["@SP","M=M+1",f"(SKIP_{commandNo})"]
            return code1 + code2         


    def writePushPop(self,command,fileName):
        ctype = self.commandType(command)
        segment = self.arg1(command)
        Index = self.arg2(command)


        
        if ctype == "C_PUSH":
            if segment == "constant":
                code1 = [f"@{Index}","D=A"]    
            elif segment == "local":
                code1 = [f"@{Index}","D=A",'@LCL',"A=M+D","D=M"]    
            elif segment == "argument":
                code1 = [f"@{Index}","D=A",'@ARG',"A=M+D","D=M"]    
            elif segment == "this":
                code1 = [f"@{Index}","D=A",'@THIS',"A=M+D","D=M"]    
            elif segment == "that":
                code1 = [f"@{Index}","D=A",'@THAT',"A=M+D","D=M"]    
            elif segment == "pointer":
                code1 = [f"@{Index}","D=A",'@THIS',"A=A+D","D=M"]    
            elif segment == "temp":
                code1 = [f"@{Index}","D=A",'@R5',"A=A+D","D=M"]    
            elif segment == "static":
                code1 = [f'@{fileName +"."+ str(Index)}',"D=M"]

            code2 = ["@SP","A=M","M=D","@SP","M=M+1"]
            return (code1 + code2)    
        elif ctype == "C_POP":
            code1 = ["@SP","M=M-1","A=M","D=D+M","A=D-M","M=D-A"] #TOP stack in D

            # 
            if segment == "local":                 #addr                       #addr+value
                code2 = [f"@{Index}","D=A",'@LCL',"D=M+D"]    # D cointains target Register
            elif segment == "argument":
                code2 = [f"@{Index}","D=A",'@ARG',"D=M+D"]    
            elif segment == "this":
                code2 = [f"@{Index}","D=A",'@THIS',"D=M+D"]    
            elif segment == "that":
                code2 = [f"@{Index}","D=A",'@THAT',"D=M+D"]    
            elif segment == "pointer":
                code2 = [f"@{Index}","D=A",'@THIS',"D=A+D"]    
            elif segment == "temp":
                code2 = [f"@{Index}","D=A",'@R5',"D=A+D"]    
            elif segment == "static":
                code2 = [f'@{fileName +"."+ str(Index)}',"D=A"]
            return code2 + code1

    def writeCode(self,command,commandNo,fileName):
        ctype = self.commandType(command)
        if ctype == "C_ARITHMETIC":
            return self.writeArithmetic(command,commandNo)
        elif ctype in ["C_PUSH","C_POP"]:
            return self.writePushPop(command,fileName)                

