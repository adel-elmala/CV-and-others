
from jpegDesign import Ui_MainWindow
from decoder2 import jpeg

from PyQt5 import QtWidgets, QtCore
from PyQt5.QtWidgets import QFileDialog
import sys
import pyqtgraph as pg
import numpy as np
from PyQt5.QtGui import QIcon, QPixmap
    

class App(QtWidgets.QMainWindow):
    def __init__(self):
        super(App, self).__init__()
        self.ui = Ui_MainWindow()
        self.ui.setupUi(self)

        

    def open_file(self):
        filename = QFileDialog.getOpenFileName(None,"open file",'./p2',"signals(**.jpeg)")
        path = filename[0]
        # pathList= path.split('/')
        print(path)
        return path

    def JpegName(self,path:str):
        path = path.split('/')
        return path[-1]    

    def ProcessJpeg(self):
        img = jpeg(self.open_file())    
    def clearViews(self):
        view = [self.ui.out1,self.ui.out2,self.ui.out3,self.ui.out4,self.ui.out5,self.ui.out6,self.ui.out7,self.ui.out8]
        
        for i in range(8):
            view[i].clear()    
    def displayScans(self):
        self.ProcessJpeg()
        self.clearViews()
        view = [self.ui.out1,self.ui.out2,self.ui.out3,self.ui.out4,self.ui.out5,self.ui.out6,self.ui.out7,self.ui.out8]
        
        for i in range(8):
            
            # selected1raw = self.ui.comboBox_image1.currentText()
            # selected1 = self.mapText(selected1raw)1
            # label = QLabel(self)
            pixmap = QPixmap('output/scan-{}.jpeg'.format(i))
            view[i].setPixmap(pixmap)
            # view[i].resize(pixmap.width(),pixmap.height())
            # view it 
            # self.ui.image1Fourier.show()







def main():
    app = QtWidgets.QApplication(sys.argv)
    application = App()
    application.ui.pushButton.clicked.connect(application.displayScans)
    # application.ui.comboBox_image1.activated.connect(application.displayImgFourier)
    # application.ui.comboBox_image2.activated.connect(application.displayImgFourier)
    # application.ui.comboBox_comp1F.activated.connect(application.hideModes)
    # application.ui.comp1_slider.valueChanged.connect(application.readSliders)
    # application.ui.comp2_slider.valueChanged.connect(application.readSliders)
    # application.ui.comboBox_outTo.activated.connect(application.output)
    # application.ui.comp1_slider.valueChanged.connect(application.output)
    # application.ui.comp2_slider.valueChanged.connect(application.output)
    # application.ui.comboBox_comp1F.activated.connect(application.output)
    # application.ui.comboBox_comp2F.activated.connect(application.output)
    # application.ui.comboBox_comp1.activated.connect(application.output)
    # application.ui.comboBox_comp2.activated.connect(application.output)

    # application.ui.comboBox_comp2F.activated.connect(application.hideModes)
    
    application.show()
    app.exec_()


if __name__ == "__main__":
    main()
