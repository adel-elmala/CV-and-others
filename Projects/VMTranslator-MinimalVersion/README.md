# 16-bit VM Translator - MIN

Trasnlate from Hack's VM Language to hack's 16-bit Assebmly

Handles only a subset of the full Hack's VM commands
- Memory segments access commands
- Stack Arithmetic commands

## How to use 

1. Run the command

```sh
     python3 VMTranslator.py FOLDERNAME/FileName.vm 
```

1. Will Generate FOLDERNAME/FileName.asm 
   


### Also Supplied some VM files for testing
- SimpleAdd
- StackTest
- StaticTest
- PointerTest