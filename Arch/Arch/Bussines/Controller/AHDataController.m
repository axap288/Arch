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

#import "AHAppRunParser.h"

@implementation AHDataController
{
    NSMutableArray *apprunArray;
    NSMutableArray *networkflowArray;
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
        apprunArray = [NSMutableArray array];
    }
    return self;
}


-(void)dataStore:(NSDictionary *)data
{
    NSNumber *category = [data objectForKey:@"category"];
    id result = [data objectForKey:@"result"];
    
    switch ([category intValue]) {
        case apprunCategory:
        {
            [apprunArray addObject:result];
        }
            break;
        case networkflowCategory:
        {
            [networkflowArray addObject:result];
        }
            break;
        default:
            break;
    }
}

-(void)outputJsonString
{
    NSMutableDictionary *totalDic = [NSMutableDictionary dictionary];
    /**
     *  app运行数据解析
     */
    NSMutableArray *tempArray = [NSMutableArray array];
    [apprunArray enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        AppInfo *appinfo = obj;
        AppRunTimeInfo *appRunInfo = [appinfo.runTimes firstObject];
        NSMutableDictionary *temp = [NSMutableDictionary dictionary];
        [temp setObject:appinfo.appName forKey:@"app_name"];
        [temp setObject:appinfo.packageName forKey:@"appid"];
        [temp setObject:appinfo.runTimes forKey:@"run_time"];
        [temp setObject:appRunInfo.start_time forKey:@"start_time"];
        [temp setObject:appRunInfo.end_time forKey:@"end_time"];
        [temp setObject:appRunInfo.duration forKey:@"duration"];
        
        [apprunArray addObject:temp];
    }];
    
    [totalDic setObject:apprunArray forKey:@"app_run"];
    NSLog(@"totalDic %@",totalDic);
    
}

@end
