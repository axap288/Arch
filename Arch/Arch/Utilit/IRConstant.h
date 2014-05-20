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

#define APP_NAME [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleDisplayName"]

//========JSON中用到的KEY和VALUE===========
#define V_UID               [IRSysInfo getUDID]
#define V_SCREEN       [NSString stringWithFormat:@"%.f*%.f",[[UIScreen mainScreen]bounds].size.width,[[UIScreen mainScreen]bounds].size.height]
#define V_TS                    [AHAssistant getTimeStamp]
#define V_APPID             [[NSBundle mainBundle] bundleIdentifier]
#define V_MAC_HASH [IRSysInfo getMacWithMD5]
#define V_DEVICE_MODEL [IRSysInfo getDeviceModelID]
#define V_DEVICE_NAME   [IRSysInfo getDeviceName]
#define V_CPU @""
#define V_IMEI  [IRSysInfo getIMEI]
#define V_SDK_VER @""
#define V_NETWORK @""
#define V_COUNTRY [IRSysInfo getCountryCode]
#define V_OS_VER [IRSysInfo getSystemVersion]
#define V_ISCRACK [IRSysInfo isJailbroken]?@"YES":@"NO"
#define V_DD [IRAssistant getDateFormateYYMMDD]
#define V_TIMEZONE [[NSString alloc] initWithFormat:@"%d",[[NSTimeZone localTimeZone] secondsFromGMT]]
#define V_OS_NAME @"ios"
#define V_CARRIER [IRSysInfo getCarrierName]
#define V_PHONENUM @""
#define V_CHANNEL @""
#define V_APPKEY [IRConfigManager getConfigValue:@"appKey"]
#define V_COL1 [IRSysInfo getCFUUID]
#define V_COL2 [IRSysInfo getUUID]
#define V_COL3 [IRSysInfo getIDFA]
#define V_APP_VERSION [IRAssistant getBundleVesion]
#define V_iClickUSER_NAME [[NSUserDefaults standardUserDefaults] objectForKey:@"user"]
#define V_iClickUSER_MOBILENUMBER [[NSUserDefaults standardUserDefaults] objectForKey:@"mobileTele"]==nil?@"":[[NSUserDefaults standardUserDefaults] objectForKey:@"mobileTele"]
#define V_iClickUSER_SEX [[NSUserDefaults standardUserDefaults] objectForKey:@"sex"]==nil?@"":[[NSUserDefaults standardUserDefaults] objectForKey:@"sex"]
#define V_iClickUSER_BIRTHYEAR [[NSUserDefaults standardUserDefaults] objectForKey:@"birthYear"]==nil?@"":[[NSUserDefaults standardUserDefaults] objectForKey:@"birthYear"]
#define V_iClickUSER_ID [[NSUserDefaults standardUserDefaults] objectForKey:@"iclickUserId"]

#define V_SEND_TIME [[NSUserDefaults standardUserDefaults] objectForKey:@"lastSendTime"]==nil?@"":[[NSUserDefaults standardUserDefaults] objectForKey:@"lastSendTime"]
#define V_FIRST_SEND [[NSUserDefaults standardUserDefaults] objectForKey:@"firstSendTime"]



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
#define K_USER_NAME @"name"
#define K_USER_MOBILENUMBER @"mobile"
#define K_USER_SEX @"sex"
#define K_USER_BIRTHYEAR @"birthyear"


#define K_CLIENT @"client"
#define K_USER @"testuser"

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
#define NOTIFICATION_OF_SEND @"sendData" //手动发送通知
#define NOTIFICATION_OF_SEND_STATE @"sendState" //通知前端显示发送状态
#define NOTIFICATION_OF_SEND_END @"sendend" //通知前端显示发送结束

#define K_SEND_STATE @"key_SendState" 
#define V_SEND_STATE_BEGIN @"begin_Send"
#define V_SEND_STATE_END @"end_Send"








//======================================================


static const int ddLogLevel = LOG_LEVEL_VERBOSE;

//单线框按钮背景
#define ImageFile_Button_uniline_BG [UIImage imageNamed:@"IR_button_small.png"]
//单线框按钮背景（不可点击状态）
#define ImageFile_Button_uniline_Disable_BG [UIImage imageNamed:@"IR_button_small_disabled.png"]
////输入框背景
#define ImageFile_InputText_Bg_small [UIImage imageNamed:@"IR_text_bg_small.png"]

#define ImageFile_check_noSelect [UIImage imageNamed:@"checkbox_notselect.png"]
#define ImageFile_check_Select [UIImage imageNamed:@"checkbox_select.png"]



