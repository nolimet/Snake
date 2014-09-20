#pragma once

#define MAX_CLIENTS 10
//#define SERVER_PORT 60000
#include "TCPInterface.h"

using namespace RakNet;

class Connector
{
private:
	void PingBack(RakNet::SystemAddress addres);
	void SendHello();
	int serverPort;
protected:
	TCPInterface *peer;
	bool isServer;
	Packet *pack;
public:
	Connector(void);
	~Connector(void);
	virtual void Init(int port);
	virtual void ProcessPack(Packet *pack);
	virtual void Loop();
	virtual void Close();
	int getServerPort(){
		return serverPort;
	}
	bool getIsServer(){
		return isServer;
	}
};

