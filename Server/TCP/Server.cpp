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
	unsigned char* data;
	string dataStr;
	switch (messageType)
	{
	case MessageType::Ping:
		this->Connector::PingBack(pack->systemAddress);
		break;
	case MessageType::PLAYER_SET_NAME:
		data = pack->data;
		//read name Lenght
		int lenghtName;
		unsigned char byteNameLength[4];
		byteNameLength[0] = data[5];
		byteNameLength[1] = data[6];
		byteNameLength[2] = data[7];
		byteNameLength[3] = data[8];
		lenghtName = ByteConverter::UnsignedCharToInt(byteNameLength);
		//read name
		dataStr = ByteConverter::UnsignedCharToStringAt(9,(pack->data),lenghtName);
		//set name in player list
		playersManager.SetPlayerName(dataStr,caller);
		SendPlayerList();
		SendPlayerIsAdmin();
		break;
	case MessageType::PLAYER_SET_NEW_DIRECTION:

		break;
	case MessageType::PLAYER_READY:
		data = pack->data;
		if(data[5]==1){
			playersManager.SetPlayerReady(true,caller);
		}else if(data[5]==0){
			playersManager.SetPlayerReady(false,caller);
		}else{
			printf("[Error]PLAYER_READY WHY NO BOOL?");
		}
		break;
	case MessageType::ADMIN_START:
		game = new Game();
		SendGameStart();
		break;
	default:
		printf("[Error]recieved message type not found!!!\n");
		break;
	}
	printf("\n");
}

void Server::SendPlayerList(){
	printf("-Send Player List-\n");
	
	int playerCount = playersManager.GetPlayerCount();
	int playerStringsLength = 0;
	for (int i = 0; i < playerCount; i++){
		playerStringsLength += playersManager.GetPlayers()[i].getName().length();
	}
	int messageL = 9+(playerCount*5)+playerStringsLength;
	
	unsigned char *message = new unsigned char[messageL];
	ByteConverter::PushIntToUnsignedCharArray(message,0,messageL);
	
	message[4]=(int)(MessageType::PLAYER_LIST);
	ByteConverter::PushIntToUnsignedCharArray(message,5,playerCount);

	int currentMessageL = 9;
	for(int i = 0;i < playerCount;i++){
		message[currentMessageL] = playersManager.GetPlayers()[i].id();
		currentMessageL++;
		string playerName = playersManager.GetPlayers()[i].getName();
		printf("--Player: %u Name:%s -\n",message[currentMessageL-1],playerName.c_str());

		int playerNameLenth = playerName.length();
		ByteConverter::PushIntToUnsignedCharArray(message,currentMessageL,playerNameLenth);
		currentMessageL+=4;

		unsigned char *nameInBytes = ByteConverter::StringToUnsignedChar(playerName);
		for(int j = 0;j < playerNameLenth;j++){
			message[currentMessageL]=nameInBytes[j];
			currentMessageL++;
		}
		delete [] nameInBytes;
	}
	
	printf("-currentMessageL %d-\n",currentMessageL);
	printf("-messageL %d-\n",messageL);
	peer->Send((const char *)message, messageL,"127.0.0.1",true);
	delete [] message;
}


void Server::SendPlayerIsAdmin(void){
	printf("[--SendPlayerIsAdmin--]");
	unsigned char message[6];
	ByteConverter::PushIntToUnsignedCharArray(message,0,6);
	message[4]=(unsigned char)(MessageType::PLAYER_IS_ADMIN);
	message[5]=(playersManager.GetFirstUnUsedId());
	peer->Send((const char *)message, 6,"127.0.0.1",true);
	printf("\n");
}


void Server::SendPlayerPositioinList(void){
}


void Server::SendServerError(void){
}


void Server::SendGameStart(void){
	printf("[--SendGameStart--]");
	unsigned char message[5];
	ByteConverter::PushIntToUnsignedCharArray(message,0,5);
	message[4]=(unsigned char)(MessageType::GAME_START);
	peer->Send((const char *)message, 6,"127.0.0.1",true);
	printf("\n");
}


void Server::SendPlayerListUpdate(void){
}
