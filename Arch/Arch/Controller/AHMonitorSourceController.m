//
//  AHMonitorSourceController.m
//  Arch
//
//  Created by LiuNian on 14-4-29.
//
//

#import "AHMonitorSourceController.h"

@implementation AHMonitorSourceController

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
        
    }
    return self;
}

-(void)runMonitors
{
    
}

-(void)stopMonitors
{
    
}

-(void)runMonitorWithtMonitorSourceId:(NSString *)monitorSourceId
{
    
}

-(void)stopMonitorWithMonitorSourceId:(NSString *)monitorSourceId
{
    
}


@end
