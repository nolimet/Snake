#pragma once
#ifndef _BYTE_CONVERTER_H
#define _BYTE_CONVERTER_H



#include <vector>
#include <sstream>
#include <iomanip>
#include <vector>
//http://www.corsix.org/content/algorithmic-stdstring-creation

namespace ByteConverter{
	int UnsignedCharToInt(unsigned char* charArray);

	std::vector<unsigned char> IntToUnsignedCharArray(int Integer);

	std::string UnsignedCharToString(unsigned char* base, size_t len);

	unsigned char* StringToUnsignedChar(std::string str);
}

#endif