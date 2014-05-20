//
//  IRSysInfo.h
//  iRDataCollectorForAppStore
//
//  Created by LN on 13-9-18.
//  Copyright (c) 2013年 LN. All rights reserved.
//

#include <arpa/inet.h>
#include <ifaddrs.h>

#import <sys/socket.h>
#import <sys/sysctl.h>
#import <net/if.h>
#import <net/if_dl.h>
#import <sys/utsname.h>
#include <ifaddrs.h>
#include <arpa/inet.h>
#import <CommonCrypto/CommonDigest.h>

typedef enum {
    NETWORK_TYPE_NONE= 0,
    NETWORK_TYPE_WIFI= 1,
    NETWORK_TYPE_3G= 2,
    NETWORK_TYPE_2G= 3,
}NETWORK_TYPE;

#define SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(v)  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedAscending)


@interface AHSysInfo : NSObject

+(BOOL)isJailbroken; //YES:Jailbroken
//UDID
+(NSString *)getUDID;
//设备名称
+(NSString *)getDeviceName;
//设备序列号
+(NSString *)getDeviceSerial;
//用户名
+(NSString *)getUserName;
//系统版本
+(NSString *)getSystemVersion;
//wifi发送流量
+(NSString *)getWifiSendTraffic;
//wifi接收流量
+(NSString *)getWifiReviceTraffic;
//移动发送流量
+(NSString *)getMobileSendTraffic;
//移动接收流量
+(NSString *)getMobileReviceTraffic;
//
+(NSString *)getMacWithMD5;

+ (NSArray *)getDataCounters;

+(NSString *)getMacAddress:(BOOL)useSemicolon;

//获取运营商名称
+(NSString *)getCarrierName;

+(NSString *)getCountryCode;
//unix时间戳
+(NSString *)getUnixTimeStamp:(NSDate *)date;


//显示电池电量
//+ (double) batteryLevel;

+(NSString *)getCFUUID;

+(NSString *)getUUID;

+(NSString *)getIDFA;

+ (NETWORK_TYPE)dataNetworkTypeFromStatusBar;


@end
