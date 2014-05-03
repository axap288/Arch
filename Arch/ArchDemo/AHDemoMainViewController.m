//
//  AHMainViewController.m
//  Arch
//
//  Created by LiuNian on 14-4-29.
//
//

#import "AHDemoMainViewController.h"
#import "Arch.h"
#import "AHDataController.h"
#import "UIViewController+MMDrawerController.h"


@interface AHDemoMainViewController ()
@property (nonatomic,strong) Arch *arch;
@end

@implementation AHDemoMainViewController

-(id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.arch = [Arch shareInstanceWithAppid:@"ArchDemo"];
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
    [self.arch startMonitor];
}

-(IBAction)clickStopMonitorAction:(id)sender
{
    [self.arch stopMonitor];

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
