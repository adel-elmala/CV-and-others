import re

class Tokenizer():
    
    def __init__(self,fileName):
        self.fileName = fileName

        
    
    def readFile(self):
        # Check if its right extention
        pattern = re.compile(r'.*[.]vm')

        match = re.match(pattern,self.fileName)

        if match:
            with open(self.fileName, 'r') as reader:
                lines = reader.readlines()
                
                return lines
        else:
            raise "File Extenstion not supported"
   


    def filterLine(self,line):
        lineList = line.split()
        return ((lineList == []) or (lineList[0] == '//'))

    def tokens(self,line):
        triple = line.partition('//') # Remove in-line comments
        token  = triple[0].rstrip('\n') # Remove '\n' chars
        token  = token.strip()  # Remove leading and trailing whitespaces
        return token

    def filter(self,list):
        filterList = [ self.tokens(line) for line in list if not(self.filterLine(line)) ]    

        
        return filterList

    def tokenizer(self):
        file = self.readFile()
        return self.filter(file)    



