//
//  AppRunTimeInfo.h
//  iRDataCollectorForEnterprise
//
//  Created by LiuNian on 13-11-5.
//  Copyright (c) 2013年 LiuNian. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface AppRunTimeInfo : NSManagedObject

@property (nonatomic, retain) NSNumber * duration;
@property (nonatomic, retain) NSString * end_time;
@property (nonatomic, retain) NSString * start_time;

@end
