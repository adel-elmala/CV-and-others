# -*- coding: utf-8 -*-

# Form implementation generated from reading ui file 'AdelDesing.ui'
#
# Created by: PyQt5 UI code generator 5.6
#
# WARNING! All changes made in this file will be lost!

from PyQt5 import QtCore, QtGui, QtWidgets

class Ui_MainWindow(object):
    def setupUi(self, MainWindow):
        MainWindow.setObjectName("MainWindow")
        MainWindow.resize(438, 193)
        self.centralwidget = QtWidgets.QWidget(MainWindow)
        self.centralwidget.setObjectName("centralwidget")
        self.gridLayout = QtWidgets.QGridLayout(self.centralwidget)
        self.gridLayout.setObjectName("gridLayout")
        self.verticalLayout = QtWidgets.QVBoxLayout()
        self.verticalLayout.setObjectName("verticalLayout")
        self.musicandvocals = QtWidgets.QPushButton(self.centralwidget)
        self.musicandvocals.setObjectName("musicandvocals")
        self.verticalLayout.addWidget(self.musicandvocals)
        self.cocktail = QtWidgets.QPushButton(self.centralwidget)
        self.cocktail.setObjectName("cocktail")
        self.verticalLayout.addWidget(self.cocktail)
        self.label = QtWidgets.QLabel(self.centralwidget)
        self.label.setObjectName("label")
        self.verticalLayout.addWidget(self.label)
        self.gridLayout.addLayout(self.verticalLayout, 0, 0, 1, 1)
        MainWindow.setCentralWidget(self.centralwidget)
        self.menubar = QtWidgets.QMenuBar(MainWindow)
        self.menubar.setGeometry(QtCore.QRect(0, 0, 438, 22))
        self.menubar.setObjectName("menubar")
        MainWindow.setMenuBar(self.menubar)
        self.statusbar = QtWidgets.QStatusBar(MainWindow)
        self.statusbar.setObjectName("statusbar")
        MainWindow.setStatusBar(self.statusbar)

        self.retranslateUi(MainWindow)
        QtCore.QMetaObject.connectSlotsByName(MainWindow)

    def retranslateUi(self, MainWindow):
        _translate = QtCore.QCoreApplication.translate
        MainWindow.setWindowTitle(_translate("MainWindow", "MainWindow"))
        self.musicandvocals.setToolTip(_translate("MainWindow", "Choose song file"))
        self.musicandvocals.setStatusTip(_translate("MainWindow", "Choose song file"))
        self.musicandvocals.setText(_translate("MainWindow", "Music AND Vocals"))
        self.cocktail.setToolTip(_translate("MainWindow", "Choose 2 audio files one for each mic"))
        self.cocktail.setStatusTip(_translate("MainWindow", "Choose 2 audio files one for each mic"))
        self.cocktail.setText(_translate("MainWindow", "CockTail party Audios"))
        self.label.setText(_translate("MainWindow", "Proccess"))


if __name__ == "__main__":
    import sys
    app = QtWidgets.QApplication(sys.argv)
    MainWindow = QtWidgets.QMainWindow()
    ui = Ui_MainWindow()
    ui.setupUi(MainWindow)
    MainWindow.show()
    sys.exit(app.exec_())

