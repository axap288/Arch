//
//  IRSysInfo.m
//  iRDataCollectorForAppStore
//
//  Created by LN on 13-9-18.
//  Copyright (c) 2013年 LN. All rights reserved.
//

#import <CoreTelephony/CTTelephonyNetworkInfo.h>
#import <CoreTelephony/CTCarrier.h>
#import "IRSysInfo.h"
#import "OpenUDID.h"
#import "IOPowerSources.h"
#import "IOPSKeys.h"
#import <AdSupport/ASIdentifierManager.h>


@implementation IRSysInfo

+(NSString *)getUDID
{
    return [OpenUDID value];
}

+(NSString *)getDeviceName
{
    
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        return [[UIDevice currentDevice] systemName];
    }else{
        return  @"iPad";
    }
    
    return [[UIDevice currentDevice] name];
}

+(NSString *)getSystemVersion
{
    return [[UIDevice currentDevice] systemVersion];
}

+(NSString *)getDeviceSerial
{
//    return  [[UIDevice currentDevice] uniqueIdentifier];
    return [OpenUDID value];
}

+(NSString *)getUserName
{
    return [[UIDevice currentDevice] name];
}

+(NSString *)getWifiSendTraffic
{
    NSArray *array = [IRSysInfo getDataCounters];
    int wifiSendValue = [(NSNumber*) [array objectAtIndex:0 ] intValue];
    return  [NSString stringWithFormat:@"%i",wifiSendValue];
}

+(NSString *)getWifiReviceTraffic
{
    NSArray *array = [IRSysInfo getDataCounters];
    int wifireceivedValue = [(NSNumber*) [array objectAtIndex:1 ] intValue];
    return  [NSString stringWithFormat:@"%i",wifireceivedValue];
}

+(NSString *)getMobileSendTraffic
{
    NSArray *array = [IRSysInfo getDataCounters];
    int wwanSendValue = [(NSNumber*) [array objectAtIndex:2 ] intValue];
    return  [NSString stringWithFormat:@"%i",wwanSendValue];
 
}

+(NSString *)getMobileReviceTraffic
{
    NSArray *array = [IRSysInfo getDataCounters];
    int wwanReceivedValue = [(NSNumber*) [array objectAtIndex:3 ] intValue];
    return  [NSString stringWithFormat:@"%i",wwanReceivedValue];
 
}

+(NSString *)getMacWithMD5
{
    NSString *macAddr = [IRSysInfo getMacAddress:FALSE];
    const char *original_str = [macAddr UTF8String];
    unsigned char result[CC_MD5_DIGEST_LENGTH];
    CC_MD5(original_str, strlen(original_str), result);
    NSMutableString *hash = [NSMutableString string];
    for (int i = 0; i < 16; i++)
        [hash appendFormat:@"%02X", result[i]];
    return [hash uppercaseString];
}

+ (NSArray *)getDataCounters
{
    BOOL   success;
    struct ifaddrs *addrs;
    const struct ifaddrs *cursor;
    const struct if_data *networkStatisc;
    int WiFiSent = 0;
    int WiFiReceived = 0;
    int WWANSent = 0;
    int WWANReceived = 0;
    NSString *name;;
    success = getifaddrs(&addrs) == 0;
    if (success)
    {
        cursor = addrs;
        while (cursor != NULL)
        {
            name=[NSString stringWithFormat:@"%s",cursor->ifa_name];
//            NSLog(@"ifa_name %s == %@\n", cursor->ifa_name,name);
            // names of interfaces: en0 is WiFi ,pdp_ip0 is WWAN
            if (cursor->ifa_addr->sa_family == AF_LINK)
            {
                if ([name hasPrefix:@"en"])
                {
                    networkStatisc = (const struct if_data *) cursor->ifa_data;
                    WiFiSent+=networkStatisc->ifi_obytes;
                    WiFiReceived+=networkStatisc->ifi_ibytes;
//                    NSLog(@"WiFiSent %d ==%d",WiFiSent,networkStatisc->ifi_obytes);
//                    NSLog(@"WiFiReceived %d ==%d",WiFiReceived,networkStatisc->ifi_ibytes);
                }
                if ([name hasPrefix:@"pdp_ip"])
                {
                    networkStatisc = (const struct if_data *) cursor->ifa_data;
                    WWANSent+=networkStatisc->ifi_obytes;
                    WWANReceived+=networkStatisc->ifi_ibytes;
//                    NSLog(@"WWANSent %d ==%d",WWANSent,networkStatisc->ifi_obytes);
//                    NSLog(@"WWANReceived %d ==%d",WWANReceived,networkStatisc->ifi_ibytes);
                } }
            cursor = cursor->ifa_next;
        }
        freeifaddrs(addrs);
    }
    return [NSArray arrayWithObjects:[NSNumber numberWithInt:WiFiSent],
            [NSNumber numberWithInt:WiFiReceived],
            [NSNumber numberWithInt:WWANSent],
            [NSNumber numberWithInt:WWANReceived], nil];
    
}

+(BOOL)isJailbroken
{
    BOOL jailbroken = NO;
    NSString *cydiaPath = @"/Applications/Cydia.app";
    NSString *aptPath = @"/private/var/lib/apt/";
    if ([[NSFileManager defaultManager] fileExistsAtPath:cydiaPath]) {
        jailbroken = YES;
    }
    if ([[NSFileManager defaultManager] fileExistsAtPath:aptPath]) {
        jailbroken = YES;
    }
    return jailbroken;
}

+(NSString *)getCarrierName
{
    CTTelephonyNetworkInfo *netInfo =[[CTTelephonyNetworkInfo alloc] init];
    CTCarrier *carrier = [netInfo subscriberCellularProvider];
    if(carrier != nil)
    {
        return  [carrier carrierName];
    }
    else
    {
        return @"--";

    }
}

+(NSString *)getCountryCode
{
    CTTelephonyNetworkInfo *netInfo =[[CTTelephonyNetworkInfo alloc] init];
    CTCarrier *carrier = [netInfo subscriberCellularProvider];
    if(carrier != nil)
    {
        return  [carrier mobileCountryCode];
    }
    else
    {
        return @"--";
    }
}

+(NSString *)getMacAddress:(BOOL)useSemicolon
{
    int                 mib[6];
    size_t              len;
    char                *buf;
    unsigned char       *ptr;
    struct if_msghdr    *ifm;
    struct sockaddr_dl  *sdl;
    
    mib[0] = CTL_NET;
    mib[1] = AF_ROUTE;
    mib[2] = 0;
    mib[3] = AF_LINK;
    mib[4] = NET_RT_IFLIST;
    
    if ((mib[5] = if_nametoindex("en0")) == 0) {
        printf("Error: if_nametoindex error\n");
        return @"-1";
    }
    
    if (sysctl(mib, 6, NULL, &len, NULL, 0) < 0) {
        printf("Error: sysctl, take 1\n");
        return @"-1";
    }
    
    if ((buf = malloc(len)) == NULL) {
        printf("Could not allocate memory. error!\n");
        return @"-1";
    }
    
    if (sysctl(mib, 6, buf, &len, NULL, 0) < 0) {
        printf("Error: sysctl, take 2");
        free(buf);
        return @"-1";
    }
    
    ifm = (struct if_msghdr *)buf;
    sdl = (struct sockaddr_dl *)(ifm + 1);
    ptr = (unsigned char *)LLADDR(sdl);
    NSString *outstring;
    if(useSemicolon)
        outstring = [NSString stringWithFormat:@"%02X:%02X:%02X:%02X:%02X:%02X",
                     *ptr, *(ptr+1), *(ptr+2), *(ptr+3), *(ptr+4), *(ptr+5)];
    else
        outstring = [NSString stringWithFormat:@"%02X%02X%02X%02X%02X%02X",
                     *ptr, *(ptr+1), *(ptr+2), *(ptr+3), *(ptr+4), *(ptr+5)];
    
    free(buf);
    
    return outstring;
}


+(NSString *)getUnixTimeStamp:(NSDate *)date
{
   return [NSString stringWithFormat:@"%d", (int)[date timeIntervalSince1970]];
}

/*
+ (double) batteryLevel
{
    
//    UIDevice *device = [UIDevice currentDevice];
//    return device.batteryLevel;
    
    CFTypeRef blob = IOPSCopyPowerSourcesInfo();
    CFArrayRef sources = IOPSCopyPowerSourcesList(blob);
    
    CFDictionaryRef pSource = NULL;
    const void *psValue;
    
    int numOfSources = CFArrayGetCount(sources);
    if (numOfSources == 0) {
        CFRelease(blob);
        CFRelease(sources);
        NSLog(@"Error in CFArrayGetCount");
        return -1.0f;
    }
    
    for (int i = 0 ; i < numOfSources ; i++)
    {
        pSource = IOPSGetPowerSourceDescription(blob, CFArrayGetValueAtIndex(sources, i));
        if (!pSource) {
            NSLog(@"Error in IOPSGetPowerSourceDescription");
            return -1.0f;
        }
//        psValue = (CFStringRef)CFDictionaryGetValue(pSource, CFSTR(kIOPSNameKey));
        
        int curCapacity = 0;
        int maxCapacity = 0;
        double percent;
        
        psValue = CFDictionaryGetValue(pSource, CFSTR(kIOPSCurrentCapacityKey));
        CFNumberGetValue((CFNumberRef)psValue, kCFNumberSInt32Type, &curCapacity);
        
        psValue = CFDictionaryGetValue(pSource, CFSTR(kIOPSMaxCapacityKey));
        CFNumberGetValue((CFNumberRef)psValue, kCFNumberSInt32Type, &maxCapacity);
        
        percent = ((double)curCapacity/(double)maxCapacity * 100.0f);
        
        return percent;
    }
    CFRelease(blob);
    CFRelease(sources);
    return -1.0f;
}
 */

+ (NETWORK_TYPE)dataNetworkTypeFromStatusBar {
    
    UIApplication *app = [UIApplication sharedApplication];
    NSArray *subviews = [[[app valueForKey:@"statusBar"] valueForKey:@"foregroundView"] subviews];
    NSNumber *dataNetworkItemView = nil;
    
    for (id subview in subviews) {
        if([subview isKindOfClass:[NSClassFromString(@"UIStatusBarDataNetworkItemView") class]]) {
            dataNetworkItemView = subview;
            break;
        }
    }
    
    int netType = NETWORK_TYPE_NONE;
    NSNumber * num = [dataNetworkItemView valueForKey:@"dataNetworkType"];
    if (num == nil) {
        
        netType = NETWORK_TYPE_NONE;
        
    }else{
        
        int n = [num intValue];
        if (n == 0) {
            netType = NETWORK_TYPE_NONE;
        }else if (n == 1){
            netType = NETWORK_TYPE_2G;
        }else if (n == 2){
            netType = NETWORK_TYPE_3G;
        }else{
            netType = NETWORK_TYPE_WIFI;
        }
    }
    return netType;
}

+(NSString *)getCFUUID
{
     CFUUIDRef cfuuid = CFUUIDCreate(kCFAllocatorDefault);
    return   (NSString*)CFBridgingRelease(CFUUIDCreateString(kCFAllocatorDefault, cfuuid));
}

+(NSString *)getUUID
{
      if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"6.0")) {
           return [[[UIDevice currentDevice] identifierForVendor] UUIDString];
      }else{
          return @"";
      }
}

+(NSString *)getIDFA
{
    if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"6.0")) {
        return [[[ASIdentifierManager sharedManager] advertisingIdentifier] UUIDString];
    }else{
        return @"";
    }
}

@end
