//
//  AHDataController.m
//  Arch
//
//  Created by LiuNian on 14-4-29.
//
//

#import "AHDataController.h"
#import "AppInfo.h"
#import "AppRunTimeInfo.h"
#import "AHMonitorSourceController.h"
#import "AHAssistant.h"

@implementation AHDataController
{
    
    NSMutableDictionary *totalDic;

    
//    NSMutableArray *apprunArray;
//    NSMutableArray *networkflowArray;
//    NSMutableArray *baseInfoArray;
}

+(AHDataController *)shareInstance
{
    static AHDataController *instance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[AHDataController alloc] init];
    });
    return instance;
}

- (id)init
{
    self = [super init];
    if (self) {
//        apprunArray = [NSMutableArray array];
//        networkflowArray = [NSMutableArray array];
        
        totalDic = [NSMutableDictionary dictionary];
    }
    return self;
}


-(void)dataStore:(NSDictionary *)data
{
    NSNumber *category = [data objectForKey:@"MonitorSourceCategory"];
//    NSDictionary result = [data objectForKey:@"result"];
    
    switch ([category intValue]) {
        case apprunCategory:
        {
            NSArray *arrayInTotalDic =  [totalDic objectForKey:@"app_run"];
            NSMutableArray *apprunArray = arrayInTotalDic == nil?[NSMutableArray array]:[NSMutableArray arrayWithArray:arrayInTotalDic];
            [apprunArray addObject:data];
            [totalDic setObject:apprunArray forKey:@"app_run"];
        }
            break;
        case networkflowCategory:
        {
            NSArray *arrayInTotalDic =  [totalDic objectForKey:@"device_flow"];
            NSMutableArray *networkflowArray = arrayInTotalDic == nil?[NSMutableArray array]:[NSMutableArray arrayWithArray:arrayInTotalDic];
            [networkflowArray addObject:data];
            [totalDic setObject:networkflowArray forKey:@"device_flow"];
        }
            break;
        case baseInfoCategory:
        {
            NSDictionary *dicInTotalDic =  [totalDic objectForKey:@"baseinfo"];
            if (dicInTotalDic == nil) {
                [totalDic setObject:data forKey:@"baseinfo"];
            }
        }
        default:
            break;
    }
    
    //测试
    NSLog(@"totalDic %@",totalDic);
}

-(void)outputJsonString
{
    NSLog(@"totalDic %@",totalDic);
}

@end
