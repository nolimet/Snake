#pragma once

#define MAX_CLIENTS 10
#define SERVER_PORT 60000
#include "TCPInterface.h"

using namespace RakNet;

class Connector
{
private:
	void PingBack(RakNet::SystemAddress addres);
	void SendHello();
protected:
	TCPInterface *peer;
	bool isServer;
	Packet *pack;
public:
	Connector(void);
	~Connector(void);
	virtual void Init();
	void ProcessPack(Packet *pack);
	void Loop();
	void Close();
};

