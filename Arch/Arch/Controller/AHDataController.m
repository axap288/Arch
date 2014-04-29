//
//  AHDataController.m
//  Arch
//
//  Created by LiuNian on 14-4-29.
//
//

#import "AHDataController.h"

@implementation AHDataController

+(AHDataController *)shareInstance
{
    static AHDataController *instance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[AHDataController alloc] init];
    });
    return instance;
}

- (id)init
{
    self = [super init];
    if (self) {
        
    }
    return self;
}

-(void)dataStore:(NSDictionary *)data
{
    
}

@end
