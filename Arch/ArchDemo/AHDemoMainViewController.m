//
//  AHMainViewController.m
//  Arch
//
//  Created by LiuNian on 14-4-29.
//
//

#import "AHDemoMainViewController.h"
#import "ArchTracker.h"
#import "AHDataController.h"
#import "UIViewController+MMDrawerController.h"


@interface AHDemoMainViewController ()
@property (nonatomic,strong) ArchTracker *archTracker;
@end

@implementation AHDemoMainViewController

-(id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.archTracker = [ArchTracker shareInstanceWithAppid:@"ArchDemo"];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"汽车之家";
//    self.view = [[UIView alloc] initWithFrame:self.view.bounds];
//    [self.view setBackgroundColor:[UIColor whiteColor]];

    self.edgesForExtendedLayout = UIRectEdgeNone;
//    self.extendedLayoutIncludesOpaqueBars = NO;
//    self.modalPresentationCapturesStatusBarAppearance = NO;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(IBAction)clickStartMonitorAction:(id)sender
{
    [self.archTracker startMonitor];
}

-(IBAction)clickStopMonitorAction:(id)sender
{
    [self.archTracker stopMonitor];

}

-(void)viewDidAppear:(BOOL)animated
{
    
}

-(UIStatusBarStyle)preferredStatusBarStyle{
    if(self.mm_drawerController.showsStatusBarBackgroundView){
        return UIStatusBarStyleLightContent;
    }
    else {
        return UIStatusBarStyleDefault;
    }
}

@end
