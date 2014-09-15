#pragma once
#include "Connector.h"
class Server : public Connector
{
public:
	Server(void);
	~Server(void);
	virtual void Init();
};

