#!/usr/bin/env python

from parser import Tokenizer
from codeWriter import CodeWriter
import re
import os
import glob
import sys

class VMtranslator():
    """
        Translate VM command to Hack-assembly commands 

    """
    def __init__(self,path):
        self.path = path
        self.fileName = ''
        self.folderName = ''
        self.writeToFile = ''
        self.writeToFolder = ''
        self.fileNoExt = ''

        self.identifyPath()

    def identifyPath(self):
        path = re.split(r'[ / \ ]',self.path)
        last = path[-1]
        pattern = re.compile(r'.*[.]vm$')
        match = re.match(pattern,last)

        if match: # vm File
            self.fileNoExt = last.partition('.')[0]
            self.writeToFile = f'{path[0]}/{self.fileNoExt}.asm'  

            self.fileName = last
            self.translateFile(self.path)
        else : # Folder
            print("NOT handling multiple files YET")
            

    
    
    def translateFile(self,fileName):
        parser = Tokenizer(fileName)
        commands = parser.tokenizer()   # List of vm commands
        coder = CodeWriter()
        with open( self.writeToFile, 'w') as writer:
            for i,cmd in enumerate(commands) :
                translated = coder.writeCode(cmd,i,self.fileNoExt,self.fileNoExt) 
                
                translated = [f"//{cmd}"] + translated
                #  translated
                [writer.write(tcmd + '\n') for tcmd in translated]

    def translateFolder(self,folder):
        for filename in glob.glob(os.path.join(folder, '*.vm')):
            self.fileName = filename
            self.writeToFile =  self.fileName.partition('.')[0] + ".asm"


            self.translateFile(self.fileName)



def main():
    path = sys.argv[-1]
    print(f'PATH IS :::: {path}')

    VMtranslator(path)
    
if __name__ == '__main__':
    main()