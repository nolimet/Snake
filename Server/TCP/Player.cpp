#include "Player.h"
#include <iostream>
#include <string>
using std::cout;
using std::endl;
using std::string;


Player::Player(string name,SystemAddress addres){
	name_ = name; 
	addres_ = addres;
	cout<<"[Player] Created: "<< name_ <<endl;
}
Player::~Player(void){
	cout<<"[Player] Destroyed: "<<name_<<endl;
}
string Player::getName() const{
	return name_;
}

void Player::setName(string name){
	name_ = name;
}

SystemAddress Player::getAddres() const{
	return addres_;
}

