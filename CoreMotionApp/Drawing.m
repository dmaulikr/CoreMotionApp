//
//  Drawing.m
//  CoreGraphicsTest
//
//  Created by Mac Book on 8/21/12.
//  Copyright (c) 2012 Nick. All rights reserved.
//

#import "Drawing.h"
#import <CoreGraphics/CoreGraphics.h>

UIBezierPath* myPath;

@implementation Drawing

- (void)drawRect:(CGRect)rect {
    
    /*
    // CGContextRef presents the drawing environment
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGRect mainSquare = self.bounds;
  
    CGContextSaveGState(context);

    CGContextAddEllipseInRect(context, mainSquare);
    CGContextClip(context);
    
    // Define rects
    
    CGRect topLeft = CGRectMake(mainSquare.origin.x, mainSquare.origin.y, mainSquare.size.width / 1, mainSquare.size.height / 1);
    CGRect topRight = CGRectMake(mainSquare.size.width / 1, mainSquare.origin.y, mainSquare.size.width / 1, mainSquare.size.height / 1);
    CGRect bottomLeft = CGRectMake(mainSquare.origin.x, mainSquare.size.height / 1, mainSquare.size.width / 1, mainSquare.size.height / 1);
    CGRect bottomRight = CGRectMake(mainSquare.size.width / 1, mainSquare.size.height / 1, mainSquare.size.width / 1, mainSquare.size.height / 1);
    
    // Define colors
    UIColor *myColor = [UIColor colorWithRed: 180.0/255.0 green: 238.0/255.0 blue:180.0/255.0 alpha: 1.0];
    CGColorRef topLeftColor = [myColor CGColor];
    CGColorRef topRightColor = [myColor CGColor];
    CGColorRef bottomLeftColor = [myColor CGColor];
    CGColorRef bottomRightColor = [myColor CGColor];
    
    // Fill rects with colors
    CGContextSetFillColorWithColor(context, topLeftColor);
    CGContextFillRect(context, topLeft);
    
    CGContextSetFillColorWithColor(context, topRightColor);
    CGContextFillRect(context, topRight);
    
    CGContextSetFillColorWithColor(context, bottomLeftColor);
    CGContextFillRect(context, bottomLeft);
    
    CGContextSetFillColorWithColor(context, bottomRightColor);
    CGContextFillRect(context, bottomRight);
    
    
    // draw maze lines
    CGContextRestoreGState(context);
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    CGContextSetRGBStrokeColor(ctx, 0, 0, 1.0, 1);
    CGContextMoveToPoint(ctx, 10, 150);
    CGContextAddLineToPoint( ctx, 180, 320);
    CGContextStrokePath(ctx);
    [myPath addLineToPoint:CGPointMake(200, 300)];
    [myPath stroke];
    CGContextSetRGBStrokeColor(ctx, 0, 0, 1.0, 1);
    CGContextMoveToPoint(ctx, 60, 100);
    CGContextAddLineToPoint( ctx, 300, 120);
    CGContextStrokePath(ctx);
    [myPath addLineToPoint:CGPointMake(50, 50)];
    [myPath stroke];
    
    
    // draw game ball
    
    [self redrawBallPosition];
 
//    CGRect gameBall = self.bounds;
//    
//    CGContextSaveGState(context);
//    
//    CGContextAddEllipseInRect(context, gameBall);
//    CGContextClip(context);
//   
//    CGRect topLeft2 = CGRectMake(40, 40, 40, 40);
//    CGRect topRight2 = CGRectMake(40, 40, 40, 40);
//    CGRect bottomLeft2 = CGRectMake(40, 40, 40, 40);
//    CGRect bottomRight2 = CGRectMake(40, 40, 40, 40);
//
//    CGContextSetFillColorWithColor(context, [[UIColor blueColor] CGColor]);
//    CGContextFillRect(context, topLeft2);
//    
//    CGContextSetFillColorWithColor(context, [[UIColor blueColor] CGColor]);
//    CGContextFillRect(context, topRight2);
//    
//    CGContextSetFillColorWithColor(context, [[UIColor blueColor] CGColor]);
//    CGContextFillRect(context, bottomLeft2);
//    
//    CGContextSetFillColorWithColor(context, [[UIColor blueColor] CGColor]);
//    CGContextFillRect(context, bottomRight2);
//
//
//    CGContextAddEllipseInRect(context, rect);
//    CGContextAddEllipseInRect(context,
//                              CGRectMake(
//                                         rect.origin.x + 10,
//                                         rect.origin.y + 10,
//                                         rect.size.width - 20,
//                                         rect.size.height - 20));
//    CGContextSetFillColor(context, CGColorGetComponents([[UIColor blueColor] CGColor]));
//    CGContextEOFillPath(context);

    */
    
    
}

-(void) redrawBallPosition {
    
    
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect
 {
 // Drawing code
 }
 */




@end
