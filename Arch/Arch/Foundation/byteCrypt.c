//
//  byteCrypt.c
//  ArchTracker
//
//  Created by LiuNian on 14-5-20.
//
//

#include <stdio.h>
#include "byteCrypt.h"


char* cryptData(char* data)
{
    size_t length = sizeof(data);
    
    char * byteData = malloc(length+1);
    bzero(byteData, sizeof(byteData));
    memcpy(byteData,data,length+1);
    
    char *byteResult = malloc(length+1);
    bzero(byteResult, sizeof(byteResult));
    
    
    for(int i = 0; i < length; i ++)
    {
        unsigned char c = byteData[i];
        unsigned char newchar = reverse8(c);
        byteResult[i] = newchar;
    }
    
//    NSData *resutData = [NSData dataWithBytes:byteResult length:length];
    free(byteData);
    free(byteResult);
    return byteResult;

}

unsigned char reverse8( unsigned char c )
{
    c = ( c & 0x55 ) << 1 | ( c & 0xAA ) >> 1;
    c = ( c & 0x33 ) << 2 | ( c & 0xCC ) >> 2;
    c = ( c & 0x0F ) << 4 | ( c & 0xF0 ) >> 4;
    return c;
}

