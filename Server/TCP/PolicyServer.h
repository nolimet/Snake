#pragma once
#include "connector.h"
#include "ByteConvert.h"
class PolicyServer :
	public Connector
{
private:
	SystemAddress addresPolicy;
public:
	PolicyServer(void);
	~PolicyServer(void);
	virtual void ProcessPack(Packet *pack);
	virtual void Init(int port);
	virtual void Loop();
};

