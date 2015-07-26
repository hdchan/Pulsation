//
//  HRUserLocation.m
//  Pulsation
//
//  Created by Henry Chan on 7/17/15.
//  Copyright (c) 2015 Henry Chan. All rights reserved.
//

#import "HRUserLocation.h"
#import "UIImage+Circle.h"

@interface HRUserLocation ()

@property (nonatomic) NSUInteger currentHeartRate;

@end

@implementation HRUserLocation

- (instancetype) initWithHeartrate:(NSUInteger)bpm {
    
    if (self = [super init]) {
        
        _currentHeartRate = bpm;
        _annotation = [UIImage circleWithColor:[UIColor redColor]];
        
    }
    
    return self;
    
}

- (instancetype) init {
    
    return [self initWithHeartrate:0];
    
}

- (void) updateHeartrate:(NSUInteger)bpm {
    
    self.currentHeartRate = bpm;
    NSLog(@"updating image");
    
    if (bpm % 2 == 0) {
        NSLog(@"blue");
        self.annotation = [UIImage circleWithColor:[UIColor blueColor]];
    } else if (bpm %3 == 0) {
        NSLog(@"red");
        self.annotation = [UIImage circleWithColor:[UIColor redColor]];
    } else if (bpm % 5 == 0) {
        NSLog(@"green");
        self.annotation = [UIImage circleWithColor:[UIColor greenColor]];
    } else {
        NSLog(@"yellow");
        self.annotation = [UIImage circleWithColor:[UIColor yellowColor]];
    }
    
    
}

@end
