//
//  Drawing.h
//  CoreGraphicsTest
//
//  Created by Mac Book on 8/21/12.
//  Copyright (c) 2012 Nick. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface Drawing : UIView {
    UIBezierPath * bezierPath;
}
@property(nonatomic,retain) UIBezierPath * bezierPath;

@end
