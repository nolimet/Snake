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
	while(1){
		SystemAddress addresClient = peer->HasNewIncomingConnection();
		if(addresClient!=UNASSIGNED_SYSTEM_ADDRESS){
			std::cout << "[Client Connected]: "<<addresClient.ToString() <<std::endl;
			playersManager.AddPlayer(addresClient);
			SendPlayerList();
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
			SendPlayerList();
			printf("\n");
		}else{
			break;
		}
	}
	Connector::Loop();
}

void Server::ExecuteMessage(MessageType messageType,int messageLength,SystemAddress caller){
	
	int lenghtName;

	unsigned char* data;
	string dataStr;
	switch (messageType)
	{
	case MessageType::Ping:
		this->Connector::PingBack(pack->systemAddress);
		break;
	case MessageType::PLAYER_SET_NAME:
		//playersManager.
		data = pack->data;

		unsigned char byteNameLength[4];
		byteNameLength[0] = data[5];
		byteNameLength[1] = data[6];
		byteNameLength[2] = data[7];
		byteNameLength[3] = data[8];
		lenghtName = ByteConverter::UnsignedCharToInt(byteNameLength);

		
		dataStr = ByteConverter::UnsignedCharToStringAt(9,(pack->data),lenghtName);

		playersManager.SetPlayerName(dataStr,caller);
		SendPlayerList();
		break;
	default:
		break;
	}
	printf("\n");
}

void Server::SendPlayerList(){
	printf("-Send Player List-\n");
	
	int playerCount = playersManager.GetPlayerCount();
	int playerStringsLength = 0;
	for (int i = 0; i < playerCount; i++){
		string playerName = playersManager.GetPlayers()[i].getName();
		playerStringsLength+=playerName.length();
	}
	int messageL = 9+(playerCount*4)+playerStringsLength;

	std::vector<unsigned char> dataLenght = ByteConverter::IntToUnsignedCharArray(messageL);
	unsigned char *message = new unsigned char[messageL];
	
	message[0]=dataLenght.at(0);
	message[1]=dataLenght.at(1);
	message[2]=dataLenght.at(2);
	message[3]=dataLenght.at(3);
	
	message[4]=(int)(MessageType::PLAYER_LIST);

	std::vector<unsigned char> playerListLenght = ByteConverter::IntToUnsignedCharArray(playerCount);
	message[5]=playerListLenght.at(0);
	message[6]=playerListLenght.at(1);
	message[7]=playerListLenght.at(2);
	message[8]=playerListLenght.at(3);

	int messageID = 9;
	for(int i = 0;i < playerCount;i++){
		string playerName = playersManager.GetPlayers()[i].getName();
		int playerNameLenth = playerName.length();
		std::vector<unsigned char> nameLength = ByteConverter::IntToUnsignedCharArray(playerNameLenth);
		message[messageID]=nameLength.at(0);
		message[messageID+1]=nameLength.at(1);
		message[messageID+2]=nameLength.at(2);
		message[messageID+3]=nameLength.at(3);
		messageID+=4;
		unsigned char *nameInBytes = ByteConverter::StringToUnsignedChar(playerName);
		for(int j = 0;j < playerNameLenth;j++){
			message[messageID]=nameInBytes[j];
			messageID++;
		}
		delete [] nameInBytes;
	}
	printf("-messageID %d-\n",messageID);
	printf("-messageL %d-\n",messageL);
	peer->Send((const char *)message, messageL,"127.0.0.1",true);
}
