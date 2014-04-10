//
//  IRsysMonitor.h
//  iResearcher
//
//  Created by liu nian on 13-6-25.
//  Copyright (c) 2013年 Liunian. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface IRsysMonitor : NSObject 

+(NSString *)getActiveAppsBySpringBoard;

+(NSString *)getProcessNameByIdentifier:(NSString *)identifier;

+(NSString *)getAppNameByIdentifier:(NSString *)identifier;


@end
