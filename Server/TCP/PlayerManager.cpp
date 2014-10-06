#include "PlayerManager.h"
#include <iostream>
#include <string>
#include "TCPInterface.h"

using std::cout;
using std::endl;
using std::string;

//Player *players;
//unsigned int playerCount;

PlayerManager::PlayerManager(void)
{
	playerCount = 0;
}


PlayerManager::~PlayerManager(void)
{
}

Player PlayerManager::GetPlayer(SystemAddress addres){
	for(unsigned int i = 0;i<playerCount;i++){
		if(players[i].getAddres()==addres){
			return (players[i]);
		}
	}
}
string PlayerManager::GetPlayerName(SystemAddress addres){
	return GetPlayer(addres).getName();
}

void PlayerManager::SetPlayerName(string name,SystemAddress addres){
	GetPlayer(addres).setName(name);
}

void PlayerManager::SetPlayerReady(bool ready,SystemAddress addres){
	GetPlayer(addres).ready(ready);
}

unsigned char PlayerManager::GetPlayerId(SystemAddress addres){
	return GetPlayer(addres).id();
}
void PlayerManager::SetPlayerId(unsigned char id,SystemAddress addres){
	GetPlayer(addres).id(id);
}

bool PlayerManager::GetPlayerReady(SystemAddress addres){
	return GetPlayer(addres).ready();
}

bool PlayerManager::GetPlayersReady(){
	for(unsigned int i = 0;i<playerCount;i++){
		if(!players[i].ready()){
			return false;
		}
	}
	return true;
}

unsigned char PlayerManager::GetFirstUnUsedId(){
	for(unsigned char i = 0;i<256;i++){
		bool idFound = false;
		for(unsigned int j = 0;j<playerCount;j++){
			if(players[j].id()==i){
				break;
			}
			idFound = true;
		}
		if(idFound){
			printf( "[GetFirstUnUsedId] id: %u \n",i);
			return i;
			break;
		}
	}
}

void PlayerManager::AddPlayer(SystemAddress addres){
	printf("[--PlayerManager--]Add Player \n");
	Player newPlayer = Player("new Player",addres);
	
	if(players == NULL){
		printf("[PlayerManager]First Player \n");
		players = new Player[1];
		players[0] = newPlayer;
		playerCount++;
	}else{
		printf("[PlayerManager]Add Player \n");
		Player *temp = players;
		players = new Player[playerCount+1];
		for(unsigned int i = 0;i<playerCount;++i){
			players[i] =temp[i];
		}
		players[playerCount] = newPlayer;
		playerCount++;
		delete [] temp;
	}
	players[playerCount-1].id(GetFirstUnUsedId());
	cout << "[new player] created addres:"<<players[playerCount-1].getAddres().ToString()<<endl;
	printf( "[new player] created id: %u \n",players[playerCount-1].id());
	cout << "[new player] count	:"<<playerCount<<endl;
}

void PlayerManager::RemovePlayer(SystemAddress addres){
	printf("[--PlayerManager--]Remove Player \n");
	if(playerCount>1){
		Player *temp = players;
		players = new Player[playerCount-1];
		//pl[0] = new Player("Player",RakNet::UNASSIGNED_SYSTEM_ADDRESS);
		bool restmin = false;
		for(unsigned int i = 0;i<playerCount;i++){
			if(temp[i].getAddres()==addres){
				restmin = true;
			}else{
				if(!restmin){
					players[i] =temp[i];
				}else{
					players[i-1] =temp[i];
				}
			}
		}
		//string name = (players[playerCount].getName());
		playerCount--;
		delete [] temp;
	}else if(playerCount==1){
		delete [] players;
		playerCount--;
		players = NULL;

	}else{
		printf("[PlayerManager]NO PLAYER TO REMOVE!!!!!!! \n");
	}
}