//
//  Arch.m
//  Arch
//
//  Created by LiuNian on 14-4-10.
//
//

#import "Arch.h"
#import "AHMonitorSourceController.h"

@implementation Arch

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

@end
