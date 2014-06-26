//
//  ViewController.m
//  owned-RouleTaBille
//
//  Created by Huy on 6/24/14.
//  Copyright (c) 2014 huy. All rights reserved.
//

#import "ViewController.h"
#import "View.h"
#import "ViewModel.h"

@interface ViewController ()

@property (nonatomic, weak) View *mainView;
@property (nonatomic, strong) ViewModel *viewModel;
@property (nonatomic, strong) CMMotionManager *motionManager;

@property (nonatomic, strong) NSTimer *timer;

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    CGRect bounds = [[UIScreen mainScreen] bounds];
    
    self.viewModel = [[ViewModel alloc] initWithBounds:bounds];
    self.viewModel.location = CGPointMake(bounds.origin.x + bounds.size.width / 2,
                                          bounds.origin.y + bounds.size.height / 2);
    [self.viewModel startUpdatingWithInterval:(self.motionManager.deviceMotionUpdateInterval * 10)];

	View *view = [[View alloc] initWithFrame:bounds andViewModel:self.viewModel];
    self.mainView = view;
    [self.view addSubview:view];
    
    _motionManager = [[CMMotionManager alloc] init];
    if (self.motionManager.deviceMotionAvailable) {
        // Default deviceMotionUpdateInteral is 0.01
        //NSLog(@"%f", self.motionManager.deviceMotionUpdateInterval);
        self.motionManager.deviceMotionUpdateInterval = 0.1;
        [self.motionManager startDeviceMotionUpdatesToQueue:[NSOperationQueue mainQueue]
                                                withHandler:^(CMDeviceMotion *motion, NSError *error)
         {
             self.viewModel.gravity = motion.gravity;
             self.mainView.accelerationXLabel.text = [NSString stringWithFormat:@"%.2f", motion.gravity.x];
             self.mainView.accelerationYLabel.text = [NSString stringWithFormat:@"%.2f", motion.gravity.y];
         }];

    }
    
    [self setupRAC];
    
    // Workaround for RAC
    [self startUpdatingWithInterval:(self.motionManager.deviceMotionUpdateInterval * 10)];
}

- (void)setupRAC
{
    // Bind view's backgroundColor to viewModel
    RAC(self.mainView, backgroundColor) = RACObserve(self, viewModel.backgroundColor);
    
    // Bind view's location of bille to viewModel
    RAC(self.mainView, billeLocation) = RACObserve(self, viewModel.location);
    
    // FIXME: This fails to run in my device for some reason.  Workaround: timer below
//    [[RACObserve(self, mainView.deltaXLabel.text) distinctUntilChanged] subscribeNext:^(id x) {
//        NSLog(@"%@", x);
//    }];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)motionEnded:(UIEventSubtype)motion withEvent:(UIEvent *)event {
    // Shaking gesture changes background color
    if (motion == UIEventSubtypeMotionShake) {
        [self.viewModel rotateColors];
    }
}

#pragma mark - Workarounds for ReactiveCocoa crashing app on install

- (void)startUpdatingWithInterval:(NSTimeInterval)interval
{
    if (self.timer) {
        [self.timer invalidate];
    }
    self.timer = [NSTimer scheduledTimerWithTimeInterval:interval
                                                  target:self
                                                selector:@selector(updateView)
                                                userInfo:nil
                                                 repeats:YES];
}


- (void)updateView
{
    self.mainView.positionXLabel.text = [NSString stringWithFormat:@"%.0f", self.viewModel.location.x];
    self.mainView.positionYLabel.text = [NSString stringWithFormat:@"%.0f", self.viewModel.location.y];
    self.mainView.deltaXLabel.text = [NSString stringWithFormat:@"%.0f", self.viewModel.velocity.x];
    self.mainView.deltaYLabel.text = [NSString stringWithFormat:@"%.0f", self.viewModel.velocity.y];
    self.mainView.edgeXLabel.text = [NSString stringWithFormat:@"%@",
                                     (self.viewModel.billeIsAtVerticalEdge ? @"OUI" : @"")];
    self.mainView.edgeYLabel.text = [NSString stringWithFormat:@"%@",
                                     (self.viewModel.billeIsAtHorizontalEdge ? @"OUI" : @"")];
}

@end
