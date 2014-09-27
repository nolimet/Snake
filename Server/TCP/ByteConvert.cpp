#include "ByteConvert.h"


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

	std::string UnsignedCharToString(unsigned char* base, int len){
		std::string ss;
		for(int i = 0; i < len; ++i){
			ss +=base[i];
		}
		return ss;
	}

	unsigned char* StringToUnsignedChar(std::string str){
		/*
		const char *conststr  = str.c_str();
		unsigned char *conststr2  = (unsigned char*)conststr;
		*/
		char * cstr = new char [str.length()+1];
		std::strcpy (cstr, str.c_str());
		unsigned char *conststr2  = (unsigned char*)cstr;
		//delete [] cstr;
		return conststr2;
	}
	
	std::string UnsignedCharToStringAt(int at,unsigned char* base, int len){
		std::string ss;
		for(size_t i = at; i < (at+len); ++i){
			ss +=base[i];
		}
		return ss;
	}
}