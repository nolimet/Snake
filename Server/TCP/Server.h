#pragma once
#include "Connector.h"
#include "PlayerManager.h"
#include "Player.h"
#include "Game.h"

class Server : public Connector
{
private:
	PlayerManager playersManager;
	Game *game;
public:
	Server(void);
	~Server(void);
	virtual void Init(ConSettings settings)override;
	virtual void Loop()override;
	virtual void ExecuteMessage(MessageType messageType,int messageLength,SystemAddress caller)override;
	void AddClient();
	void SendPlayerList();
};

