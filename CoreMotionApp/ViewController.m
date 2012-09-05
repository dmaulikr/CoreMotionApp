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


@interface ViewController () <GKSessionDelegate, GKPeerPickerControllerDelegate>
@property (nonatomic) CMMotionManager *motionManager;
@property (nonatomic) float currentPitch;
@property (nonatomic) float currentRoll;
@property (nonatomic, strong) CoyoteView* coyote;
@property (nonatomic, strong) CoyoteView* secondCoyote;
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
    if (!self.isSinglePlayer) {
        [self resetSecondCoyote];
        self.session = [[GKSession alloc] initWithSessionID:@"secretpassword" displayName:@"Ran" sessionMode:GKSessionModePeer];
        [self.session setDataReceiveHandler:self withContext:nil];
        self.session.delegate = self;
        self.session.available = YES;
    }
  
    self.motionManager = [[CMMotionManager alloc] init];
    [self startMoving];
    [NSTimer scheduledTimerWithTimeInterval:0.005 target:self selector:@selector(moveRoadrunner) userInfo:nil repeats:YES];
   
    }

-(void) viewDidLoad {
    UIButton *close = [UIButton buttonWithType:UIButtonTypeCustom];
    [close setFrame:CGRectMake(self.view.bounds.size.width - 50, 10, 40, 40)];
    [close setBackgroundImage:[UIImage imageNamed:@"close.png"] forState:UIControlStateNormal];
    close.backgroundColor = [UIColor clearColor];
    [close addTarget:self action:@selector(closeButtonPressed) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:close];
    
}

-(void)closeButtonPressed {
    [self dismissModalViewControllerAnimated:YES];
}

-(void)getMotionDataWithPitch:(float) pitch withRoll:(float) roll {
    self.currentPitch = pitch;
    self.currentRoll = roll;
    [self moveCoyote];
    [self sendMessage];
}

-(void)moveCoyote{
    
    float speedMultiplier = 5.0;
    // IN LANDSCAPE MODE //
    CGFloat viewWidth = self.view.bounds.size.width;
    CGFloat viewHeight = self.view.bounds.size.height;
    CGFloat coyoteWidth = self.coyote.bounds.size.width;
    CGFloat coyoteHeight = self.coyote.bounds.size.height;
    CGFloat coyoteX = self.coyote.center.x;
    CGFloat coyoteY = self.coyote.center.y;
    CGFloat pitch = self.currentPitch;
    CGFloat roll = self.currentRoll;
    
    if (((coyoteX+coyoteWidth/2.0 >= viewWidth) && pitch <0) || ((coyoteX-coyoteWidth/2.0 <= self.view.bounds.origin.x) && pitch >0)) {
        if (((coyoteY+coyoteHeight/2.0 >= viewHeight) && roll >0) || ((coyoteY-coyoteHeight/2.0 <= self.view.bounds.origin.y) && roll <0)) {
            self.coyote.center = CGPointMake(coyoteX, coyoteY);
        } else {
            self.coyote.center = CGPointMake(coyoteX, coyoteY+roll*speedMultiplier);
        }
    } else if (((coyoteY+coyoteHeight/2.0 >= viewHeight) && roll >0) || ((coyoteY-coyoteHeight/2.0 <= self.view.bounds.origin.y) && roll <0)) {
        if (((coyoteX+coyoteWidth/2.0 >= viewWidth) && pitch <0) || ((coyoteX-coyoteWidth/2.0 <= self.view.bounds.origin.x) && pitch >0)) {
            self.coyote.center = CGPointMake(coyoteX, coyoteY);
        } else {
            self.coyote.center = CGPointMake(coyoteX-pitch*speedMultiplier, coyoteY);
        }
    } else {
        self.coyote.center = CGPointMake(coyoteX-pitch*speedMultiplier, coyoteY+roll*speedMultiplier);
    }
    
    // IN PORTRAIT MODE //
//    if (((coyoteX+coyoteWidth/2.0 >= viewWidth) && roll >0) || ((coyoteX-coyoteWidth/2.0 <= self.view.bounds.origin.x) && roll <0)) {
//        if (((coyoteY+coyoteHeight/2.0 >= viewHeight) && pitch >0) || ((coyoteY-coyoteHeight/2.0 <= self.view.bounds.origin.y) && pitch <0)) {
//            self.coyote.center = CGPointMake(coyoteX, coyoteY);
//        } else {
//        self.coyote.center = CGPointMake(coyoteX, coyoteY+pitch*speedMultiplier);
//        }
//    } else if (((coyoteY+coyoteHeight/2.0 >= viewHeight) && pitch >0) || ((coyoteY-coyoteHeight/2.0 <= self.view.bounds.origin.y) && pitch <0)) {
//        if (((coyoteX+coyoteWidth/2.0 >= viewWidth) && roll >0) || ((coyoteX-coyoteWidth/2.0 <= self.view.bounds.origin.x) && roll <0)) {
//                self.coyote.center = CGPointMake(coyoteX, coyoteY);
//        } else {
//        self.coyote.center = CGPointMake(coyoteX+roll*speedMultiplier, coyoteY);
//        }
//    } else {
//        self.coyote.center = CGPointMake(coyoteX+roll*speedMultiplier, coyoteY+pitch*speedMultiplier);
//    }
    [self.coyote setNeedsDisplay];
    [self didCoyoteCatchRoadrunner];

}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0)
    {
        self.roadrunner.center = CGPointMake(arc4random() % ((int) self.view.bounds.size.width - (int) self.roadrunner.bounds.size.width/2), arc4random() % ((int) self.view.bounds.size.height-(int) self.roadrunner.bounds.size.height/2));
        self.coyote.center = CGPointMake(self.view.bounds.size.width/2.0, self.view.bounds.size.height/2.0);
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
    if (CGRectContainsPoint(self.coyote.frame, self.roadrunner.center)) {
        [self.motionManager stopDeviceMotionUpdates];
        if (!self.alreadyHasAlert) {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Meep Meep!" message:@"You caught me..." delegate:self cancelButtonTitle:@"Play again" otherButtonTitles:nil];
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
        if ((CGRectContainsPoint(self.view.frame, translatePosition)) && !CGRectContainsPoint(CGRectMake(self.coyote.frame.origin.x - self.coyote.frame.size.width, self.coyote.frame.origin.y - self.coyote.frame.size.height, self.coyote.frame.size.width *2.0, self.coyote.frame.size.height*2.0), translatePosition)) {
            self.roadrunner.center = translatePosition;
                        
        } else {
            //[self moveTarget];
        }
        [self.roadrunner setNeedsDisplay];

    }
}

-(void) resetCoyote {    
    self.coyote = [[CoyoteView alloc] initWithFrame:CGRectMake(self.view.bounds.size.width/4.0*3.0-37.5, self.view.bounds.size.height/4.0-37.5, 75.0, 75.0)];
    [self.view addSubview:self.coyote];
    [self.coyote setNeedsDisplay];
}

-(void) resetSecondCoyote {
    self.secondCoyote = [[CoyoteView alloc] initWithFrame:CGRectMake(self.view.bounds.size.width/4.0-37.5, self.view.bounds.size.height/4.0-37.5, 75.0, 75.0)];
    [self.view addSubview:self.secondCoyote];
    [self.secondCoyote setNeedsDisplay];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

-(void)session:(GKSession *)session peer:(NSString *)peerID didChangeState:(GKPeerConnectionState)state {
    if (state == GKPeerStateAvailable) {
//        GKPeerPickerController *pickPlayer = [GKPeerPickerController new];
//        pickPlayer.delegate = self;
//        [pickPlayer show];
       [session connectToPeer:peerID withTimeout:3];
    } else if (state == GKPeerStateConnected ) {
        session.available = NO;
    }
}

-(void)peerPickerController:(GKPeerPickerController *)picker didConnectPeer:(NSString *)peerID toSession:(GKSession *)session {
    NSLog(@"we got the peer connected");
}

-(void)session:(GKSession *)session didReceiveConnectionRequestFromPeer:(NSString *)peerID {
    [[[UIAlertView alloc] initWithTitle:@"Ready to play?" message:@"coyote challenger found!" delegate:self cancelButtonTitle:@"Accept" otherButtonTitles:nil] show];
    [self.session acceptConnectionFromPeer:peerID error:nil];
    session.available = NO;
    
}

-(void)sendMessage {
    //NSString *roadrunnerPosition = NSStringFromCGPoint(self.roadrunner.center);
    NSString *coyotePosition = NSStringFromCGPoint(self.coyote.center);
    //NSArray *positions = [[NSArray alloc] initWithObjects:roadrunnerPosition, coyotePosition, nil];
    //NSData *payload = [NSKeyedArchiver archivedDataWithRootObject:positions];
    NSData* payload = [coyotePosition dataUsingEncoding:NSUTF8StringEncoding];
    [self.session sendDataToAllPeers:payload withDataMode:GKSendDataReliable error:nil];
    
}


-(void)receiveData:(NSData *)data fromPeer:(NSString *)peer inSession: (GKSession *)session context:(void *)context {
    NSLog(@"received data: %@", data);
    //NSArray *positions = [NSKeyedUnarchiver unarchiveObjectWithData:data];
    //self.roadrunner.center = CGPointFromString([[NSString alloc] initWithFormat:[positions objectAtIndex:0]]);
    //if (!self.isSinglePlayer) {
      //  self.secondCoyote.center = CGPointFromString([[NSString alloc] initWithFormat:[positions objectAtIndex:1]]);
    //}
    self.secondCoyote.center = CGPointFromString([[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding]);
    
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationLandscapeLeft);
}
@end
