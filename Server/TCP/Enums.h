#pragma once

enum class MessageType { 
	Ping = 20, 
	PingBack = 21, 
	Hello = 22, 
	PLAYER_SET_NAME = 30, 
	PLAYER_SET_NEW_DIRECTION = 31,
	PLAYER_LIST = 100,
	PLAYER_DIRECTION_LIST = 101
};
enum class KeyCode { Enter = 13, S = 115, C = 99 };