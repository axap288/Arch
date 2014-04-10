//
//  AppInfo.h
//  iRDataCollectorForEnterprise
//
//  Created by LiuNian on 13-11-5.
//  Copyright (c) 2013年 LiuNian. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class AppRunTimeInfo;

@interface AppInfo : NSManagedObject
@property (nonatomic, retain) NSString * appName;
@property (nonatomic, retain) NSString * packageName;
@property (nonatomic, retain) NSString * processName;
@property (nonatomic, retain) NSOrderedSet *runTimes;
@end

@interface AppInfo (CoreDataGeneratedAccessors)
- (void)insertObject:(AppRunTimeInfo *)value inRunTimesAtIndex:(NSUInteger)idx;
- (void)removeObjectFromRunTimesAtIndex:(NSUInteger)idx;
- (void)insertRunTimes:(NSArray *)value atIndexes:(NSIndexSet *)indexes;
- (void)removeRunTimesAtIndexes:(NSIndexSet *)indexes;
- (void)replaceObjectInRunTimesAtIndex:(NSUInteger)idx withObject:(AppRunTimeInfo *)value;
- (void)replaceRunTimesAtIndexes:(NSIndexSet *)indexes withRunTimes:(NSArray *)values;
- (void)addRunTimesObject:(AppRunTimeInfo *)value;
- (void)removeRunTimesObject:(AppRunTimeInfo *)value;
- (void)addRunTimes:(NSOrderedSet *)values;
- (void)removeRunTimes:(NSOrderedSet *)values;
@end

