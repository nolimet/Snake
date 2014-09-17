#pragma once
#include <vector>
namespace ByteConverter{
	int UnsignedCharToInt(unsigned char* charArray){
		return charArray[0] +(charArray[1]<<010)+(charArray[2]<<020)+(charArray[3]<<030);
	}

	std::vector<unsigned char> IntToUnsignedCharArray(int Integer){
		std::vector<unsigned char> vec(4);
		vec[0] = (Integer >> 000) & 0xFF;
		vec[1] = (Integer >> 010) & 0xFF;
		vec[2] = (Integer >> 020) & 0xFF;
		vec[3] = (Integer >> 030) & 0xFF;
		return vec;
	}
}