//
//  IRConstant.h
//  iRDataCollectorForAppStore
//
//  Created by LN on 13-9-17.
//  Copyright (c) 2013年 LN. All rights reserved.
//
#import "AHsysMonitor.h"
#import "AHSysInfo.h"
#import "AHFileTool.h"
#import "AHAssistant.h"
#import "AHConfigManager.h"

#import "DDLog.h"
#import "DDTTYLogger.h"

//========JSON中用到的KEY和VALUE===========
#define V_UID               [AHSysInfo getUDID]
#define V_SCREEN       [NSString stringWithFormat:@"%.f*%.f",[[UIScreen mainScreen]bounds].size.width,[[UIScreen mainScreen]bounds].size.height]
#define V_TS                    [AHSysInfo getUnixTimeStamp:[NSDate date]]
#define V_APPID             [[NSBundle mainBundle] bundleIdentifier]
#define V_MAC_HASH [AHSysInfo getMacWithMD5]
#define V_DEVICE_MODEL [[UIDevice currentDevice] model]
#define V_DEVICE_NAME   [AHSysInfo getDeviceName]
#define V_CPU @""
#define V_IMEI  @""
#define V_SDK_VER @""
#define V_NETWORK @""
#define V_COUNTRY [AHSysInfo getCountryCode]
#define V_OS_VER [AHSysInfo getSystemVersion]
#define V_ISCRACK [AHSysInfo isJailbroken]?@"YES":@"NO"
#define V_DD [IRAssistant getDateFormateYYMMDD]
#define V_TIMEZONE [[NSString alloc] initWithFormat:@"%d",[[NSTimeZone localTimeZone] secondsFromGMT]]
#define V_OS_NAME @"ios"
#define V_CARRIER [AHSysInfo getCarrierName]
#define V_PHONENUM @""
#define V_CHANNEL @""
#define V_APPKEY [IRConfigManager getConfigValue:@"appKey"]
#define V_COL1 [AHSysInfo getCFUUID]
#define V_COL2 [AHSysInfo getUUID]
#define V_COL3 [AHSysInfo getIDFA]


#define K_UID @"uid"
#define K_SCREEN @"screen"
#define K_TS @"ts"
#define K_OS_VER @"os_ver"
#define K_APPID @"appid"
#define K_APPNAME @"app_name"
#define K_APPVER @"appver"
#define K_IMEI @"imei"
#define K_SDK_VER @"sdk_ver"
#define K_NETWORK @"network"
#define  K_COUNTRY @"country"
#define K_ISCRACK @"iscrack"
#define  K_DEVICE_MODEL @"device_model"
#define K_DD @"dd"
#define K_TIMEZONE @"timezone"
#define K_MAC_HASH @"mac_hash"
#define K_DEVICE_NAME @"device_name"
#define K_OS_NAME @"os_name"
#define K_CARRIER @"carrier"
#define K_PHONENUM @"phonenum"
#define K_CHANNEL @"channel"
#define K_APPKEY @"appkey"
#define K_CPU @"cpu"
#define K_IP @"ip"
#define K_APPKEY @"appkey"
#define K_COL1 @"col1"
#define K_COL2 @"col2"
#define K_COL3 @"col3"

#define K_CLIENT @"client"

#define K_RADIUS @"radius"
#define K_latitude @"lng"
#define K_CITY @"city"
#define K_DISTRICT @"district"

#define K_SESSION @"session"

#define K_LOCATION @"location"

#define K_DEVICE_FLOW @"device_flow"

//======================================================
//数据发送运行间隔
#define P_SendFileInterval @"SendFile_Interval_Time"
#define P_postUrl @"postURL"
//数据发送服务器地址
#define P_sendHour @"sendDataHour"
//更新通知URL
#define P_update_url @"updateURL"
//定位服务运行间隔
#define P_LocationServiceinterval @"locationServiceInterval"

//======================================================

#define  NOTIFICATION_OF_CLOSEBAIDULOCATIONSERVICE   @"closeBaiduLocationService"
#define  NOTIFICATION_OF_RESTARTBAIDULOCATIONSERVICE @"restartBaiduLocationService"
#define  NOTIFICATION_OF_GOTPACKETTODO @"GotPacketToDo"
#define NOTIFICATION_OF_LOCKED_STATE @"lockedState"
#define NOTIFICATION_OF_END_LOCKED_STATE @"endLockedState"

//======================================================


static const int ddLogLevel = LOG_LEVEL_VERBOSE;



