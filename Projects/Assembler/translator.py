from tokenizer import Tokenizer
import re
import sys
class Translator(Tokenizer):
    def __init__(self,file):
        super().__init__(file)
        self.newFileName = self.fileName.partition('.')[0]+'.hack'

        self.compTable = {
        '0' :'0101010',
        '1' :'0111111',
        '-1':'0111010',
        'D' :'0001100',
        'A' :'0110000',
        'M' :'1110000',
        '!D':'0001101',
        '!A':'0110001',
        '!M':'1110001',
        '-D':'0001111',
        '-A':'0110011',
        '-M':'1110011',
        'D+1':'0011111',
        'A+1':'0110111',
        'M+1':'1110111',
        'D-1':'0001110',
        'A-1':'0110010',
        'M-1':'1110010',
        'D+A':'0000010',
        'D+M':'1000010',
        'D-A':'0010011',
        'D-M':'1010011',
        'A-D':'0000111',
        'M-D':'1000111',
        'D&A':'0000000',
        'D&M':'1000000',
        'D|A':'0010101',
        'D|M':'1010101'
        }



        self.destTable = {
            'null':'000',
            'M':'001',
            'D':'010',
            'MD':'011',
            'A':'100',
            'AM':'101',
            'AD':'110',
            'AMD':'111'}
        self.jumpTable = {
            'null':'000',
            'JGT':'001',
            'JEQ':'010',
            'JGE':'011',
            'JLT':'100',
            'JNE':'101',
            'JLE':'110',
            'JMP':'111'}

        self.symbols = {
            'R0':'0',
            'R1':'1',
            'R2':'2',
            'R3':'3',
            'R4':'4',
            'R5':'5',
            'R6':'6',
            'R7':'7',
            'R8':'8',
            'R9':'9',
            'R10':'10',
            'R11':'11',
            'R12':'12',
            'R13':'13',
            'R14':'14',
            'R15':'15',
            'SCREEN':'16384',
            'KBD':'24576',
            'SP':'0',
            'LCL':'1',
            'ARG':'2',
            'THIS':'3',
            'THAT':'4'
        }
        self.instuctionList = self.tokenizer()    
        self.translate(self.instuctionList)
        

    def identifyInst(self,instuction):
        instList = list(instuction)
        if instList[0] == '@':
            return "A-instruction"
        elif instList[0] == '(':
            return "Label"
        else:
            return "C-instruction"

    def aInstruction(self,instuction):
        instList = instuction.partition('@')
        try:
            value = int(instList[2])
            bCode = '0'+"{0:015b}".format(value)
            return bCode
            
        except:
            value = self.symbols[instList[2]]
            bCode = '0'+"{0:015b}".format(int(value))
            return bCode
            


        
    def cInstruction(self,instuction):
        instList = re.split(r'[;= ]',instuction)
        instList = [field for field in instList if field != '']
        if len(instList) == 3:
            dest = instList[0]
            comp = instList[1]
            jump = instList[2]
        else:
            if list(instList[1])[0] == 'J': # check if the last field starts with the char 'J' then its a jump directive
                comp = instList[0] 
                jump = instList[1]
                dest = 'null'
            else:
                dest = instList[0]
                comp = instList[1]    
                jump = 'null'

        destCode = self.destTable[dest]        
        compCode = self.compTable[comp]        
        jumpCode = self.jumpTable[jump]   

        cCode = '111'+compCode+destCode+jumpCode
             

        return cCode


    def labels(self,instructionList):
        labels = [(inst.strip('()'),i) for i,inst in enumerate(instructionList) if self.identifyInst(inst) == "Label"]
        labels = [ (labels[i][0],str(labels[i][1] - i)) for i in range(len(labels))]
        for label,i in labels:
            self.symbols[label] = i

        return labels

    def variablesHelper(self,instuction):
        
            instList = instuction.partition('@')
            try:
                int(instList[2])
                
            except:

                return instuction

    def variables(self,instructionList):
        aInstList = [inst for inst in instructionList if self.identifyInst(inst) == "A-instruction"]
        aInstList = set(aInstList)
        aInstList = [self.variablesHelper(inst) for inst in aInstList]
        aInstList = [inst for inst in aInstList if inst]
        aInstList = [inst for inst in aInstList if not(inst.partition('@')[2] in self.symbols)]

        for i,inst in enumerate(aInstList):
            variable = inst.partition('@')
            self.symbols[variable[2]] = str(i+16)


    def redirect(self,instruction):
        instType = self.identifyInst(instruction)
        if instType == "A-instruction":
            return self.aInstruction(instruction) 
        elif instType == "C-instruction":
            return self.cInstruction(instruction)
        



    def translate(self,instructionList):
        labels = self.labels(instructionList) # added labels to table
        instructionList = [inst for inst in instructionList if list(inst)[0] != '(']    # removed labels from list
        self.variables(instructionList)     # add variables to table
        instructionList = [self.redirect(inst) for inst in  instructionList]

        newFile = open(self.newFileName ,"a")
        [newFile.write(inst+'\n') for inst in instructionList]


        




def main():
    path = sys.argv[-1]    
    Translator(path)
    

if __name__ == '__main__':
    main()
