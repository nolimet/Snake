#pragma once
#include "Player.h"

class PlayerManager
{
private:
	Player *players;
	unsigned int playerCount;
public:
	PlayerManager(void);
	~PlayerManager(void);
	void AddPlayer(SystemAddress addres);
	void RemovePlayer(SystemAddress addres);
	void SetPlayerName(string name,SystemAddress addres);
	string GetPlayerName(SystemAddress addres);
};

