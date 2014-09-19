#pragma once
#include "connector.h"
class PolicyServer :
	public Connector
{
private:
	SystemAddress addresPolicy;
public:
	PolicyServer(void);
	~PolicyServer(void);
	virtual void Init(int port);
	virtual void Loop();
};

