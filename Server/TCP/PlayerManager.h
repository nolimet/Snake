#pragma once
#include "Player.h"

class PlayerManager
{
private:
	Player *players;
	int playerCount;
public:
	PlayerManager(void);
	~PlayerManager(void);
	void AddPlayer(SystemAddress addres);
	void RemovePlayer(SystemAddress addres);
	void SetPlayerName(string name,SystemAddress addres);
	string GetPlayerName(SystemAddress addres);

	Player* GetPlayers ()const{return players;};
	int GetPlayerCount ()const{return playerCount;};
};

