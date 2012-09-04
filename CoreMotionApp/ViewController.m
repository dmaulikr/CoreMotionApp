//
//  ViewController.m
//  CoreMotionApp
//
//  Created by Mac Book on 9/3/12.
//  Copyright (c) 2012 Nick. All rights reserved.
//

#import "ViewController.h"
#import "Drawing.h"
#import "CoyoteView.h"
#import "RoadrunnerView.h"
#import <QuartzCore/QuartzCore.h>
#import <CoreMotion/CoreMotion.h>
#import <GameKit/GameKit.h>


@interface ViewController () <GKSessionDelegate>
@property (nonatomic) CMMotionManager *motionManager;
@property (nonatomic) float currentPitch;
@property (nonatomic) float currentRoll;
@property (nonatomic, strong) CoyoteView* firstCoyote;
@property (nonatomic, strong) RoadrunnerView* roadrunner;
@property (nonatomic) BOOL alreadyHasAlert;
@property (nonatomic) BOOL isCaught;
@property (nonatomic, strong) GKSession* session;
@end


@implementation ViewController

-(void)loadView {
    [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:YES];
    
    Drawing *view = [[Drawing alloc] initWithFrame:[[UIScreen mainScreen] applicationFrame]];
    self.view = view;
    [view setBackgroundColor:[UIColor whiteColor]];
    
    [self makeRandomRoadrunner];
    [self resetCoyote];
       
    self.motionManager = [[CMMotionManager alloc] init];
    [self startMoving];
    [NSTimer scheduledTimerWithTimeInterval:0.005 target:self selector:@selector(moveRoadrunner) userInfo:nil repeats:YES];

    self.session = [[GKSession alloc] initWithSessionID:@"secretpassword" displayName:@"Ran" sessionMode:GKSessionModePeer];
    self.session.delegate = self;
    self.session.available = YES;
    }

-(void)getMotionDataWithPitch:(float) pitch withRoll:(float) roll {
    self.currentPitch = pitch;
    self.currentRoll = roll;
    [self moveCoyote];

}

-(void)moveCoyote{
    
    float speedMultiplier = 5.0;
    
    // NEED TO FIGURE OUT WHY THE BALL STILL ESCAPES AT EACH OF THE FOUR CORNERS //
    if (((self.firstCoyote.center.x+self.firstCoyote.bounds.size.width/2.0 >= self.view.bounds.size.width) && self.currentRoll >0) || ((self.firstCoyote.center.x-self.firstCoyote.bounds.size.width/2.0 <= self.view.bounds.origin.x) && self.currentRoll <0)) {
        if (((self.firstCoyote.center.y+self.firstCoyote.bounds.size.height/2.0 >= self.view.bounds.size.height) && self.currentPitch >0) || ((self.firstCoyote.center.y-self.firstCoyote.bounds.size.height/2.0 <= self.view.bounds.origin.y) && self.currentPitch <0)) {
            self.firstCoyote.center = CGPointMake(self.firstCoyote.center.x, self.firstCoyote.center.y);
        } else {
        self.firstCoyote.center = CGPointMake(self.firstCoyote.center.x, self.firstCoyote.center.y+self.currentPitch*speedMultiplier);
        }
    } else if (((self.firstCoyote.center.y+self.firstCoyote.bounds.size.height/2.0 >= self.view.bounds.size.height) && self.currentPitch >0) || ((self.firstCoyote.center.y-self.firstCoyote.bounds.size.height/2.0 <= self.view.bounds.origin.y) && self.currentPitch <0)) {
        if (((self.firstCoyote.center.x+self.firstCoyote.bounds.size.width/2.0 >= self.view.bounds.size.width) && self.currentRoll >0) || ((self.firstCoyote.center.x-self.firstCoyote.bounds.size.width/2.0 <= self.view.bounds.origin.x) && self.currentRoll <0)) {
                self.firstCoyote.center = CGPointMake(self.firstCoyote.center.x, self.firstCoyote.center.y);
        } else {
        self.firstCoyote.center = CGPointMake(self.firstCoyote.center.x+self.currentRoll*speedMultiplier, self.firstCoyote.center.y);
        }
    } else {
        self.firstCoyote.center = CGPointMake(self.firstCoyote.center.x+self.currentRoll*speedMultiplier, self.firstCoyote.center.y+self.currentPitch*speedMultiplier);
    }
    [self.firstCoyote setNeedsDisplay];
    [self didCoyoteCatchRoadrunner];

}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0)
    {
        self.roadrunner.center = CGPointMake(arc4random() % ((int) self.view.bounds.size.width - (int) self.roadrunner.bounds.size.width/2), arc4random() % ((int) self.view.bounds.size.height-(int) self.roadrunner.bounds.size.height/2));
        self.firstCoyote.center = CGPointMake(self.view.bounds.size.width/2.0, self.view.bounds.size.height/2.0);
        [self startMoving];
        self.alreadyHasAlert = NO;
        self.isCaught = NO;
    }
   
}

-(void) startMoving {
    self.motionManager.deviceMotionUpdateInterval  = 0.001;
    [self.motionManager startDeviceMotionUpdatesToQueue:[NSOperationQueue mainQueue] withHandler:^(CMDeviceMotion *motion, NSError *error) {
        [self getMotionDataWithPitch:motion.attitude.pitch withRoll:motion.attitude.roll];
    }];

}

-(void) didCoyoteCatchRoadrunner {
    if (CGRectContainsPoint(self.firstCoyote.frame, self.roadrunner.center)) {
        [self.motionManager stopDeviceMotionUpdates];
        if (!self.alreadyHasAlert) {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Beep Beep!" message:@"You caught me..." delegate:self cancelButtonTitle:@"Play again" otherButtonTitles:nil];
            [alert show];
            self.alreadyHasAlert = YES;
            self.isCaught = YES;
        }
        
    }
}

-(void) makeRandomRoadrunner {
    CGRect targetRect = CGRectMake(arc4random() % ((int) self.view.bounds.size.width - 75), arc4random() % ((int) self.view.bounds.size.height - 75), 75.0, 75.0);
    self.roadrunner = [[RoadrunnerView alloc] initWithFrame: targetRect];
    [self.view addSubview:self.roadrunner];
    [self.roadrunner setNeedsDisplay];
    
    
}

-(void) moveRoadrunner {
    
    if (!self.isCaught) {
        float randomTranslateValueX = 0;
        float randomTranslateValueY = 0;
        int inXDirection = arc4random()%2;
        int rand = arc4random()%100;
        if (inXDirection) {
            //move random x direction
            randomTranslateValueX = 50 - rand;
            randomTranslateValueY = 0;
        } else {
            //move random y direction
            randomTranslateValueX = 0;
            randomTranslateValueY = 50 - rand;
        }
        CGPoint translatePosition = CGPointMake(self.roadrunner.center.x + randomTranslateValueX, self.roadrunner.center.y +randomTranslateValueY);
        if ((CGRectContainsPoint(self.view.frame, translatePosition)) && !CGRectContainsPoint(CGRectMake(self.firstCoyote.frame.origin.x - self.firstCoyote.frame.size.width, self.firstCoyote.frame.origin.y - self.firstCoyote.frame.size.height, self.firstCoyote.frame.size.width *2.0, self.firstCoyote.frame.size.height*2.0), translatePosition)) {
            self.roadrunner.center = translatePosition;
                        
        } else {
            //[self moveTarget];
        }
        [self.roadrunner setNeedsDisplay];

    }
}

-(void) resetCoyote {
    
    self.firstCoyote = [[CoyoteView alloc] initWithFrame:CGRectMake(self.view.bounds.size.width/2.0-37.5, self.view.bounds.size.height/2.0-37.5, 75.0, 75.0)];
    [self.view addSubview:self.firstCoyote];
    [self.firstCoyote setNeedsDisplay];

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

-(void)session:(GKSession *)session peer:(NSString *)peerID didChangeState:(GKPeerConnectionState)state {
    if (state == GKPeerStateAvailable) {
        [session connectToPeer:peerID withTimeout:3];
    } else if (state == GKPeerStateConnected ) {
        session.available = NO;
    }
}

-(void)session:(GKSession *)session didReceiveConnectionRequestFromPeer:(NSString *)peerID {
    [self.session acceptConnectionFromPeer:peerID error:nil];
    session.available = NO;
    
}

-(void)receiveData:(NSData *)data fromPeer:(NSString *)peer inSession: (GKSession *)session context:(void *)context {
    NSString* message = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    [[[UIAlertView alloc] initWithTitle:peer message:message delegate:self cancelButtonTitle:@"Accept" otherButtonTitles:nil] show];
}



@end
