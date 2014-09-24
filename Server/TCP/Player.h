#pragma once
#include <iostream>
#include "TCPInterface.h"
using std::string;
using RakNet::SystemAddress;
class Player
{
private:
	string name_;
	SystemAddress addres_;
public:
	Player(string name = "new Player",SystemAddress addres = RakNet::UNASSIGNED_SYSTEM_ADDRESS);
	~Player(void);
	string getName() const;
	SystemAddress getAddres() const;
};

