//
//  AHDeviceInfoMonitorSource.m
//  Arch
//
//  Created by LiuNian on 14-4-30.
//
//

#import "AHDeviceInfoMonitorSource.h"


@implementation AHDeviceInfoMonitorSource

/**
 *  运行一次的间隔时间
 *
 *  @return 秒数
 */
-(float)onceIntervalTime
{
    return 0;
}
/**
 *  返回监测结果
 *
 *  @return dic形式
 */
-(NSDictionary *)startMonitorSourceAndGetResult
{
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    [dic setObject:@"apptest" forKey:@"appkey"];
    [dic setObject:@"1.0" forKey:@"sdk_version"];
    [dic setObject:@"iOS" forKey:@"os_name"];
    [dic setObject:@"7.0" forKey:@"os_ver"];
    [dic setObject:@"iPhone" forKey:@"device_model"];
    [dic setObject:@"" forKey:@"device_name"];
    [dic setObject:@"" forKey:@"device_screen"];
    [dic setObject:@"" forKey:@"device_cpu"];
    [dic setObject:@"yes" forKey:@"iscrack"];
    [dic setObject:@"123456789" forKey:@"uid"];
    
    return dic;
}
/**
 *  获取监测源类别
 *
 *  @return id
 */
-(MonitorSourceCategory)getMonitorSourceCategory
{
    return baseInfoCategory;
}

@end
