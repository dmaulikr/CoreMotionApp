//
//  ViewController.m
//  CoreMotionApp
//
//  Created by Mac Book on 9/3/12.
//  Copyright (c) 2012 Nick. All rights reserved.
//

#import "ViewController.h"
#import "Drawing.h"
#import "movingBall.h"
#import <QuartzCore/QuartzCore.h>
#import <CoreMotion/CoreMotion.h>


@interface ViewController () {
    CMAttitude *referenceAttitude;
}

@end

@implementation ViewController

-(void)loadView {
    Drawing *view = [[Drawing alloc] init];
    self.view = view;
    [view setBackgroundColor:[UIColor whiteColor]];
    CMMotionManager *motionManager = [[CMMotionManager alloc] init];
    [motionManager startDeviceMotionUpdates];
    CMAttitude *attitude = [[CMAttitude alloc] init];
    NSLog(@"%f", attitude.pitch);
}


- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
}

@end
