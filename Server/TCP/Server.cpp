#include "Server.h"
#include "stdio.h"

Server::Server(void):Connector()
{
}


Server::~Server(void)
{
}

void Server::Init(){
	Connector::Init();
	printf("Server Started\n");
	peer->Start(SERVER_PORT,2);
	isServer = true;
}
