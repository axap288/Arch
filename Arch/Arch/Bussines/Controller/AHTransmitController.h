//
//  AHTransmitController.h
//  Arch
//
//  Created by LiuNian on 14-4-29.
//
//

#import <Foundation/Foundation.h>


typedef enum
{
    monitorTarget,
    eventTarget
}sendTarget;

@interface AHTransmitController : NSObject


+(AHTransmitController *)getInstance;

-(void)sendJsonData:(NSString *)jsonstr withTarget:(sendTarget)target;

@end
