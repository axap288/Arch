//
//  IRConfigManager.h
//  iRDataCollectorForEnterprise
//
//  Created by LiuNian on 13-12-3.
//  Copyright (c) 2013年 LiuNian. All rights reserved.
//

#define NOTIFICATION_NAME_changeSendFileIntervalTime @"changeSendFileIntervalTimeNotification" //更改发送间隔时间通知
#define NOTIFICATION_NAME_changeAppKey @"changeAppKeyNotification"  //更改APPKEY通知
#define NOTIFICATION_NAME_changeconfigurl @"changeConfigurlNotification"    //更改配置文件ＵＲＬ通知
#define NOTIFICATION_NAME_changePostURL @"changePostURLNotification" //更改发送文件URL通知
#define NOTIFICATION_NAME_changeOnlyWifi @"changeOnlyWifiNotification" //是否wifi使用通知
#define NOTIFICATION_NAME_changeFlowRate @"changeFlowRateNotification" //是否关闭流量监测通知
#define NOTIFICATION_NAME_changeApplication @"changeApplicationNotification" //是否关闭应用监测通知
#define NOTIFICATION_NAME_changeCloseSend @"changeCloseSendNotification" //是否关闭发送通知

typedef enum {
    ApplicationSwitch ,             /// app监测开关
	LocationSwich,               /// 地理位置开关
	FlowRateSwitch,    /// 流量开关
    RecordLogSwitch,  //日志记录开关
    WIFIOnlySendSwitch,//仅用wifi开关
    TestSwitch,//测试开关
    CloseSendSwitch//关闭发送开关
} switchItem;



@interface AHConfigManager : NSObject

+(void)updateConfigFromServer;

//取值
+(NSString *)getConfigValue:(NSString *)key;

//取开关值
+(BOOL)switchValue:(switchItem)item;

+(void)copyPlistToDocument;

+(void)saveConfigKey:(NSString *)key value:(NSString *)value;



@end
