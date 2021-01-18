# 16-bit VM Translator - Full 

Trasnlate from Hack's VM Language to hack's 16-bit Assebmly

Handles ALL of the Hack's VM commands
- Memory segments access commands
- Stack Arithmetic commands
- Function Calls commands
- Program Flow commands
## How to use 

1. Run the command

```sh
    python3 VMTranslator.py FOLDERNAME  # translate all vm files inside the folder into a single assembly file along with Booting
    
    # OR
    
    python3 VMTranslator.py FOLDERNAME/FileName.vm # Translate the file directly without Booting

```

1. Will Generate FOLDERNAME/FOLDERNAME.asm if First command used
2. Will Generate FileName.asm if second command used


### Also Supplied some VM files for testing
- BasicLoop
- FibonacciElement
- FibonacciSeries
- NestedCall
- SimpleFunction
- StaticsTest