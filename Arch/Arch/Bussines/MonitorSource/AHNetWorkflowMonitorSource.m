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
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    [dic setObject:@"1212121" forKey:@"result"];
    return dic;
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
