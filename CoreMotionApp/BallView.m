//
//  BallView.m
//  CoreMotionApp
//
//  Created by Ran Tao on 9.3.12.
//  Copyright (c) 2012 Nick. All rights reserved.
//

#import "BallView.h"
#import <CoreGraphics/CoreGraphics.h>

@implementation BallView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.backgroundColor = [UIColor clearColor];
        //self.ballPosition = CGPointMake(self.bounds.size.width /2, self.bounds.size.height / 2);
    
    }
    return self;
}


// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
    CGContextRef context = UIGraphicsGetCurrentContext();
    [[UIColor cyanColor] set];
    CGPoint center = CGPointMake(self.bounds.size.width /2, self.bounds.size.height / 2);
    CGFloat radius = self.bounds.size.width/2.0;
    CGContextAddArc(context, center.x, center.y, radius, 0.0, 2*M_PI, 0);
    CGContextFillPath(context);
}


@end
