#include "Server.h"
#include "stdio.h"
#include <iostream>
#include "TCPInterface.h"
#include <string>
#include "Enums.h"
#include <vector>
#include "ByteConvert.h"


using std::cout;
using std::endl;
using std::string;



Server::Server(void):Connector()
{
}

Server::~Server(void)
{
}

void Server::Init(ConSettings settings){
	Connector::Init(settings);
	printf("Server Started Port: %d\n",settings.port);
	peer->Start(getServerPort(),settings.maxPlayers);
	isServer = true;
}


void Server::Loop(){
	Connector::Loop();
	while(1){
		SystemAddress addresClient = peer->HasNewIncomingConnection();
		if(addresClient!=UNASSIGNED_SYSTEM_ADDRESS){
			std::cout << "[Client Connected]: "<<addresClient.ToString() <<std::endl;
			playersManager.AddPlayer(addresClient);
			printf("\n");
		}else{
			break;
		}
	}
	while(1){
		SystemAddress addresClient = peer->HasLostConnection();
		if(addresClient!=UNASSIGNED_SYSTEM_ADDRESS){
			std::cout << "[Client DisConnected]: "<<addresClient.ToString() <<std::endl;
			playersManager.RemovePlayer(addresClient);
			printf("\n");
		}else{
			break;
		}
	}
}

void Server::ExecuteMessage(MessageType messageType,SystemAddress caller){
	switch (messageType)
	{
	case MessageType::Ping:
		this->Connector::PingBack(pack->systemAddress);
		break;
	case MessageType::PLAYER_SET_NAME:
		//playersManager.
		SendPlayerList();
		break;
	default:
		break;
	}
	printf("\n");
}

void Server::SendPlayerList(){
	printf("-Send Player List-\n");
	

	string str = "Kit";
	int strL = str.length();
	int messageL = 9+strL;
	std::vector<unsigned char> dataLenght = ByteConverter::IntToUnsignedCharArray(5);
	unsigned char *message = new unsigned char[5+strL];
	unsigned char *send = ByteConverter::StringToUnsignedChar(str);
	message[0]=dataLenght.at(0);
	message[1]=dataLenght.at(1);
	message[2]=dataLenght.at(2);
	message[3]=dataLenght.at(3);
	
	message[4]=(int)(MessageType::PLAYER_LIST);

	std::vector<unsigned char> nameLenght = ByteConverter::IntToUnsignedCharArray(strL);
	message[5]=nameLenght.at(0);
	message[6]=nameLenght.at(1);
	message[7]=nameLenght.at(2);
	message[8]=nameLenght.at(3);

	for(int i = 0;i < strL;i++){
		printf("-ADDDD %d-\n",i);
		message[9+i]=send[i];
	}
	peer->Send((const char *)message, messageL,"127.0.0.1",true);
}
