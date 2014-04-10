//
//  IRAssistant.m
//  iRDataCollectorForAppStore
//
//  Created by LiuNian on 13-9-29.
//  Copyright (c) 2013年 LN. All rights reserved.
//

#import "IRAssistant.h"
#import "MBProgressHUD.h"
#import "ASIHTTPRequest.h"
#import "SBJson.h"
#import <QuartzCore/QuartzCore.h>

static UIViewController *viewcontroller;

@implementation IRAssistant

+(void)showProgressHUDMessage:(NSString *)message toVIew:(UIView *)view{
    MBProgressHUD *progress = [MBProgressHUD showHUDAddedTo:view animated:YES];
    if (message) {
        if (progress.isHidden) [progress show:YES];
        progress.labelText = message;
        progress.mode = MBProgressHUDModeCustomView;
        [progress hide:YES afterDelay:1.5];
    } else {
        [progress hide:YES];
    }
}

+(void)addCunstomBackButton:(UIViewController *)vc
{
    viewcontroller = vc;
    [vc.navigationItem setHidesBackButton:YES];
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(25, 5, 22, 20);
    [btn setBackgroundImage:[UIImage imageNamed:@"YB_leftArrows@2x.png"] forState:UIControlStateNormal];
    [btn addTarget: [IRAssistant class] action: @selector(goBackAction) forControlEvents: UIControlEventTouchUpInside];
    UIBarButtonItem *back=[[UIBarButtonItem alloc]initWithCustomView:btn];
    vc.navigationItem.leftBarButtonItem=back;
}

+(void)goBackAction{
    
    CATransition* transition = [CATransition animation];
    transition.duration = 0.3;
    transition.type = kCATransitionFade;
    transition.subtype = kCATransitionFromTop;
    [viewcontroller.navigationController.view.layer addAnimation:transition forKey:kCATransition];
    //    [self.navigationController pushViewController:vc animated:NO];
    [viewcontroller.navigationController popViewControllerAnimated:NO];
}



// 解析JSON
+ (id)getJsonValue:(NSString *)string {
    SBJsonParser *jsonParser = [SBJsonParser new];
    id repr = [jsonParser objectWithString:string];
    if (!repr)
        NSLog(@"-JSONValue failed. Error trace is: %@",[jsonParser error]);
    return repr;
} 

// 生成JSON
+ (NSString *)makeJsonString:(id)objects {
    SBJsonWriter *jsonWriter = [SBJsonWriter new];
    NSString *json = [jsonWriter stringWithObject:objects];
    if (!json)
        NSLog(@"-JSONRepresentation failed. Error trace is: %@", [jsonWriter error]);
    return json;
}

+(NSString *)getPropertyWithKey:(NSString *)key
{
    NSString *plistPath = [[NSBundle mainBundle] pathForResource:PROPERTY_FILE ofType:@"plist"];
    NSDictionary *dictionary = [[NSDictionary alloc] initWithContentsOfFile:plistPath];
    return [dictionary objectForKey:key];
}

+(NSString *)getDateFormateYYMMDD
{
    NSDateFormatter*dateFormatter =[[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyyMMdd"];
    NSString *ts =[dateFormatter stringFromDate:[NSDate date]];
    return ts;
}

+(NSString *)serverRequest:(NSString *)url
{
    MBProgressHUD *progress ;
//    [SVProgressHUD show];
    
    NSURL *targetUrl = [NSURL URLWithString:url];
    ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:targetUrl];
    [request setTimeOutSeconds:30];
    [request addRequestHeader:@"Content-Type" value:@"application/xml;charset=gb2312;"];
    [request startSynchronous];
    NSError *error = [request error];
    if (!error) {
//        [progress hide:YES];
        NSData *data = [request responseData];
        NSStringEncoding enc = CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingGB_18030_2000);
        NSString *str =[[NSString alloc] initWithData:data encoding:enc];
        // 以下一句很重要，将目标地址的页面编码变成utf-8,否则页面解析不成功
        //        str =  [str stringByReplacingOccurrencesOfString:@"gb2312" withString:@"utf-8"];
        return str;
    }else{
//        [SVProgressHUD showErrorWithStatus:@"网络请求失败，请稍候再试"];
//        progress.labelText = @"网络请求失败，请稍候再试";
//        progress.mode = MBProgressHUDModeCustomView;
//        [progress hide:YES afterDelay:1.5];
        NSLog(@"%@",error);
        //如果因为发生error错误，则返回error，调用者根据error做相应处理
    }
    return nil;
}

//单位转换
+(NSString *)bytesToAvaiUnit:(int)bytes
{
    if(bytes < 1024)     // B
    {
        return [NSString stringWithFormat:@"%dB", bytes];
    }
    else if(bytes >= 1024 && bytes < 1024 * 1024) // KB
    {
        return [NSString stringWithFormat:@"%.1fKB", (double)bytes / 1024];
    }
    else if(bytes >= 1024 * 1024 && bytes < 1024 * 1024 * 1024)   // MB
    {
        return [NSString stringWithFormat:@"%.2fMB", (double)bytes / (1024 * 1024)];
    }
    else    // GB
    {
        return [NSString stringWithFormat:@"%.3fGB", (double)bytes / (1024 * 1024 * 1024)];
    }
}

//取整点时间
+ (NSDate *)getNextIntegralHourDate{
    
    NSDate *date = [NSDate dateWithTimeIntervalSinceNow:60*60];
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *comps = [calendar components: NSEraCalendarUnit |NSYearCalendarUnit | NSMonthCalendarUnit| NSDayCalendarUnit| NSHourCalendarUnit | NSMinuteCalendarUnit fromDate: date];
    [comps setMinute:00];
    return [calendar dateFromComponents:comps];
}

@end
