//
//  ViewController.m
//  CoreMotionApp
//
//  Created by Mac Book on 9/3/12.
//  Copyright (c) 2012 Nick. All rights reserved.
//

#import "ViewController.h"
#import "Drawing.h"
#import "BallView.h"
#import "TargetView.h"
#import <QuartzCore/QuartzCore.h>
#import <CoreMotion/CoreMotion.h>


@interface ViewController () 
@property (nonatomic) CMMotionManager *motionManager;
@property (nonatomic) float currentPitch;
@property (nonatomic) float currentRoll;
@property (nonatomic, strong) BallView* ball;
@property (nonatomic, strong) TargetView* target;
@property (nonatomic) BOOL alreadyHasAlert;
@end


@implementation ViewController

-(void)loadView {
    [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:YES];
    
    Drawing *view = [[Drawing alloc] initWithFrame:[[UIScreen mainScreen] applicationFrame]];
    self.view = view;
    [view setBackgroundColor:[UIColor whiteColor]];
    
    [self makeRandomTarget];
    [self resetBall];
       
    self.motionManager = [[CMMotionManager alloc] init];
    [self startMoving];
    [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(moveTarget) userInfo:nil repeats:YES];

    
    }

-(void)getMotionDataWithPitch:(float) pitch withRoll:(float) roll {
    self.currentPitch = pitch;
    self.currentRoll = roll;
    NSLog(@"Pitch is: %f , Roll is %f", self.currentPitch, self.currentRoll);
    [self moveBall];

}

-(void)moveBall{
    
    float speedMultiplier = 5.0;
    
    // NEED TO FIGURE OUT WHY THE BALL STILL ESCAPES AT EACH OF THE FOUR CORNERS //
    if (((self.ball.center.x+self.ball.bounds.size.width/2.0 >= self.view.bounds.size.width) && self.currentRoll >0) || ((self.ball.center.x-self.ball.bounds.size.width/2.0 <= self.view.bounds.origin.x) && self.currentRoll <0)) {
        if (((self.ball.center.y+self.ball.bounds.size.height/2.0 >= self.view.bounds.size.height) && self.currentPitch >0) || ((self.ball.center.y-self.ball.bounds.size.height/2.0 <= self.view.bounds.origin.y) && self.currentPitch <0)) {
            self.ball.center = CGPointMake(self.ball.center.x, self.ball.center.y);
        } else {
        self.ball.center = CGPointMake(self.ball.center.x, self.ball.center.y+self.currentPitch*speedMultiplier);
        }
    } else if (((self.ball.center.y+self.ball.bounds.size.height/2.0 >= self.view.bounds.size.height) && self.currentPitch >0) || ((self.ball.center.y-self.ball.bounds.size.height/2.0 <= self.view.bounds.origin.y) && self.currentPitch <0)) {
        if (((self.ball.center.x+self.ball.bounds.size.width/2.0 >= self.view.bounds.size.width) && self.currentRoll >0) || ((self.ball.center.x-self.ball.bounds.size.width/2.0 <= self.view.bounds.origin.x) && self.currentRoll <0)) {
                self.ball.center = CGPointMake(self.ball.center.x, self.ball.center.y);
        } else {
        self.ball.center = CGPointMake(self.ball.center.x+self.currentRoll*speedMultiplier, self.ball.center.y);
        }
    } else {
        self.ball.center = CGPointMake(self.ball.center.x+self.currentRoll*speedMultiplier, self.ball.center.y+self.currentPitch*speedMultiplier);
    }
    
    NSLog(@"Ball Position is: %f, %f",self.ball.center.x, self.ball.center.y);
    [self.ball setNeedsDisplay];
    [self isBallInTarget];

}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0)
    {
        self.target.center = CGPointMake(arc4random() % ((int) self.view.bounds.size.width - (int) self.target.bounds.size.width/2), arc4random() % ((int) self.view.bounds.size.height-(int) self.target.bounds.size.height/2));
        self.ball.center = CGPointMake(self.view.bounds.size.width/2.0, self.view.bounds.size.height/2.0);
        [self startMoving];
        self.alreadyHasAlert = NO;
    }
   
}

-(void) startMoving {
    self.motionManager.deviceMotionUpdateInterval  = 0.001;
    [self.motionManager startDeviceMotionUpdatesToQueue:[NSOperationQueue mainQueue] withHandler:^(CMDeviceMotion *motion, NSError *error) {
        [self getMotionDataWithPitch:motion.attitude.pitch withRoll:motion.attitude.roll];
    }];

}

-(void) isBallInTarget {
    if (CGRectContainsPoint(self.ball.frame, self.target.center)) {
        [self.motionManager stopDeviceMotionUpdates];
        if (!self.alreadyHasAlert) {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Beep Beep!" message:@"You caught me..." delegate:self cancelButtonTitle:@"Play again" otherButtonTitles:nil];
            [alert show];
            self.alreadyHasAlert = YES;
        }
        
    }
}

-(void) makeRandomTarget {
    CGRect targetRect = CGRectMake(arc4random() % ((int) self.view.bounds.size.width - 75), arc4random() % ((int) self.view.bounds.size.height - 75), 75.0, 75.0);
    self.target = [[TargetView alloc] initWithFrame: targetRect];
    [self.view addSubview:self.target];
    [self.target setNeedsDisplay];
    
    
}

-(void) moveTarget {
    
    
    float randomTranslateValueX = 0;
    float randomTranslateValueY = 0;
    int inXDirection = arc4random()%2;
    if (inXDirection) {
        //move random x direction
        randomTranslateValueX = 50 - arc4random()%100;
        randomTranslateValueY = 0;
    } else {
        //move random y direction
        randomTranslateValueX = 0;
        randomTranslateValueY = 50 - arc4random()%100;
    }
    CGPoint translatePosition = CGPointMake(self.target.center.x + randomTranslateValueX, self.target.center.y +randomTranslateValueY);
    if ((CGRectContainsPoint(self.view.frame, translatePosition))) {
        self.target.center = translatePosition;
    } else {
        //[self moveTarget];
    }
    [self.target setNeedsDisplay];
}

-(void) resetBall {
    
    self.ball = [[BallView alloc] initWithFrame:CGRectMake(self.view.bounds.size.width/2.0-37.5, self.view.bounds.size.height/2.0-37.5, 75.0, 75.0)];
    [self.view addSubview:self.ball];
    [self.ball setNeedsDisplay];

}

- (void)viewDidLoad
{
    [super viewDidLoad];

}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}


@end
