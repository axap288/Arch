//
//  AppInfo.m
//  iRDataCollectorForEnterprise
//
//  Created by LiuNian on 13-11-5.
//  Copyright (c) 2013年 LiuNian. All rights reserved.
//

#import "AppInfo.h"
#import "AppRunTimeInfo.h"



@implementation AppInfo

@dynamic appName;
@dynamic packageName;
@dynamic processName;
@dynamic runTimes;

@end

@implementation AppInfo(CoreDataGeneratedAccessors)

- (void)insertObject:(AppRunTimeInfo *)value inRunTimesAtIndex:(NSUInteger)idx
{
    NSArray *array =  [self.runTimes array];
    if (!array) {
       NSLog(@"array is null");
        return;
    }
    NSMutableArray *temp = [NSMutableArray arrayWithArray:array];
    [temp insertObject:value atIndex:idx];
    self.runTimes = [NSOrderedSet orderedSetWithArray:temp];
}

- (void)replaceObjectInRunTimesAtIndex:(NSUInteger)idx withObject:(AppRunTimeInfo *)value
{
    NSArray *array =  [self.runTimes array];
    NSMutableArray *temp = [NSMutableArray arrayWithArray:array];
    [temp replaceObjectAtIndex:idx withObject:value];
    self.runTimes = [NSOrderedSet orderedSetWithArray:temp];
}


@end
