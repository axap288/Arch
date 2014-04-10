//
//  IRCoreDataManager.m
//  iRDataCollectorForEnterprise
//
//  Created by LiuNian on 13-11-5.
//  Copyright (c) 2013年 LiuNian. All rights reserved.
//

#import "IRCoreDataManager.h"
#import "IRFileTool.h"
#import "AppRunTimeInfo.h"
#import "AppInfo.h"
#import "LocationInfo.h"
#import "DeviceFlowRateInfo.h"
#import "IRConstant.h"
#import <CoreData/CoreData.h>

static IRCoreDataManager *coreDataManager;


@interface IRCoreDataManager()
@property (nonatomic,strong) NSManagedObjectContext *managedObjectContext;
@property (nonatomic,strong) NSPersistentStoreCoordinator *persistentStoreCoordinator;
@property (nonatomic,strong) NSManagedObjectModel *managedObjectModel;
- (void) createManagedObjectContext ;
@end

@implementation IRCoreDataManager


+(IRCoreDataManager *)shareInstance
{
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        coreDataManager = [[IRCoreDataManager alloc] init];
    });
    return coreDataManager;
}

-(id)init
{
    self = [super init];
    if (self) {
        [self createManagedObjectContext];
    }
    return self;
}

-(void)saveAppInfoUseCDWithPackageName:(NSString *)packageName AppName:(NSString *)appName processName:(NSString *)processName
{
    static NSString *saveRequest = @"saveRequest";
    @synchronized (saveRequest){
        __strong  NSError *error;
        
        NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
        NSPredicate* predicate = [NSPredicate predicateWithFormat:@"packageName = %@",packageName];
        NSEntityDescription *entity =  [NSEntityDescription entityForName:@"AppInfo" inManagedObjectContext:self.managedObjectContext];
        [fetchRequest setEntity:entity];
        [fetchRequest setPredicate:predicate];
        NSArray *apps = [self.managedObjectContext executeFetchRequest:fetchRequest error:&error];
        if([apps count] != 0)
        {
            return;
        }
    
    AppInfo *appinfo = [NSEntityDescription insertNewObjectForEntityForName:@"AppInfo" inManagedObjectContext:self.managedObjectContext];
    appinfo.packageName = packageName;
    appinfo.appName = appName;
    appinfo.processName = processName;
    [self save];
    }
}

-(void)saveAppRunInfo:(NSString *)packageName AppName:(NSString *)appName processName:(NSString *)processName startTime:(NSString *)startTime  endTime:(NSString *)endTime
{
     static NSString *saveRequest = @"saveRequest";
    @synchronized (saveRequest){
        __strong  NSError *error;
        
        NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
        NSPredicate* predicate = [NSPredicate predicateWithFormat:@"packageName = %@",packageName];
        NSEntityDescription *entity =  [NSEntityDescription entityForName:@"AppInfo" inManagedObjectContext:self.managedObjectContext];
        [fetchRequest setEntity:entity];
        [fetchRequest setPredicate:predicate];
        NSArray *apps = [self.managedObjectContext executeFetchRequest:fetchRequest error:&error];
        if([apps count] != 0)
        {
            return;
        }
    
    AppInfo *appinfo = [NSEntityDescription insertNewObjectForEntityForName:@"AppInfo" inManagedObjectContext:self.managedObjectContext];
    appinfo.packageName = packageName;
    appinfo.appName = appName;
    appinfo.processName = processName;
    
    NSArray *array = [[appinfo runTimes] array];
    if (array == nil || [array count] == 0) {
        return;
    }
    AppRunTimeInfo *info = [AppRunTimeInfo new];
    [info setStart_time:startTime];
    [info setEnd_time:endTime];
    NSInteger startTimeInt =  [info.start_time integerValue];
    NSInteger endTimeInt = [endTime integerValue];
    NSInteger timeInterval = endTimeInt - startTimeInt;
    NSNumber *timeBetweenNumber =  [NSNumber numberWithInteger:timeInterval];
    [info setDuration:timeBetweenNumber];
    
    //todo
    [appinfo addRunTimesObject:info];
    
    [self save];
    }
}

-(void)saveRunTimeInfoUseCDWithPackageName:(NSString *)packageName startTime:(NSString *)starttime endTime:(NSString *)endTime duration:(NSNumber*)duration
{
    static NSString *saveRequest = @"saveRequest";
    @synchronized (saveRequest){
        AppInfo *appinfo = [self getAppUsePackageName:packageName];
    //插入APPRunTimeInfo
        AppRunTimeInfo *runTimeInfo = [NSEntityDescription insertNewObjectForEntityForName:@"AppRunTimeInfo" inManagedObjectContext:self.managedObjectContext];
        runTimeInfo.start_time = starttime;
        runTimeInfo.end_time = endTime;
        if (duration) {
            runTimeInfo.duration = duration;
        }
        
        [appinfo insertObject:runTimeInfo inRunTimesAtIndex:0];
        [self save];
    }
}

-(void)updateEndTime:(NSString *)packageName endTime:(NSString *)endTime
{
    @synchronized (self){
        AppInfo *appinfo = [self getAppUsePackageName:packageName];
        NSArray *array = [[appinfo runTimes] array];
        if (array == nil || [array count] == 0) {
            return;
        }
        AppRunTimeInfo *info = (AppRunTimeInfo *)[array objectAtIndex:0];
        [info setEnd_time:endTime];
        
        //计算运行时间
        /*
         NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
         [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
         NSDate *start = [ formatter dateFromString:info.start_time];
         NSDate *end = [formatter dateFromString:endTime];
         //计算间隔时间
         NSTimeInterval timeBetween = [end timeIntervalSinceDate:start];
         NSNumber *timeBetweenNumber =  [NSNumber numberWithFloat:timeBetween];
         //    NSString *timeIntervalStr = [NSString stringWithFormat:@"%f",timeBetween];
         [info setDuration:timeBetweenNumber];
         //    [metadata setObject:timeBetweenNumber forKey:@"duration"];
         */
        NSInteger startTimeInt =  [info.start_time integerValue];
        NSInteger endTimeInt = [endTime integerValue];
        NSInteger timeInterval = endTimeInt - startTimeInt;
        NSNumber *timeBetweenNumber =  [NSNumber numberWithInteger:timeInterval];
        [info setDuration:timeBetweenNumber];
        
        [appinfo replaceObjectInRunTimesAtIndex:0 withObject:info];
    }
}

-(NSArray *)getAPPsInfo
{
    static NSString *fetchRequest = @"fetchRequest";
    NSMutableArray *array = [NSMutableArray array];
    //加同步锁
    @synchronized (fetchRequest){
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity =  [NSEntityDescription entityForName:@"AppInfo" inManagedObjectContext:self.managedObjectContext];
    [fetchRequest setEntity:entity];
    
     __block NSArray *apps;
//     [self.managedObjectContext performBlockAndWait:^{
         __strong  NSError *error;
          apps = [self.managedObjectContext executeFetchRequest:fetchRequest error:&error];
//     }];
    
      for (NSManagedObject *app in apps) {
        //在appname中可能会含有‘(null)’在原因不明的情况下过滤掉含有(null)的数据项
        if (![((AppInfo *)app).appName isEqualToString:@"(null)"]) {
            [array addObject:app];
        }
    }
    }
    return array;
}

-(NSArray *)getAPPRunTimesInfo:(NSString *)packageName
{
    static NSString *fetchRequest = @"fetchRequest";
    @synchronized (fetchRequest){
    NSMutableArray *array = [NSMutableArray array];
    AppInfo *appinfo = [self getAppUsePackageName:packageName];
    NSOrderedSet *set = [appinfo runTimes];
    
    [set enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        AppRunTimeInfo *ati = (AppRunTimeInfo *)obj;
        [array addObject:ati];
    }];
    return array;
    }
}

-(AppInfo*)getAppUsePackageName:(NSString *)packageName
{
    static NSString *fetchRequest = @"fetchRequest";
    @synchronized (fetchRequest){
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSPredicate* predicate = [NSPredicate predicateWithFormat:@"packageName = %@",packageName];
    NSEntityDescription *entity =  [NSEntityDescription entityForName:@"AppInfo" inManagedObjectContext:self.managedObjectContext];
    [fetchRequest setEntity:entity];
    [fetchRequest setPredicate:predicate];
    
    __block NSArray *apps;
//     [self.managedObjectContext performBlockAndWait:^{
         __strong  NSError *error;
          apps = [self.managedObjectContext executeFetchRequest:fetchRequest error:&error];
//     }];
    
    if (apps != nil && [apps count] != 0) {
        AppInfo *appinfo = [apps objectAtIndex:0];
        return appinfo;
    }
    }
    return nil;
}

-(void)removeAllAppInfos
{
    static NSString *deleteRequest = @"deleteRequest";
    @synchronized(deleteRequest){
        NSArray *array = [self getAPPsInfo];
        if (array != nil && [array count] != 0) {
            for(AppInfo *info in array) {
                [self.managedObjectContext deleteObject:info];
                //           DDLogInfo(@"删除完成!");
            }
        }
    }
}
-(void)removeAllAppRunTimes
{
    static NSString *deleteAllAppRunTimesRequest = @"deleteAllAppRunTimesRequest";
    @synchronized(deleteAllAppRunTimesRequest){
        NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
        NSEntityDescription *entity =  [NSEntityDescription entityForName:@"AppRunTimeInfo" inManagedObjectContext:self.managedObjectContext];
        [fetchRequest setEntity:entity];
        __strong  NSError *error;
        NSArray *apps = [self.managedObjectContext executeFetchRequest:fetchRequest error:&error];
        if (apps != nil && [apps count] != 0) {
            for (AppRunTimeInfo *info in apps) {
                //开始时间与结束时间相同表示此条目还在等待记录，不予删除
//                if (![info.start_time isEqualToString:info.end_time]) {
                    [self.managedObjectContext deleteObject:info];
//                }
//                //           DDLogInfo(@"删除完成");
            }
        }
    }
}


//保存一个位置信息

-(void)saveNewLocationWithLatitude:(float)latitude andLongitude:(float)longitude
{
    @synchronized(self){
    LocationInfo *info = [NSEntityDescription insertNewObjectForEntityForName:@"LocationInfo" inManagedObjectContext:self.managedObjectContext];
    info.jingdu = [NSNumber numberWithDouble:longitude];
    info.weidu = [NSNumber numberWithDouble:latitude];
    [self save];
    }
}

//获取所有的地理位置信息
-(NSArray *)getAllLocationInfo
{
    @synchronized(self){
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity =  [NSEntityDescription entityForName:@"LocationInfo" inManagedObjectContext:self.managedObjectContext];
    [fetchRequest setEntity:entity];
    
    __block NSArray *locations;
//    [self.managedObjectContext performBlockAndWait:^{
        __strong  NSError *error;
        locations = [self.managedObjectContext executeFetchRequest:fetchRequest error:&error];
//    }];

//   DDLogInfo(@"locations count:%d",[locations count]);
    return locations;
    }
}

-(void)saveNetFlowInfo:(NSDictionary *)netflowDic
{
    static NSString *saveRequest = @"saveRequest";
    @synchronized(saveRequest){
    DeviceFlowRateInfo *info = [NSEntityDescription insertNewObjectForEntityForName:@"DeviceFlowRateInfo" inManagedObjectContext:self.managedObjectContext];
    info.netType = [netflowDic objectForKey:@"net_type"];
    info.sendFlow = [netflowDic objectForKey:@"send_flow"];
    info.recFlow = [netflowDic objectForKey:@"rec_flow"];
    info.hour = [netflowDic objectForKey:@"hour"];
    info.ssid =  [netflowDic objectForKey:@"ssid"];
    info.carrier =  [netflowDic objectForKey:@"carrier"];
    info.ts = [netflowDic objectForKey:@"ts"];
    [self save];
    }
}

-(NSArray *)getAllNetFlowInfo
{
    static NSString *getAllNetFlowInfoRequest = @"getAllNetFlowInfoRequest";
    @synchronized(getAllNetFlowInfoRequest)
    {
        NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
        NSEntityDescription *entity =  [NSEntityDescription entityForName:@"DeviceFlowRateInfo" inManagedObjectContext:self.managedObjectContext];
        [fetchRequest setEntity:entity];
        
         NSArray *locations;
        //    [self.managedObjectContext performBlockAndWait:^{
        NSError *error;
        locations = [self.managedObjectContext executeFetchRequest:fetchRequest error:&error];
        //    }];
        return locations;
    }

}

-(void)removeAllLocationInfo
{
        static NSString *removeAllLocationInfoRequest = @"removeAllLocationInfoRequest";
    @synchronized(removeAllLocationInfoRequest){
        NSArray *array = [self getAllLocationInfo];
        if (array != nil && [array count] != 0) {
            for(LocationInfo *info in array) {
                [self.managedObjectContext deleteObject:info];
                //           DDLogInfo(@"地理位置删除完成!");
            }
        }
    }

}


-(void)removeAllNetFlowInfo
{
    static NSString *removeAllNetFlowInfoRequest = @"removeAllNetFlowInfoRequest";
    @synchronized(removeAllNetFlowInfoRequest){
        NSArray *array = [self getAllNetFlowInfo];
        if (array != nil && [array count] != 0 ) {
            for (DeviceFlowRateInfo *info in array) {
                [self.managedObjectContext deleteObject:info];
//             DDLogInfo(@"网络流量删除完成");
            }
        }
//      [(NSArray *)[self getAllNetFlowInfo] count];
       DDLogInfo(@"netflow 删除后的数值: %d",[(NSArray *)[self getAllNetFlowInfo] count]);
    }
}

#pragma  mark -
- (void) createManagedObjectContext {
    
    //如果已经有这个对象，就直接返回，否则继续
    if (self.managedObjectContext != nil) {
        return;
    }
    
    [self createPersistentStoreCoordinator];
    if (self.persistentStoreCoordinator != nil) {
        self.managedObjectContext = [[NSManagedObjectContext alloc] init];
        [self.managedObjectContext setPersistentStoreCoordinator: self.persistentStoreCoordinator];
        //这里可以看到，“内容管理器”和“数据一致性存储器”的关系，
        //managedObjectContext需要得到这个“数据一致性存储器”
    }
    //    return self.managedObjectContext;
}

- (void)createPersistentStoreCoordinator {
    
    if (self.persistentStoreCoordinator != nil) {
        return ;
    }
    
    //定义一个本地地址到NSURL，用来存储那个SQLite文件
    //    NSURL *storeUrl = [NSURL fileURLWithPath:
    //                       [[self applicationDocumentsDirectory]
    //                        stringByAppendingPathComponent: @"Locations.sqlite"]];
    
    NSURL *storeUrl = [NSURL fileURLWithPath:[IRFileTool getFullPath:@"Model.sqlite"]];
	NSError *error;
    [self createManagedObjectModel];
    self.persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc]
                                       initWithManagedObjectModel: self.managedObjectModel];
    //从这里可以看出，其实persistentStoreCoordinator需要的不过是一个
    //存储数据的位置，它是负责管理CoreData如何储存数据的
    if (![self.persistentStoreCoordinator
          addPersistentStoreWithType:NSSQLiteStoreType
          configuration:nil
          URL:storeUrl
          options:nil
          error:&error]) {
        // Handle the error
       DDLogInfo(@"error:%@",error);
    }
    
}

- (void)createManagedObjectModel {
    if (self.managedObjectModel != nil) {
        return;
    }
//    NSMutableSet *allBundles = [[NSMutableSet alloc] init];
//    [allBundles addObjectsFromArray: [NSBundle allBundles]];
//    [allBundles addObjectsFromArray: [NSBundle allFrameworks]];
//    NSBundle *bundle = [NSBundle ]
    NSString *bundlePath =  [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent: @"IRDataCollectorLib.bundle"];
    NSBundle *bundle = [NSBundle bundleWithPath: bundlePath];
    NSURL *modelURL = [bundle URLForResource:@"Model" withExtension:@"mom"];
//    self.managedObjectModel = [NSManagedObjectModel mergedModelFromBundles:[allBundles allObjects]];
    self.managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    //从本地所有xcdatamodel文件得到这个CoreData数据模板;
}

-(void)save
{
        __strong  NSError *error;
        if (![self.managedObjectContext save:&error]) {
           DDLogInfo(@"ERROR: couldn't save: %@", [error localizedDescription]);
        }
}

@end
