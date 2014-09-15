#pragma once

#define MAX_CLIENTS 10
#define SERVER_PORT 60000
#include "TCPInterface.h"

using namespace RakNet;

class Connector
{
protected:
	TCPInterface *peer;
	bool isServer;
public:
	enum class MessageCodes { Ping = 0, Print = 1, Echo = 2 };
	Connector(void);
	~Connector(void);
	virtual void Init();
	void Loop();
	void Close();
};

