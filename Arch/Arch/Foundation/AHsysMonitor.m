//
//  IRsysMonitor.m
//  iResearcher
//
//  Created by liu nian on 13-6-25.
//  Copyright (c) 2013年 Liunian. All rights reserved.
//

#import "IRsysMonitor.h"

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

@implementation IRsysMonitor

+(NSString *)getActiveAppsBySpringBoard
{
    mach_port_t *port;
    void *uikit = dlopen(SPRINGBOARDPATH, RTLD_LAZY);
    int (*SBSSpringBoardServerPort)() =
    dlsym(uikit, "SBSSpringBoardServerPort");
    port = (mach_port_t *)SBSSpringBoardServerPort();
    dlclose(uikit);
    
    
    bool locked;
    bool passcode;
    void *sbserv = dlopen(SPRINGBOARDPATH, RTLD_LAZY);
    void* (*SBGetScreenLockStatus)(mach_port_t* port, bool *lockStatus, bool *passcodeEnabled) = dlsym(sbserv, "SBGetScreenLockStatus");
      SBGetScreenLockStatus(port, &locked, &passcode);
    if (locked) {
        dlclose(sbserv);
        return LOCKED_STATE;
    }
    
    void* (*SBFrontmostApplicationDisplayIdentifier)(mach_port_t* port,char * result) =
    dlsym(sbserv, "SBFrontmostApplicationDisplayIdentifier");
    
//    CFStringRef (*SBSCopyLocalizedApplicationNameForDisplayIdentifier)(CFStringRef displayIdentifier) =
//    dlsym(sbserv, "SBSCopyLocalizedApplicationNameForDisplayIdentifier");
    
    //获取当前运行应用得APPID
    char frontmostAppS[256];
    memset(frontmostAppS,sizeof(frontmostAppS),0);
    SBFrontmostApplicationDisplayIdentifier(port,frontmostAppS);
    NSString * frontmostApp = [NSString stringWithUTF8String:frontmostAppS];
    //长度等于0标识处于springboard上，同时剔除长度小于2的无意义得进程名
    if ([frontmostApp length] == 0 || [frontmostApp length] < 2) {
        return SPRINGBOARD_STATE;
    }else{
        
//          CFStringRef locName = SBSCopyLocalizedApplicationNameForDisplayIdentifier((CFStringRef)frontmostApp);
//         NSString * locName=SBSCopyLocalizedApplicationNameForDisplayIdentifier(port,frontmostApp);
//        NSLog(@"locName:%@",(NSString *)locName);
        
//        return (NSString *)locName;
        return frontmostApp;
    }
     dlclose(sbserv);
}

+(NSString *)getAppNameByIdentifier:(NSString *)identifier
{
    /*
    mach_port_t *port;
    void *uikit = dlopen(SPRINGBOARDPATH, RTLD_LAZY);
    int (*SBSSpringBoardServerPort)() =
    dlsym(uikit, "SBSSpringBoardServerPort");
    port = (mach_port_t *)SBSSpringBoardServerPort();
    dlclose(uikit);
    */
    void *uikit = dlopen(SPRINGBOARDPATH, RTLD_LAZY);
    
    CFStringRef (*SBSCopyLocalizedApplicationNameForDisplayIdentifier)(CFStringRef displayIdentifier) =
    dlsym(uikit, "SBSCopyLocalizedApplicationNameForDisplayIdentifier");
    
    CFStringRef locName = SBSCopyLocalizedApplicationNameForDisplayIdentifier((CFStringRef)identifier);
    NSString *desc = [NSString stringWithFormat:@"%@",locName];
    if (locName != NULL)CFRelease(locName);
    dlclose(uikit);
    return desc;
}

+(NSString *)getProcessNameByIdentifier:(NSString *)identifier
{

    
    mach_port_t *port;
   void *sbserv = dlopen(SPRINGBOARDPATH, RTLD_LAZY);
    int (*SBSSpringBoardServerPort)() =
    dlsym(sbserv, "SBSSpringBoardServerPort");
    port = (mach_port_t *)SBSSpringBoardServerPort();

    void* (*SBDisplayIdentifierForPID)(mach_port_t* port, int pid,char * result) =
    dlsym(sbserv, "SBDisplayIdentifierForPID");
    
    //获取现有进程
    NSString * processName = nil;
    int mib[4] = {CTL_KERN, KERN_PROC, KERN_PROC_ALL, 0};
    size_t miblen = 4;
    
    size_t size;
    int st = sysctl(mib, miblen, NULL, &size, NULL, 0);
//    int st;
    struct kinfo_proc * process = NULL;
    struct kinfo_proc * newprocess = NULL;
    
    do {
        size += size / 10;
        newprocess = realloc(process, size);
        if (!newprocess){
            if (process){
                free(process);
            }
            return nil;
        }
        process = newprocess;
    st = sysctl(mib, miblen, process, &size, NULL, 0);
    } while (st == -1 && errno == ENOMEM);
    
    if (st == 0){
        if (size % sizeof(struct kinfo_proc) == 0){
            int nprocess = size / sizeof(struct kinfo_proc);
            if (nprocess){
                for (int i = nprocess - 1; i >= 0; i--){
//                    NSString * processID = [[NSString alloc] initWithFormat:@"%d", process[i].kp_proc.p_pid];
//                    NSString * processName = [[NSString alloc] initWithFormat:@"%s", process[i].kp_proc.p_comm];
               
                    char appid[256];
                    memset(appid,sizeof(appid),0);
                    int intID;
                    intID=process[i].kp_proc.p_pid;
                    SBDisplayIdentifierForPID(port,intID,appid);
                    NSString * appId=[NSString stringWithUTF8String:appid];
                    if ([identifier isEqualToString:appId]) {
//                        processName = [[[NSString alloc] initWithFormat:@"%s", process[i].kp_proc.p_comm] autorelease];
                        processName = [NSString stringWithFormat:@"%s",process[i].kp_proc.p_comm];
                        break;
                    }
 
                }
                free(process);
//                free(newprocess);
            }
        }
    }
    NSLog(@"processName:%@",processName);
    return processName;
}



@end
