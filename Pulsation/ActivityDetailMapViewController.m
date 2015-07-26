//
//  ActivityDetailMapViewController.m
//  Pulsation
//
//  Created by Henry Chan on 7/15/15.
//  Copyright (c) 2015 Henry Chan. All rights reserved.
//

#import "ActivityDetailMapViewController.h"
#import <QuartzCore/QuartzCore.h>
@import GoogleMaps;

@interface ActivityDetailMapViewController ()


@property (nonatomic, strong) IBOutlet GMSMapView *mapView;
@property (nonatomic, strong) StravaAPIClient *stravaClient;
@property (nonatomic, strong) GMSPolyline *currentPolyline;
@property (nonatomic, strong) NSArray *latLngStreamData;
@property (nonatomic, strong) NSArray *heartrateStreamData;
@property (nonatomic, strong) GMSMarker *currentStreamPositionMarker;
@property (weak, nonatomic) IBOutlet UILabel *heartrateLabel;
@property (weak, nonatomic) IBOutlet UISlider *streamSlider;


@end


@implementation ActivityDetailMapViewController

-(void)updateHeartrate:(NSUInteger)bpm {
    
}

- (StravaAPIClient *)stravaClient {
    
    if (!_stravaClient) {
        
        _stravaClient = [StravaAPIClient sharedClient];
        
    }
    
    return _stravaClient;
    
}

- (NSArray*)latLngStreamData {
    
    if (!_latLngStreamData) {
        
        for (NSDictionary *dic in self.activity.stream) {
            
            if ([dic[@"type"] isEqual:@"latlng"]) {
                
                self.latLngStreamData = dic[@"data"];
                
                
            }
            
        }
        
    }
    return _latLngStreamData;
}

- (NSArray*)heartrateStreamData {
    
    if (!_heartrateStreamData) {
        
        for (NSDictionary *dic in self.activity.stream) {
            
            if ([dic[@"type"] isEqual:@"heartrate"]) {
                
                self.heartrateStreamData = dic[@"data"];
            }
            
        }
        
    }
    return _heartrateStreamData;
    
}


- (GMSMarker*)currentStreamPositionMarker {
    
    if (!_currentStreamPositionMarker) {
        
        _currentStreamPositionMarker = [[GMSMarker alloc] init];
        _currentStreamPositionMarker.map = self.mapView;
        
        _currentStreamPositionMarker.groundAnchor = CGPointMake(0.5, 0.5);
        
    }
    return _currentStreamPositionMarker;
    
}



- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    GMSPath *path = [GMSPath pathFromEncodedPath:self.activity.polylineSummary];
    
    self.currentPolyline = [GMSPolyline polylineWithPath:path];
    
    self.currentPolyline.strokeColor = [UIColor redColor];
    
    
    GMSCoordinateBounds *coordBounds = [[GMSCoordinateBounds alloc] initWithPath:path];
    
    
    [self.mapView moveCamera:[GMSCameraUpdate fitBounds:coordBounds]];
    
    
    
    self.currentPolyline.map = self.mapView;
    
    
    
    if (self.activity.polyline) {
        
        [self updateMapWithFullPolyline:self.activity.polyline];
        
    } else {
        
        [self retrieveActivityData];
        
    }
    
    if (self.activity.stream) {
        
        [self setupStreamDataControls];
        
    } else {
        
        [self retrieveActivityStreamData];
        
    }
    
}



- (void)retrieveActivityData {
    
    [self.stravaClient getActivityByID:self.activity.activityID completion:^(NSDictionary *activity) {
        
        if (activity) {
           
            [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                
                NSString *fullPolyline = activity[@"map"][@"polyline"];
                
                self.activity.polyline = fullPolyline;
                
                [self updateMapWithFullPolyline:fullPolyline];
                
            }];
            
        } else {
            
            NSLog(@"No activity data!");
            
        }
        
    }];
    
}

- (void)retrieveActivityStreamData {
    
    [self.stravaClient getActivityStreamByID:self.activity.activityID completion:^(NSArray *stream) {
        
        if (stream) {
            
            self.activity.stream = stream;
            
            
            
            [self setupStreamDataControls];
            
        } else {
            
            NSLog(@"No Stream!");
            
        }
        
        
    }];
    
}

- (void)updateMapWithFullPolyline:(NSString*)polyline {
    
    self.currentPolyline.map = nil;
    
    
    GMSPath *path = [GMSPath pathFromEncodedPath:polyline];
    
    
    self.currentPolyline = [GMSPolyline polylineWithPath:path];
//    NSLog(@"%@",path.encodedPath);
    self.currentPolyline.strokeColor = [UIColor redColor];
    
    self.currentPolyline.map = self.mapView;
}




- (void)setupStreamDataControls {
    
    self.heartrateLabel.hidden = NO;
    self.streamSlider.hidden = NO;
    
    [self updateCurrentStreamPosition:0 cameraZoom:15];
    
//    self.userLocation = [[HRUserLocation alloc] initWithHeartrate: [self.heartrateStreamData[0] integerValue]];
    
//    self.currentStreamPositionMarker.icon = [self circleByApplyingAlpha:1.0];
    
    [self.streamSlider addTarget:self action:@selector(streamSliderDidChange:) forControlEvents:UIControlEventValueChanged];
    
    
}



- (IBAction)streamSliderDidChange:(UISlider*)sender {
    
    float streamDataCount = (self.latLngStreamData.count - 1);
    
    NSUInteger streamIndex = [[NSNumber numberWithFloat:(sender.value * streamDataCount)] integerValue];
    
    //NSLog(@"%lu",(unsigned long)streamIndex);

    [self updateCurrentStreamPosition:streamIndex cameraZoom:self.mapView.camera.zoom];
    
    
}

- (void)updateCurrentStreamPosition:(NSUInteger)index cameraZoom:(float)zoom{
    [self animate];
//    [self.timer invalidate];
//    
//    double heartrateBPS = [self.heartrateStreamData[index] doubleValue] / 60.0;
//    NSLog(@"%@",self.heartrateStreamData[index]);
//    NSLog(@"%f",heartrateBPS);
//    
//    NSTimeInterval timeInterval = 1.0/heartrateBPS;
//    NSLog(@"%f",timeInterval);
//    
//    self.timer = [NSTimer scheduledTimerWithTimeInterval:timeInterval target:self selector:@selector(pulsateWithTimeInterval:) userInfo:nil repeats:YES];
//    
    self.heartrateLabel.text = [NSString stringWithFormat: @"Heartrate: %@ BPM", self.heartrateStreamData[index]];
    
    
    double curLat = [self.latLngStreamData[index][0] doubleValue];
    double curLng = [self.latLngStreamData[index][1] doubleValue];
    
//    [self.userLocation updateHeartrate:[self.heartrateStreamData[index] integerValue]];
    
    self.currentStreamPositionMarker.position = CLLocationCoordinate2DMake(curLat, curLng);
    self.currentStreamPositionMarker.title = [NSString stringWithFormat: @"Heartrate: %@ BPM", self.heartrateStreamData[index]];
    
//    self.currentStreamPositionMarker.icon = self.userLocation.annotation;

    
    GMSCameraPosition *cameraPosition = [GMSCameraPosition cameraWithTarget:self.currentStreamPositionMarker.position zoom:zoom];

    [self.mapView animateToCameraPosition:cameraPosition];
    
    
}

- (UIImage *)circleByApplyingAlpha:(CGFloat) alpha {
    
    UIImage *opaqueCircle = nil;
    
    UIColor *color = [UIColor redColor];
    UIGraphicsBeginImageContextWithOptions(CGSizeMake(20.f, 20.f), NO, 0.0f);
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    
    CGContextSaveGState(ctx);
    
    CGContextSetBlendMode(ctx, kCGBlendModeMultiply);
    
    CGRect rect = CGRectMake(0, 0, 20, 20);
    CGContextSetAlpha(ctx, alpha);
    CGContextSetFillColorWithColor(ctx, color.CGColor);
    CGContextFillEllipseInRect(ctx, rect);
    
    CGContextRestoreGState(ctx);
    opaqueCircle = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    
    return opaqueCircle;
}
- (IBAction)animationButtonTapped:(id)sender {
    [self animate];
}

- (void) animate {
    
    
    GMSMarkerLayer *markerLayer = self.currentStreamPositionMarker.layer;
    
    [markerLayer removeAllAnimations];
    
    CABasicAnimation *fadeOutAnimation = [CABasicAnimation animationWithKeyPath:@"opacity"];
    fadeOutAnimation.duration = 1.0f;
    fadeOutAnimation.removedOnCompletion = NO;
    fadeOutAnimation.repeatCount = HUGE_VAL;
    fadeOutAnimation.fillMode = kCAFillModeForwards;
    fadeOutAnimation.toValue = [NSNumber numberWithFloat:0.0f];
    fadeOutAnimation.autoreverses = YES;
    

    [markerLayer addAnimation:fadeOutAnimation forKey:@"animateOpacity2"];
    
}

@end
