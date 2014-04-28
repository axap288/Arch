//
//  IRsysMonitor.m
//  iResearcher
//
//  Created by liu nian on 13-6-25.
//  Copyright (c) 2013年 Liunian. All rights reserved.
//

#import "AHsysMonitor.h"

#import <dlfcn.h>
#include <stdio.h>
#include <stdint.h>
#include <string.h>
#include <assert.h>
#include <sys/errno.h>
#include <math.h>
#include <limits.h>
#include <objc/runtime.h>
#include <execinfo.h>
#include <sys/sysctl.h>
#include <stdlib.h>

#define SPRINGBOARDPATH "/System/Library/PrivateFrameworks/SpringBoardServices.framework/SpringBoardServices"
#define SPRINGBOARD_STATE @"SpringBord"
#define LOCKED_STATE @"Locked"

@implementation AHsysMonitor

+(NSDictionary*)getActiveAppsBySpringBoard {
    mach_port_t *port;
    void *uikit = dlopen(SPRINGBOARDPATH, RTLD_LAZY);
    int (*SBSSpringBoardServerPort)() =
    dlsym(uikit, "SBSSpringBoardServerPort");
    port = (mach_port_t *)SBSSpringBoardServerPort();
    
    //判断是否处于锁屏状态
    bool locked;
    bool passcode;
    void* (*SBGetScreenLockStatus)(mach_port_t* port, bool *lockStatus, bool *passcodeEnabled) = dlsym(uikit, "SBGetScreenLockStatus");
    SBGetScreenLockStatus(port, &locked, &passcode);
    
    if (locked) {
        //如果锁屏，则直接返回
        dlclose(uikit);
        return [[NSDictionary alloc] initWithObjectsAndKeys:@"1", @"locked", nil];
    }
    else {
        //获取当前运行应用得APPID
        void* (*SBFrontmostApplicationDisplayIdentifier)(mach_port_t* port,char * result) =
        dlsym(uikit, "SBFrontmostApplicationDisplayIdentifier");
        char frontmostAppS[256];
        memset(frontmostAppS,sizeof(frontmostAppS),0);
        SBFrontmostApplicationDisplayIdentifier(port,frontmostAppS);
        NSString * app_id = [NSString stringWithUTF8String:frontmostAppS];
        
        //判断是app_id 是否为 nil ，是则返回～
        if (app_id == nil) {
            return [[NSDictionary alloc] initWithObjectsAndKeys:@"0",@"locked",
                    @"",@"app_id",
                    @"",@"app_name",nil];
        }
        
        //获取当前运行应用得APP Name
        CFStringRef (*SBSCopyLocalizedApplicationNameForDisplayIdentifier)(CFStringRef displayIdentifier) =
        dlsym(uikit, "SBSCopyLocalizedApplicationNameForDisplayIdentifier");
        CFStringRef locName = SBSCopyLocalizedApplicationNameForDisplayIdentifier((__bridge  CFStringRef)app_id);
        NSString *app_name = [NSString stringWithFormat:@"%@",locName];
        if (locName != NULL)CFRelease(locName);
        
        dlclose(uikit);
        if ([app_name length] == 0 || [app_name length] < 2)  {
            //如果包名无效，则返回空包名，外部处理
            return [[NSDictionary alloc] initWithObjectsAndKeys:@"0",@"locked",
                    @"",@"app_id",
                    @"",@"app_name",nil];
        }
        else {
            return [[NSDictionary alloc] initWithObjectsAndKeys:@"0",@"locked",
                    app_id,@"app_id",
                    app_name,@"app_name",nil];
        }
    }
}


@end
