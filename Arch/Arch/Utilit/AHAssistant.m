//
//  IRAssistant.m
//  iRDataCollectorForAppStore
//
//  Created by LiuNian on 13-9-29.
//  Copyright (c) 2013年 LN. All rights reserved.
//

#import "AHAssistant.h"
#import "MBProgressHUD.h"
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
    //    SBJsonParser *jsonParser = [SBJsonParser new];
    //    id repr = [jsonParser objectWithString:string];
    //    if (!repr)
    //       DDLogInfo(@"-JSONValue failed. Error trace is: %@",[jsonParser error]);
    //    return repr;
    NSError *error = nil;
    NSData *data = [string dataUsingEncoding:NSUTF8StringEncoding];
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:0 error:&error];
    if (error != nil) {
        return nil;
    }
    return dic;
}

// 生成JSON
+ (NSString *)makeJsonString:(id)objects {
    NSError *error = nil;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:objects options:NSJSONWritingPrettyPrinted error:&error];
    if ([jsonData length] > 0 && error == nil){
        return [[NSString alloc] initWithData:jsonData
                                     encoding:NSUTF8StringEncoding];;
    }else{
        return nil;
    }
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

+(BOOL)sendFileToHTTPServer:(NSString *)postURLStr withFilePath:(NSString *)filepath
{
    NSString *fileName = [filepath lastPathComponent];//获取文件名
    NSData *data = [NSData dataWithContentsOfFile:filepath];
    
    NSMutableURLRequest *urlRequest = [[NSMutableURLRequest alloc] init];
    [urlRequest setURL:[NSURL URLWithString:postURLStr]];
    [urlRequest setHTTPMethod:@"POST"];
    
    NSString *myboundary = @"---------------------------14737809831466499882746641449";
    NSString *contentType = [NSString stringWithFormat:@"multipart/form-data; boundary=%@",myboundary];
    [urlRequest addValue:contentType forHTTPHeaderField: @"Content-Type"];
    
    NSMutableData *postData = [NSMutableData data]; //[NSMutableData dataWithCapacity:[data length] + 512];
    [postData appendData:[[NSString stringWithFormat:@"\r\n--%@\r\n", myboundary] dataUsingEncoding:NSUTF8StringEncoding]];
    //    [postData appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"userfile\"; filename=\"%@\"\r\n", fileName]dataUsingEncoding:NSUTF8StringEncoding]];
    [postData appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"file1\"; filename=\"%@\"\r\n", fileName]dataUsingEncoding:NSUTF8StringEncoding]];
    [postData appendData:[@"Content-Type: application/octet-stream\r\n\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
    [postData appendData:[NSData dataWithData:data]];
    [postData appendData:[[NSString stringWithFormat:@"\r\n--%@--\r\n", myboundary] dataUsingEncoding:NSUTF8StringEncoding]];
    
    [urlRequest setHTTPBody:postData];
    NSError *error;
    NSData *returnData = [NSURLConnection sendSynchronousRequest:urlRequest returningResponse:nil error:&error];
    NSString *response = [[NSString alloc] initWithData:returnData encoding:NSUTF8StringEncoding];
    if (!error) {
        if (![response isEqualToString:@"error"]) {
            DDLogInfo(@"[数据处理]:成功发送文件到服务器!");
            return YES;
        }else{
            DDLogInfo(@"[数据处理]:服务器返回消息有错误");
            return NO;
        }
    }else{
        DDLogInfo(@"[数据处理]:发送失败! - error:%@",[error localizedDescription]);
        return NO;
    }
}

+(NSString *)serverRequest:(NSString *)url
{
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:url]
                                                           cachePolicy:NSURLRequestReloadIgnoringLocalAndRemoteCacheData
                                                       timeoutInterval:10];
    [request setHTTPMethod: @"GET"];
    
    NSError *requestError;
    NSURLResponse *urlResponse = nil;
    NSData *response1 = [NSURLConnection sendSynchronousRequest:request returningResponse:&urlResponse error:&requestError];
    if (!requestError) {
        NSStringEncoding enc = CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingGB_18030_2000);
        NSString *str =[[NSString alloc] initWithData:response1 encoding:enc];
        return str;
    }else{
        DDLogInfo(@"%@",requestError);
    }
    return nil;
}

@end
