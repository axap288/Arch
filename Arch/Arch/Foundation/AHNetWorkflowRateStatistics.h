//
//  IRNetWorkflowRateStatistics.h
//  iRDataCollectorForAppStore
//
//  Created by LiuNian on 13-9-29.
//  Copyright (c) 2013年 LN. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AHSysInfo.h"

@interface AHNetWorkflowRateStatistics : NSObject
{
    int wifiSent;
    int wifiReceived;
    int wwanSent;
    int wwanReceived;
}

-(void)startWork;

@end
