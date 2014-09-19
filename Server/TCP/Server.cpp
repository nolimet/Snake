#include "Server.h"
#include "stdio.h"

Server::Server(void):Connector()
{
}


Server::~Server(void)
{
}

void Server::Init(int port){
	Connector::Init(port);
	printf("Server Started Port: %d\n",port);
	peer->Start(getServerPort(),2);
	isServer = true;
}
