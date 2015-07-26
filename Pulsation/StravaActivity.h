//
//  StravaActivity.h
//  Sample Project
//
//  Created by Henry Chan on 7/14/15.
//  Copyright (c) 2015 Henry Chan. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface StravaActivity : NSObject

@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *polylineSummary;
@property (nonatomic, strong) NSString *polyline;
@property (nonatomic, strong) NSNumber *activityID;
@property (nonatomic, strong) NSArray *stream;


-(instancetype)initWithName:(NSString *)name;

@end
