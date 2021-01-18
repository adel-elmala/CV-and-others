from socket import socket, AF_INET, SOCK_STREAM, SHUT_RDWR, SOCK_DGRAM
from TCPServer import get_local_IP
import sys
import hashlib


class TCPClient():
    def __init__(self, serverIp, serverPort):
        # create a tcp socket
        self.clientSocket = None
        print(f'--- Created socket ---')

        self.initConnection(serverIp, serverPort)
        # self.chatTServer(messageToSend)
        # self.chatFServer()
        self.chatLoop()
        sys.exit()

    def initConnection(self, serverIp, serverPort):
        self.clientSocket = socket(AF_INET, SOCK_STREAM)
        # initiate three-way tcp handshake with the server
        self.clientSocket.connect((serverIp, serverPort))
        print(f'Connected to server: {(serverIp,serverPort)}')

    def chatTServer(self, messageToSend: str):

        self.clientSocket.sendall(messageToSend.encode())
        # print(f'Sent: {messageToSend}\n')

    def chatFServer(self):

        message = self.clientSocket.recv(1024).decode()
        print(f'server says: {message}\n')

        return message

    def chatLoop(self):
            inputMsg = ' '
            rcvdMsg = ' '
            stillOn = True
            
            rcvdMsg = self.chatFServer()  # greetings from server and request credentials
            while stillOn:
                # if rcvdMsg.upper().strip() == 'BYE':
                #     break
                inputMsg = str(input('username,password: '))
                # TODO : hash the password then send it
                if (inputMsg.upper().strip() == 'EXIT'):
                    self.chatTServer(inputMsg) # send bye msg to notify the server to close it's side of the connection
                    stillOn = False
                    break
                username,password = inputMsg.strip().split(',')
                hashedPassword = hashlib.sha256()
                hashedPassword.update(password.encode())
                self.chatTServer(f'{username},{hashedPassword.hexdigest()}') # send credentials

                statFlag,oldBmi = self.chatFServer().strip().split(':') #check credentials from server
                if (statFlag.lower().strip() == 'success') or (statFlag.lower().strip() == 'new'):
                    # self.chatFServer() # requesting weight and height
                    self.chatTServer(str(input("Weight,Height: "))) # send them
                    self.chatFServer() # get back the BMI
                    stillOn = False
                else:
                    #TODO: repeat 
                    # ::DONE::
                    print('TRY AGAIN...\n')
                    

            self.clientSocket.shutdown(SHUT_RDWR)        
            self.clientSocket.close()        
            print(f'-- End connection from client Side --')


if __name__ == "__main__":

    # assuming server is on same machine of client ,this function gets the default local  IPv4 Address for any machine.
    serverIp = get_local_IP()
    serverPort = 22222

    client = TCPClient(serverIp, serverPort)
