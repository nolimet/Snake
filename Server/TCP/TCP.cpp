// TCP.cpp : Defines the entry point for the console application.
//
#include <stdio.h>
#include <conio.h>
#include "stdafx.h"
#include "Server.h"
#include "Client.h"
#include "Enums.h"

char str[512];
Connector* con;



void WaitForEnter(void) { 
	printf("Press Enter to continue: "); 
	//fflush(stdout); 
	while ( _getch()){
		int key = _getch();
		if(key == (int)KeyCode::Enter){
			printf("Enter Pressed \n");
			break;
		}
		//printf("key: %i \n",_getch());
	}
} 

int _tmain(int argc, _TCHAR* argv[])
{
	printf("(C)lient or (S)erver?\n");
	
	gets(str);
	if ((str[0]=='c')||(str[0]=='C')){
		con = new Client();
	} else {
		con = new Server();
	}
	con->Init();
	con->Loop();

	return 0;
}

