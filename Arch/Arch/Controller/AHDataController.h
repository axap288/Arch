//
//  AHDataController.h
//  Arch
//
//  Created by LiuNian on 14-4-29.
//
//

#import <Foundation/Foundation.h>

@interface AHDataController : NSObject

+(AHDataController *)shareInstance;

/**
 *  数据存储
 *
 *  @param data
 */
-(void)dataStore:(NSDictionary *)data;

@end
