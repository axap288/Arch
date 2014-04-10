//
//  IRConfigManager.m
//  iRDataCollectorForEnterprise
//
//  Created by LiuNian on 13-12-3.
//  Copyright (c) 2013年 LiuNian. All rights reserved.
//

#import "IRConfigManager.h"
#import  "IRAssistant.h"
//#import  "SBJson.h"
#import "IRConstant.h"




@implementation IRConfigManager

+ (void)updateConfigFromServer
{
    NSString *url = [IRConfigManager getConfigValue:@"configurl"];
    NSString *appkey = [IRConfigManager getConfigValue:@"appKey"];
    NSString *fullUrl = [NSString stringWithFormat:@"%@?appkey=%@",url,appkey];
    NSString *result =  [IRAssistant serverRequest:fullUrl];
    NSMutableArray *notificationNames = [NSMutableArray array];
    if (result) {
        if (![result isEqualToString:@"error"]) {
            BOOL needUpdate = NO;
//            SBJsonParser * parser = [[SBJsonParser alloc] init];
            NSData *data  = [result dataUsingEncoding:NSUTF8StringEncoding];
             NSMutableDictionary *jsonDic = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
            NSError * error = nil;
//            NSMutableDictionary *jsonDic = [parser objectWithString:result error:&error];
            NSString *appkey = [jsonDic objectForKey:@"appkey"];
            NSString *configurl = [jsonDic objectForKey:@"configurl"];
            NSString *sendinterval = [jsonDic objectForKey:@"sendinterval"];
            NSString *sendzipurl = [jsonDic objectForKey:@"trackerdataurl"];
            NSString *onlywifisend = [jsonDic objectForKey:@"onlywifisend"];
            NSString *closeSend = [jsonDic objectForKey:@"androidbrowserhistory"];//关闭数据发送开关
//            NSString *inputmethod = [jsonDic objectForKey:@"inputmethod"];
            NSString *flow = [jsonDic objectForKey:@"flow"];
//            NSString *clientinfo = [jsonDic objectForKey:@"clientinfo"];
            NSString *application = [jsonDic objectForKey:@"application"];
            NSString *lockStateStepInterval = [jsonDic objectForKey:@"myselfinstall"]; //锁屏状态下的步长时间
            NSString *donwloadUrl = [jsonDic objectForKey:@"ourl"];//客户端下载URL
            
//            NSString *plistPath = [[NSBundle mainBundle] pathForResource:PROPERTY_FILE ofType:@"plist"];
//            NSDictionary *temp = [[NSDictionary alloc] initWithContentsOfFile:plistPath];
            NSString *plistPath = [IRFileTool getFullPath:PROPERTY_FILE];
            NSMutableDictionary *dictionary = [NSMutableDictionary dictionaryWithContentsOfFile:plistPath];
            
            if (sendinterval != nil &&  ![[dictionary objectForKey:@"SendFile_Interval_Time"] isEqualToString:sendinterval] ) {
                [dictionary setValue:sendinterval forKey:@"SendFile_Interval_Time"];
                needUpdate = YES;
//                notificationName = NOTIFICATION_NAME_changeSendFileIntervalTime;
                [notificationNames addObject:NOTIFICATION_NAME_changeSendFileIntervalTime];
               DDLogInfo(@"[系统配置]:参数值SendFile_Interval_Time已变更为:%@",sendinterval);
            }
            
            if (appkey != nil && ![[dictionary objectForKey:@"appKey"] isEqualToString:appkey] ) {
                [dictionary setValue:appkey forKey:@"appKey"];
                needUpdate = YES;
//                notificationName = NOTIFICATION_NAME_changeAppKey;
                [notificationNames addObject:NOTIFICATION_NAME_changeAppKey];
               DDLogInfo(@"[系统配置]:参数值appKey已变更为:%@",appkey);
            }
            
            if (configurl != nil && ![[dictionary objectForKey:@"configurl"] isEqualToString:configurl]) {
                [dictionary setValue:configurl forKey:@"configurl"];
                needUpdate = YES;
                [notificationNames addObject:NOTIFICATION_NAME_changeconfigurl];
               DDLogInfo(@"[系统配置]:参数值configurl已变更为:%@",configurl);
            }
            
            if (sendzipurl != nil && ![[dictionary objectForKey:@"postURL"] isEqualToString:sendzipurl]) {
                [dictionary setValue:sendzipurl forKey:@"postURL"];
                needUpdate = YES;
                [notificationNames addObject:NOTIFICATION_NAME_changePostURL];
               DDLogInfo(@"[系统配置]:参数值sendzipurl已变更为:%@",sendzipurl);
            }
            if (onlywifisend != nil && ![[dictionary objectForKey:@"onlywifisend"] isEqualToString:onlywifisend]) {
                [dictionary setValue:onlywifisend forKey:@"onlywifisend"];
                needUpdate = YES;
                [notificationNames addObject:NOTIFICATION_NAME_changeOnlyWifi];
               DDLogInfo(@"[系统配置]:参数值onlywifisend已变更为:%@",onlywifisend);
            }
            if (flow != nil && ![[dictionary objectForKey:@"flowRate_switch"] isEqualToString:flow]) {
                [dictionary setValue:flow forKey:@"flowRate_switch"];
                needUpdate = YES;
                [notificationNames addObject:NOTIFICATION_NAME_changeFlowRate];
               DDLogInfo(@"[系统配置]:参数值flowRate_switch已变更为:%@",flow);
            }
            if (application !=nil && ![[dictionary objectForKey:@"application_switch"] isEqualToString:application]) {
                [dictionary setValue:application forKey:@"application_switch"];
                needUpdate = YES;
                [notificationNames addObject:NOTIFICATION_NAME_changeApplication];
               DDLogInfo(@"[系统配置]:参数值application_switch已变更为:%@",application);
            }
            if (closeSend !=nil && ![[dictionary objectForKey:@"closeSend_swith"] isEqualToString:closeSend]) {
                [dictionary setValue:closeSend forKey:@"closeSend_swith"];
                needUpdate = YES;
                [notificationNames addObject:NOTIFICATION_NAME_changeCloseSend];
               DDLogInfo(@"[系统配置]:参数值closeSend_swith已变更为:%@",closeSend);
            }
            
            if (donwloadUrl !=nil && ![[dictionary objectForKey:@"updateURL"] isEqualToString:donwloadUrl]) {
                [dictionary setValue:donwloadUrl forKey:@"updateURL"];
                needUpdate = YES;
//                [notificationNames addObject:NOTIFICATION_NAME_changeCloseSend];
               DDLogInfo(@"[系统配置]:参数值updateURL已变更为:%@",donwloadUrl);
            }
            
            if (lockStateStepInterval !=nil && ![[dictionary objectForKey:@"lockStateStepInterval"] isEqualToString:lockStateStepInterval]) {
                [dictionary setValue:lockStateStepInterval forKey:@"lockStateStepInterval"];
                needUpdate = YES;
               DDLogInfo(@"[系统配置]:参数值lockStateStepInterval已变更为:%@",lockStateStepInterval);
            }

            
            if (needUpdate) {
                BOOL flag = [dictionary writeToFile:plistPath atomically:NO];
                if (flag) {
                   DDLogInfo(@"[系统配置]:已更新配置文件!");
                    for (NSString * notificationName in notificationNames) {
                        [[NSNotificationCenter defaultCenter] postNotificationName:notificationName object:nil];
                    }
                }else{
                   DDLogInfo(@"[系统配置]:更新失败!");
                }
            }

//           DDLogInfo(@"%@",appkey);
//           DDLogInfo(@"%@",configurl);
//           DDLogInfo(@"%@",onlywifisend);
//           DDLogInfo(@"%@",notification);
//           DDLogInfo(@"%@",inputmethod);
//           DDLogInfo(@"%@",flow);
//           DDLogInfo(@"%@",clientinfo);
//           DDLogInfo(@"%@",application);
        }
    }
}

//取值
+(NSString *)getConfigValue:(NSString *)key
{
//    NSString *plistPath = [[NSBundle mainBundle] pathForResource:PROPERTY_FILE ofType:@"plist"];
    NSString *plistPath = [IRFileTool getFullPath:PROPERTY_FILE];
    NSDictionary *dictionary = [[NSDictionary alloc] initWithContentsOfFile:plistPath];
    return [dictionary objectForKey:key];
}

//本地存储值
+(void)saveConfigKey:(NSString *)key value:(NSString *)value
{
    if (key == nil || value == nil) {
       DDLogInfo(@"[系统配置]:更新失败!发现有NULL值");
        return;
    }
    
    NSString *plistPath = [IRFileTool getFullPath:PROPERTY_FILE];
    NSMutableDictionary *dictionary = [NSMutableDictionary dictionaryWithContentsOfFile:plistPath];
    [dictionary setValue:value forKey:key];
    [dictionary writeToFile:plistPath atomically:NO];
}

+(void)copyPlistToDocument
{
    NSString *bundlePath =  [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent: @"IRDataCollectorLib.bundle"];
    NSBundle *bundle = [NSBundle bundleWithPath: bundlePath];
    NSString *plistPath = [bundle pathForResource:@"IRProperty" ofType:@"plist"];
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *toPath =  [documentsDirectory stringByAppendingPathComponent:PROPERTY_FILE];
    
    BOOL success = NO;
    NSError *error;
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if (![fileManager fileExistsAtPath:toPath]) {
        success = [fileManager copyItemAtPath:plistPath toPath:toPath error:&error];
        if (!success) {
           DDLogInfo(@"[系统配置]:配置文件初始化失败!:%@",error);
        }else{
           DDLogInfo(@"[系统配置]:配置文件初始化成功!");

        }
    }

    
}

//取开关值
+(BOOL)switchValue:(switchItem)item
{
    NSString *key = nil;
    switch (item) {
        case ApplicationSwitch:
        {
            key = @"application_switch";
        }
            break;
        case LocationSwich:
        {
            key = @"location_switch";
        }
            break;
        case FlowRateSwitch:
        {
            key = @"flowRate_switch";
        }
            break;
        case RecordLogSwitch:
        {
            key = @"log_swith";
        }
            break;
        case WIFIOnlySendSwitch:
        {
            key = @"onlywifisend";
        }
            break;
        case TestSwitch:
        {
            key = @"test_swith";
        }
        case CloseSendSwitch:
        {
            key = @"closeSend_swith";
        }
        default:
            break;
    }
    if (key) {
        NSString *value = [self getConfigValue:key];
        return [value isEqualToString:@"1"];
    }
    return NO;
}

@end
