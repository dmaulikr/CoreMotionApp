//
//  StartScreenViewController.m
//  CoreMotionApp
//
//  Created by Ran Tao on 9.5.12.
//  Copyright (c) 2012 Nick. All rights reserved.
//

#import "StartScreenViewController.h"
#import "ViewController.h"

@interface StartScreenViewController ()

@end

@implementation StartScreenViewController
@synthesize BackgroundImageView;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
      
        
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)viewDidUnload
{
    [self setBackgroundImageView:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationLandscapeLeft);
}

- (IBAction)singlePlayerButtonPressed:(UIButton *)sender {
    ViewController *gameView = [ViewController new];
    gameView.isSinglePlayer = YES;
    [self presentModalViewController:gameView animated:YES];
}

- (IBAction)twoPlayerButtonPressed:(UIButton *)sender {
    ViewController *gameView = [ViewController new];
    gameView.isSinglePlayer = NO;
    [self presentModalViewController:gameView animated:YES];
}
@end
