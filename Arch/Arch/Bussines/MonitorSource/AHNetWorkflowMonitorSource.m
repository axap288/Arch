//
//  AHNetWorkflowMonitorSource.m
//  Arch
//
//  Created by LiuNian on 14-4-29.
//
//

#import "AHNetWorkflowMonitorSource.h"
#import "AHAssistant.h"
#import "AHSysInfo.h"


@implementation AHNetWorkflowMonitorSource
{
    int wifiSent;
    int wifiReceived;
    int wwanSent;
    int wwanReceived;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        NSArray *array = [AHSysInfo getDataCounters];
        wifiReceived = [(NSNumber*) [array objectAtIndex:0 ] intValue];
        wifiSent = [(NSNumber*) [array objectAtIndex:1 ] intValue];
        wwanReceived = [(NSNumber*) [array objectAtIndex:2 ] intValue];
        wwanSent = [(NSNumber*) [array objectAtIndex:3 ] intValue];

    }
    return self;
}


#pragma mark -
#pragma mark MonitorSource

/**
 *  运行一次的间隔时间
 *
 *  @return 秒数
 */
-(float)onceIntervalTime
{
    return 5.0f;
}

-(float)delayTime
{
    //第一次运行时间，计算好整点运行的时间
    NSDate *nextHour = [AHAssistant getNextIntegralHourDate];
    NSTimeInterval  interval =  [nextHour timeIntervalSinceNow];
    return interval;
}

/**
 *  返回监测结果
 *
 *  @return dic形式
 */
-(NSDictionary *)startMonitorSourceAndGetResult
{
    
    NSArray *array = [AHSysInfo getDataCounters];
    int now_wifiReceived = [(NSNumber*) [array objectAtIndex:1 ] intValue];
    int now_wifiSent = [(NSNumber*) [array objectAtIndex:0 ] intValue];
    int now_wwanReceived = [(NSNumber*) [array objectAtIndex:3 ] intValue];
    int now_wwanSent = [(NSNumber*) [array objectAtIndex:2 ] intValue];
    
    int wifiReceived_flowRate = 0;
    int wifiSent_flowRate = 0;
    int wwanReceived_flowRate = 0;
    int wwanSent_flowRate = 0;
    
    //判断收集的网络流量值是否有为0的情况（网络不通或者关闭的情况）
    if (now_wifiSent) {
        wifiSent_flowRate = now_wifiSent - wifiSent;
    }
    
    if (now_wifiReceived) {
        wifiReceived_flowRate = now_wifiReceived - wifiReceived;
    }
    
    if (now_wwanReceived) {
        wwanReceived_flowRate = now_wwanReceived - wwanReceived;
    }
    
    if (now_wwanSent) {
        wwanSent_flowRate = now_wwanSent - wwanSent;
    }
    
    
    
    wifiReceived = now_wifiReceived;
    wifiSent = now_wifiSent;
    wwanReceived = now_wwanReceived;
    wwanSent = now_wwanSent;
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"HH"];
    NSString*hourStr =[dateFormatter stringFromDate:[NSDate date]];
    
    NSDateFormatter*dateFormatter1 =[[NSDateFormatter alloc] init];
    [dateFormatter1 setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSString *ts =[dateFormatter1 stringFromDate:[NSDate date]];

    NSMutableDictionary *NewflowRate = [NSMutableDictionary dictionary];
    [NewflowRate setObject:[NSNumber numberWithInt:networkflowCategory] forKey:@"MonitorSourceCategory"];
    [NewflowRate setObject:hourStr forKey:@"hour"];
    [NewflowRate setObject:[NSString stringWithFormat:@"%d",wifiReceived_flowRate] forKey:@"wifi_rec_flow"];
    [NewflowRate setObject:[NSString stringWithFormat:@"%d",wifiSent_flowRate] forKey:@"wifi_send_flow"];

    [NewflowRate setObject:[NSString stringWithFormat:@"%d",wwanReceived_flowRate]  forKey:@"wwan_rec_flow"];
    [NewflowRate setObject:[NSString stringWithFormat:@"%d",wwanSent_flowRate] forKey:@"wwan_send_flow"];
    
    [NewflowRate setObject:@"" forKey:@"ssid"];
    [NewflowRate setObject:ts forKey:@"ts"];
    
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
