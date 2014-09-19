#include "PolicyServer.h"
#include "TCPInterface.h"
#include <iostream>

PolicyServer::PolicyServer(void)
{
}


PolicyServer::~PolicyServer(void)
{
}
void PolicyServer::Init(int port){
	Connector::Init(port);
	printf("Policy Server Started Port: %d\n",port);
}

void PolicyServer::Loop(){
	while(1){
		addresPolicy = peer->HasNewIncomingConnection();
		if(addresPolicy!=UNASSIGNED_SYSTEM_ADDRESS){
			std::cout << "[policy connected]: "<<addresPolicy.ToString() <<std::endl;
			peer->CloseConnection(addresPolicy);
		}else{
			break;
		}
	}
}
