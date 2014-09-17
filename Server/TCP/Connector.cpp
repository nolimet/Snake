#include "Connector.h"
#include <stdio.h>
#include "RakSleep.h"
#include "Enums.h"
#include "ByteConvert.h"
#include <vector>

Connector::Connector(void)
{
}

Connector::~Connector(void)
{
}

void Connector::Init(){
	peer = TCPInterface::GetInstance();
}
void Connector::Loop(){
	while(1){
		//recieve loop
		while(1){
			pack = peer->Receive();
			if(pack!=0){
				ProcessPack(pack);
				peer->DeallocatePacket(pack);
			}else{
				break;
			}
		}
		RakSleep(20);
		//game loop
		//send loop
		//this->SendHello();
	}
}

void Connector::ProcessPack(RakNet::Packet *pack){
	printf("-process package-\n");
	//printf("data Lenght: %u\n",pack->length);
	unsigned int dataLength = pack->length;
	//printf("dataType: %i \n",pack->data[0]);
	printf("data: ");
	unsigned char* data = pack->data;
	//for(int i = 0;i<dataLength;i++){
	//	printf("%c",pack->data[i]);
	//}
	int lenghtMessage = data[0] +(data[1]<<010)+(data[2]<<020)+(data[3]<<030);
	unsigned char byteMessageLength[4];
	byteMessageLength[0] = data[0];
	byteMessageLength[1] = data[1];
	byteMessageLength[2] = data[2];
	byteMessageLength[3] = data[3];
	lenghtMessage = ByteConverter::UnsignedCharToInt(byteMessageLength);
	MessageType messageType = (MessageType)data[4];
	printf("Length Message: %i\n", lenghtMessage);
	printf("Length Data   : %i\n", dataLength);
	printf("MessageType   : %i\n", data[4]);
	printf("addres: %s\n",pack->systemAddress.ToString());

	switch (messageType)
	{
	case MessageType::Ping:
		this->PingBack(pack->systemAddress);
		break;
	default:
		break;
	}
}

void Connector::PingBack(SystemAddress addres){
	printf("-ping back-\n");
	std::vector<unsigned char> dataLenght = ByteConverter::IntToUnsignedCharArray(5);
	unsigned char hello[5];
	hello[0]=dataLenght.at(0);
	hello[1]=dataLenght.at(1);
	hello[2]=dataLenght.at(2);
	hello[3]=dataLenght.at(3);
	hello[4]=(int)(MessageType::PingBack);

	peer->Send((const char *)hello, 5,addres,false);
}

void Connector::SendHello(){
	//printf("-Send hello-\n");
	std::vector<unsigned char> dataLenght = ByteConverter::IntToUnsignedCharArray(5);
	unsigned char hello[5];
	hello[0]=dataLenght.at(0);
	hello[1]=dataLenght.at(1);
	hello[2]=dataLenght.at(2);
	hello[3]=dataLenght.at(3);
	hello[4]=(int)(MessageType::Hello);

	peer->Send((const char *)hello, 5,"127.0.0.1",true);
}

void Connector::Close(){
	if(this->isServer){
		printf("Server Quit\n");
	}else{
		printf("Client Quit\n");
	}
	TCPInterface::DestroyInstance(this->peer);
}
