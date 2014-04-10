//
//  DeviceFlowRateInfo.h
//  iRDataCollectorForEnterprise
//
//  Created by LiuNian on 14-1-21.
//  Copyright (c) 2014年 LiuNian. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface DeviceFlowRateInfo : NSManagedObject

@property (nonatomic, retain) NSString * carrier;
@property (nonatomic, retain) NSString * hour;
@property (nonatomic, retain) NSString * netType;
@property (nonatomic, retain) NSString * recFlow;
@property (nonatomic, retain) NSString * sendFlow;
@property (nonatomic, retain) NSString * ssid;
@property (nonatomic, retain) NSString * ts;

@end
