from __future__ import print_function
from __future__ import division
import numpy as np
import matplotlib.pyplot as plt
import librosa

import librosa.display
# import librosa.output
import soundfile as sf
import os

from scipy.io import wavfile
import time
# from scipy.io import wavfile
from sklearn.decomposition import FastICA 


class vocalSeparator():

    def __init__(self,path:str):
        self.path = path
        self.songSamples = None
        self.songSR = None
        self.mag = None
        self.phase = None
        self.filter = None
        self.mask_i = None
        self.mask_v = None
        self.background = None
        self.foreground = None
        
        print("READING")
        self.readSong()
        self.magAndPhase()
        print("FILTERING")
        self.composeFilter()
        self.FilterSound()
        print("WRITINGSOUNDS")
        self.writeSound()
        print("done")
    def readSong(self):
        self.songSamples, self.songSR = librosa.load(self.path, duration=40)    

    def magAndPhase(self):
        self.mag, self.phase = librosa.magphase(librosa.stft(self.songSamples))

    def composeFilter(self):

        self.filter = librosa.decompose.nn_filter(self.mag,
                                            aggregate=np.median,
                                            metric='cosine',
                                            width=int(librosa.time_to_frames(2, sr=self.songSR)))
        self.filter =  np.minimum(self.mag, self.filter)


    def FilterSound(self):
        margin_i, margin_v = 2,10
        power = 2
        self.mask_i = librosa.util.softmask(self.filter,
                                    margin_i * (self.mag -self.filter),
                                    power=power)

        self.mask_v = librosa.util.softmask(self.mag - self.filter,
                                    margin_v * self.filter,
                                    power=power)

        # Once we have the masks, simply multiply them with the input spectrum
        # to separate the components
    def getsongName(self):
        name  = self.path.split('.')
        songName = name[0]
        print(songName)
        return songName
    def writeSound(self):
        songname = self.getsongName()
        self.foreground = self.mask_v * self.mag
        self.background = self.mask_i * self.mag

        new_y = librosa.istft(self.foreground*self.phase)
        new_x = librosa.istft(self.background*self.phase)
        # librosa.output.write_wav("hehe.wav", new_y, sr)
        os.system("mkdir {}".format(songname))
        sf.write("{}/vocals.wav".format(songname ), new_y, self.songSR)
        sf.write("{}/music.wav".format(songname ), new_x, self.songSR)



class cocktail():
    def __init__(self,path1:str,path2:str):
        self.path1 = path1
        self.path2 = path2
        self.mic1 = None
        self.mic2 = None
        self.mic1Fs1 = None
        self.mic2Fs2 = None
        self.mixed = None
        self.A = None # mixing matrix
        print("READING")
        self.readMics()
        print("MIXING")
        self.mixMics()
        print("ICA")
        self.ica()
        print("DONE")
    def readMics(self):
        self.mic1,self.mic1Fs1= librosa.load(self.path1, duration=40)
        self.mic2,self.mic2Fs2= librosa.load(self.path2, duration=40)
        # Reshape to match them / not needed since reading specific duration / but meeehh
        m, = self.mic1.shape 
        self.mic2 = self.mic2[:m]
    def mixMics(self):
        voice = np.c_[self.mic1,self.mic2]
        self.A = np.array([[1,0.5], [0.5, 1]])
        self.mixed = np.dot(voice, self.A.T)    
    def getsongName(self):
        name1  = self.path1.split('.')
        name2 = self.path2.split('.')
        mic1Name = name1[0]
        mic2Name = name2[0]
        filename = mic1Name+'-'+mic2Name
        print(filename)
        return filename
    def ica(self):
        
        # blind source separation using ICA
        ica = FastICA(n_components=2)
        ica.fit(self.mixed)
        # get the estimated sources
        S_ = ica.fit_transform(self.mixed)
        # get the estimated mixing matrix
        A_ = ica.mixing_
        # assert np.allclose(X, np.dot(S_, A_.T) + ica.mean_)
        S_ = S_ * 10
        folderName = self.getsongName()
        os.system("mkdir {}".format(folderName))
        os.system("echo made new directory")
        #Write new separated audios
        wavfile.write('{}/seperated1.wav'.format(folderName),self.mic1Fs1,S_[:,0])
        wavfile.write('{}/seperated2.wav'.format(folderName),self.mic2Fs2,S_[:,1])    



#------------IGNORE / DOESN"T WORK FOR NOW /  --------------# 
class spleeter(): # this method uses a tool that runs through the command line 
    def __init__(self,path:str):
        self.path = path

        self.useSpleeter()

    def setUpSpleeter(self):
        os.system("echo installing ffmpeg")
        os.system("apt install ffmpeg") # try "sudo apt install ffmpeg" if produced an error
        os.system("echo installed ffmpeg")
        os.system("echo installing spleeter")
        os.system("pip install spleeter")
        os.system("echo installed spleeter")
   
    def getsongName(self):
        name  = self.path.split('.')
        filename = name[0]
        print(filename)
        return filename
   
    def useSpleeter(self):    
        folderName = self.getsongName()
        os.system("mkdir {}".format(folderName))
        os.system("echo made new directory")
        os.system("echo using spleeter")
        os.system("spleeter separate -i {} -o {}/".format(self.path,folderName))
        os.system("echo Done")
# -------------------------------------------------------------#

# song = vocalSeparator("Berlin_BellaCiao_22.mp3")

# song = vocalSeparator("Sia_Alive_05.mp3")

# cocktailAudio = cocktail("sss1.wav","sss2.wav")

###spleeter = spleeter("Berlin_BellaCiao_22.mp3")