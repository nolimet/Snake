#include "Connector.h"
#include <stdio.h>

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
		//server loop
		RakNet::Packet*pack;
		while(1){
			pack = peer->Receive();
			if(pack!=0){
				printf("-process package-\n");
				printf("data Lenght: %u\n",pack->length);
				unsigned int dataLength = pack->length;
				printf("dataType: %i \n",pack->data[0]);
				printf("data: ");
				for(int i = 0;i<dataLength;i++){
					printf("%c",pack->data[i]);
				}
				printf("\n");
				printf("addres: %s\n",pack->systemAddress.ToString());
				peer->DeallocatePacket(pack);
			}else{
				break;
			}
		}
		//game loop
	}
}

void Connector::Close(){
	if(this->isServer){
		printf("Server Quit\n");
	}else{
		printf("Client Quit\n");
	}
	TCPInterface::DestroyInstance(this->peer);
}
