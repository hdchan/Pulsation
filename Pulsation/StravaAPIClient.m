//
//  StravaAPIClient.m
//  Sample Project
//
//  Created by Henry Chan on 7/14/15.
//  Copyright (c) 2015 Henry Chan. All rights reserved.
//

#import "StravaAPIClient.h"
#import "Constants.h"
#import <AFNetworking/AFNetworking.h>

@interface StravaAPIClient ()

@property (nonatomic, strong) AFHTTPSessionManager *manager;

@end

@implementation StravaAPIClient

+(instancetype)sharedClient
{
    static StravaAPIClient *_sharedClient = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedClient = [StravaAPIClient new];
    });
    
    return _sharedClient;
}

-(instancetype)init
{
    
    self = [super init];
    
    if (self) {
        
        _currentUserActivity = [NSMutableArray new];
           
    }
    
    return self;
    
}

-(AFHTTPSessionManager *)manager {
    
    if (!_manager) {
        _manager = [AFHTTPSessionManager manager];
        [_manager.requestSerializer setValue:[NSString stringWithFormat:@"Bearer %@", STRAVA_ACCESS_TOKEN] forHTTPHeaderField:@"Authorization"];
    }
    
    return _manager;
    
}

-(NSString *)urlWithResource:(NSString *)resourceString
{
    
    return [NSString stringWithFormat:@"%@%@", STRAVA_API_URL, resourceString];
    
}

-(void)getCurrentUserActivityWithCompletion:(void(^)(BOOL success))completion
{

    NSString *resource = @"/activities";
    
    [self.manager GET:[self urlWithResource:resource] parameters:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        
        
        NSMutableArray *activityArray = [NSMutableArray new];
        
        for (NSDictionary *activity in responseObject) {
            
            NSString *activityName = activity[@"name"];
            
            NSString *polylineSummary = activity[@"map"][@"summary_polyline"];
            
            NSNumber *activityID = activity[@"id"];
            
            StravaActivity *activity = [[StravaActivity alloc] initWithName:activityName];
            
            activity.polylineSummary = polylineSummary;
            activity.activityID = activityID;
            
            [activityArray addObject:activity];
            
        }
        
        self.currentUserActivity = activityArray;
        
        completion(YES);
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        
        completion(NO);
        
    }];
    
}

-(void)getActivityByID:(NSNumber*)activityID completion:(void(^)(NSDictionary* activity))completionBlock
{
    
    NSString *resource = [NSString stringWithFormat:@"/activities/%@", activityID];
    
    [self.manager GET:[self urlWithResource:resource] parameters:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        
        NSDictionary *activityDictionary = responseObject;
        
        completionBlock(activityDictionary);
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        
        completionBlock(nil);
        
    }];
    
}

-(void)getActivityStreamByID:(NSNumber*)activityID completion:(void(^)(NSArray *stream))completionBlock
{

    NSString *resource = [NSString stringWithFormat:@"/activities/%@/streams/heartrate,latlng", activityID];
    
    [self.manager GET:[self urlWithResource:resource] parameters:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        
        NSArray *activityStreamArray = responseObject;
        
        completionBlock(activityStreamArray);
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        
        completionBlock(nil);
        
    }];
    
}

@end
