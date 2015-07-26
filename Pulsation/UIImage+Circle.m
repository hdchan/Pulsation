//
//  UIImage+Circles.m
//  Pulsation
//
//  Created by Henry Chan on 7/17/15.
//  Copyright (c) 2015 Henry Chan. All rights reserved.
//

#import "UIImage+Circle.h"

@implementation UIImage (Circle)

+ (UIImage *) circleWithColor:(UIColor*)color {
    
    static UIImage *circle = nil;
    static dispatch_once_t onceToken;
    //dispatch_once(&onceToken, ^{
        UIGraphicsBeginImageContextWithOptions(CGSizeMake(20.f, 20.f), NO, 0.0f);
        CGContextRef ctx = UIGraphicsGetCurrentContext();
        CGContextSaveGState(ctx);
        
        CGRect rect = CGRectMake(0, 0, 20, 20);
    NSLog(@"taking a new color:%@",color);
        CGContextSetFillColorWithColor(ctx, color.CGColor);
        CGContextFillEllipseInRect(ctx, rect);
        
        CGContextRestoreGState(ctx);
        circle = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        
    //});
    return circle;
}

@end
