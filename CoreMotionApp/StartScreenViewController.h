//
//  StartScreenViewController.h
//  CoreMotionApp
//
//  Created by Ran Tao on 9.5.12.
//  Copyright (c) 2012 Nick. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface StartScreenViewController : UIViewController
@property (weak, nonatomic) IBOutlet UIImageView *BackgroundImageView;
- (IBAction)singlePlayerButtonPressed:(UIButton *)sender;
- (IBAction)twoPlayerButtonPressed:(UIButton *)sender;

@end
