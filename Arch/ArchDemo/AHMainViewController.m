//
//  AHMainViewController.m
//  Arch
//
//  Created by LiuNian on 14-4-29.
//
//

#import "AHMainViewController.h"
#import "Arch.h"

@interface AHMainViewController ()
@property (nonatomic,strong) Arch *arch;
@end

@implementation AHMainViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.arch = [[Arch alloc] init];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(IBAction)clickStartMonitorAction:(id)sender
{
    [self.arch startMonitor];
}

-(IBAction)clickStopMonitorAction:(id)sender
{
    [self.arch stopMonitor];

}

@end
