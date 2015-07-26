//
//  HRUserLocation.h
//  Pulsation
//
//  Created by Henry Chan on 7/17/15.
//  Copyright (c) 2015 Henry Chan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>



@interface HRUserLocation : NSObject

@property (nonatomic, strong) UIImage *annotation;

- (void) updateHeartrate:(NSUInteger)bpm;
- (instancetype) initWithHeartrate:(NSUInteger)bpm;

@end
