//
//  AHDataController.m
//  Arch
//
//  Created by LiuNian on 14-4-29.
//
//

#import "AHDataController.h"
#import "AHMonitorSourceController.h"
#import "AHAssistant.h"
#import "MSWeakTimer.h"
#import "AHFileTool.h"
#import "AHTransmitController.h"
#import "AHFileTool.h"


#define  dataArchiveFileName @"archData.archive"

@interface AHDataController()

/**
 *  输出json数据
 */
-(void)outputJsonString;
/**
 *  用于数据输出后的数据清理操作
 */
-(void)clearData;

@end

@implementation AHDataController
{
    MSWeakTimer *timer;
    NSDictionary *basdinfo;
    AHTransmitController *transmitController;
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
        
        transmitController = [AHTransmitController getInstance];
        
        NSString *archiveFilePath = [[self getDocumentPath] stringByAppendingPathComponent:dataArchiveFileName];
        self.totalDic = [NSKeyedUnarchiver unarchiveObjectWithFile: archiveFilePath];
        if (self.totalDic == nil) {
            self.totalDic = [NSMutableDictionary dictionary];
        }
        
        //启动定时任务，开启定时发送
        float interval = 30.0f;
        timer = [MSWeakTimer scheduledTimerWithTimeInterval:interval target:self selector:@selector(timerTask) userInfo:nil repeats:YES dispatchQueue:dispatch_get_main_queue()];
        [timer fire];
    }
    return self;
}

-(void)timerTask
{
    if (self.totalDic != nil) {
        //输出json串
        [self outputJsonString];
        //数据清理
        [self clearData];
    }
}


-(void)dataStore:(NSDictionary *)data
{
    if (data  == nil) {
        return;
    }
    
    NSNumber *category = [data objectForKey:@"MonitorSourceCategory"];
    if (self.totalDic == nil) {
        self.totalDic = [NSMutableDictionary dictionary];
    }

    switch ([category intValue]) {
        case apprunCategory:
        {
            NSArray *arrayInTotalDic =  [self.totalDic objectForKey:@"app_run"];
            NSMutableArray *apprunArray = arrayInTotalDic == nil?[NSMutableArray array]:[NSMutableArray arrayWithArray:arrayInTotalDic];
            [apprunArray addObject:data];
            [self.totalDic setObject:apprunArray forKey:@"app_run"];
        }
            break;
        case networkflowCategory:
        {
            NSArray *arrayInTotalDic =  [self.totalDic objectForKey:@"device_flow"];
            NSMutableArray *networkflowArray = arrayInTotalDic == nil?[NSMutableArray array]:[NSMutableArray arrayWithArray:arrayInTotalDic];
            [networkflowArray addObject:data];
            [self.totalDic setObject:networkflowArray forKey:@"device_flow"];
        }
            break;
        case baseInfoCategory:
        {
            basdinfo = data;
        }
        default:
            break;
    }
    
    if (basdinfo) {
        [self.totalDic setObject:basdinfo forKey:@"baseinfo"];
    }

    NSString *archiveFilePath = [[AHFileTool getDocumentPath] stringByAppendingPathComponent:dataArchiveFileName];
    [NSKeyedArchiver archiveRootObject:self.totalDic toFile:archiveFilePath];
    
}

-(void)outputJsonString
{
    NSString *jsonStr = [AHAssistant makeJsonString:self.totalDic];
    NSLog(@"json Str:%@",jsonStr);
//    [transmitController sendJsonData:jsonStr withTarget:monitorTarget];
}

-(void)clearData
{
    [self.totalDic removeAllObjects];
    self.totalDic = nil;
    [AHFileTool removeFile:dataArchiveFileName];
}

-(NSString *)getDocumentPath
{
    return [NSHomeDirectory() stringByAppendingPathComponent:@"Documents"];
}

@end
