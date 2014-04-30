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
    
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    [dic setObject:[NSNumber numberWithInt:apprunCategory] forKey:@"MonitorSourceCategory"];
    [dic setObject:@"com.tencent.wechat" forKey:@"packageName"];
    [dic setObject:@"微信" forKey:@"appName"];
    [dic setObject:@"2014-04-29 10:10:10" forKey:@"start_time"];
    [dic setObject:@"2014-04-29 10:20:10" forKey:@"end_time"];
    [dic setObject:[NSNumber numberWithFloat:600] forKey:@"duration"];
    
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
