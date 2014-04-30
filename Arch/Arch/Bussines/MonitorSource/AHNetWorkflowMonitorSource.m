//
//  AHNetWorkflowMonitorSource.m
//  Arch
//
//  Created by LiuNian on 14-4-29.
//
//

#import "AHNetWorkflowMonitorSource.h"

@implementation AHNetWorkflowMonitorSource

/**
 *  运行一次的间隔时间
 *
 *  @return 秒数
 */
-(float)onceIntervalTime
{
    return 5.0f;
}

/**
 *  返回监测结果
 *
 *  @return dic形式
 */
-(NSDictionary *)startMonitorSourceAndGetResult
{
    NSMutableDictionary *NewflowRate = [NSMutableDictionary dictionary];
    [NewflowRate setObject:[NSNumber numberWithInt:networkflowCategory] forKey:@"MonitorSourceCategory"];
    [NewflowRate setObject:@"46001" forKey:@"carrier"];
    [NewflowRate setObject:@"9" forKey:@"hour"];
    [NewflowRate setObject:@"12345" forKey:@"wifi_rec_flow"];
    [NewflowRate setObject:@"12345" forKey:@"wifi_send_flow"];

    [NewflowRate setObject:@"12345" forKey:@"wwan_rec_flow"];
    [NewflowRate setObject:@"12345" forKey:@"wwan_send_flow"];
    
    [NewflowRate setObject:@"1234567890" forKey:@"ssid"];
    [NewflowRate setObject:@"2013-09-17 09:17:48" forKey:@"ts"];
    
    return NewflowRate;
}

/**
 *  获取监测源类型
 *
 *  @return id
 */
-(MonitorSourceCategory)getMonitorSourceCategory;
{
    return networkflowCategory;
}

@end
