//
//  TargetView.m
//  CoreMotionApp
//
//  Created by Ran Tao on 9.3.12.
//  Copyright (c) 2012 Nick. All rights reserved.
//

#import "TargetView.h"

@implementation TargetView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.backgroundColor = [UIColor lightGrayColor];
    }
    return self;
}


// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code

}


@end