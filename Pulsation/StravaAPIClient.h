//
//  StravaAPIClient.h
//  Sample Project
//
//  Created by Henry Chan on 7/14/15.
//  Copyright (c) 2015 Henry Chan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "StravaActivity.h"

@interface StravaAPIClient : NSObject

@property (nonatomic, strong) NSMutableArray *currentUserActivity;

+(instancetype)sharedClient;
-(void)getCurrentUserActivityWithCompletion:(void(^)(BOOL success))completion;
-(void)getActivityByID:(NSNumber*)activityID completion:(void(^)(NSDictionary* activity))completionBlock;
-(void)getActivityStreamByID:(NSNumber*)activityID completion:(void(^)(NSArray *stream))completionBlock;

@end
