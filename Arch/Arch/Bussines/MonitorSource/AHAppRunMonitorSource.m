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


@implementation AHAppRunMonitorSource

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
    
    AppInfo *info = [[AppInfo alloc] init];
    info.packageName = @"com.tencent.wechat";
    info.processName = @"";
    info.appName = @"微信";
    
    AppRunTimeInfo *runtimeInfo = [[AppRunTimeInfo alloc] init];
    runtimeInfo.start_time = @"2014-04-29 10:10:10";
    runtimeInfo.end_time = @"2014-04-29 10:20:10";
    runtimeInfo.duration = [NSNumber numberWithFloat:600];
    
    NSMutableOrderedSet *set = [NSMutableOrderedSet orderedSet];
    [set addObject:runtimeInfo];
    
    info.runTimes = set;
    
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    [dic setObject:[NSNumber numberWithInt:apprunCategory] forKey:@"category"];
    [dic setObject:info forKey:@"result"];
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
