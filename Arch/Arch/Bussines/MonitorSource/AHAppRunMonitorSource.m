//
//  AHAppRunMonitorSource.m
//  Arch
//
//  Created by LiuNian on 14-4-29.
//
//

#import "AHAppRunMonitorSource.h"
#import "AppInfo.h"
#import "AppRunTimeInfo.h"
#import "AHsysMonitor.h"
#import "AHAssistant.h"


@implementation AHAppRunMonitorSource
{
    NSString *preAppID;
    NSString *preAppName;
    NSString *preTime;
    NSTimer *timerforColllect;
}

/**
 *  运行一次的间隔时间
 *
 *  @return 秒数
 */
-(float)onceIntervalTime
{
    return 3.0f;
}
/**
 *  返回监测结果
 *
 *  @return dic形式
 */
-(NSDictionary *)startMonitorSourceAndGetResult
{
    NSDictionary *result;
    NSDictionary *dict = [AHsysMonitor getActiveAppsBySpringBoard];
    NSString *locked = [dict objectForKey:@"locked"];
    NSString *app_id = [dict objectForKey:@"app_id"];
    
    //锁屏时，设置timer步长为9秒
//    if ([locked isEqualToString:@"1"])
//        self.stampInterval = 9;
//    else
//        self.stampInterval = 3;
    
    //非锁屏状态 且 appid不为空，记录数据
    if ([locked isEqualToString:@"0"] && ![app_id isEqualToString:@""]) {
        
        
//        NSString *currentUnixTime = [NSString stringWithFormat:@"%d", (int)[[NSDate date] timeIntervalSince1970]];
        NSString *currentTime = [AHAssistant getTimeStamp];
        NSString *app_name = [dict objectForKey:@"app_name"];
        
        //排除包名app_id 中无效的字符串
        NSCharacterSet *nameCharacters = [[NSCharacterSet
                                           characterSetWithCharactersInString:@"._-abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"] invertedSet];
        NSRange userNameRange = [app_id rangeOfCharacterFromSet:nameCharacters];
        
        if (userNameRange.location != NSNotFound) {
            //存储上一次App运行信息
            if (preAppName) {
                result =  [self recordApprunInfo:currentTime];
                preAppID = nil;
                preAppName = nil;
                preTime = currentTime;
            }
            
        } else if (![preAppID isEqualToString:app_id]) {
            //存储上一次App运行信息
            if (preAppName) {
                 result =  [self recordApprunInfo:currentTime];
            }
            
            //记录当前App运行信息到内存
            preAppID = app_id;
            preAppName = app_name;
            preTime = currentTime;
            
        }
    }else {
        //存储上一次App运行信息
        if (preAppName &&  ![preAppName isEqualToString:@"(null)"]) {
            NSString *currentTime = [AHAssistant getTimeStamp];
            result =  [self recordApprunInfo:currentTime];
            
            preAppID = nil;
            preAppName = nil;
            preTime = currentTime;
        }
    }
    
    return result;
}

-(NSDictionary *) recordApprunInfo:(NSString *)currentTime{
    
    NSInteger stufTime = [currentTime integerValue] - [preTime integerValue];
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    if ([preAppID isEqualToString:@"0"] ) {
        return nil;
    }
    [dic setObject:[NSNumber numberWithInt:apprunCategory] forKey:@"MonitorSourceCategory"];
    [dic setObject:preAppID forKey:@"packageName"];
    [dic setObject:preAppName forKey:@"appName"];
    [dic setObject:preTime forKey:@"start_time"];
    [dic setObject:currentTime forKey:@"end_time"];
    [dic setObject:[NSString stringWithFormat:@"%d",stufTime] forKey:@"duration"];
    
    return dic;
}

/**
 *  获取监测源ID
 *
 *  @return id
 */
-(MonitorSourceCategory)getMonitorSourceCategory
{
    return apprunCategory;
}

@end
