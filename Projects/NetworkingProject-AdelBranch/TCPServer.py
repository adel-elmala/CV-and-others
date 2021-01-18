from socket import socket, AF_INET, SOCK_STREAM, SHUT_RDWR, timeout, SOCK_DGRAM ,error,gethostname,gethostbyname
import sys
from BMI import BMI
from db import ServerDB


class TCPServer():

    def __init__(self, serverPort):
        self.serverSocket = None
        self.serverState = None
        self.connectionSocket = None
        self.clientAddr = None
        
        self.bmiCal = BMI()
        self.dataBase = ServerDB()        

        self.initServer(serverPort)
        self.initConnection()

        self.chatLoop()

        self.serverSocket.shutdown(SHUT_RDWR)
        self.serverSocket.close()
        sys.exit()

    def initServer(self, serverPort):
        localIP = get_local_IP()
        # Create the server Welcoming socket
        self.serverSocket = socket(AF_INET, SOCK_STREAM)
        # Bind the Welcoming socket to {it's interface} and {serverPort}
        try:
            self.serverSocket.bind((localIP, serverPort))
        except error:
            print("Failed to bind")
            sys.exit()
        print(f'---- Created serverSocket ----')
        # server Welcoming socket is waiting for clients to connect to it ...
        self.serverSocket.listen(1)
        print(f'serverSocket Listening...')

        self.serverState = True

    def initConnection(self):

        # while self.serverState:
        self.connectionSocket, self.clientAddr = self.serverSocket.accept()
        # if idle: times out after 30 secs
        self.connectionSocket.settimeout(30)
        print(f'-- Created new connectionSocket --')
        print(f'conncted with: {self.clientAddr}')

    def chatFClient(self):

        recievedMsg = self.connectionSocket.recv(1024).decode()

        print(f'{self.clientAddr} says: {recievedMsg}\n')

        return recievedMsg

    def chatTClient(self, messageTosend: str):
        self.connectionSocket.sendall(messageTosend.encode())

        # print(f'Sent: {messageTosend}')

    def checkCredentials(self,username,password):
        result = self.dataBase.select_user_by_name((username))
        if result == 'notFound': # create new entry
            self.dataBase.create_user((username,password,-99.99))
            return 'new',-99.99
        else: 
            storedPassword = result[1]
            oldBmi = result[-1]
            if storedPassword == password:
                return 'success',oldBmi
            else:
                return 'fail',-99.99


    def chatLoop(self):
        inputMsg = ' '
        rcvdMsg = ' '

        self.chatTClient('Welcome to the great BMI calculator,\nPlease Enter username,password to login/signup\nTo Quit Enter exit')
        while rcvdMsg.upper().strip() != 'BYE':
            try:
                # TODO: check for 'BYE' 
                # ::DONE::

                response = self.chatFClient()

                if response.upper().strip() == 'EXIT':
                    break
                else:
                    username,password = response.strip().split(',')


                print(f'username: {username} ,password: {password}')
                #TODO: check in DB if user exists by name , if not create a new user entry , if it does -> check if password match,,, and send a notification to verify the login , and old BMI 
                # :: DONE ::

                #FIXME: could add an option to check both if the password exits and is correct but username is not, and instead of creating a new entry , ask the user first if he wwant to signup


                statFlag,oldBmi = self.checkCredentials(username,password)
                if statFlag == 'new':
                    self.chatTClient(f'{statFlag}:new accounted is created\n Please Enter you Weight,Height')
                elif statFlag == 'success':
                    self.chatTClient(f'{statFlag}:logged-in successfully, your old BMI is {oldBmi}\n Please Enter you Weight,Height')
                else:
                    self.chatTClient(f'{statFlag}:Try again') # fail
                    continue # loop again

                try:
                    weight,height = self.chatFClient().strip().split(',')
                    bmi,catagory = self.bmiCal.notify(int(weight),int(height))
                    self.chatTClient(f'Your BMI is {bmi}, {catagory}')
                    self.dataBase.update_user((bmi,username))
                except ValueError:
                    break
                break
                
                
        
        
            except timeout:
                print('TIMEOUT')
                self.chatTClient('BYE')
                break
        

        self.connectionSocket.shutdown(SHUT_RDWR)
        self.connectionSocket.close()
        print(f'-- End connection from Server side--')

# ----------------------------- helper functions ----------------------------- #

def get_local_IP() -> str:
    hostName = gethostname()
    local_ip = gethostbyname(hostName)
    return local_ip
# ---------------------------------------------------------------------------- #


if __name__ == "__main__":

    # ------------------------- single connection server ------------------------- #
    server = TCPServer(22222)
    # ---------------------------------------------------------------------------- #

# ---------------------------------------------------------------------------- #
