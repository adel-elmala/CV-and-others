

from designP4 import Ui_MainWindow
# from appV2 import audioSpectogram

import myAwesomeApp
from PyQt5 import QtWidgets, QtCore ,QtGui
from PyQt5.QtWidgets import QFileDialog
import sys
import time

class App(QtWidgets.QMainWindow):
    def __init__(self):
        super(App, self).__init__()
        self.ui = Ui_MainWindow()
        self.ui.setupUi(self)


    def open_file(self):
        filename = QFileDialog.getOpenFileName(None,"open file",'./p4',"signals(*.mp3 *.wav)")
        path = filename[0]
        # pathList= path.split('/')
        print(path)
        return path

    def SongName(self,path:str):
        path = path.split('/')
        return path[-1]    

    def vocalSeparator(self):
        audiofile = self.open_file()
        self.ui.label.setText("Proccessing...")
        songName = self.SongName(audiofile)
        # self.ui.label.setText("Proccessing...")
        
        myAwesomeApp.vocalSeparator(songName)
        # self.ui.label.setText("Created {} folder".format(songName))
        # time.sleep(3)
        self.ui.label.setText("Done. Check your Folders :)")

        # edit label 
         
    def cocktail(self):
        audiofileMic1 = self.open_file()
        mic1Name = self.SongName(audiofileMic1)
        self.ui.label.setText("Choose mic2 file")
        audiofileMic2 = self.open_file()
        mic2Name = self.SongName(audiofileMic2)
        self.ui.label.setText("Proccessing...")
        myAwesomeApp.cocktail(mic1Name,mic2Name)
        self.ui.label.setText("Created {} folder".format(mic1Name+'-'+mic2Name))
        # time.sleep(3)
        # newfont = QtGui.QFont("SansSerif", 16, QtGui.QFont.Bold) 
        # self.ui.label.setFont(newfont)
        self.ui.label.setText("Done. Check your Folders :)")
        #edit label

def main():
    app = QtWidgets.QApplication(sys.argv)
    application = App()

    application.ui.musicandvocals.clicked.connect(application.vocalSeparator)
    application.ui.cocktail.clicked.connect(application.cocktail)
    # application.ui.mix.clicked.connect(application.mixIt)
    # application.ui.average.toggled.connect(application.readMode)
    # application.ui.difference.toggled.connect(application.readMode)
    # application.ui.perception.toggled.connect(application.readMode)
    # application.ui.compare.clicked.connect(application.compare)
    # # application.ui.comp2_slider.valueChanged.connect(application.output)

    # application.ui.comboBox_comp2F.activated.connect(application.hideModes)
    
    application.show()
    app.exec_()


if __name__ == "__main__":
    main()        