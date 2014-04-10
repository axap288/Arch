//
//  IRNetWorkflowRateStatistics.m
//  iRDataCollectorForEnterprise
//
//  Created by LiuNian on 13-9-29.
//  Copyright (c) 2013年 LN. All rights reserved.
//

#import "IRNetWorkflowRateStatistics.h"
#import "IRConstant.h"
#import "IRAssistant.h"
#import "IRCoreDataManager.h"
#import  "IRConfigManager.h"

@implementation IRNetWorkflowRateStatistics


-(id)init
{
    self = [super init];
    if (self) {
        wifiReceived = [self getWifiReviceTraffic];
        wifiSent = [self getWifiSendTraffic];
        wwanReceived = [self getMobileReviceTraffic];
        wwanSent = [self getMobileSendTraffic];
    }
    return self;
}

-(void)startWork
{
    //第一次运行时间，计算好整点运行的时间
    NSDate *nextHour = [IRAssistant getNextIntegralHourDate];
    NSTimeInterval  interval =  [nextHour timeIntervalSinceNow];
//    DDLogInfo(@"interval : %f",interval);
    DDLogInfo(@"[流量监测]:启动流量监测定时器");
    DDLogInfo(@"[流量监测]: 下次扫描时间时间:%@",nextHour);
    double delayInSeconds = interval;
    //是否开启测试模式
    if ([IRConfigManager switchValue:TestSwitch]) {
        delayInSeconds = 20;//20秒
    }
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        [self startTimerForStatistics];
    });
}

-(void)startTimerForStatistics
{
    BOOL runEnable =  [IRConfigManager switchValue:FlowRateSwitch];
    if (!runEnable) {
        DDLogInfo(@"[流量监测]:已被禁止运行!");
        return;
    }
    
    int interval = 3600;//每1小时执行一次
    int leeway = 0;
    
    //开启测试模式
    if ([IRConfigManager switchValue:TestSwitch]) {
        interval = 60;
    }
    
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_source_t timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, queue);
    if (timer) {
        dispatch_source_set_timer(timer, dispatch_walltime(DISPATCH_TIME_NOW  , DISPATCH_TIME_FOREVER), interval   * NSEC_PER_SEC, leeway);
        dispatch_source_set_event_handler(timer, ^{
            
            int now_wifiReceived = [self getWifiReviceTraffic];
            int now_wifiSent = [self getWifiSendTraffic];
            int now_wwanReceived = [self getMobileReviceTraffic];
            int now_wwanSent = [self getMobileSendTraffic];
            
            int wifiReceived_flowRate = now_wifiReceived - wifiReceived;
            int wifiSent_flowRate = now_wifiSent - wifiSent;
            int wwanReceived_flowRate = now_wwanReceived - wwanReceived;
            int wwanSent_flowRate = now_wwanSent - wwanSent;
            
            wifiReceived = now_wifiReceived;
            wifiSent = now_wifiSent;
            wwanReceived = now_wwanReceived;
            wwanSent = now_wwanSent;
            
            DDLogInfo(@"[流量监测]:已使用wifi流量:%d  %d",wifiReceived_flowRate,wifiSent_flowRate);
            DDLogInfo(@"[流量监测]:已使用移动流量:%d %d",wwanReceived_flowRate,wwanSent_flowRate);
            
            NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
            [dateFormatter setDateFormat:@"HH"];
            NSString*hourStr =[dateFormatter stringFromDate:[NSDate date]];
            
            NSDateFormatter*dateFormatter1 =[[NSDateFormatter alloc] init];
            [dateFormatter1 setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
            NSString *ts =[dateFormatter stringFromDate:[NSDate date]];
            
            NSMutableDictionary *wifiFlowRatedic = [NSMutableDictionary dictionary];
            [wifiFlowRatedic setObject:@"wifi" forKey:@"net_type"];
            [wifiFlowRatedic setObject:[NSNumber numberWithInt:wifiSent_flowRate] forKey:@"send_flow"];
            [wifiFlowRatedic setObject:[NSNumber numberWithInt:wifiReceived_flowRate] forKey:@"rec_flow"];
            [wifiFlowRatedic setObject:hourStr forKey:@"hour"];
            [wifiFlowRatedic setObject:@"" forKey:@"ssid"];
            [wifiFlowRatedic setObject:V_CARRIER  forKey:@"carrier"];
            [wifiFlowRatedic setObject:ts forKey:K_TS];
            
            NSMutableDictionary *wwanFlowRatedic = [NSMutableDictionary dictionary];
            [wwanFlowRatedic setObject:@"wwan" forKey:@"net_type"];
            [wwanFlowRatedic setObject:[NSNumber numberWithInt:wwanSent_flowRate] forKey:@"send_flow"];
            [wwanFlowRatedic setObject:[NSNumber numberWithInt:wwanReceived_flowRate] forKey:@"rec_flow"];
            [wwanFlowRatedic setObject:@"" forKey:@"ssid"];
            [wwanFlowRatedic setObject:V_CARRIER  forKey:@"carrier"];
            [wifiFlowRatedic setObject:hourStr forKey:@"hour"];
            [wwanFlowRatedic setObject:ts forKey:K_TS];
            
            IRCoreDataManager *cdmanager = [IRCoreDataManager shareInstance];
            [cdmanager saveNetFlowInfo:wifiFlowRatedic];
            [cdmanager saveNetFlowInfo:wwanFlowRatedic];
            
//            NSString *deviceFlowLog = [IRFileTool getFullPath:LOG_FILE_FLOWRATE];
//            NSLog(@"deviceFlowlog:%@",deviceFlowLog);
//            NSMutableArray *deviceflowArray = [NSMutableArray arrayWithContentsOfFile:deviceFlowLog];
//            if (deviceflowArray == nil) {
//                deviceflowArray = [NSMutableArray array];
//            }
//            [deviceflowArray addObject:wifiFlowRatedic];
//            [deviceflowArray addObject:wwanFlowRatedic];
//            [deviceflowArray writeToFile:deviceFlowLog atomically:YES];
            
            //            NSLog(@"wifiReceived_flowRate:%i",wifiReceived_flowRate);
            //            NSLog(@"wifiSent_flowRate:%i",wifiSent_flowRate);
            //            NSLog(@"wwanReceived_flowRate:%i",wwanReceived_flowRate);
            //            NSLog(@"wwanSent_flowRate:%i",wwanSent_flowRate);
            //            NSLog(@"=========================");
            
        });
        dispatch_resume(timer);
    }
}



//===================

-(int)getWifiSendTraffic
{
    NSArray *array = [IRSysInfo getDataCounters];
    int wifiSendValue = [(NSNumber*) [array objectAtIndex:0 ] intValue];
    return  wifiSendValue;
}

-(int)getWifiReviceTraffic
{
    NSArray *array = [IRSysInfo getDataCounters];
    int wifireceivedValue = [(NSNumber*) [array objectAtIndex:1 ] intValue];
    return  wifireceivedValue;
}

-(int)getMobileSendTraffic
{
    NSArray *array = [IRSysInfo getDataCounters];
    int wwanSendValue = [(NSNumber*) [array objectAtIndex:2 ] intValue];
    return  wwanSendValue;
    
}

-(int)getMobileReviceTraffic
{
    NSArray *array = [IRSysInfo getDataCounters];
    int wwanReceivedValue = [(NSNumber*) [array objectAtIndex:3 ] intValue];
    return  wwanReceivedValue;
}





@end
