//
//  Arch.m
//  Arch
//
//  Created by LiuNian on 14-4-10.
//
//

#import "Arch.h"
#import "AHMonitorSourceController.h"
#import "MTAudioPlayer.h"
#import "MSWeakTimer.h"


@implementation Arch
{
    MTAudioPlayer *audioPlayer;
    UIBackgroundTaskIdentifier bgTask;
    NSUInteger deviceSystemVer;
    MSWeakTimer *playaudioTimer;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        //获取IOS版本
        deviceSystemVer =  [[[[[UIDevice currentDevice] systemVersion]
                              componentsSeparatedByString:@"."] objectAtIndex:0] intValue];
        
           [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(toBackground) name:UIApplicationDidEnterBackgroundNotification object:nil];

    }
    return self;
}

-(void)startMonitor
{
    AHMonitorSourceController *monitorSc = [AHMonitorSourceController shareInstance];
    [monitorSc runMonitors];
}

-(void)stopMonitor
{
    AHMonitorSourceController *monitorSc = [AHMonitorSourceController shareInstance];
    [monitorSc stopMonitors];
}

- (void)toBackground {
    UIApplication*    app = [UIApplication sharedApplication];
    
    bgTask = [app beginBackgroundTaskWithExpirationHandler:^{
        [app endBackgroundTask:bgTask];
        bgTask = UIBackgroundTaskInvalid;
    }];
    
    // Start the long-running task and return immediately.
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        if (audioPlayer == nil) {
            audioPlayer = [[MTAudioPlayer alloc]init];
        }
        [audioPlayer playBackgroundAudio];
        [audioPlayer stop];
        
        
        //适配iOS7的定时器间隔启动时间
        float intervalTime = 150.0f; // 2分30秒
        //低于iOS7的间隔运行时间
        if (deviceSystemVer < 7) {
            intervalTime = 570.0f; // 9分30秒
        }
        playaudioTimer = [MSWeakTimer scheduledTimerWithTimeInterval:intervalTime target:self selector:@selector(alwaysRunControl) userInfo:nil repeats:YES dispatchQueue:dispatch_get_main_queue()];
        [playaudioTimer fire];
//        [[NSRunLoop currentRunLoop] addTimer:playaudioTimer forMode:NSRunLoopCommonModes];
//        [[NSRunLoop currentRunLoop] run];
    });
}

-(void)alwaysRunControl
{
    if (audioPlayer == nil) {
        audioPlayer = [[MTAudioPlayer alloc]init];
    }
    [audioPlayer playBackgroundAudio];
    [audioPlayer stop];
}



@end
