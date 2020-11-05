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
        self.init = False

        self.identifyPath()

    def identifyPath(self):
        path = re.split(r'[ / \ ]',self.path)
        last = path[-1]
        
        
        pattern = re.compile(r'.*[.]vm$')
        match = re.match(pattern,last)
        if match: # vm File
            self.fileNoExt = last.partition('.')[0]
            self.writeToFile = self.fileNoExt + '.asm'

            self.fileName = last
            self.translateFile(self.fileName,self.path)
        else : # Folder
            self.writeToFolder = self.path
            self.writeToFile =  self.writeToFolder + self.fileName.partition('.')[0] + ".asm"
            self.folderName = last
            self.translateFolder(self.writeToFolder)

    
    
    def translateFile(self,fileName,path):

        parser = Tokenizer(path)
        commands = parser.tokenizer()   # List of vm commands
        coder = CodeWriter()
        with open( self.writeToFile, 'w') as writer:
            for i,cmd in enumerate(commands) :
                translated = coder.writeCode(cmd,i,self.fileNoExt,self.fileNoExt) 
                
                translated = [f"//{cmd}"] + translated
                #  translated
                [writer.write(tcmd + '\n') for tcmd in translated]

    def translateFolderHelper(self,fileName,folderName):

        parser = Tokenizer(fileName)
        commands = parser.tokenizer()   # List of vm commands
        coder = CodeWriter()
        with open( f'./{folderName}/{folderName}.asm', 'a') as writer:
            for i,cmd in enumerate(commands) :
                translated = []
                booting = []
                if not(self.init):
                    booting += coder.writeInit(folderName,i)
                    self.init = True
                translated += coder.writeCode(cmd,i,self.folderName,self.fileNoExt) 
                
                translated = booting + [f"//{cmd}"] + translated
                [writer.write(tcmd + '\n') for tcmd in translated]            

    def translateFolder(self,folder):
        for filename in glob.glob(os.path.join(folder, '*.vm')):
            self.fileName = filename
            self.writeToFile =  self.fileName.partition('.')[0] + ".asm"
            self.fileNoExt = filename.partition('.')[0].partition('/')[-1]
            self.translateFolderHelper(self.fileName,folder)




def main():
    path = sys.argv[-1]    
    print(f'PATH IS :::: {path}')
    VMtranslator(path)
    
if __name__ == '__main__':
    main()