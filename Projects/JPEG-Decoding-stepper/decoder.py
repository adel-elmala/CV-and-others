import cv2
from PIL import Image
import numpy as np
from dataclasses import dataclass
# # img = cv2.imread('peter.jpeg')

# # img = Image.open("the-office.jpg")

# # Read the jpeg file into hex 
# imgData = open("the-office.jpg",'rb').read()
# #make it prettier
# imgData = ''.join(['%02x%02x,' % (imgData[2*i],imgData[2*i+1]) for i in range(len(imgData)>>1)])
# #putting it into a list 
# imgDataList = imgData.split(',')[:-1]
# print(imgDataList[0] == "ffd8")
# print(type(imgDataList[0]))

ZZMap = [
            0  , 1 , 8 ,16 , 9 , 2 , 3 ,10,
            17 ,24 ,32 ,25 ,18 ,11 , 4 , 5,
            12 ,19 ,26 ,33 ,40 ,48 ,41 ,34,
            27 ,20 ,13 , 6 , 7 ,14 ,21 ,28,
            35 ,42 ,49 ,56 ,57 ,50 ,43 ,36,
            29 ,22 ,15 ,23 ,30 ,37 ,44 ,51,
            58 ,59 ,52 ,45 ,38 ,31 ,39 ,46,
            53 ,60 ,61 ,54 ,47 ,55 ,62 ,63
        ] 

@dataclass
class quantTable:
    length: int
    mode: bool # 0 > 8-bit / 1 > 1-bit 
    id:int 
    data: list 


@dataclass
class huffmanTable:
    symbols: list #  8-bit symol  
    


class jpeg():
    def __init__(self,path:str):
        self.path = path
        self.jpgDataList = None
        self.quantTables = []  
        self.restartInterval = 0
        self.huffmanAcTables = [-1]*(4)
        self.huffmanDcTables = [-1]*(4)

    def readJpeg(self):
            # Read the jpeg file into hex 
            imgData = open(self.path,'rb').read()
            #make it prettier
            imgData = ''.join(['%02x,%02x,' % (imgData[2*i],imgData[2*i+1]) for i in range(len(imgData)>>1)])
            #putting it into a list 
            self.jpgDataList = imgData.split(',')[:-1]
            # self.jpgDataList = np.array(self.jpgDataList,dtype=hex)

    def findMarker(self,marker:str):
        # print(self.jpgDataList.index(marker))
        indices = [i for i, x in enumerate(self.jpgDataList) if x == marker]
        print(indices)
        return indices

    def findMarker2(self,marker:str):
        indices = []
        for i, x in enumerate(self.jpgDataList):
            if i < len(self.jpgDataList)-1:
                if (x + self.jpgDataList[i+1]== marker) :
                    indices.append(i+1)
        print(indices)
        return indices
   
    def readLength(self,twoBytes:str):
        return int(twoBytes,16)
   
    def readInfo(self,byte:str):
        lst = list(byte)
        if len(lst) == 2:
            mode = bool(int(lst[0],16))
            id = int(lst[1])
            return mode,id
        else:
            return -99,-99    
        
    def readHuffman(self):
        markerIndcies = self.findMarker2('ffc4')

        for i in range(len(markerIndcies)):
            tableLoc = markerIndcies[i]  
            length = self.jpgDataList[tableLoc+1]+self.jpgDataList[tableLoc+2] 
            length = self.readLength(length) - 2 # length without the 2byts of length themself
            current = tableLoc + 3 # at the fisrt tableinfo byte 
            while(length > 0 ):
                tableMode,tableId = list(map(lambda x: int(x,16),self.jpgDataList[current]))
                symbols = []
                symbolsIndex = current + 17
                
                subtableLength = 0
                for i in range(16):
                    current += 1
                    subtableLength += int(self.jpgDataList[current],16)
                    symbols.append(self.jpgDataList[symbolsIndex:int(self.jpgDataList[current],16)+symbolsIndex])
                    symbolsIndex += int(self.jpgDataList[current],16)
                
                if(tableMode == 0):# DC table
                    self.huffmanDcTables[tableId] = symbols
                else:
                    self.huffmanAcTables[tableId] = symbols
                length = length - 17 - subtableLength
        
    
    def prettyDisplay(self):
        print("====== Quantization Table 0 ====== ")
        for i in range(8):
            print(file.quantTables[0].data[0][i*8:(i+1)*8])
        print("====== Quantization Table 1 ====== ")
        for i in range(8):
            print(file.quantTables[0].data[1][i*8:(i+1)*8])
        
        
        print("====== AC Huffman tables  ======")
        for i in range(len(self.huffmanAcTables)):
            print ('=== Table ID:',i,' ===' )
            if self.huffmanAcTables[i] == -1 :
                print("Table ({}) Not found".format(i))
            else:    
                for j in range(len(self.huffmanAcTables[i])):
                     
                    print(self.huffmanAcTables[i][j])
                
        
        
        print("====== DC Huffman tables  ======")
        for i in range(len(self.huffmanDcTables)):
            print ('=== Table ID:',i,' ===' )
            if self.huffmanDcTables[i] == -1 :
                print("Table ({}) Not found".format(i))
            else:    
                for j in range(len(self.huffmanDcTables[i])):
                    
                    print(self.huffmanDcTables[i][j])
                
        

        
    def readRestartInterval(self):
        markerIndex = self.findMarker2('ffdd')
        length=  self.jpgDataList[markerIndex+1]+self.jpgDataList[markerIndex+2] 
        length = self.readLength(length)
        if ((length - 4) == 0):
            RI = self.jpgDataList[markerIndex+3]+self.jpgDataList[markerIndex+4]
            self.restartInterval = self.readLength(RI)

    def readQuanTables(self):
        markerIndcies = self.findMarker2('ffdb')
        print(markerIndcies)
        for i in range(len(markerIndcies)):
            length = self.readLength(self.jpgDataList[(markerIndcies[i]+1)]+self.jpgDataList[(markerIndcies[i]+2)])
            
            mode,id = self.readInfo(self.jpgDataList[markerIndcies[i]+3]) 
            numOfTables = (length - 2)% 64 
            print(numOfTables)
            values = []
            # not supporting 128-bit tables 
            # read each table for each channel
            current = markerIndcies[i] + 4
            for j in range(numOfTables):
                subTableVals = []
                if not mode: # 8-bit  
                    for k in  range(64):
                        subTableVals.append(int(self.jpgDataList[current+k],16))
                    # subTableVals[:] = [subTableVals[l] for l in ZZMap]
                    zigzagOrdered =  [0]*(64)
                    for i in range(64):
                        zigzagOrdered[ZZMap[i]] = subTableVals[i]
                    values.append(zigzagOrdered)
                    current = current+ 65
                else:
                    # not supporting 16-bit for now 
                    pass
            table = quantTable(length,mode,id,values)
            self.quantTables.append(table)
            # print(table.mode,table.length,table.id,table.data)
        
    # def ZigZag(self):
    #     ZZMap =[
    #         0  , 1 , 8 ,16 , 9 , 2 , 3 ,10,
    #         17 ,24 ,32 ,25 ,18 ,11 , 4 , 5,
    #         12 ,19 ,26 ,33 ,40 ,48 ,41 ,34,
    #         27 ,20 ,13 , 6 , 7 ,14 ,21 ,28,
    #         35 ,42 ,49 ,56 ,57 ,50 ,43 ,36,
    #         29 ,22 ,15 ,23 ,30 ,37 ,44 ,51,
    #         58 ,59 ,52 ,45 ,38 ,31 ,39 ,46,
    #         53 ,60 ,61 ,54 ,47 ,55 ,62 ,63
    #         ] 
    #     for i in     
    #     self.quantTables    

file = jpeg("peter2-progressive.jpeg")


file.readJpeg()
file.findMarker2('ffc4')
file.readQuanTables()
file.readHuffman()

# print("DC huffman",file.huffmanDcTables)
# print("AC huffman",file.huffmanAcTables)

# print(file.quantTables)


file.prettyDisplay()


# print(file.jpgDataList[0:200])
# file.findMarker2('ffdb')
# print(file.readLength('09f8'))
# print(int('01',16))
# print((file.jpgDataList[4] << 8)+file.jpgDataList[5])
img = Image.open("peter2.jpeg")
tables = img.quantization
# print(tables)
# var1,var2 = list('01')
# print(var1,var2)
# print(type(var1))
# print(list(range(64)))
# lst = []
# lst2=[1,2,3]
# lst.append(lst2[0:2])
# print(lst)