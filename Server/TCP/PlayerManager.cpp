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


void PlayerManager::AddPlayer(SystemAddress addres){
	printf("[--PlayerManager--]Add Player \n");
	Player newPlayer = Player("new Player",addres);
	
	string name;
	if(players == NULL){
		printf("[PlayerManager]First Player \n");
		players = new Player[1];
		players[0] = newPlayer;
		name = players[0].getName();
		cout << "[player: "<<name<<"] created"<<endl;
		cout << "[player: "<<name<<"] addres:"<<players[0].getAddres().ToString()<<endl;
		playerCount++;
	}else{
		printf("[PlayerManager]Add Player \n");
		Player *temp = players;
		players = new Player[playerCount+1];
		for(unsigned int i = 0;i<playerCount;++i){
			printf("[PlayerManager]copy: %d \n",i);
			players[i] =temp[i];
		}
		players[playerCount] = newPlayer;
		
		string name = (players[playerCount].getName());
		playerCount++;
		delete [] temp;
	}
	
	cout << "[player count]:"<<playerCount<<name<<endl;
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