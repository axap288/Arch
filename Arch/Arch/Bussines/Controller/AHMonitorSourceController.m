//
//  AHMonitorSourceController.m
//  Arch
//
//  Created by LiuNian on 14-4-29.
//
//

#import "AHMonitorSourceController.h"
#import "AHAppRunMonitorSource.h"
#import "AHNetWorkflowMonitorSource.h"
#import "AHDataController.h"
#import "AHDeviceInfoMonitorSource.h"
#import "MSWeakTimer.h"

@interface AHMonitorSourceController()

@property(nonatomic,strong) AHDataController *dataController;
@property(nonatomic,strong) NSMutableDictionary *timers;

-(void)timeTaskWithMonitorSource:(NSTimer*)theTimer;

@end

@implementation AHMonitorSourceController
{
}

+(AHMonitorSourceController *)shareInstance
{
    static AHMonitorSourceController *instance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[AHMonitorSourceController alloc] init];
    });
    return instance;
}

-(id)init
{
    self = [super init];
    if (self) {
        
        self.dataController = [AHDataController shareInstance];
        
        self.monitorSources = [NSMutableArray array];
        self.timers = [NSMutableDictionary dictionary];
        
        
        AHAppRunMonitorSource *appMS = [[AHAppRunMonitorSource alloc] init];
        AHNetWorkflowMonitorSource *netWorkflowMS = [[AHNetWorkflowMonitorSource alloc] init];
        AHDeviceInfoMonitorSource *deviceInfoMS = [[AHDeviceInfoMonitorSource alloc] init];

        //添加监测源
        [self.monitorSources addObject:appMS];
        [self.monitorSources addObject:netWorkflowMS];
        [self.monitorSources addObject:deviceInfoMS];
        
    }
    return self;
}

-(void)runMonitors
{
    for (id<MonitorSource> monitorSource in self.monitorSources) {
        
        //给每个监测源分配一个定时器
        if ([monitorSource respondsToSelector:@selector(startMonitorSourceAndGetResult)]) {
            float interval = [monitorSource onceIntervalTime];
            
            //如果interval∫
            if (interval == 0) {
                if ([monitorSource respondsToSelector:@selector(startMonitorSourceAndGetResult)]) {
                    NSDictionary *result = [monitorSource startMonitorSourceAndGetResult];
                    [self.dataController dataStore:result];
                }
            }else{
                
                NSDictionary *dic = [NSDictionary dictionaryWithObject:monitorSource forKey:@"monitorSource"];

                MSWeakTimer *timer = [MSWeakTimer scheduledTimerWithTimeInterval:interval target:self selector:@selector(timeTaskWithMonitorSource:) userInfo:dic repeats:YES dispatchQueue:dispatch_get_main_queue()];
                [timer fire];
                
                switch ([monitorSource getMonitorSourceCategory]) {
                    case apprunCategory:
                        [self.timers setObject:timer forKey:@"apprun"];
                        break;
                    case networkflowCategory:
                        [self.timers setObject:timer forKey:@"networkflow"];
                        break;
                    default:
                        break;
                }
                
            }
        }
    }
}

-(void)timeTaskWithMonitorSource:(MSWeakTimer*)theTimer
{
    id<MonitorSource> monitorSource = [theTimer.userInfo objectForKey:@"monitorSource"];
    if ([monitorSource respondsToSelector:@selector(startMonitorSourceAndGetResult)]) {
        NSDictionary *result = [monitorSource startMonitorSourceAndGetResult];
        [self.dataController dataStore:result];
    }
}

-(void)stopMonitors
{
   NSArray *temp =  [self.timers allValues];
    for (NSTimer *timer in temp) {
        [timer invalidate];
    }
    [self.timers removeAllObjects];
}

-(void)addMonitorWithtMonitorSourceId:(NSString *)monitorSourceId
{
    
}

-(void)removeMonitorWithMonitorSourceId:(MonitorSourceCategory)monitorSourceCategory
{
    for (id<MonitorSource> monitorSource in self.monitorSources) {
        if ([monitorSource respondsToSelector:@selector(getMonitorSourceCategory)]) {
            if ([monitorSource getMonitorSourceCategory] == monitorSourceCategory) {
                [self.monitorSources removeObject:monitorSource];
            }
        }
    }

}


@end
