//
//  AHTransmitController.m
//  Arch
//
//  Created by LiuNian on 14-4-29.
//
//

#import "AHTransmitController.h"
#import "AHAssistant.h"
#import "MSWeakTimer.h"
#import "AHFileTool.h"

#define  cacheArchiveFileName @"RequestCache.archive"
#define  MonitorDataServerURL @"http://192.168.1.24/PoweredByMacOSX.gif"
#define  EventDataServerURL @"http://127.0.0.1/b.jpg"


@interface AHTransmitController()

@property (atomic,strong) NSMutableArray *dataCache;
@property (nonatomic,strong) MSWeakTimer *timer;

@end

@implementation AHTransmitController

+(AHTransmitController *)getInstance
{
    static AHTransmitController *instance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[AHTransmitController alloc] init];
    });
    return instance;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        float interval = 10;
        
        self.dataCache = [NSKeyedUnarchiver unarchiveObjectWithFile:[self getArchiveFilePath]];
        if (self.dataCache == nil) {
            self.dataCache = [NSMutableArray array];
        }
        self.timer = [MSWeakTimer scheduledTimerWithTimeInterval:interval target:self selector:@selector(runLoopCheckSendDataService) userInfo:nil repeats:YES dispatchQueue:dispatch_get_main_queue()];
        [self.timer fire];
    }
    return self;
}

-(void)runLoopCheckSendDataService
{
    if ([self.dataCache count] != 0) {
        
        NSMutableArray *sendSuccessArray = [NSMutableArray array];
        [self.dataCache enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            if ([AHAssistant reachabilityCheck]) {
                NSString *url = [self getRightSendUrl:obj];
                if (url != nil) {
                    //发送数据
                    BOOL success =  [AHAssistant simpleRequestUseGetMethod:url];
                    //发送成功的记录到一个数组中等待删除
                    if (success) {
                        [sendSuccessArray addObject:obj];
                    }
                    sleep(1);
                }
            }else{
                *stop = YES;
            }
        }];
        
        [self.dataCache removeObjectsInArray:sendSuccessArray];
        [NSKeyedArchiver archiveRootObject:self.dataCache toFile:[self getArchiveFilePath]];
    }
}

-(void)sendJsonData:(NSString *)jsonstr withTarget:(sendTarget)target
{
    if (jsonstr  != nil) {
        NSString *compressStr = [self gzipCompressStr:jsonstr];
//        NSString *restoreStr = [self gzipUncompressStr:compressStr];
        if (compressStr) {
            NSMutableDictionary *dic = [NSMutableDictionary dictionary];
            [dic setObject:compressStr forKey:@"data"];
            [dic setObject:[NSNumber numberWithInt:target] forKey:@"target"];
            //发送数据
            [self sendDataToServerNow:dic];
        }
    }
}

-(void)sendDataToServerNow:(NSDictionary *)data
{
    if (data == nil) {
        return;
    }
    //首先判断网络状态
    if ([AHAssistant reachabilityCheck]) {
        NSString *url = [self getRightSendUrl:data];
        if (url != nil) {
            //发送数据
            BOOL success =  [AHAssistant simpleRequestUseGetMethod:url];
            //发送不成功也记入到缓存中
            if (!success) {
                [self.dataCache addObject:data];
            }
        }
    }else{
        //如果网络不通则先缓存数据
        [self.dataCache addObject:data];
        [NSKeyedArchiver archiveRootObject:self.dataCache toFile:[self getArchiveFilePath]];

    }
}

-(NSString *)getRightSendUrl:(NSDictionary *)data
{
    if (data) {
        NSString *sendUrl ;
        sendTarget target = [[data objectForKey:@"target"] intValue];
        NSString *jsonStr =  [data objectForKey:@"data"];
        switch (target) {
            case monitorTarget:
                sendUrl = [NSString stringWithFormat:@"%@?d=%@",MonitorDataServerURL,jsonStr];
                break;
            case eventTarget:
                sendUrl = [NSString stringWithFormat:@"%@?d=%@",EventDataServerURL,jsonStr];
            default:
                break;
        }
        return sendUrl;
    }
    return nil;
}


-(NSString *)gzipCompressStr:(NSString *)jsonstr
{
    NSData *inputData = [jsonstr dataUsingEncoding:NSUTF8StringEncoding];
    NSData *compressedData = [AHAssistant gzipData:inputData] ;
    NSString *compressStr  = [compressedData base64EncodedStringWithOptions:0];
    return compressStr;
}

-(NSString *)gzipUncompressStr:(NSString *)compressStr
{
   NSData *inputData =[[NSData alloc] initWithBase64EncodedString:compressStr options:0];
    NSData *uncompressedData = [AHAssistant ungzipData:inputData] ;
    NSString *uncompressStr =  [[NSString alloc] initWithData:uncompressedData encoding:NSUTF8StringEncoding];

    return uncompressStr;
}

-(NSString *)getArchiveFilePath
{
    NSString *archiveFilePath = [[AHFileTool getDocumentPath] stringByAppendingPathComponent:cacheArchiveFileName];
    return archiveFilePath;
}


@end
